namespace :microsoft_graph do
  desc "Setup Microsoft Graph credentials"
  task :setup => :environment do
    puts "Setting up Microsoft Graph credentials..."
    puts "Please provide the following information from your Azure App Registration:"
    
    print "Client ID (Application ID): "
    client_id = STDIN.gets.chomp
    
    print "Client Secret: "
    client_secret = STDIN.gets.chomp
    
    print "Tenant ID (Directory ID): "
    tenant_id = STDIN.gets.chomp
    
    puts "\nChoose your preferred method for storing credentials:"
    puts "1. Environment variables (.env file) - Recommended for development"
    puts "2. Rails encrypted credentials - Recommended for production"
    print "Enter choice (1 or 2): "
    choice = STDIN.gets.chomp
    
    if choice == "1"
      puts "\nAdd the following lines to your .env file:"
      puts "(Create .env file in your project root if it doesn't exist)"
      puts ""
      puts "MICROSOFT_GRAPH_CLIENT_ID=#{client_id}"
      puts "MICROSOFT_GRAPH_CLIENT_SECRET=#{client_secret}"
      puts "MICROSOFT_GRAPH_TENANT_ID=#{tenant_id}"
      puts "AGATHA_USE_MICROSOFT_GRAPH=true"
      puts ""
      puts "Make sure .env is in your .gitignore file!"
      
      # Check if .env exists and offer to append
      env_file = Rails.root.join('.env')
      if File.exist?(env_file)
        print "\nWould you like me to add these to your existing .env file? (y/n): "
        append_choice = STDIN.gets.chomp.downcase
        if append_choice == 'y' || append_choice == 'yes'
          File.open(env_file, 'a') do |f|
            f.puts "\n# Microsoft Graph Configuration"
            f.puts "MICROSOFT_GRAPH_CLIENT_ID=#{client_id}"
            f.puts "MICROSOFT_GRAPH_CLIENT_SECRET=#{client_secret}"
            f.puts "MICROSOFT_GRAPH_TENANT_ID=#{tenant_id}"
            f.puts "AGATHA_USE_MICROSOFT_GRAPH=true"
          end
          puts "✓ Added Microsoft Graph configuration to .env file"
        end
      end
      
    else
      puts "\nTo set these credentials using Rails encrypted credentials, run:"
      puts "rails credentials:edit"
      puts "\nThen add the following YAML structure:"
      puts "\nmicrosoft_graph:"
      puts "  client_id: #{client_id}"
      puts "  client_secret: #{client_secret}"
      puts "  tenant_id: #{tenant_id}"
    end
    
    puts "\nRemember to enable Microsoft Graph by setting config.use_microsoft_graph = true in your environment configuration or by setting the AGATHA_USE_MICROSOFT_GRAPH=true environment variable."
  end
  
  desc "Test Microsoft Graph configuration"
  task :test => :environment do
    puts "Testing Microsoft Graph configuration..."
    
    begin
      service = MicrosoftGraphService.new
      puts "✓ Microsoft Graph service initialized successfully"
      puts "✓ All required credentials are present"
      
      # Test if we can get an access token
      token = service.send(:get_access_token)
      if token
        puts "✓ Successfully obtained access token from Microsoft Graph"
        puts "✓ Microsoft Graph is properly configured and ready to use"
      else
        puts "✗ Failed to obtain access token"
      end
      
    rescue => e
      puts "✗ Error testing Microsoft Graph configuration: #{e.message}"
      puts "\nPlease ensure you have:"
      puts "1. Set up the credentials using 'rails microsoft_graph:setup'"
      puts "2. Added the credentials to Rails encrypted credentials"
      puts "3. Configured the proper API permissions in Azure"
    end
  end
  
  desc "Show current Microsoft Graph status"
  task :status => :environment do
    puts "Microsoft Graph Email Configuration Status:"
    puts "=========================================="
    
    use_graph = Rails.application.config.respond_to?(:use_microsoft_graph) && 
                Rails.application.config.use_microsoft_graph
    
    puts "Microsoft Graph Enabled: #{use_graph ? 'YES' : 'NO'}"
    puts "Environment: #{Rails.env}"
    
    # Check for environment variables first
    env_client_id = ENV['MICROSOFT_GRAPH_CLIENT_ID']
    env_client_secret = ENV['MICROSOFT_GRAPH_CLIENT_SECRET']
    env_tenant_id = ENV['MICROSOFT_GRAPH_TENANT_ID']
    
    if env_client_id.present? || env_client_secret.present? || env_tenant_id.present?
      puts "\nEnvironment Variables Configuration:"
      puts "Client ID configured: #{env_client_id.present? ? 'YES' : 'NO'}"
      puts "Client Secret configured: #{env_client_secret.present? ? 'YES' : 'NO'}"
      puts "Tenant ID configured: #{env_tenant_id.present? ? 'YES' : 'NO'}"
      
      if env_client_id.present? && env_client_secret.present? && env_tenant_id.present?
        puts "✓ All environment variables are configured"
      else
        puts "✗ Missing some environment variables"
      end
    end
    
    # Check for Rails credentials
    begin
      cred_client_id = Rails.application.credentials.dig(:microsoft_graph, :client_id)
      cred_client_secret = Rails.application.credentials.dig(:microsoft_graph, :client_secret)
      cred_tenant_id = Rails.application.credentials.dig(:microsoft_graph, :tenant_id)
      
      if cred_client_id.present? || cred_client_secret.present? || cred_tenant_id.present?
        puts "\nRails Credentials Configuration:"
        puts "Client ID configured: #{cred_client_id.present? ? 'YES' : 'NO'}"
        puts "Client Secret configured: #{cred_client_secret.present? ? 'YES' : 'NO'}"
        puts "Tenant ID configured: #{cred_tenant_id.present? ? 'YES' : 'NO'}"
        
        if cred_client_id.present? && cred_client_secret.present? && cred_tenant_id.present?
          puts "✓ All Rails credentials are configured"
        else
          puts "✗ Missing some Rails credentials"
        end
      end
      
      # Overall status
      any_complete = (env_client_id.present? && env_client_secret.present? && env_tenant_id.present?) ||
                     (cred_client_id.present? && cred_client_secret.present? && cred_tenant_id.present?)
      
      if any_complete
        puts "\n✓ Microsoft Graph credentials are properly configured"
      else
        puts "\n✗ Microsoft Graph credentials are not complete - run 'rails microsoft_graph:setup'"
      end
      
    rescue => e
      puts "✗ Error reading credentials: #{e.message}"
    end
    
    puts "\nTo enable Microsoft Graph:"
    puts "- Add AGATHA_USE_MICROSOFT_GRAPH=true to your .env file"
    puts "- Or set config.use_microsoft_graph = true in environment config"
  end
end
