class SearchTableChannel < ApplicationCable::Channel
  def subscribed
    # Subscribe to global search table updates
    stream_from "search_table_updates"
    Rails.logger.info "User #{current_user_id} subscribed to search table updates"
  end

  def unsubscribed
    Rails.logger.info "User #{current_user_id} unsubscribed from search table updates"
  end

  def join_table(data)
    # Allow users to join specific table streams for targeted updates (optional)
    table_name = data['table_name']
    if table_name.present?
      stream_from "search_table_#{table_name}_updates"
      Rails.logger.info "User #{current_user_id} joined #{table_name} updates"
    end
  end

  private

  def current_user_id
    # Get user ID from connection
    connection.current_user_id
  end
end
