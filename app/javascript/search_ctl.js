function wait()
{

    jQuery('#disable_id').show();
    jQuery('#disable_id').css('cursor','wait');
    

}
window.wait = wait;
function unwait()
{
    jQuery('#disable_id').hide();
    jQuery('#disable_id').css('cursor','default');

}
window.unwait = unwait;

function deleteColumn(field_name, table_name)  
{
    wait();
    table_text_element_str = "table_selector_text_" + table_name 

    table_text_element_str29 = "#"+table_text_element_str;
    table_text_element  = jQuery(table_text_element_str29 );
    if(table_text_element[0] != null)
    {             
        table_text_element.attr("value", table_name);
    }
    class_name = field_name + "_" + table_name
    column_elements = jQuery("td." + class_name )
    column_elements.each(function(){
        jQuery(this).remove()
    });
    column_elements = jQuery("th." + class_name )
    column_elements.each(function(){
        jQuery(this).remove()
    });
    num_filters_obj = jQuery('#all_display_indices_'+ table_name);
    num_filters = parseInt(num_filters_obj.val()) - 1;
    num_filters_obj.val(  num_filters);
    if(num_filters <=1)
    {

        search_div = jQuery('#search_results_'+table_name);
        current_div = jQuery('#current_filters_'+table_name);
        var x_elements_search = search_div.find('.remove_column').first();
        var x_elements_current = current_div.find('remove_column.').first();
        if(typeof(x_elements_search) != "undefined")
        {
            x_elements_search.remove();
        }
        if(typeof(x_elements_current) != "undefined")
        {
            x_elements_current.remove();
        }
    }

    do_search_str = "do_search_" + table_name;

    do_search_str64 = "#"+do_search_str;
    do_search_element  = jQuery(do_search_str64);
    do_search_element.attr("name", "do_not_search");

    form_id = "search_form_" + table_name
    form_id = 'search_form_' + table_name;
    elem = document.getElementById(form_id);
    Rails.fire(elem, 'submit');;
}
window.deleteColumn = deleteColumn;

function setSearchIndices(table_name)
{
    rows_class_str = ".row_" +  table_name;
    row_count = 0;
    row_str=""
    jQuery(rows_class_str).each(function(){
        id_td = jQuery(this).children().first()
        if(id_td != null)
        {
            id_array = id_td.html().match(/\b\d+\b/)
            if(id_array !=null)
            {
                row_count = row_count+1;
                if(row_str.length != 0)
                {
                    row_str = row_str + ", " + id_array[0];

                }
                else
                {
                    row_str = row_str + id_array[0];
                }
            }
        }
    });
    if(row_count>0 && row_count <150)
    {
        order_index_element_str = "#order_indices_" + table_name;
        order_index_element = jQuery(order_index_element_str);

        order_index_element.attr("name", "order_indices");
        order_index_element.attr("value", row_str);
    }

}
window.setSearchIndices = setSearchIndices;

function invert_selection(table_name, check_str) 
{
    check_box_strs = '#search_results_'+ table_name + ' input.'+check_str;
    check_boxes = jQuery(check_box_strs);
    check_boxes.each(function(){
        box = jQuery(this);
        box.prop( 'checked', !box.is(':checked') );
        if(check_str=='check'){
            if(!box.is(':checked') ){
                box.closest('tr').find('.compulsorycheck:first').prop( 'checked',false);
                box.closest('tr').find('.examcheck:first').prop( 'checked',false);
            }
            
        } else {
            if(box.is(':checked') ){
                box.closest('tr').find('.check:first').prop( 'checked',true);
            }
        }
    }); 

}
window.invert_selection = invert_selection;

function setSelectIndices(table_name)
{
     search_results_div_str = "#search_results_" + table_name;
     search_results_div = jQuery(search_results_div_str);
     specific_div_str = "#order_checks_"+ table_name;
     specific_div = jQuery(specific_div_str);    
     specific_div.children().each(function(){jQuery(this).remove()});

     insert_specific_div_checks(specific_div, search_results_div, '.check');

     if(table_name== "Person")
     {        
        insert_specific_div_checks(specific_div, search_results_div, '.examcheck');
        insert_specific_div_checks(specific_div, search_results_div, '.compulsorycheck');
     }

}
window.setSelectIndices = setSelectIndices;

