class EditCell
  attr_reader :current_object;
    attr_reader :attribute
    attr_reader :filter_controller
    attr_reader :table_name
    attr_reader :update_parent;
    attr_reader :readonly_flag;
     def initialize(attribute, current_object, table_name, filter_controller,update_parent, readonly_flag );
 #      Rails.logger.error( "new EditCell" );
       @current_object = current_object
       @attribute = attribute
       @filter_controller = filter_controller
       @table_name = table_name
       @update_parent =update_parent
       @readonly_flag = readonly_flag
     end
end