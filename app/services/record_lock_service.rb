# Service class to handle record locking logic with timeout management
class RecordLockService
  LOCK_TIMEOUT = 1.hour # 1 hour timeout
  ACTIVITY_TIMEOUT = 30.minutes # Release lock if no activity for 30 minutes
  
  class << self
    # Attempt to acquire a lock on a record
    def attempt_lock(table_name, record_id, user_id)
      # Clean up expired locks first
      cleanup_expired_locks
      
      # Check if record is already locked
      existing_lock = OpenRecord.find_by(
        table_name: table_name,
        record_id: record_id,
        in_use: true
      )
      
      if existing_lock
        # Check if it's the same user
        if existing_lock.user_id == user_id
          # Refresh the lock timestamp
          existing_lock.touch
          
          # Broadcast lock refresh
          ActionCable.server.broadcast "record_locks", {
            action: 'lock_refreshed',
            table_name: table_name,
            record_id: record_id,
            user_id: user_id,
            locked: true
          }
          
          return { locked: true, message: "Lock refreshed" }
        else
          # Check if lock has expired
          if lock_expired?(existing_lock)
            # Expire the old lock and create new one
            existing_lock.update(in_use: false)
            create_lock(table_name, record_id, user_id)
            return { locked: true, message: "Previous lock expired, new lock acquired" }
          else
            # Lock is held by another user and still valid
            user = User.find_by(id: existing_lock.user_id)
            time_remaining = time_until_expiry(existing_lock)
            return { 
              locked: false, 
              message: "Record is being edited by #{user&.name || 'another user'}. Lock expires in #{time_remaining}.",
              locked_by_user: user&.name,
              expires_at: existing_lock.updated_at + LOCK_TIMEOUT
            }
          end
        end
      else
        # No existing lock, create new one
        create_lock(table_name, record_id, user_id)
        return { locked: true, message: "Lock acquired successfully" }
      end
    end
    
    # Release a lock
    def release_lock(table_name, record_id, user_id)
      lock = OpenRecord.find_by(
        table_name: table_name,
        record_id: record_id,
        user_id: user_id,
        in_use: true
      )
      
      if lock
        lock.update(in_use: false)
        
        # Broadcast that the record has been unlocked
        ActionCable.server.broadcast "record_locks", {
          action: 'record_unlocked',
          table_name: table_name,
          record_id: record_id,
          user_id: user_id,
          unlocked: true
        }
        
        Rails.logger.info "RecordLockService: Released lock for #{table_name}##{record_id} by user #{user_id}"
        return { unlocked: true, message: "Lock released successfully" }
      else
        return { unlocked: false, message: "No active lock found for this user" }
      end
    end
    
    # Check if a user has a lock on a record
    def has_lock?(table_name, record_id, user_id)
      OpenRecord.exists?(
        table_name: table_name,
        record_id: record_id,
        user_id: user_id,
        in_use: true
      )
    end
    
    # Get all active locks for a user
    def user_locks(user_id)
      OpenRecord.where(user_id: user_id, in_use: true)
    end
    
    # Clean up expired locks
    def cleanup_expired_locks
      expired_locks = OpenRecord.where(in_use: true)
                                .where('updated_at < ?', LOCK_TIMEOUT.ago)
      
      expired_locks.find_each do |lock|
        lock.update(in_use: false)
        
        # Broadcast that the lock has been released due to timeout
        ActionCable.server.broadcast "record_locks", {
          action: 'record_unlocked',
          table_name: lock.table_name,
          record_id: lock.record_id,
          user_id: lock.user_id,
          unlocked: true,
          reason: 'timeout'
        }
        
        Rails.logger.info "RecordLockService: Expired lock for #{lock.table_name}##{lock.record_id} by user #{lock.user_id}"
      end
      
      expired_locks.count
    end
    
    # Refresh lock timestamp (call this on every update)
    def refresh_lock(table_name, record_id, user_id)
      lock = OpenRecord.find_by(
        table_name: table_name,
        record_id: record_id,
        user_id: user_id,
        in_use: true
      )
      
      if lock
        lock.touch
        Rails.logger.debug "RecordLockService: Refreshed lock for #{table_name}##{record_id}"
        return true
      end
      
      false
    end
    
    # Get information about who has a record locked
    def lock_info(table_name, record_id)
      lock = OpenRecord.find_by(
        table_name: table_name,
        record_id: record_id,
        in_use: true
      )
      
      return nil unless lock
      
      if lock_expired?(lock)
        lock.update(in_use: false)
        return nil
      end
      
      user = User.find_by(id: lock.user_id)
      {
        user_id: lock.user_id,
        user_name: user&.name,
        locked_at: lock.created_at,
        last_activity: lock.updated_at,
        expires_at: lock.updated_at + LOCK_TIMEOUT,
        time_remaining: time_until_expiry(lock)
      }
    end
    
    private
    
    def create_lock(table_name, record_id, user_id)
      OpenRecord.create!(
        table_name: table_name,
        record_id: record_id,
        user_id: user_id,
        in_use: true
      )
      
      # Broadcast that the record has been locked
      ActionCable.server.broadcast "record_locks", {
        action: 'record_locked',
        table_name: table_name,
        record_id: record_id,
        user_id: user_id,
        locked: true
      }
      
      Rails.logger.info "RecordLockService: Created lock for #{table_name}##{record_id} by user #{user_id}"
    end
    
    def lock_expired?(lock)
      lock.updated_at < LOCK_TIMEOUT.ago
    end
    
    def time_until_expiry(lock)
      remaining_seconds = (lock.updated_at + LOCK_TIMEOUT - Time.current).to_i
      return "expired" if remaining_seconds <= 0
      
      if remaining_seconds > 3600
        "#{remaining_seconds / 3600}h #{(remaining_seconds % 3600) / 60}m"
      elsif remaining_seconds > 60
        "#{remaining_seconds / 60}m"
      else
        "#{remaining_seconds}s"
      end
    end
  end
end
