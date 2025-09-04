namespace :email_mapping do
  desc "List all valid email accounts from Microsoft Graph or configuration"
  task list_accounts: :environment do
    puts "🔍 Fetching valid email accounts..."
    puts ""

    result = EmailAddressMapper.list_all_valid_accounts

    puts "📊 Source: #{result[:source]}"
    if result[:cached_at]
      puts "🕒 Cached at: #{result[:cached_at]}"
    end
    puts ""

    puts "📧 Owned Domain (#{result[:owned_domain][:domain]}):"
    puts "   Found #{result[:owned_domain][:accounts].length} accounts:"
    result[:owned_domain][:accounts].sort.each_with_index do |account, index|
      puts "     #{index + 1}. #{account}"
    end
    puts ""

    puts "🔐 Sender Domain (#{result[:sender_domain][:domain]}):"
    puts "   Found #{result[:sender_domain][:accounts].length} accounts:"
    result[:sender_domain][:accounts].sort.each_with_index do |account, index|
      puts "     #{index + 1}. #{account}"
    end
    puts ""
  end

  desc "Refresh the Microsoft Graph accounts cache"
  task refresh_cache: :environment do
    puts "🔄 Refreshing Microsoft Graph accounts cache..."

    begin
      accounts = EmailAddressMapper.refresh_valid_accounts_cache
      puts "✅ Successfully refreshed cache with #{accounts.length} accounts"
      puts ""
      puts "📧 Updated accounts:"
      accounts.sort.each_with_index do |account, index|
        puts "  #{index + 1}. #{account}"
      end
    rescue => e
      puts "❌ Failed to refresh cache: #{e.message}"
      puts ""
      puts "💡 Make sure your Microsoft Graph credentials are configured correctly:"
      puts "   - MICROSOFT_GRAPH_CLIENT_ID"
      puts "   - MICROSOFT_GRAPH_CLIENT_SECRET"
      puts "   - MICROSOFT_GRAPH_TENANT_ID"
    end
    puts ""
  end

  desc "Test email address mapping"
  task :test_mapping, [:email] => :environment do |t, args|
    email = args[:email] || "vice.regent@studium.bfriars.ox.ac.uk"

    puts "🧪 Testing email mapping for: #{email}"
    puts ""

    debug_info = EmailAddressMapper.test_email_mapping(email)

    puts "🔍 Debug Information:"
    puts "   Original: #{debug_info[:original_email]}"
    puts "   Cleaned:  #{debug_info[:cleaned_email]}"
    if debug_info[:graph_lookup_result]
      puts "   Graph API found: #{debug_info[:graph_lookup_result]}"
    end
    puts "   Method: #{debug_info[:lookup_method]}"
    puts ""

    result = debug_info[:mapping_result]
    if result[:success]
      puts "✅ Mapping successful!"
      puts "📧 Send from: #{result[:send_from]}"
      puts "↩️  Reply to: #{result[:reply_to]}"
      puts "💬 Message: #{result[:message]}"
    else
      puts "❌ Mapping failed!"
      puts "🚫 Error: #{result[:error]}"
    end
    puts ""
  end

  desc "Show Microsoft Graph configuration status"
  task config_status: :environment do
    puts "⚙️  Microsoft Graph Configuration Status"
    puts ""

    client_id = ENV["MICROSOFT_GRAPH_CLIENT_ID"] || Rails.application.credentials.dig(:microsoft_graph, :client_id)
    client_secret = ENV["MICROSOFT_GRAPH_CLIENT_SECRET"] || Rails.application.credentials.dig(:microsoft_graph, :client_secret)
    tenant_id = ENV["MICROSOFT_GRAPH_TENANT_ID"] || Rails.application.credentials.dig(:microsoft_graph, :tenant_id)

    puts "📋 Client ID: #{client_id.present? ? "✅ Set" : "❌ Missing"}"
    puts "🔐 Client Secret: #{client_secret.present? ? "✅ Set" : "❌ Missing"}"
    puts "🏢 Tenant ID: #{tenant_id.present? ? "✅ Set" : "❌ Missing"}"
    puts ""

    if client_id.present? && client_secret.present? && tenant_id.present?
      puts "🎯 All credentials configured!"
      puts "💡 Try running: rails email_mapping:test_connection"
    else
      puts "⚠️  Some credentials are missing. Email mapping will fall back to configuration."
    end
    puts ""
  end

  desc "Test Microsoft Graph connection"
  task test_connection: :environment do
    puts "🔌 Testing Microsoft Graph connection..."
    puts ""

    begin
      graph_service = MicrosoftGraphService.new
      access_token = graph_service.send(:get_access_token)

      puts "✅ Successfully obtained access token!"
      puts "🔑 Token length: #{access_token.length} characters"
      puts ""

      # Test fetching a few users
      puts "👥 Testing user fetch (first 5 users)..."
      users = EmailAddressMapper.send(:fetch_users_from_graph, access_token)

      if users.any?
        puts "✅ Successfully fetched #{users.length} users from Microsoft Graph"
        puts ""
        puts "📧 Sample accounts in your owned domain (#{EmailAddressMapper::OWNED_DOMAIN}):"

        owned_domain_users = users.select { |u|
          u["mail"]&.end_with?("@#{EmailAddressMapper::OWNED_DOMAIN}") ||
            (u["proxyAddresses"] || []).any? { |addr| addr.match(/@#{Regexp.escape(EmailAddressMapper::OWNED_DOMAIN)}/io) }
        }
        owned_domain_users.first(5).each do |user|
          main_email = user["mail"]
          proxy_emails = (user["proxyAddresses"] || []).select { |addr|
            addr.match(/@#{Regexp.escape(EmailAddressMapper::OWNED_DOMAIN)}/io)
          }.map { |addr| addr.gsub(/^SMTP:/i, "") }

          puts "  - #{main_email} (#{user["displayName"]})"
          proxy_emails.each { |proxy| puts "    └─ Proxy: #{proxy}" if proxy != main_email }
        end

        puts ""
        puts "🔐 Sample accounts in your sender domain (#{EmailAddressMapper::SENDER_DOMAIN}):"

        sender_domain_users = users.select { |u|
          u["userPrincipalName"]&.end_with?("@#{EmailAddressMapper::SENDER_DOMAIN}") ||
            u["mail"]&.end_with?("@#{EmailAddressMapper::SENDER_DOMAIN}")
        }
        sender_domain_users.first(5).each do |user|
          auth_email = user["userPrincipalName"]&.end_with?("@#{EmailAddressMapper::SENDER_DOMAIN}") ?
                      user["userPrincipalName"] : user["mail"]
          puts "  - #{auth_email} (#{user["displayName"]})"
        end

        if owned_domain_users.length > 5
          puts "  ... and #{owned_domain_users.length - 5} more owned domain accounts"
        end
        if sender_domain_users.length > 5
          puts "  ... and #{sender_domain_users.length - 5} more sender domain accounts"
        end
      else
        puts "⚠️  No users found. Check your tenant permissions."
      end
    rescue => e
      puts "❌ Connection failed: #{e.message}"
      puts ""
      puts "💡 Troubleshooting steps:"
      puts "   1. Check your credentials with: rails email_mapping:config_status"
      puts "   2. Verify your app has User.Read.All permissions in Azure"
      puts "   3. Ensure admin consent has been granted"
    end
    puts ""
  end
end
