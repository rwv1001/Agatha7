class FormatController 
  attr_reader :format_elements_hash
  attr_reader :table_objects
  def initialize(user_id_)


    Rails.logger.debug( "new FormatController" );
    setTableObjects();
    @format_elements_hash = {}
    @user_id = user_id_;
    Update();
  end
  def Update()
    for t in @table_objects
      @format_elements_hash[t.object] = FormatController.FormatElements(t.table, @user_id);
    end
  end

  def self.FormatElements(table, user_id)
      sql_str = "FormatElement.find_by_sql(\"SELECT field_name, insert_string, element_order FROM format_elements WHERE (user_id = " + user_id.to_s +  " AND table_name = '" + table + "' AND in_use = true) ORDER BY element_order asc\")"
  #    Rails.logger.error( "DEBUG: before eval(#{sql_str})" );
      results = eval(sql_str);
      if(results.length == 0)
        sql_str = "FormatElement.find_by_sql(\"SELECT field_name, insert_string, element_order FROM format_elements WHERE (user_id = 0 AND table_name = '" + table + "' AND in_use = true) ORDER BY element_order asc\")"
 #       Rails.logger.error( "DEBUG: before eval(#{sql_str})" );
        results = eval(sql_str);
      end
      format_elements_array = Array.new();
      if(results.length == 0)
        format_elements_array  << FormatElt.new("id","");

      else
        for r in results
          format_elements_array <<  FormatElt.new(r.field_name, r.insert_string);
        end
      end
      format_elts = FormatElts.new(table, user_id, format_elements_array );
      return format_elts;
  end


  def setTableObjects()
    all_tables = ActiveRecord::Base.connection.tables;
    @table_objects = [];

    for t in all_tables
      object_name = t.classify()
      eval_str = object_name + ".reflect_on_all_associations(:has_many).length"
      begin
        if eval(eval_str)>0
          @table_objects << TableObject.new(t,object_name);
        end
      rescue Exception => exc
      end
    end

  end
end


class FormatElt
  attr_reader :field_name
  attr_reader :insert_string
  def initialize(field_name_, insert_string_)
 #   Rails.logger.error( "new FormatElt" );
    @field_name = field_name_
    @insert_string = insert_string_
  end
end

class FormatElts
  attr_reader :table
  attr_reader :attribute_list
  attr_reader :user_id
  attr_reader :format_elements_array
  def initialize(table, user_id, format_elements_array)
#    Rails.logger.error( "new FormatElts" );
    @table = table
    @user_id = user_id
    @format_elements_array = format_elements_array
    attribute_eval_str = "AttributeList.new(#{table.classify})"
#    unless session_[attribute_eval_str]
      @attribute_list = AttributeList.new(table.classify);
  #    session_[attribute_eval_str] = @attribute_list;
 #   else
 #     @attribute_list = session_[attribute_eval_str];
 #   end

   # @attribute_list = AttributeList.new(table.classify);
  end
end

class TableObject
  attr_reader :table
  attr_reader :object
  def initialize(table_, object_)
#    Rails.logger.error( "new TableObject" );
    @table = table_;
    @object = object_;
  end
end

