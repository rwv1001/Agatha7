# Clear all record locks on application startup using TRUNCATE
# This is especially useful when restarting the application via Docker Compose
# to ensure no locks are left hanging from previous sessions

Rails.application.config.after_initialize do
  # Only run this in non-test environments and when the database is available
  unless Rails.env.test?
    begin
      # Check if the open_records table exists and truncate it
      if ActiveRecord::Base.connection.table_exists?('open_records')
        Rails.logger.info "🔓 Application startup: Truncating open_records table to clear all record locks"
        
        # Use TRUNCATE TABLE to completely clear the table
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE open_records")
        
        Rails.logger.info "✅ Application startup: Successfully truncated open_records table"
      else
        Rails.logger.warn "⚠️ Application startup: open_records table not found, skipping lock cleanup"
      end
    rescue => e
      # Don't let lock clearing prevent app startup
      Rails.logger.error "❌ Application startup: Failed to truncate open_records table: #{e.message}"
      Rails.logger.error "   This is not critical - the app will continue to start normally"
    end
  end
end
