module SearchTableBroadcastHelper
  include ExtendedFilterDependencyHelper
  
  def broadcast_search_table_update(table_name, updated_object, attribute_names, ids, search_ctls)
    Rails.logger.info("=== ExtendedFilter Debug: Starting broadcast for #{table_name} ===")
    Rails.logger.info("Attribute names: #{attribute_names}")
    Rails.logger.info("IDs: #{ids}")
    
    # Get all active user sessions who might be viewing search tables
    broadcast_data = {
      action: 'update_search_rows',
      edited_table_name: table_name,
      attribute_names: attribute_names,
      ids: ids,
      search_controllers: {}
    }

    # Process each search controller and its updated objects
    search_ctls.each do |search_table_name, search_ctl|
      Rails.logger.info("Processing search table: #{search_table_name}")
      begin
        # Standard table relationship updates (existing functionality)
        updated_objects = search_ctl.GetUpdateObjects(table_name, attribute_names, ids)
        Rails.logger.info("Standard updates found: #{updated_objects.length} objects")
        
        # Check if this table needs ExtendedFilter updates due to dependencies
        extended_filter_updates = []
        if should_update_extended_filters?(table_name, search_table_name)
          affected_filters = get_affected_extended_filters(table_name, search_table_name)
          Rails.logger.info("ExtendedFilter update needed for #{search_table_name} due to #{table_name} change. Affected filters: #{affected_filters}")
          
          # For ExtendedFilter dependencies, we need to get ALL currently visible rows
          # because ExtendedFilter subqueries can affect any row that references the changed data
          extended_filter_updates = get_all_visible_rows_for_extended_filter_update(search_ctl)
          Rails.logger.info("Retrieved #{extended_filter_updates.length} rows for ExtendedFilter update")
        else
          Rails.logger.info("No ExtendedFilter update needed for #{search_table_name} due to #{table_name} change")
        end
        
        # Combine standard updates with ExtendedFilter updates, but prioritize ExtendedFilter updates
        if extended_filter_updates.any?
          # For ExtendedFilter updates, use all visible rows instead of just the detected ones
          all_updated_objects = extended_filter_updates
          Rails.logger.info("Using ExtendedFilter updates: #{all_updated_objects.length} objects")
        else
          # For standard updates, use the normal detection
          all_updated_objects = updated_objects
          Rails.logger.info("Using standard updates: #{all_updated_objects.length} objects")
        end
        
        broadcast_data[:search_controllers][search_table_name] = {
          updated_objects: all_updated_objects.map do |row|
            {
              id: row.id,
              html: ApplicationController.render(
                partial: 'shared/search_results_row_button', 
                locals: { search_results_row_button: row }
              ),
              short_field: search_ctl.GetShortField(row.id)
            }
          end
        }

        # Add information about affected ExtendedFilters for precise cell highlighting
        if extended_filter_updates.any?
          affected_filters = get_affected_extended_filters(table_name, search_table_name)
          broadcast_data[:search_controllers][search_table_name][:affected_extended_filters] = affected_filters
          broadcast_data[:search_controllers][search_table_name][:update_type] = 'extended_filter'
        else
          broadcast_data[:search_controllers][search_table_name][:update_type] = 'standard'
        end

        # If this is the table being edited, include new rows data
        if search_table_name == table_name
          select_string = search_ctl.get_sql_id_string(ids)
          # Use eval cautiously - this follows the existing pattern in the codebase
          new_rows = eval("#{search_table_name}.find_by_sql(\"#{select_string}\")")
          
          broadcast_data[:search_controllers][search_table_name][:new_rows] = new_rows.map do |new_row|
            {
              id: new_row.id,
              html: ApplicationController.render(
                partial: 'shared/search_results_row_button', 
                locals: { search_results_row_button: new_row }
              ),
              short_field: search_ctl.GetShortField(new_row.id)
            }
          end
          
          broadcast_data[:search_controllers][search_table_name][:results_table_name] = "search_results_table_#{search_table_name}"
          broadcast_data[:search_controllers][search_table_name][:current_filter_name] = "current_filters_#{search_table_name}"
        end
      rescue => e
        Rails.logger.error "Error processing search table update for #{search_table_name}: #{e.message}"
        next
      end
    end

    # Broadcast to all users
    ActionCable.server.broadcast("search_table_updates", broadcast_data)
    
    Rails.logger.info("Broadcast search table update: #{broadcast_data[:action]} for #{table_name}")
  end

  private

  def get_all_visible_rows_for_extended_filter_update(search_ctl)
    return [] unless search_ctl.respond_to?(:get_sql_string) && search_ctl.instance_variable_get(:@active)
    
    begin
      # Get the current SQL string for all visible rows
      search_ctl.get_sql_string
      sql_string = search_ctl.instance_variable_get(:@sql_str)
      table_name = search_ctl.table_name
      
      return [] if sql_string.blank? || table_name.blank?
      
      # Execute the query to get all visible rows
      Rails.logger.info("ExtendedFilter SQL query: #{sql_string}")
      visible_rows = eval("#{table_name}.find_by_sql(\"#{sql_string}\")")
      
      Rails.logger.info("Retrieved #{visible_rows.length} rows for ExtendedFilter update in #{table_name}")
      return visible_rows
    rescue => e
      Rails.logger.error("Error getting ExtendedFilter affected rows: #{e.message}")
      Rails.logger.error("Backtrace: #{e.backtrace.first(5).join('\n')}")
      return []
    end
  end

  def get_extended_filter_affected_rows(search_ctl, affected_filters, changed_ids)
    # This method is now deprecated in favor of get_all_visible_rows_for_extended_filter_update
    # but keeping it for backward compatibility
    return get_all_visible_rows_for_extended_filter_update(search_ctl)
  end
end
