import Rails from "@rails/ujs";

console.log("🍪 edit.js loaded!");

window.MyHash = function(){
  // private storage
  this.hash_table = {};

  // define each method on the instance itself
  this.set = function(key, value) {
    return this.hash_table[key] = value;
  };

  this.unset = function(key) {
    delete this.hash_table[key];
  };

  this.exists = function(key) {
    return key in this.hash_table;
  };

  this.get = function(key) {
    return this.exists(key) ? this.hash_table[key] : null;
  };
};





function div_test()
{

    
    //jQuery('#div_test').submit();
    const elem = document.getElementById('div_test');
    Rails.fire(elem, 'submit');    

}
window.div_test = div_test;



function on_load()
{
    const win_load_obj = jQuery('#win_load')
    if(win_load_obj.get(0)){
    //win_load_obj.submit();
    const elem = document.getElementById('win_load');
    Rails.fire(elem, 'submit');;

    }
}
window.onload = on_load;

document.addEventListener('turbo:load', function() { on_load; });

var open_windows = new window.MyHash();

function file_change()
{

    const disable_div = jQuery("<div></div>").attr({style: "position:absolute; top:0; right:0; width:100%; height: 100%; background-color: #ff0000;  opacity:0.0" });
    const main_div = jQuery('#main_div');
    disable_div.insertAfter( main_div);
     disable_div.css('cursor','wait');
    const submit_upload_obj = jQuery('#file_upload');
   // submit_upload_obj.submit();
    const elem = document.getElementById('file_upload');
    Rails.fire(elem, 'submit');
 
}
window.file_change = file_change;

function file_change2()
{
    const submit_upload_obj = jQuery('#edit_agatha_file');
    const elem = document.getElementById('edit_agatha_file');
    Rails.fire(elem, 'submit');
  //  submit_upload_obj.submit();
    const x = 1;
}
window.file_change2 = file_change2;
function myBlur()
{
 const x = 1;
 const y = 2;
 const z = x+y;
}
window.myBlur = myBlur;



function on_unload()
{
    const unload_attribute_obj = jQuery("#unload_attribute");
    const unload_data_type_obj = jQuery("#unload_data_type");
    const attribute_name = unload_attribute_obj.val();
    const data_type = unload_data_type_obj.val(); 
    const unloading = true;
    editBlur(attribute_name, data_type, unloading);
    const parent_win = window.opener;
    const unload_table_obj = jQuery('#unload_table_name');
    const table = unload_table_obj.val(); 
   parent_win.alert("" +table +" edit window has been closed and the database has been updated. Click search to see changes.");

}


function open_win()
{
const my_window = window.open("http://localhost:3000/people/13/edit?table_name=Person");
}
window.open_win = open_win;


function update_parent(table_name, attribute_name, id)
{
    let parent_win = window.opener;
    let first_parent;
    if(parent_win == null)
        {
            const first_parent = window.open('','main_window');
            if(first_parent != jQuery(window))
            {
                    const parent_win = first_parent
            }
        }
    if(parent_win!=null)
        {
            const id_obj = parent_win.document.getElementById('update_main_id');
            const table_obj = parent_win.document.getElementById('update_main_class_name');
            const attribute_obj = parent_win.document.getElementById('update_main_attribute_name');
            const update_opener_attribute_name_obj = parent_win.document.getElementById('update_opener_attribute_name');
            const update_opener_id_obj = parent_win.document.getElementById('update_opener_id');
            jQuery(id_obj).val( id);
            jQuery(table_obj).val( table_name);
            jQuery(attribute_obj).val( attribute_name);
            jQuery(update_opener_attribute_name_obj).val( document.getElementById('sensible_update_opener_attribute_name').value);
            if(update_opener_id_obj!=null){
                jQuery(update_opener_id_obj).val( document.getElementById('sensible_update_opener_id').value);
            }
            const submit_obj = parent_win.document.getElementById('update_main');
            //submit_obj.submit();
            Rails.fire(submit_obj, 'submit');
        }
}
window.update_parent = update_parent;

function on_edit( table_name,class_name,id)
{
    const span_aref_obj_str = "a_edit_"+table_name +"_" + id;

    const span_aref_obj_str120 = "#"+span_aref_obj_str;
    const span_aref_obj = jQuery(span_aref_obj_str120 );
    const aref_obj = span_aref_obj.find('a').first();
    //var  disabled_a = jQuery("<label></label>").attr({'class': 'alabel'});
    //disabled_a.html('Edit ')
    //aref_obj.remove();
    //span_aref_obj.replaceWith(disabled_a);

    const attribute_opener = ''
    const opener_id = 1;
    open_windows.set('main', jQuery(window));
    open_edit_window(attribute_opener,  opener_id, table_name, class_name, id);


    const y = 2;
   
  
}
window.on_edit = on_edit;

function open_edit_window(attribute_opener, opener_id, table_name,class_name,id)
{

      const new_name = class_name + '_' + id;
   const url = '/'+table_name +'/' + id +'/edit?table_name='+ class_name;
   const new_height = screen.height-20;

    var config_window = 'toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width='+ (screen.width/2 - 16)+ ', height=' + new_height  +',left='+(screen.width/2 +17)+',top=20'

    const stupid_update_opener_attribute_name_obj = jQuery('#stupid_update_opener_attribute_name');
    stupid_update_opener_attribute_name_obj.val(attribute_opener);
    const stupid_update_opener_id_obj = jQuery('#stupid_update_opener_id');
    stupid_update_opener_id_obj.val( opener_id);
    
    const win_ref = window.open(url,new_name, config_window);
    const update_opener_attribute_name_obj = win_ref.document.getElementById('update_opener_attribute_name');
    if(update_opener_attribute_name_obj!=null){
        jQuery(update_opener_attribute_name_obj).val( attribute_opener);
    }

    const update_opener_id_obj = win_ref.document.getElementById('update_opener_id');
    if(update_opener_id_obj!=null){
        jQuery(update_opener_id_obj).val( opener_id);
    }
    open_windows.set(new_name , win_ref );

}
window.open_edit_window = open_edit_window; 

