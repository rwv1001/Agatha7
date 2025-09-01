# coding: utf-8
#require 'ruby-prof'
require 'ostruct'

class Dependency
  attr_reader :dependent_table;
  attr_reader :dependent_ids;
  def initialize(dependent_table, dependent_ids)
    @dependent_table = dependent_table
    @dependent_ids = dependent_ids
  end
end

include FilterHelper
include ModelDependencyHelper
class WelcomeController < ApplicationController
 
skip_before_action :authorize, only: [:index]
layout "welcome"



  def string_update
    String.class_eval do
      def pl(n)       
        ret_val = "";
        if( n == 0 || n > 1)
          if self == "0"
            ret_val = "No"
          elsif self =~ /^\d+$/
            ret_val = str;
          elsif self == "was"
            ret_val ="were"
          elsif self == "does"
            ret_val = "do"
          elsif self == "a"
            ret_val = ""
          elsif self == "has"
            ret_val = have
          else
            ret_val = self.pluralize;
          end
        else
          ret_val = self;
        end        
      end
    end
  end


  def index
      unless session[:user_id]
        redirect_to controller: :admin, action: :login
        return
      end
    if session[:user_id]==1 && Person.first == nil
      import_csv
    end
  
 
    
    user_id=session[:user_id];
    Rails.logger.debug("WelcomeController:index a #{user_id}");

    @format_controller = FormatController.new(user_id);
    @all_group_filters = FilterController.GetAllGroupFilters(user_id);
  
    session[:format_controller] = @format_controller

    string_update
   
    unless session[:search_ctls]
      create_external_filters(session);
       Rails.logger.debug("WelcomeController:index Session does not have search_ctls, calling InitializeSessionController");
       InitializeSessionController()
       Rails.logger.debug("WelcomeController:index Session search_ctls initialized");
  #    Rails.logger.error("inialization index");
    else
   #   Rails.logger.error("no need for initialization");
      
    end
    Rails.logger.debug("WelcomeController:index a");
    
    @search_ctls = session[:search_ctls];
    @attr_lists = session[:attr_lists];
    Rails.logger.debug("WelcomeController:index b");
 
    @search_ctls.each do |table_name, search_ctl|
      Rails.logger.debug("WelcomeController:index calling UpdateFiltersFromDB with table_name: #{table_name}");
      search_ctl.UpdateFiltersFromDB
    end

    Rails.logger.debug("WelcomeController:index d");
    Rails.logger.flush
    
    # Add session counter for display
    @session_counter = session[:counter] || 0
  
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @people }
    end
    Rails.logger.debug("WelcomeController:index e");
    Rails.logger.flush
      x = 1;
  end
  
  def get_session_counter
    counter_value = session[:counter] || 0
    last_update = session[:last_counter_update]
    
    render json: {
      counter: counter_value,
      last_update: last_update
    }
  end
  
  def increment_session_counter
    current_counter = session[:counter] || 0
    new_counter = current_counter + 1
    
    session[:counter] = new_counter
    session[:last_counter_update] = Time.current.to_s
    
    Rails.logger.info "🔢 Welcome: Counter incremented from #{current_counter} to #{new_counter}"
    
    render json: {
      counter: new_counter,
      last_update: session[:last_counter_update],
      success: true
    }
  end
  
  def reset_session_counter
    session[:counter] = 0
    session[:last_counter_update] = Time.current.to_s
    
    Rails.logger.info "🔢 Welcome: Counter reset to 0"
    
    render json: {
      counter: 0,
      last_update: session[:last_counter_update],
      success: true
    }
  end
  
  def inactive_user_pages(except_page_name)
    user_pages = UserPage.find(:all, :conditions =>{ :user_id => @user_id});
    user_pages.each do |user_page|
      if(except_page_name!=user_page.page_name)
      user_page.is_active = false;
      user_page.save;
      end
    end
  end



  def InitializeSessionController()

    table_options = ["Person","Attendee","GroupPerson","GroupLecture","GroupCourse","GroupAttendee", "GroupTutorial","GroupTutorialSchedule", "GroupInstitution", "GroupUser","GroupTerm","GroupDay","GroupLocation","GroupWillingLecturer","GroupWillingTutor","Lecture","TutorialSchedule","Tutorial","WillingTeacher","WillingLecturer","WillingTutor","EmailTemplate","AgathaEmail", "GroupEmailTemplate","GroupAgathaEmail","Course","Group","Location","Institution","Term","TermName","Day", "User", "MaximumTutorial", "AgathaFile", "EmailAttachment"];

    @search_ctls = {}
    @attr_lists = {}

    @hash_to_index = {}
    @search_ctls = {}
    @number_of_controllers =  table_options.length




    
    user_id = session[:user_id]
    administrator = session[:administrator];
    Rails.logger.debug("InitializeSessionController: user_id: #{user_id}, administrator: #{administrator}, number_of_controllers: #{@number_of_controllers}");
    for controller_index in (0 .. (@number_of_controllers - 1))

      search_controller = SearchController.new(table_options[controller_index], user_id, administrator, session);
      attribute_eval_str = "AttributeList.new(#{table_options[controller_index]})"
     # unless session[attribute_eval_str]
        attribute_list = AttributeList.new(table_options[controller_index]);
    #    session[attribute_eval_str] = attribute_list;
   #   else
   #     attribute_list = session[attribute_eval_str];
    #  end
      #attribute_list = AttributeList.new(table_options[controller_index]);
      
      @search_ctls[table_options[controller_index]] = search_controller;
      @attr_lists[table_options[controller_index]] = attribute_list;
    end

   
    for controller_index in (0 .. (@number_of_controllers - 1))
      Rails.logger.debug("InitializeSessionController: controller_index: #{controller_index}, table_options[controller_index]: #{table_options[controller_index]}");
    
      @search_ctls[table_options[controller_index]].SetExtendedFilterControllers(@search_ctls);

    end

    Rails.logger.debug("Calling SetCompulsoryIndices")
    @search_ctls["AgathaFile"].SetCompulsoryIndices([6]);

   
    session[:search_ctls] =  @search_ctls

    session[:attr_lists] = @attr_lists
  
    Rails.logger.debug("inialization of search controllers complete");

  end



  

   

  def update_search_controller