function searchOrder(field_name, table_name) 
{
    wait();
    order_element_str = "order_text_" + table_name;

    order_element_str74 = "#"+order_element_str;
    order_element  = jQuery(order_element_str74);
  
    order_element.attr("name", "order_text");
    order_element.attr("value", field_name);
    
    
    setSearchIndices(table_name);
    setSelectIndices(table_name);
    
    disableSubmitters();

    do_search_str = "do_search_" + table_name;

    do_search_str81 = "#"+do_search_str;
    do_search_element  = jQuery(do_search_str81);
    do_search_element.attr("name", "do_search");

    search_form_str = "search_form_" + table_name;

    search_form_str85 = "#"+search_form_str;
    my_form  = jQuery(search_form_str85);
    elem = document.getElementById(search_form_str);
    Rails.fire(elem, 'submit');;
}
window.searchOrder = searchOrder;

function disableSubmitters()
{

    
}
window.disableSubmitters = disableSubmitters;

function resizeX()
{
    var client_height = parseInt(jQuery('#dummy_x').height());
    var a_height = jQuery('#dummy_a').height();
    var new_padding = (client_height - parseInt(a_height))/2;
    var new_height = client_height - new_padding;
    var style_str = "background: #AAAAAA;  border-left: 1px solid; border-color: #000000;  float: right; height: "    + new_height + "px; padding-top: " + new_padding +"px"
    jQuery('.remove_column').each(function(){
      //  jQuery(this).attr('style',style_str)
         jQuery(this).css('height', new_height);
          jQuery(this).css('padding-top', new_padding);
        });


    jQuery('.div_column_edit').each(function(){
        jQuery(this).css('height', new_height);
        jQuery(this).css('padding-top', new_padding);
        });

}
window.resizeX = resizeX;

function doEscapeHTML(class_id_name)
{
    sent_text_element_str = class_id_name +"_sent"

    sent_text_element_str116 = "#"+sent_text_element_str;
    sent_text_element  = jQuery(sent_text_element_str116);

    sent_text_element_str117 = "#"+sent_text_element_str;
    sent_text_element_value  = jQuery(sent_text_element_str117).val();
    sent_text_element_value_esc = sent_text_element_value.escapeHTML();
    sent_text_element.attr("value", sent_text_element_value_esc);
}
window.doEscapeHTML = doEscapeHTML;

function updatePostFilterStrings(class_id_name) 
{
    sent_text_element_str = class_id_name +"_sent"
    typed_text_element_str = class_id_name +"_typed"

    sent_text_element_str125 = "#"+sent_text_element_str;
    sent_text_element  = jQuery(sent_text_element_str125);

    typed_text_element_str126 = "#"+typed_text_element_str;
    typed_text_element  = jQuery(typed_text_element_str126);
    typed_filter_str = typed_text_element.val();
    typed_filter_str_esc =  typed_filter_str.escapeHTML()
    sent_text_element.attr("value", typed_filter_str_esc );
}
window.updatePostFilterStrings = updatePostFilterStrings;

function updatePostExternalFilter(class_id_name)
{
    sent_text_element_str = class_id_name +"_sent"
    typed_text_element_str = class_id_name +"_typed"

    sent_text_element_str136 = "#"+sent_text_element_str;
    sent_text_element  = jQuery(sent_text_element_str136);

    typed_text_element_str137 = "#"+typed_text_element_str;
    typed_text_element  = jQuery(typed_text_element_str137);
    typed_filter_str = parseInt(typed_text_element.val());
    sent_text_element.val( typed_filter_str);
    x = 1;
    
}
window.updatePostExternalFilter = updatePostExternalFilter;

function Search(table_name)
{
    wait();
    resizeFilters();
    //   jQuery('#person_id_Person_x').hasAttribute('style')
    // jQuery('#person_first_name_Person_x').attr('style','float:right; height: 190px');

    current_filter_str = "current_filters_" +table_name;

    current_filter_str152 = "#"+current_filter_str;
    current_filter_element  = jQuery(current_filter_str152);
    current_filter_element.style.display = 'none';
    do_search_str = "do_search_" + table_name;

    do_search_str155 = "#"+do_search_str;
    do_search_element  = jQuery(do_search_str155);
    do_search_element.attr("name", "do_search");

    form_id = "search_form_" + table_name

    form_id159 = "#"+form_id;
    form_element  = jQuery(form_id159);
    elem = document.getElementById(form_id);
    Rails.fire(elem, 'submit');
    
}
window.Search = Search;