function silly_update()
{
 
    const parent_win = window.opener;
    if(parent_win!=null)
    {
          
         const stupid_update_opener_attribute_name_obj = parent_win.document.getElementById('stupid_update_opener_attribute_name');
         const stupid_update_opener_id_obj = parent_win.document.getElementById('stupid_update_opener_id');
         document.getElementById('sensible_update_opener_attribute_name').value =  stupid_update_opener_attribute_name_obj.value;
        
         document.getElementById('sensible_update_opener_id').value =  stupid_update_opener_id_obj.value;
         
       //   
    }

}
window.silly_update = silly_update;

function OnChangeNewGroup(class_name)
{
    const button_id = "create_group_button_"+class_name;

    const button_id181 = "#"+button_id;
    const button_elt = jQuery(button_id181 );
    const group_name_id = "new_group_name_" + class_name;

    const group_name_id183 = "#"+group_name_id;
    const group_name_elt = jQuery(group_name_id183);
    const current_str = group_name_elt.val();
    const new_str = current_str.replace(/^\s+/,'').replace(/\s+$/,'');
    if(new_str.length!=0)
        {
            button_elt.disabled = false;
        }
        else
            {
                 button_elt.disabled = true;
                
            }
}
window.OnChangeNewGroup = OnChangeNewGroup;

function setcheck(check_id, value)
{
    

    const check_id199 = "#"+check_id;
    const check_obj = jQuery(check_id);
    check_obj.prop( 'checked', value);
}
window.setcheck = setcheck;

function setcheckremote(check_id, value,doc)
{
     const check_id199 = "#"+check_id;
    const check_obj = jQuery(check_id,doc);
    check_obj.prop( 'checked', value);  
}
window.setcheckremote = setcheckremote;

function on_checkbox_click(row_id, type_name, class_name)
{
    const check_str = class_name +'_'+ type_name +'_'+  row_id

     const check_str206 = "#"+check_str;
     const check_obj = jQuery(check_str206)
    if( check_obj[0] != null && check_obj.is(':checked'))
        {

            const class_name209 = "#"+class_name;
            const select_box = jQuery(class_name209 + "_check_"+row_id);
            select_box.prop( 'checked', true);
        }
        return check_obj.is(':checked')
}
window.on_checkbox_click = on_checkbox_click;

function on_select_check_click(row_id, class_name)
{

    const class_name217 = "#"+class_name;
    const select_box = jQuery(class_name217 +"_check_"+row_id);
    
    if(select_box && !select_box.is(':checked'))
        {

            const class_name221 = "#"+class_name;
            const compulosry_box = jQuery(class_name221 + "_compulsorycheck_"+row_id);
            compulosry_box.prop( 'checked',false);

            const class_name223 = "#"+class_name;
            const exam_box = jQuery(class_name223 + "_examcheck_"+row_id);
            exam_box.prop( 'checked',false);
        }
        return select_box.is(':checked')
}
window.on_select_check_click = on_select_check_click;

function on_assign(id)
{
    wait();
    const specific_div = jQuery('#specific_action_variables');
    specific_div.children().each(function(){
        jQuery(this).remove()
        });
     const sent_tutor = jQuery("<input></input>").attr({ type: 'text', name: 'id',  value: id  });
     specific_div.append(sent_tutor  );
     const class_name = document.getElementById('action_class').value;
     const search_results_div_str = "search_results_" + class_name;

     const search_results_div_str239 = "#"+search_results_div_str;
     const search_results_div = jQuery(search_results_div_str239)
     search_results_div.find('.check').each(function()
     {
            const new_elt = jQuery(this).clone(true); new_elt.removeAttr('id');
            specific_div.append(new_elt  )
      });

    const form_obj = jQuery('#action_form');
   // form_obj.submit();
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');;

}
window.on_assign = on_assign;   

function on_willing(id)
{
    wait();
    const specific_div = jQuery('#specific_action_variables');
    specific_div.children().each(function(){
        jQuery(this).remove()
        });
     const sent_willing = jQuery("<input></input>").attr({ type: 'text', name: 'willing_id',  value: id  });
     specific_div.append(sent_willing   );
     const class_name = document.getElementById('action_class').value;
     const search_results_div_str = "search_results_" + class_name;

     const search_results_div_str261 = "#"+search_results_div_str;
     const search_results_div = jQuery(search_results_div_str261)
     search_results_div.find('.check').each(function()
     {
            const new_elt = jQuery(this).clone(true); new_elt.removeAttr('id');
            specific_div.append(new_elt  )
      });

    const form_obj = jQuery('#action_form');
    //form_obj.submit();
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');;

}
window.on_willing = on_willing;

function on_agatha_send(id,test_flag)
{
    wait();
    const specific_div = jQuery('#specific_action_variables');
    specific_div.children().each(function(){
        jQuery(this).remove()
        });

    const sent_email = jQuery("<input></input>").attr({ type: 'text', name: 'email_id',  value: id  })
    const sent_test_flag = jQuery("<input></input>").attr({ type: 'text', name: 'test_flag',  value: test_flag  })
    specific_div.append( sent_email );
     specific_div.append( sent_test_flag  );
    document.getElementById('action_type').value =  "send_email"
    const form_obj = jQuery('#action_form');
   // form_obj.submit();
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');
}
window.on_agatha_send = on_agatha_send;

function on_sends(test_flag)
{
    wait();
    const specific_div = jQuery('#specific_action_variables');
    specific_div.children().each(function(){
        jQuery(this).remove()
        });

   
     const search_results_div_str = "search_results_AgathaEmail" ;

     const search_results_div_str299 = "#"+search_results_div_str;
     const search_results_div = jQuery(search_results_div_str299)
     search_results_div.find('.check').each(function()
     {
            const new_elt = jQuery(this).clone(true); new_elt.removeAttr('id');
            specific_div.append(new_elt  )
      });
     const sent_test_flag = jQuery("<input></input>").attr({ type: 'text', name: 'test_flag',  value: test_flag  })
     specific_div.append( sent_test_flag  );
    document.getElementById('action_type').value =  "send_emails"
    const form_obj = jQuery('#action_form');
   // form_obj.submit();
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');;
    
}
window.on_sends = on_sends;