#   start = Time.now; Rails.logger.error("update_search_controller_start");
    @search_ctls = session[:search_ctls];
    @attr_lists = session[:attr_lists]
    table_name =  params[:table_change_text];
    search_ctl = @search_ctls[table_name];    
    current_filter_indices = [];
    possible_filter_indices = [];
    number_of_available_filters =  search_ctl.extended_filters.length;
    for filter_index in (0..(number_of_available_filters-1))
      extended_filter = search_ctl.extended_filters[filter_index];
      if(params.has_key?(extended_filter.filter_object.tag))
        current_filter_indices << filter_index
        if(extended_filter.filter_object.class == SearchField)
          extended_filter.filter_object.current_filter_string = params[extended_filter.filter_object.tag]
        elsif(extended_filter.filter_object.class == SubQuery)
         
          select_value =  params[extended_filter.filter_object.tag].to_i;
          if(select_value == 0 )
            argument_class = extended_filter.filter_object.argument_class;
            if argument_class.length >0
              last_str = "#{argument_class}.last.id"
              select_value = eval(last_str);
            end
          end
                 
          extended_filter.filter_object.current_argument_value = select_value;


        end
      else
        possible_filter_indices << filter_index
      end
    end
    if current_filter_indices.length>0
      update_display = true;
      search_ctl.updateFilters(current_filter_indices,  update_display)
    end

    if(params.has_key?("order_text"))
      order_field_name = params["order_text"];
      #search_ctl.UpdateOrder(order_field_name)      
    end
    exam_ids = [];
    row_ids = [];
    compulsory_ids = [];
    if(params.has_key?("row_in_list"))
      row_ids = params[:row_in_list];
      if(table_name == "Person")
        if(params.has_key?("exam_in_list"))
          exam_ids = params[:exam_in_list];
        end
        
        if(params.has_key?("compulsory_in_list"))
          compulsory_ids = params[:compulsory_in_list];
        end        
      end     
    end

    #search_ctl.updateCheckBoxes(row_ids, exam_ids, compulsory_ids);
    

    if(params.has_key?("order_indices"))

      search_indices = params["order_indices"]
      search_ctl.UpdateSearchIndices(search_indices)
    else
      search_ctl.UpdateSearchIndices("")
    end
 #   elapsed = Time.now  - start; Rails.logger.error("update_search_controller_end, time: #{elapsed}");

  end
  def QualifiersStr(in_str)
    ret_str = in_str.strip;
    ret_str = ret_str.gsub(/[a-z][A-Z]\S{1}/){|s| s.insert(1," ")}
    ret_str = ret_str.gsub(/[a-z][A-Z]\S{1}/){|s| s.insert(1," ")}
    ret_str = ret_str.gsub(/\S+$/){|s| s = s.pluralize}
    ret_str = ret_str.gsub(/\s/){|s| '_'};
    ret_str = ret_str.gsub(/\//){|s| '__'};
    ret_str = ret_str.downcase;
    return ret_str;
  end  
  def update_external_filters
      @search_ctls = session[:search_ctls];
      @attr_lists = session[:attr_lists];
      @user_id = session[:user_id];
      table_name =  params["table_change_text"];
      @tables_name =  QualifiersStr(table_name);
      Rails.logger.info("update_external_filters table_name:#{table_name}, tables_name:#{@tables_name}, user_id:#{@user_id}");
      search_ctl = @search_ctls[table_name];
      external_filters = search_ctl.external_filters;
      # number_of_external_filters = params[:number_of_external_filters];
      stupid_count = 0;
      sql_str = "ExternalFilterValue.find_by_sql(\"SELECT id, table_name, filter_id, member_id, group_id, in_use FROM external_filter_values WHERE (user_id = " + @user_id.to_s +  " AND table_name = '" + @tables_name + "') ORDER BY id asc\")"
      
      old_external_filter_elts = eval(sql_str);
      old_external_filter_elt_count  = old_external_filter_elts.length;
      filter_count = 0;    
      
      for external_filter in external_filters
          current_arguments = external_filter.filter_object.current_arguments;
          if current_arguments == nil
              current_arguments = [];
          end
          
          filter_id = external_filter.filter_object.id;
          num_elements_str = "number_of_filter_elements_#{filter_id}";
          
          if(params.has_key?(num_elements_str))
              
              num_elts = params[num_elements_str].to_i;
              Rails.logger.info("update_external_filters  param #{num_elements_str} = #{num_elts} ");
              if num_elts < current_arguments.length
                  current_arguments = current_arguments[0, (num_elts)];
                  Rails.logger.info("update_external_filters num_elts:#{num_elts}, current_arguments:#{current_arguments.length}");
              end
              elt_off_set = 0; 
              for elt_id in (0..(num_elts-1))
                  if filter_count >= old_external_filter_elt_count
                      external_filter_elt  = ExternalFilterValue.new;
                  else
                      external_filter_elt = old_external_filter_elts[filter_count];
                  end
                  
                  member_id = -1;
                  while(member_id == -1 && elt_off_set<1000)
                      arg_name_str = "argument_selection_#{filter_id}_#{elt_id+elt_off_set}";
                      if(params.has_key?(arg_name_str))
                          member_id = params[arg_name_str];
                      else
                          elt_off_set=elt_off_set+1;
                      end
                  end
                  if (member_id ==-1)
                      member_id = 0;
                  end
                  
                  group_name_str = "group_selection_#{filter_id}_#{elt_id+elt_off_set}"         
                  
                  if params.has_key?(group_name_str)
                      group_id = params[group_name_str];
                  else
                      group_id = 0;
                  end
                  if filter_count >= current_arguments.length                    
                      
                      
                      new_filter_elt = ExternalFilterElement.new(elt_id,external_filter.filter_object);
                      new_filter_elt.member_id = member_id;
                      new_filter_elt.group_id = group_id;
                      current_arguments << new_filter_elt
                  else
                      current_arguments[elt_id].group_id = group_id;
                      current_arguments[elt_id].member_id = member_id;
                  end
                  
                  external_filter_elt.table_name = @tables_name;
                  external_filter_elt.user_id = @user_id;
                  external_filter_elt.filter_id = external_filter.filter_object.id;
                  external_filter_elt.in_use = true;
                  external_filter_elt.member_id = member_id;
                  external_filter_elt.group_id = group_id;
                  external_filter_elt.save;
                  filter_count =filter_count+1;          
                  Rails.logger.info("update_external_filters hum current_arguments:#{current_arguments.length}");
                  Rails.logger.info("update_external_filters, group_id:#{group_id}, member_id:#{member_id}");
              end
          else
              Rails.logger.info("update_external_filters no param #{num_elements_str}");
              external_filter.filter_object.current_arguments =[];
              
          end    
          
      end
      while filter_count < old_external_filter_elt_count
          external_filter_elt = old_external_filter_elts[filter_count];
          external_filter_elt.in_use = false;
          external_filter_elt.save;
          filter_count = filter_count+1; 
      end
  end
  def id_str_generator(ids)
    id_str = "";
      ids.each do |id|
        if(id_str.length >0 )
          id_str << ", ";
        end
        id_str << id.to_s;
     end
     return id_str;
  end
  
  def order_toggle
    Rails.logger.error("🧪 TEST: order_toggle called with params: #{params.inspect}")
    
   # unless session[:search_ctls]
    #  InitializeSessionController
    #end
    
    table_name = params[:table_name] || "Person"   
    @search_ctls = session[:search_ctls]

    search_ctl = @search_ctls[table_name];
    order_field_name = params["order_text"];
    search_ctl.UpdateOrder(order_field_name);
    
    #search_ctl = session[:search_ctls][table_name]
    #if search_ctl.nil?
     # Rails.logger.error("🧪 TEST: ERROR - No search controller for #{table_name}")
      #render json: { error: "No search controller found for #{table_name}" }
      #return
    #end
    
    # Show session data before the call (using symbol keys)
    session_order_key = :test_search_order_Person
    session_direction_key = :test_search_direction_Person
    session_counter_key = :test_toggle_counter_Person
    #Rails.logger.error("🧪 TEST: Session before - #{session_order_key}: #{session[session_order_key].inspect}")
    #Rails.logger.error("🧪 TEST: Session before - #{session_direction_key}: #{session[session_direction_key].inspect}")
    Rails.logger.error("🧪 TEST: Session before - #{session_counter_key}: #{session[session_counter_key].inspect}")
    

    
    # Call our test method, passing the session
    #search_ctl.TestOrderToggle(field_name, session)
    
    # Show session data after the call
    #Rails.logger.error("🧪 TEST: Session after - #{session_order_key}: #{session[session_order_key].inspect}")
    #Rails.logger.error("🧪 TEST: Session after - #{session_direction_key}: #{session[session_direction_key].inspect}")
    Rails.logger.error("🧪 TEST: Session after - #{session_counter_key}: #{session[session_counter_key].inspect}")
  
        # Read counter from session, increment it, and update session
    current_counter = session[:test_toggle_counter_Person] || 0
    new_counter = current_counter + 1
    
    # Force session to save using multiple approaches
    session.delete(:test_toggle_counter_Person)  # Delete first to ensure change is detected
    session[:test_toggle_counter_Person] = new_counter  # Set new value
    session[:_force_save] = Time.current.to_f  # Add dummy value to force dirty flag
    request.session_options[:renew] = true if request.respond_to?(:session_options)  # Force session renewal
    
    Rails.logger.error("🧪 TEST: Counter incremented from #{current_counter} to #{session[:test_toggle_counter_Person].inspect}")
    Rails.logger.error("🧪 TEST: Forced session save using delete-set pattern + dummy value + renewal")

    # Prepare the response data
    response_data = {
      table_name: table_name,
      field_name: order_field_name,
      session_search_order: session[session_order_key],
      session_search_direction: session[session_direction_key],
      toggle_counter: session[session_counter_key],
      status: 'success'  # Add status field like the working increment counter
    }
    
    Rails.logger.error("🧪 TEST: Returning response: #{response_data}")
    session[:search_ctls] = @search_ctls
    
    respond_to do |format|
      format.json { render json: response_data }
      format.js { render js: "console.log('🔧 ORDER_TOGGLE: About to call functions'); setSearchIndices('#{table_name}'); setSelectIndices('#{table_name}'); Search('#{table_name}');" }
    end
  end
  
  # Extract the common logic for handling display filter updates (column removal)
  def handle_display_filter_update(search_ctl, table_name, logger_prefix = "")
    return unless params.has_key?("update_display_filters") && params["update_display_filters"] == "true"
    
    Rails.logger.info("#{logger_prefix} Processing display filter update for #{table_name}")
    
    return unless params.has_key?("removed_column")
    
    removed_field = params["removed_column"]
    Rails.logger.info("#{logger_prefix} Removing column: #{removed_field} from #{table_name}")
    
    # Find the index of the removed field in the current filter indices
    field_index_to_remove = nil
    Rails.logger.debug("#{logger_prefix} Current filter indices: #{search_ctl.current_filter_indices}")
    extended_filter_tags = search_ctl.extended_filters.map { |ef| ef.filter_object.tag }
    Rails.logger.debug("#{logger_prefix} extended_filters tags: #{extended_filter_tags}")

    search_ctl.current_filter_indices.each_with_index do |filter_index, position|
      # Get the field name from the available_fields array using the filter_index
      if filter_index < extended_filter_tags.length
        field_name_from_index = extended_filter_tags[filter_index]
        if field_name_from_index == removed_field
          field_index_to_remove = position
          break
        else
          Rails.logger.debug("#{logger_prefix} field at index #{filter_index}: #{field_name_from_index} not equal to removed_field: #{removed_field}")
        end
      else
        Rails.logger.warn("#{logger_prefix} Filter index #{filter_index} out of bounds for available_fields in #{table_name}")
      end
    end
    
    if field_index_to_remove
      Rails.logger.info("#{logger_prefix} Found field #{removed_field} at position #{field_index_to_remove}, removing from current_filter_indices")
      search_ctl.current_filter_indices.delete_at(field_index_to_remove)
      
      # Save the updated display filter configuration to the database
      search_ctl.updateFilters(search_ctl.current_filter_indices, true)  # Pass current indices and update_display=true
      Rails.logger.info("#{logger_prefix} Updated display filters for #{table_name}, new indices: #{search_ctl.current_filter_indices}")
    else
      Rails.logger.warn("#{logger_prefix} Could not find field #{removed_field} in current filter indices")
    end
  end

  def delete_column
    Rails.logger.info("🗑️ DELETE_COLUMN: called with params: #{params.inspect}")
    
    table_name = params[:table_name] || "Person"   
    field_name = params[:field_name]
    
    # Set up parameters that would normally be sent by the form submission
    # These parameters are needed for update_search_controller and table_search to work properly
    params[:table_change_text] = table_name
    params[:do_not_search] = "0"  # This will prevent the actual search from running
    params[:update_display_filters] = "true"  # Signal that we're updating display filters
    params[:removed_column] = field_name  # The field being removed
    
    Rails.logger.info("🗑️ DELETE_COLUMN: Setting up table_search parameters")
    Rails.logger.info("🗑️ DELETE_COLUMN: table_name=#{table_name}, field_name=#{field_name}")
    
    # Initialize and update controllers
    unless session[:search_ctls]
      InitializeSessionController
    end
    update_search_controller
    update_external_filters
    
    search_ctl = session[:search_ctls][table_name]
    search_ctl.user_id = session[:user_id]
    
    # Use the extracted method to handle display filter updates
    handle_display_filter_update(search_ctl, table_name, "🗑️ DELETE_COLUMN:")
    
    # Update filters from database to ensure consistency
    search_ctl.UpdateFiltersFromDB()
    
    # Generate JavaScript for DOM manipulation only (no form submission)
    class_name = "#{field_name}_#{table_name}"
    js_code = <<~JAVASCRIPT
      (function() {
        console.log('🗑️ DELETE_COLUMN: Starting DOM cleanup for #{field_name} in #{table_name}');
        
        const className = "#{class_name}";

        // Remove matching <td> elements
        document.querySelectorAll("td." + className).forEach(function (td) {
          td.remove();
        });

        // Remove matching <th> elements  
        document.querySelectorAll("th." + className).forEach(function (th) {
          th.remove();
        });

        // Update the filter count
        const num_filters_obj = document.getElementById("all_display_indices_#{table_name}");
        if (num_filters_obj) {
          let num_filters = parseInt(num_filters_obj.value, 10) - 1;
          num_filters_obj.value = num_filters;

          // If only 1 or fewer filters remain, remove the X buttons
          if (num_filters <= 1) {
            const search_div = document.getElementById("search_results_#{table_name}");
            const current_div = document.getElementById("current_filters_#{table_name}");

            if (search_div) {
              const x_elements_search = search_div.querySelector('.remove_column');
              if (x_elements_search !== null) {
                x_elements_search.remove();
              }
            }

            if (current_div) {
              const x_elements_current = current_div.querySelector('.remove_column');
              if (x_elements_current !== null) {
                x_elements_current.remove();
              }
            }
          }
        }
        
        console.log('🗑️ DELETE_COLUMN: DOM cleanup completed, backend state updated');
      })();
    JAVASCRIPT
    
    Rails.logger.info("🗑️ DELETE_COLUMN: Column removal processed server-side, returning DOM cleanup JavaScript")
    
    respond_to do |format|
      format.json { render json: { status: 'success', table_name: table_name, field_name: field_name } }
      format.js { 
        render "delete_column", :locals => {
          :search_ctl => search_ctl, 
          :table_name => table_name, 
          :field_name => field_name,
          :js_code => js_code
        }
      }
    end
  end
  
  def table_search
  Rails.logger.debug("RWV WelcomeController:table_search a");
#     RubyProf.start
#start = Time.now; Rails.logger.debug("table_search_start");
    unless session[:search_ctls]
      InitializeSessionController
    end
    update_search_controller
    update_external_filters
    table_name =  params[:table_change_text];
    search_ctl = @search_ctls[table_name];
    
    search_ctl.user_id = session[:user_id];
    
    # Use the extracted method to handle display filter updates (column deletion)
    handle_display_filter_update(search_ctl, table_name, "RWV")
    
    if(params.has_key?("do_search"))
      eval_str = search_ctl.get_eval_string2();
      Rails.logger.debug( "TABLE SEARCH: before eval(#{eval_str})" );
      @table = eval(eval_str);
      eval("#{table_name}.set_controller(search_ctl)");

      Rails.logger.debug( "TABLE SEARCH: after eval(eval_str)" );
      search_results = SearchResults.new(@table, :search_results, search_ctl);
      search_results.table_type = :search_results;
    end
    search_ctl.UpdateFiltersFromDB();
    respond_to do |format|
      format.js { render "table_search", :locals => {:search_ctl => search_ctl, :params => params, :table_name => table_name, :search_results=> search_results} } 

    end


    Rails.logger.debug("RWV WelcomeController:table_search end");
    Rails.logger.flush;
  end

  def add_external_filter
    table_name = params[:table_name];
    filter_id = params[:filter_id].to_i;
    @search_ctls = session[:search_ctls];
    search_ctl = @search_ctls[table_name];
    # search_ctl.AddExternalFilter(filter_id);
    external_filter = search_ctl.CreateNewExternalFilter(filter_id);
    
    respond_to do |format|
      format.js { render "add_external_filter", :locals => {:external_filter => external_filter, :table_name => table_name } } 
    end

  end
  def update_external_filter
    class_name = params[:class_name];
    filter_id = params[:filter_id].to_i;
    elt_index= params[:elt_index].to_i;
    member_id = params[:member_id].to_i;
    group_id = params[:group_id].to_i;
    @search_ctls = session[:search_ctls];
    search_ctl = @search_ctls[class_name];
    external_filter_element = search_ctl.GetExternalFilterElement(filter_id, elt_index);
    external_filter_element.member_id = member_id;
    external_filter_element.group_id = group_id;

    respond_to do |format|
      format.js  { render "update_external_filter", :locals => {:external_filter_element => external_filter_element, :class_name => class_name, :filter_id => filter_id, :elt_index=> elt_index} } 
    end
  
  end

  def refresh_external_filter
    class_name = params[:class_name]
    filter_id = params[:filter_id].to_i
    table_name = params[:table_name]
    
    @search_ctls = session[:search_ctls]
    search_ctl = @search_ctls[class_name]
    
    # Get the external filter object to re-render with fresh data
    external_filter = search_ctl.GetExternalFilter(filter_id)
    
    respond_to do |format|
      format.html { 
        render partial: 'shared/external_filter', 
               object: external_filter,
               layout: false
      }
      format.js { 
        render partial: 'shared/external_filter', 
               object: external_filter,
               layout: false
      }
    end
  end

  def refresh_edit_select
    # Capture user ID at the start of the request to prevent race conditions
    current_user_id = session[:user_id]
    Rails.logger.info("refresh_edit_select: Request initiated by user_id=#{current_user_id}")
    
    model_class = params[:model_class]
    foreign_key = params[:foreign_key]
    foreign_class = params[:foreign_class]
    current_value = params[:current_value]
    select_element_id = params[:select_element_id]

    Rails.logger.info("refresh_edit_select: Refreshing edit select: select_element_id=#{select_element_id} for #{model_class} foreign_key: #{foreign_key}, foreign_class: #{foreign_class}, current_value: #{current_value} (user: #{current_user_id})")

    begin
      # Get the search controllers from session
      @search_ctls = session[:search_ctls]
      
      if !@search_ctls
        Rails.logger.error("refresh_edit_select: No search controllers found in session")
        render json: { 
          error: "No search controllers found",
          user_id: current_user_id,
          request_timestamp: Time.current.to_f
        }, status: 400
        return
      else
        Rails.logger.info("refresh_edit_select: Using search controllers from session")
      end
      
      # Verify user ID hasn't changed during request processing
      if session[:user_id] != current_user_id
        Rails.logger.warn("refresh_edit_select: User ID changed during request! Started with #{current_user_id}, now have #{session[:user_id]}")
        render json: { 
          error: "User session changed during request processing",
          user_id: current_user_id,
          request_timestamp: Time.current.to_f
        }, status: 409
        return
      else
        Rails.logger.info("refresh_edit_select: User ID #{session[:user_id]} is still valid")
      end
      
      # Get the current object
      object_class = foreign_class.classify.constantize
      current_object = object_class.find(current_value)
      if !current_object
        Rails.logger.error("refresh_edit_select: No current object found for #{foreign_class} ID #{current_value}")
        render json: { error: "refresh_edit_select: No current object found" }, status: 400
        return
      else
        Rails.logger.info("refresh_edit_select: Found current object for #{foreign_class} ID #{current_value}")
      end 

      # Create a filter controller to get the updated options
      user_id = session[:user_id] || 0
      table_name = model_class # Using model_class as table_name parameter for FilterController
      filter_controller = FilterController.new(@search_ctls, table_name, user_id)
      
      # Get the current value for this field from the object
      current_id = current_object.send(foreign_key) if current_object.respond_to?(foreign_key)
      
      # Get updated options using the filter controller
      possible_options = filter_controller.GetOptions(foreign_key, foreign_class, current_id, false, false)
       
      
       
      # Format the options for JSON response
      options_array = possible_options.map do |option|
        {
          id: option.id,
          name: option.name
        }
      end

      Rails.logger.info("refresh_edit_select: Returning #{options_array.length} options for #{foreign_key} (user: #{current_user_id})")

      render json: {
        foreign_key: foreign_key,
        foreign_class: foreign_class,
        model_class: model_class,
        options: options_array,
        current_value: current_id,
        user_id: current_user_id,
        request_timestamp: Time.current.to_f
      }
      
    rescue Exception => e
      Rails.logger.error("refresh_edit_select: Error refreshing edit select for user #{current_user_id}: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      render json: { 
        error: e.message,
        user_id: current_user_id,
        request_timestamp: Time.current.to_f
      }, status: 500
    end
  end

  def refresh_external_filter_select
    # Capture user ID at the start of the request to prevent race conditions
    current_user_id = session[:user_id]
    Rails.logger.info("refresh_external_filter_select: Request initiated by user_id=#{current_user_id}")
    
    class_name = params[:class_name]
    filter_id = params[:filter_id].to_i
    element_id = params[:element_id].to_i
    trigger_table = params[:trigger_table]
    trigger_object_id = params[:trigger_object_id].to_i

    Rails.logger.info("refresh_external_filter_select: Refreshing external filter select for #{class_name} filter #{filter_id}, element #{element_id}, triggered by #{trigger_table} ID #{trigger_object_id}")

    begin
      # Get the search controllers from session
      @search_ctls = session[:search_ctls]
      
      if !@search_ctls || !@search_ctls[class_name]
        Rails.logger.error("refresh_external_filter_select: No search controller found for class: #{class_name}")
        render json: { 
          error: "No search controller found",
          user_id: current_user_id,
          request_timestamp: Time.current.to_f
        }, status: 400
        return
      end
      
      search_ctl = @search_ctls[class_name]
      Rails.logger.info("refresh_external_filter_select: Using search controller for class: #{class_name}")
      
      # Get the external filter element using the search controller
      external_filter_element = search_ctl.GetExternalFilterElement(filter_id, element_id)
      
      if !external_filter_element
        Rails.logger.error("refresh_external_filter_select: No external filter element found for filter #{filter_id}, element #{element_id}")
        render json: { 
          error: "External filter element not found",
          user_id: current_user_id,
          request_timestamp: Time.current.to_f
        }, status: 400
        return
      else
        Rails.logger.info("refresh_external_filter_select: Found external filter element for filter #{filter_id}, element #{element_id}")
      end
      
      # Get the updated member selection
      argument_selection = external_filter_element.MemberSelection()
      
      # Format all options for JSON response
      all_options = argument_selection.map do |arg|
        {
          id: arg.id,
          name: arg.name
        }
      end
      
      # Find the specific updated option that matches the trigger object
      updated_option = argument_selection.find { |arg| arg.id.to_i == trigger_object_id }
      
      response_data = {
        all_options: all_options,
        user_id: current_user_id,
        request_timestamp: Time.current.to_f
      }
      
      # Include the specific updated option if found
      if updated_option
        response_data[:updated_option] = {
          id: updated_option.id,
          name: updated_option.name
        }
        Rails.logger.info("refresh_external_filter_select: Found updated option for #{trigger_table} ID #{trigger_object_id}: #{updated_option.name}")
      else
        Rails.logger.info("refresh_external_filter_select: No specific option found for #{trigger_table} ID #{trigger_object_id} - returning all options")
      end

      Rails.logger.info("refresh_external_filter_select: Returning #{all_options.length} total options for #{class_name} filter #{filter_id}, element #{element_id}")

      render json: response_data
      
    rescue Exception => e
      Rails.logger.error("Error refreshing external filter select for user #{current_user_id}: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      render json: { 
        error: e.message,
        user_id: current_user_id,
        request_timestamp: Time.current.to_f
      }, status: 500
    end
  end
  
  def get_object_display_name
    begin
      current_user_id = session[:user_id] || 0
      class_name = params[:class_name]
      object_id = params[:object_id].to_i
      
      Rails.logger.info("get_object_display_name: Getting display name for #{class_name} ID #{object_id}")
      
      # Validate parameters
      if class_name.blank? || object_id <= 0
        Rails.logger.error("get_object_display_name: Invalid parameters - class_name: #{class_name}, object_id: #{object_id}")
        render json: { 
          error: "Invalid parameters",
          user_id: current_user_id,
          request_timestamp: Time.current.to_f
        }, status: 400
        return
      end
      
      # Get search controllers from session
      search_ctls = session[:search_ctls]
      if !search_ctls || !search_ctls[class_name]
        Rails.logger.error("get_object_display_name: No search controller found for #{class_name}")
        render json: { 
          error: "No search controller found for #{class_name}",
          user_id: current_user_id,
          request_timestamp: Time.current.to_f
        }, status: 400
        return
      end
      
      # Set up the search controller
      search_ctl = search_ctls[class_name]
      eval("#{class_name}.set_controller(search_ctl)")
      
      # Get the object and its display name using GetShortField
      begin
        # Verify the object exists
        class_name.constantize.find(object_id)
        display_name = search_ctl.GetShortField(object_id)
        
        Rails.logger.info("get_object_display_name: Found display name '#{display_name}' for #{class_name} ID #{object_id}")
        
        render json: {
          display_name: display_name,
          object_id: object_id,
          class_name: class_name,
          user_id: current_user_id,
          request_timestamp: Time.current.to_f
        }
        
      rescue ActiveRecord::RecordNotFound
        Rails.logger.error("get_object_display_name: #{class_name} with ID #{object_id} not found")
        render json: { 
          error: "#{class_name} with ID #{object_id} not found",
          user_id: current_user_id,
          request_timestamp: Time.current.to_f
        }, status: 404
      end
      
    rescue Exception => e
      Rails.logger.error("Error getting display name for user #{current_user_id}: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      render json: { 
        error: e.message,
        user_id: current_user_id,
        request_timestamp: Time.current.to_f
      }, status: 500
    end
  end

  def fetch_updated_rows
    table_name = params[:table_name]
    row_ids = params[:row_ids].split(',').map(&:to_i)
    
    Rails.logger.info("Fetching updated rows for #{table_name}: #{row_ids}")
    
    begin
      # Get the object class
      object_class = table_name.classify.constantize
      
      # Fetch the updated objects
      updated_objects = object_class.where(id: row_ids)
      
      # Get search controller to render rows
      @search_ctls = session[:search_ctls]
      search_ctl = @search_ctls[table_name]
      
      if !search_ctl
        Rails.logger.error("No search controller found for table: #{table_name}")
        render json: { error: "No search controller found" }, status: 400
        return
      end
      
      # Render each row's HTML
      rows_data = updated_objects.map do |obj|
        # Use the search controller to render the row HTML
        row_html = search_ctl.GetRowHTML(obj.id)
        {
          id: obj.id,
          html: row_html
        }
      end
      
      render json: { rows: rows_data }
      
    rescue Exception => e
      Rails.logger.error("Error fetching updated rows: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      render json: { error: e.message }, status: 500
    end
  end

  # before def new
  def new
#     RubyProf.start
#   
    Rails.logger.info("WelcomeController:new, params: #{params.inspect}")
    class_name = params[:class_name];
    table_name = class_name.tableize;
    search_done = params[:search_done] == 'true';
    Rails.logger.debug("WelcomeController:new class_name: #{class_name}, table_name: #{table_name}, search_done: #{search_done}");
    new_eval_str = "#{class_name}.new"
    new_obj = eval(new_eval_str);
    if(class_name == "EmailTemplate")
      new_obj.from_email = "<%= me.email %>"
      new_obj.subject = "Put the email subject here."
      new_obj.body =  %q{Dear <%= person.salutation %>,<br><br>Put your email content here }
    end    
    
    new_obj.save;
    id = new_obj.id;

    # Get search controller and prepare the new row for display
    search_ctls = session[:search_ctls]
    search_ctl = nil
    new_row = nil
    search_results = nil
    
    if search_ctls && search_ctls[class_name]
      search_ctl = search_ctls[class_name]
      begin
        eval("#{class_name}.set_controller(search_ctl)")
        
        # Create a simple object with the required attributes for the template
        new_row = OpenStruct.new(
          id: new_obj.id,
          class_name: class_name,
          search_controller: search_ctl
        )
        
        # Copy all the new_obj attributes to new_row so filter.eval_str can access them
        new_obj.attributes.each do |key, value|
          new_row.send("#{key}=", value) unless new_row.respond_to?(key)
        end
        
        Rails.logger.debug("DEBUG: Created row object for new #{class_name} with ID #{new_obj.id}")
        
        # If no search has been performed, create a SearchResults with just the new row
        if !search_done
          search_results = SearchResults.new([new_row], :search_results, search_ctl)
        end
        
      rescue => e
        Rails.logger.error("ERROR creating row object: #{e.message}")
        new_row = nil
      end
    else
      Rails.logger.debug("DEBUG: No search controller found for #{class_name}")
    end

    
    
    # Send data invalidation to update other clients
    #send_data_invalidation_for_update(class_name, new_obj, nil, id)

    respond_to do |format|
      if search_done
        # If search was already performed, add to existing table
        Rails.logger.debug("new rendering new for #{class_name}")
        format.js { render "new", :locals=>{:table_name => table_name, :id => id, :class_name => class_name, :new_row => new_row, :search_done => search_done, :search_ctl => search_ctl } }
        
      else
        # If no search was performed, render a new table with just this entry
        # We'll need to handle opening the edit window in the table_search template
        Rails.logger.debug("new rendering table_search for #{class_name}")
        format.js { render "table_search", :locals => {:search_ctl => search_ctl, :params => params, :table_name => class_name, :search_results=> search_results, :new_entry_id => id, :open_edit => true} }
      end
      
      format.html do
        Rails.logger.debug "WARNING: Form submitted as HTML instead of JavaScript format"
        Rails.logger.debug "Request headers: #{request.headers['Accept']}"
        Rails.logger.debug "Request format: #{request.format}"
        redirect_to root_path, notice: "#{class_name} created successfully with ID #{id}"
      end     
    end
  end
  # after def new

  def suggest_tutorial
    debug_prefix = "WelcomeController:suggest_tutorial (#{Time.now.strftime('%H:%M:%S')})"
    Rails.logger.debug "#{debug_prefix} METHOD START - session keys: #{session.keys}, suggest_tutorial_course_id: #{session[:suggest_tutorial_course_id].inspect}";
    Rails.logger.debug "#{debug_prefix} suggest_tutorial_course_id key exists: #{session.key?(:suggest_tutorial_course_id)}, value class: #{session[:suggest_tutorial_course_id].class}";
    
    # Check if session was reset and restore from a backup or use a different strategy
    if session[:suggest_tutorial_course_id] == 0 && params[:suggest_id] && session.key?(:suggest_tutorial_course_id)
      Rails.logger.debug "#{debug_prefix} SUSPICIOUS: suggest_tutorial_course_id is 0 but key exists - possible reset detected";
      Rails.logger.debug "#{debug_prefix} Request params suggest_id: #{params[:suggest_id]}, previous_suggestions: #{params[:previous_suggestions]}";
      
      # Check if this is a continuation of a previous suggestion by looking at previous_suggestions
      if params[:previous_suggestions] && !params[:previous_suggestions].empty?
        Rails.logger.debug "#{debug_prefix} Found previous_suggestions - this appears to be a continuation, not first call";
        # If we have previous suggestions, this suggests the session was reset between calls
        # We can try to recover by setting the course_id from params
        session[:suggest_tutorial_course_id] = params[:suggest_id].to_i
        Rails.logger.debug "#{debug_prefix} RECOVERY: Set suggest_tutorial_course_id to #{session[:suggest_tutorial_course_id]} from params";
      end
    end
    
    tutorial_schedule = TutorialSchedule.new;
    previous_suggestions = params[:previous_suggestions];
    course_id = params[:suggest_id];
    Rails.logger.debug "#{debug_prefix} current_term: #{session[:current_term]}, suggest_tutorial_course_id: #{session[:suggest_tutorial_course_id]}, course_id: #{course_id}, previous_suggestions: #{previous_suggestions}, person_id: #{params[:person_id]}";
    if session[:suggest_tutorial_course_id].to_i !=course_id.to_i
      Rails.logger.debug "#{debug_prefix} course_id changed, resetting previous suggestions";
      previous_suggestions="";
      old_person_id = SearchController::NOT_SET;
      
      # More explicit session assignment to ensure persistence
      Rails.logger.debug "#{debug_prefix} BEFORE assignment - suggest_tutorial_course_id: #{session[:suggest_tutorial_course_id].inspect}";
      session[:suggest_tutorial_course_id] = course_id.to_i  # Ensure it's an integer
      Rails.logger.debug "#{debug_prefix} AFTER assignment - suggest_tutorial_course_id: #{session[:suggest_tutorial_course_id].inspect}";
      Rails.logger.debug "#{debug_prefix} forced session save for suggest_tutorial_course_id";
    else
      old_person_id = params[:person_id].to_i;
    end
    Rails.logger.debug "#{debug_prefix} session[:suggest_tutorial_course_id] is now #{session[:suggest_tutorial_course_id]}";

    previous_str = "";
    if previous_suggestions.length >0
        previous_suggestions << ", "
    end
    previous_suggestions << old_person_id.to_s;
    if previous_suggestions.length >0
      previous_str = "AND person_id NOT IN (#{previous_suggestions}) "
    end
    db_tutorial_schedules = TutorialSchedule.find_by_sql("SELECT * FROM tutorial_schedules WHERE course_id = #{course_id} #{previous_str} ORDER BY term_id DESC LIMIT 1");
    willing_tutor_str = "SELECT * FROM willing_tutors WHERE course_id = #{course_id} #{previous_str} ORDER BY order_of_preference ASC LIMIT 1";
    Rails.logger.debug "#{debug_prefix} willing_tutor_str: #{willing_tutor_str}";
    willing_tutor = WillingTutor.find_by_sql(willing_tutor_str);
    if willing_tutor.length > 0
      tutorial_schedule.person_id = willing_tutor[0].person_id;
    else
      first_suggestion = previous_suggestions.scan(/\d+/)
      if first_suggestion
        if first_suggestion[0].to_i == SearchController::NOT_SET && first_suggestion.length>1
        tutorial_schedule.person_id = first_suggestion[1].to_i
        else
          tutorial_schedule.person_id = first_suggestion[0].to_i
        end
      else
        tutorial_schedule.person_id = SearchController::NOT_SET;
      end
      previous_suggestions = SearchController::NOT_SET.to_s;
    end
        old_term_id = params[:term_id].to_i;
    if old_term_id == SearchController::NOT_SET

      suggested_term = session[:current_term];
      if suggested_term !=nil &&   suggested_term == SearchController::NOT_SET
        tutorial_schedule.term_id = suggested_term.id
      else
        tutorial_schedule.term_id = Term.last.id;
      end
    else
      tutorial_schedule.term_id = old_term_id;
    end
    tutorial_schedule.course_id = course_id;

    old_number_of_tutorials = params[:number_of_tutorials].to_i;
    if old_number_of_tutorials == 0 && db_tutorial_schedules.length > 0
      tutorial_schedule.number_of_tutorials = db_tutorial_schedules[0].number_of_tutorials;
    else
      tutorial_schedule.number_of_tutorials = old_number_of_tutorials;
    end

    @search_ctls = session[:search_ctls];

   
    suggested_tutorial_schedule = SuggestedTutorial.new(@search_ctls["TutorialSchedule"],tutorial_schedule);
    suggested_tutorial_schedule.previous_suggestions = previous_suggestions;
    Rails.logger.debug "#{debug_prefix} METHOD END - session[:suggest_tutorial_course_id]: #{session[:suggest_tutorial_course_id].inspect}";
    respond_to do |format|
      format.js  { render "suggest_tutorial", :locals => {:suggested_tutorial_schedule => suggested_tutorial_schedule}  }
  
    end
    Rails.logger.flush
  end
  
  def suggest_lecture
    debug_prefix = "WelcomeController:suggest_lecture (#{Time.now.strftime('%H:%M:%S')})"
    Rails.logger.debug "#{debug_prefix} METHOD START - session keys: #{session.keys}, suggest_course_id: #{session[:suggest_course_id].inspect}";
    Rails.logger.debug "#{debug_prefix} suggest_course_id key exists: #{session.key?(:suggest_course_id)}, value class: #{session[:suggest_course_id].class}";
    
    # Check if session was reset and restore from a backup or use a different strategy
    if session[:suggest_course_id] == 0 && params[:suggest_id] && session.key?(:suggest_course_id)
      Rails.logger.debug "#{debug_prefix} SUSPICIOUS: suggest_course_id is 0 but key exists - possible reset detected";
      Rails.logger.debug "#{debug_prefix} Request params suggest_id: #{params[:suggest_id]}, previous_suggestions: #{params[:previous_suggestions]}";
      
      # Check if this is a continuation of a previous suggestion by looking at previous_suggestions
      if params[:previous_suggestions] && !params[:previous_suggestions].empty?
        Rails.logger.debug "#{debug_prefix} Found previous_suggestions - this appears to be a continuation, not first call";
        # If we have previous suggestions, this suggests the session was reset between calls
        # We can try to recover by setting the course_id from params
        session[:suggest_course_id] = params[:suggest_id].to_i
        Rails.logger.debug "#{debug_prefix} RECOVERY: Set suggest_course_id to #{session[:suggest_course_id]} from params";
      end
    end
    
    lecture = Lecture.new;
    previous_suggestions = params[:previous_suggestions];
    course_id = params[:suggest_id];
    Rails.logger.debug "#{debug_prefix} current_term: #{session[:current_term]}, suggest_course_id: #{session[:suggest_course_id]}, course_id: #{course_id}, previous_suggestions: #{previous_suggestions}, person_id: #{params[:person_id]}";
    if session[:suggest_course_id].to_i !=course_id.to_i
      Rails.logger.debug "#{debug_prefix} course_id changed, resetting previous suggestions";
      previous_suggestions="";
      old_person_id = SearchController::NOT_SET;
      
      # More explicit session assignment to ensure persistence
      Rails.logger.debug "#{debug_prefix} BEFORE assignment - suggest_course_id: #{session[:suggest_course_id].inspect}";
      session[:suggest_course_id] = course_id.to_i  # Ensure it's an integer
      Rails.logger.debug "#{debug_prefix} AFTER assignment - suggest_course_id: #{session[:suggest_course_id].inspect}";
      Rails.logger.debug "#{debug_prefix} forced session save for suggest_course_id";
    else
      old_person_id = params[:person_id].to_i;
      Rails.logger.debug "#{debug_prefix} course_id unchanged";
    end
    Rails.logger.debug "#{debug_prefix} session[:suggest_course_id] is now #{session[:suggest_course_id]}";


    
    previous_str = "";
    if previous_suggestions.length >0
        previous_suggestions << ", "
    end
    previous_suggestions << old_person_id.to_s;
    if previous_suggestions.length >0
      previous_str = "AND person_id NOT IN (#{previous_suggestions}) "
    end
    
    db_lectures_str = "SELECT * FROM lectures WHERE course_id = #{course_id} #{previous_str} ORDER BY term_id DESC LIMIT 1";
    Rails.logger.debug "#{debug_prefix} db_lectures_str: #{db_lectures_str}";
    db_lectures = Lecture.find_by_sql(db_lectures_str);

    willing_lecturers_str = "SELECT * FROM willing_lecturers WHERE course_id = #{course_id} #{previous_str} ORDER BY order_of_preference ASC LIMIT 1";
    Rails.logger.debug "#{debug_prefix} willing_lecturers_str: #{willing_lecturers_str}";
    willing_lecturers = WillingLecturer.find_by_sql(willing_lecturers_str);
    if willing_lecturers.length > 0
      lecture.person_id = willing_lecturers[0].person_id;
    else
      first_suggestion = previous_suggestions.scan(/\d+/)
      if first_suggestion
        if first_suggestion[0].to_i == SearchController::NOT_SET && first_suggestion.length>1
        lecture.person_id = first_suggestion[1].to_i
        else
          lecture.person_id = first_suggestion[0].to_i
        end
      else
        lecture.person_id = SearchController::NOT_SET;
      end      
      previous_suggestions = SearchController::NOT_SET.to_s;
    end
        old_term_id = params[:term_id].to_i;
    if old_term_id == SearchController::NOT_SET
       suggested_term = session[:current_term];
      if suggested_term !=nil &&   suggested_term == SearchController::NOT_SET
        lecture.term_id = suggested_term.id
      else
        lecture.term_id = Term.last.id;
      end
    else
      lecture.term_id = old_term_id;
    end
    old_classes = params[:number_of_classes].to_i
    if old_classes == 0  && db_lectures.length > 0
      lecture.number_of_classes = db_lectures[0].number_of_classes
    else
      lecture.number_of_classes = old_classes
    end
    old_lectures = params[:number_of_lectures].to_i;
    if old_lectures == 0 && db_lectures.length > 0
      lecture.number_of_lectures = db_lectures[0].number_of_lectures;
    else
      lecture.number_of_lectures = old_lectures;
    end
    lecture.day_id = params[:day_id].to_i;
    lecture.lecture_time = params[:lecture_time];
    @search_ctls = session[:search_ctls];

    class_name = params[:suggest_class];
    suggested_lecture = SuggestedLecture.new(@search_ctls["Lecture"],lecture);
    suggested_lecture.previous_suggestions = previous_suggestions;
    Rails.logger.debug "#{debug_prefix} METHOD END - session[:suggest_course_id]: #{session[:suggest_course_id].inspect}";
    respond_to do |format|
      format.js  { render "suggest_lecture", :locals =>{:suggested_lecture => suggested_lecture, :class_name => class_name  } }
=begin      
        render :update do |page|
        #  page["#{class_name}_action_div"].select(".schedule_div")[0].replace_html(:partial => "shared/suggested_lecture", :object =>  suggested_lecture);
        page.replace_html("schedule_div",:partial => "shared/suggested_lecture", :object =>  suggested_lecture);
        page << "unwait();"
        end
      end
=end      
    end
    Rails.logger.flush
  end

  def make_suggestion
    suggest_type = params[:suggest_type];
    Rails.logger.debug "WelcomeController:make_suggestion - suggest_type: #{suggest_type}"
    
    case suggest_type
    when "Lecture"
      suggest_lecture
    when "Tutorial"
      suggest_tutorial
    else
      x = 1;
    end
   end

  def multi_table_create
    table_name = params[:multi_table_create]
    @search_ctls = session[:search_ctls];
    search_ctl = @search_ctls[table_name];
    respond_to do |format|
        format.js { render "multi_table_create", :locals =>{:table_name => table_name, :search_ctl => search_ctl  } } 
=begin 
          render :update do |page|
            page << "wait();"
            if  table_name.length >0
             @search_ctls = session[:search_ctls];
             search_ctl = @search_ctls[table_name];
             new_multi_table = MultiTable.new("\"#{table_name}\"", search_ctl)
           # <%= render(:partial => "shared/multi_table", :object => new_multi_table ) %>
             page.replace_html("multi_change_table_div_#{table_name}" , :partial => "shared/multi_table" , :object => new_multi_table);
            else
              page << notification_alert('Something went wrong with multi table create', 'error');

            end
            page << "unwait();"
          end
        end
=end         
    end

  end

  def select_action
    action = params[:action_type];
    class_name = params[:class_name];
    ids = params[:row_in_list];
    if(ids == nil)
      ids = [];
    end
    case action
    when "delete"
      delete_array(ids, class_name);
    when "update_collection_status"
      new_status = params[:collection_status].to_i;
      update_collection_status(ids, new_status);
    when "multi_update"
      multi_update(ids, class_name);
      
    when "group"
      
      group_name = params[:new_group_name];
      group_privacy = params[:group_privacy];
      new_group(ids, class_name, group_name, group_privacy);
    when "set_tutorial_number"

      tutorial_number = params[:tutorial_number];
      update_tutorial_number(ids, tutorial_number);      
    when "add_to_group"
      
      class_name2 = params[:class_name2];
      group_id = params[:id];
      add_to_group(group_id, ids, class_name2);
    when "remove_from_group"
      
      class_name2 = params[:class_name2];
      group_id = params[:id];
      remove_from_group(group_id, ids, class_name2);
      
    when "add_to_groups"
      
      class_id = params[:id];
      add_to_groups(ids, class_id, class_name);
    when "remove_from_groups"
      
      class_id = params[:id];
      remove_from_groups(ids, class_id, class_name);
    when "create_lecture_from_course"
      create_lecture_schedule
    when "create_tutorials_from_course"
      create_tutorial_schedules(ids)
    when "create_email_from_template"
      send_flag = false;
      create_email_from_template(ids, send_flag)
    when "create_send_email_from_template"
      send_flag = true;
      create_email_from_template(ids, send_flag)
    when "send_email"
      send_email()
    when "send_emails"
      send_emails(ids)
    when "make_willing_lecturer"
      make_willing_lecturer(ids)
    when "make_willing_tutor"
      make_willing_tutor(ids)
    when "add_to_lectures"
      if class_name == "Lecture"
        add_to_lectures(ids)
      else
        make_attendee(ids)
      end
    when "assign_tutor"
      assign_tutor(ids)
    when "max_tutorials"
      max_tutorials(ids)
    when "attach_files"
      attach_files(ids)
    when "attach_to_emails"
      attach_to_emails(ids)
    when "add_tutorial_student"
      add_tutorial_student(ids)
    else
      x = 1;     
    end
     Rails.logger.flush
  end
  
  def multi_update(ids, class_name)
    error_str = "";
    success_str = "";
    attribute_list = [];
    if(ids == nil || ids.length==0)
      error_str = "You have not selected any rows to update. "
    else      
        
        Rails.logger.info(" multi_update 1");
        update_int_fields = Hash.new;
        update_text_fields = Hash.new;
        field_str = ""
        field_count = 0;
        params.each do |key,value|
            if(key =~ Regexp.new("^mi_edit_#{class_name}_"))

                i_value = value.to_i
                Rails.logger.debug("key = #{key}, i_value = #{i_value}, value.length = #{value.length}  ");
                if (i_value  >= 0 && value.length > 0)
                  if(field_str.length > 0)
                    field_str << ", "
                  end
                  field_name = key.gsub(Regexp.new("^mi_edit_#{class_name}_"),'');
                  field_str << field_name;
                  attribute_list.push(field_name);

                  field_count = field_count + 1;
                  update_int_fields[field_name] = i_value;
                end

            elsif(key =~ Regexp.new("^mt_edit_#{class_name}_"))
                if(value.length > 0)
                  if(field_str.length > 0)
                    field_str << ", "
                  end
                  field_name = key.gsub(Regexp.new("^mt_edit_#{class_name}_"),'')
                  field_str << field_name;
                  attribute_list.push(field_name);
                  field_count = field_count + 1;
                  update_text_fields[field_name] = value;
                end
            end
        end
                Rails.logger.debug(" multi_update 2");
        ids.each do |id|
           object_str = "#{class_name}.find(#{id})";
           current_object  = eval(object_str);
           update_int_fields.each do |key,value|
              
                update_str = "current_object.#{key} = #{value}";
                eval(update_str);
              

           end
                   Rails.logger.debug(" multi_update 3");
           update_text_fields.each do |key,value|

                update_str = "current_object.#{key} = \"#{value}\"";
                eval(update_str);
              
           end
           current_object.save;
                   Rails.logger.debug(" multi_update 4");
        end
        
                Rails.logger.debug(" multi_update 5");
        if(field_count==0)
                  Rails.logger.debug(" multi_update 6");
          success_str = "No updates were made because you didn't set any fields"
        else
                  Rails.logger.debug(" multi_update 7");
          @pluralize_num =  ids.length;
          success_str = ids.length.to_s + " " +pl("#{class_name}") + " " + pl("was") + " updated with new ";
          @pluralize_num = field_count;
          success_str << pl("value") + " for " + pl("field") + " " + field_str;
        end
    end
    
    # ActionCable invalidation notification for multi_update
    if error_str.empty? && ids.any? && field_count > 0
      begin
        Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for multi_update operation")
        
        # Build affected relationships for multi-update
        affected_relationships = []
        
        # Records of the target class updated
        affected_relationships << {
          table: class_name,
          operation: "update",
          ids: ids.map(&:to_i),
          reason: "multi_update_fields_changed",
          source_operation: "multi_update",
          updated_fields: attribute_list,
          updated_field_count: field_count
        }
        
        Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships for multi_update")
        affected_relationships.each do |rel|
          Rails.logger.info("RWV  - #{rel[:table]} #{rel[:operation]} (#{rel[:ids]&.length || 0} records): #{rel[:reason]} [fields: #{rel[:updated_fields]&.join(', ')}]")
        end
        
        # Broadcast the invalidation notification
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id],
            operation: "multi_update",
            class_name: class_name,
            object_ids: ids,
            updated_fields: attribute_list,
            field_count: field_count
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })
        
        Rails.logger.info("RWV Successfully broadcast invalidation notification for multi_update operation")
        
      rescue => e
        Rails.logger.error "RWV ActionCable broadcast failed in multi_update: #{e.message}"
        Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
    else
      Rails.logger.info("RWV Skipping ActionCable invalidation broadcast for multi_update due to error, no records, or no fields updated")
    end
    
            Rails.logger.debug(" multi_update 8");


    if error_str.length>0
      alert_str = error_str;
      alert_status = 'error';
    else
      alert_str = success_str;
      alert_status = 'success';
    end

    respond_to do |format|
      format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => alert_status } }
    end   
    
            

  end  
  def add_tutorial_student(ids)
    error_str = "";
    success_str = "";
    if(ids == nil || ids.length==0)
      error_str = "You have not selected any tutorial schedules. "
    else
      id_str = "";
      ids.each do |id|
        if(id_str.length >0 )
          id_str << ", ";
        end
        id_str << id.to_s;
      end
      person_id = params[:id];
      already_present =Tutorial.find_by_sql("SELECT a0.tutorial_schedule_id FROM tutorials a0 WHERE a0.person_id = #{person_id} AND a0.tutorial_schedule_id IN (#{id_str})");
      if  already_present.length >0
        @pluralize_num = already_present.length;
        success_str = "The tutorial" + pl("schedule") + " with " + pl("id") + " = ";
        tutorial_schedule_id_str = "";
        already_present.each do |tutorial|
          if tutorial_schedule_id_str.length >0
            tutorial_schedule_id_str << ", ";
          end
          tutorial_schedule_id_str << tutorial.tutorial_schedule_id.to_s;
          ids.delete(tutorial.tutorial_schedule_id.to_s);
        end
        success_str << tutorial_schedule_id_str + " "

        success_str << " already had the student with id #{person_id} attending. "
      end
       ids.each do |tutorial_schedule_id|
        tutorial = Tutorial.new;
        tutorial.tutorial_schedule_id = tutorial_schedule_id;
        tutorial.person_id = person_id;
        tutorial.save;
      end
      @pluralize_num = ids.length;
      success_str << "You have added person with id #{person_id} to #{@pluralize_num} " + pl("tutorial schedules");

    end
    
    # ActionCable invalidation notification for add_tutorial_student
    if error_str.empty? && ids.any?
      begin
        Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for add_tutorial_student operation")
        
        # Build affected relationships for tutorial student addition
        affected_relationships = []
        
        # Person record updated (shows new tutorial assignments)
        person_id = params[:id].to_i
        affected_relationships << {
          table: "Person",
          operation: "update",
          ids: [person_id],
          reason: "tutorial_assignments_added",
          source_operation: "add_tutorial_student"
        }
        
        # TutorialSchedule records updated (show new student assignments)
        affected_relationships << {
          table: "TutorialSchedule",
          operation: "update",
          ids: ids.map(&:to_i),
          reason: "student_assignments_added",
          source_operation: "add_tutorial_student"
        }
        
        # New Tutorial records created
        affected_relationships << {
          table: "Tutorial",
          operation: "create",
          ids: [], # New records, so no specific IDs yet
          reason: "new_tutorial_records",
          source_operation: "add_tutorial_student",
          related_person_id: person_id,
          related_tutorial_schedule_ids: ids.map(&:to_i)
        }
        
        Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships for add_tutorial_student")
        affected_relationships.each do |rel|
          Rails.logger.info("RWV  - #{rel[:table]} #{rel[:operation]} (#{rel[:ids]&.length || 0} records): #{rel[:reason]}")
        end
        
        # Broadcast the invalidation notification
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id],
            operation: "add_tutorial_student",
            person_id: person_id,
            tutorial_schedule_ids: ids
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })
        
        Rails.logger.info("RWV Successfully broadcast invalidation notification for add_tutorial_student operation")
        
      rescue => e
        Rails.logger.error "RWV ActionCable broadcast failed in add_tutorial_student: #{e.message}"
        Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
    else
      Rails.logger.info("RWV Skipping ActionCable invalidation broadcast for add_tutorial_student due to error or no tutorial schedules")
    end
    
    @search_ctls = session[:search_ctls];
    edited_table_name = "Tutorial";
    Rails.logger.info("add_tutorial_student success_str = #{success_str}");

    if error_str.length>0
      alert_str = error_str;
      alert_status = 'error';
    else
      alert_str = success_str;
      alert_status = 'success';
    end

    respond_to do |format|
      format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => alert_status } }
    end
  end

  def attach_to_emails(ids)
    error_str = "";
    success_str = "";
    if(ids == nil || ids.length==0)
      error_str = "You have not selected any emails to attach file to. "
    else

      id_str = "";
      ids.each do |id|
        if(id_str.length >0 )
          id_str << ", ";
        end
        id_str << id.to_s;
      end
      agatha_file_id = params[:id];
      agatha_file = AgathaFile.find(agatha_file_id);
      
      already_present =EmailAttachment.find_by_sql("SELECT  a0.agatha_email_id FROM email_attachments a0  WHERE a0.agatha_file_id = #{agatha_file_id} AND a0.agatha_email_id IN (#{id_str})");
      if  already_present.length >0
        @pluralize_num = already_present.length;
        success_str = "The " + pl("email") + " with " + pl("id") + " = ";
        attach_id_str = "";
        already_present.each do |email|
          if attach_id_str.length >0
            attach_id_str << ", ";
          end
          attach_id_str << email.agatha_email_id.to_s;
          ids.delete(email.agatha_email_id.to_s);
        end
        success_str << attach_id_str + " "        

        success_str << " already had the file #{agatha_file.agatha_data_file_name} attached. "
      end


      ids.each do |agatha_email_id|
        email_attachment = EmailAttachment.new;
        email_attachment.agatha_email_id = agatha_email_id;
        email_attachment.agatha_file_id = agatha_file_id;
        email_attachment.save;
      end
      @pluralize_num = ids.length;
      success_str << "You have attached file #{agatha_file.agatha_data_file_name} to #{@pluralize_num} " + pl("email");

    end
    @search_ctls = session[:search_ctls]
    respond_to do |format|
      format.js { render "attach_to_emails", :locals => {:error_str => error_str, :search_ctls => session[:search_ctls], :ids => ids, :success_str => success_str } }

    end
  end

  def attach_files(ids)
     error_str = "";
     success_str = "";
    if(ids == nil || ids.length==0)
      error_str = "You have not selected any files to attach to email. "
    else
      id_str = "";
      ids.each do |id|
        if(id_str.length >0 )
          id_str << ", ";
        end
        id_str << id.to_s;
      end
    
      
      agatha_email_id = params[:id];

      already_present =EmailAttachment.find_by_sql("SELECT  a0.agatha_file_id, a1.agatha_data_file_name FROM email_attachments a0 INNER JOIN agatha_files a1 ON a0.agatha_file_id = a1.id  WHERE a0.agatha_email_id = #{agatha_email_id} AND a0.agatha_file_id IN (#{id_str})");
      if  already_present.length >0
        @pluralize_num = already_present.length;
        success_str = "The " + pl("file") + " ";
        attach_file_str = "";
        already_present.each do |attachment|
          if attach_file_str.length >0
            attach_file_str << ", ";
          end
          attach_file_str  << attachment.agatha_data_file_name;
          ids.delete(attachment.agatha_file_id.to_s);
        end
        success_str << attach_file_str + " "
        success_str << pl("was") + " already attached. "


      end
      ids.each do |agatha_file_id|
        email_attachment = EmailAttachment.new;
        email_attachment.agatha_email_id = agatha_email_id;
        email_attachment.agatha_file_id = agatha_file_id;
        email_attachment.save;
      end

       @pluralize_num = ids.length;
       success_str << "You have attached #{@pluralize_num} " + pl("file") + " to the selected email";

    end

    x = 1;
    @search_ctls = session[:search_ctls];
    respond_to do |format|
      format.js {render  "attach_files", :locals => {:error_str => error_str, :search_ctls => session[:search_ctls], :agatha_email_id => agatha_email_id, :success_str => success_str } }

    end
  end

  def send_email()
    ids = [];
    ids << params[:email_id];
    send_emails(ids)
  end
  def send_emails_routine(ids)
      error_str =""
    success_str =""
    non_emails = 0;
    has_emails = 0;
    non_email_str = "";
    if(ids == nil || ids.length==0)
      error_str = "You have not selected any emails to send. "
    else
      test_flag = params[:test_flag].to_i;
      user_id = session[:user_id];
      user = User.find(user_id)
      me = Person.find(user.person_id)


      if(test_flag == 0 || (test_flag ==1 && me.email != nil && me.email =~ /@/))



      ids.each do |id|
        agatha_email = AgathaEmail.find(id);
        agatha_email.sent = false;
        to_email = agatha_email.to_email
        if to_email == nil
            to_email = []
        end
        email_addresses = to_email.split(';');
        email_addresses.each do |email_address|
        if email_address =~ /@/
          email_address = email_address.gsub(/\s+/,'');
          has_emails = has_emails +1;
          if(test_flag ==1)
            to_email =  me.email;
          else
            to_email =  email_address
          end
          Rails.logger.debug("email to address is #{to_email}");
          Rails.logger.debug("email from address is #{agatha_email.from_email}");
          Rails.logger.debug("email subject is #{agatha_email.subject}");
          AgathaMailer.with(agatha_email: agatha_email, to_email: to_email).email.deliver_now
          agatha_email.sent = true;
        else
          non_emails = non_emails + 1;
          if non_email_str.length >0
            non_email_str << ", ";
          end
          non_email_str << id.to_s
        end
        end
        agatha_email.save;

      end
           if test_flag == 1
            success_str = "Testing: "
          else
            success_str = ""
          end
        non_email_str  = non_email_str.gsub(/,\s*(\d+)$/,' and \1')
        if(non_emails >0)
          @pluralize_num = non_emails

          success_str << "The " + pl("email") +" with " +pl("id") +" "+  non_email_str +" "+ pl("does") + " not have "  + pl("a") + " valid email " + pl("address") + ". ";
        end
          @pluralize_num = has_emails
          success_str << pl(has_emails.to_s) + " " + pl("email") +" "+ pl("was") + " sent. "


      else
         error_str = "You are logged in as user #{user.name} which is associated with the person #{me.first_name} #{me.second_name}, but this person does not have a valid email which can be used for testing. "
      end
    end
    ret_val = {}
    ret_val["success_str"] = success_str
    ret_val["error_str"] = error_str
    return ret_val
  end
  def send_emails(ids)


      status_val = send_emails_routine(ids)
      error_str = status_val["error_str"];


    
      respond_to do |format|
      format.js  { render "send_emails", :locals => { :status_val => status_val, :error_str => error_str } } 

    end
  end


  def pl(str)
    x = 1;
    ret_val = "";
    if( @pluralize_num == 0 || @pluralize_num > 1)
      if str == "0"
        ret_val = "No"
      elsif str =~ /^\d+$/
        ret_val = str;
      elsif str == "was"
        ret_val ="were"
      elsif str == "does"
        ret_val = "do"
      elsif str == "a"
        ret_val = ""
      elsif str == "has"
        ret_val = "have"
      else
        ret_val = str.pluralize;
      end
    else
      ret_val = str;
    end
    return ret_val;

  end

  def conv(str)
    str = str.gsub(/(“|”)/,'"').gsub(/(’|‘)/,'\'').gsub(/–/,'-');

  end

  def create_email_from_template(ids, send_flag)
    string_update
    success_str = "";
    warning_str="";
    if(ids == nil || ids.length==0)
      error_str = "You have not selected any students"
    else
      email_ids = []
      error_str = ""
      email_template_id = params[:email_template_id].to_i;
      term_id = params[:term_id].to_i;
      course_id = params[:course_id].to_i;
      template = EmailTemplate.find(email_template_id);
      if(template.course_dependency && course_id == SearchController::NOT_SET)
        error_str = "This template depends on a course, but you have not selected one. "
      elsif(template.term_dependency && term_id == SearchController::NOT_SET)
        error_str = "This template depends on a term, but you have not selected one. "
      else
        term = Term.find(term_id);
        course = Course.find(course_id);
        
        if template.global_warnings != nil && template.global_warnings.length>0
        eval(template.global_warnings);
        end
        id_str = "";



        ids.each do |id|

          person = Person.find(id);
          if person.salutation != nil && person.salutation.length >0
             #Rails.logger.error("email test #{person.salutation.length }");
          else
             #Rails.logger.error("email test nil or 0"); 
          end
          if template.personal_warnings != nil && template.personal_warnings.length >0
            eval(template.personal_warnings);
          end

          if  template.ruby_header.length > 0
            body_str = template.ruby_header + template.body;
          else
            body_str =  template.body;
          end
          body_str  = body_str.gsub(/&amp;(?=([^<]*?)%>)/,"&");
          body_str  = body_str.gsub(/&nbsp;(?=([^<]*?)%>)/," ");


          agatha_email = AgathaEmail.new
          user_id = session[:user_id]
          user = User.find(user_id);
          user_person_id = user.person_id
          user_person = Person.find(user_person_id);
          Rails.logger.info("Create email, term_year=#{term.year}");
          Rails.logger.info("Create email, body_str=#{body_str}");

          agatha_email.from_email = render_to_string( :inline => template.from_email , :locals => { :me => user_person})
          agatha_email.to_email = person.email
          subject_str = render_to_string( :inline => template.subject , :locals => { :person => person, :term => term, :course => course })
          agatha_email.subject = conv(subject_str);
          Rails.logger.debug("pre-rendered body string = #{body_str}");
          begin
             body_str = render_to_string( :inline => body_str , :locals => { :person => person, :term => term, :course => course });
          rescue Exception =>exc
            body_str = "";
            error_str = "Agatha Email Error has occurred. There is something wrong with the template" 
          end
          Rails.logger.info("body_string_ = #{body_str}");
          agatha_email.body = conv(body_str);
          agatha_email.sent = false
          agatha_email.email_template_id = email_template_id
          agatha_email.person_id = id;
          agatha_email.term_id = term_id;
          agatha_email.course_id = course_id;
          agatha_email.save;
          Rails.logger.info("Created email with id = #{agatha_email.id}");
          #new_emails << agatha_email;
          email_ids << agatha_email.id
          if id_str.length >0
            id_str << ", "
          end
          id_str <<  agatha_email.id.to_s;
        end
        @pluralize_num = ids.length;
        success_str = pl(@pluralize_num.to_s) + " " +  pl("email") + " " + pl("was") + " created. ";
        if send_flag
          status_val = send_emails_routine(email_ids);
          success_str = success_str + status_val["success_str"] + status_val["error_str"];
        end
      end
    end
    @search_ctls = session[:search_ctls];
    search_ctl = @search_ctls["AgathaEmail"];
    respond_to do |format|
      format.js  {render "create_email_from_template", :locals => {:error_str => error_str, :success_str => success_str, :warning_str=> warning_str, :id_str=> id_str, :search_ctl => search_ctl } }

    end
  end
  def max_tutorials(ids)
      people_ids = ids[0 .. -1]
      Rails.logger.info("b max_tutorials ids = #{ids.length}")
    success_str = "";
    if(ids == nil || ids.length==0)
      error_str = "You have not selected any people"
    else
      error_str = ""
      term_id = params[:term_id];
      max_tutorials_number = params[:max_tutorials];
      id_str = "";
      ids.each do |id|
        if(id_str.length >0 )
          id_str << ", ";
        end
        id_str << id.to_s;
      end

      present_max_tutorials = MaximumTutorial.find_by_sql("SELECT * FROM maximum_tutorials WHERE person_id IN (#{id_str}) AND term_id =#{term_id}");
      present_num = present_max_tutorials.length;
      present_max_tutorials.each do |max_tutorial|
        ids.delete(max_tutorial.person_id.to_s)
        max_tutorial.max_tutorials = max_tutorials_number;
        max_tutorial.save;
      end
      
      ids.each do |id|
        max_tutorial = MaximumTutorial.new;
        max_tutorial.term_id = term_id;
        max_tutorial.person_id = id;
        max_tutorial.max_tutorials = max_tutorials_number;
        max_tutorial.save;
      end
      new_num = ids.length;
      success_str  ="";
      if present_num ==1
        success_str = "1 maximum tutorial entry was updated in the database. "
      elsif present_num >1
       success_str = "#{present_num} maximum tutorial entries were updated in the database. "
      end
      if new_num == 1
        success_str << "1 new maximum maximum tutorial entry was added to the database. "
      elsif new_num >1
        success_str << "#{new_num} new maximum tutorial entries were added to the database. "
      end

    end
    
    # ActionCable invalidation notification for max_tutorials
    if error_str.empty? && people_ids.any?
      begin
        affected_relationships = []
        
        # Person table updates for max tutorials changes
        affected_relationships << {
          table: "Person",
          operation: "update", 
          ids: people_ids.map(&:to_s),
          reason: "max_tutorials_updated",
          source_operation: "max_tutorials"
        }
        
        # MaximumTutorial table updates (creates and updates)
        all_max_tutorial_ids = []
        if present_num > 0
          # Updated existing MaximumTutorial records
          updated_max_tutorial_ids = present_max_tutorials.map(&:id).map(&:to_s)
          all_max_tutorial_ids.concat(updated_max_tutorial_ids)
          affected_relationships << {
            table: "MaximumTutorial",
            operation: "update",
            ids: updated_max_tutorial_ids,
            reason: "max_tutorials_value_updated",
            source_operation: "max_tutorials"
          }
        end
        
        if new_num > 0
          # Created new MaximumTutorial records - get their IDs
          new_max_tutorial_records = MaximumTutorial.where(person_id: ids.map(&:to_i), term_id: term_id)
          new_max_tutorial_ids = new_max_tutorial_records.map(&:id).map(&:to_s)
          all_max_tutorial_ids.concat(new_max_tutorial_ids)
          affected_relationships << {
            table: "MaximumTutorial", 
            operation: "create",
            ids: new_max_tutorial_ids,
            reason: "new_max_tutorial_records",
            source_operation: "max_tutorials"
          }
        end
        
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          type: "data_invalidation",
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f,
          source_action: "max_tutorials",
          metadata: {
            term_id: term_id,
            max_tutorials_number: max_tutorials_number,
            people_count: people_ids.length,
            updates_count: present_num,
            creates_count: new_num
          }
        })
        
        Rails.logger.info("RWV ActionCable broadcast sent for max_tutorials: #{affected_relationships.length} relationships affected")
      rescue => e
        Rails.logger.error("RWV ActionCable broadcast failed for max_tutorials: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
      end
    else
      Rails.logger.info("RWV Skipping ActionCable invalidation broadcast for max_tutorials due to error or no people")
    end
    
    table_name = "Person"
    @search_ctls=session[:search_ctls]
    search_ctl = @search_ctls[table_name]

    
    
    respond_to do |format|
      format.js  {render "max_tutorials", :locals => {:search_ctl => search_ctl, :ids => people_ids, :success_str => success_str, :error_str => error_str} } 
    
    end

  end

  def assign_tutor(ids)
    success_str = "";
    error_str = "";
    if(ids == nil || ids.length==0)
      error_str = "You have not selected any tutorial schedules"
    else
      error_str = ""
      tutor_id = params[:id];
      id_str = "";
      ids.each do |id|
        if(id_str.length >0 )
          id_str << ", ";
        end
        id_str << id.to_s;
      end
      tutorial_schedules = TutorialSchedule.find_by_sql("SELECT * FROM tutorial_schedules WHERE id IN (#{id_str})");
      tutorial_schedules.each do |tutorial_schedule|
        tutorial_schedule.person_id = tutor_id;
        tutorial_schedule.save;
      end
      
      # ActionCable invalidation notification for assign_tutor
      if tutorial_schedules.any?
        begin
          Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for assign_tutor operation")
          
          # Build affected relationships for tutor assignment
          affected_relationships = []
          
          # TutorialSchedule records updated (new tutor assigned)
          affected_relationships << {
            table: "TutorialSchedule",
            operation: "update",
            ids: ids.map(&:to_i),
            reason: "tutor_assigned",
            source_operation: "assign_tutor"
          }
          
          # Person record updated (shows new tutor assignments)
          affected_relationships << {
            table: "Person",
            operation: "update",
            ids: [tutor_id.to_i],
            reason: "tutor_assignments_added",
            source_operation: "assign_tutor"
          }
          
          Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships for assign_tutor")
          affected_relationships.each do |rel|
            Rails.logger.info("RWV  - #{rel[:table]} #{rel[:operation]} (#{rel[:ids]&.length || 0} records): #{rel[:reason]}")
          end
          
          # Broadcast the invalidation notification
          ActionCable.server.broadcast("search_table_updates", {
            action: "data_invalidation",
            triggered_by: {
              user_id: session[:user_id],
              operation: "assign_tutor",
              tutor_id: tutor_id,
              tutorial_schedule_ids: ids
            },
            affected_relationships: affected_relationships,
            timestamp: Time.current.to_f
          })
          
          Rails.logger.info("RWV Successfully broadcast invalidation notification for assign_tutor operation")
          
        rescue => e
          Rails.logger.error "RWV ActionCable broadcast failed in assign_tutor: #{e.message}"
          Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
          # Continue without ActionCable if it fails
        end
      else
        Rails.logger.info("RWV Skipping ActionCable invalidation broadcast for assign_tutor due to no tutorial schedules")
      end
      
      num_updates = tutorial_schedules.length;
      if (num_updates == 0)
        success_str = "No tutor updates were made. "
      elsif num_updates ==1
        success_str = "One tutor update was made. "
      else
        success_str = "#{num_updates} tutor updates were made. "
      end
    end
    @search_ctls = session[:search_ctls];
    edited_table_name = "TutorialSchedule";
    if error_str.length>0
      alert_str = error_str;
      alert_status = 'error';
    else
      alert_str = success_str;
      alert_status = 'success';
    end

    respond_to do |format|
      format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => alert_status } }
    end
    
  end

  def  make_willing_lecturer(ids)
     alert_str= "";
     affected_course_ids = []
    if ids != nil && ids.length > 0
      person_id = params[:willing_id];
      already_willing = 0;
      new_willing = 0;
      ids.each do |course_id|
        present = WillingLecturer.find_by_sql("SELECT * FROM willing_lecturers WHERE person_id = #{person_id} AND course_id = #{course_id}");
        if present !=nil && present.length >0
          already_willing = already_willing + 1;
        else
          new_willing = new_willing +1;
          willing_lecturer = WillingLecturer.new;
          willing_lecturer.person_id = person_id;
          willing_lecturer.course_id = course_id;
          willing_lecturer.order_of_preference = 1;
          willing_lecturer.save;
          affected_course_ids << course_id.to_i
        end
      end
      
      # Send data invalidation for affected courses
      if affected_course_ids.any?
        begin
          ActionCable.server.broadcast("search_table_updates", {
            action: "data_invalidation",
            triggered_by: {
              user_id: session[:user_id] || 0,
              operation: "make_willing_lecturer",
              person_id: person_id.to_i,
              course_ids: affected_course_ids
            },
            affected_relationships: [
              {
                table: 'WillingLecturer',
                operation: 'create',
                ids: [], # New records, so no specific IDs yet
                reason: "New willing lecturer records created",
                source_operation: "make_willing_lecturer"
              },
              {
                table: 'Person',
                operation: 'update',
                ids: [person_id.to_i],
                reason: "Person #{person_id} became willing lecturer for courses",
                source_operation: "make_willing_lecturer"
              },
              {
                table: 'Course',
                operation: 'update',
                ids: affected_course_ids,
                reason: "Courses gained new willing lecturer (Person #{person_id})",
                source_operation: "make_willing_lecturer"
              }
            ],
            timestamp: Time.current.to_f
          })
          Rails.logger.info("RWV Successfully broadcast invalidation notification for make_willing_lecturer operation")
          Rails.logger.info("RWV Affected tables: WillingLecturer (create), Person #{person_id} (update), Courses #{affected_course_ids} (update)")
        rescue => e
          Rails.logger.error "RWV ActionCable broadcast failed in make_willing_lecturer: #{e.message}"
        end
      end
      
      if new_willing == 0
        alert_str = "No willing lecturer entries were added to the database. "
      elsif new_willing == 1
        alert_str = "1 willing lecturer entry was added to the database. "
      else
        alert_str = "#{new_willing} willing lecturer entries were added to the database. "
      end
      if already_willing==1
        alert_str << "1 willing lecturer entry was already in the database for person with id #{person_id}. "
      elsif already_willing>1
        alert_str << "#{already_willing} willing lecturer entries were already in the database for person with id #{person_id}. "
      end
    else
      alert_str = "You did not select any courses. "
    end
    respond_to do |format|
      format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => (alert_str.include?("did not select") ? 'error' : 'success')} }
    end
  end

    def  make_willing_tutor(ids)
     alert_str= "";
     affected_course_ids = []
    if ids != nil && ids.length > 0
      person_id = params[:willing_id];
      already_willing = 0;
      new_willing = 0;
      ids.each do |course_id|
        present = WillingTutor.find_by_sql("SELECT * FROM willing_tutors WHERE person_id = #{person_id} AND course_id = #{course_id}");
        if present !=nil && present.length >0
          already_willing = already_willing + 1;
        else
          new_willing = new_willing +1;
          willing_tutor = WillingTutor.new;
          willing_tutor.person_id = person_id;
          willing_tutor.course_id = course_id;
          willing_tutor.order_of_preference = 1;
          willing_tutor.save;
          affected_course_ids << course_id.to_i
        end
      end
      
      # Send data invalidation for affected courses
      if affected_course_ids.any?
        begin
          ActionCable.server.broadcast("search_table_updates", {
            action: "data_invalidation",
            triggered_by: {
              user_id: session[:user_id] || 0,
              operation: "make_willing_tutor",
              person_id: person_id.to_i,
              course_ids: affected_course_ids
            },
            affected_relationships: [
              {
                table: 'WillingTutor',
                operation: 'create',
                ids: [], # New records, so no specific IDs yet
                reason: "New willing tutor records created",
                source_operation: "make_willing_tutor"
              },
              {
                table: 'Person',
                operation: 'update',
                ids: [person_id.to_i],
                reason: "Person #{person_id} became willing tutor for courses",
                source_operation: "make_willing_tutor"
              },
              {
                table: 'Course',
                operation: 'update',
                ids: affected_course_ids,
                reason: "Courses gained new willing tutor (Person #{person_id})",
                source_operation: "make_willing_tutor"
              }
            ],
            timestamp: Time.current.to_f
          })
          Rails.logger.info("RWV Successfully broadcast invalidation notification for make_willing_tutor operation")
          Rails.logger.info("RWV Affected tables: WillingTutor (create), Person #{person_id} (update), Courses #{affected_course_ids} (update)")
        rescue => e
          Rails.logger.error "RWV ActionCable broadcast failed in make_willing_tutor: #{e.message}"
        end
      end
      
      if new_willing == 0
        alert_str = "No willing tutor entries were added to the database. "
      elsif new_willing == 1
        alert_str = "1 willing tutor entry was added to the database. "
      else
        alert_str = "#{new_willing} willing tutor entries were added to the database. "
      end
      if already_willing==1
        alert_str << "1 willing tutor entry was already in the database for person with id #{person_id}. "
      elsif already_willing>1
        alert_str << "#{already_willing} willing tutor entries were already in the database for person with id #{person_id}. "
      end
    else
      alert_str = "You did not select any courses. "
    end
    respond_to do |format|
      format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => (alert_str.include?("did not select") ? 'error' : 'success')} }

    end
  end
  
  def create_tutorial_schedules(ids)
    tutor_id = params[:tutor_id];
    course_id =  params[:course_id];
    class_size = params[:tutorial_class_size].to_i;
    new_tutorial_schedule_ids = [];
    success_str = '';
    error_str = '';
    if ids != nil && ids.length > 0
      if class_size < 1
        class_size =1;
      end

      number_of_students = ids.length+0.000001;
      number_of_classes = (number_of_students/class_size).round;

      class_count = 1;
      a_class = [];
      tutorial_classes = [];
      student_count = 1;
      upper_bound = (number_of_students * class_count/number_of_classes);
      ids.each do |student_id|
        a_class << student_id;
        student_count= student_count +1;
        if student_count > upper_bound
          tutorial_classes << a_class;
          a_class = [];
          class_count = class_count +1;
          upper_bound = (number_of_students * class_count/number_of_classes);
        end
      end
      if a_class.length>0
        tutorial_classes << a_class;
      end

      tutorial_classes.each do |tutorial_class|
        tutorial_schedule = TutorialSchedule.new;
        tutorial_schedule.course_id = course_id
        tutorial_schedule.person_id = tutor_id
        tutorial_schedule.term_id = params[:term_id];
        tutorial_schedule.number_of_tutorials = params[:number_of_tutorials];        
        tutorial_schedule.number_of_tutorial_hours = params[:number_of_tutorials];
        tutorial_schedule.save;
        new_tutorial_schedule_ids << tutorial_schedule.id;
        tutorial_class.each do |student_id|
        tutorial = Tutorial.new;
        tutorial.person_id = student_id;
        tutorial.tutorial_schedule_id = tutorial_schedule.id;
        tutorial.collection_status = params[:collection_required];
        tutorial.save;
        end
        present = WillingTutor.find_by_sql("SELECT * FROM willing_tutors WHERE person_id = #{tutor_id} AND course_id = #{course_id}");
        if present ==nil || present.length == 0

          willing_tutor = WillingTutor.new;
          willing_tutor.person_id = tutor_id
          willing_tutor.course_id = course_id
          willing_tutor.order_of_preference = 1;
          willing_tutor.save;
        end
      end
      
      # ActionCable invalidation notification for create_tutorial_schedules
      begin
        Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for create_tutorial_schedules operation")
        
        # Collect all created tutorial schedule IDs and tutorial IDs
        created_tutorial_schedule_ids = []
        created_tutorial_ids = []
        affected_person_ids = [tutor_id.to_i] + ids.map(&:to_i)

        
        # Get the tutorial schedules we just created to extract their IDs
        recent_tutorial_schedules = TutorialSchedule.where(
          course_id: course_id,
          person_id: tutor_id,
          term_id: params[:term_id]
        ).order(created_at: :desc).limit(tutorial_classes.length)
        
        created_tutorial_schedule_ids = recent_tutorial_schedules.pluck(:id)
        
        # Get the tutorials we just created
        if created_tutorial_schedule_ids.any?
          created_tutorial_ids = Tutorial.where(tutorial_schedule_id: created_tutorial_schedule_ids).pluck(:id)
        end
        
        # Build affected relationships for tutorial schedule creation
        affected_relationships = []
        
        # New TutorialSchedule records created
        affected_relationships << {
          table: "TutorialSchedule",
          operation: "create",
          ids: created_tutorial_schedule_ids,
          reason: "tutorial_schedules_created",
          source_operation: "create_tutorial_schedules"
        }
        
        # New Tutorial records created
        if created_tutorial_ids.any?
          affected_relationships << {
            table: "Tutorial",
            operation: "create",
            ids: created_tutorial_ids,
            reason: "tutorials_created",
            source_operation: "create_tutorial_schedules"
          }
        end
        
        # Person records updated (tutor and all students now have new tutorial relationships)
        affected_relationships << {
          table: "Person",
          operation: "update",
          ids: affected_person_ids,
          reason: "tutorial_relationships_added",
          source_operation: "create_tutorial_schedules"
        }
        
        # Course record updated (now has new tutorial schedules)
        affected_relationships << {
          table: "Course",
          operation: "update",
          ids: [course_id.to_i],
          reason: "tutorial_schedules_added",
          source_operation: "create_tutorial_schedules"
        }
        
        # WillingTutor record potentially created
        if tutorial_classes.length > 0
          affected_relationships << {
            table: "WillingTutor",
            operation: "create",
            ids: [], # We don't have the specific ID easily available
            reason: "willing_tutor_created",
            source_operation: "create_tutorial_schedules"
          }
        end
        
        Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships for create_tutorial_schedules")

        if affected_relationships.any? && new_tutorial_schedule_ids.length > 0
           ActionCable.server.broadcast("search_table_updates", {
             action: "data_invalidation",
             triggered_by: {
               user_id: session[:user_id] || 0,
               table: "TutorialSchedule",
               operation: "create",
               object_id: new_tutorial_schedule_ids[0]
             },
             affected_relationships: affected_relationships,
             timestamp: Time.current.to_f
           })
           Rails.logger.info("Broadcast data invalidation for lecture creation affecting: Course #{course_id}, Person #{person_id}, Lecture #{tutorial_schedule.id}")
        end
 
   
        
        Rails.logger.info("RWV Successfully broadcast invalidation notification for create_tutorial_schedules operation")
        
      rescue => e
        Rails.logger.error "RWV ActionCable broadcast failed in create_tutorial_schedules: #{e.message}"
        Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
      
      @pluralize_num = tutorial_classes.length;
      success_str = "#{@pluralize_num} Tutorial/Tutorial " + pl("Schedule") +" created";
    else
      ids = [];
      error_str = "You did not select any students. "
    end

    # Check if TutorialSchedule table search has been performed to determine display update strategy
    search_done = params[:search_done] == 'true'
    Rails.logger.debug("WelcomeController:create_tutorial_schedules search_done: #{search_done}")
    
    # Prepare TutorialSchedule table rows for display (similar to create_lecture_schedule)
    search_ctls = session[:search_ctls]
    new_rows = []
    tutorial_schedule_search_results = nil
    
    if search_ctls && search_ctls["TutorialSchedule"] && new_tutorial_schedule_ids.any?
      search_ctl_tutorial_schedule = search_ctls["TutorialSchedule"]
      begin
        eval("TutorialSchedule.set_controller(search_ctl_tutorial_schedule)")
        
        # Create row objects for each new tutorial schedule
        new_tutorial_schedule_ids.each do |tutorial_schedule_id|
          tutorial_schedule = TutorialSchedule.find(tutorial_schedule_id)
          
          # Create a simple object with the required attributes for the template
          new_row = OpenStruct.new(
            id: tutorial_schedule.id,
            class_name: "TutorialSchedule",
            search_controller: search_ctl_tutorial_schedule
          )
          
          # Copy all the tutorial_schedule attributes to new_row so filter.eval_str can access them
          tutorial_schedule.attributes.each do |key, value|
            new_row.send("#{key}=", value) unless new_row.respond_to?(key)
          end
          
          new_rows << new_row
        end
        
        Rails.logger.debug("DEBUG: Created TutorialSchedule row objects for #{new_rows.length} new TutorialSchedules")
        
        # If no search has been performed on TutorialSchedule table, create a SearchResults with the new rows
        if !search_done
          tutorial_schedule_search_results = SearchResults.new(new_rows, :search_results, search_ctl_tutorial_schedule)
        end
        
      rescue => e
        Rails.logger.error("ERROR creating TutorialSchedule row objects: #{e.message}")
        new_rows = []
      end
    else
      Rails.logger.debug("DEBUG: No search controller found for TutorialSchedule or no tutorial schedules created")
    end

    if error_str.length>0
      alert_str = error_str;
      alert_status = 'error';
      
      respond_to do |format|
        format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => alert_status } }
      end
    else
      alert_str = success_str;
      alert_status = 'success';
      
      @search_ctls = session[:search_ctls];
      search_ctl_tutorial_schedule = @search_ctls["TutorialSchedule"];

      respond_to do |format|
        if search_done
          # If TutorialSchedule search was already performed, add to existing table
          # For multiple new rows, we'll render the first one and let ActionCable handle the rest
          format.js { 
            render "new", :locals => { 
              :table_name => "TutorialSchedule", 
              :id => new_tutorial_schedule_ids.first, 
              :class_name => "TutorialSchedule", 
              :new_row => new_rows.first, 
              :search_done => search_done, 
              :search_ctl => search_ctl_tutorial_schedule,
              :success_str => "Tutorial schedule created successfully"
            } 
          }
        else
          # If no TutorialSchedule search was performed, render a new TutorialSchedule table with all new entries
          format.js { 
            render "table_search", :locals => {
              :search_ctl => search_ctl_tutorial_schedule, 
              :params => params, 
              :table_name => "TutorialSchedule", 
              :search_results => tutorial_schedule_search_results,
              :new_entry_id => new_tutorial_schedule_ids.first,
              :open_edit => false,
              :success_str => "Tutorial schedule created successfully",
              :display_notification => true
            }
          }        
        end
        format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => alert_status } }        
      end
    end    
    
  end



  
  def create_lecture_schedule
    lecture = Lecture.new;
    person_id = params[:person_id];
    course_id =  params[:course_id];
    lecture.course_id = params[:course_id];
    lecture.person_id = params[:person_id];
    lecture.day_id = params[:day_id];
    lecture.lecture_time = params[:lecture_time];
    lecture.location_id = SearchController::NOT_SET;
    lecture.term_id = params[:term_id];
    lecture.exam = "";
    lecture.notes = "";
    lecture.number_of_classes = params[:number_of_classes];
    lecture.number_of_lectures = params[:number_of_lectures];
    lecture.save;

    success_str = "Lecture schedule created successfully with id #{lecture.id}";

     present = WillingLecturer.find_by_sql("SELECT * FROM willing_lecturers WHERE person_id = #{person_id} AND course_id = #{course_id}");
        if present ==nil || present.length == 0

          willing_lecturer = WillingLecturer.new;
          willing_lecturer.person_id =  person_id
          willing_lecturer.course_id =  course_id 
          willing_lecturer.order_of_preference = 1;
          willing_lecturer.save;
        end

    # Check if Lecture table search has been performed to determine display update strategy
    search_done = params[:search_done] == 'true'
    Rails.logger.debug("WelcomeController:create_lecture_schedule search_done: #{search_done}")
    
    # Prepare Lecture table row for display (similar to new method and new_group)
    search_ctls = session[:search_ctls]
    new_row = nil
    lecture_search_results = nil
    
    if search_ctls && search_ctls["Lecture"]
      search_ctl_lecture = search_ctls["Lecture"]
      begin
        eval("Lecture.set_controller(search_ctl_lecture)")
        
        # Create a simple object with the required attributes for the template
        new_row = OpenStruct.new(
          id: lecture.id,
          class_name: "Lecture",
          search_controller: search_ctl_lecture
        )
        
        # Copy all the lecture attributes to new_row so filter.eval_str can access them
        lecture.attributes.each do |key, value|
          new_row.send("#{key}=", value) unless new_row.respond_to?(key)
        end
        
        Rails.logger.debug("DEBUG: Created Lecture row object for new Lecture with ID #{lecture.id}")
        
        # If no search has been performed on Lecture table, create a SearchResults with just the new row
        if !search_done
          lecture_search_results = SearchResults.new([new_row], :search_results, search_ctl_lecture)
        end
        
      rescue => e
        Rails.logger.error("ERROR creating Lecture row object: #{e.message}")
        new_row = nil
      end
    else
      Rails.logger.debug("DEBUG: No search controller found for Lecture")
    end

    # Send data invalidation for lecture creation
    begin
      affected_relationships = []
      
      # Course is affected because it now has a new lecture
      if course_id.present? && course_id.to_i != SearchController::NOT_SET
        affected_relationships << {
          table: 'Course',
          operation: 'update',
          ids: [course_id.to_i],
          reason: "Course #{course_id} has new lecture #{lecture.id}"
        }
      end
      
      # Person is affected because they are now lecturing this course
      if person_id.present? && person_id.to_i != SearchController::NOT_SET
        affected_relationships << {
          table: 'Person',
          operation: 'update',
          ids: [person_id.to_i],
          reason: "Person #{person_id} is now lecturer for lecture #{lecture.id}"
        }
      end
      
      # Lecture itself is a new record
      affected_relationships << {
        table: 'Lecture',
        operation: 'create',
        ids: [lecture.id],
        reason: "New lecture #{lecture.id} created"
      }
      
      if affected_relationships.any?
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id] || 0,
            table: "Lecture",
            operation: "create",
            object_id: lecture.id
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })
        Rails.logger.info("Broadcast data invalidation for lecture creation affecting: Course #{course_id}, Person #{person_id}, Lecture #{lecture.id}")
      end
    rescue => e
      Rails.logger.error "ActionCable broadcast failed in create_lecture_schedule: #{e.message}"
    end

    @search_ctls = session[:search_ctls];
    search_ctl_lecture = @search_ctls["Lecture"];

    respond_to do |format|
      if search_done && new_row
        # If Lecture search was already performed, add to existing table
        Rails.logger.debug("WelcomeController:create_lecture_schedule rendering new.")
        format.js { 
          render "new", :locals => { 
            :table_name => "Lecture", 
            :id => lecture.id, 
            :class_name => "Lecture", 
            :new_row => new_row, 
            :search_done => search_done, 
            :search_ctl => search_ctl_lecture,
            :success_str => success_str
          }          
        }
      elsif !search_done && lecture_search_results
        # If no Lecture search was performed, render a new Lecture table with just this entry
        Rails.logger.debug("WelcomeController:create_lecture_schedule rendering table_search.")
        format.js { 
          render "table_search", :locals => {
            :search_ctl => search_ctl_lecture, 
            :params => params, 
            :table_name => "Lecture", 
            :search_results => lecture_search_results,
            :new_entry_id => lecture.id,
            :open_edit => false,
            :success_str => success_str,
            :display_notification => true
          }
        }        
      else
        # Fallback to showing success message if row creation failed
        format.js { render :partial => "shared/alert", :locals => {:alert_str => success_str, :status_flag => 'success' } }
      end
    end
  
  end

  def make_attendee(lecture_ids)
    error_str = "";
    success_str="";
    person_id = params[:id];
    if lecture_ids == nil || lecture_ids.length == 0
      error_str = "Add/Update attendee failed: you have not selected any lectures. "
    else
      lecture_list = ""
      lecture_ids.each do |lecture_id|
      if lecture_list.length >0
        lecture_list << ", "
      end
        lecture_list << lecture_id.to_s
      end
      lectures_where_str = "(#{lecture_list})"
      non_present_lectures = Lecture.find_by_sql("SELECT * FROM lectures a0 WHERE a0.id IN #{lectures_where_str} AND (SELECT COUNT(*) FROM attendees a1 WHERE a1.person_id = #{person_id} AND a1.lecture_id = a0.id)=0");
      non_present_lectures.each do |lecture|
        attendee = Attendee.new;
        attendee.lecture_id = lecture.id;
        attendee.person_id = person_id;
        attendee.save;
      end
       exam_ids = params[:exam_in_list];
       exam_list = "";
      if exam_ids == nil || exam_ids.length == 0
         exam_ids = [];
         non_exam_attendees = Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.lecture_id IN #{lectures_where_str} AND a0.person_id = #{person_id}");
         exam_attendees = []
      else
        exam_ids.each do |exam_id|
          if exam_list.length >0
            exam_list << ", "
          end
            exam_list << exam_id.to_s
        end
        exam_attendees = Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.lecture_id IN (#{exam_list}) AND a0.person_id = #{person_id}");
        non_exam_attendees =  Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.lecture_id IN (#{lecture_list}) AND a0.lecture_id NOT IN (#{exam_list}) AND a0.person_id = #{person_id}");
      end
      exam_attendees.each do |attendee|
        attendee.examined = true;
        attendee.save;
      end
      non_exam_attendees.each do |attendee|
        attendee.examined = false;
        attendee.save;
      end
      compulsory_ids = params[:compulsory_in_list];
      compulsory_list = "";
      if compulsory_ids == nil || compulsory_ids.length == 0
         compulsory_ids = [];
         non_compulsory_attendees = Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.lecture_id IN #{lectures_where_str} AND a0.person_id = #{person_id}");
         compulsory_attendees = []
      else
        compulsory_ids.each do |compulsory_id|
          if compulsory_list.length >0
            compulsory_list << ", "
          end
            compulsory_list << compulsory_id.to_s
        end
        compulsory_attendees = Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.lecture_id IN (#{compulsory_list}) AND a0.person_id = #{person_id}");
        non_compulsory_attendees =  Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.lecture_id IN (#{lecture_list}) AND a0.lecture_id NOT IN (#{compulsory_list}) AND a0.person_id = #{person_id}");
      end
      compulsory_attendees.each do |attendee|
        attendee.compulsory = true;
        attendee.save;
      end
      non_compulsory_attendees.each do |attendee|
        attendee.compulsory = false;
        attendee.save;
      end
      non_present_num = non_present_lectures.length;
      if non_present_num == 0
        success_str = "Attendees were updated, although no new lecture was attended because lecture in the selected list was already attended the person. "
      elsif non_present_num ==1
        success_str = "The person was added to one lecture attendee list. "
      else
        success_str = "The person was added to #{non_present_num} lecture attendee lists. "
      end
      if non_present_num != 0
        present_num = lecture_ids.length - non_present_num
        if present_num ==1
          success_str << "The person was already attending the selected lecture. "
        elsif present_num > 1
          success_str << "The person was already on the lecture attendee list of #{present_num} of the lectures. "
        end
      end
    end

    @search_ctls = session[:search_ctls];
    
    # ActionCable invalidation notification for make_attendee
    if error_str.empty? && lecture_ids.any?
      begin
        Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for make_attendee operation")
        
        # Build affected relationships for attendee addition
        affected_relationships = []
        
        # Person row updated (shows new lecture attendance)
        affected_relationships << {
          table: "Person",
          operation: "update",
          ids: [person_id.to_i],
          reason: "attendance_added",
          source_operation: "make_attendee"
        }
        
        # Lecture rows updated (show new attendee counts)
        affected_relationships << {
          table: "Lecture", 
          operation: "update",
          ids: lecture_ids.map(&:to_i),
          reason: "attendee_count_change",
          source_operation: "make_attendee"
        }
        
        # New Attendee records created
        affected_relationships << {
          table: "Attendee",
          operation: "create",
          ids: [], # New records, so no specific IDs yet
          reason: "new_attendee_records",
          source_operation: "make_attendee",
          related_person_id: person_id.to_i,
          related_lecture_ids: lecture_ids.map(&:to_i)
        }
        
        Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships for make_attendee")
        affected_relationships.each do |rel|
          Rails.logger.info("RWV  - #{rel[:table]} #{rel[:operation]} (#{rel[:ids].length} records): #{rel[:reason]}")
        end
        
        # Broadcast the invalidation notification
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id],
            operation: "make_attendee",
            person_id: person_id.to_i,
            lecture_ids: lecture_ids.map(&:to_i)
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })
        
        Rails.logger.info("RWV Successfully broadcast invalidation notification for make_attendee operation")
        
      rescue => e
        Rails.logger.error "RWV ActionCable broadcast failed in make_attendee: #{e.message}"
        Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
    else
      Rails.logger.info("RWV Skipping ActionCable invalidation broadcast for make_attendee due to error or no lectures");
    end

    if error_str.length>0
      alert_str = error_str;
      alert_status = 'error';
    else
      alert_str = success_str;
      alert_status = 'success';
    end

    respond_to do |format|
      format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => alert_status } }
    end
    

  end


  def add_to_lectures(people_ids)
    lecture_id = params[:id];
    error_str = "";
    success_str="";
    if people_ids == nil || people_ids.length == 0
      error_str = "Add/Update lectures failed: you have not selected any people. "
    else
      people_list = ""
      people_ids.each do |person_id|
      if people_list.length >0
        people_list << ", "
      end
        people_list << person_id.to_s
      end
      people_where_str = "(#{people_list})"
      non_present_people = Person.find_by_sql("SELECT * FROM people a0 WHERE a0.id IN #{people_where_str} AND (SELECT COUNT(*) FROM attendees a1 WHERE a1.person_id = a0.id AND a1.lecture_id = #{lecture_id})=0");
      non_present_people.each do |person|
        attendee = Attendee.new;
        attendee.lecture_id = lecture_id;
        attendee.person_id = person.id;
        attendee.save;
      end
      exam_ids = params[:exam_in_list];
      
      exam_list = "";
      if exam_ids == nil || exam_ids.length == 0
         exam_ids = [];
         non_exam_attendees = Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.person_id IN #{people_where_str} AND a0.lecture_id = #{lecture_id}");
         exam_attendees = []
      else
        exam_ids.each do |exam_id|
          if exam_list.length >0
            exam_list << ", "
          end
            exam_list << exam_id.to_s
        end
        exam_attendees = Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.person_id IN (#{exam_list}) AND a0.lecture_id = #{lecture_id}");
        non_exam_attendees =  Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.person_id IN (#{people_list}) AND a0.person_id NOT IN (#{exam_list}) AND a0.lecture_id = #{lecture_id}");
      end
      exam_attendees.each do |attendee|
        attendee.examined = true;
        attendee.save;
      end
      non_exam_attendees.each do |attendee|
        attendee.examined = false;
        attendee.save;
      end
      compulsory_ids = params[:compulsory_in_list];
      compulsory_list = "";
      if compulsory_ids == nil || compulsory_ids.length == 0
         compulsory_ids = [];
         non_compulsory_attendees = Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.person_id IN #{people_where_str} AND a0.lecture_id = #{lecture_id}");
         compulsory_attendees = []
      else
        compulsory_ids.each do |compulsory_id|
          if compulsory_list.length >0
            compulsory_list << ", "
          end
            compulsory_list << compulsory_id.to_s
        end
        compulsory_attendees = Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.person_id IN (#{compulsory_list}) AND a0.lecture_id = #{lecture_id}");
        non_compulsory_attendees =  Attendee.find_by_sql("SELECT * FROM attendees a0 WHERE a0.person_id IN (#{people_list}) AND a0.person_id NOT IN (#{compulsory_list}) AND a0.lecture_id = #{lecture_id}");
      end
      compulsory_attendees.each do |attendee|
        attendee.compulsory = true;
        attendee.save;
      end
      non_compulsory_attendees.each do |attendee|
        attendee.compulsory = false;
        attendee.save;
      end
      non_present_num = non_present_people.length;
      if non_present_num == 0
        success_str = "Attendees were updated, although no one was added because everyone in the selected list was already attending the lecture course. "
      elsif non_present_num ==1
        success_str = "One person was added to the lecture attendee list. "
      else
        success_str = "#{non_present_num} people were added to the lecture attendee list. "
      end
      if non_present_num != 0
        present_num = people_ids.length - non_present_num
        if present_num ==1
          success_str << "One person was already on the lecture attendee list. "
        elsif present_num > 1
          success_str << "#{present_num} people were already on the lecture attendee list. "
        end
      end
    end

    # ActionCable invalidation notifications for attendance changes
    if error_str.empty?
      Rails.logger.info("ActionCable: Broadcasting invalidation for add_to_lectures")
      
      # Broadcast proper search table updates for affected objects
      if people_ids.present? && lecture_id.present?
        lecture = Lecture.find(lecture_id) rescue nil
        
        if lecture
          # Broadcast updates for the people and lecture that were modified
          people_ids.each do |person_id|
            person = Person.find(person_id) rescue nil
            if person
              # Broadcast person update (attendance status changed)
              send_data_invalidation_for_update('Person', person, 'lectures_attended_in_term', person_id)
            end
          end
          
          # Broadcast lecture update (attendee list changed)
          send_data_invalidation_for_update('Lecture', lecture, 'attendees', lecture_id)
          
          # Also broadcast any attendee objects that were created
          new_attendees = Attendee.where(person_id: people_ids, lecture_id: lecture_id)
          new_attendees.each do |attendee|
            send_data_invalidation_for_update('Attendee', attendee, 'person_id', attendee.id)
          end
        end
      end
    end

    @search_ctls = session[:search_ctls];
    if error_str.length>0
      alert_str = error_str;
      alert_status = 'error';
    else
      alert_str = success_str;
      alert_status = 'success';
    end

    respond_to do |format|
      format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => alert_status } }
    end
  end

  def remove_from_group(group_id, ids, class_name2)
    Rails.logger.info("RWV remove_from_group BEGIN")
    @user_id = session[:user_id];
    db_group = Group.find(group_id);
    permission = false
    class_ok= false
    num_existing = 0;
    Rails.logger.info("RWV remove_from_group A")
    if(db_group != nil)
        if db_group.private == false || db_group.owner_id = @user_id
            permission = true;
        end
    end
Rails.logger.info("RWV remove_from_group B")
    if(permission)
        Rails.logger.info("RWV remove_from_group C")
        if(class_name2.tableize == db_group.table_name)
            class_ok= true;
            Rails.logger.info("RWV remove_from_group D")
            if (ids.length > 0)
                Rails.logger.info("RWV remove_from_group E")
                id_str = ""
                ids.each do |id|
                    if id_str.length >0
                        id_str << ", "
                    end
                    id_str << id.to_s;
                end
                Rails.logger.info("RWV remove_from_group F")
                already_existing = Group.find_by_sql("SELECT * FROM group_#{class_name2.tableize} WHERE #{class_name2.underscore}_id IN (#{id_str}) AND group_id = #{group_id}");
                num_existing = already_existing.length;
                not_present_members = Array.new(ids);
                Rails.logger.info("RWV remove_from_group G")
                
                already_existing.each do |existing|
                    existing_id_str = "existing.#{class_name2.underscore}_id";
                    existing_id = eval(existing_id_str)
                    Rails.logger.info("RWV remove_from_group existing_id_str = #{existing_id_str}, existing_id = #{existing_id}")
                    not_present_members.delete(existing_id.to_s);
                end
                Rails.logger.info("RWV remove_from_group H")
                Rails.logger.info("RWV remove_from_group not_present_members = #{not_present_members.inspect}");
                already_existing.each do |delete_obj|
                    destroy_str = "Group#{class_name2}.destroy(#{delete_obj.id})";
                    Rails.logger.info("RWV remove_from_group #{destroy_str}");
                    eval(destroy_str);
                    # delete_obj.destroy;
                end
                Rails.logger.info("RWV remove_from_group I")
            end
            Rails.logger.info("RWV remove_from_group J")
        end
        Rails.logger.info("RWV remove_from_group K")
    end
    
    # ActionCable invalidation notification for remove_from_group
    if permission && class_ok && num_existing > 0
      begin
        Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for remove_from_group operation")
        
        # Build affected relationships for group membership removal
        affected_relationships = []
        
        # Group record updated (member count changed)
        affected_relationships << {
          table: "Group",
          operation: "update",
          ids: [group_id],
          reason: "group_membership_removed",
          source_operation: "remove_from_group"
        }
        
        # GroupMembership records deleted
        group_membership_table = "Group#{class_name2}"
        affected_relationships << {
          table: group_membership_table,
          operation: "delete",
          ids: [], # Records were deleted, so no specific IDs
          reason: "group_memberships_deleted",
          source_operation: "remove_from_group",
          related_group_id: group_id,
          related_member_ids: ids.map(&:to_i)
        }
        
        # Member records updated (group membership removed)
        affected_relationships << {
          table: class_name2,
          operation: "update",
          ids: ids.map(&:to_i),
          reason: "group_membership_removed",
          source_operation: "remove_from_group"
        }
        
        Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships for remove_from_group")
        affected_relationships.each do |rel|
          Rails.logger.info("RWV  - #{rel[:table]} #{rel[:operation]} (#{rel[:ids]&.length || 0} records): #{rel[:reason]}")
        end
        
        # Broadcast the invalidation notification
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id],
            operation: "remove_from_group",
            group_id: group_id,
            class_name: class_name2,
            member_ids: ids || []
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })
        
        Rails.logger.info("RWV Successfully broadcast invalidation notification for remove_from_group operation")
        
      rescue => e
        Rails.logger.error "RWV ActionCable broadcast failed in remove_from_group: #{e.message}"
        Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
    else
      Rails.logger.info("RWV Skipping ActionCable invalidation broadcast for remove_from_group due to permission/class/existence issues");
    end
    
    Rails.logger.info("RWV remove_from_group L")
    @search_ctls = session[:search_ctls];
    if class_ok
        Rails.logger.info("RWV remove_from_group M")
        table_name = class_name2;
        search_ctl = @search_ctls[table_name]; 
        search_ctl_group =  @search_ctls["Group"];
    else
        Rails.logger.info("RWV remove_from_group O")
        search_ctl = nil;
    end
    Rails.logger.info("RWV remove_from_group P")

    respond_to do |format|
        format.js  { render "remove_from_group", :locals => { :db_group => db_group, :group_id => group_id, :permission => permission, :class_ok => class_ok, :class_name2 => class_name2, :not_present_members => not_present_members, :num_existing => num_existing, :search_ctl => search_ctl, :search_ctl_group => search_ctl_group, :ids => ids, :table_name => table_name } }
    end
    Rails.logger.info("RWV remove_from_group END")
    Rails.logger.flush
  end      
   


  def add_to_groups(group_ids, class_id, class_name)
    @user_id = session[:user_id];
    debug_prefix = "WelcomeController:add_to_groups  (#{Time.now.strftime('%H:%M:%S')})"
    Rails.logger.info("#{debug_prefix}: BEGIN");
    permissioned = [];
    if group_ids.length >0
      group_ids_str = "";
      group_ids.each do |group_id|
        if(group_ids_str.length >0)
          group_ids_str << ", "
        end
        group_ids_str << group_id.to_s;
      end
      group_ids_str = "(#{group_ids_str})";
      unpermissioned_str = "SELECT * FROM groups WHERE id IN #{group_ids_str} AND table_name = '#{class_name.tableize}' AND (owner_id != #{@user_id} AND private = true)"
      Rails.logger.info("#{debug_prefix}: unpermissioned_str: #{unpermissioned_str}");
      unpermissioned = Group.find_by_sql(unpermissioned_str)
      wrong_types_str = "SELECT * FROM groups WHERE id IN #{group_ids_str} AND table_name != '#{class_name.tableize}' AND (owner_id = #{@user_id} OR private = false)";
      Rails.logger.info("#{debug_prefix}: wrong_types_str: #{wrong_types_str}");
      wrong_types = Group.find_by_sql(wrong_types_str)
      permissioned_str = "SELECT * FROM groups WHERE id IN #{group_ids_str} AND table_name = '#{class_name.tableize}' AND (owner_id = #{@user_id} OR private = false)"
      Rails.logger.info("#{debug_prefix}: permissioned_str: #{permissioned_str}");
      permissioned = Group.find_by_sql(permissioned_str)
      if permissioned.length >0
        permission_id_str = "";
        permissioned.each do |permission_group|
          if(permission_id_str.length > 0)
            permission_id_str << ", "
          end
          permission_id_str << permission_group.id.to_s
        end
         permission_id_str = "(#{permission_id_str})"
         sql_str = "SELECT * FROM groups a0 WHERE a0.id IN #{permission_id_str} AND (SELECT COUNT(*) FROM group_#{class_name.tableize} WHERE group_id = a0.id AND #{class_name.underscore}_id = #{class_id})=0"
         unpresent = Group.find_by_sql(sql_str);
         present = Group.find_by_sql("SELECT * FROM group_#{class_name.tableize} WHERE group_id  IN #{permission_id_str} AND #{class_name.underscore}_id = #{class_id}");

         unpresent.each do |db_group|
          new_group_member_str = "Group#{class_name}.new"
          new_group_member = eval(new_group_member_str);
          new_group_member.group_id = db_group.id;
          new_group_member_id_str = "new_group_member.#{class_name.underscore}_id = #{class_id}"
          eval(new_group_member_id_str);
          new_group_member.save;
         end
      end
    end
    
    # ActionCable invalidation notification for add_to_groups
    if permissioned.length > 0 && unpresent.length > 0
      begin
        Rails.logger.info("#{debug_prefix}: RWV Broadcasting ActionCable invalidation notifications for add_to_groups operation")

        # Build affected relationships for adding to multiple groups
        affected_relationships = []
        
        # Group records updated (member count changed)
        group_ids_affected = unpresent.map(&:id)
        affected_relationships << {
          table: "Group",
          operation: "update",
          ids: group_ids_affected,
          reason: "group_membership_added",
          source_operation: "add_to_groups"
        }
        
        # New GroupMembership records created
        group_membership_table = "Group#{class_name}"
        affected_relationships << {
          table: group_membership_table,
          operation: "create",
          ids: [], # New records, so no specific IDs yet
          reason: "new_group_memberships",
          source_operation: "add_to_groups",
          related_group_ids: group_ids_affected,
          related_member_id: class_id
        }
        
        # Member record updated (shows new group memberships)
        affected_relationships << {
          table: class_name,
          operation: "update",
          ids: [class_id],
          reason: "group_membership_added",
          source_operation: "add_to_groups"
        }

        Rails.logger.info("#{debug_prefix}: RWV Identified #{affected_relationships.length} affected table relationships for add_to_groups")
        affected_relationships.each do |rel|
          Rails.logger.info("#{debug_prefix}: RWV  - #{rel[:table]} #{rel[:operation]} (#{rel[:ids]&.length || 0} records): #{rel[:reason]}")
        end
        
        # Broadcast the invalidation notification
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id],
            operation: "add_to_groups",
            group_ids: group_ids,
            class_id: class_id,
            class_name: class_name
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })

        Rails.logger.info("#{debug_prefix}: RWV Successfully broadcast invalidation notification for add_to_groups operation")

      rescue => e
        Rails.logger.error "#{debug_prefix}: RWV ActionCable broadcast failed in add_to_groups: #{e.message}"
        Rails.logger.error "#{debug_prefix}: RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
    else
      Rails.logger.info("#{debug_prefix}: RWV Skipping ActionCable invalidation broadcast for add_to_groups due to no valid operations");
    end
    
    @search_ctls = session[:search_ctls];
    table_name = class_name
    search_ctl = @search_ctls[table_name];
    search_ctl_group = @search_ctls["Group"];
    respond_to do |format|
      format.js { render "add_to_groups", :locals => { :group_ids => group_ids, :permissioned => permissioned, :unpresent => unpresent, :class_name => class_name, :present => present, :wrong_types => wrong_types, :class_id => class_id, :unpermissioned => unpermissioned, :search_ctl => search_ctl, :search_ctl_group => search_ctl_group } }

    end    
  end

  def remove_from_groups(group_ids, class_id, class_name)
      Rails.logger.info("remove_from_groups begin ");
    @user_id = session[:user_id];
    if group_ids.length >0
      group_ids_str = "";
      group_ids.each do |group_id|
        if(group_ids_str.length >0)
          group_ids_str << ", "
        end
        group_ids_str << group_id.to_s;
      end
      group_ids_str = "(#{group_ids_str})";
      unpermissioned = Group.find_by_sql("SELECT * FROM groups WHERE id IN #{group_ids_str} AND table_name = '#{class_name.tableize}' AND (owner_id != #{@user_id} AND private = true)")
      wrong_types = Group.find_by_sql("SELECT * FROM groups WHERE id IN #{group_ids_str} AND table_name != '#{class_name.tableize}' AND (owner_id = #{@user_id} OR private = false)")
      permissioned = Group.find_by_sql("SELECT * FROM groups WHERE id IN #{group_ids_str} AND table_name = '#{class_name.tableize}' AND (owner_id = #{@user_id} OR private = false)")
      if permissioned.length >0
        permission_id_str = "";
        permissioned.each do |permission_group|
          if(permission_id_str.length > 0)
            permission_id_str << ", "
          end
          permission_id_str << permission_group.id.to_s
        end
         permission_id_str = "(#{permission_id_str})"
         sql_str = "SELECT * FROM groups a0 WHERE a0.id IN #{permission_id_str} AND (SELECT COUNT(*) FROM group_#{class_name.tableize} WHERE group_id = a0.id AND #{class_name.underscore}_id = #{class_id})=0"
         unpresent = Group.find_by_sql(sql_str);
         present = Group.find_by_sql("SELECT * FROM group_#{class_name.tableize} WHERE group_id  IN #{permission_id_str} AND #{class_name.underscore}_id = #{class_id}");

         present.each do |group_member|
           destroy_str = "Group#{class_name}.destroy(#{group_member.id})"
           eval(destroy_str);

         end
      end
    end
    
    # ActionCable invalidation notification for remove_from_groups
    if permissioned.length > 0 && present.length > 0
      begin
        Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for remove_from_groups operation")
        
        # Build affected relationships for removing from multiple groups
        affected_relationships = []
        
        # Group records updated (member count changed)
        group_ids_affected = permissioned.map(&:id)
        affected_relationships << {
          table: "Group",
          operation: "update",
          ids: group_ids_affected,
          reason: "group_membership_removed",
          source_operation: "remove_from_groups"
        }
        
        # GroupMembership records deleted
        group_membership_table = "Group#{class_name}"
        affected_relationships << {
          table: group_membership_table,
          operation: "delete",
          ids: [], # Records were deleted, so no specific IDs
          reason: "group_memberships_deleted",
          source_operation: "remove_from_groups",
          related_group_ids: group_ids_affected,
          related_member_id: class_id
        }
        
        # Member record updated (group memberships removed)
        affected_relationships << {
          table: class_name,
          operation: "update",
          ids: [class_id],
          reason: "group_membership_removed",
          source_operation: "remove_from_groups"
        }
        
        Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships for remove_from_groups")
        affected_relationships.each do |rel|
          Rails.logger.info("RWV  - #{rel[:table]} #{rel[:operation]} (#{rel[:ids]&.length || 0} records): #{rel[:reason]}")
        end
        
        # Broadcast the invalidation notification
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id],
            operation: "remove_from_groups",
            group_ids: group_ids,
            class_id: class_id,
            class_name: class_name
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })
        
        Rails.logger.info("RWV Successfully broadcast invalidation notification for remove_from_groups operation")
        
      rescue => e
        Rails.logger.error "RWV ActionCable broadcast failed in remove_from_groups: #{e.message}"
        Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
    else
      Rails.logger.info("RWV Skipping ActionCable invalidation broadcast for remove_from_groups due to no valid operations");
    end
    
    @search_ctls = session[:search_ctls];
    table_name = class_name;
    search_ctl = @search_ctls[table_name];
    search_ctl_group = @search_ctls["Group"];
    Rails.logger.info("remove_from_groups 01 ");
    respond_to do |format|
      format.js  { render "remove_from_groups", :locals => {:group_ids => group_ids, :permissioned => permissioned, :present => present, :unpresent => unpresent, :wrong_types => wrong_types, :unpermissioned => unpermissioned, :search_ctl => search_ctl, :search_ctl_group => search_ctl_group, :class_name => class_name , :class_id => class_id } }
    end
  end


  def add_to_group(group_id, ids, class_name2)

  @user_id = session[:user_id];
  db_group = Group.find(group_id);
  permission = false
  class_ok= false
    if(db_group != nil)
      if db_group.private == false || db_group.owner_id = @user_id
        permission = true;
      end
    end

    if(permission)
      if(class_name2.tableize == db_group.table_name)
        class_ok= true;
        if (ids.length > 0)
        id_str = ""
        ids.each do |id|
          if id_str.length >0
            id_str << ", "
          end
          id_str << id.to_s;
        end
        already_existing_str = "SELECT * FROM group_#{class_name2.tableize} WHERE #{class_name2.underscore}_id IN (#{id_str}) AND group_id = #{group_id}";
        Rails.logger.info("RWV add_to_group, already_existing_str = #{already_existing_str}")
        already_existing = Group.find_by_sql(already_existing_str);
        new_members = Array.new(ids);
        Rails.logger.info("RWV ids = #{ids.inspect}");
        already_existing.each do |existing|
          existing_id_str = "existing.#{class_name2.underscore}_id";
          existing_id = eval(existing_id_str)
          Rails.logger.info("RWV existing_id_str = #{existing_id_str}, existing_id = #{existing_id}")
          new_members.delete(existing_id.to_s);
        end
        Rails.logger.info("RWV new_members = #{new_members.inspect}");
        new_members.each do |new_id|
          new_group_member_str = "Group#{class_name2}.new"
          new_group_member = eval(new_group_member_str);
          new_group_member.group_id = db_group.id;
          new_group_member_id_str = "new_group_member.#{class_name2.underscore}_id = #{new_id}"
          Rails.logger.info("RWV new_group_member_id_str = #{new_group_member_id_str}");
          
          eval(new_group_member_id_str);
          new_group_member.save;
        end
      end
    end
    end
    
    # ActionCable invalidation notification for add_to_group
    if permission && class_ok && new_members.length > 0
      begin
        Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for add_to_group operation")
        
        # Build affected relationships for group membership addition
        affected_relationships = []
        
        # Group record updated (member count changed)
        affected_relationships << {
          table: "Group",
          operation: "update",
          ids: [group_id],
          reason: "group_membership_added",
          source_operation: "add_to_group"
        }
        
        # New GroupMembership records created
        group_membership_table = "Group#{class_name2}"
        affected_relationships << {
          table: group_membership_table,
          operation: "create",
          ids: [], # New records, so no specific IDs yet
          reason: "new_group_memberships",
          source_operation: "add_to_group",
          related_group_id: group_id,
          related_member_ids: new_members.map(&:to_i)
        }
        
        # Member records updated (shows new group membership)
        affected_relationships << {
          table: class_name2,
          operation: "update",
          ids: new_members.map(&:to_i),
          reason: "group_membership_added",
          source_operation: "add_to_group"
        }
        
        Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships for add_to_group")
        affected_relationships.each do |rel|
          Rails.logger.info("RWV  - #{rel[:table]} #{rel[:operation]} (#{rel[:ids]&.length || 0} records): #{rel[:reason]}")
        end
        
        # Broadcast the invalidation notification
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id],
            operation: "add_to_group",
            group_id: group_id,
            class_name: class_name2,
            member_ids: ids || []
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })
        
        Rails.logger.info("RWV Successfully broadcast invalidation notification for add_to_group operation")
        
      rescue => e
        Rails.logger.error "RWV ActionCable broadcast failed in add_to_group: #{e.message}"
        Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
    else
      Rails.logger.info("RWV Skipping ActionCable invalidation broadcast for add_to_group due to permission/class/membership issues");
    end
    
   @search_ctls = session[:search_ctls];
   if class_ok
      table_name = class_name2;
      search_ctl = @search_ctls[table_name]; 
      search_ctl_group =  @search_ctls["Group"];
   else
       search_ctl = nil;
   end  
   respond_to do |format|
      format.js { render "add_to_group", :locals => { :db_group => db_group, :group_id => group_id, :permission => permission, :class_ok => class_ok, :class_name2 => class_name2, :table_name => table_name, :ids => ids, :already_existing => already_existing, :new_members => new_members, :search_ctl => search_ctl, :search_ctl_group => search_ctl_group  } }
