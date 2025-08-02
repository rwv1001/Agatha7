module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user_id

    def connect
      self.current_user_id = find_verified_user
    end

    private

    def find_verified_user
      # Access the session through the request environment
      # Rails stores session data in the request env
      session = request.session
      
      if session[:user_id]
        session[:user_id]
      else
        reject_unauthorized_connection
      end
    end
  end
end