function on_create_send(id)
{
    wait();
    const specific_div = jQuery('#specific_action_variables');
    specific_div.children().each(function(){
        jQuery(this).remove()
        });
    document.getElementById('action_type').value =   "create_send_email_from_template";
             const class_name = document.getElementById('action_class').value;

            const class_name320 = "#"+class_name;
            const action_div = jQuery(class_name320 +'_action_div');
            const email_template_div = action_div.find('email_template_div:first');

            const term_elt = jQuery('#email_template_term');
            const term_id = term_elt.val();
            const course_elt = jQuery('#email_template_course');
            const course_id = course_elt.val();
            const sent_template = jQuery("<input></input>").attr({ type: 'text', name: 'email_template_id',  value: id  })
            const sent_term = jQuery("<input></input>").attr({ type: 'text',  name: 'term_id', value: term_id });
            const sent_course = jQuery("<input></input>").attr({ type: 'text',  name: 'course_id', value: course_id });
            specific_div.append( sent_template);
            specific_div.append(  sent_term);
            specific_div.append(  sent_course);
            const class_name2 = document.getElementById('action_class2').value;
            const search_results_div_str = "search_results_" + class_name2;

            const search_results_div_str335 = "#"+search_results_div_str;
            const search_results_div = jQuery(search_results_div_str335)
            search_results_div.find('.check').each(function()
            {
                const new_elt = jQuery(this).clone(true); new_elt.removeAttr('id');
                specific_div.append(new_elt  )
            });

        const form_obj = jQuery('#action_form');
      //  form_obj.submit();
        const elem = document.getElementById('action_form');
        Rails.fire(elem, 'submit');;
      
}
window.on_create_send = on_create_send;

function on_create(id)
{
    let class_name;
    let action_div;
    let term_elt;
    let term_id;
    let previous_suggestion_elt;
    let previous_suggestions;
    let sent_course;
    let sent_term;
    let sent_previous_suggestions;
    let class_name2;
    let search_results_div_str;
    let search_results_div;

    wait();
    const specific_div = jQuery('#specific_action_variables');
    specific_div.children().each(function(){
        jQuery(this).remove()
        });
    const action_type = document.getElementById('action_type').value;
    switch (action_type)
    {
        case 'create_lecture_from_course':
            
            class_name = document.getElementById('action_class').value;

            const class_name359 = "#"+class_name;
            action_div = jQuery(class_name359 +'_action_div');
            const schedule_div = action_div.find('schedule_div:first');
            const lecturer_elt = jQuery('#new_lecturer');
            const person_id = lecturer_elt .val();
            term_elt = jQuery('#lecture_term')
            term_id = term_elt.val();
            const day_elt = jQuery('#lecture_day')
            const day_id = day_elt.val();
            const time_elt = jQuery('#lecture_time')
            const lecture_time = time_elt.val();
            const num_lectures_elt = jQuery('#number_of_lectures');
            const number_of_lectures = num_lectures_elt.val();
            const num_classes_elt = jQuery('#number_of_classes');
            const number_of_classes = num_classes_elt.val();

            previous_suggestion_elt = jQuery('#previous_lecture_suggestions')
            previous_suggestions = previous_suggestion_elt.val();

            sent_course = jQuery("<input></input>").attr({ type: 'text', name: 'course_id',  value: id  })
            const sent_lecturer = jQuery("<input></input>").attr({type: 'text',name: 'person_id',  value: person_id })
            sent_term = jQuery("<input></input>").attr({ type: 'text',  name: 'term_id', value: term_id })
            const sent_day = jQuery("<input></input>").attr({ type: 'text', name: 'day_id', value: day_id  })
            const sent_time = jQuery("<input></input>").attr({ type: 'text', name: 'lecture_time', value: lecture_time });
            const sent_num_lectures = jQuery("<input></input>").attr({ type: 'text',   name: 'number_of_lectures',  value: number_of_lectures   })
            const sent_num_classes = jQuery("<input></input>").attr({  type: 'text',  name: 'number_of_classes',  value: number_of_classes })
            sent_previous_suggestions = jQuery("<input></input>").attr({ type: 'text',  name: 'previous_suggestions', value: previous_suggestions  })

            specific_div.append(sent_course  );
            specific_div.append( sent_lecturer   );
            specific_div.append( sent_term);
            specific_div.append( sent_day  );
            specific_div.append( sent_time );
            specific_div.append( sent_num_lectures);
            specific_div.append( sent_num_classes);
            specific_div.append( sent_previous_suggestions );
            break;
        case 'create_tutorials_from_course':
            class_name = document.getElementById('action_class').value;

            const class_name397 = "#"+class_name;
            action_div = jQuery(class_name397 +'_action_div');
            const tutorial_schedule_div = action_div.find('tutorial_schedule_div:first');
            const tutor_elt = jQuery('#new_tutor');
            const tutor_id = tutor_elt .val();
            term_elt = jQuery('#tutorial_schedule_term')
            term_id = term_elt.val();

            const num_tutorials_elt = jQuery('#number_of_tutorials');
            const number_of_tutorials = num_tutorials_elt.val();
            const tutorial_class_size_elt = jQuery("#tutorial_class_size");
            const tutorial_class_size = tutorial_class_size_elt.val();
            const collection_required_elt = jQuery('#collection_required');
            if(collection_required_elt.is(':checked'))
            {
                const collection_required = "1"
            }
            else
            {
                const collection_required = "0";
            }
            const previous_suggestion_elt = jQuery('#previous_tutorial_schedule_suggestions')
            const previous_suggestions = previous_suggestion_elt.val();

            sent_course = jQuery("<input></input>").attr({ type: 'text', name: 'course_id',  value: id  })
            const sent_tutor = jQuery("<input></input>").attr({type: 'text',name: 'tutor_id',  value: tutor_id })
            sent_term = jQuery("<input></input>").attr({ type: 'text',  name: 'term_id', value: term_id })
            const sent_num_tutorials = jQuery("<input></input>").attr({ type: 'text',   name: 'number_of_tutorials',  value: number_of_tutorials   })
            const sent_tutorial_class_size = jQuery("<input></input>").attr({ type: 'text',   name: 'tutorial_class_size',  value: tutorial_class_size   })
            const sent_collection_required = jQuery("<input></input>").attr({ type: 'text',   name: 'collection_required',  value: collection_required   })
            const sent_previous_suggestions = jQuery("<input></input>").attr({ type: 'text',  name: 'previous_suggestions', value: previous_suggestions  })

            specific_div.append(sent_course  );
            specific_div.append( sent_tutor   );
            specific_div.append( sent_term);
            specific_div.append( sent_num_tutorials );
            specific_div.append(sent_tutorial_class_size );
            specific_div.append( sent_collection_required );
            specific_div.append( sent_previous_suggestions );

            class_name2 = document.getElementById('action_class2').value;
            search_results_div_str = "search_results_" + class_name2;

            const search_results_div_str435 = "#"+search_results_div_str;
            search_results_div = jQuery(search_results_div_str435)
            search_results_div.find('.check').each(function()
            {
                const new_elt = jQuery(this).clone(true); new_elt.removeAttr('id');
                specific_div.append(new_elt  )
            });
            break;
          case 'create_email_from_template':
            const class_name = document.getElementById('action_class').value;

            const class_name444 = "#"+class_name;
            const action_div = jQuery(class_name444 +'_action_div');
            const email_template_div = action_div.find('email_template_div:first');

            const term_elt = jQuery('#email_template_term');
            const term_id = term_elt.val();
            const course_elt = jQuery('#email_template_course');
            const course_id = course_elt.val();
            const sent_template = jQuery("<input></input>").attr({ type: 'text', name: 'email_template_id',  value: id  })
            const sent_term = jQuery("<input></input>").attr({ type: 'text',  name: 'term_id', value: term_id });
            const sent_course = jQuery("<input></input>").attr({ type: 'text',  name: 'course_id', value: course_id });
            specific_div.append(  sent_template);
            specific_div.append(  sent_term);
            specific_div.append( sent_course);
            const class_name2 = document.getElementById('action_class2').value;
            const search_results_div_str = "search_results_" + class_name2;

            const search_results_div_str459 = "#"+search_results_div_str;
            const search_results_div = jQuery(search_results_div_str459)
            search_results_div.find('.check').each(function()
            {
                const new_elt = jQuery(this).clone(true); new_elt.removeAttr('id');
                specific_div.append(new_elt  )
            });
            break;
        }
        const form_obj = jQuery('#action_form');
        //form_obj.submit();
        const elem = document.getElementById('action_form');
        Rails.fire(elem, 'submit');;
        


}
window.on_create = on_create;