=begin      
       do
        render :update do |page|
          if(db_group== nil)
          page << "alert('Add Selected Failed: Could not find group id #{group_id} in database')"
          elsif(!permission )
            page << "alert('Add Selected Failed: You do not have permission to edit group #{db_group.group_name}')"
          elsif(!class_ok)
            page << "alert('Add Selected Failed: The #{db_group.group_name} is for members of type #{db_group.table.classify} rather than type #{class_name2}')"
          elsif(ids.length == 0)
            page << "alert('Add Selected Failed: You have not selected any #{db_group.table_name}')"
          else
            success_str = ""
            if already_existing.length == 1
              success_str << "1 #{class_name2} was already in the group #{db_group.group_name}. "
            elsif already_existing.length >1
              success_str << "#{already_existing.length} #{class_name2.tableize} were already in the group #{db_group.group_name}. "
            end
            if new_members.length == 1
              success_str <<  "1 #{class_name2} was added to the group #{db_group.group_name}. "
            elsif new_members.length > 1
              success_str << "#{new_members.length} #{class_name2.tableize} were added to the group #{db_group.group_name}"
            end
            page << "alert('#{success_str}')"
          end
          page << "unwait();"
        end
      end
=end      
    end

  end

  def new_group(ids, class_name, group_name, group_privacy)
    Rails.logger.debug("WelcomeController:new_group: Params received for new_group: #{params.inspect}")
    group_name = group_name.gsub(/^\s+/,'').gsub(/\s+$/,'');
    if(group_name.length ==0)
      alert_str = "Group creation failed: the chosen group name #{group_name} can't be an empty string.";
      respond_to do |format|
        format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => 'error'} }

      end
      return;
    end

    table_name = class_name.tableize;
    Rails.logger.info("RWV Created new group I am here");
    existing_group = Group.where(:group_name => group_name, :table_name => table_name).first;
    new_group_id = nil
    
    # Check if a group with this name already exists for this table
    if existing_group
      alert_str = "Group creation failed: a #{class_name} group with name '#{group_name}' already exists.";
      respond_to do |format|
        format.js { render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => 'error'} }
      end
      return;
    end
    
    # Check if Group table search has been performed to determine display update strategy
    search_done = params[:search_done] == 'true'
    Rails.logger.debug("WelcomeController:new_group search_done: #{search_done}")
    
    # Create the new group
    Rails.logger.info("RWV Created new group");

      new_group = Group.new;
      new_group.group_name = group_name;
      new_group.table_name = table_name;
      new_group.owner_id= session[:user_id];
      new_group.readers_id = 1;
      new_group.writers_id = 1;
      new_group.private = group_privacy;
      new_group.save;
      new_group_id = new_group.id;
      if ids != nil
        for id in ids
          new_group_member_str = "Group#{class_name}.new"
          new_group_member =  eval(new_group_member_str);
          new_group_member.group_id = new_group.id
          new_group_member_member_str= "new_group_member.#{class_name.underscore}_id = #{id}"
          eval(new_group_member_member_str);
          new_group_member.save;
        end
      end
      
      # Prepare Group table row for display (similar to new method)
      search_ctls = session[:search_ctls]
      new_row = nil
      group_search_results = nil
      
      if search_ctls && search_ctls["Group"]
        search_ctl_group = search_ctls["Group"]
        begin
          eval("Group.set_controller(search_ctl_group)")
          
          # Create a simple object with the required attributes for the template
          new_row = OpenStruct.new(
            id: new_group.id,
            class_name: "Group",
            search_controller: search_ctl_group,
            Number_of_group_members_Group: ids.length
          )
          
          # Copy all the new_group attributes to new_row so filter.eval_str can access them
          new_group.attributes.each do |key, value|
            new_row.send("#{key}=", value) unless new_row.respond_to?(key)
          end
          
          Rails.logger.debug("DEBUG: Created Group row object for new Group with ID #{new_group.id}")
          
          # If no search has been performed on Group table, create a SearchResults with just the new row
          if !search_done
            group_search_results = SearchResults.new([new_row], :search_results, search_ctl_group)
          end
          
        rescue => e
          Rails.logger.error("ERROR creating Group row object: #{e.message}")
          new_row = nil
        end
      else
        Rails.logger.debug("DEBUG: No search controller found for Group")
      end

      # ActionCable invalidation notification for new_group
      begin
        Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for new_group operation")
        
        # Build affected relationships for group creation
        affected_relationships = []
        
        # New Group record created
        affected_relationships << {
          table: "Group",
          operation: "create",
          ids: [new_group_id],
          reason: "new_group_created",
          source_operation: "new_group"
        }
        
        # If members were added to the group
        if ids && ids.any?
          # New GroupMembership records created (e.g., GroupPerson, GroupCourse, etc.)
          group_membership_table = "Group#{class_name}"
          affected_relationships << {
            table: group_membership_table,
            operation: "create",
            ids: [], # New records, so no specific IDs yet
            reason: "new_group_memberships",
            source_operation: "new_group",
            related_group_id: new_group_id,
            related_member_ids: ids.map(&:to_i)
          }
          
          # Member records updated (shows new group membership)
          affected_relationships << {
            table: class_name,
            operation: "update", 
            ids: ids.map(&:to_i),
            reason: "group_membership_added",
            source_operation: "new_group"
          }
        end
        
        Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships for new_group")
        affected_relationships.each do |rel|
          Rails.logger.info("RWV  - #{rel[:table]} #{rel[:operation]} (#{rel[:ids]&.length || 0} records): #{rel[:reason]}")
        end
        
        # Broadcast the invalidation notification
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id],
            operation: "new_group",
            group_id: new_group_id,
            group_name: group_name,
            class_name: class_name,
            member_ids: ids || []
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })
        
        Rails.logger.info("RWV Successfully broadcast invalidation notification for new_group operation")
        
      rescue => e
        Rails.logger.error "RWV ActionCable broadcast failed in new_group: #{e.message}"
        Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
    
    @search_ctls = session[:search_ctls];
    table_name = class_name;
    search_ctl = @search_ctls[table_name];
    search_ctl_group = @search_ctls["Group"];

    respond_to do |format|   
      if search_done
        # If Group search was already performed, add to existing table
        format.js { 
          render "new_group", :locals => { 
            :existing_group => existing_group, 
            :class_name => class_name, 
            :table_name => table_name, 
            :group_name => group_name, 
            :new_group_id => new_group_id, 
            :ids => ids, 
            :search_ctl => search_ctl, 
            :search_ctl_group => search_ctl_group,
            :new_row => new_row,
            :search_done => search_done
          } 
        }
      else
        # If no Group search was performed, render a new Group table with just this entry
        format.js { 
          render "table_search", :locals => {:search_ctl => search_ctl_group, :params => params, :table_name => "Group", :search_results => group_search_results}
                 
        }
      end
    end      

  end
  def update_tutorial_number(ids, tutorial_number)
    tutorial_number = tutorial_number.to_i
    error_str ='';
    success_str = '';
    if(tutorial_number <0)
        alert_str = "Set Tutorial Number failed: the number of tutorial can't be negative."
        respond_to do |format|
            format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => 'error'} }
        end    

        return;
    end
    if ids.length == 0
        alert_str = "Set Tutorial Number failed: you didn't select any tutorial scedules to be updated."
        respond_to do |format|
            format.js {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => 'error'} }  
        end 
    
      return;
    end
    id_str = ""
    ids.each do |id|
        if id_str.length >0
            id_str << ", "
        end
        id_str << id.to_s;
    end
    tutorial_schedules = TutorialSchedule.find_by_sql("SELECT * FROM tutorial_schedules WHERE id IN (#{id_str})");

    tutorial_schedules.each do |tutorial_schedule|
      tutorial_schedule.number_of_tutorials = tutorial_number;
      tutorial_schedule.save;
    end

    # ActionCable invalidation notification for update_tutorial_number
    if tutorial_schedules.any?
      begin
        Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for update_tutorial_number operation")
        
        # Build affected relationships for tutorial number updates
        affected_relationships = []
        
        # TutorialSchedule records updated
        affected_relationships << {
          table: "TutorialSchedule",
          operation: "update",
          ids: ids.map(&:to_i),
          reason: "tutorial_number_updated",
          source_operation: "update_tutorial_number"
        }
        
        Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships for update_tutorial_number")
        affected_relationships.each do |rel|
          Rails.logger.info("RWV  - #{rel[:table]} #{rel[:operation]} (#{rel[:ids]&.length || 0} records): #{rel[:reason]}")
        end
        
        # Broadcast the invalidation notification
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id],
            operation: "update_tutorial_number",
            tutorial_schedule_ids: ids,
            tutorial_number: tutorial_number
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })
        
        Rails.logger.info("RWV Successfully broadcast invalidation notification for update_tutorial_number operation")
        
      rescue => e
        Rails.logger.error "RWV ActionCable broadcast failed in update_tutorial_number: #{e.message}"
        Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
    else
      Rails.logger.info("RWV Skipping ActionCable invalidation broadcast for update_tutorial_number due to no tutorial schedules")
    end

    @pluralize_num = ids.length;
    success_str = "#{@pluralize_num} "+ pl("tutorial schedule") +" updated to have "
    @pluralize_num = tutorial_number;
    success_str = success_str + "#{@pluralize_num} " + pl("tutorial");

    if error_str.length>0
      alert_str = error_str;
      alert_status = 'error';
    else
      alert_str = success_str;
      alert_status = 'success';
    end

    respond_to do |format|
      format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => alert_status } }
    end

  end
  
  def update_collection_status(ids, new_status)
    error_str = "";
    success_str = "";
    
    if (ids.length > 0)
      id_str = ""
      ids.each do |id|
        if id_str.length >0
          id_str << ", "
        end
        id_str << id.to_s;
      end
      tutorials = Tutorial.find_by_sql("SELECT * FROM tutorials WHERE id IN (#{id_str})");

     
      tutorials.each do |tutorial|
        tutorial.collection_status = new_status;
        tutorial.save;
      end

      case new_status
        when 2
          status_str = "COLLECTION HAS BEEN TAKEN"
        when 1
          status_str = "COLLECTION TO BE TAKEN"
      else
          status_str = "COLLECTION UNNECESSARY"
      end
      @pluralize_num = ids.length;
      success_str = "#{@pluralize_num} "+ pl("tutorial") +" updated with status #{status_str}";
    else
      success_str = "no tutorials were selected"
    end

    # ActionCable invalidation notification for update_collection_status
    if ids.length > 0
      begin
        Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for update_collection_status operation")
        
        # Build affected relationships for collection status updates
        affected_relationships = []
        
        # Tutorial records updated
        affected_relationships << {
          table: "Tutorial",
          operation: "update",
          ids: ids.map(&:to_i),
          reason: "collection_status_updated",
          source_operation: "update_collection_status"
        }
        
        Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships for update_collection_status")
        affected_relationships.each do |rel|
          Rails.logger.info("RWV  - #{rel[:table]} #{rel[:operation]} (#{rel[:ids]&.length || 0} records): #{rel[:reason]}")
        end
        
        # Broadcast the invalidation notification
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id],
            operation: "update_collection_status",
            tutorial_ids: ids,
            new_status: new_status
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })
        
        Rails.logger.info("RWV Successfully broadcast invalidation notification for update_collection_status operation")
        
      rescue => e
        Rails.logger.error "RWV ActionCable broadcast failed in update_collection_status: #{e.message}"
        Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
    else
      Rails.logger.info("RWV Skipping ActionCable invalidation broadcast for update_collection_status due to no tutorials selected")
    end

    if error_str.length>0
      alert_str = error_str;
      alert_status = 'error';
    else
      alert_str = success_str;
      alert_status = 'success';
    end

    respond_to do |format|
      format.js  {render :partial => "shared/alert", :locals => {:alert_str => alert_str, :status_flag => alert_status } }
    end
    end

  def check_dependencies(ids, table_name)
    dependencies_present = [];
    if(ids.length == 0)
      return dependencies_present 
    end
    has_many_str = table_name + ".reflect_on_all_associations(:has_many)";
    has_manys = eval(has_many_str);

    dependent_str ="";
    id_str = "";
    for id in ids
      if id_str.length>0
        id_str << ", "
      end
      id_str << id.to_s;
    end
    dependent_tables = {};
    for has_many in has_manys
      dependent_table_name = has_many.class_name;
      reflection_str = dependent_table_name + ".reflect_on_all_associations(:belongs_to)"
      reflections = eval(reflection_str);

      for reflection in reflections
        if reflection.class_name == table_name
          foreign_key =reflection.options[:foreign_key] ;
          if dependent_tables.has_key?(dependent_table_name)
            if dependent_tables[dependent_table_name].index(foreign_key) == nil
              dependent_tables[dependent_table_name] << foreign_key
            end
          else
            dependent_tables[dependent_table_name] = [];
            dependent_tables[dependent_table_name] << foreign_key;
          end
        end
      end
    end
    ids.each do |id|
      id_dependencies  = []; #ret value is a list of these Dependency objects
      dependent_hash = {}
      dependent_tables.each do |dependent_table_name, foreign_keys|
        dependent_ids = []; # this is the list in a Dependency object
        foreign_keys.each do |foreign_key|
          objects_str = "#{reflection.class_name}.find_by_sql(\"SELECT id, #{foreign_key} FROM #{ dependent_table_name.tableize} WHERE #{foreign_key} = #{id}\")"
          objects = eval(objects_str);
          if objects.length >0
            objects.each do |object|
              if dependent_ids.index(object.id) == nil
                dependent_ids <<  object.id;
              end
            end

          end

        end
        if dependent_ids.length >0
          dependent_hash[dependent_table_name] = dependent_ids
          #  id_dependencies << Dependency.new(, );
        end        
      end
      dependencies_present << dependent_hash;
    end
    return dependencies_present;
  end

  def delete_array(ids, table_name)
    dependencies_present = check_dependencies(ids, table_name)
    Rails.logger.info("RWV delete_array BEGIN");
    Rails.logger.info("RWV delete_array dependencies_present: #{dependencies_present.inspect}");

    delete_hash = {}
    delete_hash_str ={}
    error_str = ""
    success_str = "";
    deleted_ids = "";
    num_deletes = 0;
    num_ids = ids.length;
    ids_for_deletion = [];
    for id_count in (0..(num_ids -1))
      do_delete = true;
      
      current_dependencies = dependencies_present[id_count];
      Rails.logger.info("RWV delete_array current_dependencies: #{current_dependencies.inspect}");
      if table_name == "User" && ids[id_count] == session[:user_id]
        do_delete = false;
        error_str = "You cannot delete your user account whilst you are logged in. "
      elsif current_dependencies.length >0
        if  current_dependencies.has_key?("WillingTutor") || current_dependencies.has_key?("WillingLecturer") ||current_dependencies.has_key?("Group") || current_dependencies.has_key?("MaxTutorial") || current_dependencies.has_key?("User") || current_dependencies.has_key?("TutorialSchedule") || current_dependencies.has_key?("Lecture") ||  current_dependencies.has_key?("Term") ||current_dependencies.has_key?("Person")||current_dependencies.has_key?("AgathaEmail") ||current_dependencies.has_key?("AgathaFile")
          do_delete = false;
          Rails.logger.info("RWV delete_array do_delete = false for current_dependencies: #{current_dependencies.inspect}");
        elsif  table_name == "AgathaFile" && current_dependencies.has_key?("EmailAttachment")
          do_delete = false;
          Rails.logger.info("RWV delete_array do_delete = false for AgathaFile}");
        elsif table_name == "Lecture" && current_dependencies.has_key?("Attendee")
          do_delete = false;
          Rails.logger.info("RWV delete_array do_delete = false for Lecture");
        elsif table_name == "TutorialSchedule" && current_dependencies.has_key?("Tutorial") && current_dependencies["Tutorial"].length >1
          do_delete = false;
          Rails.logger.info("RWV delete_array do_delete = false for TutorialSchedule with multiple Tutorials");
        elsif table_name == "Person" && current_dependencies.has_key?("TutorialSchedule")
          do_delete = false;
          Rails.logger.info("RWV delete_array do_delete = false for Person with TutorialSchedule");
        else
          do_delete = true;
          Rails.logger.info("RWV delete_array do_delete = true for current_dependencies: #{current_dependencies.inspect}");
        end
      end
      if do_delete
        delete_tutorial_schedule = false;
        ids_for_deletion << ids[id_count];
        Rails.logger.info("RWV delete_array added #{ids[id_count]} to ids_for_deletion: #{ids_for_deletion.inspect}");
        num_deletes = num_deletes +1;
        if table_name == "Tutorial"
          tutorial = Tutorial.find(ids[id_count]);
          tutorial_schedule_ids = [tutorial.tutorial_schedule_id];
          tutorials = Tutorial.find_by_sql("SELECT COUNT(*) AS tutee_num FROM tutorials WHERE tutorial_schedule_id = #{tutorial.tutorial_schedule_id}");
          if(tutorials[0].tutee_num.to_i == 1)
            delete_tutorial_schedule = true;
          end

        elsif table_name == "Person"
          tutorials = Tutorial.find_by_sql("SELECT * FROM tutorials WHERE person_id IN (#{ids[id_count]})");
          tutorial_schedule_id_str = "";
          tutorials.each do |tutorial2|
            if tutorial_schedule_id_str.length >0
              tutorial_schedule_id_str << ", ";
            end
            tutorial_schedule_id_str << tutorial2.tutorial_schedule_id.to_s
          end
          tutorial_schedules = [];
          if tutorials.length >0
            tutorial_schedules = TutorialSchedule.find_by_sql("SELECT * FROM tutorial_schedules a1 WHERE id IN (#{tutorial_schedule_id_str}) AND (SELECT COUNT(*) FROM tutorials a2 WHERE a2.tutorial_schedule_id = a1.id)=1");
          end
          if tutorial_schedules.length >0
            delete_tutorial_schedule = true;
            tutorial_schedule_ids = [];
            tutorial_schedules.each do |tutorial_schedule|
              tutorial_schedule_ids << tutorial_schedule.id;
            end
          end          
        end        
        current_dependencies.each do |dependent_table, dependent_ids|
          if(delete_hash.has_key?(dependent_table) == false)          
            delete_hash[dependent_table] ={}
          end
          dependent_ids.each do |dependent_id|
            delete_hash[dependent_table][dependent_id]=true;
          end
        end
        
        if deleted_ids.length >0
          deleted_ids << ", ";
        end
        deleted_ids << ids[id_count].to_s;
        if delete_tutorial_schedule
          if(delete_hash.has_key?("TutorialSchedule") == false)
            delete_hash["TutorialSchedule"] ={}
          end
          tutorial_schedule_id_str = ""
          tutorial_schedule_ids.each do |tutorial_schedule_id|
           delete_hash["TutorialSchedule"][tutorial_schedule_id]=true;
           if tutorial_schedule_id_str.length >0
             tutorial_schedule_id_str << ", "
           end
           tutorial_schedule_id_str << tutorial_schedule_id.to_s
          end
          tutorial_dependencies = check_dependencies(tutorial_schedule_ids, "TutorialSchedule")[0];
          tutorial_dependencies.each do |dependent_table, dependent_ids|
            if(delete_hash.has_key?(dependent_table) == false)
              delete_hash[dependent_table] ={}
            end
            dependent_ids.each do |dependent_id|
              delete_hash[dependent_table][dependent_id]=true;
            end
            tutorial_schedules = TutorialSchedule.find_by_sql("SELECT * FROM tutorial_schedules WHERE id IN (#{tutorial_schedule_id_str})");

            tutorial_schedules.each do |tutorial_schedule|
              tutorial_schedule.destroy;
            end
          end
        end
      else
        current_dependencies.each do |dependent_table, dependent_ids|
          @pluralize_num = dependent_ids.length ;
          error_str << "#{table_name} id = #{ids[id_count]} depends on #{dependent_table} with " + pl("id") + " = "
          id_str = ""
          dependent_ids.each do |dependent_id|
            if id_str.length >0
              id_str << ", ";
            end
            id_str << dependent_id.to_s;
          end
          id_str << ". ";
          error_str << id_str ;
        end       
      end      
    end
    Rails.logger.info("RWV delete_array ids_for_deletion: #{ids_for_deletion.inspect}");
    if(table_name!='Group' && table_name!='WillingLecturer' && table_name!= 'WillingTutor')
    join_model_class = "Group#{table_name}".constantize
    group_ids = join_model_class
      .where("#{table_name.downcase}_id": ids_for_deletion)
      .distinct
      .pluck(:group_id)
    Rails.logger.info("RWV delete_array group_ids: #{group_ids.inspect}");

    affected_groups = Group.where(id: group_ids)
    else
      affected_groups = []
    end
    
    # Extract relationship data BEFORE destroying records
    deleted_attendees = nil
    lecture_ids_from_attendees = []
    person_ids_from_attendees = []
    
    if table_name == "Attendee"
      Rails.logger.info("RWV Processing Attendee deletions - extracting relationship data before deletion")
      deleted_attendees = Attendee.where(id: ids_for_deletion)
      Rails.logger.info("RWV Found #{deleted_attendees.count} attendees to delete")
      
      lecture_ids_from_attendees = deleted_attendees.distinct.pluck(:lecture_id)
      person_ids_from_attendees = deleted_attendees.distinct.pluck(:person_id)
      
      Rails.logger.info("RWV Extracted lecture_ids: #{lecture_ids_from_attendees.inspect}")
      Rails.logger.info("RWV Extracted person_ids: #{person_ids_from_attendees.inspect}")
    end
    
    # Now destroy the records
    model_class = table_name.constantize
    model_class.where(id: ids_for_deletion).destroy_all

    @pluralize_num =num_deletes  ;
    if num_deletes >0
      success_str << "#{table_name} with " + pl("id") + " = #{deleted_ids} " + pl("was")+" DELETED. "

      delete_hash.each do |delete_table, id_hash|
        delete_hash_str[delete_table] = "";
        id_hash.each do |id_key, true_value|
          if delete_hash_str[delete_table].length >0
            delete_hash_str[delete_table] << ", ";
          end
          delete_hash_str[delete_table] << id_key.to_s;

        end
      end     
    end
   Rails.logger.info("RWV deleted_ids = #{deleted_ids.inspect}");

    # Add ActionCable broadcasts for cross-tab data invalidation notifications
    # This new approach tells each client what data might have changed, then each client
    # refreshes their own data with their own filters and display preferences
    if num_deletes > 0
      begin
        Rails.logger.info("RWV Broadcasting ActionCable invalidation notifications for delete operation")
        
        # Build a comprehensive list of table relationships that might be affected
        affected_relationships = []
        
        # Direct deletions
        affected_relationships << {
          table: table_name,
          operation: "delete",
          ids: ids_for_deletion,
          reason: "direct_deletion"
        }
        
        # Group member count changes for groupable models
        groupable_models = %w[Person Lecture Course Attendee Tutorial TutorialSchedule Institution User Term Day Location WillingLecturer WillingTutor EmailTemplate AgathaEmail]
        if groupable_models.include?(table_name) && affected_groups.any?
          affected_relationships << {
            table: "Group",
            operation: "update",
            ids: affected_groups.pluck(:id),
            reason: "member_count_change",
            source_table: table_name,
            source_operation: "delete"
          }
        end
        
        # Dependent table deletions
        delete_hash_str.each do |dependent_table, dependent_ids_str|
          dependent_ids = dependent_ids_str.split(", ").map(&:to_i)
          affected_relationships << {
            table: dependent_table,
            operation: "delete",
            ids: dependent_ids,
            reason: "dependent_deletion",
            source_table: table_name
          }
        end
        
        # Lecture attendance count changes when Person is deleted
        if table_name == "Person"
          # Find lectures that had attendees from the deleted people
          lecture_ids = Attendee.where(person_id: ids_for_deletion).distinct.pluck(:lecture_id)
          if lecture_ids.any?
            affected_relationships << {
              table: "Lecture",
              operation: "update",
              ids: lecture_ids,
              reason: "attendance_count_change",
              source_table: table_name,
              source_operation: "delete"
            }
          end
        end
        
        # Tutorial enrollment count changes when Person is deleted
        if table_name == "Person"
          # Find tutorial schedules that had enrollments from the deleted people
          tutorial_schedule_ids = Tutorial.where(person_id: ids_for_deletion).distinct.pluck(:tutorial_schedule_id)
          if tutorial_schedule_ids.any?
            affected_relationships << {
              table: "TutorialSchedule", 
              operation: "update",
              ids: tutorial_schedule_ids,
              reason: "enrollment_count_change",
              source_table: table_name,
              source_operation: "delete"
            }
          end
        end
        
        # Lecture attendance and Person attendance changes when Attendee is deleted
        if table_name == "Attendee"
          Rails.logger.info("RWV Processing Attendee deletions - using extracted relationship data")
          
          if lecture_ids_from_attendees.any?
            affected_relationships << {
              table: "Lecture",
              operation: "update", 
              ids: lecture_ids_from_attendees,
              reason: "attendance_count_change",
              source_table: table_name,
              source_operation: "delete"
            }
            Rails.logger.info("RWV Added Lecture relationship to affected_relationships")
          else
            Rails.logger.info("RWV No lecture_ids found - skipping Lecture relationship")
          end
          
          if person_ids_from_attendees.any?
            affected_relationships << {
              table: "Person",
              operation: "update",
              ids: person_ids_from_attendees,
              reason: "attendance_removed",
              source_table: table_name,
              source_operation: "delete"
            }
            Rails.logger.info("RWV Added Person relationship to affected_relationships")
          else
            Rails.logger.info("RWV No person_ids found - skipping Person relationship")
          end
        else
          Rails.logger.info("RWV Not processing Attendee deletions - table_name is: #{table_name}")
        end
        
        Rails.logger.info("RWV Identified #{affected_relationships.length} affected table relationships")
        Rails.logger.info("RWV Complete affected_relationships array:")
        affected_relationships.each_with_index do |rel, index|
          Rails.logger.info("RWV  [#{index}] #{rel[:table]} #{rel[:operation]} (#{rel[:ids].length} records): #{rel[:reason]}")
          Rails.logger.info("RWV      IDs: #{rel[:ids].inspect}")
        end
        
        # Broadcast the invalidation notification
        # Each client will receive this and decide what to refresh based on their current view
        ActionCable.server.broadcast("search_table_updates", {
          action: "data_invalidation",
          triggered_by: {
            user_id: session[:user_id],
            table: table_name,
            operation: "delete",
            ids: ids_for_deletion
          },
          affected_relationships: affected_relationships,
          timestamp: Time.current.to_f
        })
        
        Rails.logger.info("RWV Successfully broadcast data invalidation notification")
        
      rescue => e
        Rails.logger.error "RWV ActionCable broadcast failed in delete_array: #{e.message}"
        Rails.logger.error "RWV #{e.backtrace.first(5).join("\n")}"
        # Continue without ActionCable if it fails
      end
    end


    respond_to do |format|
      format.js  { render "delete_array" , :locals => { :success_str => success_str, :error_str => error_str, :deleted_ids => deleted_ids, :table_name => table_name, :delete_hash_str => delete_hash_str } }

    end
    Rails.logger.info("RWV delete_array END");
    
  end

  def delete
    table_name = params[:table_name];
    id = params[:id];
    ids =[];
    ids << id.to_i;
    delete_array(ids, table_name);
  end

  def remove_dependencies(ids, table_name, dependent_table_name)
    reflection_str = dependent_table_name + ".reflect_on_all_associations(:belongs_to)"
    reflections = eval(reflection_str);
    @update_hash["#{dependent_table_name}"]={}
    for reflection in reflections
      if(reflection.class_name == table_name)
        foreign_key = reflection.options[:foreign_key];
        id_str = "";
        for id in ids
          if id_str.length>0
            id_str << ", "
          end
          id_str << id.to_s;
        end

        objects_str = "#{reflection.class_name}.find_by_sql(\"SELECT id, #{foreign_key} FROM #{ dependent_table_name.tableize} WHERE #{foreign_key} IN (#{id_str})\")"
        
        objects = eval(objects_str);
        object_update_str = "object.#{foreign_key} = 1"
        update_ids =[];
        for object in objects
          eval(object_update_str)
          object.save;
          update_ids << object.id;
        end
        @update_hash["#{dependent_table_name}][#{foreign_key}"] = update_ids;
      end
    end

  end


  def update_formats
    user_id = session[:user_id] || 0;
    @format_controller =  FormatController.new(user_id);
    for table_object in @format_controller.table_objects
      sql_str = "FormatElement.find_by_sql(\"SELECT id, field_name, insert_string, element_order, in_use FROM format_elements WHERE (user_id = " + user_id.to_s +  " AND table_name = '" + table_object.table + "') ORDER BY element_order asc\")"
 #     Rails.logger.error( "DEBUG: before eval(#{sql_str})" );
      old_fields = eval(sql_str);
      old_fields_count  = old_fields.length;
      new_fields_count = params["display_format_count_#{table_object.table}"].to_i;
      for i in (0..(new_fields_count-1))
        if i>=old_fields_count
          format_elt = FormatElement.new;
        else
          format_elt = old_fields[i];
        end
        format_elt.table_name = table_object.table;
        format_elt.user_id = user_id;
        format_elt.field_name = params["display_format_field_#{table_object.table}_#{i}"];
        format_elt.insert_string = params["display_format_string_#{table_object.table}_#{i}"];
        format_elt.element_order = i;
        format_elt.in_use = true;
        format_elt.save;


      end
      if old_fields_count > new_fields_count
        for i in (new_fields_count..(old_fields_count-1))
          old_fields[i].in_use =false;
          old_fields[i].save;
        end
      end
    end
    @format_controller.Update();

    respond_to do |format|
      format.js { render "update_formats", :locals => {:format_controller => @format_controller } }
