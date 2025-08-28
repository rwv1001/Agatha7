# ActionCable channel for real-time record locking notifications
class RecordLockChannel < ApplicationCable::Channel
  def subscribed
    # Subscribe to the general record lock stream
    stream_from "record_locks"
    
    # Also subscribe to user-specific stream for direct notifications
    user_id = current_user_id
    stream_from "record_locks_user_#{user_id}" if user_id
    
    Rails.logger.info "RecordLockChannel: User #{user_id} subscribed to record lock notifications"
  end

  def unsubscribed
    Rails.logger.info "RecordLockChannel: User unsubscribed from record lock notifications"
  end

  # Handle when client requests to lock a record
  def lock_record(data)
    table_name = data['table_name']
    record_id = data['record_id']
    user_id = current_user_id
    
    if user_id && table_name && record_id
      result = RecordLockService.attempt_lock(table_name, record_id, user_id)
      
      # Broadcast the lock status to all users
      ActionCable.server.broadcast "record_locks", {
        action: 'record_locked',
        table_name: table_name,
        record_id: record_id,
        user_id: user_id,
        user_name: User.find(user_id)&.name,
        locked: result[:locked],
        message: result[:message]
      }
      
      # Send response back to the requesting client
      transmit({
        success: result[:locked],
        message: result[:message]
      })
    end
  end

  # Handle when client releases a record lock
  def unlock_record(data)
    table_name = data['table_name']
    record_id = data['record_id']
    user_id = current_user_id
    
    if user_id && table_name && record_id
      result = RecordLockService.release_lock(table_name, record_id, user_id)
      
      # Note: The RecordLockService.release_lock method already broadcasts the unlock message
      # so we don't need to broadcast again here to avoid duplicate notifications
      Rails.logger.info "RecordLockChannel: User #{user_id} unlocked #{table_name}##{record_id}, result: #{result[:message]}"
    end
  end

  private

  def current_user_id
    # Get user ID from the connection
    connection.current_user_id
  end
end