function on_add_attendees(lecture_id)
{

}
window.on_add_attendees = on_add_attendees;


function insert_specific_div_checks(specific_div, search_results_div, check_class)
{
    

    search_results_div.find(check_class).each(function(){
    const new_elt = jQuery(this).clone(true); new_elt.removeAttr('id');
                specific_div.append(new_elt)
            });
}
window.insert_specific_div_checks = insert_specific_div_checks;

function insert_specific_div_multi_values(specific_div, class_name2)
{

}
window.insert_specific_div_multi_values = insert_specific_div_multi_values;

function on_action( id)
{
    wait();
    const action_type = document.getElementById('action_type').value;
    const specific_div = jQuery('#specific_action_variables');
    specific_div.children().each(function(){
        jQuery(this).remove()
    });
    const class_name2 = jQuery("#action_class2").val();
    const search_results_div_str = "#search_results_" + class_name2;
    const search_results_div = jQuery(search_results_div_str)

    const id_elt = new Element('input',{
        type: 'text',
        name: 'id',
        value: id
    });
    specific_div.append( id_elt);
    switch (action_type)
    {
        case 'add_to_group': case 'remove_from_group': case 'add_to_groups': case 'remove_from_groups': case 'attach_files': case 'attach_to_emails':
            insert_specific_div_checks(specific_div, search_results_div, '.check');
            break;

        case 'add_to_lectures':
            insert_specific_div_checks(specific_div, search_results_div, '.check');
            insert_specific_div_checks(specific_div, search_results_div, '.examcheck');
            insert_specific_div_checks(specific_div, search_results_div, '.compulsorycheck');
            break;

    }
    const form_obj = jQuery('#action_form');
 //   form_obj.submit();
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');;
     
}
window.on_action = on_action;
function set_suggestion_class(suggest_type_str, suggestion_class)
{
    const suggest_obj = jQuery('#suggest_type')
    suggest_obj.val( suggest_type_str);
    const suggest_class_obj = jQuery('#suggest_class')
    suggest_class_obj.val( suggestion_class);

}
window.set_suggestion_class = set_suggestion_class;
function set_action_class(class_name, class_name2, action_type)
{
    const action_obj = jQuery('#action_type');

    const action_table = jQuery('#action_class');
    const action_class2 = jQuery('#action_class2');
    action_class2.val( class_name2);
    action_table.val( class_name);

    action_obj.val(  action_type);
}
window.set_action_class = set_action_class;
function create_multi_change_table(table_name)
{
    const multi_change_present_obj = jQuery("#multi_change_present_"+table_name);
    


    if(!multi_change_present_obj.checked)
    {
        multi_change_present_obj.prop('checked', true);
        const multi_table_create_table_name_obj = jQuery("#multi_table_create_table_name");
        multi_table_create_table_name_obj.val( table_name);
        const multi_table_create_obj = jQuery("#multi_table_create");
        //multi_table_create.onsubmit();
        const elem = document.getElementById('multi_table_create');
        Rails.fire(elem, 'submit');;

    }

}
window.create_multi_change_table = create_multi_change_table;
function on_remove(class_name, id)
{
    on_action(class_name, id, "remove_from_group")
}
window.on_remove = on_remove;

function on_add(class_name, id)
{
    on_action(class_name, id,  "add_to_group")
}
window.on_add = on_add;