=begin      
      do
        render :update do |page|
          page.replace_html("format_controller_div", :partial => "shared/format_controller", :object => @format_controller);
          page << "resizeFormat()";
          page << "unwait();"
        end
      end
=end      
    end
  end

  def edit
    table_name = params[:table_name];
    id = params[:id];
    object_str = "#{table_name}.find(id)";
    new_current_object  = eval(object_str );
    if new_current_object
      @current_object  = new_current_object
    end
    if new_current_object
      respond_to do |format|
        format.html {redirect_to person  }
      end
    else
      fail_str = "Failed  to find #{@table_str}  with id #{id}."
      flash[:notice] = fail_str;
      respond_to do |format|
        format.html   { redirect_to person }
      end
    end
    Rails.logger.debug("welcome/edit end")
  end

  def update_group_filters
 
    table_name = params[:group_filters_table_name]
    foreign_key = params[:group_filters_foreign_key];
    group_id = params[:group_id];
    @user_id = session[:user_id];
    sql_str = "GroupFilter.find_by_sql(\"SELECT id, table_name, group_id, foreign_key, user_id  FROM group_filters WHERE (user_id = " + @user_id.to_s +  " AND table_name = '" + table_name + "' AND foreign_key = '" +foreign_key + "') \")"
#    Rails.logger.error( "DEBUG: before eval(#{sql_str})" );
    group_filters = eval(sql_str);
    if group_filters.length == 0
      group_filter = GroupFilter.new;
      group_filter.table_name = table_name;
      group_filter.foreign_key= foreign_key;
      group_filter.user_id = @user_id;
    else
      group_filter = group_filters[0];

    end
    group_filter.group_id = group_id;
    group_filter.save;
    group_filters = FilterController.GetGroupFilters(table_name, @user_id)
    respond_to do |format|
      format.js {render "update_group_filters",  :locals => {:table_name =>table_name, :group_filters => group_filters } }
    end
  end


  def SetNotClass(class_name)
    @snc_level = @snc_level+1
    if @snc_level >10
      @snc_level = @snc_level-1;
      return;
    end

   
    find_first_str = "#{class_name}.first"
    first_obj = eval(find_first_str)
    if(first_obj == nil)
      new_str = class_name +".new"
      not_set_obj = eval(new_str)
      reflection_str = class_name + ".reflect_on_all_associations(:belongs_to)"
      reflections = eval(reflection_str)
      for reflection in reflections

        SetNotClass(reflection.class_name)
        field_name = reflection.options[:foreign_key]

        eval_str = "not_set_obj.#{field_name} = @not_set_value"
  #      Rails.logger.error( "DEBUG: before SetNotClass(#{class_name}) eval(#{eval_str})" );
        eval(eval_str);
      end
      not_set_obj.save;
    end
    @snc_level = @snc_level-1;
  end

  def div_test
    x = 1;
        term = Term.find(20);
    person = Person.find(32);
    course = Course.find(112);
   lecture_schedules = Lecture.find_by_sql("SELECT * FROM lectures WHERE course_id = #{course.id} AND term_id = #{term.id}");     if lecture_schedules.length >0 then       lecture_id = lecture_schedules[0].id;      exam_attendees = Attendee.find_by_sql("SELECT *, a1.first_name || ' ' || a1.second_name AS student_name FROM attendees a0 INNER JOIN people a1 ON a1.id=a0.person_id AND a0.lecture_id = #{lecture_id} AND a0.examined= true ORDER BY student_name");      non_exam_attendees =  Attendee.find_by_sql("SELECT *, a1.first_name || ' ' || a1.second_name AS student_name FROM attendees a0 INNER JOIN people a1 ON a1.id=a0.person_id AND a0.lecture_id = #{lecture_id} AND a0.examined= false ORDER BY student_name");    else      exam_attendees = [];      non_exam_attendees = [];    end;
    



        EmailTemplate.create(:template_name =>"Class list and reminder of exam arrangements",
      :from_email => "<%= me.email %>",
      :subject => "Class and exam list for the coming Term at Blackfriars",
      :ruby_header=> %q{<% lecture_schedules = Lecture.find_by_sql("SELECT * FROM lectures WHERE course_id = #{course.id} AND term_id = #{term.id}");     if lecture_schedules.length >0 then       lecture_id = lecture_schedules[0].id;      exam_attendees = Attendee.find_by_sql("SELECT *, a1.first_name || ' ' || a1.second_name AS student_name FROM attendees a0 INNER JOIN people a1 ON a1.id=a0.person_id AND a0.lecture_id = #{lecture_id} AND a0.examined= true ORDER BY student_name");      non_exam_attendees =  Attendee.find_by_sql("SELECT *, a1.first_name || ' ' || a1.second_name AS student_name FROM attendees a0 INNER JOIN people a1 ON a1.id=a0.person_id AND a0.lecture_id = #{lecture_id} AND a0.examined= false ORDER BY student_name");    else      exam_attendees = [];      non_exam_attendees = [];    end;%>},
      :body=> %q{Dear <%= person.salutation %>,<br><br>This email concerns the lecture course on <%=course.name%> for the current Term. <% if (exam_attendees.length + non_exam_attendees.length) >0 %> As I understand it, the following students are supposed to attend the lecture course – there may well be others in the class, for whom it is optional.<br><% if exam_attendees.length >0 %> <br><b>Students needing an end-of-term examination</b>:<br><br>These students need a grade for the course, but are not taking tutorials in the subject. The lecturer normally determines the exam format (often a short viva-voce exam) and scope, and explains this to the students. Exams are usually held on the Monday or Tuesday of 9th Week, at a time to suit the lecturer and the students involved.<br><br><% exam_attendees.each do |attendee|%> <%=attendee.student_name%><br><%end%><br><%end%><% if non_exam_attendees.length >0 %> <b>Students not needing an end-of-term examination</b>:<br><br><% non_exam_attendees.each do |attendee|%> <%=attendee.student_name%><br><%end%><br><%end%><% else%>No one needs to be examined in this course and no one is required to attend.<%end%>If anything seems odd, surprising, alarming, or even wrong with these arrangements, let me know.<br><br>With best wishes,<br><br>Richard.<br><br>(Richard Conrad, O.P., vice-regent)<br><br>},
      :term_dependency=>true,
      :course_dependency=>false,
      :global_warnings=>"",
      :personal_warnings=>"");

    respond_to do |format|
      format.js  { render "div_test" }
