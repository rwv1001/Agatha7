module RecordLockHelper
  # Helper methods for record locking functionality
  
  def record_locked_by_current_user?(table_name, record_id)
    return false unless session[:user_id]
    
    lock = RecordLock.find_by(
      table_name: table_name,
      record_id: record_id,
      user_id: session[:user_id]
    )
    
    lock&.active?
  end
  
  def record_locked_by_other_user?(table_name, record_id)
    return false unless session[:user_id]
    
    lock = RecordLock.where(
      table_name: table_name,
      record_id: record_id
    ).where.not(user_id: session[:user_id]).first
    
    lock&.active?
  end
  
  def record_lock_owner(table_name, record_id)
    lock = RecordLock.find_by(table_name: table_name, record_id: record_id)
    return nil unless lock&.active?
    
    lock.user
  end
  
  def lock_status_class(table_name, record_id)
    if record_locked_by_current_user?(table_name, record_id)
      'locked-by-me'
    elsif record_locked_by_other_user?(table_name, record_id)
      'locked-by-other'
    else
      'unlocked'
    end
  end
end