
function deleteElement(table, count_str)
{
    const count = parseInt(count_str);
    const current_elts_str = "display_format_count_"+ table;

    const current_elts_str14 = "#"+current_elts_str;
    const current_elts_obj = jQuery(current_elts_str14);
    let current_elts = parseInt(current_elts_obj.val());
    if( current_elts == 1)
        {
            return;
        }
    const field_names = new Array();
    const insert_strings = new Array();

    for(i=count+1;i<current_elts;i++)
    {
        const field_name_str = "display_format_field_"+table + "_"+i

        const field_name_str26 = "#"+field_name_str;
        const field_name_obj = jQuery(field_name_str26);
        const field_name = field_name_obj.val();
        field_names.push( field_name);

        const insert_string_str = "display_format_string_"+table + "_"+i

        const insert_string_str31 = "#"+insert_string_str;
        const insert_string_obj = jQuery(insert_string_str31);
        const insert_string = insert_string_obj.val();
        insert_strings.push( insert_string);
    }
    current_elts = current_elts - 1;
    

    for(i=count;i<current_elts;i++)
    {
        const field_name_str = "display_format_field_"+table + "_"+i

        const field_name_str41 = "#"+field_name_str;
        const field_name_obj = jQuery(field_name_str41);
        field_name_obj.val( field_names[i-count]);

        const insert_string_str = "display_format_string_"+table + "_"+i

        const insert_string_str45 = "#"+insert_string_str;
        const insert_string_obj = jQuery(insert_string_str45);
        insert_string_obj.val( insert_strings[i-count]);
    }
    current_elts_obj.val( current_elts);
    const delete_elt_str = "display_format_" +table +"_" + current_elts;

    const delete_elt_str50 = "#"+delete_elt_str;
    const delete_elt = jQuery(delete_elt_str50);
    delete_elt.remove();
    if(current_elts ==1)
    {
        const elt_str = "#display_format_" +table +"_0 .remove_format_field";
        const a_elts = jQuery(elt_str);
        a_elts[0].remove();

    }
    const min_width_div_str = "min_width_"+table;
    const width = (current_elts )*230;
    const width_str = ' '+ width +'px';

    jQuery(min_width_div_str).attr('min-width', width_str );
}
window.deleteElement = deleteElement;

