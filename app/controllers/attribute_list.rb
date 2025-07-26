class AttributeElement
  attr_reader :foreign_key
  attr_reader :data_type
  attr_reader :name
  attr_reader :primary
  attr_reader :table_name
  attr_reader :foreign_class

  def initialize(name_, data_type_, table_name_, foreign_key_, foreign_class_, primary_)
 #   Rails.logger.error( "new AttributeElement" );
    @name = name_
    @data_type = data_type_
    @table_name = table_name_
    @foreign_key= foreign_key_
    @foreign_class = foreign_class_
    @primary = primary_
  end
end
class ReflectionElement
  attr_reader :name
  attr_reader :foreign_key
  def initialize(name_, foreign_key_)
 #   Rails.logger.error( "new ReflectionElement" );
    @name = name_
    @foreign_key =foreign_key_
  end
end
class AttributeList
  attr_reader :attribute_elements 
  attr_reader :reflections
  attr_reader :attribute_hash

  def initialize(table_name_)
#    Rails.logger.error( "new AttributeList" );
    string_to_evaluate = "#{table_name_}.reflect_on_all_associations(:belongs_to)"
    reflections = eval(string_to_evaluate);
    reflection_keys = [];
    @reflection_names = [];
    @reflections = {};
    @attribute_elements  = [];
    @attribute_hash = {}
    for reflection in reflections
       class_name = reflection.class_name;
       foreign_key = reflection.options[:foreign_key];
       @reflections[foreign_key] =  class_name.to_str
       reflection_keys << reflection.options[:foreign_key];
    end
    attribute_eval_str = "#{table_name_}.columns"
    attributes = eval(attribute_eval_str)
    for attribute in attributes
       ind = reflection_keys.index(attribute.name)
       if(ind == nil)
           attribute_element = AttributeElement.new(attribute.name, attribute.type, table_name_, "","", eval("#{table_name_}.primary_key==attribute.name"));
       else
           attribute_element = AttributeElement.new(attribute.name, attribute.type, table_name_, reflections[ind].name.to_s,  reflections[ind].class_name,eval("#{table_name_}.primary_key==attribute.name"));
       end
       @attribute_elements << attribute_element
       @attribute_hash[attribute.name] = attribute_element;
    end
  end
end
