module SearchTableBroadcastHelper
  def broadcast_search_table_update(table_name, updated_object, attribute_names, ids, search_ctls)
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
      begin
        updated_objects = search_ctl.GetUpdateObjects(table_name, attribute_names, ids)
        
        broadcast_data[:search_controllers][search_table_name] = {
          updated_objects: updated_objects.map do |row|
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
end
