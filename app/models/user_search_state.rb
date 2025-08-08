class UserSearchState < ApplicationRecord
  serialize :current_filter_indices, coder: JSON, type: Array
  serialize :search_order, coder: JSON, type: Array  
  serialize :search_direction, coder: JSON, type: Array
  serialize :search_indices, coder: JSON, type: Hash

  def self.save_search_state(user_id, table_name, search_controller)
    # Re-enabled with ActiveRecord session store - should handle complex data better
    Rails.logger.debug("🔍 UserSearchState.save_search_state: Saving search state for user #{user_id}, table #{table_name}")
    
    begin
      # Deactivate any existing search state for this user and table
      where(user_id: user_id, table_name: table_name, active: true).update_all(active: false)
      
      # Extract safe data from SearchController
      current_filter_indices = safe_extract_array(search_controller.instance_variable_get(:@current_filter_indices))
      search_order = safe_extract_array(search_controller.instance_variable_get(:@search_order))
      search_direction = safe_extract_array(search_controller.instance_variable_get(:@search_direction))
      search_indices = safe_extract_hash(search_controller.instance_variable_get(:@search_indices))
      
      # Create new search state record
      user_search_state = create!(
        user_id: user_id,
        table_name: table_name,
        current_filter_indices: current_filter_indices,
        search_order: search_order,
        search_direction: search_direction,
        search_indices: search_indices,
        active: true
      )
      
      Rails.logger.debug("✅ UserSearchState.save_search_state: Successfully saved search state with ID #{user_search_state.id}")
      user_search_state
    rescue => e
      Rails.logger.error("❌ UserSearchState.save_search_state: Error saving search state: #{e.message}")
      nil
    end
  end

  def self.load_search_state(user_id, table_name)
    find_by(user_id: user_id, table_name: table_name, active: true)
  end

  def restore_to_controller(search_controller)
    search_controller.instance_variable_set(:@current_filter_indices, current_filter_indices || [])
    search_controller.instance_variable_set(:@search_order, search_order || [])
    search_controller.instance_variable_set(:@search_direction, search_direction || {})
    search_controller.instance_variable_set(:@search_indices, search_indices || {})
  end
  
  private
  
  def self.safe_extract_array(data)
    return [] unless data.is_a?(Array)
    # Only keep very simple types to avoid any circular references
    result = []
    data.each do |item|
      if item.is_a?(String) || item.is_a?(Integer) || item.is_a?(Float) || item.nil?
        result << item
      elsif item.is_a?(TrueClass) || item.is_a?(FalseClass)
        result << item
      else
        # Skip any complex objects that could contain circular references
        Rails.logger.debug("🚫 Skipping complex object in array: #{item.class}")
      end
    end
    result
  rescue => e
    Rails.logger.error("❌ Error in safe_extract_array: #{e.message}")
    []
  end
  
  def self.safe_extract_hash(data)
    return {} unless data.is_a?(Hash)
    result = {}
    data.each do |key, value|
      # Only store if both key and value are simple types
      if simple_type?(key) && simple_type?(value)
        result[key] = value
      else
        Rails.logger.debug("🚫 Skipping complex hash entry: #{key.class} => #{value.class}")
      end
    end
    result
  rescue => e
    Rails.logger.error("❌ Error in safe_extract_hash: #{e.message}")
    {}
  end
  
  def self.simple_type?(obj)
    obj.is_a?(String) || obj.is_a?(Integer) || obj.is_a?(Float) || obj.is_a?(TrueClass) || obj.is_a?(FalseClass) || obj.nil?
  end
end