function AddField(table_name)
{
    wait();
    text_element_id = "add_filter_value_" +table_name
    select_id = "possible_filters_"+table_name

    select_id168 = "#"+select_id;
    selected_val  = jQuery(select_id168).val();

    if(selected_val == "do_nothing")
    {
        return;
    }

    current_filter_str = "current_filters_" +table_name;

    current_filter_str176 = "#"+current_filter_str;
    current_filter_element  = jQuery(current_filter_str176);
    no_results = current_filter_element.is(':visible');
    do_search_str = "do_search_" + table_name;

    do_search_str179 = "#"+do_search_str;
    do_search_element  = jQuery(do_search_str179);
    if(no_results)
    {
        do_search_element.attr("name", "do_not_search");
    }
    else
    {
        do_search_element.attr("name", "do_search");
    }


    text_element_id189 = "#"+text_element_id;
    text_element  = jQuery(text_element_id189);
    text_element.attr("name", selected_val);
    text_element.attr("value", "%" );
    form_id = "search_form_" + table_name

    form_id193 = "#"+form_id;
    form_element  = jQuery(form_id193);
    elem = document.getElementById(form_id);
    Rails.fire(elem, 'submit');  
}
window.AddField = AddField;

function AddFilter(table_name)
{
    wait();
    select_elt_str = "possible_external_filters_"+table_name;

    select_elt_str200 = "#"+select_elt_str;
    select_elt  = jQuery(select_elt_str200);
    selected_val= select_elt.val();

    

    if(selected_val == "do_nothing")
    {
        return;
    }

    option_id = "possible_external_filters_"+table_name+"_"+selected_val;

    option_id211 = "#"+option_id;
    option_elt = jQuery(option_id211);
    option_elt.remove();
    
    text_element_str= "add_external_filter_id_" + table_name;

    text_element_str215 = "#"+text_element_str;
    text_elt  = jQuery(text_element_str215);
    text_elt.attr("value",selected_val);

    text_num_filters_str = "number_of_external_filters_" + table_name;

    text_num_filters_str219 = "#"+text_num_filters_str;
    text_num_filters_elt  = jQuery(text_num_filters_str219);
    current_num_filters = parseInt(text_num_filters_elt.val());
    if(current_num_filters == 0)
        {
            header_str = "external_filters_header_" + table_name;

            header_str224 = "#"+header_str;
            header_elt  = jQuery(header_str224);
            header_elt.html("<label>Search Filters </label>")
        }
    new_num_filters = current_num_filters+1;
    text_num_filters_elt.attr("value", new_num_filters);

    form_id = "add_external_filter_"+ table_name;

    form_id231 = "#"+form_id;
    form_element  = jQuery(form_id231);
    elem = document.getElementById(form_id);
    Rails.fire(elem, 'submit');
}
window.AddFilter = AddFilter;

function onUpdateExternalFilterGroup(class_name, filter_id,  elt_id)
{
    filter_id_str = "update_external_filter_id_"+ class_name;
    elt_id_str = "update_external_elt_index_"+ class_name;
    member_id_str = "update_external_member_id_"+ class_name;
    group_id_str = "update_external_group_id_"+ class_name;


    filter_id_str242 = "#"+filter_id_str;
    filter_id_elt  = jQuery(filter_id_str242);

    elt_id_str243 = "#"+elt_id_str;
    elt_id_elt  = jQuery(elt_id_str243);

    member_id_str244 = "#"+member_id_str;
    member_id_elt  = jQuery(member_id_str244);

    group_id_str245 = "#"+group_id_str;
    group_id_elt   = jQuery(group_id_str245);

    group_select_id_str = "group_selection_" + class_name + "_" + filter_id + "_" + elt_id;
    member_select_id_str = "argument_selection_" + class_name + "_" + filter_id + "_" + elt_id;

    group_select_id_str249 = "#"+group_select_id_str;
    group_select_elt  = jQuery(group_select_id_str249);

    member_select_id_str250 = "#"+member_select_id_str;
    member_select_elt  = jQuery(member_select_id_str250);
    group_id= group_select_elt.val();
    member_id = member_select_elt.val();

    filter_id_elt.attr("value",filter_id );
    elt_id_elt.attr("value", elt_id);

    member_id_elt.attr("value",member_id);
    group_id_elt.attr("value", group_id);

    form_str = "update_external_filter_"+ class_name;

    form_str261 = "#"+form_str;
    form_elt  = jQuery(form_str261);
    
    elem = document.getElementById(form_str);
    Rails.fire(elem, 'submit');
    
}
window.onUpdateExternalFilterGroup = onUpdateExternalFilterGroup;

