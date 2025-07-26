class ExtendedFilter
 
  attr_reader :filter_type; # :attribute, :subquery, :external_filter
  attr_reader :filter_object;
  def initialize(filter_type_, filter_object_)
#    Rails.logger.error( "new ExtendedFilter" );
    @filter_type = filter_type_;
    @filter_object = filter_object_;
  end

end
