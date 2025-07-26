class ExternalFilterElement
  attr_accessor :group_id
  attr_accessor :member_id
  attr_reader :external_filter
  attr_reader :element_id
  def initialize(element_id_, external_filter_)
 #   Rails.logger.error( "new ExternalFilterElement" );
    @element_id = element_id_;
    @external_filter = external_filter_;
  end

  def MemberSelection()
    return @external_filter.MemberSelection(@group_id, @member_id)
  end
end

class ExternalFilter
  attr_reader :header
  attr_reader :class_name
  attr_reader :group_selector
  attr_accessor :id

  attr_reader :where_str
  attr_reader :argument_class;
  attr_reader :group_class;
  attr_reader :tag
  attr_accessor :current_arguments;
  attr_reader :argument_selector_str;
  attr_reader :group_selector_str
  attr_accessor :selection_controller;
  attr_accessor :class_search_controller
  attr_accessor :allow_multiple_arguments

  def set_user_id(user_id_, administrator_)
    @user_id = user_id_
     @group_selector_str = @group_selector_str.gsub(/user_id_/,user_id_.to_s);
     @group_selector_str = @group_selector_str.gsub(/administrator_/,administrator_.to_s);
     @argument_selector_str = @argument_selector_str.gsub(/user_id_/,user_id_.to_s);
     @argument_selector_str = @argument_selector_str.gsub(/administrator_/,administrator_.to_s);
  end
  def initialize(class_name_, header_, where_str_, argument_class_, group_class_, argument_selector_str_, allow_multiple_arguments_, group_selector_)
#    Rails.logger.error( "new ExternalFilter" );
    @class_name = class_name_;
    @header = header_;
    @where_str = where_str_;
    @argument_class = argument_class_;
    @current_arguments = [];
    @argument_selector_str = argument_selector_str_;
    @group_class = group_class_;
    @group_selector = group_selector_;
    if group_selector_
      @group_selector_str = "Group.find_by_sql(\"SELECT a0.id, a0.group_name FROM groups a0 WHERE a0.table_name ='#{@argument_class.tableize}' AND (a0.owner_id = user_id_ OR administrator_ OR ((SELECT COUNT(*) FROM group_users a2 WHERE a2.user_id = user_id_ AND a2.group_id = a0.readers_id) > 0 AND a0.private = FALSE) ) ORDER BY a0.group_name asc\")";
    else
      @group_selector_str = ""
    end
    
    #argument_selector_str_ = Group.find(:all,:conditions => ["group_name = 'people'"]);
    #argument_selector_str_ = @selection_controller.GetSelectFields(member_id, group_id, member_attribute_name, @class_search_controller)
    
    @tag = header_.gsub(/\s+/,'_');
    @allow_multiple_arguments = allow_multiple_arguments_;
  end

  def Update() #reads from DB to populate current_arguments
     
     sql_str = "ExternalFilterValue.find_by_sql(\"SELECT id, member_id, group_id FROM external_filter_values WHERE (user_id = #{@user_id.to_s} AND filter_id = #{@id} AND table_name = '#{class_name.tableize}' AND in_use = true ) ORDER BY id asc\")"
     db_args = eval(sql_str);
     num_db_args = db_args.length;
     if num_db_args < @current_arguments.length
       @current_arguments = @current_arguments[0, num_db_args];
     end

     for arg_count in (0..(num_db_args-1))
       group_id = db_args[arg_count].group_id;
       member_id = db_args[arg_count].member_id;
       if arg_count >= @current_arguments.length
         new_filter_elt = ExternalFilterElement.new(arg_count, self);
         new_filter_elt.group_id = group_id;
         new_filter_elt.member_id = member_id;
         @current_arguments << new_filter_elt
       else
         @current_arguments[arg_count].member_id = member_id;
         @current_arguments[arg_count].group_id = group_id;
       end
     end     
  end

  def GroupSelection()
    ret_val = []
    if group_selector_str.length >0
      group_values = eval(@group_selector_str)
      Rails.logger.info("GroupSelection, @group_selector_str = #{@group_selector_str}");
      for group_value in group_values
        ret_val << GroupMember.new(group_value.group_name, group_value.id);
      end
    end
    return ret_val;
  end
  
  def MemberSelection(group_id, member_id)
    ret_val = [];    
    member_attribute_name = argument_class.underscore + "_id"
    Rails.logger.info("MemberSelection @argument_selector_str = #{@argument_selector_str}");
    return eval(@argument_selector_str);
  end
end