function on_suggest(course_id)
{
    wait();
    const action_type = document.getElementById('action_type').value;
    let suggest_div = jQuery('#specific_suggest_variables');
    suggest_div.remove();
    const new_suggest_div = jQuery("<div></div>").attr({id: 'specific_suggest_variables'});
    jQuery('#make_suggestion_div').append(new_suggest_div);
    suggest_div = jQuery('#specific_suggest_variables'); 
    //suggest_div.children().each(function()
    //{
      //  jQuery(this).remove()
    //});
    const suggest_id = jQuery('#suggest_id');
    suggest_id.val( course_id)
    const class_name = document.getElementById('action_class').value;

    const class_name578 = "#"+class_name;
    const action_div = jQuery(class_name578 +'_action_div');

    let term_elt;
    let term_id;
    let previous_suggestion_elt;
    let previous_suggestions;
    let sent_term;
    let sent_previous_suggestions;  

    switch(action_type)
    {
        case 'create_lecture_from_course':
            const schedule_div = action_div.find('schedule_div:first');
            const lecturer_elt = jQuery('#new_lecturer');
            const person_id = lecturer_elt .val();
            term_elt = jQuery('#lecture_term')
            term_id = term_elt.val();
            const day_elt = jQuery('#lecture_day')
            const day_id = day_elt.val();
            const time_elt = jQuery('#lecture_time')
            const lecture_time = time_elt.val();
            const num_lectures_elt = jQuery('#number_of_lectures');
            const number_of_lectures = num_lectures_elt.val();
            const num_classes_elt = jQuery('#number_of_classes');
            const number_of_classes = num_classes_elt.val();

            previous_suggestion_elt = jQuery('#previous_lecture_suggestions')
            previous_suggestions = previous_suggestion_elt.val();


            const sent_lecturer = jQuery("<input></input>").attr({type: 'text', name: 'person_id', value: person_id})
            sent_term = jQuery("<input></input>").attr({type: 'text', name: 'term_id', value: term_id})
            const sent_day = jQuery("<input></input>").attr({type: 'text', name: 'day_id', value: day_id})
             const sent_time = jQuery("<input></input>").attr({ type: 'text', name: 'lecture_time', value: lecture_time });
            const sent_num_lectures = jQuery("<input></input>").attr({type: 'text', name: 'number_of_lectures', value: number_of_lectures})
            const sent_num_classes = jQuery("<input></input>").attr({type: 'text', name: 'number_of_classes', value: number_of_classes})
            sent_previous_suggestions = jQuery("<input></input>").attr({type: 'text', name: 'previous_suggestions', value: previous_suggestions})
            suggest_div.append(sent_lecturer);
            suggest_div.append(sent_term);
            suggest_div.append(sent_day);
            suggest_div.append(sent_time);
            suggest_div.append(sent_num_lectures);
            suggest_div.append(sent_num_classes);
            suggest_div.append(sent_previous_suggestions);
            break;
     case 'create_tutorials_from_course':
            const tutorial_schedule_div = action_div.find('tutorial_schedule_div:first');
            const tutor_elt = jQuery('#new_tutor');
            const tutor_id = tutor_elt .val();
            const term_elt = jQuery('#tutorial_schedule_term')
            const term_id = term_elt.val();
            const num_tutorials_elt = jQuery('#number_of_tutorials');
            const number_of_tutorials = num_tutorials_elt.val();
            const previous_suggestion_elt = jQuery('#previous_tutorial_schedule_suggestions')
            const previous_suggestions = previous_suggestion_elt.val();
            
            const sent_tutor = jQuery("<input></input>").attr({type: 'text', name: 'person_id', value: tutor_id})
            const sent_term = jQuery("<input></input>").attr({type: 'text', name: 'term_id', value: term_id})
            const sent_num_tutorials = jQuery("<input></input>").attr({type: 'text', name: 'number_of_lectures', value: number_of_tutorials})
            const sent_previous_suggestions = jQuery("<input></input>").attr({type: 'text', name: 'previous_suggestions', value: previous_suggestions})
            suggest_div.append(sent_tutor);
            suggest_div.append(sent_term);
            suggest_div.append(sent_num_tutorials);
            suggest_div.append(sent_previous_suggestions);
            break;
    }
    
//    descended_elt = schedule_div.firstDescendant();
//    while(descended_elt != null)
//        {
 //           insert_elt = descended_elt.clone(true);
 ///           suggest_div.append(insert_elt );
  //          descended_elt = descended_elt.next();
  //      }
        const make_suggestion_form = jQuery('#make_suggestion')
        //make_suggestion_form.submit();    
        const elem = document.getElementById('make_suggestion');
        Rails.fire(elem, 'submit');        
}
window.on_suggest = on_suggest;



function SetMaxTutorials()
{
    wait();
    const specific_div = jQuery('#specific_action_variables');
    specific_div.children().each(function(){jQuery(this).remove()});
    const term_elt = jQuery('#max_tutorials_term')
    const term_id = term_elt.val();
    const sent_term = jQuery("<input></input>").attr({type: 'text', name: 'term_id', value: term_id})
    specific_div.append(sent_term);

    const max_tutorials_elt = jQuery('#max_tutorials')
    const max_tutorials = max_tutorials_elt.val();
    const sent_max_tutorials = jQuery("<input></input>").attr({type: 'text', name: 'max_tutorials', value: max_tutorials})
    specific_div.append(sent_max_tutorials);

    const search_results_div_str = "search_results_Person";

    const search_results_div_str666 = "#"+search_results_div_str;
    const search_results_div = jQuery(search_results_div_str666)
    search_results_div.find('.check').each(function(){new_elt = jQuery(this).clone(true); specific_div.append(new_elt)});

  

    const action_obj = jQuery('#action_type')
    action_obj.val( "max_tutorials")
    const action_table = jQuery('#action_class');
    action_table.val( "Person");

    //form_obj = jQuery('#action_form');
  //  form_obj.submit();
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');  

}
window.SetMaxTutorials = SetMaxTutorials;

function MultiUpdate(class_name)
{
    wait();
    const specific_div = jQuery("#specific_action_variables");
    specific_div.children().each(function(){jQuery(this).remove()});
    const action_obj = jQuery("#action_type")
    action_obj.val( "multi_update")
    const action_table = jQuery("#action_class");
    action_table.val( class_name);
    
    const search_results_div_str = "#search_results_" + class_name;
    const search_results_div = jQuery(search_results_div_str);

    insert_specific_div_checks(specific_div, search_results_div, '.check');

    const multi_change_table_div = jQuery("#multi_change_table_div_"+class_name);
    multi_change_table_div.find('.radio').each(function(){new_elt = jQuery(this).clone(true); specific_div.append(new_elt)});
    multi_change_table_div.find('.edit_text').each(function(){new_elt = jQuery(this).clone(true); specific_div.append( new_elt)});
    multi_change_table_div.find('.select').each(function(){new_elt =  jQuery("<input></input>").attr({ type: 'text',   name: jQuery(this).prop("name"),  value: jQuery(this).val()   }); specific_div.append( new_elt)});

    //form_obj = document.getElementById('action_form');
    //form_obj.onsubmit();
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');  
}
window.MultiUpdate = MultiUpdate;

