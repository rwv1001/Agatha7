class ForeignFilter
  attr_reader :foreign_key
  attr_reader :attribute_name


  def initialize(foreign_key_, attribute_name_)
  #  Rails.logger.error( "new ForeignFilter" );
    @foreign_key = foreign_key_;
    @attribute_name = attribute_name_;   
  end

end