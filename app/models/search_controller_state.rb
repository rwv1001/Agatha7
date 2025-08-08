class SearchControllerState < ApplicationRecord
  # Store serialized SearchController state in database instead of session
  
  validates :user_id, presence: true
  validates :table_name, presence: true
  validates_uniqueness_of :table_name, scope: :user_id
  
  # JSON serialization for complex SearchController data
  serialize :controller_data, JSON
  serialize :filters_data, JSON
  serialize :search_direction, JSON
  serialize :search_order, JSON
  
  class << self
    def save_search_controller(user_id, table_name, search_controller)
      return unless user_id && table_name && search_controller
      
      begin
        # Extract essential data from SearchController
        controller_data = {
          current_filter_indices: search_controller.current_filter_indices,
          possible_filter_indices: search_controller.possible_filter_indices,
          search_indices: search_controller.search_indices,
          limit_offset: search_controller.limit_offset,
          limit_length: search_controller.limit_length,
          order_updated: search_controller.order_updated,
          user_where_str: search_controller.user_where_str
        }
        
        # Extract search direction and order
        search_direction = search_controller.search_direction || []
        search_order = search_controller.search_order || []
        
        # Extract filters data (simplified)
        filters_data = {
          extended_filters_count: search_controller.extended_filters&.length || 0,
          external_filters_count: search_controller.external_filters&.length || 0,
          foreign_filters_count: search_controller.foreign_filters&.length || 0
        }
        
        # Save or update record
        state_record = find_or_initialize_by(user_id: user_id, table_name: table_name)
        state_record.update!(
          controller_data: controller_data,
          filters_data: filters_data,
          search_direction: search_direction,
          search_order: search_order,
          last_accessed: Time.current
        )
        
        Rails.logger.info "💾 Saved SearchController state for user #{user_id}, table #{table_name}"
        true
      rescue => e
        Rails.logger.error "❌ Failed to save SearchController state: #{e.message}"
        false
      end
    end
    
    def load_search_controller_data(user_id, table_name)
      return nil unless user_id && table_name
      
      begin
        state_record = find_by(user_id: user_id, table_name: table_name)
        if state_record
          # Update last accessed time
          state_record.update_column(:last_accessed, Time.current)
          
          Rails.logger.info "🔄 Loaded SearchController state for user #{user_id}, table #{table_name}"
          {
            controller_data: state_record.controller_data || {},
            filters_data: state_record.filters_data || {},
            search_direction: state_record.search_direction || [],
            search_order: state_record.search_order || []
          }
        else
          Rails.logger.info "🔍 No saved state found for user #{user_id}, table #{table_name}"
          nil
        end
      rescue => e
        Rails.logger.error "❌ Failed to load SearchController state: #{e.message}"
        nil
      end
    end
    
    def cleanup_old_states(days_old = 30)
      # Clean up old unused states
      cutoff_date = days_old.days.ago
      deleted_count = where('last_accessed < ?', cutoff_date).delete_all
      Rails.logger.info "🧹 Cleaned up #{deleted_count} old SearchController states"
      deleted_count
    end
  end
  
  def age_in_days
    return nil unless last_accessed
    ((Time.current - last_accessed) / 1.day).round(1)
  end
end
