class DisplayDiv
  attr_reader :div_id
  attr_reader :insert_id
  attr_reader :visible_ids
  attr_reader :invisible_ids
  attr_accessor :visible_classes
  attr_accessor :invisible_classes
  attr_reader :post_javascript
  def initialize(div_id_, insert_id_, visible_ids_, invisible_ids_, visible_classes_, invisible_classes_, post_javascript_)
#    Rails.logger.error( "new DisplayDiv" );
    @div_id = div_id_;
    @insert_id = insert_id_;
    @visible_ids = visible_ids_;
    @invisible_ids = invisible_ids_;
    @visible_classes = visible_classes_;
    @invisible_classes = invisible_classes_;
    @post_javascript = post_javascript_;
  end
end

