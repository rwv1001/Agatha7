# Background job to clean up expired record locks
class CleanupExpiredLocksJob < ApplicationJob
  queue_as :default
  
  def perform
    Rails.logger.info "CleanupExpiredLocksJob: Starting cleanup of expired locks"
    
    expired_count = RecordLockService.cleanup_expired_locks
    
    Rails.logger.info "CleanupExpiredLocksJob: Cleaned up #{expired_count} expired locks"
  end
end
