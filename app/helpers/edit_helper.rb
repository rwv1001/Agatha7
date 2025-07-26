
module EditHelper
def edit_helper(table_name, readonly_fields)
    
    @table_name = table_name;
    @user_id = session[:user_id];
#    session["#{@table_name}_readonly_fields"]= readonly_fields;
    id = params[:id];
    time_out = 20*60;
    sql_str = "OpenRecord.find_by_sql(\"SELECT * FROM  open_records WHERE (table_name = '" + @table_name + "' AND  record_id = " +id.to_s + "  AND in_use = true)\")"
    open_records = eval(sql_str)
    record_present = false
    if  open_records.length >0
    
    open_record = open_records[0]
    update_time = open_record.updated_at;
    time_now = Time.now;
    time_diff = time_now -  update_time;
    if time_diff < time_out
        record_present = true;
    elsif open_record.user_id == @user_id
        record_present = true;
    else
        record_present = false;
        open_record.in_use = false; #have a timeout just in case a user closes record whilst disconnected from database
        open_record.save;        
    end
    end

    allow_edit = false;

    if !record_present || open_record.user_id == @user_id
    allow_edit = true; # will end up here only if close record when disconnected from the database - the session will be new but record still flagged as open in open_record table.
    else
    allow_edit = false;
    end
    

    if allow_edit
    
    object_str = "#{@table_name}.find(id)";
    attribute_eval_str = "AttributeList.new(#{@table_name})"
#    unless session[attribute_eval_str]
        @attribute_list = AttributeList.new(@table_name);
#     session[attribute_eval_str] = @attribute_list;
#    else
#      @attribute_list = session[attribute_eval_str];
#    end
    # @attribute_list = AttributeList.new(@table_name);
    @search_ctls = session[:search_ctls];
    

    @filter_controller = FilterController.new(@search_ctls, @table_name, @user_id)
    new_current_object  = eval(object_str );
    if new_current_object
        @current_object  = new_current_object
    end
    if new_current_object
        @edit_object = EditObject.new(new_current_object, @attribute_list, @filter_controller , @table_name, readonly_fields)
        x =1 ;
        respond_to do |format|
        format.html {render :controller => @table_name.tableize, :action => "edit"  }
        end
    else
        fail_str = "Failed  to find #{@table_name}  with id #{id}."
        flash[:notice] = fail_str;
        respond_to do |format|
        format.html   { redirect_to(welcome_url) }
        end
    end

    else
    user = User.find(open_record.user_id)
    bar_edit_message = "User " + user.name+ " is currently working on the " + @table_name + " record, id = " + id + ". Last updated: " + open_record.updated_at.to_s;
    bar_table_name = @table_name.tableize;
    bar_class_name = @table_name;
    bar_id = id;
    @bar_object = BarObject.new(bar_edit_message,bar_table_name, bar_class_name , bar_id)
    
    respond_to do |format|
        format.html {render :controller => @table_name.tableize, :action => "bar_record"  }
    end
    end



end
def win_load_helper
    user_id = session[:user_id];
    id = params[:id];
    @table_name = params[:table_name];
    sql_str = "OpenRecord.find_by_sql(\"SELECT * FROM  open_records WHERE (table_name = '" + @table_name + "' AND  record_id = " +id.to_s + " AND user_id = " + user_id.to_s + "  AND in_use = true)\")"
    open_records = eval(sql_str)
    if open_records.length == 0
    open_record = OpenRecord.new;
    open_record.table_name = @table_name;
    open_record.record_id = id;
    open_record.user_id = user_id;
    open_record.in_use = true;
    open_record.save;
    end
    session_div = 1;

    respond_to do |format|
    format.js  { render :partial => "shared/win_load_helper", :locals => {:session_div => session_div}  }
=begin      
    do
        render :update do |page|
       
        page.replace_html("session_div", :partial => "shared/session_div", :object => session_div);
        end
    end
=end
    end
end
def win_unload_helper
    Rails.logger.info("win_unload_helper rwv begin");
    @id = params[:id];
    @table_name = params[:table_name];
    attribute_name = params[:field_name];
    @user_id = session[:user_id];


    sql_str = "OpenRecord.find_by_sql(\"SELECT * FROM  open_records WHERE (user_id = " + @user_id.to_s + " AND table_name = '" + @table_name + "' AND  record_id = " +@id.to_s + "  AND in_use = true)\")"
    open_records = eval(sql_str)
    if(open_records.length >0)
    open_records[0].in_use = false;
    open_records[0].save;
 
    session_div = 1;
    respond_to do |format|
        format.js { render  :partial => "shared/win_unload_helper", :locals => {:session_div => session_div, :table_name => @table_name, :id => @id, :attribute => attribute_name }  }
=begin        
        do
        render :update do |page|
            session_div = 1;
            page.replace_html("session_div", :partial => "shared/session_div", :object => session_div);
        end
        end
=end        
    end

    else
    Rails.logger.info("win_unload_helper rwv NOT updated record");
    respond_to do |format|
        format.js { render :partial => "shared/win_unload_helper_blank" }
