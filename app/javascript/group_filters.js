function UpdateGroupFilter(table_name, foreign_key)
{

    wait();
    const group_id_str = "group_filters_option_" + table_name +"_" +foreign_key;

    const group_id_str15 = "#"+group_id_str;
    const group_id_obj = jQuery(group_id_str15);
    const group_id = group_id_obj.val();

    jQuery(group_filters_table_name).val( table_name);
    jQuery(group_filters_foreign_key).val( foreign_key);
    jQuery(group_filters_group_id).val( group_id);

    
   // jQuery('#group_filters_form').submit();
    const elem = document.getElementById('group_filters_form');
    Rails.fire(elem, 'submit');;
    

}
function UpdateGroupFilter2(table_name, foreign_key)
{
    const x = 2;


}