function addExternalFilterElement(class_name, filter_id)
{
    num_elts_str = "number_of_filter_elements_" + class_name + "_" + filter_id;

    num_elts_str268 = "#"+num_elts_str;
    num_elts_elt  = jQuery(num_elts_str268);
    max_filter_element_str = "#max_filter_elements_" + class_name + "_" + filter_id;
    max_filter_element = jQuery(max_filter_element_str);
    current_num_elts = parseInt(num_elts_elt.val());
    new_elt_id = current_num_elts;
    new_current_num = current_num_elts+1;
    num_elts_elt.attr("value", new_current_num);
    max_filter_element.attr("value", new_elt_id+1);

    prev_elt_id = new_elt_id -1;
    prev_elt = null;
    max_id = 0;
    new_elt = null;
    while(prev_elt_id>=0 && prev_elt == null)
    {
    prev_elt_str = "external_filter_selection_" + class_name + "_" + filter_id +"_" + prev_elt_id;


    prev_elt_str277 = "#"+prev_elt_str;
    prev_elt  = jQuery(prev_elt_str277)[0];
    prev_elt_id = prev_elt_id  -1;
        
    }
    new_elt = jQuery(prev_elt).clone(true);

    
    new_elt.attr('id',"external_filter_selection_"+ class_name + "_" + filter_id +"_" + new_elt_id);
    external_filter_group_selection = new_elt.find('.external_filter_group_selection_'+class_name)[0];
    if(typeof(external_filter_group_selection) != "undefined")
        {
            jQuery(external_filter_group_selection).attr('id',"group_selection_"+ class_name + "_" + filter_id +"_" + new_elt_id);

            jQuery(external_filter_group_selection).attr("onchange","onUpdateExternalFilterGroup('"+class_name+"','"+filter_id+"','"+new_elt_id+"');return false");
            old_filter_group_selection = jQuery(prev_elt).find('.external_filter_group_selection_'+class_name)[0];
            old_group_selection_value = jQuery(old_filter_group_selection).val();
            group_class_str = ".group_class_"+old_group_selection_value
            external_filter_group_selected =  jQuery(external_filter_group_selection).find(group_class_str)[0];
            jQuery(external_filter_group_selected).prop('selected',true);

    }
    external_filter_argument_span_element = new_elt.find('.external_filter_argument_span').first();
    external_filter_argument_span_element.attr('id',"external_filter_argument_span_"+ class_name + "_" + filter_id +"_" + new_elt_id);
    argument_selection_element = new_elt.find('.external_filter_argument_selection').first();
    argument_selection_element.attr('id',"argument_selection_"+class_name + "_" + filter_id +"_" + new_elt_id);
    argument_selection_element.attr('name',"argument_selection_"+ filter_id +"_" + new_elt_id);
    filter_element_field= new_elt.find('.remove_filter_element_field').first();;
    filter_element_field_a = filter_element_field.find('a').first();
    filter_element_field_a.attr('onclick', "deleteExternalFilterElement('"+class_name+"','"+filter_id+"','"+new_elt_id+"');return false");

    var new_space = jQuery("<div></div>").attr({ style: 'float: left' });
     //   new_space.html("&nbsp")
    new_space.insertAfter(prev_elt)
    //prev_elt.after(new_space);
    next_space = prev_elt.next('div');
    new_elt.insertAfter(next_space);
    //next_space.after(new_elt);
}
window.addExternalFilterElement = addExternalFilterElement;

