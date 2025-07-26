class SubQuery
  attr_reader :header
  attr_reader :variable_name
  attr_reader :eval_str
  attr_reader :select_string;
  attr_reader :argument_class;
  attr_reader :tag;
  attr_accessor :current_argument_value;
  attr_accessor :selection_controller;

  def initialize(dependences_, header_, variable_name_, select_string_, argument_class_)
#    Rails.logger.error( "new SubQuery" );
    @dependences_ = dependences_;
    @header = header_;
    @variable_name = variable_name_;
    @select_string = select_string_;
    
    @argument_class = argument_class_;
    if(@argument_class.length>0)
      begin
       @current_argument_value =  eval("#{@argument_class}.last.id").to_i;
      rescue Exception => exc
      @current_argument_value = 0;
      end

    else
      @current_argument_value = 0;
    end
    @eval_str = "row.#{@variable_name}";
    @tag = header_.gsub(/[^A-z0-9]/,'_');
  end

end
