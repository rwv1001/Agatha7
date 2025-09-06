# Background job to clean up expired record locks
class CleanupExpiredLocksJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.debug "CleanupExpiredLocksJob: Starting cleanup of expired locks"

    expired_count = RecordLockService.cleanup_expired_locks

    Rails.logger.debug "CleanupExpiredLocksJob: Cleaned up #{expired_count} expired locks"
  end
end
