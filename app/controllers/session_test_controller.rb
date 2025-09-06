class SessionTestController < ApplicationController
  layout "welcome"
  # Skip authorization for session testing
  skip_before_action :authorize

  def counter
    # Initialize counter if it doesn't exist
    session[:counter] ||= 0

    @counter_value = session[:counter]
    @last_update = session[:last_counter_update]

    Rails.logger.debug "🔢 Counter test - current value: #{@counter_value}"
    Rails.logger.debug "🔢 Last update: #{@last_update}"
    Rails.logger.debug "🔢 Session ID: #{session.id if session.respond_to?(:id)}"
  end

  def increment
    # Load current counter
    current_counter = session[:counter] || 0

    # Increment it
    new_counter = current_counter + 1

    # Save back to session
    session[:counter] = new_counter
    session[:last_counter_update] = Time.current.to_s

    Rails.logger.debug "🔢 INCREMENT - was: #{current_counter}, now: #{new_counter}"
    Rails.logger.debug "🔢 Session keys: #{session.keys.inspect}"

    # Force session commit for cookie store
    if session.respond_to?(:commit)
      session.commit
      Rails.logger.debug "🔢 Forced session commit"
    end

    redirect_to session_test_counter_path
  end

  def reset
    session[:counter] = 0
    session[:last_counter_update] = Time.current.to_s

    Rails.logger.debug "🔢 RESET counter to 0"

    redirect_to session_test_counter_path
  end
end