function deleteExternalFilterElement(class_name, filter_id,  elt_id)
{


    filter_selection_str = "external_filter_selection_" + class_name + "_" + filter_id + "_" + elt_id;

    filter_selection_str316 = "#"+filter_selection_str;
    filter_selection_elt  = jQuery(filter_selection_str316);
    div_space = filter_selection_elt.next('div');
    filter_selection_elt.remove();
  //  div_space.remove();

    num_elts_str = "number_of_filter_elements_" + class_name + "_" + filter_id;

    num_elts_str322 = "#"+num_elts_str;
    num_elts_elt  = jQuery(num_elts_str322);

    current_num_elts = parseInt(num_elts_elt.val());
    new_current_num = current_num_elts-1;
    if(new_current_num == 0)
    {

            header_str = "external_filters_header_" + class_name;

            header_str330 = "#"+header_str;
            header_elt  = jQuery(header_str330);
            

        header_container_str = "external_filter_header_" + class_name + "_" + filter_id;

        header_container_str334 = "#"+header_container_str;
        header_container  = jQuery(header_container_str334);
       header_str = header_container.html();
        extended_filter_str = "external_filter_" + class_name + "_" + filter_id;

        extended_filter_str337 = "#"+extended_filter_str;
        extended_filter_elt  = jQuery(extended_filter_str337);
        extended_filter_elt.remove();
        num_filters_str = "number_of_external_filters_" + class_name;

        num_filters_str340 = "#"+num_filters_str;
        num_filters_elt  = jQuery(num_filters_str340);
        current_num_filters = parseInt(num_filters_elt.val());
        new_num_filters = current_num_filters - 1;
        num_filters_elt.attr("value",new_num_filters);
        if(new_num_filters == 0)
            {
                header_elt.html("")
            }



        possible_select_str = "possible_external_filters_" + class_name;

        possible_select_str352 = "#"+possible_select_str;
        possible_select_elt  = jQuery(possible_select_str352);
        not_set_option = possible_select_elt.find('option').first();
        first_option = not_set_option.next();

        var new_option = jQuery("<option>", {id: 'possible_external_filters_' + class_name + '_' +  filter_id,  value: filter_id });
        new_option.html(header_str)
        if(first_option[0] == null)
        {
            new_option.insertAfter(not_set_option);
        }
        else
        {
            current_elt = first_option;
            current_value = parseInt(current_elt.val());
            if(current_value > filter_id)
            {
                new_option.insertAfter(not_set_option);
            }
            else
            {
                next_elt = current_elt.next();
                while (next_elt[0] != null && parseInt(next_elt.val()) < filter_id)
                {
                    current_elt = next_elt;
                    next_elt = current_elt.next();
                }
                new_option.insertAfter(current_elt);
            }
        }
    }
    else
    {
        num_elts_elt.attr("value", new_current_num);
        
        for (reorder_index = parseInt(elt_id)+1; reorder_index <= new_current_num; reorder_index++) {
             filter_selection_str = "external_filter_selection_" + class_name + "_" + filter_id + "_" + reorder_index;
             new_id = "external_filter_selection_" + class_name + "_" + filter_id + "_" + (reorder_index-1);

             filter_selection_str316 = "#"+filter_selection_str;
             filter_selection_elt  = jQuery(filter_selection_str316);
             filter_selection_elt.prop('id', new_id);
             
             external_filter_argument_span_str = "external_filter_argument_span_" + class_name + "_" + filter_id + "_" + reorder_index;
             new_external_filter_argument_span_str = "external_filter_argument_span_" + class_name + "_" + filter_id + "_" + (reorder_index-1);
             external_filter_argument_span_elt = jQuery("#"+external_filter_argument_span_str);
             external_filter_argument_span_elt.prop('id', new_external_filter_argument_span_str);
             
             onclick_str = "deleteExternalFilterElement('"+class_name+"','"+filter_id+"','"+(reorder_index-1)+"');return false;"
             external_filter_argument_span_elt.find('a').attr('onclick', onclick_str);
             
             
             argument_selection_str = '#argument_selection_'+ class_name +'_'+ filter_id + '_' + reorder_index; 
             new_namer = 'argument_selection_' + filter_id + '_' + (reorder_index-1);
             new_idr = 'argument_selection_' + class_name +'_'+ filter_id + '_' + (reorder_index-1);
             argument_selection_elt = jQuery(argument_selection_str);
             argument_selection_elt.prop('id', new_idr);
             argument_selection_elt.prop('name',new_namer);
        }
    }
    
}
window.deleteExternalFilterElement = deleteExternalFilterElement;

function resizeExternalFilters(class_name)
{
    
    var client_height = jQuery('#dummy_x').height();
    var height_str = "" +  client_height+"px"
    jQuery('.external_filter_group_selection_'+class_name).each(function(){
        jQuery(this).css({height: height_str});
    });
    jQuery('.external_filter_argument_selection').each(function(){
        jQuery(this).css({height: height_str});
    });
    jQuery('.external_filter_element').each(function(){
        jQuery(this).css({height: height_str});
    });

    var a_height = jQuery('#dummy_a').height();
    var new_padding = ((client_height - parseInt(a_height))/2);
    var new_height = client_height - new_padding;



    jQuery('.add_external_filter_element').each(function(){
        jQuery(this).css("height", new_height);
        jQuery(this).css("padding-top", new_padding);
    });
    jQuery('.remove_filter_element_field').each(function(){
        jQuery(this).css("height", new_height);
        jQuery(this).css("padding-top", new_padding);
    });
}
window.resizeExternalFilters = resizeExternalFilters;