=begin        
        do
        render :update do |page|
            blank_popup_div  = "This page has expired";
            page.replace_html("main_div", :partial => "shared/blank_popup_div", :object =>  blank_popup_div );
        end
        end\
=end        
    end
    end

end
def update_helper()
    @user_id = session[:user_id];
    id = params[:id];
    @table_name = params[:table_name];
    field_value = params[:field_value];
    field_name = params[:field_name];
    #  readonly_fields = session["#{@table_name}_readonly_fields"]
    Rails.logger.info("update_helper(), table_name = #{@table_name}, field_value = #{field_value}, field_name = #{field_name}");

    sql_str = "OpenRecord.find_by_sql(\"SELECT * FROM  open_records WHERE (user_id = " + @user_id.to_s + " AND table_name = '" + @table_name + "' AND  record_id = " +id.to_s + "  AND in_use = true)\")"
    Rails.logger.info("update_helper sql_str = #{sql_str}");
    open_records = eval(sql_str)

    if(open_records.length == 0 ) #1
        blank_div = "This page has expired";
        respond_to do |format| 
            format.js { render :partial => "shared/blank", :locals => {:blank_div => blank_div} }
=begin        
do
render :update do |page|

page.replace_html("main_div", :partial => "shared/blank_div", :object => blank_div);
end
end
=end        
        end
    else #1
        object_str = "#{@table_name}.find(id)"
        object = eval(object_str)
        if object == nil #2
            blank_div = "#{@table_name} record with id = #{id} could not be found. I guess this means another user has just deleted this record. They shouldn't have been able to do this because you should have been the current owner of the file.  So if your reading this, it means there is a bug in Agatha";
            respond_to do |format| #3
                format.js  { render :partial => "shared/blank", :locals => {:blank_div => blank_div} }
=begin           
            do
            render :update do |page|

            page.replace_html("main_div", :partial => "shared/blank_div", :object => blank_div);
            end
            end
=end           
            end #3
        else #2
            open_record = open_records[0];
            open_record.save;
            update_str = "object.update(#{field_name}: %q(#{field_value}))";
            Rails.logger.info("RWV update_str = #{update_str}")
            if field_name.strip().length != 0
                Rails.logger.info("update_helper updating *#{field_name}*")
                eval(update_str);

                save_ok = false;
                exception_str = ""
                begin
                    object.save;
                    save_ok = true;
                    rescue Exception => exc
                    exception_str = "An update error has occurred. Perhaps you already have #{@table_name} with these details.";
                end
                if save_ok  #4
                    Rails.logger.info("update_helper save_ok")
                    attribute_eval_str = "AttributeList.new(#{@table_name.classify})"
                    @attribute_list = AttributeList.new(@table_name.classify);
                    @search_ctls = session[:search_ctls]
                    attribute1 = @attribute_list.attribute_hash[field_name]
                    Rails.logger.info("update_helper attribute1.name = #{attribute1.name}");
                    if attribute1.foreign_key.length >0
                    @filter_controller = FilterController.new(@search_ctls, @table_name, @user_id)
                    end
                    update_parent = true;
                    readonly_flag = false;  
                    edit_cell1 = EditCell.new(attribute1, object, @table_name, @filter_controller, update_parent,readonly_flag );       
                    attribute2 = @attribute_list.attribute_hash["updated_at"];  
                    update_parent = false;
                    edit_cell2 = EditCell.new(attribute2, object, @table_name, @filter_controller, update_parent,readonly_flag);
                    respond_to do |format| #5
                        format.js { render :partial => "shared/update_helper", :locals => {:table_name => @table_name, :field_name => field_name, :edit_cell1 => edit_cell1, :edit_cell2 => edit_cell2, :attribute => attribute1, :id => id , :search_ctls => @search_ctls} }
                    end #5
                else #4
                    respond_to do |format|
                        format.js { render :partial => "shared/alert", :locals => {:alert_str => exception_str } }
                    end 
                end #4
            else 
                Rails.logger.info("update_helper do nothing");
                respond_to do |format|
                    format.js { render :partial => "shared/do_nothing" }
                end   
            end 
        end #2
    end #1
end        
=begin          
        do
            render :update do |page|
            if save_ok

                attribute_eval_str = "AttributeList.new(#{@table_name.classify})"
                @attribute_list = AttributeList.new(@table_name.classify);
                @search_ctls = session[:search_ctls]
                attribute = @attribute_list.attribute_hash[field_name]
                if attribute.foreign_key.length >0
                @filter_controller = FilterController.new(@search_ctls, @table_name, @user_id)
                end
                update_parent = true;
                readonly_flag = false;
    #          if readonly_fields.index(field_name) == nil
    #       readonly_flag = false
    #       else
    #       readonly_flag = true
    #     end
                edit_cell = EditCell.new(attribute, object, @table_name, @filter_controller, update_parent,readonly_flag );
                page.replace_html("#{@table_name}_#{field_name}", :partial => "shared/edit_cell", :object => edit_cell);
                attribute = @attribute_list.attribute_hash["updated_at"]
                update_parent = false;
                edit_cell = EditCell.new(attribute, object, @table_name, @filter_controller, update_parent,readonly_flag);
                page.replace_html("#{@table_name}_updated_at", :partial => "shared/edit_cell", :object => edit_cell);
            else
                page << "alert('#{exception_str}')";
            end
            end
        end