function CreateGroup(class_name)
{
 //   add_group('Person', '11', 204)
    wait();
    const specific_div = jQuery('#specific_action_variables');
    specific_div.children().each(function(){jQuery(this).remove()});
    const group_name_id = "new_group_name_" + class_name;

    const group_name_id687 = "#"+group_name_id;
    const group_name_elt = jQuery(group_name_id687);
    const cloned_group_name_elt = jQuery("<input></input>").attr({type: 'text', name: 'new_group_name', value: group_name_elt.val()})
    group_name_elt.val( "");
    specific_div.append(cloned_group_name_elt);
    const search_results_div_str = "search_results_" + class_name;

    const search_results_div_str692 = "#"+search_results_div_str;
    const search_results_div = jQuery(search_results_div_str692)
    search_results_div.find('.check').each(function(){new_elt = jQuery(this).clone(true); specific_div.append(new_elt)});


    const class_name695 = "#"+class_name;
    const action_div = jQuery(class_name695 +'_action_div');
    action_div.find('.group_privacy').each(function(){new_elt = jQuery(this).clone(true); specific_div.append(new_elt)});


    const action_obj = jQuery('#action_type')
    action_obj.val( "group")
    const action_table = jQuery('#action_class');
    action_table.val( class_name);

    const form_obj = jQuery('#action_form');
 //   form_obj.submit();
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');;
}
window.CreateGroup = CreateGroup;

function SetChecks(ids, check_type)
{
     
     ids.forEach(function(id){
        const check_id = check_type + '_'+id;
        const check_obj = jQuery(check_id);
        if(check_obj[0]!=null)
        {
            check_obj.prop('checked', true);
        }
        
    });
}
window.SetChecks = SetChecks;
function SetTutorialNumber()
{
    wait();
    const specific_div = jQuery("#specific_action_variables");
    specific_div.children().each(function(){jQuery(this).remove()});
    const tutorial_number_id = "#tutorial_number";
    const tutorial_number_elt = jQuery(tutorial_number_id);
    const cloned_tutorial_number_elt = jQuery("<input></input>").attr({type: 'text', name: 'tutorial_number', value: tutorial_number_elt.val()})
    
    specific_div.append( cloned_tutorial_number_elt);
    const search_results_div_str = "#search_results_TutorialSchedule";
    const search_results_div = jQuery(search_results_div_str);
    search_results_div.find('.check').each(function(){new_elt = jQuery(this).clone(true); specific_div.append( new_elt)});

    const action_div = jQuery('#TutorialSchedule_action_div');
  
    const action_obj = jQuery("#action_type");
    action_obj.val( "set_tutorial_number");
    const action_table = jQuery("action_class");
    action_table.val( "TutorialSchedule");

    const form_obj = document.getElementById('action_form');
   // form_obj.onsubmit();
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');;
}
window.SetTutorialNumber = SetTutorialNumber;

function GetRadioValue(radio_list)
{
    const default_ret_val = jQuery(radio_list[0]).val();
    const length = radio_list.length;
    for(i=0;i<length; i++)
    {
        if(jQuery(radio_list[i]).is(':checked') == true)
        {
            return jQuery(radio_list[i]).val();
        }
    }
    return default_ret_val;
}
window.GetRadioValue = GetRadioValue;
function UpdateCollectionStatus()
{
    wait();
    const class_name = "Tutorial"
    const specific_div = jQuery('#specific_action_variables');
    specific_div.children().each(function(){jQuery(this).remove()});

    const search_results_div_str = "search_results_" + class_name;

    const search_results_div_str729 = "#"+search_results_div_str;
    const search_results_div = jQuery(search_results_div_str729)
    search_results_div.find('.check').each(function(){new_elt = jQuery(this).clone(true); specific_div.append(new_elt)});



    const class_name733 = "#"+class_name;
    const action_div = jQuery(class_name733 +'_action_div');
    const radio_list = action_div.find('.collection_status');
    const collection_status = GetRadioValue(radio_list);
    const cloned_collection_status_elt = jQuery("<input></input>").attr({type: 'text', name: 'collection_status', value: collection_status});
    specific_div.append(cloned_collection_status_elt);


    const action_obj = jQuery('#action_type')
    action_obj.val( "update_collection_status")
    const action_table = jQuery('#action_class');
    action_table.val( class_name);

    const form_obj = jQuery('#action_form');
 //   form_obj.submit();
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');



}
window.UpdateCollectionStatus = UpdateCollectionStatus;

function add_group(class_name, group_name, new_group_id)
{
   const external_filter_group_selection_class = ".external_filter_group_selection_"+class_name;
   const external_filter_group_selection_classes = jQuery(external_filter_group_selection_class)
   external_filter_group_selection_classes.each(function()
   {
       insert_option(jQuery(this), group_name, new_group_id);
   });
   const argument_selection_group_span_class = ".argument_selection_group_" + class_name;
   jQuery(argument_selection_group_span_class).each(function()
   {
       const span_sibling = jQuery(this);
       const select_elt = span_sibling.next('select');
       if(select_elt[0] !=null)
           {
       insert_option(select_elt, group_name, new_group_id);
           }
   });   
}
window.add_group = add_group;

function select_remove(table_name,id)
{
   const select_class = "."+ table_name + "_select > option[value="+id+"]";
   jQuery(select_class).each(function()
   { 
       jQuery(this).remove();
   });

}
window.select_remove = select_remove;

function select_update(table_name,id,new_option_str)
{
   
   const count = 0;
 
   const select_class = "."+ table_name + "_select > option[value="+id+"]";
   jQuery(select_class).each(function()
   {
       const count = count + 1;
       jQuery(this).text(new_option_str);
   });
   
   if(count == 0 && new_option_str.length>0)
   {
       insert_new_obj(table_name, new_option_str, id);
   }
     
}
window.select_update = select_update;

