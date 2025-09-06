class EmailAddressMapper
  DISPLAY_DOMAIN = "bfriars.ox.ac.uk"     # What users see in replies
  OWNED_DOMAIN = "studium.bfriars.ox.ac.uk"  # What we validate against
  SENDER_DOMAIN = "english.op.org"        # The domain for user IDs/authentication
  AUTH_DOMAIN = SENDER_DOMAIN              # Alias for backward compatibility

  def self.map_from_address(original_from_address)
    # Clean up any template artifacts
    cleaned_address = clean_template_artifacts(original_from_address)

    return {success: false, error: "Invalid email format"} unless valid_email?(cleaned_address)

    local_part = cleaned_address.split("@").first

    # Three-domain mapping logic:
    # 1. If input is display domain (bfriars.ox.ac.uk), convert to owned domain (studium.bfriars.ox.ac.uk)
    # 2. Try Microsoft Graph lookup for authentication domain mapping
    # 3. Fall back to direct auth domain mapping (local_part@english.op.org)
    # 4. Fall back to .bf auth domain mapping (local_part.bf@english.op.org)

    # Step 1: Determine the email to validate against owned domain
    validation_email = if cleaned_address.end_with?("@#{DISPLAY_DOMAIN}")
      "#{local_part}@#{OWNED_DOMAIN}"
    elsif cleaned_address.end_with?("@#{OWNED_DOMAIN}")
      cleaned_address
    else
      # If it's neither display nor owned domain, try to work with it anyway
      cleaned_address
    end

    # Step 2: Try Microsoft Graph lookup first (if owned domain email exists)
    if is_valid_owned_domain_email?(validation_email)
      sender_email = find_sender_email_for_address(validation_email)
      if sender_email
        return {
          success: true,
          send_from: sender_email,
          reply_to: cleaned_address,
          message: "Email will be sent from #{sender_email} with reply-to #{cleaned_address} (Graph API mapping)"
        }
      end
    end

    # Step 3: Try direct auth domain mapping (local_part@english.op.org)
    direct_auth_email = "#{local_part}@#{AUTH_DOMAIN}"
    if is_valid_auth_domain_email?(direct_auth_email)
      return {
        success: true,
        send_from: direct_auth_email,
        reply_to: cleaned_address,
        message: "Email will be sent from #{direct_auth_email} with reply-to #{cleaned_address} (direct auth mapping)"
      }
    end

    # Step 4: Try .bf fallback auth domain mapping (local_part.bf@english.op.org)
    fallback_auth_email = "#{local_part}.bf@#{AUTH_DOMAIN}"
    if is_valid_auth_domain_email?(fallback_auth_email)
      return {
        success: true,
        send_from: fallback_auth_email,
        reply_to: cleaned_address,
        message: "Email will be sent from #{fallback_auth_email} with reply-to #{cleaned_address} (fallback .bf mapping)"
      }
    end

    # If all steps fail
    {
      success: false,
      error: "No corresponding sender email found for #{cleaned_address}. Tried: Graph API lookup for #{validation_email}, direct mapping to #{direct_auth_email}, and fallback mapping to #{fallback_auth_email}."
    }
  end

  private

  def self.log_graph_api_error(operation, response)
    error_body = begin
      JSON.parse(response.body)
    rescue
      {"error" => {"code" => "ParseError", "message" => response.body}}
    end
    error_code = error_body.dig("error", "code")

    if error_code == "Authorization_RequestDenied"
      Rails.logger.warn "EmailAddressMapper: Graph API permissions insufficient for #{operation}. Using fallback configuration."
    else
      Rails.logger.error "EmailAddressMapper: Graph API #{operation} error: #{response.code} - #{response.body}"
    end
  end

  def self.find_sender_email_for_address(target_email)
    # Try to find the user ID (english.op.org email) for someone who has the target email as a proxy address
    Rails.cache.fetch("graph_user_mapping_#{target_email}", expires_in: 30.minutes) do
      graph_service = MicrosoftGraphService.new
      access_token = graph_service.send(:get_access_token)

      # Search for users who have this email address as one of their addresses
      user = find_user_by_proxy_address(access_token, target_email)

      if user
        # Look for their primary email or userPrincipalName that ends with english.op.org
        sender_email = extract_sender_email_from_user(user)
        Rails.logger.debug "EmailAddressMapper: Found sender #{sender_email} for #{target_email}"
        sender_email
      else
        Rails.logger.warn "EmailAddressMapper: No user found with proxy address #{target_email}"
        nil
      end
    rescue => e
      Rails.logger.error "EmailAddressMapper: Error finding sender for #{target_email}: #{e.message}"
      nil
    end
  end

  def self.find_user_by_proxy_address(access_token, target_email)
    require "net/http"
    require "uri"
    require "json"

    # Search for users by email address using OData filter
    # This searches both mail and proxyAddresses fields
    filter = "mail eq '#{target_email}' or proxyAddresses/any(x:x eq 'smtp:#{target_email}') or proxyAddresses/any(x:x eq 'SMTP:#{target_email}')"
    encoded_filter = URI.encode_www_form_component(filter)

    uri = URI("https://graph.microsoft.com/v1.0/users?$filter=#{encoded_filter}&$select=mail,userPrincipalName,proxyAddresses,displayName")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{access_token}"
    request["Content-Type"] = "application/json"

    response = http.request(request)

    if response.code == "200"
      data = JSON.parse(response.body)
      users = data["value"] || []

      # Return the first matching user
      users.first
    else
      log_graph_api_error("user search", response)
      nil
    end
  end

  def self.extract_sender_email_from_user(user)
    # Priority order for finding the sender email:
    # 1. userPrincipalName ending with @english.op.org
    # 2. mail field ending with @english.op.org
    # 3. Any proxyAddress ending with @english.op.org

    upn = user["userPrincipalName"]
    if upn&.end_with?("@#{SENDER_DOMAIN}")
      return upn
    end

    mail = user["mail"]
    if mail&.end_with?("@#{SENDER_DOMAIN}")
      return mail
    end

    # Check proxy addresses
    proxy_addresses = user["proxyAddresses"] || []
    english_proxies = proxy_addresses.select { |addr|
      addr.match(/^SMTP:.*@#{Regexp.escape(SENDER_DOMAIN)}$/io) ||
        addr.match(/^smtp:.*@#{Regexp.escape(SENDER_DOMAIN)}$/io)
    }

    if english_proxies.any?
      # Remove the SMTP: prefix
      return english_proxies.first.gsub(/^SMTP:/i, "")
    end

    # Fallback: try to construct from display name or username
    display_name = user["displayName"]
    if display_name && upn
      # Extract username part from UPN and try english.op.org
      username = upn.split("@").first
      potential_email = "#{username}@#{SENDER_DOMAIN}"

      # Verify this email exists
      if email_exists_in_sender_domain?(potential_email)
        return potential_email
      end
    end

    nil
  end

  def self.email_exists_in_sender_domain?(email)
    # Check if the email exists in the sender domain (english.op.org)
    sender_accounts = fetch_sender_domain_accounts
    sender_accounts.include?(email)
  end

  def self.fetch_sender_domain_accounts
    # Fetch accounts specifically from the sender domain
    Rails.cache.fetch("sender_domain_accounts", expires_in: 1.hour) do
      graph_service = MicrosoftGraphService.new
      access_token = graph_service.send(:get_access_token)

      users = fetch_users_from_graph(access_token)

      # Filter to accounts in the sender domain
      sender_emails = users.select { |user|
        user["userPrincipalName"]&.end_with?("@#{SENDER_DOMAIN}") ||
          user["mail"]&.end_with?("@#{SENDER_DOMAIN}")
      }.map { |user|
        # Prefer userPrincipalName over mail for authentication
        user["userPrincipalName"]&.end_with?("@#{SENDER_DOMAIN}") ?
          user["userPrincipalName"] : user["mail"]
      }.compact.uniq

      Rails.logger.debug "EmailAddressMapper: Fetched #{sender_emails.length} sender domain accounts"
      sender_emails
    rescue => e
      Rails.logger.error "EmailAddressMapper: Error fetching sender domain accounts: #{e.message}"
      default_sender_accounts
    end
  end

  def self.default_sender_accounts
    [
      # 'vice.regent@english.op.org',  # Removed so it falls back to .bf version
      "vice.regent.bf@english.op.org",  # Add .bf fallback for vice.regent
      "prior@english.op.org",
      "subprior@english.op.org",
      "registrar@english.op.org"
    ]
  end

  def self.clean_template_artifacts(email_string)
    # Remove ERB template artifacts
    cleaned = email_string.to_s
    cleaned = cleaned.gsub("!--BEGINinlinetemplate--", "")
    cleaned = cleaned.gsub("!--ENDinlinetemplate--", "")
    cleaned = cleaned.strip

    # Remove angle brackets if present
    cleaned = cleaned.gsub(/^</, "").gsub(/>$/, "")

    # Remove any semicolons at the end
    cleaned = cleaned.gsub(/;$/, "")

    # Remove extra whitespace
    cleaned.gsub(/\s+/, "")
  end

  def self.valid_email?(email)
    email.present? &&
      email.include?("@") &&
      !email.include?("!--BEGIN") &&
      !email.include?("!--END") &&
      email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
  end

  def self.email_exists_in_owned_domain?(email)
    # This method now checks for owned domain emails (studium.bfriars.ox.ac.uk)
    # but we primarily use it for validation
    begin
      valid_accounts = fetch_valid_accounts_from_graph_api
      return valid_accounts.include?(email) if valid_accounts.any?
    rescue => e
      Rails.logger.warn "EmailAddressMapper: Could not fetch accounts from Microsoft Graph: #{e.message}"
      Rails.logger.warn "EmailAddressMapper: Falling back to configured account list"
    end

    # Fallback to configured list
    valid_accounts = Rails.application.config.respond_to?(:email_mapping) &&
      Rails.application.config.email_mapping[:valid_accounts] ||
      default_valid_accounts

    valid_accounts.include?(email)
  end

  def self.fetch_valid_accounts_from_graph_api
    # Fetch accounts from the owned domain (studium.bfriars.ox.ac.uk)
    Rails.cache.fetch("microsoft_graph_valid_accounts", expires_in: 1.hour) do
      graph_service = MicrosoftGraphService.new
      access_token = graph_service.send(:get_access_token)

      users = fetch_users_from_graph(access_token)

      # Filter to accounts in our owned domain (what we can send on behalf of)
      valid_emails = users.select { |user|
        user["mail"]&.end_with?("@#{OWNED_DOMAIN}") ||
          (user["proxyAddresses"] || []).any? { |addr|
            addr.match(/^SMTP:.*@#{Regexp.escape(OWNED_DOMAIN)}$/io) ||
              addr.match(/^smtp:.*@#{Regexp.escape(OWNED_DOMAIN)}$/io)
          }
      }.map { |user|
        # Get the actual email address for the owned domain
        if user["mail"]&.end_with?("@#{OWNED_DOMAIN}")
          user["mail"]
        else
          proxy = (user["proxyAddresses"] || []).find { |addr|
            addr.match(/^SMTP:.*@#{Regexp.escape(OWNED_DOMAIN)}$/io) ||
              addr.match(/^smtp:.*@#{Regexp.escape(OWNED_DOMAIN)}$/io)
          }
          proxy&.gsub(/^SMTP:/i, "")
        end
      }.compact.uniq

      Rails.logger.debug "EmailAddressMapper: Fetched #{valid_emails.length} valid accounts from Microsoft Graph"
      valid_emails
    rescue => e
      Rails.logger.error "EmailAddressMapper: Error fetching accounts from Microsoft Graph: #{e.message}"
      []
    end
  end

  def self.fetch_users_from_graph(access_token)
    require "net/http"
    require "uri"
    require "json"

    all_users = []
    next_link = "https://graph.microsoft.com/v1.0/users?$select=mail,userPrincipalName,displayName&$filter=accountEnabled eq true"

    while next_link
      uri = URI(next_link)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{access_token}"
      request["Content-Type"] = "application/json"

      response = http.request(request)

      if response.code == "200"
        data = JSON.parse(response.body)
        all_users.concat(data["value"] || [])
        next_link = data["@odata.nextLink"]
      else
        log_graph_api_error("user list", response)
        break
      end
    end

    all_users
  end

  def self.default_valid_accounts
    [
      "vice.regent@studium.bfriars.ox.ac.uk",
      "prior@studium.bfriars.ox.ac.uk",
      "subprior@studium.bfriars.ox.ac.uk",
      "registrar@studium.bfriars.ox.ac.uk"
    ]
  end

  # Utility methods for managing the account cache
  def self.refresh_valid_accounts_cache
    Rails.cache.delete("microsoft_graph_valid_accounts")
    Rails.cache.delete("sender_domain_accounts")
    Rails.cache.delete_matched("graph_user_mapping_*")

    # Refresh both caches
    fetch_valid_accounts_from_graph_api
    fetch_sender_domain_accounts
  end

  def self.list_all_valid_accounts
    owned_domain_accounts = fetch_valid_accounts_from_graph_api
    auth_domain_accounts = fetch_sender_domain_accounts

    if owned_domain_accounts.any? || auth_domain_accounts.any?
      {
        source: "Microsoft Graph API",
        display_domain: {
          domain: DISPLAY_DOMAIN,
          note: "Public-facing domain for replies and signatures"
        },
        owned_domain: {
          domain: OWNED_DOMAIN,
          note: "Internal validation domain",
          emails: owned_domain_accounts
        },
        auth_domain: {
          domain: AUTH_DOMAIN,
          note: "Authentication domain for Microsoft Graph",
          usernames: auth_domain_accounts.map { |email| email.split("@").first }
        },
        cached_at: Rails.cache.fetch("microsoft_graph_valid_accounts_timestamp") { Time.current }
      }
    else
      raise "No accounts from Graph API"
    end
  rescue => e
    fallback_accounts = Rails.application.config.respond_to?(:email_mapping) &&
      Rails.application.config.email_mapping[:valid_accounts] ||
      default_valid_accounts
    {
      source: "Configuration fallback (Graph API unavailable: #{e.message})",
      display_domain: {
        domain: DISPLAY_DOMAIN,
        note: "Public-facing domain for replies and signatures"
      },
      owned_domain: {
        domain: OWNED_DOMAIN,
        note: "Internal validation domain",
        emails: fallback_accounts
      },
      auth_domain: {
        domain: AUTH_DOMAIN,
        note: "Authentication domain for Microsoft Graph",
        usernames: default_sender_accounts.map { |email| email.split("@").first }
      },
      cached_at: nil
    }
  end

  # Check if email exists in owned domain
  def self.is_valid_owned_domain_email?(email)
    return false unless email&.end_with?("@#{OWNED_DOMAIN}")

    accounts = list_all_valid_accounts
    accounts[:owned_domain][:emails].include?(email)
  end

  # Check if email exists in auth domain
  def self.is_valid_auth_domain_email?(email)
    return false unless email&.end_with?("@#{AUTH_DOMAIN}")

    local_part = email.split("@").first
    accounts = list_all_valid_accounts
    accounts[:auth_domain][:usernames].include?(local_part)
  end

  def self.test_email_mapping(email_address)
    # Test the complete three-domain email mapping process
    cleaned_email = clean_template_artifacts(email_address)
    local_part = cleaned_email.split("@").first

    # Step 1: Convert display domain to owned domain (if needed)
    step1_studium_email = if email_address.end_with?("@#{DISPLAY_DOMAIN}")
      "#{local_part}@#{OWNED_DOMAIN}"
    else
      cleaned_email
    end

    # Check if step 1 email exists in owned domain
    step1_exists = is_valid_owned_domain_email?(step1_studium_email)

    # Step 2: Try authentication mappings regardless of step 1 result
    step2_graph_lookup = nil
    step2_direct_auth = "#{local_part}@#{AUTH_DOMAIN}"
    step2_direct_exists = is_valid_auth_domain_email?(step2_direct_auth)
    step2_fallback_auth = "#{local_part}.bf@#{AUTH_DOMAIN}"
    step2_fallback_exists = is_valid_auth_domain_email?(step2_fallback_auth)

    # Try Graph API lookup if step 1 exists
    if step1_exists
      step2_graph_lookup = find_sender_email_for_address(step1_studium_email)
    end

    # Get the final mapping result
    result = map_from_address(email_address)

    # Return comprehensive debug info
    {
      input: {
        original_email: email_address,
        cleaned_email: cleaned_email,
        local_part: local_part
      },
      mapping_steps: {
        step1_studium_email: step1_studium_email,
        step1_exists: step1_exists,
        step2_graph_lookup: step2_graph_lookup,
        step2_direct_auth: step2_direct_auth,
        step2_direct_exists: step2_direct_exists,
        step2_fallback_auth: step2_fallback_auth,
        step2_fallback_exists: step2_fallback_exists
      },
      result: result
    }
  end
end
