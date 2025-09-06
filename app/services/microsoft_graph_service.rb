require "net/http"
require "uri"
require "json"
require "base64"

class MicrosoftGraphService
  GRAPH_API_URL = "https://graph.microsoft.com/v1.0"
  TOKEN_URL = "https://login.microsoftonline.com/common/oauth2/v2.0/token"

  def initialize
    # Try environment variables first, then fall back to Rails credentials
    @client_id = ENV["MICROSOFT_GRAPH_CLIENT_ID"] ||
      Rails.application.credentials.dig(:microsoft_graph, :client_id)
    @client_secret = ENV["MICROSOFT_GRAPH_CLIENT_SECRET"] ||
      Rails.application.credentials.dig(:microsoft_graph, :client_secret)
    @tenant_id = ENV["MICROSOFT_GRAPH_TENANT_ID"] ||
      Rails.application.credentials.dig(:microsoft_graph, :tenant_id)

    if @client_id.blank? || @client_secret.blank? || @tenant_id.blank?
      raise "Microsoft Graph credentials not configured. Please set either:\n" \
            "1. Environment variables: MICROSOFT_GRAPH_CLIENT_ID, MICROSOFT_GRAPH_CLIENT_SECRET, MICROSOFT_GRAPH_TENANT_ID\n" \
            "2. Rails credentials using 'rails credentials:edit'"
    end
  end

  def send_email(agatha_email, to_email)
    Rails.logger.debug("MicrosoftGraphService: Sending email via Microsoft Graph API")
    Rails.logger.debug("To: #{to_email}, Subject: #{agatha_email.subject}")

    begin
      access_token = get_access_token

      email_data = build_email_data(agatha_email, to_email)

      response = send_via_graph_api(email_data, access_token)

      if response.code == "202"
        Rails.logger.debug("MicrosoftGraphService: Email sent successfully")
        {success: true, message: "Email sent via Microsoft Graph"}
      else
        error_msg = "Failed to send email. HTTP Status: #{response.code}, Response: #{response.body}"
        Rails.logger.error("MicrosoftGraphService: #{error_msg}")
        {success: false, error: error_msg}
      end
    rescue => e
      error_msg = "Microsoft Graph API error: #{e.message}"
      Rails.logger.error("MicrosoftGraphService: #{error_msg}")
      Rails.logger.error(e.backtrace.join("\n"))
      {success: false, error: error_msg}
    end
  end

  private

  def get_access_token
    Rails.logger.debug("MicrosoftGraphService: Getting access token")

    uri = URI("https://login.microsoftonline.com/#{@tenant_id}/oauth2/v2.0/token")

    params = {
      "client_id" => @client_id,
      "client_secret" => @client_secret,
      "scope" => "https://graph.microsoft.com/.default",
      "grant_type" => "client_credentials"
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.body = URI.encode_www_form(params)

    response = http.request(request)

    if response.code == "200"
      token_data = JSON.parse(response.body)
      access_token = token_data["access_token"]
      Rails.logger.debug("MicrosoftGraphService: Access token obtained successfully")
      access_token
    else
      error_msg = "Failed to get access token. HTTP Status: #{response.code}, Response: #{response.body}"
      Rails.logger.error("MicrosoftGraphService: #{error_msg}")
      raise error_msg
    end
  end

  def build_email_data(agatha_email, to_email)
    # Map the from address using EmailAddressMapper
    original_from = extract_email_address(agatha_email.from_email)
    mapping_result = EmailAddressMapper.map_from_address(original_from)

    unless mapping_result[:success]
      Rails.logger.error "MicrosoftGraphService: #{mapping_result[:error]}"
      raise StandardError, mapping_result[:error]
    end

    actual_from = mapping_result[:send_from]
    reply_to = mapping_result[:reply_to]

    Rails.logger.debug "MicrosoftGraphService: #{mapping_result[:message]}"

    # Determine content type based on person preferences (default to HTML if not set)
    is_html = agatha_email.person&.html_email.nil? || agatha_email.person.html_email

    email_body = {
      message: {
        subject: agatha_email.subject,
        body: {
          contentType: is_html ? "HTML" : "Text",
          content: format_email_content(agatha_email.body, is_html)
        },
        toRecipients: [
          {
            emailAddress: {
              address: to_email.strip
            }
          }
        ],
        from: {
          emailAddress: {
            address: actual_from
          }
        },
        replyTo: [
          {
            emailAddress: {
              address: reply_to
            }
          }
        ]
      }
    }

    # Add attachments if any
    attachments = build_attachments(agatha_email)
    if attachments.any?
      email_body[:message][:attachments] = attachments
    end

    Rails.logger.debug("MicrosoftGraphService: Email data built - Subject: #{agatha_email.subject}")
    email_body
  end

  def format_email_content(content, is_html)
    # Handle nil content
    content = content.to_s if content.nil?

    if is_html
      # For HTML emails, use content as-is
      content
    else
      # For plain text emails, strip HTML tags (similar to existing logic)
      plain_text = content.dup
      plain_text = plain_text.gsub("&nbsp;", " ")
      plain_text = plain_text.gsub("&#39;", "'")
      plain_text = plain_text.gsub(/<br\s*\/?>/i, "\n")
      plain_text = plain_text.gsub(/<p\b[^>]*>(.*?)<\/p>/i, "\n\\1\n")
      plain_text = plain_text.gsub(/<div\b[^>]*>(.*?)<\/div>/i, "\n\\1\n")
      plain_text = plain_text.gsub(/<([A-z][A-z0-9]*)\b[^>]*>(.*?)<\/\1>/m, '\\2')
      plain_text = plain_text.gsub(/<[^>]+>/, "") # Remove any remaining HTML tags
      plain_text.strip
    end
  end

  def extract_email_address(from_email_string)
    # Extract clean email address from string like "<email@domain.com>"
    # Also clean up any template artifacts
    cleaned = from_email_string.to_s.gsub(/\s+/, "").split(";")[0]

    # Remove ERB template artifacts
    cleaned = cleaned.gsub("!--BEGINinlinetemplate--", "")
    cleaned = cleaned.gsub("!--ENDinlinetemplate--", "")

    # Remove angle brackets
    cleaned = cleaned.gsub(/[<>]/, "")

    # Remove trailing semicolons
    cleaned = cleaned.gsub(/;$/, "")

    cleaned.strip
  end

  def build_attachments(agatha_email)
    attachments = []

    # Get attachments through the email_attachments association
    # Handle case where email_attachments is nil (for testing)
    if agatha_email.email_attachments.present?
      agatha_email.email_attachments.includes(:agatha_file).each do |email_attachment|
        agatha_file = email_attachment.agatha_file

        if agatha_file&.agatha_data_file_name.present?
          begin
            # Read file content and encode as base64
            file_path = agatha_file.agatha_data.path
            if File.exist?(file_path)
              file_content = File.read(file_path)
              base64_content = Base64.strict_encode64(file_content)

              attachment = {
                "@odata.type" => "#microsoft.graph.fileAttachment",
                "name" => agatha_file.agatha_data_file_name,
                "contentType" => agatha_file.agatha_data_content_type || "application/octet-stream",
                "contentBytes" => base64_content
              }

              attachments << attachment
              Rails.logger.debug("MicrosoftGraphService: Added attachment - #{agatha_file.agatha_data_file_name}")
            else
              Rails.logger.warn("MicrosoftGraphService: Attachment file not found - #{file_path}")
            end
          rescue => e
            Rails.logger.error("MicrosoftGraphService: Error processing attachment #{agatha_file.agatha_data_file_name}: #{e.message}")
          end
        end
      end
    end

    attachments
  end

  def send_via_graph_api(email_data, access_token)
    # Use the mapped 'from' address for the API endpoint (the actual sender)
    from_email = email_data[:message][:from][:emailAddress][:address]

    uri = URI("#{GRAPH_API_URL}/users/#{from_email}/sendMail")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{access_token}"
    request["Content-Type"] = "application/json"
    request.body = email_data.to_json

    Rails.logger.debug("MicrosoftGraphService: Sending request to Microsoft Graph API")
    Rails.logger.debug("MicrosoftGraphService: Using sender address: #{from_email}")
    response = http.request(request)

    Rails.logger.debug("MicrosoftGraphService: API Response - Status: #{response.code}")
    if response.code != "202"
      Rails.logger.error("MicrosoftGraphService: API Response Body: #{response.body}")
    end

    response
  end
end