function resizeFilters()
{
    var client_height = parseInt(jQuery('#dummy_x').height());
    var narrow_width = parseInt(jQuery('#dummy_format_narrow').width());
    var wide_width = parseInt(jQuery('#dummy_format').width());
    var x_height = parseInt(jQuery('#dummy_fx').height());
    var p_height = parseInt(jQuery('#dummy_fp').height());
    var x_padding = (client_height - x_height)/2.0 ;
    var p_padding = (client_height - p_height)/2.0 ;
    var new_x_height = client_height  - x_padding;
    var new_p_height = client_height- p_padding;

    var x_style_str = "background: #AAAAAA;  border-left: 1px solid;  border-color: #000000; float:right; height: " + new_x_height + "px; padding-top: " + x_padding + "px";
    var p_style_str = "background: #AAAAAA;  border: 1px solid #000; float:left; height: " + new_p_height + "px; padding-top: " + p_padding + "px";
    var select_style_str = "border:none; background-color: transparent; overflow:hidden; height: " + client_height*2 + "px"
    var input_style_str = "border:none; height: " + client_height + "px"
    var height_str = "" +  client_height+"px"
    var wide_width_str = "" + wide_width + "px"
    var narrow_width_str = "" + narrow_width + "px"
    //  var p_style_str = "background: #AAAAAA;  border: 1px solid #000; float:left; height: 60px: padding-top: " + p_padding + "px";
      
   
    jQuery('.select_filter').each(function(){
        jQuery(this).attr({
            height: height_str
        });
    //   elt_parent = jQuery(this).getOffsetParent();
    //   grand_parent = elt_parent.getOffsetParent();
    //   grand_parent.attr({MinWidth: '200px'})
    //    jQuery(this).attr({MinWidth: "200px" }); I just can't get this to '
           
    });
    
//      jQuery('.wide_filter').each(function(){
//         jQuery(this).attr({'min-width': '200px' });
//     });


       

}
window.resizeFilters = resizeFilters;

function group_unrestriction()
{
    external_filter_Group_0 =  jQuery('#external_filter_Group_0');
    if (external_filter_Group_0[0]  != null)
    {
        external_filter_Group_0.style.display = '';
    }

 
}
window.group_unrestriction = group_unrestriction;

function group_restriction_timeout(table_name, do_update)
{
    external_filter_Group_0 = jQuery('#external_filter_Group_0');
    select_obj = jQuery('#argument_selection_Group_0_0');
     
    if( external_filter_Group_0[0] == null ||  select_obj[0] == null)
    {
        function_str = 'group_restriction_timeout("' + table_name +'",'+  do_update+')';
 //       setTimeout("alert('hi there')", 100);
        setTimeout(function_str, 10);
    }
    else
    {
        external_filter_Group_0.style.display = 'none';
        select_value = select_obj.val();
        if(select_value != table_name)
        {
            do_update = true;
            options = select_obj.find('option');
            options.each(function()
            {
                x=1;
                if(jQuery(this).val() == table_name)
                {

                    jQuery(this).prop('selected',true);
                    class_name = jQuery(this).text()
                    return false;
                }

            });

        }
        if(do_update)
        {
            Search("Group")


        }
    }
}
window.group_restriction_timeout = group_restriction_timeout;

function group_restriction(table_name)
{ 
    
    select_obj = jQuery('#argument_selection_Group_0_0');
    
    do_update = false;
    if( select_obj[0] == null)
    {
        select_elt_str = "possible_external_filters_Group";

        select_elt_str567 = "#"+select_elt_str;
        select_elt  = jQuery(select_elt_str567);
        options = select_elt.find('option');
        options.each(function()
        {
            x=1;
            if(jQuery(this).val() == 0)
            {
                jQuery(this).prop('selected',true);
                return false;
            }

        });

        AddFilter('Group');       
        do_update = true;
        

    }
    
    group_restriction_timeout(table_name, do_update)
}
window.group_restriction = group_restriction;