function edit_alert(test_str)
{
   alert(test_str);
}
window.edit_alert = edit_alert;

function update_edit_link(table_name, class_name,id)
{
    
    const parent_win = window.opener;
    if(parent_win == null)
        {
            const first_parent = window.open('','main_window');
            if(first_parent != window)
            {
                    const parent_win = first_parent
            }
        }
    if(parent_win!=null)
        {
            const span_aref_obj_str = "a_edit_"+table_name +"_" + id;
            const span_aref_obj = parent_win.document.getElementById(span_aref_obj_str);
            const aref_obj = jQuery(span_aref_obj).find('label:first');
            var new_a = jQuery("<a></a>").attr({ href: '#', onclick: "on_edit('"+table_name+"','"+class_name+"','"+id+"');return false" });

            new_a.html('Edit ')          
            aref_obj.remove();
            span_aref_obj.replaceWith(new_a);  
       }

}
window.update_edit_link = update_edit_link;
function insert_option(select_elt, group_name, new_group_id)
{
    const first_option = select_elt.find('option:first');

    const current_option = first_option;
    const next_option = first_option.next('option');
    while(next_option[0] != null && next_option.text().trim().toLowerCase() < group_name.toLowerCase().trim())
        {
            const current_option = next_option;
            const next_option = current_option.next('option');
        }
        //var new_option = jQuery("<option></option>").attr({'value': new_group_id, 'class': 'group_class_' + new_group_id }) I'm not sure why I'm setting class to group_class_.
        var new_option = jQuery("<option></option>").attr({'value': new_group_id}) 
        new_option.text(group_name);
        new_option.insertAfter(current_option);
}
window.insert_new_obj = insert_new_obj;

function insert_new_obj(class_name, new_obj_name, new_obj_id)
{
    
    
    const select_class = "."+ class_name + "_select:first";
    const done = false;

    jQuery(select_class).each(function()
    {
        const select_elt = jQuery(this);
       if(done)
       {
               return false;
       }

       const select_length = Math.round(select_elt.children().length);
       const n = Math.round(select_elt.children().length/2);
       const offset = n;
       const n_shift = Math.floor(n/2);
       

       
       while(n_shift>0)
       {
          const comp_done = false
          const select_class_n = "."+ class_name + "_select > option:nth-child("+offset+")";
          jQuery(select_class_n).each(function()
          {
              const option_elt = jQuery(this)
              if(comp_done == false)
              {
                  if(option_elt.text().trim().toLowerCase()<new_obj_name.trim().toLowerCase())
                  {
                      const offset = offset + n_shift;
                  }
                  else
                  {
                      const offset = offset - n_shift;
                  }
                  const n_shift = Math.floor(n_shift/2);
              }
              if(offset>=select_length)
              {
          //        offset = select_length -1;
              }
              
              const comp_done = true;
           });
        }
        const select_class_n = "."+ class_name + "_select > option:nth-child("+offset+")";
        jQuery(select_class_n).each(function()
        {
            var option_elt = jQuery(this)
            var new_option = jQuery("<option></option>").attr({'value': new_obj_id })
            new_option.text( new_obj_name);
            if(option_elt.text().trim().toLowerCase()<new_obj_name.trim().toLowerCase())
            {
                new_option.insertAfter(option_elt );
                return false;
            }
            else
            {
                new_option.insertBefore(option_elt );
                return false;
            }
        });


        const done = true;
      // insert_option(select_elt, new_group_name, new_group_id);
    });
    const y = 2;
    
}
window.insert_new_obj = insert_new_obj;

function any_selected(class_name)
{
    var ret_val = false

    const search_results_div_str = "search_results_" + class_name;

    const search_results_div_str792 = "#"+search_results_div_str;
    const search_results_div = jQuery(search_results_div_str792)
    search_results_div.find('.check').each(function(){
        if(jQuery(this).is(':checked'))
        {
            const ret_val = true;
            return ret_val;
        }
        else
            {
                const x = 1;
            }
    });
    return ret_val;
}
window.any_selected = any_selected;

function DeleteMembers(class_name)
{

    if(!any_selected(class_name))
        {
            alert('You have not selected any items for deletion!');
            return;
        }
        wait();

        const confirm_str = "Are you sure you want to delete selected members from " + class_name + " table?";
    var answer = confirm (confirm_str)
if (!answer)
    {
        unwait();

 return;
    }

    const specific_action_variables825 = "#"+"specific_action_variables";
    const specific_div = jQuery(specific_action_variables825);
    specific_div.children().each(function(){jQuery(this).remove()});
    const search_results_div_str = "search_results_" + class_name;

    const search_results_div_str828 = "#"+search_results_div_str;
    const search_results_div = jQuery(search_results_div_str828)
    search_results_div.find('.check').each(function(){new_elt = jQuery(this).clone(true); jQuery(this).removeAttr('id'); specific_div.append(new_elt)});

    const action_obj = jQuery('#action_type')
    action_obj.val( "delete")
    const action_table = jQuery('#action_class');
    action_table.val( class_name);
   
    const form_obj = jQuery('#action_form');
//    form_obj.submit();
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');
   
}
window.DeleteMembers = DeleteMembers;


function on_delete(table_name,id)
{
    const confirm_str = "Are you sure you want to delete " + table_name + " with id = " + id +"?";
    var answer = confirm (confirm_str)
    wait();
if (!answer)
    {
        unwait();

 return;
    }


   const table_obj_str = "delete_table_name"

   const table_obj_str857 = "#"+table_obj_str;
   const table_obj = jQuery(table_obj_str857);
   const id_obj_str = "delete_id"

   const id_obj_str859 = "#"+id_obj_str;
   const id_obj = jQuery(id_obj_str859);
   const form_obj_str = "form_delete";

   const form_obj_str861 = "#"+form_obj_str;
   const form_obj = jQuery(form_obj_str861);
   table_obj.val( table_name);
   id_obj.val( id);
   const ids = new Array;
   ids[0] = id;
   
   //form_obj.submit();
   const elem = document.getElementById(form_obj_str);
   Rails.fire(elem, 'submit');;  
   
}
window.on_delete = on_delete;

var row_count = 0;