=end           




def email_update()
    @user_id = session[:user_id];
    id = params[:id];
    @table_name = params[:table_name];
    field_value = params[:field_value];
    body_value = params[:body_value];
    field_name = params[:field_name];
    closing_flag = params[:closing_flag].to_i;


    sql_str = "OpenRecord.find_by_sql(\"SELECT * FROM  open_records WHERE (user_id = " + @user_id.to_s + " AND table_name = '" + @table_name + "' AND  record_id = " +id.to_s + "  AND in_use = true)\")"
    open_records = eval(sql_str)

    if(open_records.length == 0 )#1
    blank_div = "This page has expired";
    respond_to do |format|
        format.js { render "shared/blank", :locals => {:blank_div => blank_div} }
=begin        
        do
        render :update do |page|
            
            page.replace_html("main_div", :partial => "shared/blank_div", :object => blank_div);
        end
        end
=end        
    end
    else #1
    object_str = "#{@table_name}.find(id)"
    object = eval(object_str)
    if object == nil #2
    blank_div = "#{@table_name} record with id = #{id} could not be found. I guess this means another user has just deleted this record. They shouldn't have been able to do this because you should have been the current owner of the file.  So if your reading this, it means there is a bug in Agatha";
        respond_to do |format|
        format.js  { render "shared/blank", :locals => {:blank_div => blank_div} }
=begin          
        do
            render :update do |page|
            
            page.replace_html("main_div", :partial => "shared/blank_div", :object => blank_div);
            end
        end
=end           
        end
    else#2
        open_record = open_records[0];
        open_record.save;
        if body_value !=nil && body_value.length !=0
        object.body = body_value;
        end
        if field_name.length != 0
        update_str ="object.update(#{field_name}: %q({field_value}))";
        eval(update_str);
        end

        save_ok = false;
        exception_str = ""
        begin
        object.save;
        save_ok = true;
        rescue Exception => exc
        exception_str = "An update error has occurred. Perhaps a uniqueness criteria has been violated. Do you already have #{@table_name} with these details?";
        end
            if closing_flag == 0 #3
                if save_ok #4
                attribute_eval_str = "AttributeList.new(#{@table_name.classify})"

        #       unless session[attribute_eval_str]
                    @attribute_list = AttributeList.new(@table_name.classify);
            #       session[attribute_eval_str] = @attribute_list;
            #    else
            #     @attribute_list = session[attribute_eval_str];
            #   end

                # @attribute_list = AttributeList.new(@table_name.classify)
                @search_ctls = session[:search_ctls]

                edit_cell1 = nil;
                edit_cell2 = nil;
                edit_cell3 = nil;
                if field_name.length != 0 #5
                    attribute = @attribute_list.attribute_hash[field_name]
                    if attribute.foreign_key.length >0 #6
                    @filter_controller = FilterController.new(@search_ctls, @table_name, @user_id)
                    end #6
                    update_parent = true;
                    read_only_flag = false;
                    edit_cell1 = EditCell.new(attribute, object, @table_name, @filter_controller, update_parent, read_only_flag  );
                    #page.replace_html("#{@table_name}_#{field_name}", :partial => "shared/edit_cell", :object => edit_cell);
                else #5
                    attribute = @attribute_list.attribute_hash["body"]
                    if attribute.foreign_key.length >0#7
                    @filter_controller = FilterController.new(@search_ctls, @table_name, @user_id)
                    else#7
                    if body_value !=nil && body_value.length !=0 #8
                        update_parent = true;
                        edit_cell2 = EditCell.new(attribute, object, @table_name, @filter_controller, update_parent, read_only_flag  );
                        #page.replace_html("#{@table_name}_body", :partial => "shared/edit_cell", :object => edit_cell);
                        #page << "yahoo_widget()";
                    else
                        #page << "add_blur_listener(); myEditor.saveHTML();editBlur(\"\",\"\")";
                    end #8
                    end #7
                end #5
                attribute = @attribute_list.attribute_hash["updated_at"]
                edit_cell3 = EditCell.new(attribute, object, @table_name, @filter_controller, update_parent, read_only_flag  );
                #page.replace_html("#{@table_name}_updated_at", :partial => "shared/edit_cell", :object => edit_cell);
                if(field_name.length == 0)

                end
                
                respond_to do |format| #9
                format.js  { render :partial => "shared/email_update", :locals => {:edit_cell1 => edit_cell1, :edit_cell2 => edit_cell2, :edit_cell3 => edit_cell3, :table_name => @table_name, :field_name => field_name } }
                end #9
                end  #4 
                        
            else#3
                #page << "alert('#{exception_str}')";
                respond_to do |format|#3
                    format.js {render :partial => "shared/alert", :locals => {:alert_str => exception_str} }
                end

            end #3        

        end #2
    end #1

end
end
