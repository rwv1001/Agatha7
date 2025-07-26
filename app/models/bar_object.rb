class BarObject
  attr_reader :bar_edit_message;
    attr_reader :bar_table_name
    attr_reader :bar_class_name
    attr_reader :bar_id
     def initialize(bar_edit_message, bar_table_name, bar_class_name, bar_id)
  #     Rails.logger.error( "new EditObject" );
       @bar_edit_message = bar_edit_message
       @bar_table_name = bar_table_name
       @bar_class_name = bar_class_name
       @bar_id = bar_id
     end
end
