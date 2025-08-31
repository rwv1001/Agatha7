class SearchResults
  attr_reader :table
  attr_accessor :table_type
  attr_reader :search_controller


  def initialize(table_, table_type_, search_controller_)
#    Rails.logger.error( "new SearchResults" );
    @table = table_
    @table_type = table_type_
    @search_controller = search_controller_

  end
end
class SearchResultsRow
  attr_reader :row
  attr_reader :search_controller
  def initialize(row_, search_controller_)
  #  Rails.logger.error( "new SearchResultsRow" );
    @row = row_
    @search_controller = search_controller_
  end
end

class SearchResultsButtons
  attr_reader :row
 

  attr_reader :table_name

  def initialize(row_)
#    Rails.logger.error( "new SearchResultsButtons" );
    @row = row_
   

    @table_name = @row.class_name;
  end
end
class SearchResultsRowButton
  attr_reader :search_results_row
  attr_reader :search_results_button
  def initialize(search_results_row_)
#    Rails.logger.error( "new SearchResultsRowButton" );
    @search_results_row = search_results_row_;
    @search_results_button =   SearchResultsButtons.new(@search_results_row.row);
  end
end
class  TableSelection
  attr_reader :table_index
  attr_reader :search_controller
  def initialize(search_controller_, table_index_)
  #  Rails.logger.error( "new TableSelection" );
    @search_controller = search_controller_
    @table_index = table_index_
  end
end

class SearchControllerHeader
  attr_reader :table_type
  attr_reader :search_controller
  def initialize(table_type_, search_controller_)
 #   Rails.logger.error( "new SearchControllerHeader" );
    @table_type = table_type_
    @search_controller = search_controller_
  end
end

class SearchFilterHeader
  attr_reader :table_type
  attr_reader :row_type
  attr_reader :extended_filter
  attr_reader :table_name
  attr_reader :num_filters
  def initialize(table_type_, row_type_, extended_filter_, table_name_, num_filters_)
 #   Rails.logger.error( "new SearchFilterHeader" );
    @table_type = table_type_
    @row_type = row_type_
    @extended_filter = extended_filter_
    @table_name= table_name_
    @num_filters = num_filters_
  end

end
class TestClass
  attr_accessor :x
  attr_accessor :y
  def initialize(x_, y_)
    @x = x_
    @y = y_
  end
end

class FieldNode
  attr_accessor :parent
  attr_accessor :all_children
  attr_accessor :current_children
  attr_accessor :name
  attr_accessor :key
  attr_accessor :available_fields_index
  attr_accessor :current_flag
 
  attr_accessor :id

  
  def initialize(parent_, name_, available_fields_index_, key_)
 #   Rails.logger.error( "new FieldNode" );
    @parent = parent_
    @all_children = []
    @current_children = []
    @name = name_
    @key =  key_
    @available_fields_index = available_fields_index_;
    @current_flag = 0;
    @id = @@next_id
    @@next_id = @@next_id + 1;
  end
  def self.Reset()
    @@next_id = 0;
  end
end
# To change this template, choose Tools | Templates
# and open the template in the editor.
class SearchField
  include EditHelper
  attr_reader :name
  attr_accessor :header
  attr_accessor :id
  attr_accessor :full_name
  attr_accessor :qualifier
  attr_accessor :eval_str
  attr_accessor :data_type
  attr_accessor :current_filter_string
  attr_accessor :class_override
  attr_accessor :tag
  attr_accessor :include_index
  attr_accessor :table_name
  attr_accessor :attribute_name
  attr_accessor :field_node
  attr_accessor :foreign_class
  attr_accessor :foreign_search_str
  attr_accessor :primary
  def initialize(field_string, qualifer_string,  eval_string, include_index_val, data_type_symbol, tag_symbol, id_val, table_name_str, attribute_name, field_node, foreign_class, primary)