function recolour(table_name)
{
    const row_objs_str = ".row_" + table_name
    const row_count = 0;
    jQuery(row_objs_str).each(function(){
        const row = jQuery(this)
        if( row_count  % 2 == 0)
        {
            row.css({
                background:'#CCCCCC'
            });
        }
        else
        {
            row.css({
                background:'#EEEEEE'
            });
        }
        const row_count = row_count +1;
    });

}
window.recolour = recolour;
function on_del(table_name, ids)
{
//    alert_str = "table = " + table_name + ", ids = ";
//   ids.each(function(){alert_str = alert_str + id + ", "});
//    alert(alert_str);
    ids.forEach(function(id){ 
        
        const name = table_name + '_' + id;
        const win_ref = open_windows.get(name);
        
        if(win_ref!=null && !win_ref.closed)
        {
            win_ref.close();
        }
        
        open_windows.unset(name);
        const row_obj_str = ""+ id +"_"+ table_name;

        const row_obj_str907 = "#"+row_obj_str;
        const row_obj = jQuery(row_obj_str907);
        
        if(row_obj[0] != null)
        {
            row_obj.remove();
        }
        
    });
    const row_objs_str = ".row_" + table_name
    const row_count = 0;
    jQuery(row_objs_str).each(function(){
        const row = jQuery(this);
        
        if( row_count  % 2 == 0)
        {
            row.css({background:'#CCCCCC'});
        }
        else
        {
            row.css({background:'#EEEEEE'});
        }
        const row_count = row_count +1;
    });



  //  action_obj_str = "action_" + table_name

  //action_obj_str934 = "#"+action_obj_str;
  //  action_obj  = jQuery(action_obj_str934)
  //  action_obj.val( "delete")


 // form_obj_str937 = "#"+form_obj_str;
  //  form_obj  = jQuery(form_obj_str937);
  //  form_obj.submit();
}
window.on_del = on_del;






function updateRecord(class_name)
{

// alert('updateRecord!');
const x = 1;

}
window.updateRecord = updateRecord;
function documentBlur()
{
  //  on_unload();
}
window.documentBlur = documentBlur;

function editClick(attribute_opener,  opener_id, table_name, class_name, current_id, e)
{
    if(e.shiftKey && current_id != 1)
    {
       open_edit_window(attribute_opener, opener_id, table_name,class_name,current_id);
      //  alert("attribute_name = " + attribute_name + ", data_type = " +data_type +", current_id = "+current_id+ ", shift_key = " + e.shiftKey);
    }
}
window.editClick = editClick;

function editBlur(attribute_name, data_type, unloading)
{
    
    const field_name_obj = jQuery('#field_name');
    const field_value_obj = jQuery('#field_value');
    const field_data_type_obj = jQuery('#field_data_type');
    const closing_flag_obj = jQuery('#closing_flag');
    field_name_obj.val( attribute_name);
    field_data_type_obj.val( data_type);
    if (unloading){
        closing_flag_obj.val('1');
    } else {
        closing_flag_obj.val('0');
    }
    const current_attribute_obj_str = "edit_"+ attribute_name;
    if(attribute_name=="collection_status")
    {
        const radio_elts = jQuery("input.collection_status");
        const found = false;
        const found_val = 0;
        const num_elts = radio_elts.length;
        for(i=0;i<num_elts && !found; i++)
        {
            if(radio_elts[i].is(':checked'))
            {
               const found = true;
               const found_val = radio_elts[i].val();
            }
        }
        field_value_obj.val( found_val);

    }
    else if(data_type.length !=0)
    {
    if(data_type== "boolean")
        {
            const current_attribute_obj_str = current_attribute_obj_str + "_1"
        }



    const current_attribute_obj_str1001 = "#"+current_attribute_obj_str;
    const current_attribute_obj = jQuery(current_attribute_obj_str1001);
    if(data_type != "boolean")
        {
        field_value_obj.val( current_attribute_obj.val());
        }
    else
        {
            field_value_obj.val( current_attribute_obj.is(':checked'));
        }
    }

    const form_obj = jQuery('#update_form');
    const elem = document.getElementById('update_form');
    Rails.fire(elem, 'submit');
    //form_obj.submit();
}
window.editBlur = editBlur;

function editFocus(attribute_name, data_type)
{
    document.getElementById('unload_attribute').value =  attribute_name;
    document.getElementById('unload_data_type').value =  data_type;

}
window.editFocus = editFocus;

function emailBlur()
{
    const table_name = jQuery('#unload_table_name');
    const body_id = table_name.val()+"_body";

    const body_id1027 = "#"+body_id;
    const body_obj = jQuery(body_id1027);
    if(body_obj.get(0) == null)
     {
         return;
    }

    const body_id1032 = "#"+body_id;
    const my_iframes = jQuery(body_id1032).find('iframe');


     const my_iframe = my_iframes[0];
     const iframe_ind = 1;
     while (my_iframe.className!= "yui-editor-editable" && iframe_ind < my_iframes.length)
         {
             const my_iframe = my_iframes[iframe_ind];
             const iframe_ind = iframe_ind + 1;

             }


  const my_body = my_iframe._document().body;
  const text_content = my_body.html();
  if(/&lt;/.test(text_content))
      {
          const text_content = text_content.replace(/&lt;/g,'<');

          }
            if(/&gt;/.test(text_content))
      {
          const text_content = text_content.replace(/&gt;/g,'>');

          }
      
    const body_value_obj = jQuery('#body_value');
   
 
   
   body_value_obj.val( text_content);

    return;

}
window.emailBlur = emailBlur;   
var myEditor = null;
function add_blur_listener()
{
    myEditor.on('editorWindowBlur', function()
{
   myEditor.saveHTML();

   editBlur("","", false)



},myEditor, true);

    }
window.add_blur_listener = add_blur_listener;
function  yahoo_widget()
{

    var myEditor2 = new YAHOO.widget.Editor('edit_body', {
    height: '250px',
    width: '522px',
    dompath: true, //Turns on the bar at the bottom
    animate: true //Animates the opening, closing and moving of Editor windows
});
myEditor2._defaultToolbar.titlebar = false
myEditor2._defaultToolbar.buttonType = 'advanced';
myEditor2.render();

 const myEditor = myEditor2;
add_blur_listener();

const x = 1;



    }
window.yahoo_widget = yahoo_widget;
