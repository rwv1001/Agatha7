class AgathaMailer < ApplicationMailer
  layout "mailer"

  # Class variable to store the last Microsoft Graph result
  @@last_microsoft_graph_result = nil

  def email
    agatha_email = params[:agatha_email]
    to_email = params[:to_email]
    @body_text = agatha_email.body
    Rails.logger.info("email body text = #{@body_text}")

    # Check if Microsoft Graph should be used
    use_microsoft_graph = Rails.application.config.respond_to?(:use_microsoft_graph) &&
      Rails.application.config.use_microsoft_graph

    if use_microsoft_graph
      # Use Microsoft Graph API to send email
      Rails.logger.info("AgathaMailer: Using Microsoft Graph to send email")
      graph_service = MicrosoftGraphService.new
      result = graph_service.send_email(agatha_email, to_email)

      # Store the result in class variable for controller to access
      @@last_microsoft_graph_result = result

      if result[:success]
        Rails.logger.info("AgathaMailer: Email sent successfully via Microsoft Graph result= #{result.inspect}")
      else
        Rails.logger.error("AgathaMailer: Microsoft Graph send failed: #{result[:error]}")
      end

      # Return a NullMail object since we're not using SMTP
      ActionMailer::Base::NullMail.new

    else
      # Microsoft Graph is disabled, but SMTP is not configured
      Rails.logger.error("AgathaMailer: Neither Microsoft Graph nor SMTP is configured")

      # Store error result in class variable
      @@last_microsoft_graph_result = {
        success: false,
        error: "Email sending is not configured - neither Microsoft Graph nor SMTP is available"
      }

      # Return a NullMail object
      ActionMailer::Base::NullMail.new
    end
  end

  # Helper method to get the last Microsoft Graph result
  def self.get_last_microsoft_graph_result
    @@last_microsoft_graph_result
  end

  # Clear the stored result (optional, for cleanup)
  def self.clear_last_result
    @@last_microsoft_graph_result = nil
  end
end
