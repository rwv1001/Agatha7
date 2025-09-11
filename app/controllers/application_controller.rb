# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.




class ApplicationController < ActionController::Base
 #before_action :validaccess, :except => :accessdenied
 # before_action :authorize, [:except => "/admin/login", :except => :accessdenied ]
  before_action :authorize, except: [:render_404]
  
  # Add error handling for routing errors
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  
  helper :all # include all helpers, all the time

#  session :session_key => '_agatha_session_id'

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery with: :exception
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  # Helper method for notification alerts
  def notification_alert(message, type = 'success')
    escaped_message = message.gsub("'", "\\'")
    "if (window.showNotification) { window.showNotification('#{escaped_message}', '#{type}'); } else { alert('#{escaped_message}'); }"
  end

  # Handle 404 errors gracefully - public so it can be used as a route action
  def render_404
    respond_to do |format|
      format.html { render file: Rails.public_path.join('404.html'), status: :not_found, layout: false }
      format.json { render json: { error: 'Page not found' }, status: :not_found }
      format.any  { head :not_found }
    end
  end

private


protected
  def authorize
    
Rails.logger.debug "ApplicationController:authorize a"
Rails.logger.debug "ApplicationController:authorize - Request: #{request.method} #{request.path}"
Rails.logger.debug "ApplicationController:authorize - User-Agent: #{request.user_agent}"
Rails.logger.debug "ApplicationController:authorize - Referer: #{request.referer}"

        # Track suggest_course_id at the start of authorize
        Rails.logger.debug "ApplicationController:authorize - suggest_course_id at start: #{session[:suggest_course_id].inspect}"

        # Get the real client IP, accounting for Docker/proxy setups
        current_ip = request.headers['X-Forwarded-For']&.split(',')&.first&.strip ||
                     request.headers['X-Real-IP'] ||
                     request.remote_ip ||
                     request.ip
        
        Rails.logger.debug "ApplicationController:authorize - Current IP: #{current_ip}, Session IP: #{session[:current_ip]}"
        Rails.logger.warn "🔍 DETAILED IP DEBUG:"
        Rails.logger.warn "🔍   Final current_ip: #{current_ip}"
        Rails.logger.warn "🔍   request.remote_ip: #{request.remote_ip}"
        Rails.logger.warn "🔍   request.ip: #{request.ip}"
        Rails.logger.warn "🔍   X-Forwarded-For: #{request.headers['X-Forwarded-For']}"
        Rails.logger.warn "🔍   X-Real-IP: #{request.headers['X-Real-IP']}"
        Rails.logger.warn "🔍   REMOTE_ADDR: #{request.env['REMOTE_ADDR']}"
        Rails.logger.warn "🔍   HTTP_X_FORWARDED_FOR: #{request.env['HTTP_X_FORWARDED_FOR']}"
        Rails.logger.debug "ApplicationController:authorize - request.ip: #{request.ip}"
        Rails.logger.debug "ApplicationController:authorize - X-Forwarded-For: #{request.headers['X-Forwarded-For']}"
        Rails.logger.debug "ApplicationController:authorize - X-Real-IP: #{request.headers['X-Real-IP']}"
        Rails.logger.debug "ApplicationController:authorize - REMOTE_ADDR: #{request.env['REMOTE_ADDR']}"
        
        # Re-enable IP checking with improved Docker-aware IP detection
        ip_check_enabled = true  # Set to false to disable IP checking
        
        Rails.logger.warn "🔍 IP CHECK DEBUG: ip_check_enabled=#{ip_check_enabled}, session has current_ip: #{session.key?(:current_ip)}, stored IP: #{session[:current_ip]}, current IP: #{current_ip}"
        
        # Always update the current_ip in session to track the real IP
        if current_ip && current_ip != session[:current_ip]
          Rails.logger.warn "🔍 IP changed from '#{session[:current_ip]}' to '#{current_ip}' - updating session"
          session[:current_ip] = current_ip
        end
        
        if ip_check_enabled && current_ip && (!session.key?(:current_ip) || session[:current_ip] != current_ip) #force logout if ip has changed
          Rails.logger.debug "ApplicationController:authorize b"
          Rails.logger.debug "ApplicationController:authorize - IP changed! Old: #{session[:current_ip]}, New: #{current_ip}"
          Rails.logger.debug "ApplicationController:authorize - Clearing session due to IP change"
          Rails.logger.debug "ApplicationController:authorize - suggest_course_id before IP clear: #{session[:suggest_course_id].inspect}"
           session[:current_ip] = current_ip
	         session[:valid_ip] = false
           session[:user_id] = nil
          Rails.logger.debug "ApplicationController:authorize - suggest_course_id after IP clear: #{session[:suggest_course_id].inspect}"
        else
          Rails.logger.warn "🔍 IP CHECK DEBUG: IP check passed or skipped - user_id should remain intact"
        end
        Rails.logger.debug "ApplicationController:authorize c"
        Rails.logger.warn "🔍 SESSION DEBUG: Before user lookup - session[:user_id] = #{session[:user_id].inspect}"
        Rails.logger.warn "🔍 SESSION DEBUG: Session keys present: #{session.keys.sort}"
        Rails.logger.debug "ApplicationController:authorize - session[:user_id] = #{session[:user_id].inspect}"
        Rails.logger.debug "ApplicationController:authorize - session[:user_id].class = #{session[:user_id].class}"
        Rails.logger.debug "ApplicationController:authorize - session current ip: #{session[:current_ip].inspect}"
        
        user_record = User.find_by_id(session[:user_id])
        Rails.logger.debug "ApplicationController:authorize - User.find_by_id(#{session[:user_id]}) = #{user_record.inspect}"
        Rails.logger.debug "ApplicationController:authorize - suggest_course_id at end: #{session[:suggest_course_id].inspect}"
        
        unless user_record
            Rails.logger.debug "ApplicationController:authorize d - User not found, redirecting to login"
            Rails.logger.debug "ApplicationController:authorize - Session contents: #{session.to_hash.inspect}"
            Rails.logger.debug "ApplicationController:authorize - Session ID: #{session.id rescue 'N/A'}"
            flash[:notice] = "Please log in"
            redirect_to :controller => :admin, :action => :login
        else
            Rails.logger.debug "ApplicationController:authorize - User found: #{user_record.name} (ID: #{user_record.id})"
        end
     
  end
  def validaccess
      


      
  end
end
