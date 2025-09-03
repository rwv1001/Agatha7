# Microsoft Graph Email Configuration
Rails.application.configure do
  # Set to true to use Microsoft Graph API for sending emails
  # Set to false to use traditional SMTP
  config.use_microsoft_graph = Rails.env.production? ? true : false
  
  # In development/test, you can override by setting environment variable:
  # AGATHA_USE_MICROSOFT_GRAPH=true
  if Rails.env.development? || Rails.env.test?
    config.use_microsoft_graph = ENV['AGATHA_USE_MICROSOFT_GRAPH'] == 'true'
  end
  
  Rails.logger.info "Microsoft Graph Email Sending: #{config.use_microsoft_graph ? 'ENABLED' : 'DISABLED'}"
end
