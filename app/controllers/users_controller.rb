class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new_user
    Rails.logger.info("new_user params: #{params[:user]}");
    params[:user].permit!
    new_user = User.new(params[:user])   #
    save_status = new_user.save;

    respond_to do |format|
      format.js  { render "new_user", :locals => {:save_status => save_status, :new_user => new_user, :session => session } }
=begin      
      do
        if(save_status)
          render :update do |page|

             if session[:administrator]
                page.replace_html("user", :partial => "shared/create_user", :object => new_user );
             else
                page.replace_html("user", :partial => "shared/user", :object => new_user );
             end
             page << "alert(\"Username #{new_user.name} has been successfully created\")";
         #   page.replace_html("flash", :partial => "shared/flash", :object => "Username #{new_user.name} has been successfully created");

          end
        else
          render :update do |page|
            page << "alert(\"Unable to create new user\")";
           # page.replace_html("flash", :partial => "shared/flash", :object => "Unable to create new user");
          end
        end

      end
=end      
    end
  end

  def admin_update_user
    update_status = false;
    current_user = nil;
    if session[:administrator]
        current_user  = User.find(params[:user_id])
        update_status = false;
        if( current_user )
            params[:user].permit!
            current_user.update_attributes(params[:user])
            update_status = current_user.save;
        end
        respond_to do |format|
            format.js  { render "admin_update_user", :locals => {:update_status => update_status, :current_user => current_user } }
        end    
=begin        
        do
        if(update_status)
        render :update do |page|
        page.replace_html("user", :partial => "shared/create_user", :object => current_user );
        page << "alert(\"Username #{current_user.name} has been successfully updated\")";
        #  page.replace_html("flash", :partial => "shared/flash", :object => "Username #{current_user.name} has been successfully updated");

        end
        else
        render :update do |page|
        page << "alert(\"Unable to update user. Make sure new password and confirm password are identical\")";
        # page.replace_html("flash", :partial => "shared/flash", :object => "Unable to update user");
        end
        end

        end
=end  
    else
        alert_str = "You do not have admin rights";
        respond_to do |format|
            format.js { render "shared/alert", :locals => {:alert_str => alert_str} }
        end
    end
  end            
            
=begin            
    do
        render :update do |page|
        page << "alert(\"You do not have admin rights\")";
        #    page.replace_html("flash", :partial => "shared/flash", :object => "You do not have admin rights");
        end
    end
=end     



  def update_user
    @user = User.find(params[:user_id])
    current_user = User.authenticate(@user.name, params[:old_password])
    update_status = false;
    if( current_user )
      current_user.update_attributes(params[:user])
      update_status = current_user.save;
    end
     
    respond_to do |format|
      format.js  { render "update_user.js.erb", :locals => { :update_status => update_status , :current_user => current_user } }
    end
  end
=begin      
      do
        if(update_status)
          render :update do |page|
            page.replace_html("user", :partial => "shared/user", :object => current_user );
            page.replace_html("flash", :partial => "shared/flash", :object => "Username #{current_user.name} has been successfully updated");

          end
        else
          render :update do |page|
            page.replace_html("flash", :partial => "shared/flash", :object => "Unable to update user");
          end
        end

      end
    end

  end
=end  
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @table_name = params[:table_name];
    @id = params[:id];

    @short_name = session[:search_ctls][@table_name].GetShortField(@id );

    edit_helper(@table_name,[]);
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = "User #{@user.name} was successfully created."
        format.html { redirect_to(:action=>'index') }
        format.xml  { render :xml => @user, :status => :created,
          :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors,
          :status => :unprocessable_entity }
      end
    end
  end
  def win_load

    win_load_helper();

  end

  def win_unload
    win_unload_helper();



  end
  # PUT /users/1
  # PUT /users/1.xml
  def updater
    @user = User.find(params[:id])

    user = User.authenticate(@user.name, params[:user][:old_password])
    new_password = params[:user][:password]
    flash[:notice] = ""
    flash_comma = ""

    if params[:user][:password] == params[:user][:password_confirmation]
      confirmed_password = true
    else
      confirmed_password =false
      flash[:notice] = "ERROR: Confirmation password is not the same"
      flash_comma = ", "
    end

    is_not_blank = !params[:user][:password].blank?
    if !is_not_blank
      flash[:notice] = flash[:notice] + flash_comma + "ERROR: Password is blank"
      flash_comma = ", "
    end
    if user == nil
      flash[:notice] = flash[:notice] + flash_comma + "ERROR: Old password is incorrect"
      flash_comma = ", "
    end
    user_name_ok = true
    if @user.name != params[:user][:name]
      if User.find_by_name(params[:user][:name])
        user_name_ok = false
        flash[:notice] = flash[:notice] + flash_comma + "ERROR: Username already exists in database"
      end
    end

    if user && is_not_blank  && confirmed_password && user_name_ok

      update_status = true
      @user.name =  params[:user][:name]
      @user.hashed_password = User.encrypted_password(params[:user][:password], @user.salt)
      if !@user.save
        update_status = false
        flash[:notice] = "ERROR: Unable to save user #{@user.name} to database "
      end
    else
      update_status = false
    end
    respond_to do |format|
      if update_status
        flash[:notice] = "User #{@user.name} was successfully updated."
        format.html { redirect_to(:action=>'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors,
          :status => :unprocessable_entity }
      end


    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    begin
      flash[:notice] = "User #{@user.name} deleted"
      @user.destroy
    rescue Exception => e
      flash[:notice] = e.message
    end

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  
  end

end

