
class GroupFilterElt
 
  attr_reader :foreign_key
  attr_reader :group_id
  attr_reader :class_name
  attr_reader :possible_groups

  

  def initialize(foreign_key, group_id, class_name)
  #  Rails.logger.error( "new GroupFilterElt" );
    @foreign_key = foreign_key
    @group_id = group_id
    @class_name = class_name
    UpdatePossibleGroups();
  end
  def UpdatePossibleGroups()
    sql_str = "Group.find_by_sql(\"SELECT id, group_name FROM groups WHERE id != 1 AND table_name = '" + @class_name.tableize + "' \")"
 #   Rails.logger.error( "DEBUG: before eval(#{sql_str})" );
    @possible_groups =   eval(sql_str);
     
  end

end
class GroupFilterElts
  attr_reader :table_name
  attr_reader :user_id
  attr_reader :group_filter_elts
  attr_reader :possible_char_length
 
  def initialize(table_name,  user_id, group_filter_elts)
#    Rails.logger.error( "new GroupFilterElts" );
    @table_name = table_name
    @group_filter_elts = group_filter_elts
    @user_id = user_id
    UpdatePossibleLength()
  end
  def UpdatePossibleGroups()

    for group_filter_elt in group_filter_elts
      group_filter_elt.UpdatePossibleGroups();
    end
    UpdatePossibleLength()
  end
  def UpdatePossibleLength()
    sql_str ="Group.find_by_sql(\"SELECT MAX(LENGTH(group_name)) AS max_length FROM groups WHERE id != 1 \")"

    @possible_char_length =  eval(sql_str)[0].max_length.to_i;
  end
   

      
end

class FilterController

  def initialize(search_ctls_, class_name_, user_id_)
#    Rails.logger.error( "new FilterController" );
    @search_ctls = search_ctls_;
    @class_name = class_name_;
    @user_id = user_id_;
    @foreign_key_to_class = {};
    reflection_str =  @class_name + ".reflect_on_all_associations(:belongs_to)"
    reflections = eval(reflection_str)
    for reflection in reflections
      @foreign_key_to_class[reflection.name] = reflection.class_name;
    end
  end

  def GetOptions(foreign_key, foreign_class, current_id, order_by_id_, include_group_name_)
    if current_id == nil
      current_id = 0;
    end
    group_members = [];
    group_table = "Group#{foreign_class}"
    search_ctl = @search_ctls[group_table];
    class_search_controller = @search_ctls[foreign_class];
    group_id = FilterController.GroupID(@class_name.tableize, foreign_key, @user_id);
    foreign_id = "#{foreign_class.underscore}_id"
    if search_ctl!=nil
      if include_group_name_
        group_members =   search_ctl.GetSelectFields(current_id, group_id, foreign_id, class_search_controller, order_by_id_)
      else
        group_members << GroupMember.new(SearchController::NOT_SET_STR, SearchController::NOT_SET)
        if current_id != SearchController::NOT_SET
          present_str =  "#{group_table}.find_by_sql(\"SELECT id, #{foreign_class.underscore}_id FROM group_#{foreign_class.tableize} WHERE group_id = #{group_id} AND #{foreign_id} = #{current_id}\")";
          present = eval(present_str);
          if(present.length == 0)
            group_members << GroupMember.new(class_search_controller.GetShortField(current_id), current_id);
          end
        end
        id_str = "#{group_table}.find_by_sql(\"SELECT id, #{foreign_class.underscore}_id FROM group_#{foreign_class.tableize} WHERE group_id = #{group_id}\")";
        group_member_objs = eval(id_str);
        if group_member_objs.length >0
          id_list = "";
          group_member_objs.each do |group_member_obj|
            if id_list.length >0
              id_list << ", "
            end
            id_list <<  group_member_obj.id.to_s

          end
          id_list = "(#{id_list})"
          where_str = "a0.id IN #{id_list}"
          group_members =  group_members +  class_search_controller.GetAllShortFieldsWhere(order_by_id_, 'asc', false, "", where_str);
        else
          group_members =  group_members +  class_search_controller.GetAllShortFieldsWhere(order_by_id_, 'asc', false, "", "");
        end
      end
    else
      group_members << GroupMember.new( SearchController::NOT_SET_STR, SearchController::NOT_SET);
      group_members =  group_members +  class_search_controller.GetAllShortFieldsWhere(order_by_id_, "asc", false,  "", "");
    end
   
    return group_members;
  end

  def self.GroupID(table_name, foreign_key, user_id)
    
    sql_str = "GroupFilter.find_by_sql(\"SELECT id, group_id FROM group_filters WHERE (user_id = #{user_id}  AND table_name = '#{table_name}' AND foreign_key = '#{foreign_key}') \")"
 #   Rails.logger.error( "DEBUG: before eval(#{sql_str})" );
    results = eval(sql_str);
    if(results.length == 0)
      sql_str = "GroupFilter.find_by_sql(\"SELECT id, group_id FROM group_filters WHERE (user_id = 0 AND table_name = '#{table_name}' AND foreign_key = '#{foreign_key}') \")"
#      Rails.logger.error( "DEBUG: before eval(#{sql_str})" );
      results = eval(sql_str);
    end
    if(results.length == 0)
      group_id =0;
    else
      group_id = results[0].group_id;
    end
      
    return group_id
  end

  def self.GetGroupFilters(table_name, user_id)
#    Rails.logger.error("DEBUG: GetGroupFilters");
    group_filter_elts = [];
    eval_str = table_name.classify + ".reflect_on_all_associations(:belongs_to)";
    begin
      reflections = eval(eval_str);
    rescue Exception => exc
      reflections = []
    end
    for reflection in reflections
      group_id = GroupID(table_name, reflection.name, user_id)
      group_filter_elts << GroupFilterElt.new(reflection.name, group_id, reflection.class_name);
    end
    if group_filter_elts.length >0
      group_filters = GroupFilterElts.new(table_name, user_id, group_filter_elts);
    else
      group_filters = nil
    end
    
    return group_filters;
  end

  def self.GetAllGroupFilters(user_id)
    all_tables = ActiveRecord::Base.connection.tables;
    ret_val = [];

    for t in all_tables
      group_filters = FilterController.GetGroupFilters(t, user_id)
      
      if group_filters !=nil
        ret_val << group_filters;
      end

    end
    return ret_val;
  end 
  
end