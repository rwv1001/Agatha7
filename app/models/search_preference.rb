class SearchPreference < ApplicationRecord
  belongs_to :user, optional: true

  validates :table_name, presence: true
  validates :preference_key, presence: true

  # Store search direction as JSON
  def search_direction=(direction_array)
    self.preference_value = direction_array.to_json
  end

  def search_direction
    return [] if preference_value.blank?
    JSON.parse(preference_value).map(&:to_sym)
  rescue JSON::ParserError
    []
  end

  # Class methods for easy access
  def self.save_search_direction(user_id, table_name, direction_array)
    Rails.logger.debug "🔧 SearchPreference.save_search_direction called with: user_id=#{user_id}, table_name=#{table_name}, direction=#{direction_array.inspect}"

    preference = find_or_initialize_by(
      user_id: user_id,
      table_name: table_name,
      preference_key: "search_direction"
    )

    Rails.logger.debug "🔧 Found/created preference: id=#{preference.id}, new_record=#{preference.new_record?}"

    preference.search_direction = direction_array

    Rails.logger.debug "🔧 About to save preference with value: #{preference.preference_value}"

    if preference.save!
      Rails.logger.debug "💾 ********* SUCCESS! Saved search direction to database at #{Time.now}: #{table_name} => #{direction_array}"
      true
    else
      Rails.logger.error "❌ Failed to save preference: #{preference.errors.full_messages}"
      false
    end
  rescue => e
    Rails.logger.error "❌ Exception in save_search_direction: #{e.message}"
    Rails.logger.error "❌ Backtrace: #{e.backtrace.first(5).join('\n')}"
    raise e
  end

  def self.load_search_direction(user_id, table_name)
    preference = find_by(
      user_id: user_id,
      table_name: table_name,
      preference_key: "search_direction"
    )
    if preference
      direction = preference.search_direction
      Rails.logger.debug "🔄 Loaded search direction from database: #{table_name} => #{direction}"
      direction
    else
      Rails.logger.debug "🆕 No saved search direction found for: #{table_name}"
      nil
    end
  end
end
