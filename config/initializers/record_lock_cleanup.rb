# Configure recurring cleanup job for expired record locks
Rails.application.configure do
  # Schedule cleanup job to run every 10 minutes
  config.after_initialize do
    # Only run in production or when RAILS_ENV allows background jobs
    if defined?(Rails::Server) && (Rails.env.production? || ENV['ENABLE_BACKGROUND_JOBS'])
      # Use a simple recurring job approach
      Thread.new do
        loop do
          begin
            CleanupExpiredLocksJob.perform_later
            Rails.logger.info "RecordLock: Scheduled cleanup job"
          rescue => e
            Rails.logger.error "RecordLock: Failed to schedule cleanup job: #{e.message}"
          end
          
          # Sleep for 10 minutes
          sleep(10.minutes)
        end
      end
    end
  end
end
