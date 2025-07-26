#require 'ruby-prof'
include EditHelper

class PeopleController < ApplicationController
  protect_from_forgery :only => [:create, :updater, :destroy]

 
  def destroy()
    Rails.logger.info("rwv People Destroy");
    respond_to do |format|
      format.js
    end
  end

  def test()
    Rails.logger.info("rwv People test");
    respond_to do |format|
      format.js
    end
  end

    
  
  def edit
 #   RubyProf.start
    @table_name = "Person";
    @id = params[:id];
   
    @short_name = session[:search_ctls][@table_name].GetShortField(@id );

    
    if session[:administrator]
      @user = User.where(:person_id => @id).first
      if @user == nil      
        @user = User.create(:person_id => @id, :name => '');
       end
    else
      my_id = session[:user_id];
      @user = User.where(:id=>  my_id, :person_id => @id).first
    end
    edit_helper(@table_name, []);


#          result = RubyProf.stop
# printer = RubyProf::GraphHtmlPrinter.new(result)
# file = File.open('profile-graph-edit.html', File::WRONLY |  File::CREAT)

  #  my_str = "";
# printer.print(file, :min_percent=>0)
# Rails.logger.error("Does this work?");
#file.close
  end





  def win_load
   
    win_load_helper();

  end
  
  def win_unload
    win_unload_helper();
  


  end

  def updater
    update_helper();

  end


 


 
end


