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
  protect_from_forgery :secret => 'bfbdd14f1e9f26c30e848e9f3ed30d2c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  


protected
  def authorize
    
Rails.logger.debug "ApplicationController:authorize a"

        current_ip = request.remote_ip 
        if !session.key?(:current_ip) || session[:current_ip] != current_ip #force logout if ip has changed
          Rails.logger.debug "ApplicationController:authorize b"
           session[:current_ip] = current_ip
	   session[:valid_ip] = false
           session[:user_id] = nil
        end
        Rails.logger.debug "ApplicationController:authorize c"
        unless User.find_by_id(session[:user_id])
            flash[:notice] = "Please log in"
            Rails.logger.debug "ApplicationController:authorize d"
            redirect_to :controller => :admin, :action => :login
        end
     
  end
  def validaccess
      


      
  end
end
