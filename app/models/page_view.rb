class PageView
  @@option_ids = {}
  attr_reader :body_id
  attr_reader :page_name
  attr_reader :option_id
  attr_reader :page_option_str
  attr_reader :unrestricted
  attr_accessor :display_divs
  def initialize(body_id_, page_name_, page_option_str_, unrestricted_, display_divs_)
#    Rails.logger.error( "new PageView" );
    if(!@@option_ids.has_key?(page_name_))
      @@option_ids[page_name_]= 0;
    end
    @body_id = body_id_
    @page_name = page_name_
    @option_id = @@option_ids[page_name_]
    @page_option_str = page_option_str_
    @unrestricted = unrestricted_
    @display_divs = display_divs_
    @@option_ids[page_name_] = @@option_ids[page_name_]+1;
  end


end