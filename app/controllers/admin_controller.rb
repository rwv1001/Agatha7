

class AdminController < ApplicationController
#  before_action :valid_ip, :except => :accessdenied
  # just display the form and wait for user to
  # enter a name and password
  # 
  skip_before_action :authorize, only: [:login, :logout, :accessdenied]

  
  def login
    Rails.logger.debug "AdminController:login a"

    
    
    
     if !session.key?(:valid_ip) || session[:valid_ip] == false
      Rails.logger.debug "AdminController:login b"
         current_ip = request.remote_ip
         if current_ip =~ /(127\.0\.0\.1|163\.1\.170\..*|192\.168\.1\..*|10\.100\.1\..*|129\.67\..*\..*|10\.67\.236\..*)/
            Rails.logger.debug "AdminController:login c"
            session[:valid_ip] = true
            
         else
          Rails.logger.debug "AdminController:login d"
             
            flash.now[:notice] = "Access denied!"
            redirect_to :controller => :welcome, :action => :accessdenied 
            return
         end
    end 
    Rails.logger.debug "Session keys: #{session.keys}"
session.each { |k, v| Rails.logger.debug "#{k}: #{v.class}" } 
    Rails.logger.debug "AdminController:login e"
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      Rails.logger.debug "AdminController:login f"
      if user
        Rails.logger.debug "AdminController:login g"
        session[:user_id] = user.id
        
        admin_group = Group.where(:group_name => "Administrator", :table_name => "users").first;
        if(admin_group == nil)
          Rails.logger.debug "AdminController:login h"
          Group.create(:group_name => 'Not Set', :table_name => '', :owner_id => User.where(:name => "agathaapp").first.id, :private => true, :readers_id => 0, :writers_id => 0)
          Group.create(:group_name => 'Administrator', :table_name => 'users', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
          admin_group = Group.where(:group_name => "Administrator", :table_name => "users").first
          admin_group.readers_id = admin_group.id
          admin_group.writers_id = admin_group.id
          GroupUser.create(:group_id => Group.where(:group_name => "Administrator", :table_name => "users").first.id, :user_id =>  User.where(:name => "agathaapp").first.id)
          admin_group = Group.where(:group_name => "Administrator", :table_name => "users").first;
        end
        Rails.logger.debug "AdminController:login i"
        if GroupUser.exists?(["user_id = #{session[:user_id]} AND group_id = #{admin_group.id}"])
          Rails.logger.debug "AdminController:login j"
          session[:administrator] = true;
          update_terms
        else
          Rails.logger.debug "AdminController:login k"
          session[:administrator] = false;
        end
        Rails.logger.debug "AdminController:login l"
        redirect_to( { :controller=> :welcome, :action => :index })

      else
        Rails.logger.debug "AdminController:login m"
        flash.now[:notice] = "Invalid user/password combination"
        redirect_to :controller => :admin, :action => :accessdenied
      end
    else
      Rails.logger.debug "AdminController:login n"
      
    end
  end
  def update_terms
    today = Date::today;
    max_year_objs = Term.find_by_sql("SELECT * FROM terms WHERE id != #{SearchController::NOT_SET} ORDER BY year DESC, term_name_id DESC LIMIT 1");
    if max_year_objs.length == 0
      session[:current_term] == SearchController::NOT_SET;
      return;
    end
    year = max_year_objs[0].year;
    upper_year = (5+today.year)
    if year  < upper_year
      max_term_obj  = TermName.find_by_sql("SELECT * FROM term_names  ORDER BY id DESC LIMIT 1");
      max_term = max_term_obj[0].id
      
      term = max_year_objs[0].term_name_id+1;
      while year <= upper_year
        if(term<=max_term)
          term_obj = Term.new;
          term_obj.term_name_id = term;
          term_obj.year = year;
          term_obj.save;
        else
          term = SearchController::NOT_SET;
          year = year+1;
          
        end
        term = term+1;
      end
    end


      year = today.year;
      if today.month >= 6 && today.month <12
        term_name_id = 4;
      elsif today.month == 12 || today.month < 3
        term_name_id = 2;
        if today.month == 12
          year = today.year+1;
        end
      else
        term_name_id = 3;
      end
      session[:current_term] = Term.where(:term_name_id => term_name_id, :year => year).first.id;
  end
  
  def logout
    Rails.logger.debug "AdminController:logout session[:user_id] = #{session[:user_id].inspect} before logout"
    session[:user_id] = nil
    session[:search_ctls] = nil;
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end

  def accessdenied

  end
    def valid_ip

  end


  
end