=begin      
      do
        render :update do |page|

          page << "alert('div_test!')"
        end
      end
=end      
    end
  end


  def import_csv
    Rails.logger.debug( "import_csv begin" );
    if session[:user_id]!=1

      return;
    end


    old_institution_ids = [];
    new_institution_ids = [];

    old_person_ids = [];
    new_person_ids = [];

    old_course_ids = [];
    new_course_ids = [];

    old_term_ids = [];
    new_term_ids = [];

    old_group_ids = [];
    new_group_ids = [];

    old_lecture_ids = [];
    new_lecture_ids = [];

    old_day_ids = [];
    new_day_ids = [];



    @not_set_value = SearchController::NOT_SET;
    @snc_level = 0;
    all_tables = ActiveRecord::Base.connection.tables;
    for t in all_tables
      if (t =~ /csvs$/ || t =~ /schema_migrations/ || t =~ /sessions/) == nil
        SetNotClass(t.classify)
      end
    end
    csv_terms = TermCsv.find(:all);
    for csv_term in csv_terms
      new_term = Term.new;
      new_term.term_name_id = csv_term.name ;
      new_term.term_name_id = new_term.term_name_id+1;
      new_term.year = csv_term.year;
      if new_term.term_name_id>=1 && new_term.term_name_id<=4
        new_term.save;
        old_term_ids << csv_term.id;
        new_term_ids << new_term.id;
      end
    end
    Rails.logger.debug( "import_csv done terms" );
    Rails.logger.flush
    status_csvs = StatusCsv.find(:all);


    for csv_status in status_csvs
      group = Group.new;
      group.table_name = "people"
      group.group_name = csv_status.status;
      group.owner_id = 1;
      group.readers_id = 0;
      group.writers_id = 1;
      group.private = false;

      group.save;
      old_group_ids << csv_status.id;
      new_group_ids << group.id;
    end
        Rails.logger.debug( "import_csv done groups" );
    Rails.logger.flush

    people_csvs = PersonCsv.find(:all);

    institutuion_group = Group.new;
    institutuion_group.table_name = "institutions"
    institutuion_group.group_name = "Institutions"
    institutuion_group.owner_id = 1;
    institutuion_group.readers_id = 0;
    institutuion_group.writers_id = 1;
    institutuion_group.private = false;
    institutuion_group.save;

    religious_group = Group.new;
    religious_group.table_name = "institutions"
    religious_group.group_name = "Religious Houses"
    religious_group.owner_id = 1;
    religious_group.readers_id = 0;
    religious_group.writers_id = 1;
    religious_group.private = false;
    religious_group.save



    
    for people_csv in people_csvs

      person = Person.new;
      person.title = people_csv.title;
      person.first_name = people_csv.first_name;
      person.second_name = people_csv.second_name;
      person.postnomials = people_csv.postnominals;
      person.salutation = people_csv.salutation;
      person.term_address = people_csv.term_address;
      person.term_city = people_csv.term_city;
      person.term_postcode = people_csv.term_postcode;
      person.term_home_phone = people_csv.term_home_phone;
      person.term_work_phone = people_csv.term_work_phone;
      person.mobile = people_csv.mobile;
      person.email = people_csv.email;
      person.other_address = people_csv.other_address;
      person.other_city = people_csv.other_city;
      person.other_postcode = people_csv.other_postcode;
      person.other_home_phone = people_csv.other_home_phone;
      person.fax = people_csv.Fax;
      person.notes = people_csv.Notes;
      entry_year = people_csv.entry_year
      if entry_year == nil
        person.entry_term_id = SearchController::NOT_SET;
      else
      entry_terms = Term.find_by_sql("SELECT * FROM terms WHERE year = #{entry_year} LIMIT 1")

      if( entry_terms.length >0 )
        person.entry_term_id = entry_terms[0].id;
      else
        person.entry_term_id = SearchController::NOT_SET;
      end
      end
      person.next_of_kin = people_csv.next_of_kin;
      person.conventual_name = people_csv.conventual_name;

      status_ids = PersonstatusCsv.find(:all,:conditions => ["person_id = ?", people_csv.id]);
      status_id_array = [];
      for status_obj_id in status_ids
        status_id_array << status_obj_id.status_id
      end

      inst_id = people_csv.home_institution;
      relig_id = people_csv.religious_house;



      inst_ids = [inst_id, relig_id];
      new_ids = [];


      for i in (0..1)
        id = inst_ids[i];
        if id !=0 && id !=nil
          processed_id =  old_institution_ids.index(id);
          if processed_id != nil
            new_ids <<  new_institution_ids[processed_id];
          else
            if institution = PersonCsv.find(id)
              new_institution = Institution.new;
              new_institution.old_name = institution.old_name;
              new_institution.title = institution.title;
              new_institution.first_name = institution.first_name;
              new_institution.second_name = institution.second_name;
              new_institution.salutation = institution.salutation;
              new_institution.term_address = institution.term_address;
              new_institution.term_city = institution.term_city;
              new_institution.term_postcode = institution.term_postcode;
              new_institution.conventual_name = institution.conventual_name;

              # new_institution.institution_type = i;
              new_institution.save;
              if i == 0
                institutuion_group_member = GroupInstitution.new;
                institutuion_group_member.group_id = institutuion_group.id;
                institutuion_group_member.institution_id = new_institution.id
                institutuion_group_member.save;
              else
                institutuion_group_member = GroupInstitution.new;
                institutuion_group_member.group_id = religious_group.id;
                institutuion_group_member.institution_id = new_institution.id
                institutuion_group_member.save;
              end
              old_institution_ids << id;
              new_institution_ids << new_institution.id;
              new_ids << new_institution.id;
            else
              new_ids << 0;
            end
          end
        else
          new_ids << 0;
        end
        if new_ids[0]!=0
          person.institution_id = new_ids[0];
        else
          person.institution_id = @not_set_value;
        end
        if new_ids[1]!=0
          person.religious_house_id = new_ids[1];
        else
          person.religious_house_id = @not_set_value;
        end
      end

      if status_id_array.index(19)||status_id_array.index(20)
        if old_institution_ids.index(people_csv.id) == nil
          new_institution = Institution.new;
          new_institution.old_name = people_csv.old_name;
          new_institution.title = people_csv.title;
          new_institution.first_name = people_csv.first_name;
          new_institution.second_name = people_csv.second_name;
          new_institution.salutation = people_csv.salutation;
          new_institution.term_address = people_csv.term_address;
          new_institution.term_city = people_csv.term_city;
          new_institution.term_postcode = people_csv.term_postcode;
          new_institution.conventual_name = people_csv.conventual_name;

          new_institution.save;
          if status_id_array.index(20)
            institutuion_group_member = GroupInstitution.new;
            institutuion_group_member.group_id = institutuion_group.id;
            institutuion_group_member.institution_id = new_institution.id
            institutuion_group_member.save;
          else
            institutuion_group_member = GroupInstitution.new;
            institutuion_group_member.group_id = religious_group.id;
            institutuion_group_member.institution_id = new_institution.id
            institutuion_group_member.save;
          end

          old_institution_ids << people_csv.id;
          new_institution_ids << new_institution.id;
        end
      else
        person.save;
        old_person_ids << people_csv.id;
        new_person_ids << person.id;
        for status_val in status_id_array

          status_index = old_group_ids.index(status_val);
          if status_index != nil
            begin
              group_person = GroupPerson.new;
              group_person.group_id = new_group_ids[status_index];
              group_person.person_id = person.id;
              group_person.save;
            rescue Exception =>exc
              Rails.logger.debug( "DEBUG: an exception has occurred (person)" );
            end
          end
        end
      end
    end
        Rails.logger.debug( "import_csv done people" );
    Rails.logger.flush

    csv_courses = CourseCsv.find(:all);
    for csv_course in csv_courses
      new_course = Course.new;
      new_course.name =  csv_course.course_name;
      new_course.save;
      old_course_ids << csv_course.id;
      new_course_ids << new_course.id;
    end

        Rails.logger.debug( "import_csv done courses" );
    Rails.logger.flush





    csv_days = DayCsv.find(:all);


    for csv_day in csv_days
      day = Day.new;
      day.long_name = csv_day.long_name;
      day.short_name = csv_day.short_name;
      if csv_day.long_name =~ /Sunday/
        day.sunday = true;
      else
        day.sunday = false;
      end
      if csv_day.long_name =~ /Monday/
        day.monday = true;
      else
        day.monday = false;
      end
      if csv_day.long_name =~ /Tuesday/
        day.tuesday = true;
      else
        day.tuesday = false;
      end
      if csv_day.long_name =~ /Wednesday/
        day.wednesday = true;
      else
        day.wednesday = false;
      end
      if csv_day.long_name =~ /Thursday/
        day.thursday = true;
      else
        day.thursday = false;
      end
      if csv_day.long_name =~ /Friday/
        day.friday = true;
      else
        day.friday = false;
      end
      if csv_day.long_name =~ /Saturday/
        day.saturday = true;
      else
        day.saturday = false;
      end

      day.save;

      old_day_ids << csv_day.id;
      new_day_ids << day.id;
    end

    Rails.logger.debug( "import_csv done days" );
    Rails.logger.flush


    csv_lectures = LectureCsv.find(:all);
    for csv_lecture in csv_lectures
      course_index = old_course_ids.index(csv_lecture.course);
      term_index = old_term_ids.index(csv_lecture.term);
      tutor_index = old_person_ids.index(csv_lecture.tutor);
      day_index = old_day_ids.index(csv_lecture.day);
      if( course_index != nil && term_index != nil && tutor_index != nil && day_index !=nil)
        new_lecture = Lecture.new;
        new_lecture.term_id = new_term_ids[term_index];
        new_lecture.course_id = new_course_ids[course_index];
        new_lecture.person_id = new_person_ids[tutor_index];
        new_lecture.exam = csv_lecture.examination;
        new_lecture.day_id = new_day_ids[day_index];
        new_lecture.location_id = @not_set_value;;
        if csv_lecture.lecture_time =~/12:13/
          x = 1;
        else
          new_lecture.lecture_time = csv_lecture.lecture_time;
        end
        new_lecture.lecture_time = csv_lecture.lecture_time;
        new_lecture.number_of_classes = csv_lecture.number_of_classes;
        new_lecture.number_of_lectures = csv_lecture.number_of_lectures;
        new_lecture.hours = csv_lecture.hours;
        new_lecture.notes = csv_lecture.notes;
        new_lecture.save;
        old_lecture_ids << csv_lecture.id;
        new_lecture_ids << new_lecture.id;
      end
    end
    Rails.logger.debug( "import_csv done lectures" );
    Rails.logger.flush

    csv_attendees = AttendeeCsv.find(:all);
    for csv_attendee in csv_attendees
      lecture_index = old_lecture_ids.index(csv_attendee.lectures_course);
      person_index = old_person_ids.index(csv_attendee.student);
      if(lecture_index != nil && person_index != nil)
        begin
          new_attendee = Attendee.new;
          new_attendee.lecture_id = new_lecture_ids[lecture_index];
          new_attendee.person_id = new_person_ids[person_index];
          new_attendee.compulsory = csv_attendee.compulsory;
          new_attendee.comment = csv_attendee.mark;
          new_attendee.examined = csv_attendee.examined;
          new_attendee.save;
        rescue Exception => exc
          Rails.logger.debug( "DEBUG: an exception has occurred (new_attendee)" );
        end
      end
    end
        Rails.logger.debug( "import_csv done attendees" );
    Rails.logger.flush


    csv_willing_teachers = WillingTeacherCsv.find(:all);
    for csv_willing_teacher in csv_willing_teachers
      person_index = old_person_ids.index(csv_willing_teacher.tutor);
      course_index = old_course_ids.index(csv_willing_teacher.course);
      if(person_index !=nil && course_index !=nil)
        willing_teacher = WillingTeacher.new;
        willing_teacher.person_id = new_person_ids[person_index];
        willing_teacher.course_id = new_course_ids[course_index];
        willing_teacher.can_lecture = true;
        willing_teacher.can_tutor = true;
        willing_teacher.notes = csv_willing_teacher.notes;
        willing_teacher.save;
      end
    end

        Rails.logger.debug( "import_csv done willing teachers" );
    Rails.logger.flush


    csv_tutorials = TutorialCsv.find(:all);
    for csv_tutorial in csv_tutorials
      student_index = old_person_ids.index(csv_tutorial.student);
      course_index = old_course_ids.index(csv_tutorial.course);
      term_index = old_term_ids.index(csv_tutorial.term);
      tutor_index = old_person_ids.index(csv_tutorial.tutor);
      if(student_index !=nil && course_index != nil && term_index != nil && tutor_index !=nil)
        tutorial = Tutorial.new;
        tutorial_schedule = TutorialSchedule.find(:first, :conditions => ["person_id = ? AND course_id = ? AND term_id = ?",
            new_person_ids[tutor_index], new_course_ids[course_index], new_term_ids[term_index]]);
        if(tutorial_schedule == nil)
          tutorial_schedule = TutorialSchedule.new;
          tutorial_schedule.person_id = new_person_ids[tutor_index];
          tutorial_schedule.course_id =  new_course_ids[course_index];
          tutorial_schedule.term_id = new_term_ids[term_index];
          tutorial_schedule.number_of_tutorials = 0;
          tutorial_schedule.save;
        end
        tutorial.person_id = new_person_ids[student_index];
        tutorial.tutorial_schedule_id = tutorial_schedule.id;
        tutorial_hours = csv_tutorial.hours;
        if tutorial_hours !=nil && tutorial_hours != 0
          tutorial_schedule.number_of_tutorial_hours  = tutorial_hours;
        else
          tutorial_schedule.number_of_tutorial_hours = 0
        end
        tutorial.notes = csv_tutorial.notes
        tutorial.comment = csv_tutorial.mark;
        tutorial_schedule.number_of_tutorials =  csv_tutorial.number;
        tutorial_schedule.save;
        begin
          tutorial.save;
        rescue Exception => exc
          Rails.logger.debug( "DEBUG: an exception has occurred (tutorial_schedule)" );
        end
      end
    end

    courses = Course.find(:all);
    courses.each do |course|
      if course.id != SearchController::NOT_SET
      tutors = TutorialSchedule.find_by_sql("SELECT person_id, max(term_id) AS term_id FROM tutorial_schedules WHERE course_id = #{course.id} GROUP BY person_id ORDER BY term_id DESC")
      preference = 1
      tutors.each do |tutor|
        willing_tutor = WillingTutor.new;
        willing_tutor.person_id = tutor.person_id;
        willing_tutor.course_id = course.id;
        willing_tutor.order_of_preference = preference;
        preference = preference +1;
        willing_tutor.save;
      end

      lecturers = Lecture.find_by_sql("SELECT person_id, max(term_id) AS term_id FROM lectures WHERE course_id = #{course.id} GROUP BY person_id ORDER BY term_id DESC");
      preference = 1;
      lecturers.each do |lecturer|

        willing_lecturer = WillingLecturer.new;
        willing_lecturer.person_id = lecturer.person_id;
        willing_lecturer.course_id = course.id;
        willing_lecturer.order_of_preference = preference;
        preference = preference + 1;
        willing_lecturer.save;
      end
      end

    end

    Rails.logger.debug( "import_csv done tutorials" );
    Rails.logger.flush

    term_name1 = TermName.new;
    term_name1.name = "Hilary"
    term_name1.save;
    term_name2 = TermName.new;
    term_name2.name = "Trinity"
    term_name2.save;
    term_name3 = TermName.new;
    term_name3.name = "Michaelmas"
    term_name3.save;

    FormatElement.create(:user_id => 0, :table_name => 'people', :field_name => 'second_name', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'people', :field_name => 'first_name', :insert_string => '', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'courses', :field_name => 'name', :insert_string => ' ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'institutions', :field_name => 'conventual_name', :insert_string => ' ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'groups', :field_name => 'group_name', :insert_string => '', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'lectures', :field_name => 'course_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'lectures', :field_name => 'term_id', :insert_string => ' ', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'term_names', :field_name => 'name', :insert_string => ' ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'terms', :field_name => 'term_name_id', :insert_string => ' ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'terms', :field_name => 'year', :insert_string => ' ', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'days', :field_name => 'short_name', :insert_string => ' ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'locations', :field_name => 'name', :insert_string => ' ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'attendees', :field_name => 'lecture_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'attendees', :field_name => 'person_id', :insert_string => '', :element_order => 2, :in_use => true)


    FormatElement.create(:user_id => 0, :table_name => 'tutorials', :field_name => 'tutorial_schedule_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'tutorials', :field_name => 'person_id', :insert_string => '', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'tutorial_schedules', :field_name => 'course_id', :insert_string => '', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'email_templates', :field_name => 'template_name', :insert_string => '', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'agatha_emails', :field_name => 'term_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'agatha_emails', :field_name => 'person_id', :insert_string => ', ', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'agatha_emails', :field_name => 'subject', :insert_string => '', :element_order => 3, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'agatha_files', :field_name => 'agatha_data_file_name', :insert_string => '', :element_order => 1, :in_use => true)


    FormatElement.create(:user_id => 0, :table_name => 'willing_lecturers', :field_name => 'course_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'willing_lecturers', :field_name => 'person_id', :insert_string => '', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'willing_tutors', :field_name => 'course_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'willing_tutors', :field_name => 'person_id', :insert_string => '', :element_order => 2, :in_use => true)


    FormatElement.create(:user_id => 0, :table_name => 'group_agatha_emails', :field_name => 'group_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_agatha_emails', :field_name => 'agatha_email_id', :insert_string => ', ', :element_order => 2, :in_use => true)

    FormatElement.create(:user_id => 0, :table_name => 'group_people', :field_name => 'group_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_people', :field_name => 'person_id', :insert_string => '', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_institutions', :field_name => 'group_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_institutions', :field_name => 'institution_id', :insert_string => '', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_courses', :field_name => 'group_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_courses', :field_name => 'course_id', :insert_string => '', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_lectures', :field_name => 'group_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_lectures', :field_name => 'lecture_id', :insert_string => '', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_attendees', :field_name => 'group_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_attendees', :field_name => 'attendee_id', :insert_string => '', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_tutorial_schedules', :field_name => 'group_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_tutorial_schedules', :field_name => 'tutorial_schedule_id', :insert_string => '', :element_order => 2, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_tutorials', :field_name => 'group_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_tutorials', :field_name => 'tutorial_id', :insert_string => '', :element_order => 2, :in_use => true)


    FormatElement.create(:user_id => 0, :table_name => 'group_users', :field_name => 'group_id', :insert_string => ', ', :element_order => 1, :in_use => true)
    FormatElement.create(:user_id => 0, :table_name => 'group_users', :field_name => 'user_id', :insert_string => '', :element_order => 2, :in_use => true)

     FormatElement.create(:user_id => 0, :table_name => 'users', :field_name => 'name', :insert_string => '', :element_order => 1, :in_use => true);

        Rails.logger.debug( "import_csv done format elements" );
    Rails.logger.flush

    DisplayFilter.create(:user_id => 0, :table_name => 'people', :filter_index => 0, :element_order => 0, :in_use => true);
    DisplayFilter.create(:user_id => 0, :table_name => 'people', :filter_index => 1, :element_order => 1, :in_use => true);
    DisplayFilter.create(:user_id => 0, :table_name => 'people', :filter_index => 2, :element_order => 2, :in_use => true);
    DisplayFilter.create(:user_id => 0, :table_name => 'people', :filter_index => 3, :element_order => 3, :in_use => true);
    DisplayFilter.create(:user_id => 0, :table_name => 'people', :filter_index => 4, :element_order => 4, :in_use => true);
    DisplayFilter.create(:user_id => 0, :table_name => 'people', :filter_index => 12, :element_order => 4, :in_use => true);
    DisplayFilter.create(:user_id => 0, :table_name => 'attendees', :filter_index => 0, :element_order => 0, :in_use => true);
    DisplayFilter.create(:user_id => 0, :table_name => 'attendees', :filter_index => 1, :element_order => 1, :in_use => true);
    DisplayFilter.create(:user_id => 0, :table_name => 'attendees', :filter_index => 2, :element_order => 2, :in_use => true);
    DisplayFilter.create(:user_id => 0, :table_name => 'attendees', :filter_index => 3, :element_order => 3, :in_use => true);
    DisplayFilter.create(:user_id => 0, :table_name => 'attendees', :filter_index => 6, :element_order => 4, :in_use => true);

    DisplayFilter.create(:user_id => 0, :table_name => 'courses', :filter_index => 0, :element_order => 0, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'courses', :filter_index => 1, :element_order => 1, :in_use => true)

    DisplayFilter.create(:user_id => 0, :table_name => 'terms', :filter_index => 0, :element_order => 0, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'terms', :filter_index => 1, :element_order => 1, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'terms', :filter_index => 2, :element_order => 2, :in_use => true)

    DisplayFilter.create(:user_id => 0, :table_name => 'days', :filter_index => 0, :element_order => 0, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'days', :filter_index => 1, :element_order => 1, :in_use => true)

    DisplayFilter.create(:user_id => 0, :table_name => 'groups', :filter_index => 0, :element_order => 0, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'groups', :filter_index => 1, :element_order => 1, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'groups', :filter_index => 4, :element_order => 2, :in_use => true)

    DisplayFilter.create(:user_id => 0, :table_name => 'group_people', :filter_index => 0, :element_order => 0, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'group_people', :filter_index => 1, :element_order => 1, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'group_people', :filter_index => 2, :element_order => 2, :in_use => true)

    DisplayFilter.create(:user_id => 0, :table_name => 'users', :filter_index => 0, :element_order => 0, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'users', :filter_index => 1, :element_order => 1, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'users', :filter_index => 6, :element_order => 2, :in_use => true)

    DisplayFilter.create(:user_id => 0, :table_name => 'willing_tutors', :filter_index => 0, :element_order => 0, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'willing_tutors', :filter_index => 1, :element_order => 1, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'willing_tutors', :filter_index => 2, :element_order => 2, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'willing_tutors', :filter_index => 3, :element_order => 3, :in_use => true)

    DisplayFilter.create(:user_id => 0, :table_name => 'willing_lecturers', :filter_index => 0, :element_order => 0, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'willing_lecturers', :filter_index => 1, :element_order => 1, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'willing_lecturers', :filter_index => 2, :element_order => 2, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'willing_lecturers', :filter_index => 3, :element_order => 3, :in_use => true)

    DisplayFilter.create(:user_id => 0, :table_name => 'maximum_tutorials', :filter_index => 0, :element_order => 0, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'maximum_tutorials', :filter_index => 1, :element_order => 1, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'maximum_tutorials', :filter_index => 2, :element_order => 2, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'maximum_tutorials', :filter_index => 3, :element_order => 3, :in_use => true)

    DisplayFilter.create(:user_id => 0, :table_name => 'email_templates', :filter_index => 0, :element_order => 0, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'email_templates', :filter_index => 1, :element_order => 1, :in_use => true)  
    DisplayFilter.create(:user_id => 0, :table_name => 'email_templates', :filter_index => 3, :element_order => 2, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'email_templates', :filter_index => 5, :element_order => 3, :in_use => true)

    DisplayFilter.create(:user_id => 0, :table_name => 'agatha_emails', :filter_index => 0, :element_order => 0, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'agatha_emails', :filter_index => 8, :element_order => 1, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'agatha_emails', :filter_index => 2, :element_order => 2, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'agatha_emails', :filter_index => 3, :element_order => 3, :in_use => true)
    DisplayFilter.create(:user_id => 0, :table_name => 'agatha_emails', :filter_index => 4, :element_order => 4, :in_use => true)

    
    Group.create(:group_name => 'BA', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => '2nd BA', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'MSt', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'MPhil', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'visiting student (UG - OSP)', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'visiting student (UG - not OSP)', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => "visiting student (UG - St. Clare's)", :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'visiting student (Post-Gr)', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'PGCE', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'Certificate in Theology', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'BTh', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'other', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'Philosophy Year', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'STB', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'Lectorate', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'Sapientia', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'Lampeter Certificate in Theology', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'Lampeter Diploma in Theology', :table_name => 'people', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'Language Classes', :table_name => 'courses', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'Lecturer Confirmed', :table_name => 'lectures', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
Group.create(:group_name => 'Tutor Confirmed', :table_name => 'tutorial_schedules', :owner_id => User.where(:name => "agathaapp").first.id, :private => false, :readers_id => 2, :writers_id => 2)
language_groups = Group.find_by_sql("SELECT * FROM groups WHERE table_name = 'courses' AND group_name='Language Classes'");
confirmed_lecturer_groups = Group.find_by_sql("SELECT * FROM groups WHERE table_name = 'lectures' AND group_name='Lecturer Confirmed'");
confirmed_tutor_groups =Group.find_by_sql("SELECT * FROM groups WHERE table_name = 'tutorial_schedules' AND group_name='Tutor Confirmed'");

if confirmed_lecturer_groups.length >0 then confirmed_lecturer_id = confirmed_lecturer_groups[0].id else  confirmed_lecturer_id  = 0 end;
if confirmed_tutor_groups.length >0 then confirmed_tutor_id = confirmed_tutor_groups[0].id else confirmed_tutor_id = 0 end;
if language_groups.length >0 then language_group_id = language_groups[0].id else language_group_id = 0 end;
languages = [41,42,143,184,191,39,40,147,157,37,38,175,192];
languages.each do |language_id|
  GroupCourse.create(:group_id=>language_group_id, :course_id => language_id);
end
lectures = Lecture.find(:all);
lectures.each do |lecture|
  GroupLecture.create(:group_id=>confirmed_lecturer_id,:lecture_id =>lecture.id)
end
tutorial_schedules = TutorialSchedule.find(:all);
tutorial_schedules.each do |tutorial_schedule1|
  GroupTutorialSchedule.create(:group_id=>confirmed_tutor_id, :tutorial_schedule_id=>tutorial_schedule1.id)
end



    EmailTemplate.create(:template_name => "Enquiry re availability",
      :from_email => "<%= me.email %>",
      :subject => "Availability for teaching for Blackfriars next year?",
      :ruby_header=> %q{<% first_term = term;   second_term_id = term.id + 1 ;  second_term = Term.find(second_term_id); third_term_id = term.id + 2;  third_term = Term.find(third_term_id); first_term_name = TermName.find(first_term.term_name_id).name; first_term_year = first_term.year; second_term_name = TermName.find(second_term.term_name_id).name; second_term_year = second_term.year; third_term_name = TermName.find(third_term.term_name_id).name; third_term_year = third_term.year; confirmed_groups = Group.find_by_sql("SELECT * FROM groups WHERE table_name = 'lectures' AND group_name='Lecturer Confirmed'"); if confirmed_groups.length >0 then confirmed_id = confirmed_groups[0].id else confirmed_id = 0 end; first_term_lectures = Lecture.find_by_sql("SELECT * FROM lectures a0 WHERE a0.term_id = #{term.id} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)=0"); second_term_lectures =  Lecture.find_by_sql("SELECT * FROM lectures a0 WHERE a0.term_id = #{term.id+1} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)=0"); third_term_lectures =  Lecture.find_by_sql("SELECT * FROM lectures a0 WHERE a0.term_id = #{term.id+2} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)=0"); if first_term_lectures.length>0 || second_term_lectures.length>0 || third_term_lectures.length>0 then make_lecture_request = true;  else make_lecture_request = false; end; num_terms = 0; if first_term_lectures.length >0 then num_terms = num_terms+1 end; if second_term_lectures.length  >0 then num_terms = num_terms+1 end; if third_term_lectures.length  >0 then num_terms = num_terms+1 end; terms_str = "(#{term.id},#{second_term_id },#{third_term_id})"; courses = Course.find_by_sql("SELECT * FROM courses a0 WHERE (SELECT COUNT(*) FROM lectures a1 WHERE a1.course_id = a0.id AND a1.person_id = #{person.id} AND a1.term_id IN #{terms_str} AND (SELECT COUNT(*) FROM group_lectures a2 WHERE a2.group_id=#{confirmed_id} AND a2.lecture_id = a1.id)=0)>0"); num_topics = courses.length; num_lectures = first_term_lectures.length + second_term_lectures.length + third_term_lectures.length; %>},
      :body=> %q{Dear <%= person.salutation %>,<br><br>I hope you are well and the academic year has gone smoothly.<br><br>Thank you for your teaching done for Blackfriars this year soon to end.<br><br>I am soon going to have to sort out who teaches what to whom, and when, in the coming academic year. It will assist that process if at this stage I find out what you and our other tutors can offer us, insofar as you can predict your availability. I hope my questions don’t pose too much of a distraction at this time.<br><br>So, could you let me know if there’s a Term in the coming academic year that is specially good, or specially bad, for doing some tutorials for Blackfriars?<br><br>Also, roughly how many tutorials a week you could reasonably do for us?<br><br>Could you remind me which topics you would specially like to teach if students need them, and which others you could teach if necessary?<br><br><% if make_lecture_request %>Could you also let me know if you would be available to give lectures on the following <%="topic".pl(num_topics)%> in the <%="term".pl(num_terms)%> specified, and if there are any constraints on the days and times at which you can give the <%="lecture".pl(num_lectures)%>?<br><br><% if first_term_lectures.length >0 %><% i = 0; ii=first_term_lectures.length-1; %><u><b><%=first_term_name%> Term <%= first_term_year %></b></u>: <%first_term_lectures.each do |lecture| course_name = Course.find(lecture.course_id).name; n=lecture.number_of_lectures;%><%= n %> <%="lecture".pl(n)%> on <%=course_name%><%if i< ii-1%><%=", "%><%elsif i== ii-1%><%=" and "%><%else%><%="."%><%end%><%i=i+1%><%end%><% end %><br><br><% if second_term_lectures.length >0 %><% i = 0; ii=second_term_lectures.length-1; %><u><b><%=second_term_name%> Term <%= second_term_year %></b></u>: <%second_term_lectures.each do |lecture| course_name = Course.find(lecture.course_id).name; n=lecture.number_of_lectures;%><%= n %> <%="lecture".pl(n)%> on <%=course_name%><%if i< ii-1%><%=", "%><%elsif i== ii-1%><%=" and "%><%else%><%="."%><%end%><%i=i+1%><%end%><% end %><br><br><% if third_term_lectures.length >0 %><% i = 0; ii=third_term_lectures.length-1; %><u><b><%=third_term_name%> Term <%= third_term_year %></b></u>: <%third_term_lectures.each do |lecture| course_name = Course.find(lecture.course_id).name; n=lecture.number_of_lectures;%><%= n %> <%="lecture".pl(n)%> on <%=course_name%><%if i< ii-1%><%=", "%><%elsif i== ii-1%><%=" and "%><%else%><%="."%><%end%><%i=i+1%><%end%><% end %><br><br><%end%>With many thanks for your help, and best wishes,<br><br>Richard.<br>(Richard Conrad, O.P., Vice Regent).<i-1%><br><p></p> <p></p></i-1%>},
      :term_dependency=>true,
      :course_dependency=>false,
      :global_warnings=>%q{michaelmas_term_id = TermName.where(:name =>"Michaelmas").first.id;   if michaelmas_term_id != term.term_name_id   then  warning_str << "WARNING: you haven't selected a Michaelmas term." end},
      :personal_warnings=>"");

    EmailTemplate.create(:template_name => "Next year's planned tuition, for tutors",
      :from_email => "<%= me.email %>",
      :subject => "Next year's teaching for Blackfriars?",
      :ruby_header=> %q{<%  first_term = term;     second_term_id = term.id + 1 ;     second_term = Term.find(second_term_id);     third_term_id = term.id + 2;     third_term = Term.find(third_term_id);     first_term_name = TermName.find(first_term.term_name_id).name;     first_term_year = first_term.year;     second_term_name = TermName.find(second_term.term_name_id).name;     second_term_year = second_term.year;     third_term_name = TermName.find(third_term.term_name_id).name;     third_term_year = third_term.year;       confirmed_groups = Group.find_by_sql("SELECT * FROM groups WHERE table_name = 'lectures' AND group_name='Lecturer Confirmed'");     language_groups = Group.find_by_sql("SELECT * FROM groups WHERE table_name = 'courses' AND group_name='Language Classes'");     if confirmed_groups.length >0 then confirmed_id = confirmed_groups[0].id else confirmed_id = 0 end;     if language_groups.length >0 then language_group_id = language_groups[0].id else language_group_id = 0 end;     first_term_lectures = Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture FROM lectures a0 WHERE a0.term_id = #{term.id} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0 AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");     second_term_lectures =  Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id+1} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0 AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");     third_term_lectures =  Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id+2} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0 AND(SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");     first_term_language_classes = Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");  second_term_language_classes =  Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id+1} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");  third_term_language_classes =  Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id+2} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND(SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");     first_term_tutorial_schedules = TutorialSchedule.find_by_sql("SELECT * FROM tutorial_schedules WHERE term_id = #{first_term.id} AND person_id = #{person.id}");     if first_term_tutorial_schedules.length > 0 then       first_term_tutorial_str = "";       first_term_tutorial_schedules.each do |tutorial_schedule1|         if (first_term_tutorial_str.length >0) then first_term_tutorial_str << ", "; end;         first_term_tutorial_str << tutorial_schedule1.id.to_s;       end;       first_term_tutorials = Tutorial.find_by_sql("SELECT  *, a10.number_of_tutorials AS num_tutorials, a99.first_name || '  ' || a99.second_name  AS student_name,   a83.name  AS course_name FROM tutorials a0 INNER JOIN people a99 ON  a0.person_id = a99.id INNER JOIN ( tutorial_schedules a10 INNER JOIN courses a83 ON  a10.course_id = a83.id ) ON a0.tutorial_schedule_id = a10.id  WHERE  (a0.id != 1  AND (a0.tutorial_schedule_id IN (#{first_term_tutorial_str}) )) ORDER BY  course_name asc, student_name  asc");     else       first_term_tutorials = [];     end;     second_term_language_classes = Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");  second_term_language_classes =  Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id+1} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");  third_term_language_classes =  Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id+2} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND(SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");     second_term_tutorial_schedules = TutorialSchedule.find_by_sql("SELECT * FROM tutorial_schedules WHERE term_id = #{second_term.id} AND person_id = #{person.id}");     if second_term_tutorial_schedules.length > 0 then       second_term_tutorial_str = "";       second_term_tutorial_schedules.each do |tutorial_schedule1|         if (second_term_tutorial_str.length >0) then second_term_tutorial_str << ", "; end;         second_term_tutorial_str << tutorial_schedule1.id.to_s;       end;       second_term_tutorials = Tutorial.find_by_sql("SELECT  *, a10.number_of_tutorials AS num_tutorials, a99.first_name || '  ' || a99.second_name  AS student_name,   a83.name  AS course_name FROM tutorials a0 INNER JOIN people a99 ON  a0.person_id = a99.id INNER JOIN ( tutorial_schedules a10 INNER JOIN courses a83 ON  a10.course_id = a83.id ) ON a0.tutorial_schedule_id = a10.id  WHERE  (a0.id != 1  AND (a0.tutorial_schedule_id IN (#{second_term_tutorial_str}) )) ORDER BY  course_name asc, student_name  asc");     else       second_term_tutorials = [];     end;     third_term_language_classes = Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");  third_term_language_classes =  Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id+1} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");  third_term_language_classes =  Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id+2} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND(SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");     third_term_tutorial_schedules = TutorialSchedule.find_by_sql("SELECT * FROM tutorial_schedules WHERE term_id = #{third_term.id} AND person_id = #{person.id}");     if third_term_tutorial_schedules.length > 0 then       third_term_tutorial_str = "";       third_term_tutorial_schedules.each do |tutorial_schedule1|         if (third_term_tutorial_str.length >0) then third_term_tutorial_str << ", "; end;         third_term_tutorial_str << tutorial_schedule1.id.to_s;       end;       third_term_tutorials = Tutorial.find_by_sql("SELECT  *, a10.number_of_tutorials AS num_tutorials, a99.first_name || '  ' || a99.second_name  AS student_name,   a83.name  AS course_name FROM tutorials a0 INNER JOIN people a99 ON  a0.person_id = a99.id INNER JOIN ( tutorial_schedules a10 INNER JOIN courses a83 ON  a10.course_id = a83.id ) ON a0.tutorial_schedule_id = a10.id  WHERE  (a0.id != 1  AND (a0.tutorial_schedule_id IN (#{third_term_tutorial_str}) )) ORDER BY  course_name asc, student_name  asc");     else       third_term_tutorials = [];     end;     students = Person.find_by_sql("SELECT  *, a0.first_name || '  ' || a0.second_name  AS student_name FROM people a0  WHERE (a0.id != 1  AND (SELECT COUNT(*) FROM tutorials y1 INNER JOIN tutorial_schedules y2 ON y2.id = y1.tutorial_schedule_id WHERE y1.person_id = a0.id AND y2.person_id = #{person.id} AND  y2.term_id = #{term.id})>0 ) ORDER BY  student_name  asc ");   %>},
      :body=> %q{Dear <%= person.salutation%>,<br><br>I have been working out who should teach what to whom and how at Blackfriars in the course of the coming academic year, and I should like to invite you to undertake the following teaching. If the proposed lecture courses are acceptable, they will stand. The tutorial courses are liable to fine-tuning as the year develops, but should stay substantially the same. I will of course be in touch term-by-term to confirm or fine-tune the arrangements.<br><br><% if (first_term_lectures.length + first_term_language_classes.length + first_term_tutorials.length) >0 %><u><b><%=first_term_name%> Term <%= first_term_year %></b></u>:<% if first_term_lectures.length >0%><br><br><b>Lectures</b>:<% first_term_lectures.each do |lecture| course_name = Course.find(lecture.course_id).name; num_students =lecture.number_of_students_at_lecture.to_i %><br><u><%=course_name%></u>. <%if num_students>0%> I expect roughly <%=num_students%> <%= "student".pl(num_students)%> to attend.&nbsp; <%else%> I currently don't know how many students will attend<%end%><% end %> <% end %><% if first_term_language_classes.length >0%><br><br><b>Language Classes</b>:<% first_term_language_classes.each do |lecture| course_name = Course.find(lecture.course_id).name; num_students = lecture.number_of_students_at_lecture.to_i %><br><u><%=course_name%></u>. <%if num_students>0%> I expect roughly <%=num_students%> <%= "student".pl(num_students)%> to attend.&nbsp; <%else%> I currently don't know how many students will attend<%end%><% end %> <% end %><% if first_term_tutorials.length> 0%><br><br><b>Tutorials</b>:<% first_term_tutorials.each do |tutorial| num_tutorials = tutorial.num_tutorials.to_i; student = tutorial.student_name; course = tutorial.course_name%><br><%=num_tutorials%> <%="tutorial".pl(num_tutorials)%> on <%=course%> for <%=student%> <% end %> <% end %><% end %><br><br><% if (second_term_lectures.length + second_term_language_classes.length + second_term_tutorials.length) >0 %><u><b><%=second_term_name%> Term <%= second_term_year %></b></u>:<% if second_term_lectures.length >0%><br><br><b>Lectures</b>:<% second_term_lectures.each do |lecture| course_name = Course.find(lecture.course_id).name; num_students =lecture.number_of_students_at_lecture.to_i %><br><u><%=course_name%></u>. <%if num_students>0%> I expect roughly <%=num_students%> <%= "student".pl(num_students)%> to attend.&nbsp; <%else%> I currently don't know how many students will attend<%end%><% end %> <% end %><% if second_term_language_classes.length >0%><br><br><b>Language Classes</b>:<% second_term_language_classes.each do |lecture| course_name = Course.find(lecture.course_id).name; num_students = lecture.number_of_students_at_lecture.to_i %><br><u><%=course_name%></u>. <%if num_students>0%> I expect roughly <%=num_students%> <%= "student".pl(num_students)%> to attend.&nbsp; <%else%> I currently don't know how many students will attend<%end%><% end %> <% end %><% if second_term_tutorials.length> 0%><br><br><b>Tutorials</b>:<% second_term_tutorials.each do |tutorial| num_tutorials = tutorial.num_tutorials.to_i; student = tutorial.student_name; course = tutorial.course_name%><br><%=num_tutorials%> <%="tutorial".pl(num_tutorials)%> on <%=course%> for <%=student%> <% end %> <% end %><% end %><br><br><% if (third_term_lectures.length + third_term_language_classes.length + third_term_tutorials.length) >0 %><u><b><%=third_term_name%> Term <%= third_term_year %></b></u>:<% if third_term_lectures.length >0%><br><br><b>Lectures</b>:<% third_term_lectures.each do |lecture| course_name = Course.find(lecture.course_id).name; num_students =lecture.number_of_students_at_lecture.to_i %><br><u><%=course_name%></u>. <%if num_students>0%> I expect roughly <%=num_students%> <%= "student".pl(num_students)%> to attend.&nbsp; <%else%> I currently don't know how many students will attend<%end%><% end %> <% end %><% if third_term_language_classes.length >0%><br><br><b>Language Classes</b>:<% third_term_language_classes.each do |lecture| course_name = Course.find(lecture.course_id).name; num_students = lecture.number_of_students_at_lecture.to_i %><br><u><%=course_name%></u>. <%if num_students>0%> I expect roughly <%=num_students%> <%= "student".pl(num_students)%> to attend.&nbsp; <%else%> I currently don't know how many students will attend<%end%><% end %> <% end %><% if third_term_tutorials.length> 0%><br><br><b>Tutorials</b>:<% third_term_tutorials.each do |tutorial| num_tutorials = tutorial.num_tutorials.to_i; student = tutorial.student_name; course = tutorial.course_name%><br><%=num_tutorials%> <%="tutorial".pl(num_tutorials)%> on <%=course%> for <%=student%> <% end %> <% end %><% end %><br><br><u>Please let me know</u>:<br><br>Can you manage the teaching load?<br><br>Could you reasonably fit anything more in if I needed to find a few more tutors?<br><br>Do you need details of what is prescribed for any of the lecture courses or tutorials? <span style="color: rgb(64, 160, 255);" tag="span" class="yui-tag-span yui-tag">– apart from the module descriptors attached to this email.</span><br><br>Do you need more information about any of the students you will be tutoring, their backgrounds, needs, interests?<br><br><%if students.length > 0 %><u><b>Vacation Reading and students’ contact details for Michaelmas Term:</b></u><br><br>These are the email addresses of your students for Michaelmas Term. It would be good to give them recommendations for vacation reading, if you can. Hopefully they will get in touch with you nearer Term to fix tutorial times and topics.<br><br><%students.each do |student|%><%=student.student_name%>: <%=student.email%><br><%end%><% end %><br>With many thanks, and best wishes,<br>Richard.<br>(Richard Conrad, O.P., Vice Regent).<br>   	 	 	<br>},
      :term_dependency=>true,
      :course_dependency=>false,
      :global_warnings=>"",
      :personal_warnings=>"");

    EmailTemplate.create(:template_name => "Next year's planned tuition, for students",
      :from_email => "<%= me.email %>",
      :subject => "Next year's studies at Blackfriars",
      :ruby_header=> %q{<%  first_term = term;     second_term_id = term.id + 1 ;    second_term = Term.find(second_term_id);    third_term_id = term.id + 2;    third_term = Term.find(third_term_id);    first_term_name = TermName.find(first_term.term_name_id).name;    first_term_year = first_term.year;    second_term_name = TermName.find(second_term.term_name_id).name;    second_term_year = second_term.year;    third_term_name = TermName.find(third_term.term_name_id).name;    third_term_year = third_term.year;        language_groups = Group.find_by_sql("SELECT * FROM groups WHERE table_name = 'courses' AND group_name='Language Classes'");      if language_groups.length >0 then language_group_id = language_groups[0].id; else language_group_id = 0; end;    first_term_examined =  Lecture.find_by_sql("SELECT  a0.id, a30.name  AS course_name FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND y1.examined = true AND a0.term_id = #{first_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0) ORDER BY   course_name  asc ");    first_term_not_examined =  Lecture.find_by_sql("SELECT  a0.id, a30.name  AS course_name FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND y1.examined = false AND a0.term_id = #{first_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0) ORDER BY   course_name  asc ");    first_term_languages = Lecture.find_by_sql("SELECT  a0.id, a30.name AS course_name, x1.first_name || ' ' || x1.second_name AS tutor_name FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN people x1 ON x1.id = a0.person_id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND a0.term_id = #{first_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0) ORDER BY  course_name  asc ");    first_term_tutorials = TutorialSchedule.find_by_sql("SELECT  a0.id, a0.number_of_tutorials, a30.name AS course_name, a31.first_name || ' ' || a31.second_name AS tutor_name FROM tutorial_schedules a0 INNER JOIN courses a30 ON a0.course_id = a30.id INNER JOIN people a31 ON a31.id = a0.person_id INNER JOIN tutorials y1 ON y1.tutorial_schedule_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND a0.term_id = #{first_term.id}) ORDER BY  course_name  asc ");    first_term_tutors = Person.find_by_sql("SELECT a0.first_name || ' ' || a0.second_name AS tutor_name, a0.email FROM people a0 WHERE (a0.id != 1 AND (SELECT COUNT(*) FROM tutorials y1 INNER JOIN tutorial_schedules y2 ON y2.id = y1.tutorial_schedule_id WHERE y2.person_id = a0.id AND y1.person_id = #{person.id} AND y2.term_id = #{first_term.id})>0) ORDER BY tutor_name asc  ");    if first_term_languages.length !=0 then     language_ids = "";    first_term_languages.each do|language|      if language_ids.length>0 then language_ids << ", "; end;  language_ids << language.id.to_s;    end;    first_term_language_tutors = Person.find_by_sql("SELECT a0.id, a0.first_name|| ' ' || a0.second_name AS tutor_name, a0.email FROM people a0 WHERE (a0.id != 1 AND (SELECT COUNT(*) FROM attendees y1 INNER JOIN lectures y2 ON y2.id = y1.lecture_id WHERE y2.person_id = a0.id AND y1.person_id = #{person.id} AND y2.term_id = #{first_term.id} AND y2.id IN (#{language_ids}) )>0) ORDER BY tutor_name asc ");  else    first_term_language_tutors = [];  end;second_term_examined =  Lecture.find_by_sql("SELECT  a0.id, a30.name  AS course_name  FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND y1.examined = true AND a0.term_id = #{second_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0) ORDER BY   course_name  asc ");    second_term_not_examined =  Lecture.find_by_sql("SELECT   a0.id, a30.name  AS course_name FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND y1.examined = false AND a0.term_id = #{second_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0) ORDER BY   course_name  asc ");    second_term_languages = Lecture.find_by_sql("SELECT  a0.id, a30.name AS course_name, x1.first_name || ' ' || x1.second_name AS tutor_name FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN people x1 ON x1.id = a0.person_id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND a0.term_id = #{second_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0) ORDER BY  course_name  asc ");    second_term_tutorials = TutorialSchedule.find_by_sql("SELECT   a0.id, a0.number_of_tutorials, a30.name AS course_name, a31.first_name || ' ' || a31.second_name AS tutor_name FROM tutorial_schedules a0 INNER JOIN courses a30 ON a0.course_id = a30.id INNER JOIN people a31 ON a31.id = a0.person_id INNER JOIN tutorials y1 ON y1.tutorial_schedule_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND a0.term_id = #{second_term.id}) ORDER BY  course_name  asc ");third_term_examined =  Lecture.find_by_sql("SELECT   a0.id, a30.name  AS course_name FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND y1.examined = true AND a0.term_id = #{third_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0) ORDER BY   course_name  asc ");    third_term_not_examined =  Lecture.find_by_sql("SELECT   a0.id, a30.name  AS course_name FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND y1.examined = false AND a0.term_id = #{third_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0) ORDER BY   course_name  asc ");   third_term_languages = Lecture.find_by_sql("SELECT  a0.id, a30.name AS course_name, x1.first_name || ' ' || x1.second_name AS tutor_name FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN people x1 ON x1.id = a0.person_id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND a0.term_id = #{third_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0) ORDER BY  course_name  asc ");    third_term_tutorials = TutorialSchedule.find_by_sql("SELECT  a0.id,a0.number_of_tutorials, a30.name AS course_name, a31.first_name || ' ' || a31.second_name AS tutor_name FROM tutorial_schedules a0 INNER JOIN courses a30 ON a0.course_id = a30.id INNER JOIN people a31 ON a31.id = a0.person_id INNER JOIN tutorials y1 ON y1.tutorial_schedule_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND a0.term_id = #{third_term.id}) ORDER BY  course_name  asc ");%>},
      :body=> %q{Dear <%= person.salutation%>,<br><br>I have been organising the studies for Blackfriars’ students for the coming academic year, and have made the following arrangements for you. If anything seems odd, surprising, alarming, or even wrong, let me know. As with most years, some fine-tuning of the arrangements is only to be expected.<br><br><% if first_term_examined.length + first_term_not_examined.length + first_term_languages.length + first_term_tutorials.length > 0 %><u><b><%=first_term_name%> Term, <%= first_term_year%></b></u>:<br><% if first_term_examined.length>0 %><br><b>Lectures needing an end-of-term examination</b>:<br><% first_term_examined.each do |lecture| %><u><%=lecture.course_name%></u>.<br><% end %><% end%><% if first_term_not_examined.length>0%><br><b>Lectures not needing an end-of-term examination</b>:<br><% first_term_not_examined.each do |lecture| %><u><%= lecture.course_name%></u>.<br><%end%><%end%><% if first_term_languages.length>0%><br><b>Language classes</b>:<br><%first_term_languages.each do |lecture|%><u><%=lecture.course_name%></u> with <%=lecture.tutor_name %>.<br><%end%><%end%><% if first_term_tutorials.length>0 %><br><b>Tutorials</b>:<br><%first_term_tutorials.each do |tutorial| %><%=tutorial.number_of_tutorials%> <%="tutorial".pl(tutorial.number_of_tutorials)%> on <%= tutorial.course_name%> with <%=tutorial.tutor_name%>.<br><% end%><% end %><br><% end %><% if second_term_examined.length + second_term_not_examined.length + second_term_languages.length + second_term_tutorials.length > 0 %><u><b><%=second_term_name%> Term, <%= second_term_year%></b></u>:<br><% if second_term_examined.length>0 %><br><b>Lectures needing an end-of-term examination</b>:<br><% second_term_examined.each do |lecture| %><u><%=lecture.course_name%></u>.<br><% end %><% end%><% if second_term_not_examined.length>0%><br><b>Lectures not needing an end-of-term examination</b>:<br><% second_term_not_examined.each do |lecture| %><u><%= lecture.course_name%></u>.<br><%end%><%end%><% if second_term_languages.length>0%><br><b>Language classes</b>:<br><%second_term_languages.each do |lecture|%><u><%=lecture.course_name%></u> with <%=lecture.tutor_name %>.<br><%end%><%end%><% if second_term_tutorials.length>0 %><br><b>Tutorials</b>:<br><%second_term_tutorials.each do |tutorial| %><%=tutorial.number_of_tutorials%> <%="tutorial".pl(tutorial.number_of_tutorials)%> on <%= tutorial.course_name%> with <%=tutorial.tutor_name%>.<br><% end%><% end %><br><% end %><% if third_term_examined.length + third_term_not_examined.length + third_term_languages.length + third_term_tutorials.length > 0 %><u><b><%=third_term_name%> Term, <%= third_term_year%></b></u>:<br><% if third_term_examined.length>0 %><br><b>Lectures needing an end-of-term examination</b>:<br><% third_term_examined.each do |lecture|%><u><%= lecture.course_name%></u><br><% end %><% end%><% if third_term_not_examined.length>0%><br><b>Lectures not needing an end-of-term examination</b>:<br><% third_term_not_examined.each do |lecture| %><u><%= lecture.course_name%></u>.<br><%end%><%end%><% if third_term_languages.length>0%><br><b>Language classes</b>:<br><%third_term_languages.each do |lecture|%><u><%=lecture.course_name%></u> with <%=lecture.tutor_name %><br><%end%><%end%><% if third_term_tutorials.length>0 %><br><b>Tutorials</b>:<br><%third_term_tutorials.each do |tutorial| %><%=tutorial.number_of_tutorials%> <%="tutorial".pl(tutorial.number_of_tutorials)%> on <%= tutorial.course_name%> with <%=tutorial.tutor_name%>.<br><% end%><% end %><br><% end %><u><b>Syllabuses and Vacation Reading</b></u>:<br>I attach the “descriptors” for the Michaelmas Term courses. These include some bibliography, and it would be good to get ahead with some reading. If you can get more specific advice from your tutors, follow that; otherwise use the descriptors, and browse the library! <% if first_term_tutorials.length + first_term_languages.length>0%><br><br><u><b>Tutors’ contact details for Michaelmas Term</b></u>:<br>These are the email addresses of your tutors for Michaelmas Term, and of the lecturers who will run the language classes you are attending. It would be good to ask the tutors for recommendations for vacation reading, and to get in touch again nearer Term to fix tutorial times and topics. Ask the language-class lecturers what preparations to make for the language classes.<br><br><% if first_term_tutors.length >0 %><b>Tutorial Emails</b>:<br><%first_term_tutors.each do |a_tutor|%><%=a_tutor.tutor_name%>: <%=a_tutor.email%>.<br><%end%><br><% end %><% if first_term_language_tutors.length >0 %><b>Language Class Emails</b>:<br><%first_term_language_tutors.each do |a_tutor|%><%=a_tutor.tutor_name%>: <%=a_tutor.email%>.<br><%end%><%end%><br><%end%>If anything seems unclear, or you need more advice for the vacation, or feel the need to change some of the arrangements, please get in touch.<br>With best wishes,<br>Richard.<br>(Richard Conrad, O.P., Vice Regent).<br><br><br><p></p>},
      :term_dependency=>true,
      :course_dependency=>false,
      :global_warnings=>"",
      :personal_warnings=>"");

      EmailTemplate.create(:template_name => "Confirmation of teaching plans, for tutors",
      :from_email => "<%= me.email %>",
      :subject => "The coming Term’s teaching for Blackfriars",
      :ruby_header=> %q{<%  first_term = term;  first_term_name = TermName.find(first_term.term_name_id).name;  first_term_year = first_term.year;  confirmed_groups = Group.find_by_sql("SELECT * FROM groups WHERE table_name = 'lectures' AND group_name='Lecturer Confirmed'");  language_groups = Group.find_by_sql("SELECT * FROM groups WHERE table_name = 'courses' AND group_name='Language Classes'");  if confirmed_groups.length >0 then confirmed_id = confirmed_groups[0].id else confirmed_id = 0 end;  if language_groups.length >0 then language_group_id = language_groups[0].id else language_group_id = 0 end;  first_term_lectures = Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture FROM lectures a0 WHERE a0.term_id = #{term.id} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0 AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");  first_term_language_classes = Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");  second_term_language_classes =  Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id+1} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND (SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");  third_term_language_classes =  Lecture.find_by_sql("SELECT *, (SELECT COUNT(*) FROM attendees x1 WHERE x1.lecture_id = a0.id) AS number_of_students_at_lecture  FROM lectures a0 WHERE a0.term_id = #{term.id+2} AND a0.person_id = #{person.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0 AND(SELECT COUNT(*) FROM group_lectures a1 WHERE a1.group_id=#{confirmed_id} AND a1.lecture_id = a0.id)>0");  first_term_tutorial_schedules = TutorialSchedule.find_by_sql("SELECT * FROM tutorial_schedules WHERE term_id = #{first_term.id} AND person_id = #{person.id}");  if first_term_tutorial_schedules.length > 0 then       first_term_tutorial_str = "";       first_term_tutorial_schedules.each do |tutorial_schedule1|      if (first_term_tutorial_str.length >0) then first_term_tutorial_str << ", "; end;         first_term_tutorial_str << tutorial_schedule1.id.to_s;       end;    first_term_tutorials = Tutorial.find_by_sql("SELECT  *, a10.number_of_tutorials AS num_tutorials, a99.first_name || '  ' || a99.second_name  AS student_name,   a83.name  AS course_name FROM tutorials a0 INNER JOIN people a99 ON  a0.person_id = a99.id INNER JOIN ( tutorial_schedules a10 INNER JOIN courses a83 ON  a10.course_id = a83.id ) ON a0.tutorial_schedule_id = a10.id  WHERE  (a0.id != 1  AND (a0.tutorial_schedule_id IN (#{first_term_tutorial_str}) )) ORDER BY  course_name asc, student_name  asc");  else    first_term_tutorials = [];     end;  students = Person.find_by_sql("SELECT  *, a0.first_name || '  ' || a0.second_name  AS student_name FROM people a0  WHERE (a0.id != 1  AND (SELECT COUNT(*) FROM tutorials y1 INNER JOIN tutorial_schedules y2 ON y2.id = y1.tutorial_schedule_id WHERE y1.person_id = a0.id AND y2.person_id = #{person.id} AND  y2.term_id = #{term.id})>0 ) ORDER BY  student_name  asc ");%>},
      :body=> %q{Dear <%= person.salutation%>,<br><br><%if first_term_name == "Michaelmas"%>I hope you had a good summer.<br><br><% end%>Thanks for expressing your willingness to undertake the teaching for Blackfriars that I asked you to undertake.<br><br>This email is to confirm the arrangements <b>for the coming <%=first_term_name%> Term</b>. <span style="color: rgb(128, 192, 255);" tag="span" class="yui-tag-span yui-tag">You will see there has been a bit of fine-tuning to the tutorial courses, but this should not increase your work load</span>. If there are now any problems with the teaching, then of course please be in touch and we can modify the arrangements.<br><br>I attach the lecture list for the term in case you have mislaid the copy sent earlier.<% if (first_term_lectures.length + first_term_language_classes.length + first_term_tutorials.length) >0 %><% if first_term_lectures.length >0%><br><br><b>Lectures</b>:<% first_term_lectures.each do |lecture| course_name = Course.find(lecture.course_id).name; num_students =lecture.number_of_students_at_lecture.to_i %><br><u><%=course_name%></u>. <%if num_students>0%> I expect roughly <%=num_students%> <%= "student".pl(num_students)%> to attend.&nbsp; <%else%> I currently don't know how many students will attend<%end%><% end %> <% end %><% if first_term_language_classes.length >0%><br><br><b>Language Classes</b>:<% first_term_language_classes.each do |lecture| course_name = Course.find(lecture.course_id).name; num_students = lecture.number_of_students_at_lecture.to_i %><br><u><%=course_name%></u>. <%if num_students>0%> I expect roughly <%=num_students%> <%= "student".pl(num_students)%> to attend.&nbsp; <%else%> I currently don't know how many students will attend<%end%><% end %> <% end %><% if first_term_tutorials.length> 0%><br><br><b>Tutorials</b>:<% first_term_tutorials.each do |tutorial| num_tutorials = tutorial.num_tutorials.to_i; student = tutorial.student_name; course = tutorial.course_name%><br><%=num_tutorials%> <%="tutorial".pl(num_tutorials)%> on <%=course%> for <%=student%> <% end %> <% end %><br><br><% end %>Do you need more information about any of the students you will be tutoring, their backgrounds, needs, interests?<br><br><%if students.length > 0%> <%if first_term_name == "Michaelmas" %>In case you still need to chase up any of your tutorial students for the forthcoming Michaelmas Term, here is an up-to-date list of email addresses.<br><br><%students.each do |student|%><%=student.student_name%>: <%=student.email%><br><%end%><br>With many thanks, and best wishes for the new academic year,<% else %><u><b>Vacation Reading and students’ contact details:</b></u><br><br>These are the up-to-date email addresses of your students for next Term. It would be good to give them recommendations for vacation reading, if you can. Hopefully they will get in touch with you nearer Term to fix tutorial times and topics.<br><br><%students.each do |student|%><%=student.student_name%>: <%=student.email%><br><%end%><br>I hope you have a good vacation.<br><br>With many thanks, and best wishes,<% end %><br><%end%><br>Richard.<br><br>(Richard Conrad, O.P., Vice Regent).<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; <br><br>},
      :term_dependency=>true,
      :course_dependency=>false,
      :global_warnings=>"",
      :personal_warnings=>"");

    EmailTemplate.create(:template_name => "Confirmation of teaching plans, for students",
      :from_email => "<%= me.email %>",
      :subject => "The coming Term’s studies at Blackfriars",
      :ruby_header=> %q{<%     first_term = term;       first_term_name = TermName.find(first_term.term_name_id).name;    first_term_year = first_term.year;       language_groups = Group.find_by_sql("SELECT * FROM groups WHERE table_name = 'courses' AND group_name='Language Classes'");     if language_groups.length >0 then language_group_id = language_groups[0].id; else language_group_id = 0; end;        first_term_examined =  Lecture.find_by_sql("SELECT  a0.id, a30.name  AS course_name FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND y1.examined = true AND a0.term_id = #{first_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0) ORDER BY   course_name  asc ");        first_term_not_examined =  Lecture.find_by_sql("SELECT  a0.id, a30.name  AS course_name FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND y1.examined = false AND a0.term_id = #{first_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)=0) ORDER BY   course_name  asc ");       first_term_languages = Lecture.find_by_sql("SELECT  a0.id, a30.name AS course_name, x1.first_name || ' ' || x1.second_name AS tutor_name FROM lectures a0 INNER JOIN courses a30 ON  a0.course_id = a30.id INNER JOIN people x1 ON x1.id = a0.person_id INNER JOIN attendees y1 ON y1.lecture_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND a0.term_id = #{first_term.id} AND (SELECT COUNT(*) FROM group_courses a2 WHERE a2.group_id = #{language_group_id} AND a2.course_id = a0.course_id)>0) ORDER BY  course_name  asc ");        first_term_tutorials = TutorialSchedule.find_by_sql("SELECT  a0.id, a0.number_of_tutorials, a30.name AS course_name, a31.first_name || ' ' || a31.second_name AS tutor_name FROM tutorial_schedules a0 INNER JOIN courses a30 ON a0.course_id = a30.id INNER JOIN people a31 ON a31.id = a0.person_id INNER JOIN tutorials y1 ON y1.tutorial_schedule_id = a0.id  WHERE  (a0.id != 1  AND y1.person_id =#{person.id} AND a0.term_id = #{first_term.id}) ORDER BY  course_name  asc ");        first_term_tutors = Person.find_by_sql("SELECT a0.first_name || ' ' || a0.second_name AS tutor_name, a0.email FROM people a0 WHERE (a0.id != 1 AND (SELECT COUNT(*) FROM tutorials y1 INNER JOIN tutorial_schedules y2 ON y2.id = y1.tutorial_schedule_id WHERE y2.person_id = a0.id AND y1.person_id = #{person.id} AND y2.term_id = #{first_term.id})>0) ORDER BY tutor_name asc  ");        if first_term_languages.length !=0 then     language_ids = "";    first_term_languages.each do|language|      if language_ids.length>0 then language_ids << ", "; end;  language_ids << language.id.to_s;    end;          first_term_language_tutors = Person.find_by_sql("SELECT a0.id, a0.first_name|| ' ' || a0.second_name AS tutor_name, a0.email FROM people a0 WHERE (a0.id != 1 AND (SELECT COUNT(*) FROM attendees y1 INNER JOIN lectures y2 ON y2.id = y1.lecture_id WHERE y2.person_id = a0.id AND y1.person_id = #{person.id} AND y2.term_id = #{first_term.id} AND y2.id IN (#{language_ids}) )>0) ORDER BY tutor_name asc ");      else    first_term_language_tutors = [];  end;%>},
      :body=> %q{Dear <%= person.salutation%>,<br><br><%if first_term_name == "Michaelmas"%>I hope you had a good summer.<br><br><% end%>This email is to confirm the arrangements <b>for the coming <%=first_term_name%> Term</b>. If any problems have emerged to do with these studies, then of course please be in touch and we can deal with them.<br><br>I attach the lecture list for the term in case you have mislaid the copy sent earlier.<br><br><% if first_term_examined.length + first_term_not_examined.length + first_term_languages.length + first_term_tutorials.length > 0 %><% if first_term_examined.length>0 %><b>Lectures needing an end-of-term examination</b>:<br><% first_term_examined.each do |lecture| %><u><%=lecture.course_name%></u>.<br><% end %><br><% end%><% if first_term_not_examined.length>0%><b>Lectures not needing an end-of-term examination</b>:<br><% first_term_not_examined.each do |lecture| %><u><%= lecture.course_name%></u>.<br><%end%><%end%><% if first_term_languages.length>0%><br><b>Language classes</b>:<br><%first_term_languages.each do |lecture|%><u><%=lecture.course_name%></u> with <%=lecture.tutor_name %>.<br><%end%><%end%><% if first_term_tutorials.length>0 %><br><b>Tutorials</b>:<br><%first_term_tutorials.each do |tutorial| %><%=tutorial.number_of_tutorials%> <%="tutorial".pl(tutorial.number_of_tutorials)%> on <%= tutorial.course_name%> with <%=tutorial.tutor_name%>.<br><% end%><% end %><br><% end %><% if first_term_name == "Michaelmas" %><u><b>Tutors’ contact details for Michaelmas Term</b></u>:<br>In case you still need to chase up any of your tutors and lecturers for <%if first_term_name == "Michaelmas"%>the forthcoming Michaelmas<%else%> next <%end%> Term, here is an up-to-date list of email addresses. <br><br><% if first_term_tutors.length >0 %><b>Tutorial Emails</b>:<br><%first_term_tutors.each do |a_tutor|%><%=a_tutor.tutor_name%>: <%=a_tutor.email%>.<br><%end%><br><% end %><% if first_term_language_tutors.length >0 %><b>Language Class Emails</b>:<br><%first_term_language_tutors.each do |a_tutor|%><%=a_tutor.tutor_name%>: <%=a_tutor.email%>.<br><%end%><br><%end%>With best wishes for the new academic year,<% else %><u><b>Syllabuses and Vacation Reading</b></u>:<br>I attach the “descriptors” for next Term’s courses. These include some bibliography, and it would be good to get ahead with some reading. If you can get more specific advice from your tutors, follow that; otherwise use the descriptors, and browse the library!<br><br><u><b>Tutors’ contact details for next Term</b></u>:<br>These are the up-to-date email addresses of your tutors for next Term. It would be good to ask them for recommendations for vacation reading, and to get in touch again nearer Term to fix tutorial times and topics.<br><br><% if first_term_tutors.length >0 %><b>Tutorial Emails</b>:<br><%first_term_tutors.each do |a_tutor|%><%=a_tutor.tutor_name%>: <%=a_tutor.email%>.<br><%end%><br><% end %><% if first_term_language_tutors.length >0 %><b>Language Class Emails</b>:<br><%first_term_language_tutors.each do |a_tutor|%><%=a_tutor.tutor_name%>: <%=a_tutor.email%>.<br><% end %><br><%end%> If anything seems unclear, or you need more advice for the vacation, or feel the need to change some of the arrangements, please get in touch.<br><br>I hope you have a good vacation.<br><br>With best wishes,<%end%><br><br>Richard.<br><br>(Richard Conrad, O.P., Vice Regent).<br>},
      :term_dependency=>true,
      :course_dependency=>false,
      :global_warnings=>"",
      :personal_warnings=>"");

    EmailTemplate.create(:template_name =>"Class list and reminder of exam arrangements",
      :from_email => "<%= me.email %>",
      :subject => "Class and exam list for the coming Term at Blackfriars",
      :ruby_header=> %q{<% lecture_schedules = Lecture.find_by_sql("SELECT * FROM lectures WHERE course_id = #{course.id} AND term_id = #{term.id}");     if lecture_schedules.length >0 then       lecture_id = lecture_schedules[0].id;      exam_attendees = Attendee.find_by_sql("SELECT *, a1.first_name || ' ' || a1.second_name AS student_name FROM attendees a0 INNER JOIN people a1 ON a1.id=a0.person_id AND a0.lecture_id = #{lecture_id} AND a0.examined= true ORDER BY student_name");      non_exam_attendees =  Attendee.find_by_sql("SELECT *, a1.first_name || ' ' || a1.second_name AS student_name FROM attendees a0 INNER JOIN people a1 ON a1.id=a0.person_id AND a0.lecture_id = #{lecture_id} AND a0.examined= false ORDER BY student_name");    else      exam_attendees = [];      non_exam_attendees = [];    end;%>},
      :body=> %q{Dear <%= person.salutation %>,<br><br>This email concerns the lecture course on <%=course.name%> for the current Term. <% if (exam_attendees.length + non_exam_attendees.length) >0 %> As I understand it, the following students are supposed to attend the lecture course – there may well be others in the class, for whom it is optional.<br><% if exam_attendees.length >0 %> <br><b>Students needing an end-of-term examination</b>:<br><br>These students need a grade for the course, but are not taking tutorials in the subject. The lecturer normally determines the exam format (often a short viva-voce exam) and scope, and explains this to the students. Exams are usually held on the Monday or Tuesday of 9th Week, at a time to suit the lecturer and the students involved.<br><br><% exam_attendees.each do |attendee|%> <%=attendee.student_name%><br><%end%><br><%end%><% if non_exam_attendees.length >0 %> <b>Students not needing an end-of-term examination</b>:<br><br><% non_exam_attendees.each do |attendee|%> <%=attendee.student_name%><br><%end%><br><%end%><% else%>No one needs to be examined in this course and no one is required to attend.<%end%>If anything seems odd, surprising, alarming, or even wrong with these arrangements, let me know.<br><br>With best wishes,<br><br>Richard.<br><br>(Richard Conrad, O.P., vice-regent)<br><br>},
      :term_dependency=>true,
      :course_dependency=>false,
      :global_warnings=>"",
      :personal_warnings=>"");

        Rails.logger.debug( "import_csv done display filters" );
    Rails.logger.flush

  end
  
  def fetch_updated_rows
    Rails.logger.info("RWV fetch_updated_rows called with params: #{params.inspect}")
    
    # Capture user ID at the start of the request to prevent race conditions
    current_user_id = session[:user_id]
    Rails.logger.info("RWV fetch_updated_rows: Request initiated by user_id=#{current_user_id}")
    
    table_name = params[:table_name]
    row_ids = params[:row_ids]&.split(',')&.map(&:to_i) || []
    
    if table_name.blank? || row_ids.empty?
      render json: { 
        error: 'Missing table_name or row_ids',
        user_id: current_user_id,
        request_timestamp: Time.current.to_f
      }, status: :bad_request
      return
    end
    
    begin
      # Get the existing search controller from session (which has the proper filters and setup)
      unless session[:search_ctls]
        InitializeSessionController
      end
      
      search_controller = session[:search_ctls][table_name]
      
      if search_controller.nil?
        render json: { 
          error: "No search controller found for table #{table_name}",
          user_id: current_user_id,
          request_timestamp: Time.current.to_f
        }, status: :not_found
        return
      end
      
      # Verify user ID hasn't changed during request processing (race condition check)
      if session[:user_id] != current_user_id
        Rails.logger.warn("RWV fetch_updated_rows: User ID changed during request! Started with #{current_user_id}, now have #{session[:user_id]}")
        render json: { 
          error: "User session changed during request processing",
          user_id: current_user_id,
          request_timestamp: Time.current.to_f
        }, status: :conflict
        return
      end
      
      # Get the model class
      model_class = table_name.constantize
      
      # Set the search controller on the model class so the partial can access it
      model_class.set_controller(search_controller)
      
      # Apply the same filtering logic as the search controller
      # Use the search controller's eval string to get filtered results
      sql_str = search_controller.get_sql_id_string(row_ids)
      eval_str =  "#{table_name}.find_by_sql(\"#{sql_str}\")"
      Rails.logger.info("RWV fetch_updated_rows: User #{current_user_id} using eval string: #{eval_str}")
      
      filtered_results = eval(eval_str)
      
      # Final user ID verification before processing results
      if session[:user_id] != current_user_id
        Rails.logger.warn("RWV fetch_updated_rows: User ID changed after query! Started with #{current_user_id}, now have #{session[:user_id]}")
        render json: { 
          error: "User session changed during query processing",
          user_id: current_user_id,
          request_timestamp: Time.current.to_f
        }, status: :conflict
        return
      end
      
      # Find the requested rows among the filtered results only
      
      
      rows = filtered_results.select { |r| row_ids.include?(r.id) }
     
     
      Rails.logger.info("RWV fetch_updated_rows: User #{current_user_id} - #{row_ids.size} requested, #{rows.size} matched filters for #{table_name}")
      
      # Generate HTML for each row using the same logic as the search results
      updated_rows = rows.map do |row|
        # Use the search controller's row rendering logic
        row_html = render_to_string(
          partial: 'shared/search_results_row_button',
          object: row,
          formats: [:html]
        )        
        {
          id: row.id,
          html: row_html.strip
        }
      end
      
      Rails.logger.info("RWV fetch_updated_rows: User #{current_user_id} - Successfully generated #{updated_rows.size} row updates for #{table_name}")
      
      respond_to do |format|
        format.json { 
          render json: {
            success: true,
            user_id: current_user_id,
            table_name: table_name,
            rows: updated_rows,
            request_timestamp: Time.current.to_f
          }
        }
      end      
      
    rescue => e
      Rails.logger.error("RWV Error in fetch_updated_rows for user #{current_user_id}: #{e.message}")
      Rails.logger.error("RWV #{e.backtrace.first(5).join("\n")}")
      render json: { 
        error: e.message,
        user_id: current_user_id,
        request_timestamp: Time.current.to_f
      }, status: :internal_server_error
    end
  end
end  

