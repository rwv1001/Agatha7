class DisplayPagesClass
  attr_accessor :DisplayPages
  def initialize()
#    Rails.logger.error( "new DisplayPagesClass" );
    @DisplayPages = {}
  end
  def RegisterClasses(page_name_, div_ids_, visible_classes_, invisible_classes_)

    @DisplayPages[page_name_].each do | display_page|
      display_page.display_divs.each do |display_div|
        div_ids_.each do |div_id|
          if display_div.div_id == div_id
            visible_classes_.each do |visible_class|
              if display_div.invisible_classes.index(visible_class) == nil #do not override what is already set specifically
                display_div.visible_classes << visible_class;
              end
            end
            invisible_classes_.each do |invisible_class|
              if display_div.visible_classes.index(invisible_class) == nil
                display_div.invisible_classes << invisible_class;
              end
            end
          end
        end
      end
    end
  end
end