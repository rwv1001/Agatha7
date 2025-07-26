class EditObject
  attr_reader :current_object;
    attr_reader :attribute_list
    attr_reader :filter_controller
    attr_reader :table_name
    attr_reader :readonly_fields
     def initialize(current_object, attribute_list, filter_controller, table_name, readonly_fields)
  #     Rails.logger.error( "new EditObject" );
       @current_object = current_object
       @attribute_list = attribute_list
       @filter_controller = filter_controller
       @table_name = table_name
       @readonly_fields = readonly_fields
     end
end
