# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.




class ApplicationController < ActionController::Base
 #before_action :validaccess, :except => :accessdenied
 # before_action :authorize, [:except => "/admin/login", :except => :accessdenied ]
  before_action :authorize
  
  helper :all # include all helpers, all the time

#  session :session_key => '_agatha_session_id'

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery with: :exception
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  


protected
  def authorize
    
Rails.logger.debug "ApplicationController:authorize a"
Rails.logger.debug "ApplicationController:authorize - Request: #{request.method} #{request.path}"
Rails.logger.debug "ApplicationController:authorize - User-Agent: #{request.user_agent}"
Rails.logger.debug "ApplicationController:authorize - Referer: #{request.referer}"

        current_ip = request.remote_ip 
        Rails.logger.debug "ApplicationController:authorize - Current IP: #{current_ip}, Session IP: #{session[:current_ip]}"
        Rails.logger.debug "ApplicationController:authorize - request.ip: #{request.ip}"
        Rails.logger.debug "ApplicationController:authorize - X-Forwarded-For: #{request.headers['X-Forwarded-For']}"
        Rails.logger.debug "ApplicationController:authorize - X-Real-IP: #{request.headers['X-Real-IP']}"
        Rails.logger.debug "ApplicationController:authorize - REMOTE_ADDR: #{request.env['REMOTE_ADDR']}"
        
        # Temporarily disable IP checking to debug session issues
        # TODO: Re-enable this after fixing the IP detection issues
        ip_check_enabled = false  # Set to true to re-enable IP checking
        
        if ip_check_enabled && (!session.key?(:current_ip) || session[:current_ip] != current_ip) #force logout if ip has changed
          Rails.logger.debug "ApplicationController:authorize b"
          Rails.logger.debug "ApplicationController:authorize - IP changed! Old: #{session[:current_ip]}, New: #{current_ip}"
          Rails.logger.debug "ApplicationController:authorize - Clearing session due to IP change"
           session[:current_ip] = current_ip
	   session[:valid_ip] = false
           session[:user_id] = nil
        end
        Rails.logger.debug "ApplicationController:authorize c"
        Rails.logger.debug "ApplicationController:authorize - session[:user_id] = #{session[:user_id].inspect}"
        Rails.logger.debug "ApplicationController:authorize - session[:user_id].class = #{session[:user_id].class}"
        
        user_record = User.find_by_id(session[:user_id])
        Rails.logger.debug "ApplicationController:authorize - User.find_by_id(#{session[:user_id]}) = #{user_record.inspect}"
        
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
