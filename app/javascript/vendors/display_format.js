
function deleteElement(table, count) {
  count = parseInt(count, 10);
  const counterId = "display_format_count_" + table;
  const counterInput = document.getElementById(counterId);
  let currentElts = parseInt(counterInput.value, 10);

  // If there’s only one left, do nothing
  if (currentElts === 1) return;

  // 1) Collect the values of all fields/strings after the one we’re deleting
  const fieldNames = [];
  const insertStrings = [];
  for (let i = count + 1; i < currentElts; i++) {
    const fieldInput = document.getElementById(`display_format_field_${table}_${i}`);
    fieldNames.push(fieldInput.value);

    const stringInput = document.getElementById(`display_format_string_${table}_${i}`);
    insertStrings.push(stringInput.value);
  }

  // 2) Decrement the count
  currentElts -= 1;

  // 3) Shift each saved value down one slot
  for (let i = count; i < currentElts; i++) {
    const fieldInput = document.getElementById(`display_format_field_${table}_${i}`);
    fieldInput.value = fieldNames[i - count];

    const stringInput = document.getElementById(`display_format_string_${table}_${i}`);
    stringInput.value = insertStrings[i - count];
  }

  // 4) Update the counter in the DOM
  counterInput.value = currentElts;

  // 5) Remove the now-unused element container
  const toDelete = document.getElementById(`display_format_${table}_${currentElts}`);
  if (toDelete) toDelete.remove();

  // 6) If only one remains, also remove its “remove” link
  if (currentElts === 1) {
    const removeLink = document.querySelector(`#display_format_${table}_0 .remove_format_field`);
    if (removeLink) removeLink.remove();
  }

  // 7) Adjust the container’s min-width (230px per item)
  const minWidthDiv = document.getElementById("min_width_" + table);
  if (minWidthDiv) {
    minWidthDiv.style.minWidth = (currentElts * 230) + "px";
  }
}
window.deleteElement = deleteElement;

function addElement(table, count_str)
{
    const count = parseInt(count_str);
    const current_elts_str = "display_format_count_"+ table;

    const current_elts_str71 = "#"+current_elts_str;
    const current_elts_obj = document.getElementById((current_elts_str71).slice(1)); //rwv vanilla change
    const current_elts = parseInt(current_elts_obj.value);
    if(current_elts ==1)
    {
        const first_textbox_str = "display_format_string_div_" + table+"_0";

        const first_textbox_str76 = "#"+first_textbox_str;
        const first_textbox = document.getElementById((first_textbox_str76).slice(1)); //rwv vanilla change
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
       
        const div_obj = document.getElementById(('#display_format_' + table+"_"+i).slice(1)); //rwv vanilla change
        const display_format_string_div = document.getElementById(('#display_format_string_div_'+ table+"_"+i).slice(1)); //rwv vanilla change
        const display_format_field = document.getElementById(('#display_format_field_'+ table+"_"+i).slice(1)); //rwv vanilla change
        const display_format_string = document.getElementById(('#display_format_string_'+ table+"_"+i).slice(1)); //rwv vanilla change
        const remove_format = document.getElementById(('#remove_format_'+ table+"_"+i).slice(1)); //rwv vanilla change
        const aref_remove_format = remove_format.find('a:first');
        const add_format = jQuery('#add_format_'+ table+"_"+i);
        const aref_add_format = add_format.find('a:first');

        new_count = i+1;

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
    const first_div_obj = document.getElementById((div_str133).slice(1)); //rwv vanilla change
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

    display_format_string.value = ""; //rwv vanilla change;
    display_format_field.value =  ""; //rwv vanilla change;

    if(pos_str == 'before')
    {
        div_obj.insertBefore(first_div_obj );
    }
    else
    {
        div_obj.insertAfter(first_div_obj);

    }
    
    current_elts_obj.value =  current_elts +1; //rwv vanilla change;
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