function addElement(table, count_str)
{
    const count = parseInt(count_str);
    const current_elts_str = "display_format_count_"+ table;

    const current_elts_str71 = "#"+current_elts_str;
    const current_elts_obj = jQuery(current_elts_str71);
    const current_elts = parseInt(current_elts_obj.val());
    if(current_elts ==1)
    {
        const first_textbox_str = "display_format_string_div_" + table+"_0";

        const first_textbox_str76 = "#"+first_textbox_str;
        const first_textbox = jQuery(first_textbox_str76);
        const parent_textbox = first_textbox.getOffsetParent();

     //   jQuery(element).wrap('div').attr({backgroundImage: 'url(images/rounded-corner-top-left.png) top left'});
        var new_a = jQuery('<a href ="/" data-remote="true" rel="nofollow"></a>').attr({ onclick: "deleteElement('"+table+"','0');return false" });
        new_a.html("X")
        var new_a_div = new_a.wrap('div',{ 'class': 'remove_format_field' })
        new_a_div.attr('id',"remove_format_"+ table+"_0");
       // var new_x = new Element( 'i' );
       // new_x.update("<div class=\"remove_format_field\"><a href =\"#\">X</a> </div>");
       // new_x.attr("onclick","deleteElement('"+table+"','0');return false");
       // new_x.attr('id',"remove_format_"+ table+"_0");
        new_a_div.insertAfter(first_textbox );
    }

    
    let i;
    let new_count;
    for(i=current_elts-1;  i>=count; i--)
    {
       
        const div_obj = jQuery('#display_format_' + table+"_"+i);
        const display_format_string_div = jQuery('#display_format_string_div_'+ table+"_"+i);
        const display_format_field = jQuery('#display_format_field_'+ table+"_"+i);
        const display_format_string = jQuery('#display_format_string_'+ table+"_"+i);
        const remove_format = jQuery('#remove_format_'+ table+"_"+i);
        const aref_remove_format = remove_format.find('a:first');
        const add_format = jQuery('#add_format_'+ table+"_"+i);
        const aref_add_format = add_format.find('a:first');

        const new_count = i+1;

        div_obj.attr('id',"display_format_" + table+"_"+new_count);
        display_format_string_div.attr('id',"display_format_string_div_"+ table+"_"+new_count);
        display_format_field.attr('id',"display_format_field_"+ table+"_"+new_count);
        display_format_field.attr('name',"display_format_field_"+ table+"_"+new_count);
        display_format_string.attr('id',"display_format_string_"+ table+"_"+new_count);
        display_format_string.attr('name',"display_format_string_"+ table+"_"+new_count);
        aref_remove_format.attr("onclick","deleteElement('"+table+"','"+new_count+"');return false");
        remove_format.attr('id',"remove_format_"+ table+"_"+new_count);
        add_format.attr('id',"add_format_"+ table+"_"+new_count);
        aref_add_format.attr("onclick", "addElement('"+table+"','"+(new_count+1)+"');return false");
    }
    let pos_str;
    let div_str;

    if(count ==current_elts)
    {
        const pos_str = 'after';
        const div_str = "display_format_" + table+"_"+(count-1);

    }
    else
    {
        const pos_str = 'before';
        const div_str = "display_format_" + table+"_" +(count+1);
    }
    

    const div_str133 = "#"+div_str;
    const first_div_obj = jQuery(div_str133);
    const div_obj = first_div_obj.clone(true);
   
    const display_format_string = div_obj.find('input:first');
    const display_format_string_div = div_obj.find('display_format_string_div:first');
    const display_format_field = div_obj.find('select:first');
    const remove_format = div_obj.find('remove_format_field:first');
    const aref_remove_format = remove_format.find('a:first');
    const add_format = div_obj.find('add_format_field:first');
    const aref_add_format = add_format.find('a:first');

    new_count = count;
    div_obj.attr('id',"display_format_" + table+"_"+new_count);
    display_format_string_div.attr('id',"display_format_string_div_"+ table+"_"+new_count);
    display_format_field.attr('id',"display_format_field_"+ table+"_"+new_count);
    display_format_field.attr('name',"display_format_field_"+ table+"_"+new_count);
    display_format_string.attr('id',"display_format_string_"+ table+"_"+new_count);
    display_format_string.attr('name',"display_format_string_"+ table+"_"+new_count);
    aref_remove_format.attr("onclick","deleteElement('"+table+"','"+new_count+"');return false");
    remove_format.attr('id',"remove_format_"+ table+"_"+new_count);
    add_format.attr('id',"add_format_"+ table+"_"+new_count);
    aref_add_format.attr("onclick", "addElement('"+table+"','"+(new_count+1)+"');return false");

    display_format_string.val("");
    display_format_field.val( "");

    if(pos_str == 'before')
    {
        div_obj.insertBefore(first_div_obj );
    }
    else
    {
        div_obj.insertAfter(first_div_obj);

    }
    
    current_elts_obj.val( current_elts +1);
    const min_width_div_str = "min_width_"+table;
    const width = (current_elts+1)*230;
    const width_str = ' '+ width +'px';

    jQuery(min_width_div_str).attr('min-width', width_str );


}
window.addElement = addElement;

function resizeFormat()
{

      var client_height = parseInt(getElementHeight('dummy_format'));
      var x_height = parseInt(getElementHeight('dummy_fx'));
      var p_height = parseInt(getElementHeight('dummy_fp'));
      var x_padding = (client_height - x_height)/2.0 ;
      var p_padding = (client_height - p_height)/2.0 ;
      var new_x_height = client_height  - x_padding;
      var new_p_height = client_height- p_padding;

      var x_style_str = "background: #AAAAAA;  border-left: 1px solid;  border-color: #000000; float:right; height: " + new_x_height + "px; padding-top: " + x_padding + "px";
      var p_style_str = "background: #AAAAAA;  border: 1px solid #000; float:left; height: " + new_p_height + "px; padding-top: " + p_padding + "px";
      var select_style_str = "border:none; background-color: transparent; overflow:hidden; height: " + client_height + "px"
      var input_style_str = "border:none; height: " + client_height + "px"
    //  var p_style_str = "background: #AAAAAA;  border: 1px solid #000; float:left; height: 60px: padding-top: " + p_padding + "px";
      jQuery('.add_format_field').each(function(){jQuery(this).attr('style',p_style_str)});
      jQuery('.remove_format_field').each(function(){jQuery(this).attr('style',x_style_str)});
       jQuery('.format_select').each(function(){jQuery(this).attr('style',select_style_str)});
       jQuery('.format_input').each(function(){jQuery(this).attr('style',input_style_str)});

}
window.resizeFormat = resizeFormat;