#    Rails.logger.error( "new SearchField" );
    @header =field_string
    @qualifier =  qualifer_string
    @full_name = "#{qualifer_string}/#{field_string}"
    @tag = tag_symbol
    @eval_str = eval_string
    @include_index = include_index_val
    @data_type = data_type_symbol
    @current_filter_string = "%"
    @class_override = "" #this is so that the select column stands out. - I'm not sure this is necessary.
    @id = id_val
    @table_name = table_name_str
    @attribute_name = attribute_name
    @field_node = field_node
    @foreign_class = foreign_class
    @foreign_search_str = ''
    @primary = primary
    # TestSQLString()
  end
  def TestSQLString()
    @data_type = :integer
    @current_filter_string = ",, ,- 35 ABC aBVdE51 , 3 . 4.. -65 , 7-.. 8 ,9 3 ...9"
    str = GetSQLString2();
    @data_type = :integer
    @current_filter_string = "21, 3, -43"
    str = GetSQLString2();
    @data_type = :integer
    @current_filter_string = "-24..4"
    str = GetSQLString2();
    @data_type = :integer
    @current_filter_string = "%"
    str = GetSQLString2();
    @current_filter_string = ""
    str = GetSQLString2();

    @data_type = :time
    @current_filter_string = ",4:20 , ,3:90 ABC 85 , 3:40 . 4:20.. 6 2 4, 7.. 8:40 ,9 82:90 3 : 52 ...9"
    str = GetSQLString2();
    @data_type = :time
    @current_filter_string = "4:20 , 5, 3:30"
    str = GetSQLString2();
    @data_type = :time
    @current_filter_string = "4:20..19:30"
    str = GetSQLString2();

    @data_type = :timestamp
    @current_filter_string = ",4-12-20 , ,1973-11 ABC 85 , 3 -02- 240 . 09-8-20.. 16-7 - 3 2-3 4-5, 1997-8.. 98-01-7 40-7-7 ,9-8-1 82-90-60 3 : 52 ...9"
    str = GetSQLString2();
    @data_type = :timestamp
    @current_filter_string = "4-12-20 , 2005, 3-2"
    str = GetSQLString2();
    @data_type = :timestamp
    @current_filter_string = " 4-12-20.. 2005-11-19"
    str = GetSQLString2();

    @data_type = :boolean
    @current_filter_string = 0;
    str = GetSQLString2();
    @date_type = :boolean
    @current_filter_string = 1;
    str = GetSQLString2();

    @data_type = :string
    @current_filter_string = "%a-6% danx"
    str = GetSQLString2();

  end

  


  def AddMinutes(time_str)
    hours = time_str.match(/(?:^(?:\d+))/)

    if hours
      hours = hours[0]
    else
      hours = "0"
    end
    # hours = hours[0]
    if time_str =~ /:/
      mins = time_str.match(/(?:\d+$)/)
      #mins = mins[0]
      if mins
        mins = mins[0]
      else
        mins = "00"
      end
    else
      mins = "00"
    end

    if hours.to_i > 23
      hours = "00"
    end
    if mins.to_i >59
      mins = "00"
    end

    ret_val = "#{hours}:#{mins}"

    return ret_val
  end
  def CompleteDate(date_str)

    scan_array = date_str.scan(/(?:\d+)/)
    if scan_array
      scan_length = scan_array.length
    else
      scan_length = 0
    end
    year = nil

    if scan_length>0
      year = scan_array[0]
    end
    if year == nil      
      year = "2009"
    end

 

    if year.length <4
      year_val = year.to_i
      year_val = year_val - ((year_val -1) /50).floor * 100
      year_val = year_val +2000
      year = year_val.to_s
    end

    if scan_length >1
      month = scan_array[1]
    else
      month = "01"
    end
    if month.to_i > 12
      month = "12"
    end
    if month.length == 1
      month = "0"+month;
    end
    if scan_length >2
      day = scan_array[2]
      month_days_val = Time.days_in_month(month.to_i, year_val)
      day_val = day.to_i
      if day_val > month_days_val
        dav_val =  month_days_val
        day = dav_val.to_s
      end
    else
      day = "01"
    end

    if day.length ==1
      day = "0"+day;
    end

    ret_val = "#{year}-#{month}-#{day}"
  end
  def ParseIntegerStr2()
    ret_val = ""
    the_orig_str = @current_filter_string

    trimmed_str = @current_filter_string.gsub(/([A-Z]|[a-z])/,' ')
    trimmed_str = trimmed_str.gsub(/-\s+/,'-')
    trimmed_str =trimmed_str.gsub(/(?:^\s+)|(?:\s+$)/,'')

    trimmed_str = trimmed_str.gsub(/\d\s+(\d|-)/){|s| s=s.gsub(/\s+/,',')  }
    trimmed_str = trimmed_str.gsub(/\s+/,'')



    trimmed_str = trimmed_str.gsub(/\.{2,}/,'..')
    trimmed_str = trimmed_str.gsub(/\,+/,',')
    trimmed_str = trimmed_str.gsub(/-+/,'-')
    trimmed_str =trimmed_str.gsub(/(?:^,+)|(?:,+$)|(?:^\.+)|(?:\.+$)/,'')
    trimmed_str =trimmed_str.gsub(/\d\.-*\d/){|s| s = s.gsub(/\./, ',')}
    scanner = StringScanner.new(trimmed_str );
    matched_or_str = [];
    # scan_match =  scanner.scan(/\.^-*[0-9]+,/)
    # while scan_match !=nil do
    #  matched_or_str << scan_match;
    #   scan_match = scanner.scan(/\.^-*[0-9]+,/)
    # end

    # matched_or_str = trimmed_str.scan(/\.^-*[0-9]+,/);
    #  matched_or_str = trimmed_str.scan(/[^\.]-*[0-9]+,/);
    #  matched_or_str << trimmed_str.match(/,-*[0-9]+/);

    matched_ranges =  trimmed_str.scan(/-*[0-9]+\.{2}-*[0-9]+/);
    for range in matched_ranges
      reg_exp = Regexp.new(range);
      trimmed_str = trimmed_str.gsub(reg_exp, '')
    end

    matched_or_str = trimmed_str.scan(/-*[0-9]+/);


    num_matched_ors = matched_or_str.length
    if matched_or_str.length >0
      ret_val = "("

      for or_str in matched_or_str[0, num_matched_ors-1]
        or_str = or_str.gsub(/,/,'')
        ret_val = ret_val + "a#{@field_node.parent.id}.#{@attribute_name} = #{or_str} OR "
      end
      final_or = matched_or_str[num_matched_ors-1]
      final_or = final_or.gsub(/,/,'')
      ret_val = ret_val + "a#{@field_node.parent.id}.#{@attribute_name} = #{final_or})"
    end
    num_matched_ranges = matched_ranges.length
    if num_matched_ranges >0
      if num_matched_ors > 0
        ret_val = ret_val + " OR "
      end

      for matched_range in matched_ranges[0,num_matched_ranges -1]
        int_a = matched_range.match(/^-*\d+/);
        int_b = matched_range.match(/-*\d+$/);
        ret_val = ret_val + "( a#{@field_node.parent.id}.#{@attribute_name} BETWEEN #{int_a} AND #{int_b}) OR "
      end
      final_range = matched_ranges[num_matched_ranges -1];
      int_a = final_range.match(/^-*\d+/);
      int_b = final_range.match(/-*\d+$/);
      ret_val = ret_val + "( a#{@field_node.parent.id}.#{@attribute_name} BETWEEN #{int_a} AND #{int_b})"
    end
    return ret_val;
  end

  def ParseTextStr2()
    ret_val= ""

    @current_filter_string = @current_filter_string .gsub(/<%/){|s| 'naughty'};
    @current_filter_string = @current_filter_string .gsub(/%>/){|s| 'naughty'};
    safe_string = @current_filter_string.gsub(/\\*\"+/){|s| '\\"'};
    safe_string = safe_string.gsub(/\n/){|s| '\\n'}
    safe_string = safe_string.gsub(/\r/){|s| '\\r'}
    safe_string = safe_string.gsub(/\v/){|s| '\\v'}
    safe_string = safe_string.gsub(/\f/){|s| '\\f'}
    safe_string = safe_string.gsub(/\s+$/){|s| ''}


    safe_string = safe_string.gsub(/\'+/){|s| '\'\''}

    possible_percent_str =   safe_string.gsub(/\s+/,'')
    if safe_string.length == 0 || possible_percent_str == '%'
      ret_val = ""
    elsif @foreign_class.length == 0
      ret_val = "LOWER(a#{@field_node.parent.id}.#{@attribute_name}) SIMILAR TO LOWER(\'#{ safe_string}\')"
    elsif @foreign_search_str.length>0
      ret_val = "LOWER(" +  @foreign_search_str + ") SIMILAR TO LOWER(\'#{ safe_string}\')"
    end
    
    return ret_val
  end

  def ParseBooleanStr2()
    case @current_filter_string
    when 1, "T", "t", "true", "TRUE", "True"
      ret_val = "a#{@field_node.parent.id}.#{@attribute_name} IS TRUE"
    when 0, "F", "f", "false", "FALSE", "False"
      ret_val = "a#{@field_node.parent.id}.#{@attribute_name} IS FALSE"
    else
      ret_val = ""
    end
    return ret_val
  end

  def ParseTimeStr2()
    orig_str =@current_filter_string
    trimmed_str = @current_filter_string.gsub(/([A-Z]|[a-z])/,' ')
    trimmed_str =trimmed_str.gsub(/(?:^\s*)|(?:\s*$)/,'')
    trimmed_str = trimmed_str.gsub(/\d\s+\d/){|s| s=s.gsub(/\s+/,',')  }
    trimmed_str = trimmed_str.gsub(/\d\s+\d/){|s| s=s.gsub(/\s+/,',')  }
    trimmed_str = trimmed_str.gsub(/\s+/,'')
    #trimmed_str = trimmed_str.gsub(/(\s+:\s*)|(\s*:\s+)/,':')
    trimmed_str = trimmed_str.gsub(/\.{2,}/,'..')
    trimmed_str = trimmed_str.gsub(/\,+/,',')
    trimmed_str = trimmed_str.gsub(/:+/,':')
    trimmed_str =trimmed_str.gsub(/(?:^,*)|(?:,*$)|(?:^:*)|(?::*$)/,'')
    matched_ranges = []
    # matched_ranges = trimmed_str.scan(/(?:(?:[0-1][0-9])|(2[0-3]))|(?:(?:(?:[0-1][0-9])|(?:2[0-3])):[0-5][0-9]).{2}(?:(?:[0-1][0-9])|(2[0-3]))|(?:(?:(?:[0-1][0-9])|(?:2[0-3])):[0-5][0-9])/);

    # matched_range = trimmed_str.scan(/(?:(?:[0-9]+)|(?:[0-9]+:[0-9]+))\.{2}(?:(?:[0-9]+)|(?:[0-9]+:[0-9]+))/);
    matched_ranges = trimmed_str.scan(/(?:(?:(?:\d+:\d+)|(?:\d+))\.{2}(?:(?:\d+:\d+)|(?:\d+)))/);
    for matched_range in matched_ranges
      reg_exp = Regexp.new(matched_range);
      trimmed_str = trimmed_str.gsub(reg_exp, '')
    end
    # while matched_range do
    #   x = matched_range
    #   matched_ranges << matched_range
    #   reg_exp = Regexp.new(matched_range);
    #   trimmed_str = trimmed_str.gsub(reg_exp, '')
    # matched_range = trimmed_str.match(/(?:(?:\d+:\d+)|(?:\d+))\.{2}(?:(?:\d+:\d+)|(?:\d+))/);
    # end

    matched_or_strs  = trimmed_str.scan(/(?:\d+:\d+)|(?:\d+)/);

    #  matched_or_str = trimmed_str.match(/(?:\d+:\d+)|(?:\d+)/);
    #matched_or_strs_scan = trimmed_str.scan(/(?:\d+:\d+)|(?:\d+)/);
    #matched_or_strs = []
    #for matched_scan in matched_or_strs_scan
    #  if matched_scan[0]
    #     matched_or_strs << matched_scan[0]
    #  else
    #    matched_or_strs << matched_scan[1]
    #  end

    # end



    ret_val  = ""
    num_matched_ors = matched_or_strs.length
    if matched_or_strs.length >0
      ret_val = "("

      for or_str in matched_or_strs[0, num_matched_ors-1]
        or_str = AddMinutes(or_str)
        ret_val = ret_val + "a#{@field_node.parent.id}.#{@attribute_name} = #{or_str} OR "
      end
      final_or = matched_or_strs[num_matched_ors-1]
      final_or =  AddMinutes(final_or)
      ret_val = ret_val + "a#{@field_node.parent.id}.#{@attribute_name} = #{final_or})"
    end
    num_matched_ranges = matched_ranges.length
    if num_matched_ranges >0
      if num_matched_ors > 0
        ret_val = ret_val + " OR "
      end
      for matched_range in matched_ranges[0,num_matched_ranges -1]
        time_a = matched_range.match(/^(?:(?:\d+:\d+)|(?:\d+))/);
        if  time_a[0]
          time_a = time_a[0]
        else
          time_a = ""
        end
        #   time_a = time_a[1]
        # # end
        time_b = matched_range.match(/(?:(?:\d+:\d+)|(?:\d+))$/);
        if  time_b[0]
          time_b = time_b[0]
        else
          time_b = ""
        end
        #     time_b = time_b[1]
        #   end
        time_a = AddMinutes(time_a)

        time_b = AddMinutes(time_b)
        ret_val = ret_val + "( a#{@field_node.parent.id}.#{@attribute_name} BETWEEN #{time_a} AND #{time_b}) OR "
      end
      final_range = matched_ranges[num_matched_ranges -1];
      time_a = final_range.match(/(?:^(?:(?:\d+:\d+)|(?:\d+)))/);
      if  time_a[0]
        time_a = time_a[0]
      else
        time_a = ""
      end
      #  time_a = time_a[1]
      # end
      time_b =final_range.match(/(?:(?:(?:\d+:\d+)|(?:\d+))$)/);
      if  time_b[0]
        time_b = time_b[0]
      else
        time_b =""
      end
      time_a = AddMinutes(time_a)

      time_b = AddMinutes(time_b)
      ret_val = ret_val + "( a#{@field_node.parent.id}.#{@attribute_name} BETWEEN #{time_a} AND #{time_b})"
    end
    return ret_val;
  end


  def ParseTimeStampStr2()
    the_current_str  = @current_filter_string
    trimmed_str = @current_filter_string.gsub(/([A-Z]|[a-z])/,' ')
    trimmed_str =trimmed_str.gsub(/(?:^\s*)|(?:\s*$)/,'')
    trimmed_str = trimmed_str.gsub(/\d\s+\d/){|s| s=s.gsub(/\s+/,',')  }
    trimmed_str = trimmed_str.gsub(/\s/,'')
    # trimmed_str = trimmed_str.gsub(/\s*-\s*/,'-')

    #trimmed_str = trimmed_str.gsub(/(?:\s*\.)|(?:\.\s*)/,'.')
    trimmed_str = trimmed_str.gsub(/\.{2,}/,'..')
    trimmed_str = trimmed_str.gsub(/\,+/,',')
    trimmed_str = trimmed_str.gsub(/-+/,'-')
    trimmed_str =trimmed_str.gsub(/(?:^,*)|(?:,*$)|(?:^\.*)|(?:\.*$)/,'')
    # matched_ranges1 = trimmed_str.match(/(?:(?:\d+-\d+-\d+)|(?:\d+-\d+)|(\d+))\.{2}(?:(?:\d+-\d+-\d+)|(?:\d+-\d+)|(?:\d+))/ )
    matched_ranges = trimmed_str.scan(/(?:(?:(?:\d+-\d+-\d+)|(?:\d+-\d+)|(?:\d+))\.{2}(?:(?:\d+-\d+-\d+)|(?:\d+-\d+)|(?:\d+)))/ )
    # matched_range = trimmed_str.match(/(?:(?:\d+-\d+-\d+)|(?:\d+-\d+)|(?:\d+))\.{2}(?:(?:\d+-\d+-\d+)|(?:\d+-\d+)|(?:\d+))/ )
    # matched_ranges = []
    for matched_range in matched_ranges


      reg_exp = Regexp.new(matched_range);
      trimmed_str = trimmed_str.gsub(reg_exp, '')
    end

    matched_or_str = trimmed_str.scan(/(?:(?:\d+-\d+-\d+)|(?:\d+-\d+)|(?:\d+))/);
    #  matched_or_str << trimmed_str.match(/,(?:(?:\d{2})|(?:\d{4}))|(?:(?:(?:\d{2})|(?:\d{4}))-(?:(?:0{0,1}[1-9])|(?:1[1-2])))|(?:(?:(?:\d{2})|(?:\d{4}))-(?:(?:0{0,1}[1-9])|(?:1[1-2]))-(?:(?:0{0,1}[1-9])|(?:[1-3][0-9])))/);
    #   matched_ranges << trimmed_str.scan(/(?:(?:\d{2})|(?:\d{4}))|(?:(?:(?:\d{2})|(?:\d{4}))-(?:(?:0{0,1}[1-9])|(?:1[1-2])))|(?:(?:(?:\d{2})|(?:\d{4}))-(?:(?:0{0,1}[1-9])|(?:1[1-2]))-(?:(?:0{0,1}[1-9])|(?:[1-3][0-9]))).{2}(?:(?:\d{2})|(?:\d{4}))|(?:(?:(?:\d{2})|(?:\d{4}))-(?:(?:0{0,1}[1-9])|(?:1[1-2])))|(?:(?:(?:\d{2})|(?:\d{4}))-(?:(?:0{0,1}[1-9])|(?:1[1-2]))-(?:(?:0{0,1}[1-9])|(?:[1-3][0-9])))/);
    ret_val  = ""
    num_matched_ors = matched_or_str.length
    if matched_or_str.length >0
      ret_val = "("

      for or_str in matched_or_str[0, num_matched_ors-1]
        date_str = CompleteDate(or_str)
        ret_val = ret_val + "a#{@field_node.parent.id}.#{@attribute_name} = #{date_str} OR "
      end
      date_str = CompleteDate(matched_or_str[num_matched_ors-1])
      ret_val = ret_val + "a#{@field_node.parent.id}.#{@attribute_name} = #{date_str})"
    end
    num_matched_ranges = matched_ranges.length
    if num_matched_ranges >0
      if num_matched_ors > 0
        ret_val = ret_val + " OR "
      end
      for matched_range in matched_ranges[0,num_matched_ranges -1]
        date_a = matched_range.match(/^(?:(?:\d+-\d+-\d+)|(?:\d+-\d+)|(?:\d+))/);
        if date_a
          date_a = date_a[0]
        else
          date_a = ""
        end
        date_b = matched_range.match(/(?:(?:\d+-\d+-\d+)|(?:\d+-\d+)|(?:\d+))$/);
        if date_b
          date_b = date_b[0]
        else
          date_b = ""
        end
        date_a = CompleteDate(date_a)
        date_b= CompleteDate(date_b)

        ret_val = ret_val + "( a#{@field_node.parent.id}.#{@attribute_name} BETWEEN #{date_a} AND #{date_b}) OR "
      end
      final_range = matched_ranges[num_matched_ranges -1];
      date_a = final_range.match(/^(?:(?:\d+-\d+-\d+)|(?:\d+-\d+)|(?:\d+))/);
      if date_a
        date_a = date_a[0]
      else
        date_a = ""
      end
      date_b = final_range.match(/(?:(?:\d+-\d+-\d+)|(?:\d+-\d+)|(?:\d+))$/);
      if date_b
        date_b = date_b[0]
      else
        date_b = ""
      end
      date_a = CompleteDate(date_a)
      date_b= CompleteDate(date_b)

      ret_val = ret_val + "( a#{@field_node.parent.id}.#{@attribute_name} BETWEEN #{date_a} AND #{date_b})"
    end

    return ret_val;
  end

  def GetSQLString2
    case @data_type
    when :integer
      ret_val = ParseIntegerStr2()
    when :time
      ret_val = ParseTimeStr2()

    when :timestamp
      ret_val = ParseTimeStampStr2()
    when :boolean
      ret_val = ParseBooleanStr2()
    when :string, :text
      ret_val = ParseTextStr2()
    else
      ret_val = ""
    end
    return  ret_val
  end
    
end

class SearchController 
  NOT_SET = 1;
  NOT_SET_STR = "Not Set";
  attr_reader :table_name
  attr_reader :tables_name
  attr_accessor :current_filter_indices # these refer to indices in @available_fields on which searches are curretnly done
  attr_reader :available_fields #these are all the availabe fields extracted from the table and its :belongs_to associations
  attr_reader :possible_filter_names
  attr_accessor :possible_filter_indices
  attr_reader :current_filter_names
  attr_reader :current_filters
  attr_reader :extended_filters
  attr_reader :external_filters;
  attr_accessor :user_id;
  attr_reader :filter_controller;
  attr_accessor :row_ids;
  attr_accessor :exam_ids;
  attr_accessor :compulsory_ids;
  
  attr_reader :search_ctls
  
  
  attr_reader :fixed_indices


  def initialize(table_name, user_id_, administrator_, session) #eg GroupPerson

    @user_id = user_id_
    @administrator = administrator_
    @active = false;
    @compulsory_indices = [];
    @row_ids = [];
    @exam_ids = [];
    @compulsory_ids = [];
    

    @order_updated = false;
    @table_name = table_name
    @current_filter_indices = []
    @current_filter_names = []
    @possible_filter_names =[]
    @limit_offset = 0;
    @limit_length = 250;
    @fixed_indices = [];

    @current_attribute_flag = 0;
    @foreign_key_tree_hash = {};
    @user_where_str="";

    # @fields = [SearchField.new("First Name", "Person", "row.person.first_name", "people.first_name", 0, 0),
    #  SearchField.new("Second Name", "Person", "row.person.second_name", "people.second_name",0, 0)];
    #@table = GroupPerson.find(:all, :conditions => "people.second_name like '%Verr%'" , :include => :person);

    #@table_index = 1;
    

    # @@search_include = [:person, :attendee];
    # group_person2 = GroupPerson.find(:all, :conditions => "people.second_name like '%Verr%'" , :include => @@search_include[0] );

    @available_fields = [];
    @hash_to_index = {};
    @max_level = 4;
    @level =0;
    process_reflections = true
    qualifier_str = ""
    qualifiers_str = ""
    
    current_table = @table_name;
    # @tables_name = @table_name.pluralize.downcase;
    @tables_name = QualifiersStr(@table_name)
    @search_include_strings = [""];
    @data_type_strings = [];
    @new_index_val = 0;
    

    qualifier = eval("HeaderStr(#{current_table}.name)")
    include_str = ""
    FieldNode.Reset();
    @field_tree = FieldNode.new(nil, current_table, -1, current_table);
    ProcessTable(qualifier, qualifier_str, qualifiers_str, current_table, include_str, @field_tree ) #sets @available_fields

    @extended_filters = [];
    @external_filters = [];
    @foreign_filters = [];
    for field in @available_fields
      if(field.field_node.parent.id == 0)
        @extended_filters << ExtendedFilter.new(:attribute,  field);
      else
        @foreign_filters << ExtendedFilter.new(:attribute,  field);
      end
    end
    extended_filters = session[:extended_filters];
    table_filters = extended_filters[table_name];
   # table_filters_str = "#{table_name}::ExtendedFilters"
   # table_filters =  eval(table_filters_str);
    for filter in table_filters     
      filter_object = filter.filter_object;
     # Rails.logger.info("search initialize RWV, filter_object.class = #{filter_object.class}, filter_object.tag = #{filter_object.tag}");
      if filter_object.class == SubQuery
        @hash_to_index[filter_object.tag] = @extended_filters.length
        @extended_filters << filter;
      elsif filter_object.class == ForeignFilter
        foreign_filter = FindForeignFilter(filter_object);
        if foreign_filter !=nil
         @hash_to_index[foreign_filter.filter_object.tag] = @extended_filters.length
         @extended_filters << foreign_filter;
        end
      else
        @external_filters << filter;
      end
      

    end

    number_available_fields = @extended_filters.length

    # Handle nil user_id by defaulting to 0
    safe_user_id = @user_id || 0
    sql_str = "DisplayFilter.find_by_sql(\"SELECT table_name, filter_index, element_order FROM display_filters WHERE (user_id = " + safe_user_id.to_s +  " AND table_name = '" + @tables_name + "' AND in_use = true) ORDER BY element_order asc\")"
 #   Rails.logger.error( "DEBUG: before eval(#{sql_str})" );
    results = eval(sql_str);
    if(results.length == 0)
      sql_str = "DisplayFilter.find_by_sql(\"SELECT table_name, filter_index, element_order FROM display_filters WHERE (user_id = 0 AND table_name = '" + @tables_name + "' AND in_use = true) ORDER BY element_order asc\")"
 #     Rails.logger.error( "DEBUG: before eval(#{sql_str})" );
      results = eval(sql_str);
    end
    if(results.length == 0)
      default_number_of_fields = 5
      if number_available_fields <=default_number_of_fields
        @current_filter_indices =  (0 .. (number_available_fields -1)).to_a;
        @possible_filter_indices = []
      else
        @current_filter_indices = (0..(default_number_of_fields-1)).to_a
        @possible_filter_indices = (default_number_of_fields..(number_available_fields-1)).to_a
      end
    else
      @current_filter_indices = []
      @possible_filter_indices = []
      for display_filter in results
        @current_filter_indices << display_filter.filter_index.to_i;
      end
      for i in (0..(number_available_fields -1))
        if(!@current_filter_indices.index(i))
          @possible_filter_indices << i;
        end
      end
    end

    @search_order = Array.new(@current_filter_indices);
    @search_direction = []
    for index in @search_order
      @search_direction << :asc ;
    end
    @search_indices ="";

    #group_person2 = GroupPerson.find(:all, :conditions => "people.second_name like '%Verr%'" , :include => :person);

  end

  def SetCompulsoryIndices(compulsory_indices_)
    @compulsory_indices = compulsory_indices_;
  end

  def FindForeignFilter(foreign_filter_)
    ret_val = nil;
    @foreign_filters.each do |filter|
      if filter.filter_object.field_node.parent.id != 0 && filter.filter_object.field_node.parent.key == foreign_filter_.foreign_key && filter.filter_object.attribute_name == foreign_filter_.attribute_name
        ret_val = filter;
      return ret_val;
    end
    end
    return ret_val;

  end
  def process_node(field_node)
    if @processed_child_nodes.index(field_node.id) == nil
      current_node = field_node
      @processed_child_nodes << current_node.id;
      parent_node = current_node.parent;
      while(parent_node!=nil)
        if(@processed_nodes.index(parent_node.id) == nil)
          @processed_nodes << parent_node.id
          parent_node.current_children = []
        end
        parent_node.current_children << current_node
        @processed_child_nodes << current_node.id
        current_node = parent_node
        parent_node = parent_node.parent
        if @processed_child_nodes.index(current_node.id) != nil
          break;
        end
      end
    end
  end


  #this fuction finds all the possible fields names for a table and puts them in @available_fields.
  #It traces through the associations, and it uses recursion to do this.
  #to prevent call stack overflows, @max_level puts a limit on the number of recursive calls.
  def construct_current_field_tree_with_subquery()
    
    @processed_nodes = [];
    @processed_child_nodes = [];
    @alias_id = 0;
    if(@current_filter_indices.index(0) == nil)
      field = @available_fields[0]; #id must be retrieved
      field_node = field.field_node;
      process_node(field_node)
    end
    @current_attribute_flag = @current_attribute_flag+1;

    @compulsory_indices.each  do |complusory_index|
      if(@current_filter_indices.index(complusory_index) == nil)
        field = @available_fields[complusory_index]; #complusory_index must be retrieved
        field_node = field.field_node;
        field_node.current_flag = @current_attribute_flag;
        @foreign_fields = [];
        @f_f_level = 0;
        find_foreign_fields(field)
        for foreign_field in @foreign_fields
          process_node(foreign_field.field_node)
        end
        process_node(field_node)
      end
    end

    
    for index in @current_filter_indices
      filter_object = @extended_filters[index].filter_object;
      if filter_object.class == SearchField || filter_object.class == SubQuery
        field = filter_object;
        field_node = field.field_node;
        field_node.current_flag = @current_attribute_flag;
        @foreign_fields = [];
        @f_f_level = 0;
        find_foreign_fields(field)
        for foreign_field in @foreign_fields
          process_node(foreign_field.field_node)
        end
        process_node(field_node)
      end
    end
  end
  
  def construct_current_field_tree()
    
    @processed_nodes = [];
    @processed_child_nodes = [];
    @alias_id = 0;
    if(@current_filter_indices.index(0) == nil)
      field = @available_fields[0]; #id must be retrieved
      field_node = field.field_node;
      process_node(field_node)
    end
    @current_attribute_flag = @current_attribute_flag+1;

    @compulsory_indices.each  do |complusory_index|
      if(@current_filter_indices.index(complusory_index) == nil)
        field = @available_fields[complusory_index]; #complusory_index must be retrieved
        field_node = field.field_node;
        field_node.current_flag = @current_attribute_flag;
        @foreign_fields = [];
        @f_f_level = 0;
        find_foreign_fields(field)
        for foreign_field in @foreign_fields
          process_node(foreign_field.field_node)
        end
        process_node(field_node)
      end
    end

    
    for index in @current_filter_indices
      filter_object = @extended_filters[index].filter_object;
      if filter_object.class == SearchField
        field = filter_object;
        field_node = field.field_node;
        field_node.current_flag = @current_attribute_flag;
        @foreign_fields = [];
        @f_f_level = 0;
        find_foreign_fields(field)
        for foreign_field in @foreign_fields
          process_node(foreign_field.field_node)
        end
        process_node(field_node)
      end
    end
  end
  def find_foreign_fields(field)
    if (field.foreign_class == nil)
      x =1;
      return;
    end
    if(field.foreign_class.length == 0)
      return;
    end
    @f_f_level = @f_f_level + 1;
    if @f_f_level > @max_level
      @f_f_level = @f_f_level -1
      return;
    end
    format_elts = FormatController.FormatElements(field.foreign_class.tableize, @user_id).format_elements_array;
    for format_elt in format_elts
      child_name = format_elt.field_name;
      child_field = GetChildNode(field,child_name);
      if child_field != nil
        if(child_field.foreign_class.length == 0)
          @foreign_fields << child_field
        else
          find_foreign_fields(child_field);
        end
      end
    end
    @f_f_level = @f_f_level - 1;
  end
  def construct_short_field_tree()
    @processed_nodes = [];
    @processed_child_nodes = [];
    @alias_id = 0;
    parent_field = @available_fields[0].field_node.parent; #id must be retrieved

    @foreign_fields = [];
    @f_f_level = 0;

    format_elts = FormatController.FormatElements(@table_name.tableize, @user_id).format_elements_array;
    for format_elt in format_elts
      child_name = format_elt.field_name;
      child_field = GetShortChildNode(child_name);
      if child_field != nil
        if(child_field.foreign_class.length == 0)
          @foreign_fields << child_field
        else
          find_foreign_fields(child_field);
        end 
      end
    end
    for foreign_field in @foreign_fields
      process_node(foreign_field.field_node)
    end
  end
  def GetSelectFields(member_id, group_id, member_attribute_name, class_search_controller, order_by_id_)
    ret_val = []   
    
    if !group_id.blank? && group_id != 0 
      if member_id != SearchController::NOT_SET
         group_member = GroupMember.new( NOT_SET_STR, NOT_SET);
         ret_val << group_member;
      end
      eval_str1 = "#{@table_name}.find_by_sql(\"SELECT id FROM #{tables_name} WHERE group_id=#{group_id} AND #{member_attribute_name}=#{member_id} \").length";
      Rails.logger.info("GetSelectFields rwv ret_str = #{eval_str1}")
      id_pres_count = eval(eval_str1);


      if id_pres_count == 0
        short_string = class_search_controller.GetShortField(member_id);
        group_member = GroupMember.new( short_string, member_id);
        ret_val << group_member;
      end

      ret_val  = ret_val + GetAllShortFieldsWhere(order_by_id_, "asc", false,  member_attribute_name, "a0.group_id = #{group_id}");
    else
      group_member = GroupMember.new( NOT_SET_STR, NOT_SET);
      ret_val << group_member;
      ret_val = ret_val  + class_search_controller.GetAllShortFieldsWhere(order_by_id_, "asc", false,  "", "");
    end
    return ret_val;
  end
  def GetAllShortFieldsWhere(order_by_id, order_direction, have_not_set, id_str_, where_str_)
    construct_short_field_tree();
    @sql_str = "SELECT a0.id, "
    if id_str_.length>0
      @sql_str << "a0." + id_str_ + ", "
    end
    get_short_select_string()

    @sql_str << " FROM #{@tables_name} a#{@field_tree.id} "
    @join_str = ""
    get_join_string(@field_tree)
    @sql_str << @join_str
    where_str = "";
    if !have_not_set
      where_str << " a0.id != #{NOT_SET} "
    end
    if where_str_.length >0
      if where_str.length >0
        where_str << " AND "
      end
      where_str << where_str_;
    end
    if where_str.length >0
      @sql_str << " WHERE " + where_str;
    end
    if(order_by_id)
      @sql_str << " ORDER BY a0.id " + order_direction;
    else
      @sql_str << " ORDER BY short_string " + order_direction;
    end

    eval_str = "#{@table_name}.find_by_sql(\"#{@sql_str}\")";
    Rails.logger.info("GetAllShortFieldsWhere rwv ret_str = #{eval_str}")
    
    begin
      ret_val =[]
      results = eval(eval_str);
      if id_str_.length >0
        result_id_str = "result."+id_str_
      else
        result_id_str = "result.id"
      end

      for result in results
        result_id = eval(result_id_str)
        ret_val << GroupMember.new( result.short_string, result_id);
      end
    rescue Exception => exc
      ret_val = [];
    end
    return ret_val;
  end
 def GetAllShortFields2(order_by_id, order_direction, have_not_set)
   GetAllShortFields(order_by_id, order_direction, have_not_set)
 end

  def GetAllShortFields(order_by_id, order_direction, have_not_set)
    return GetAllShortFieldsWhere(order_by_id, order_direction, have_not_set,"", "");
  end

  def GetShortField(id_)
    construct_short_field_tree();
    @sql_str = "SELECT a0.id, "
    get_short_select_string()
    @sql_str << " FROM #{@tables_name} a#{@field_tree.id} "
    @join_str = ""
    get_join_string(@field_tree)
    @sql_str << @join_str
    @where_str = "WHERE a0.id = #{id_}";
    @sql_str << @where_str;
    eval_str = "#{@table_name}.find_by_sql(\"#{@sql_str}\")";
    Rails.logger.info("GetShortField rwv ret_str = #{eval_str}")
    begin
      ret_val = eval(eval_str)[0].short_string;

    rescue Exception => exc
      ret_val = "";
    end
    if ret_val == nil
      ret_val = "";
    end
    return ret_val;
  end
  def get_foreign_select_string(filter)
    @gfss_level = @gfss_level +1;
    if @gfss_level > @max_level
      @gfss_level = @gfss_level -1;
      return;
    end

    format_elts = FormatController.FormatElements(filter.foreign_class.tableize, @user_id).format_elements_array;
    for format_elt in format_elts
      child_name = format_elt.field_name;
      child_field = GetChildNode(filter,child_name);
      if child_field != nil
        child_node = child_field.field_node;
        if(child_field.foreign_class.length == 0)
          @foreign_str << " || " if(@foreign_str.length >0)
          @foreign_str << "a#{child_node.parent.id}.#{child_node.name}"
        else
          get_foreign_select_string(child_field);
        end
      end
      if format_elt.insert_string.length >0
        @foreign_str << " || " if(@foreign_str.length >0)
        @foreign_str << "'#{format_elt.insert_string}'"
      end
    end
    @gfss_level = @gfss_level -1;
  end
  def GetShortChildNode(child_name)
    child_field = nil;
    parent_node = @available_fields[0].field_node.parent
    for c in parent_node.all_children
      if c.name == child_name
        child_field = @available_fields[c.available_fields_index];
        break;
      end
    end
    return child_field;
  end
  def get_short_select_string()
    
    @gfss_level =0;
    @foreign_str = "";
    format_elts = FormatController.FormatElements(@table_name.tableize, @user_id).format_elements_array;
    for format_elt in format_elts
      child_name = format_elt.field_name;
      child_field =GetShortChildNode(child_name)
       
      if child_field != nil
        child_node = child_field.field_node;

        if(child_field.foreign_class.length == 0)
          @foreign_str << " || " if(@foreign_str.length >0)
          @foreign_str << "a#{child_node.parent.id}.#{child_node.name}"
        else
          get_foreign_select_string(child_field);
        end
      end
      if format_elt.insert_string.length >0
        @foreign_str << " || " if(@foreign_str.length >0)
        @foreign_str << "'#{format_elt.insert_string}'"
      end
    end
    # if @foreign_str.length>0
    @sql_str << " CASE a0.id WHEN #{NOT_SET} THEN '#{NOT_SET_STR}' ELSE "
    @sql_str << @foreign_str;
    @sql_str << " END "
    @sql_str <<" AS short_string"
    #  end
  end

  def GetLastShortField()
    min_id_str = "#{@table_name}.last.id"
    begin
      min_id =eval(min_id_str)
    rescue Exception => exc
      min_id = 0
    end
    ret_str = GetShortField(min_id)
    Rails.logger.info("GetLastShortField rwv ret_str = #{ret_str}")
    return ret_str;
  end

  def GetChildNode(field,child_name)
    field_node = @foreign_key_tree_hash[field.full_name]
    child_field = nil;
    for c in field_node.all_children
      if c.name == child_name
        child_field = @available_fields[c.available_fields_index];
        break;
      end
    end
    return child_field;
  end
  
  def get_sql_id_string(ids)
    construct_current_field_tree()
    @sql_str = "SELECT "
    get_select_string(@field_tree )
    @sql_str[@sql_str.length - 1] = ' '
    get_sub_query_string()
    @sql_str << "FROM #{@tables_name} a#{@field_tree.id} "
    @join_str = ""
    get_join_string(@field_tree)
    @sql_str << @join_str
              id_list = "";
          ids.each do |id|
            if id_list.length >0
              id_list << ", "
             end
            id_list <<  id.to_s 
          end
          id_list = "(#{id_list})"
          where_str = "a0.id IN #{id_list}"
    @sql_str <<  "WHERE #{where_str}"
  end

  def get_sql_string()
    construct_current_field_tree()
    @sql_str = "SELECT "
    get_select_string(@field_tree )
    @sql_str[@sql_str.length - 1] = ' '
    get_sub_query_string()
    @sql_str << "FROM #{@tables_name} a#{@field_tree.id} "
    @join_str = ""
    get_join_string(@field_tree)
    @sql_str << @join_str
    @where_str = "";
    get_where_string;
    @sql_str <<  @where_str
    @order_str = "";
    get_order_string;
    @sql_str << @order_str;
    @sql_str << " LIMIT 150 "
  end

  def get_sub_query_string
    x_count = 0;
    for filter_index in @current_filter_indices
      filter_object = @extended_filters[filter_index].filter_object
      if filter_object.class == SubQuery
        sub_query_str = filter_object.select_string;
        sub_query_str = sub_query_str.gsub(/current_argument_value/, filter_object.current_argument_value.to_s );
        local_count = 0;
        sub_query_str.scan(/b\d/){|b_str| local_count = [b_str.match(/\d/)[0].to_i,local_count].max}
        sub_query_str = sub_query_str.gsub(/b\d/){|s| 'x'+(s.match(/\d/)[0].to_i + x_count).to_s}
        x_count  = local_count+ x_count;
        @sql_str << ', '+sub_query_str + ' AS ' +  filter_object.variable_name + ' '
      end
    end

  end

  def get_select_string(field_node)
    for child_node in field_node.current_children
      if child_node.current_children.length == 0 && child_node.current_flag ==  @current_attribute_flag
        filter =  @available_fields[child_node.available_fields_index]
        filter.foreign_search_str = ""
        foreign_class =filter.foreign_class
        if(foreign_class.length == 0)
          @sql_str << " a#{field_node.id}.#{child_node.name}"
          if field_node.parent != nil
            @sql_str << " AS a#{field_node.id}_#{child_node.name}"
          end
          @sql_str << ","
        else
          @gfss_level =0;
          @foreign_str = "";
          get_foreign_select_string(filter)
          # if @foreign_str.length>0
          @foreign_str = " CASE a#{field_node.id}.#{child_node.name} WHEN #{NOT_SET} THEN '#{NOT_SET_STR}' ELSE " +@foreign_str +" END "
          filter.foreign_search_str = @foreign_str
       #   @sql_str << " CASE a#{field_node.id}.#{child_node.name} WHEN #{NOT_SET} THEN '#{NOT_SET_STR}' ELSE "
          @sql_str << @foreign_str;
         # @sql_str << " END "
          @sql_str <<" AS a#{field_node.id}_#{child_node.name}"
          @sql_str << ","
          # end
        end
      else
        get_select_string(child_node)
      end
    end
  end



  def get_join_string(field_node)
    if field_node.parent == nil
      for child_node0 in field_node.current_children
        get_join_string(child_node0)
      end
    else
      nested_joins = [];
      for child_node1 in field_node.current_children
        if child_node1.current_children.length > 0
          nested_joins << child_node1;
        end
      end
      if nested_joins.length >0
        @join_str << "INNER JOIN ( #{field_node.name.tableize} a#{field_node.id} ";
        for child_node2 in nested_joins
          get_join_string(child_node2)
        end
        @join_str << ") ON a#{field_node.parent.id}.#{field_node.key} = a#{field_node.id}.id ";
        
      else
        if field_node.current_children.length > 0
          @join_str << "INNER JOIN #{field_node.name.tableize} a#{field_node.id} ON  a#{field_node.parent.id}.#{field_node.key} = a#{field_node.id}.id "
        end
      end
    end
  end


  def get_where_string
    num_filters = @current_filter_indices.length;
    @where_str = "a0.id != #{NOT_SET} "
    if num_filters >0 && @search_indices.length == 0

      for index in @current_filter_indices
        filter = @extended_filters[index].filter_object;
        if filter.class == SearchField
          filter_str = filter.GetSQLString2;
          if filter_str.length >0
            @where_str = @where_str + " AND #{filter_str} "
          end
        end
      end

      user_where_eval_str = eval("#{table_name}::USER_WHERE_STR");
      if  user_where_eval_str.length >0
         user_where_str = eval(user_where_eval_str);
         @where_str << " AND " + user_where_str if user_where_str.length>0
       end

      external_where_str = external_where_string;
      if external_where_str.length >0

      @where_str << " AND " + external_where_str;
      end
      
    elsif @search_indices.length >0
      @where_str << " AND a0.id IN (#{@search_indices})"     
     
    else
      
    end
    
    if  @where_str.length >0
      @where_str = " WHERE  (" + @where_str +")";
    end
  end
  def external_where_string
    y_count = 0;
    ret_where_str = "";
    for external_filter in @external_filters      
      
      for arg in external_filter.filter_object.current_arguments
        if ret_where_str.length >0
          ret_where_str << " AND "
        end
        external_where_str = external_filter.filter_object.where_str;
        external_where_str = external_where_str.gsub(/arg_value/, arg.member_id.to_s );
        local_count = 0;
        external_where_str.scan(/b\d/){|b_str| local_count = [b_str.match(/\d/)[0].to_i,local_count].max}
        external_where_str = external_where_str.gsub(/b\d/){|s| 'y'+(s.match(/\d/)[0].to_i + y_count).to_s}
        ret_where_str << external_where_str;
      end      
    end
    return ret_where_str;
  end

  def get_order_string
    @order_str = " ORDER BY "

    number_of_orders = @search_order.length
    number_of_orders = 2 if number_of_orders >2
    for i in  (0..( number_of_orders - 1))
      field = @extended_filters[@search_order[i]].filter_object
      if field.class == SearchField
        node_id = field.field_node.parent.id;
        field_name = field.attribute_name
        if(field.field_node.parent.parent == nil && field.foreign_class.length == 0)
          @order_str << " a#{ node_id}.#{field_name}  #{@search_direction[i].to_s },"
        else
          @order_str << " a#{ node_id}_#{field_name}  #{@search_direction[i].to_s },"
        end
      elsif field.class == SubQuery
        @order_str << " #{field.variable_name}  #{@search_direction[i].to_s },"

      end
    end
    @order_str[(@order_str.length) -1] = ' ';

  end
  def get_eval_string2()
    get_sql_string()
    ret_str = "#{@table_name}.find_by_sql(\"#{@sql_str}\")"
    Rails.logger.info("get_eval_string2 rwv ret_str = #{ret_str}")
    return ret_str;
  end

  def get_eval_string_no_sub
    get_sql_string_no_sub
    ret_str = "#{@table_name}.find_by_sql(\"#{@sql_str}\")"
    Rails.logger.info("get_eval_string_no_sub rwv ret_str = #{ret_str}")
    return ret_str;
  end

  def GetUpdateObjects(edit_table_name_, attribute_names_, ids_)
      Rails.logger.info("GetUpdateObjects 01")
    if !@active
      return [];
    end
    if ids_.length == 0
      return [];
    end    
    construct_current_field_tree()
    @update_nodes = [];
    @sn_level = 0;
    @edit_table = edit_table_name_;
    @attribute_names =attribute_names_;
    scan_nodes(@field_tree);
    if @update_nodes.length == 0
      return [];
    else
      get_update_sql_string(ids_);
      eval_str = "#{@table_name}.find_by_sql(\"#{@sql_str}\")";
      Rails.logger.info("GetUpdateObjects rwv eval_str = #{eval_str}")
      ret_val = eval(eval_str);
    end
    x = 1;
    return ret_val;
  end
  def get_update_where_string(ids_)

    num_filters = @current_filter_indices.length;

    for field_id in @update_nodes
      if @where_str.length >0
        @where_str =  @where_str + " OR "
      end
      @where_str =   @where_str + "(a0.id != #{NOT_SET} AND a#{field_id}.id IN (" #{id_}  "
      in_str ="";
      for id in ids_
        if in_str.length>0
          in_str << ","
        end
        in_str << " #{id}"
      end
      in_str << ")"
      @where_str  = @where_str  + in_str;


      if num_filters >0

        for index in @current_filter_indices
          filter = @extended_filters[index].filter_object;
          if filter.class == SearchField
            if((filter.field_node.parent.id == field_id && filter.attribute_name == @attribute_name)==false)
              filter_str = filter.GetSQLString2;
              if filter_str.length >0
                @where_str = @where_str + " AND #{filter_str} "
              end
            end
          end          
        end

      
        @where_str = @where_str + ")"

        
      else
       
      end
    end
    if  @where_str.length >0
      @where_str = " WHERE  (" + @where_str + ")";
    end    
  end

  def get_update_sql_string(ids_)
    construct_current_field_tree()
    @sql_str = "SELECT "
    get_select_string(@field_tree)
    @sql_str[@sql_str.length - 1] = ' '
    @sql_str[@sql_str.length - 1] = ' '
    get_sub_query_string()
    @sql_str << "FROM #{@tables_name} a#{@field_tree.id} "
    @join_str = ""
    get_join_string(@field_tree)
    @sql_str << @join_str
    @where_str = "";
    get_update_where_string(ids_);
    @sql_str <<  @where_str
    @order_str = "";
    get_order_string;
    @sql_str << @order_str;
    # @sql_str << " LIMIT #{@limit_length} OFFSET #{@limit_offset} "
  end

 
  def scan_nodes(field_node_)
    @sn_level = @sn_level+1;
    if(@sn_level >10)
      @sn_level = @sn_level - 1;
      return;
    end
    for child_node in field_node_.current_children
      if(field_node_.name == @edit_table  && @attribute_names.index(child_node.name)!=nil)
        if(@update_nodes.index(field_node_.id) == nil )
          @update_nodes << field_node_.id;
        end
      end
      scan_nodes(child_node)
    end
    
    @sn_level = @sn_level - 1;    
  end
  
  def updateCheckBoxes(row_ids, exam_ids, compulsory_ids)
    @row_ids = row_ids;
    @exam_ids = exam_ids;
    @compulsory_ids = compulsory_ids;
  end

  def updateFilters(current_filter_indices_,  update_display_)
     Rails.logger.debug( "updateFilters start" );
    @active = true;
    num_available_fields = @extended_filters.length;
    @possible_filter_indices = [];
    for i in (0..(num_available_fields-1))
      curr_i = @current_filter_indices.index(i)
      if(curr_i ==nil)
        if(current_filter_indices_.index(i) != nil)
          @current_filter_indices << i;
          @search_order << i;
          @search_direction << :asc;
        else
          @possible_filter_indices << i;
        end
      else
        if(current_filter_indices_.index(i) == nil)
          @current_filter_indices.delete_at(curr_i);
          ord_i = @search_order.index(i)
          if(ord_i !=nil)
            @search_order.delete_at(ord_i);
            @search_direction.delete_at(ord_i);
          end
          @possible_filter_indices << i;
        end
      end
      
    end


    if update_display_
      # Handle nil user_id by defaulting to 0
      safe_user_id = @user_id || 0
      sql_str = "DisplayFilter.find_by_sql(\"SELECT id, user_id, table_name, filter_index, element_order, in_use FROM display_filters WHERE (user_id = " + safe_user_id.to_s +  " AND table_name = '" + @tables_name + "') ORDER BY element_order asc\")"
   #   Rails.logger.error( "DEBUG: before eval(#{sql_str})" );
      old_fields = eval(sql_str);
      old_fields_count  = old_fields.length;
      new_fields_count = @current_filter_indices.length;
      for i in (0..(new_fields_count-1))
        if i>=old_fields_count
          display_filter = DisplayFilter.new;
        else
          display_filter = old_fields[i];
        end
        display_filter.table_name =  @tables_name;
        display_filter.user_id = @user_id;
        display_filter.filter_index = @current_filter_indices[i];
        display_filter.element_order = i;
        display_filter.in_use = true;
        display_filter.save;
      end
    
      if old_fields_count > new_fields_count
        for i in (new_fields_count..(old_fields_count-1))
          old_fields[i].in_use =false;
          old_fields[i].save;
        end
      end
    end
    Rails.logger.debug( "updateFilters end" );
  end



  def binary_search(array_, val_) #searches for insertion point for val_ in ordered array_
    ret_val = 0;
    if array_.length == 0
      return ret_val;
    end
    factor = 2;
    jump  = (array_.length/factor).floor;
    pos = (array_.length/factor).floor
    while(jump>0)
      if array_[pos] <  val_
        pos = pos + jump
      else
        pos = pos - jump
      end
      factor= factor*2;
      jump  = (array_.length/factor).floor;
    end
    if array_[pos] < val
      ret_val = pos + 1;
    else
      ret_val = pos
    end
    return ret_val;
  end

  def UpdateSearchIndices(search_indices)
    @search_indices = search_indices;
  end

  def UpdateOrder(order_field_name)

    Rails.logger.debug("🧪 TEST: UpdateOrder called for '#{order_field_name}', search_direction: #{@search_direction.inspect}")
    order_index = @hash_to_index[order_field_name]
    if(order_index == @search_order[0])
      if @search_direction[0] == :asc
        @search_direction[0] = :desc
      else
        @search_direction[0] = :asc
      end
    else
      old_pos = @search_order.index(order_index)
      if(old_pos !=nil)
        search_dir = @search_direction[old_pos];
        @search_order.delete_at(old_pos);
        @search_direction.delete_at(old_pos);
        @search_order.insert(0,order_index);
        @search_direction.insert(0,search_dir);
        @order_updated = true;
      end
    end
    Rails.logger.debug("🧪 TEST: UpdateOrder after update search_direction: #{@search_direction.inspect}")
  end

  def TestOrderToggle(order_field_name, session)
    Rails.logger.error("🧪 TEST: TestOrderToggle called for '#{order_field_name}'")
    
    # Use symbol keys for persistence (hardcoded for Person table)
    session_order_key = :test_search_order_Person
    session_direction_key = :test_search_direction_Person
    
    
    # Initialize or load from session
    if session[session_order_key].nil? || session[session_direction_key].nil?
      Rails.logger.error("🧪 TEST: Initializing session data from controller state")
      session[session_order_key] = @search_order.dup
      session[session_direction_key] = @search_direction.dup
      
    end
    
    # Increment the counter
    
    
    # Work with session data directly
    search_order = session[session_order_key]
    search_direction = session[session_direction_key]
    
    Rails.logger.error("🧪 TEST: Loaded search_order from session = #{search_order.inspect}")
    Rails.logger.error("🧪 TEST: Loaded search_direction from session = #{search_direction.inspect}")
    
    order_index = @hash_to_index[order_field_name]
    Rails.logger.error("🧪 TEST: order_index for '#{order_field_name}' = #{order_index}")
    
    if order_index.nil?
      Rails.logger.error("🧪 TEST: ERROR - order_index is nil!")
      return
    end
    
    if(order_index == search_order[0])
      if search_direction[0] == :asc
        search_direction[0] = :desc
        Rails.logger.error("🧪 TEST: Toggled primary sort from ASC to DESC")
      else
        search_direction[0] = :asc
        Rails.logger.error("🧪 TEST: Toggled primary sort from DESC to ASC")
      end
    else
      old_pos = search_order.index(order_index)
      Rails.logger.error("🧪 TEST: Moving field from position #{old_pos} to primary position")
      if(old_pos !=nil)
        search_dir = search_direction[old_pos];
        search_order.delete_at(old_pos);
        search_direction.delete_at(old_pos);
        search_order.insert(0,order_index);
        search_direction.insert(0,search_dir);
        Rails.logger.error("🧪 TEST: Moved to primary position with direction #{search_dir}")
      else
        Rails.logger.error("🧪 TEST: Field not found in current order, adding as primary")
        search_order.insert(0,order_index);
        search_direction.insert(0,:asc);
      end
    end
    
    # Save back to session
    session[session_order_key] = search_order
    session[session_direction_key] = search_direction
    
    Rails.logger.error("🧪 TEST: Saved search_order to session = #{search_order.inspect}")
    Rails.logger.error("🧪 TEST: Saved search_direction to session = #{search_direction.inspect}")
    
    
    # Also update the controller state for consistency
    @search_order = search_order.dup
    @search_direction = search_direction.dup
    
    Rails.logger.error("🧪 TEST: Final search_order = #{@search_order.inspect}")
    Rails.logger.error("🧪 TEST: Final search_direction = #{@search_direction.inspect}")
  end

  def UpdateOrder2(order_index)
    if(order_index == @search_order[0])
      if @search_direction[0] == :asc
        @search_direction[0] = :desc
      else
        @search_direction[0] = :asc
      end
    else
      old_pos = @search_order.index(order_index)
      if(old_pos !=nil)
        search_dir = @search_direction[old_pos];
        @search_order.delete_at(old_pos);
        @search_direction.delete_at(old_pos);
        @search_order.insert(0,order_index);
        @search_direction.insert(0,search_dir);
        @order_updated = true;
      end
    end

  end

  def SetExtendedFilterControllers(search_ctls_)
    Rails.logger.debug( "SetExtendedFilterControllers start" );
    filter_id = 0;
    for extended_filter in @extended_filters
      if extended_filter.filter_object.class == SubQuery
        extended_filter.filter_object.selection_controller = search_ctls_[extended_filter.filter_object.argument_class];
      end
    end
 
    Rails.logger.debug( "SetExtendedFilterControllers a" );
    for extended_filter in @external_filters
        Rails.logger.debug( "SetExtendedFilterControllers filter_id = #{filter_id}" );
      
        extended_filter.filter_object.class_search_controller = search_ctls_[extended_filter.filter_object.argument_class];
         
        extended_filter.filter_object.selection_controller = search_ctls_[extended_filter.filter_object.group_class];
       
        extended_filter.filter_object.id = filter_id;
        extended_filter.filter_object.set_user_id(@user_id, @administrator);

        filter_id = filter_id+1;
    end
  
      Rails.logger.debug( "SetExtendedFilterControllers new FilterController" );
      @filter_controller = FilterController.new(search_ctls_, @table_name, @user_id);
      
      @search_ctls = search_ctls_;

      Rails.logger.debug( "SetExtendedFilterControllers end" );
  end
  def UpdateFiltersFromDB()
   for ex_filter in @external_filters
     ex_filter.filter_object.Update();
   end
  end
  def GetPossibleExternalFilters()
    ret_val = [];
    for ex_filter in @external_filters

      if ex_filter.filter_object.current_arguments.length==0
        ret_val << ex_filter.filter_object
      end
    end
    return ret_val;

  end
  def GetCurrentExternalFilters()
    ret_val = [];
    for ex_filter in @external_filters
      
      if ex_filter.filter_object.current_arguments.length>0
        ret_val << ex_filter.filter_object
      end
    end
    return ret_val;    
  end
  
  def GetExternalFilterElement(filter_id, elt_index)
    external_filter = @external_filters[filter_id].filter_object;
    ret_val = ExternalFilterElement.new(elt_index, external_filter);
    return ret_val;
  end

  def GetExternalFilter(filter_id)
    external_filter = @external_filters[filter_id].filter_object;
    return external_filter;
  end  
    
  

  def save_external_filters_to_db
    
 


  end
  
  def CreateNewExternalFilter(filter_id)
    Rails.logger.info("CreateNewExternalFilter begin");
    external_filter = @external_filters[filter_id].filter_object;
    external_filter.current_arguments = [];
    new_arg =  GetExternalFilterElement(filter_id, 0);
    new_arg.group_id = 0;
    new_member_id_str = "#{external_filter.class_name}.last";
    Rails.logger.info("CreateNewExternalFilter before eval str #{new_member_id_str}");
    new_arg.member_id = eval(new_member_id_str).id;
    external_filter.current_arguments << new_arg;
    Rails.logger.info("CreateNewExternalFilter end");
    return external_filter;    
  end



  def ProcessTable(qualifier, qualifier_str, qualifiers_str, current_table, include_str, parent_tree)

    @level = @level + 1;
    if @level > @max_level
      @level = @level - 1;
      return
    end
    include_index = @search_include_strings.index(include_str);
    if include_index == nil
      include_index = @search_include_strings.length;
      @search_include_strings << include_str;
    end
    ExtractFields(qualifier, qualifier_str, qualifiers_str, current_table, include_index, parent_tree);
    string_to_evaluate = "#{current_table}.reflect_on_all_associations(:belongs_to)"
    reflections = eval(string_to_evaluate);
    for reflection in reflections
      reflection_table_name = reflection.class_name
      #reflection_table_name = reflection.name
      local_qualifier = HeaderStr(reflection.name.to_s)
      reflection_qualifier = "#{qualifier}/#{local_qualifier}"

      local_qualifier_str = HeaderStr(reflection.name.to_s);
      reflection_qualifier_str = "#{qualifier_str}#{local_qualifier_str}."

      local_qualifiers_str = local_qualifier_str.pluralize
      reflection_qualifiers_str = "#{qualifiers_str}#{local_qualifiers_str}."

      local_include_str = IncludeStr(local_qualifier_str)
      if include_str == ""
        reflection_include_str = local_include_str;
      else
        reflection_include_str = "#{include_str} => #{local_include_str}"
      end
      foreign_key = reflection.options[:foreign_key];
      tables_name = QualifiersStr(reflection_table_name)

      sub_tree = FieldNode.new(parent_tree,reflection.class_name,-1, foreign_key);
      parent_tree.all_children << sub_tree;
      # @foreign_key_tree_hash[foreign_key] = sub_tree;
      full_name = "#{reflection_qualifier}"
      @foreign_key_tree_hash[full_name] = sub_tree;
      ProcessTable(reflection_qualifier, reflection_qualifier_str, reflection_qualifiers_str, reflection_table_name, reflection_include_str, sub_tree)

    end
    @level = @level - 1
  end
  #This is a helper function for ProcessTable. It does a local field extraction for the table_name_str
  def ExtractFields(qualifier, qualifier_str, qualifiers_str, table_name_str, include_index_val, parent_tree)
    #attribute_eval_str = " AttributeList.new(#{table_name_str}).attribute_elements"
    attribute_eval_str = "AttributeList.new(#{table_name_str})"
#    unless session[attribute_eval_str]
      attribute_list = eval(attribute_eval_str)
 #     session[attribute_eval_str] = attribute_list;
 #   else
 #     attribute_list = session[attribute_eval_str];
 #   end
   
    reflection_hash = attribute_list.reflections;
    attributes = attribute_list.attribute_elements
    for attribute in attributes
      attribute_name= attribute.name()
      if attribute.foreign_key.length == 0
        data_type_symbol  = attribute.data_type
      else
        data_type_symbol = :string
      end

      if data_type_symbol == :time
      if parent_tree.parent == nil && attribute.foreign_key.length == 0

        eval_string ="row.#{attribute_name}.strftime(\"%H:%M\")"

      else
        eval_string ="row.a#{parent_tree.id}_#{attribute_name}.strftime(\"%H:%M\")"
      end

      else


      if parent_tree.parent == nil && attribute.foreign_key.length == 0
        if(attribute_name == "collection_status")
          eval_string = "case row.#{attribute_name}
                           when 1
                              \"NEEDS TO BE TAKEN\"
                           when 2
                              \"HAS BEEN TAKEN\"
                           else
                              \"UNNECESSARY\"
                           end"
        else
          eval_string = "row.#{attribute_name}"
        end
      else
        eval_string = "row.a#{parent_tree.id}_#{attribute_name}"
      end
      end
      if attribute.foreign_key.length == 0
        foreign_class = ""
        field_string = HeaderStr(attribute_name);
      else
        foreign_class = reflection_hash[attribute.name];
        field_string = HeaderStr(attribute.foreign_key);
      end
      
      
      qualifer_string = qualifier
      tag_symbol =  QualifierStr("#{qualifier}_#{field_string}")
      id_val = @new_index_val

      available_fields_index = @available_fields.length;

      field_node = FieldNode.new(parent_tree, attribute_name, available_fields_index, "");
      parent_tree.all_children << field_node;
      if parent_tree.parent == nil
        primary = attribute.primary;
      else
        primary = false;
      end
      


      @available_fields << SearchField.new(field_string, qualifer_string, eval_string, include_index_val, data_type_symbol, tag_symbol, id_val,  table_name_str, attribute_name, field_node, foreign_class, primary)
      @hash_to_index[tag_symbol] = @available_fields.length - 1;
      @new_index_val = @new_index_val+1
    end

  end
  def HeaderStr(in_str)

    ret_str = in_str.strip;
    ret_str = ret_str.gsub(/_/){|s| ' '};
    ret_str = ret_str.gsub(/[a-z][A-Z]\S{1}/){|s| s.insert(1," ")}
    ret_str = ret_str.gsub(/[a-z][A-Z]\S{1}/){|s| s.insert(1," ")}
    ret_str = ret_str.gsub(/(?:\s|^)[a-z]/){|s| s.upcase}
    ret_str = ret_str.gsub(/(?:\s|^)(?:i|I)(?:d|D)(?:\s|$)/){|s| s = s.upcase}
    ret_str = ret_str.gsub(/Id(?:\s|$)/){|s|  s = s.upcase }
    return  ret_str

  end
  def QualifierStr(in_str)
    ret_str = in_str.strip;
    ret_str = ret_str.gsub(/[a-z][A-Z]\S{1}/){|s| s.insert(1," ")}
    ret_str = ret_str.gsub(/[a-z][A-Z]\S{1}/){|s| s.insert(1," ")}
    ret_str = ret_str.gsub(/\s/){|s| '_'};
    ret_str = ret_str.gsub(/\//){|s| '__'};
    ret_str = ret_str.downcase;
    return ret_str;
  end
  def QualifiersStr(in_str)
    ret_str = in_str.strip;
    ret_str = ret_str.gsub(/[a-z][A-Z]\S{1}/){|s| s.insert(1," ")}
    ret_str = ret_str.gsub(/[a-z][A-Z]\S{1}/){|s| s.insert(1," ")}
    ret_str = ret_str.gsub(/\S+$/){|s| s = s.pluralize}
    ret_str = ret_str.gsub(/\s/){|s| '_'};
    ret_str = ret_str.gsub(/\//){|s| '__'};
    ret_str = ret_str.downcase;
    return ret_str;
  end
  def IncludeStr(in_str)
    ret_str = QualifierStr(in_str);
    ret_str = ":#{ret_str}"
    return ret_str

  end
end





