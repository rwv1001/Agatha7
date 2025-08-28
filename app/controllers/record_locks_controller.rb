# Controller to handle record lock state requests
class RecordLocksController < ApplicationController
  # Return current lock states for all active locks
  def current_state
    user_id = session[:user_id]
    
    # Get all active locks with user information (don't cleanup here - let scheduled job handle it)
    active_locks = OpenRecord.joins('LEFT JOIN users ON open_records.user_id = users.id')
                             .where(in_use: true)
                             .select('open_records.*, users.name as user_name')
    
    locks_data = active_locks.map do |lock|
      {
        table_name: lock.table_name,
        record_id: lock.record_id.to_s,
        user_id: lock.user_id,
        user_name: lock.user_name || 'Unknown User',
        locked_at: lock.created_at,
        last_activity: lock.updated_at,
        expires_at: lock.updated_at + RecordLockService::LOCK_TIMEOUT
      }
    end
    
    render json: {
      locks: locks_data,
      current_user_id: user_id,
      timestamp: Time.current
    }
  end
end
