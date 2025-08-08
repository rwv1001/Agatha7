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
    const win_load_obj = document.getElementById(('#win_load').slice(1)); //rwv vanilla change
    if(win_load_obj != null){
    //win_load_obj.submit();
    const elem = document.getElementById('win_load');
    Rails.fire(elem, 'submit');;

    }
}
window.onload = on_load;

document.addEventListener('turbo:load', function() { on_load; });

var open_windows = new window.MyHash();

function file_change() {
    // Create a div to disable interaction
    const disable_div = document.createElement('div');
    disable_div.style.position = 'absolute';
    disable_div.style.top = '0';
    disable_div.style.right = '0';
    disable_div.style.width = '100%';
    disable_div.style.height = '100%';
    disable_div.style.backgroundColor = '#ff0000';
    disable_div.style.opacity = '0.0';
    disable_div.style.cursor = 'wait';

    const main_div = document.getElementById('main_div');
    if (main_div && main_div.parentNode) {
        main_div.parentNode.insertBefore(disable_div, main_div.nextSibling);
    }

    const elem = document.getElementById('file_upload');
    Rails.fire(elem, 'submit');
}
window.file_change = file_change;

function file_change2()
{
    const submit_upload_obj = document.getElementById(('#edit_agatha_file').slice(1)); //rwv vanilla change
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
    const unload_attribute_obj = document.getElementById(("#unload_attribute").slice(1)); //rwv vanilla change
    const unload_data_type_obj = document.getElementById(("#unload_data_type").slice(1)); //rwv vanilla change
    const attribute_name = unload_attribute_obj.value;
    const data_type = unload_data_type_obj.value; 
    const unloading = true;
    editBlur(attribute_name, data_type, unloading);
    const parent_win = window.opener;
    const unload_table_obj = document.getElementById(('#unload_table_name').slice(1)); //rwv vanilla change
    const table = unload_table_obj.value; 
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
            if(first_parent != (window))
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
            (id_obj).value =  id; //rwv vanilla change;
            (table_obj).value =  table_name; //rwv vanilla change;
            (attribute_obj).value =  attribute_name; //rwv vanilla change;
            (update_opener_attribute_name_obj).value =  document.getElementById('sensible_update_opener_attribute_name').value; //rwv vanilla change;
            if(update_opener_id_obj!=null){
                (update_opener_id_obj).value =  document.getElementById('sensible_update_opener_id').value; //rwv vanilla change;
            }
            const submit_obj = parent_win.document.getElementById('update_main');
            //submit_obj.submit();
            Rails.fire(submit_obj, 'submit');
        }
}
window.update_parent = update_parent;

function on_edit(table_name, class_name, id) {
    const span_aref_obj_str = "a_edit_" + table_name + "_" + id;
    const span_aref_obj = document.getElementById(span_aref_obj_str);

    // Find the first <a> element inside span_aref_obj
    let aref_obj = null;
    if (span_aref_obj) {
        const links = span_aref_obj.getElementsByTagName('a');
        if (links.length > 0) {
            aref_obj = links[0];
        }
    }
    // Optionally remove or replace the <a> element if needed
    // if (aref_obj) {
    //     aref_obj.remove();
    //     // You can replace with a <label> if needed
    //     // const disabled_a = document.createElement('label');
    //     // disabled_a.className = 'alabel';
    //     // disabled_a.textContent = 'Edit ';
    //     // span_aref_obj.parentNode.replaceChild(disabled_a, span_aref_obj);
    // }

    const attribute_opener = '';
    const opener_id = 1;
    open_windows.set('main', window);
    open_edit_window(attribute_opener, opener_id, table_name, class_name, id);

    const y = 2;
}
window.on_edit = on_edit;

function open_edit_window(attribute_opener, opener_id, table_name,class_name,id)
{

      const new_name = class_name + '_' + id;
   const url = '/'+table_name +'/' + id +'/edit?table_name='+ class_name;
   const new_height = screen.height-20;

    var config_window = 'toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width='+ (screen.width/2 - 16)+ ', height=' + new_height  +',left='+(screen.width/2 +17)+',top=20'

    const stupid_update_opener_attribute_name_obj = document.getElementById(('#stupid_update_opener_attribute_name').slice(1)); //rwv vanilla change
    stupid_update_opener_attribute_name_obj.value = attribute_opener; //rwv vanilla change;
    const stupid_update_opener_id_obj = document.getElementById(('#stupid_update_opener_id').slice(1)); //rwv vanilla change
    stupid_update_opener_id_obj.value =  opener_id; //rwv vanilla change;
    
    const win_ref = window.open(url,new_name, config_window);
    const update_opener_attribute_name_obj = win_ref.document.getElementById('update_opener_attribute_name');
    if(update_opener_attribute_name_obj!=null){
        (update_opener_attribute_name_obj).value =  attribute_opener; //rwv vanilla change;
    }

    const update_opener_id_obj = win_ref.document.getElementById('update_opener_id');
    if(update_opener_id_obj!=null){
        (update_opener_id_obj).value =  opener_id; //rwv vanilla change;
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
    const button_elt = document.getElementById((button_id181 ).slice(1)); //rwv vanilla change
    const group_name_id = "new_group_name_" + class_name;

    const group_name_id183 = "#"+group_name_id;
    const group_name_elt = document.getElementById((group_name_id183).slice(1)); //rwv vanilla change
    const current_str = group_name_elt.value;
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

function setcheck(check_id, value, silent = false)
{
    // Handle both cases: with and without # prefix
    let elementId = check_id;
    if (check_id.startsWith('#')) {
        elementId = check_id.slice(1);
    }
    
    const check_obj = document.getElementById(elementId);
    if (check_obj) {
        check_obj.checked = value;
        return true;
    } else {
        if (!silent) {
            console.warn(`setcheck: Could not find element with ID: ${elementId}`);
        }
        return false;
    }
}
window.setcheck = setcheck;

function setcheckremote(check_id, value, doc)
{
    // Handle both cases: with and without # prefix
    let elementId = check_id;
    if (check_id.startsWith('#')) {
        elementId = check_id.slice(1);
    }
    
    const check_obj = (doc || document).getElementById(elementId);
    if (check_obj) {
        check_obj.checked = value;
    } else {
        console.warn(`setcheckremote: Could not find element with ID: ${elementId}`);
    }
}
window.setcheckremote = setcheckremote;

function on_checkbox_click(row_id, type_name, class_name)
{
    console.log(`🔍 on_checkbox_click called: row_id=${row_id}, type_name=${type_name}, class_name=${class_name}`);
    
    // Only auto-check select box for tables that have exam/compulsory checkboxes
    if (class_name !== "Person" && class_name !== "Lecture") {
        console.log(`❌ Skipping checkbox sync for ${class_name} - not Person or Lecture`);
        return false;
    }
    
    const check_str = class_name +'_'+ type_name +'_'+  row_id
    console.log(`🎯 Looking for checkbox with ID: ${check_str}`);

     const check_str206 = "#"+check_str;
     const check_obj = document.getElementById((check_str206).slice(1)); //rwv vanilla change
     
    if( check_obj != null)
        {
            console.log(`✅ Found ${type_name} checkbox, checked: ${check_obj.checked}`);
            
            // Debug: Let's see what checkboxes actually exist
            console.log(`🔍 DEBUG: Looking for all checkboxes in row ${row_id}:`);
            const allCheckboxes = document.querySelectorAll(`input[type="checkbox"]`);
            const rowCheckboxes = Array.from(allCheckboxes).filter(cb => cb.id && cb.id.includes(row_id));
            rowCheckboxes.forEach(cb => console.log(`   Found checkbox: ID="${cb.id}", name="${cb.name}", class="${cb.className}"`));
            
            const select_box_id = class_name + "_check_"+row_id;
            const select_box = document.getElementById(select_box_id);
            console.log(`🎯 Looking for select box with ID: ${select_box_id}`);
            
            if (select_box) {
                console.log(`✅ Found select box, currently checked: ${select_box.checked}`);
                
                if (check_obj.checked) {
                    // If exam or compulsory is checked, auto-check the select box
                    console.log(`🔄 ${type_name} was checked, auto-checking select box`);
                    select_box.checked = true;
                } else {
                    // If exam or compulsory is unchecked, check if we should uncheck select box
                    // Only uncheck select if BOTH exam and compulsory are unchecked
                    const exam_box = document.getElementById(class_name + "_examcheck_"+row_id); 
                    const compulsory_box = document.getElementById(class_name + "_compulsorycheck_"+row_id);
                    
                    const exam_checked = exam_box ? exam_box.checked : false;
                    const compulsory_checked = compulsory_box ? compulsory_box.checked : false;
                    
                    console.log(`🔍 Checking other boxes - exam: ${exam_checked}, compulsory: ${compulsory_checked}`);
                    
                    if (!exam_checked && !compulsory_checked) {
                        console.log(`🔄 Both exam and compulsory unchecked, unchecking select box`);
                        select_box.checked = false;
                    } else {
                        console.log(`⏸️ Not unchecking select box - other checkboxes still checked`);
                    }
                }
            } else {
                console.log(`❌ Could not find select box with ID: ${select_box_id}`);
                console.log(`🔍 DEBUG: Let's try alternative select box IDs:`);
                // Try different possible ID formats
                const altIds = [
                    `${class_name.toLowerCase()}_check_${row_id}`,
                    `${class_name}_check${row_id}`,
                    `check_${row_id}`,
                    `${row_id}_${class_name}_check`,
                    `${row_id}_check`
                ];
                altIds.forEach(altId => {
                    const altBox = document.getElementById(altId);
                    if (altBox) {
                        console.log(`   ✅ Found alternative select box: ID="${altId}"`);
                    } else {
                        console.log(`   ❌ No checkbox with ID="${altId}"`);
                    }
                });
            }
        } else {
            console.log(`❌ Could not find ${type_name} checkbox with ID: ${check_str}`);
        }
        return check_obj ? check_obj.checked : false;
}
window.on_checkbox_click = on_checkbox_click;

function on_select_check_click(row_id, class_name)
{
    console.log(`🔍 on_select_check_click called: row_id=${row_id}, class_name=${class_name}`);
    
    // Debug: Let's see what checkboxes actually exist for this row
    console.log(`🔍 DEBUG: Looking for all checkboxes in row ${row_id}:`);
    const allCheckboxes = document.querySelectorAll(`input[type="checkbox"]`);
    const rowCheckboxes = Array.from(allCheckboxes).filter(cb => cb.id && cb.id.includes(row_id));
    rowCheckboxes.forEach(cb => console.log(`   Found checkbox: ID="${cb.id}", name="${cb.name}", class="${cb.className}"`));
    
    const select_box_id = class_name +"_check_"+row_id;
    const select_box = document.getElementById(select_box_id);
    console.log(`🎯 Looking for select box with ID: ${select_box_id}`);
    
    // Try alternative ID formats if the first one doesn't work
    let actualSelectBox = select_box;
    if (!actualSelectBox) {
        console.log(`🔍 DEBUG: Trying alternative select box IDs:`);
        const altIds = [
            `${class_name.toLowerCase()}_check_${row_id}`,
            `${class_name}_check${row_id}`,
            `check_${row_id}`,
            `${row_id}_${class_name}_check`,
            `${row_id}_check`
        ];
        
        for (const altId of altIds) {
            const altBox = document.getElementById(altId);
            if (altBox) {
                console.log(`   ✅ Found alternative select box: ID="${altId}"`);
                actualSelectBox = altBox;
                break;
            } else {
                console.log(`   ❌ No checkbox with ID="${altId}"`);
            }
        }
    }
    
    // Only auto-sync exam/compulsory boxes for tables that have them
    if(actualSelectBox && (class_name === "Person" || class_name === "Lecture"))
        {
            console.log(`✅ Found select box, checked: ${actualSelectBox.checked}`);
            
            const compulsory_box_id = class_name + "_compulsorycheck_"+row_id;
            const compulosry_box = document.getElementById(compulsory_box_id);
            console.log(`🎯 Looking for compulsory box with ID: ${compulsory_box_id}`);
            
            const exam_box_id = class_name + "_examcheck_"+row_id;
            const exam_box = document.getElementById(exam_box_id);
            console.log(`🎯 Looking for exam box with ID: ${exam_box_id}`);
            
            if (!actualSelectBox.checked) {
                // If select is unchecked, uncheck both exam and compulsory
                console.log(`🔄 Select box unchecked - unchecking exam and compulsory`);
                if (compulosry_box) {
                    console.log(`✅ Unchecking compulsory box`);
                    compulosry_box.checked = false;
                } else {
                    console.log(`❌ Could not find compulsory box`);
                }
                if (exam_box) {
                    console.log(`✅ Unchecking exam box`);
                    exam_box.checked = false;
                } else {
                    console.log(`❌ Could not find exam box`);
                }
            } else {
                // REMOVED: Don't auto-check exam and compulsory when select is checked
                // This allows users to attend without being examined or compulsory
                console.log(`✅ Select box checked - leaving exam/compulsory as user set them`);
            }
        } else {
            if (!actualSelectBox) {
                console.log(`❌ Could not find select box with any ID format`);
            } else {
                console.log(`❌ Skipping sync for ${class_name} - not Person or Lecture`);
            }
        }
        return actualSelectBox ? actualSelectBox.checked : false;
}
window.on_select_check_click = on_select_check_click;

function on_assign(id) {
    wait();
    const specific_div = document.getElementById('specific_action_variables');
    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }

    // Create and append input for id
    const sent_tutor = document.createElement('input');
    sent_tutor.type = 'text';
    sent_tutor.name = 'id';
    sent_tutor.value = id;
    specific_div.appendChild(sent_tutor);

    const class_name = document.getElementById('action_class').value;
    const search_results_div = document.getElementById('search_results_' + class_name);

    // Clone and append all .check elements
    const checks = search_results_div.querySelectorAll('.check');
    checks.forEach(function(check) {
        const new_elt = check.cloneNode(true);
        new_elt.removeAttribute('id');
        specific_div.appendChild(new_elt);
    });

    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');
}
window.on_assign = on_assign;   

function on_willing(id) {
    wait();
    const specific_div = document.getElementById('specific_action_variables');
    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }

    const sent_willing = document.createElement('input');
    sent_willing.type = 'text';
    sent_willing.name = 'willing_id';
    sent_willing.value = id;
    specific_div.appendChild(sent_willing);

    const class_name = document.getElementById('action_class').value;
    const search_results_div = document.getElementById('search_results_' + class_name);

    const checks = search_results_div.querySelectorAll('.check');
    checks.forEach(function(check) {
        const new_elt = check.cloneNode(true);
        new_elt.removeAttribute('id');
        specific_div.appendChild(new_elt);
    });

    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');
}
window.on_willing = on_willing;

function on_agatha_send(id, test_flag) {
    wait();
    const specific_div = document.getElementById('specific_action_variables');
    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }

    const sent_email = document.createElement('input');
    sent_email.type = 'text';
    sent_email.name = 'email_id';
    sent_email.value = id;

    const sent_test_flag = document.createElement('input');
    sent_test_flag.type = 'text';
    sent_test_flag.name = 'test_flag';
    sent_test_flag.value = test_flag;

    specific_div.appendChild(sent_email);
    specific_div.appendChild(sent_test_flag);

    document.getElementById('action_type').value = "send_email";

    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');
}

window.on_agatha_send = on_agatha_send;

function on_sends(test_flag) {
    wait();
    const specific_div = document.getElementById('specific_action_variables');
    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }

    const search_results_div = document.getElementById('search_results_AgathaEmail');
    const checks = search_results_div.querySelectorAll('.check');
    checks.forEach(function(check) {
        const new_elt = check.cloneNode(true);
        new_elt.removeAttribute('id');
        specific_div.appendChild(new_elt);
    });

    const sent_test_flag = document.createElement('input');
    sent_test_flag.type = 'text';
    sent_test_flag.name = 'test_flag';
    sent_test_flag.value = test_flag;
    specific_div.appendChild(sent_test_flag);

    document.getElementById('action_type').value = "send_emails";
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');
}
window.on_sends = on_sends;

function on_create_send(id) {
    wait();
    const specific_div = document.getElementById('specific_action_variables');
    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }

    document.getElementById('action_type').value = "create_send_email_from_template";
    const class_name = document.getElementById('action_class').value;

    const action_div = document.getElementById(class_name + '_action_div');
    // email_template_div is not used

    const term_elt = document.getElementById('email_template_term');
    const term_id = term_elt.value;
    const course_elt = document.getElementById('email_template_course');
    const course_id = course_elt.value;

    const sent_template = document.createElement('input');
    sent_template.type = 'text';
    sent_template.name = 'email_template_id';
    sent_template.value = id;

    const sent_term = document.createElement('input');
    sent_term.type = 'text';
    sent_term.name = 'term_id';
    sent_term.value = term_id;

    const sent_course = document.createElement('input');
    sent_course.type = 'text';
    sent_course.name = 'course_id';
    sent_course.value = course_id;

    specific_div.appendChild(sent_template);
    specific_div.appendChild(sent_term);
    specific_div.appendChild(sent_course);

    const class_name2 = document.getElementById('action_class2').value;
    const search_results_div = document.getElementById('search_results_' + class_name2);
    const checks = search_results_div.querySelectorAll('.check');
    checks.forEach(function(check) {
        const new_elt = check.cloneNode(true);
        new_elt.removeAttribute('id');
        specific_div.appendChild(new_elt);
    });

    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');
}
window.on_create_send = on_create_send;

function on_create(id) {
    wait();
    const specific_div = document.getElementById('specific_action_variables');
    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }
    const action_type = document.getElementById('action_type').value;
    switch (action_type) {
        case 'create_lecture_from_course': {
            const class_name = document.getElementById('action_class').value;
            const lecturer_elt = document.getElementById('new_lecturer');
            const person_id = lecturer_elt.value;
            const term_elt = document.getElementById('lecture_term');
            const term_id = term_elt.value;
            const day_elt = document.getElementById('lecture_day');
            const day_id = day_elt.value;
            const time_elt = document.getElementById('lecture_time');
            const lecture_time = time_elt.value;
            const num_lectures_elt = document.getElementById('number_of_lectures');
            const number_of_lectures = num_lectures_elt.value;
            const num_classes_elt = document.getElementById('number_of_classes');
            const number_of_classes = num_classes_elt.value;
            const previous_suggestion_elt = document.getElementById('previous_lecture_suggestions');
            const previous_suggestions = previous_suggestion_elt.value;

            // Create and append inputs
            const sent_course = document.createElement('input');
            sent_course.type = 'text';
            sent_course.name = 'course_id';
            sent_course.value = id;

            const sent_lecturer = document.createElement('input');
            sent_lecturer.type = 'text';
            sent_lecturer.name = 'person_id';
            sent_lecturer.value = person_id;

            const sent_term = document.createElement('input');
            sent_term.type = 'text';
            sent_term.name = 'term_id';
            sent_term.value = term_id;

            const sent_day = document.createElement('input');
            sent_day.type = 'text';
            sent_day.name = 'day_id';
            sent_day.value = day_id;

            const sent_time = document.createElement('input');
            sent_time.type = 'text';
            sent_time.name = 'lecture_time';
            sent_time.value = lecture_time;

            const sent_num_lectures = document.createElement('input');
            sent_num_lectures.type = 'text';
            sent_num_lectures.name = 'number_of_lectures';
            sent_num_lectures.value = number_of_lectures;

            const sent_num_classes = document.createElement('input');
            sent_num_classes.type = 'text';
            sent_num_classes.name = 'number_of_classes';
            sent_num_classes.value = number_of_classes;

            const sent_previous_suggestions = document.createElement('input');
            sent_previous_suggestions.type = 'text';
            sent_previous_suggestions.name = 'previous_suggestions';
            sent_previous_suggestions.value = previous_suggestions;

            specific_div.appendChild(sent_course);
            specific_div.appendChild(sent_lecturer);
            specific_div.appendChild(sent_term);
            specific_div.appendChild(sent_day);
            specific_div.appendChild(sent_time);
            specific_div.appendChild(sent_num_lectures);
            specific_div.appendChild(sent_num_classes);
            specific_div.appendChild(sent_previous_suggestions);
            break;
        }
        case 'create_tutorials_from_course': {
            const class_name = document.getElementById('action_class').value;
            const tutor_elt = document.getElementById('new_tutor');
            const tutor_id = tutor_elt.value;
            const term_elt = document.getElementById('tutorial_schedule_term');
            const term_id = term_elt.value;
            const num_tutorials_elt = document.getElementById('number_of_tutorials');
            const number_of_tutorials = num_tutorials_elt.value;
            const tutorial_class_size_elt = document.getElementById('tutorial_class_size');
            const tutorial_class_size = tutorial_class_size_elt.value;
            const collection_required_elt = document.getElementById('collection_required');
            const collection_required = collection_required_elt.checked ? "1" : "0";
            const previous_suggestion_elt = document.getElementById('previous_tutorial_schedule_suggestions');
            const previous_suggestions = previous_suggestion_elt.value;

            // Create and append inputs
            const sent_course = document.createElement('input');
            sent_course.type = 'text';
            sent_course.name = 'course_id';
            sent_course.value = id;

            const sent_tutor = document.createElement('input');
            sent_tutor.type = 'text';
            sent_tutor.name = 'tutor_id';
            sent_tutor.value = tutor_id;

            const sent_term = document.createElement('input');
            sent_term.type = 'text';
            sent_term.name = 'term_id';
            sent_term.value = term_id;

            const sent_num_tutorials = document.createElement('input');
            sent_num_tutorials.type = 'text';
            sent_num_tutorials.name = 'number_of_tutorials';
            sent_num_tutorials.value = number_of_tutorials;

            const sent_tutorial_class_size = document.createElement('input');
            sent_tutorial_class_size.type = 'text';
            sent_tutorial_class_size.name = 'tutorial_class_size';
            sent_tutorial_class_size.value = tutorial_class_size;

            const sent_collection_required = document.createElement('input');
            sent_collection_required.type = 'text';
            sent_collection_required.name = 'collection_required';
            sent_collection_required.value = collection_required;

            const sent_previous_suggestions = document.createElement('input');
            sent_previous_suggestions.type = 'text';
            sent_previous_suggestions.name = 'previous_suggestions';
            sent_previous_suggestions.value = previous_suggestions;

            specific_div.appendChild(sent_course);
            specific_div.appendChild(sent_tutor);
            specific_div.appendChild(sent_term);
            specific_div.appendChild(sent_num_tutorials);
            specific_div.appendChild(sent_tutorial_class_size);
            specific_div.appendChild(sent_collection_required);
            specific_div.appendChild(sent_previous_suggestions);

            const class_name2 = document.getElementById('action_class2').value;
            const search_results_div = document.getElementById('search_results_' + class_name2);
            const checks = search_results_div.querySelectorAll('.check');
            checks.forEach(function(check) {
                const new_elt = check.cloneNode(true);
                new_elt.removeAttribute('id');
                specific_div.appendChild(new_elt);
            });
            break;
        }
        case 'create_email_from_template': {
            const class_name = document.getElementById('action_class').value;
            const term_elt = document.getElementById('email_template_term');
            const term_id = term_elt.value;
            const course_elt = document.getElementById('email_template_course');
            const course_id = course_elt.value;

            const sent_template = document.createElement('input');
            sent_template.type = 'text';
            sent_template.name = 'email_template_id';
            sent_template.value = id;

            const sent_term = document.createElement('input');
            sent_term.type = 'text';
            sent_term.name = 'term_id';
            sent_term.value = term_id;

            const sent_course = document.createElement('input');
            sent_course.type = 'text';
            sent_course.name = 'course_id';
            sent_course.value = course_id;

            specific_div.appendChild(sent_template);
            specific_div.appendChild(sent_term);
            specific_div.appendChild(sent_course);

            const class_name2 = document.getElementById('action_class2').value;
            const search_results_div = document.getElementById('search_results_' + class_name2);
            const checks = search_results_div.querySelectorAll('.check');
            checks.forEach(function(check) {
                const new_elt = check.cloneNode(true);
                new_elt.removeAttribute('id');
                specific_div.appendChild(new_elt);
            });
            break;
        }
    }
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');
}
window.on_create = on_create;

function on_add_attendees(lecture_id)
{

}
window.on_add_attendees = on_add_attendees;


function insert_specific_div_checks(specific_div, search_results_div, check_class) {
    console.log("🔍 insert_specific_div_checks called with check_class:", check_class);
    const checks = search_results_div.querySelectorAll(check_class);
    console.log("🔍 Found", checks.length, "checkboxes with class", check_class);
    
    checks.forEach(function(check, index) {
        console.log("🔍 Processing checkbox", index, "- name:", check.name, "value:", check.value, "checked:", check.checked);
        const new_elt = check.cloneNode(true);
        new_elt.removeAttribute('id');
        specific_div.appendChild(new_elt);
        console.log("🔍 Cloned and appended checkbox", index);
    });
    
    console.log("🔍 insert_specific_div_checks completed for", check_class);
}
window.insert_specific_div_checks = insert_specific_div_checks;

function insert_specific_div_multi_values(specific_div, class_name2)
{

}
window.insert_specific_div_multi_values = insert_specific_div_multi_values;

function on_action(id) {
    wait();
    const action_type = document.getElementById('action_type').value;
    const specific_div = document.getElementById('specific_action_variables');
    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }
    const class_name2 = document.getElementById('action_class2').value;
    const search_results_div = document.getElementById('search_results_' + class_name2);

    // Create and append id input
    const id_elt = document.createElement('input');
    id_elt.type = 'text';
    id_elt.name = 'id';
    id_elt.value = id;
    specific_div.appendChild(id_elt);

    switch (action_type) {
        case 'add_to_group':
        case 'remove_from_group':
        case 'add_to_groups':
        case 'remove_from_groups':
        case 'attach_files':
        case 'attach_to_emails':
            insert_specific_div_checks(specific_div, search_results_div, '.check');
            break;
        case 'add_to_lectures':
            insert_specific_div_checks(specific_div, search_results_div, '.check');
            insert_specific_div_checks(specific_div, search_results_div, '.examcheck');
            insert_specific_div_checks(specific_div, search_results_div, '.compulsorycheck');
            break;
    }
    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');
}
window.on_action = on_action;
function set_suggestion_class(suggest_type_str, suggestion_class)
{
    const suggest_obj = document.getElementById(('#suggest_type').slice(1)); //rwv vanilla change
    suggest_obj.value =  suggest_type_str; //rwv vanilla change;
    const suggest_class_obj = document.getElementById(('#suggest_class').slice(1)); //rwv vanilla change
    suggest_class_obj.value =  suggestion_class; //rwv vanilla change;

}
window.set_suggestion_class = set_suggestion_class;
function set_action_class(class_name, class_name2, action_type)
{
    const action_obj = document.getElementById(('#action_type').slice(1)); //rwv vanilla change

    const action_table = document.getElementById(('#action_class').slice(1)); //rwv vanilla change
    const action_class2 = document.getElementById(('#action_class2').slice(1)); //rwv vanilla change
    action_class2.value =  class_name2; //rwv vanilla change;
    action_table.value =  class_name; //rwv vanilla change;

    action_obj.value =   action_type; //rwv vanilla change;
}
window.set_action_class = set_action_class;
function create_multi_change_table(table_name)
{
    const multi_change_present_obj = document.getElementById(("#multi_change_present_"+table_name).slice(1)); //rwv vanilla change
    


    if(!multi_change_present_obj.checked)
    {
        multi_change_present_obj.checked = true;
        const multi_table_create_table_name_obj = document.getElementById(("#multi_table_create_table_name").slice(1)); //rwv vanilla change
        multi_table_create_table_name_obj.value =  table_name; //rwv vanilla change;
        const multi_table_create_obj = document.getElementById(("#multi_table_create").slice(1)); //rwv vanilla change
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

function on_suggest(course_id) {
    wait();

    const action_type = document.getElementById('action_type').value;
    let suggest_div = document.getElementById('specific_suggest_variables');
    if (suggest_div) {
        suggest_div.remove();
    }
    const new_suggest_div = document.createElement('div');
    new_suggest_div.id = 'specific_suggest_variables';
    document.getElementById('make_suggestion_div').appendChild(new_suggest_div);
    suggest_div = document.getElementById('specific_suggest_variables');

    const suggest_id = document.getElementById('suggest_id');
    suggest_id.value = course_id;

    const class_name = document.getElementById('action_class').value;
    const action_div = document.getElementById(class_name + '_action_div');

    switch (action_type) {
        case 'create_lecture_from_course': {
            // schedule_div = action_div.querySelector('schedule_div:first-child'); // Not used
            const lecturer_elt = document.getElementById('new_lecturer');
            const person_id = lecturer_elt.value;
            const term_elt = document.getElementById('lecture_term');
            const term_id = term_elt.value;
            const day_elt = document.getElementById('lecture_day');
            const day_id = day_elt.value;
            const time_elt = document.getElementById('lecture_time');
            const lecture_time = time_elt.value;
            const num_lectures_elt = document.getElementById('number_of_lectures');
            const number_of_lectures = num_lectures_elt.value;
            const num_classes_elt = document.getElementById('number_of_classes');
            const number_of_classes = num_classes_elt.value;
            const previous_suggestion_elt = document.getElementById('previous_lecture_suggestions');
            const previous_suggestions = previous_suggestion_elt.value;

            const sent_lecturer = document.createElement('input');
            sent_lecturer.type = 'text';
            sent_lecturer.name = 'person_id';
            sent_lecturer.value = person_id;

            const sent_term = document.createElement('input');
            sent_term.type = 'text';
            sent_term.name = 'term_id';
            sent_term.value = term_id;

            const sent_day = document.createElement('input');
            sent_day.type = 'text';
            sent_day.name = 'day_id';
            sent_day.value = day_id;

            const sent_time = document.createElement('input');
            sent_time.type = 'text';
            sent_time.name = 'lecture_time';
            sent_time.value = lecture_time;

            const sent_num_lectures = document.createElement('input');
            sent_num_lectures.type = 'text';
            sent_num_lectures.name = 'number_of_lectures';
            sent_num_lectures.value = number_of_lectures;

            const sent_num_classes = document.createElement('input');
            sent_num_classes.type = 'text';
            sent_num_classes.name = 'number_of_classes';
            sent_num_classes.value = number_of_classes;

            const sent_previous_suggestions = document.createElement('input');
            sent_previous_suggestions.type = 'text';
            sent_previous_suggestions.name = 'previous_suggestions';
            sent_previous_suggestions.value = previous_suggestions;

            suggest_div.appendChild(sent_lecturer);
            suggest_div.appendChild(sent_term);
            suggest_div.appendChild(sent_day);
            suggest_div.appendChild(sent_time);
            suggest_div.appendChild(sent_num_lectures);
            suggest_div.appendChild(sent_num_classes);
            suggest_div.appendChild(sent_previous_suggestions);
            break;
        }
        case 'create_tutorials_from_course': {
            // tutorial_schedule_div = action_div.querySelector('tutorial_schedule_div:first-child'); // Not used
            const tutor_elt = document.getElementById('new_tutor');
            const tutor_id = tutor_elt.value;
            const term_elt = document.getElementById('tutorial_schedule_term');
            const term_id = term_elt.value;
            const num_tutorials_elt = document.getElementById('number_of_tutorials');
            const number_of_tutorials = num_tutorials_elt.value;
            const previous_suggestion_elt = document.getElementById('previous_tutorial_schedule_suggestions');
            const previous_suggestions = previous_suggestion_elt.value;

            const sent_tutor = document.createElement('input');
            sent_tutor.type = 'text';
            sent_tutor.name = 'person_id';
            sent_tutor.value = tutor_id;

            const sent_term = document.createElement('input');
            sent_term.type = 'text';
            sent_term.name = 'term_id';
            sent_term.value = term_id;

            const sent_num_tutorials = document.createElement('input');
            sent_num_tutorials.type = 'text';
            sent_num_tutorials.name = 'number_of_lectures';
            sent_num_tutorials.value = number_of_tutorials;

            const sent_previous_suggestions = document.createElement('input');
            sent_previous_suggestions.type = 'text';
            sent_previous_suggestions.name = 'previous_suggestions';
            sent_previous_suggestions.value = previous_suggestions;

            suggest_div.appendChild(sent_tutor);
            suggest_div.appendChild(sent_term);
            suggest_div.appendChild(sent_num_tutorials);
            suggest_div.appendChild(sent_previous_suggestions);
            break;
        }
    }

    const elem = document.getElementById('make_suggestion');
    Rails.fire(elem, 'submit');
}
window.on_suggest = on_suggest;



function SetMaxTutorials() {
    wait();

    const specific_div = document.getElementById('specific_action_variables');
    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }

    const term_elt = document.getElementById('max_tutorials_term');
    const term_id = term_elt.value;
    const sent_term = document.createElement('input');
    sent_term.type = 'text';
    sent_term.name = 'term_id';
    sent_term.value = term_id;
    specific_div.appendChild(sent_term);

    const max_tutorials_elt = document.getElementById('max_tutorials');
    const max_tutorials = max_tutorials_elt.value;
    const sent_max_tutorials = document.createElement('input');
    sent_max_tutorials.type = 'text';
    sent_max_tutorials.name = 'max_tutorials';
    sent_max_tutorials.value = max_tutorials;
    specific_div.appendChild(sent_max_tutorials);

    const search_results_div = document.getElementById('search_results_Person');
    const checks = search_results_div.querySelectorAll('.check');
    checks.forEach(function(check) {
        const new_elt = check.cloneNode(true);
        specific_div.appendChild(new_elt);
    });

    const action_obj = document.getElementById('action_type');
    action_obj.value = "max_tutorials";
    const action_table = document.getElementById('action_class');
    action_table.value = "Person";

    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');
}
window.SetMaxTutorials = SetMaxTutorials;

function MultiUpdate(class_name) {
    wait();

    const specific_div = document.getElementById("specific_action_variables");
    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }

    const action_obj = document.getElementById("action_type");
    action_obj.value = "multi_update";

    const action_table = document.getElementById("action_class");
    action_table.value = class_name;

    const search_results_div = document.getElementById("search_results_" + class_name);
    const checks = search_results_div.querySelectorAll('.check');
    checks.forEach(check => {
        const cloned = check.cloneNode(true);
        specific_div.appendChild(cloned);
    });

    const multi_change_table_div = document.getElementById("multi_change_table_div_" + class_name);

    // Clone radio buttons
    const radios = multi_change_table_div.querySelectorAll('.radio');
    radios.forEach(radio => {
        const cloned = radio.cloneNode(true);
        specific_div.appendChild(cloned);
    });

    // Clone text inputs
    const edit_texts = multi_change_table_div.querySelectorAll('.edit_text');
    edit_texts.forEach(textInput => {
        const cloned = textInput.cloneNode(true);
        specific_div.appendChild(cloned);
    });

    // For selects, create a new input with the same name and value
    const selects = multi_change_table_div.querySelectorAll('.select');
    selects.forEach(select => {
        const input = document.createElement("input");
        input.type = "text";
        input.name = select.name;
        input.value = select.value;
        specific_div.appendChild(input);
    });

    const elem = document.getElementById('action_form');
    Rails.fire(elem, 'submit');
}
window.MultiUpdate = MultiUpdate;

function CreateGroup(class_name) {
    wait();

    const specific_div = document.getElementById('specific_action_variables');

    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }

    // Get group name input
    const group_name_id = "new_group_name_" + class_name;
    const group_name_elt = document.getElementById(group_name_id);

    // Clone the value into a new input
    const cloned_group_name_elt = document.createElement("input");
    cloned_group_name_elt.type = "text";
    cloned_group_name_elt.name = "new_group_name";
    cloned_group_name_elt.value = group_name_elt.value;

    group_name_elt.value = "";
    specific_div.appendChild(cloned_group_name_elt);

    // Clone checked elements
    const search_results_div = document.getElementById("search_results_" + class_name);
    const checks = search_results_div.querySelectorAll('.check');
    checks.forEach((checkbox) => {
        const cloned = checkbox.cloneNode(true);
        specific_div.appendChild(cloned);
    });

    // Clone group privacy elements
    const action_div = document.getElementById(class_name + '_action_div');
    const privacies = action_div.querySelectorAll('.group_privacy');
    privacies.forEach((privacy) => {
        const cloned = privacy.cloneNode(true);
        specific_div.appendChild(cloned);
    });

    // Set action fields
    document.getElementById('action_type').value = "group";
    document.getElementById('action_class').value = class_name;

    // Submit the form via Rails UJS
    const form = document.getElementById('action_form');
    Rails.fire(form, 'submit');
}

window.CreateGroup = CreateGroup;

function SetChecks(ids, check_type) {
    ids.forEach(function(id) {
        const check_id = check_type + '_' + id;
        const check_obj = document.getElementById(check_id);
        if (check_obj) {
            check_obj.checked = true;
        }
    });
}
window.SetChecks = SetChecks;
function SetTutorialNumber() {
    wait();

    const specific_div = document.getElementById("specific_action_variables");

    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }

    // Get tutorial number input and clone it as a new hidden input
    const tutorial_number_elt = document.getElementById("tutorial_number");
    const cloned_tutorial_number_elt = document.createElement("input");
    cloned_tutorial_number_elt.type = "text";
    cloned_tutorial_number_elt.name = "tutorial_number";
    cloned_tutorial_number_elt.value = tutorial_number_elt.value;
    specific_div.appendChild(cloned_tutorial_number_elt);

    // Clone all checkboxes
    const search_results_div = document.getElementById("search_results_TutorialSchedule");
    const checkboxes = search_results_div.querySelectorAll('.check');
    checkboxes.forEach((checkbox) => {
        const cloned = checkbox.cloneNode(true);
        specific_div.appendChild(cloned);
    });

    // Set action type and table name
    const action_obj = document.getElementById("action_type");
    action_obj.value = "set_tutorial_number";

    const action_table = document.getElementById("action_class");
    action_table.value = "TutorialSchedule";

    // Submit the form via Rails UJS
    const form = document.getElementById("action_form");
    Rails.fire(form, 'submit');
}

window.SetTutorialNumber = SetTutorialNumber;

function GetRadioValue(radio_list) {
    if (!radio_list || radio_list.length === 0) return null;
    let default_ret_val = radio_list[0].value;
    for (let i = 0; i < radio_list.length; i++) {
        if (radio_list[i].checked) {
            return radio_list[i].value;
        }
    }
    return default_ret_val;
}
window.GetRadioValue = GetRadioValue;
function UpdateCollectionStatus() {
    wait();

    const class_name = "Tutorial";
    const specific_div = document.getElementById('specific_action_variables');

    // Remove all children
    while (specific_div.firstChild) {
        specific_div.removeChild(specific_div.firstChild);
    }

    const search_results_div = document.getElementById("search_results_" + class_name);

    // Clone all checkboxes and append to specific_div
    const checks = search_results_div.querySelectorAll('.check');
    checks.forEach(check => {
        const cloned = check.cloneNode(true);
        specific_div.appendChild(cloned);
    });

    const action_div = document.getElementById(class_name + '_action_div');

    // Get radio buttons with class "collection_status"
    const radio_list = action_div.querySelectorAll('.collection_status');
    const collection_status = GetRadioValue(radio_list);

    // Create new input for collection status
    const cloned_input = document.createElement('input');
    cloned_input.type = 'text';
    cloned_input.name = 'collection_status';
    cloned_input.value = collection_status;
    specific_div.appendChild(cloned_input);

    // Set action_type
    const action_obj = document.getElementById('action_type');
    action_obj.value = "update_collection_status";

    // Set class name
    const action_table = document.getElementById('action_class');
    action_table.value = class_name;

    // Submit form via Rails UJS
    const form = document.getElementById('action_form');
    Rails.fire(form, 'submit');
}

window.UpdateCollectionStatus = UpdateCollectionStatus;

function add_group(class_name, group_name, new_group_id) {
  const external_filter_group_selection_class = "external_filter_group_selection_" + class_name;
  const group_select_elements = document.getElementsByClassName(external_filter_group_selection_class);

  Array.from(group_select_elements).forEach(function (select) {
    insert_option(select, group_name, new_group_id);
  });

  const argument_group_class = "argument_selection_group_" + class_name;
  const span_elements = document.getElementsByClassName(argument_group_class);

  Array.from(span_elements).forEach(function (span) {
    const nextSibling = span.nextElementSibling;
    if (nextSibling && nextSibling.tagName.toLowerCase() === 'select') {
      insert_option(nextSibling, group_name, new_group_id);
    }
  });
}

window.add_group = add_group;

function select_remove(table_name, id) {
    const selectElements = document.getElementsByClassName(table_name + "_select");
    for (let i = 0; i < selectElements.length; i++) {
        const selectElt = selectElements[i];
        for (let j = selectElt.options.length - 1; j >= 0; j--) {
            const option = selectElt.options[j];
            if (option.value == id) {
                selectElt.remove(j);
            }
        }
    }
}
window.select_remove = select_remove;

function select_update(table_name, id, new_option_str) {
    let count = 0;
    const selectElements = document.getElementsByClassName(table_name + "_select");
    for (let i = 0; i < selectElements.length; i++) {
        const selectElt = selectElements[i];
        for (let j = 0; j < selectElt.options.length; j++) {
            const option = selectElt.options[j];
            if (option.value == id) {
                count++;
                option.text = new_option_str;
            }
        }
    }
    if (count === 0 && new_option_str.length > 0) {
        insert_new_obj(table_name, new_option_str, id);
    }
}
window.select_update = select_update;

function edit_alert(test_str)
{
   alert(test_str);
}
window.edit_alert = edit_alert;

function update_edit_link(table_name, class_name, id) {
    const parent_win = window.opener;
    let win = parent_win;
    if (win == null) {
        const first_parent = window.open('', 'main_window');
        if (first_parent != window) {
            win = first_parent;
        }
    }
    if (win != null) {
        const span_aref_obj_str = "a_edit_" + table_name + "_" + id;
        const span_aref_obj = win.document.getElementById(span_aref_obj_str);

        // Find the first label element inside span_aref_obj
        let aref_obj = null;
        if (span_aref_obj) {
            const labels = span_aref_obj.getElementsByTagName('label');
            if (labels.length > 0) {
                aref_obj = labels[0];
            }
        }

        // Create new <a> element
        const new_a = win.document.createElement('a');
        new_a.href = '#';
        new_a.onclick = function () {
            win.on_edit(table_name, class_name, id);
            return false;
        };
        new_a.textContent = 'Edit ';

        // Remove the label and replace the span with the new <a>
        if (aref_obj && span_aref_obj) {
            aref_obj.remove();
            span_aref_obj.parentNode.replaceChild(new_a, span_aref_obj);
        }
    }
}
window.update_edit_link = update_edit_link;
function insert_option(select_elt, group_name, new_group_id) {
    // Find the correct position to insert the new option
    let insertBeforeOption = null;
    for (let i = 0; i < select_elt.options.length; i++) {
        const option = select_elt.options[i];
        if (option.text.trim().toLowerCase() > group_name.trim().toLowerCase()) {
            insertBeforeOption = option;
            break;
        }
    }

    // Create new option element
    const new_option = document.createElement("option");
    new_option.value = new_group_id;
    new_option.text = group_name;

    if (insertBeforeOption) {
        select_elt.insertBefore(new_option, insertBeforeOption);
    } else {
        select_elt.appendChild(new_option);
    }
}
window.insert_new_obj = insert_new_obj;

function insert_new_obj(class_name, new_obj_name, new_obj_id) {
    const selectElements = document.getElementsByClassName(class_name + "_select");
    if (selectElements.length === 0) return;

    // Use the first select element
    const selectElt = selectElements[0];

    // Create new option
    const newOption = document.createElement("option");
    newOption.value = new_obj_id;
    newOption.text = new_obj_name;

    let inserted = false;
    for (let i = 0; i < selectElt.options.length; i++) {
        const option = selectElt.options[i];
        if (option.text.trim().toLowerCase() > new_obj_name.trim().toLowerCase()) {
            selectElt.insertBefore(newOption, option);
            inserted = true;
            break;
        }
    }
    if (!inserted) {
        selectElt.appendChild(newOption);
    }
}
window.insert_new_obj = insert_new_obj;

function any_selected(class_name) {
    const search_results_div = document.getElementById("search_results_" + class_name);
    if (!search_results_div) return false;

    const checkboxes = search_results_div.querySelectorAll('.check');
    for (let i = 0; i < checkboxes.length; i++) {
        if (checkboxes[i].checked) {
            return true;
        }
    }
    return false;
}
window.any_selected = any_selected;

function DeleteMembers(class_name) {
  if (!any_selected(class_name)) {
    alert('You have not selected any items for deletion!');
    return;
  }

  wait();

  const confirm_str = "Are you sure you want to delete selected members from " + class_name + " table?";
  const answer = confirm(confirm_str);
  if (!answer) {
    unwait();
    return;
  }

  const specific_div = document.getElementById("specific_action_variables");
  while (specific_div.firstChild) {
    specific_div.removeChild(specific_div.firstChild);
  }

  const search_results_div = document.getElementById("search_results_" + class_name);
  const checkboxes = search_results_div.querySelectorAll('.check');

  checkboxes.forEach(function (checkbox) {
    const new_elt = checkbox.cloneNode(true);
    new_elt.removeAttribute('id');
    specific_div.appendChild(new_elt);
  });

  const action_obj = document.getElementById('action_type');
  action_obj.value = "delete";

  const action_table = document.getElementById('action_class');
  action_table.value = class_name;

  const form_elem = document.getElementById('action_form');
  Rails.fire(form_elem, 'submit');
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
   const table_obj = document.getElementById((table_obj_str857).slice(1)); //rwv vanilla change
   const id_obj_str = "delete_id"

   const id_obj_str859 = "#"+id_obj_str;
   const id_obj = document.getElementById((id_obj_str859).slice(1)); //rwv vanilla change
   const form_obj_str = "form_delete";

   const form_obj_str861 = "#"+form_obj_str;
   const form_obj = document.getElementById((form_obj_str861).slice(1)); //rwv vanilla change
   table_obj.value =  table_name; //rwv vanilla change;
   id_obj.value =  id; //rwv vanilla change;
   const ids = new Array;
   ids[0] = id;
   
   //form_obj.submit();
   const elem = document.getElementById(form_obj_str);
   Rails.fire(elem, 'submit');;  
   
}
window.on_delete = on_delete;

var row_count = 0;

function recolour(table_name) {
    const rows = document.getElementsByClassName("row_" + table_name);
    for (let i = 0; i < rows.length; i++) {
        rows[i].style.background = i % 2 === 0 ? '#CCCCCC' : '#EEEEEE';
    }
}
window.recolour = recolour;
function on_del(table_name, ids) {
  ids.forEach(function(id) {
    const name = table_name + '_' + id;
    const win_ref = open_windows.get(name);

    if (win_ref != null && !win_ref.closed) {
      win_ref.close();
    }

    open_windows.unset(name);

    const rowId = `${id}_${table_name}`;
    const rowEl = document.getElementById(rowId);

    if (rowEl) {
      rowEl.remove();
    }
  });

  const rowClass = "row_" + table_name;
  const rows = document.getElementsByClassName(rowClass);

  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    row.style.background = i % 2 === 0 ? '#CCCCCC' : '#EEEEEE';
  }
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

function editBlur(attribute_name, data_type, unloading) {
    const field_name_obj = document.getElementById('field_name');
    const field_value_obj = document.getElementById('field_value');
    const field_data_type_obj = document.getElementById('field_data_type');
    const closing_flag_obj = document.getElementById('closing_flag');

    if (field_name_obj) field_name_obj.value = attribute_name;
    if (field_data_type_obj) field_data_type_obj.value = data_type;
    if (closing_flag_obj) closing_flag_obj.value = unloading ? '1' : '0';

    let current_attribute_obj_str = "edit_" + attribute_name;

    if (attribute_name === "collection_status") {
        const radio_elts = document.querySelectorAll("input.collection_status");
        let found_val = "";
        for (let i = 0; i < radio_elts.length; i++) {
            if (radio_elts[i].checked) {
                found_val = radio_elts[i].value;
                break;
            }
        }
        if (field_value_obj) field_value_obj.value = found_val;
    } else if (data_type.length !== 0) {
        if (data_type === "boolean") {
            current_attribute_obj_str = current_attribute_obj_str + "_1";
        }
        const current_attribute_obj = document.getElementById(current_attribute_obj_str);
        if (current_attribute_obj) {
            if (data_type !== "boolean") {
                if (field_value_obj) field_value_obj.value = current_attribute_obj.value;
            } else {
                if (field_value_obj) field_value_obj.value = current_attribute_obj.checked ? "true" : "false";
            }
        }
    }

    const elem = document.getElementById('update_form');
    if (elem) Rails.fire(elem, 'submit');
}
window.editBlur = editBlur;

function editFocus(attribute_name, data_type)
{
    document.getElementById('unload_attribute_name').value =  attribute_name;
    document.getElementById('unload_data_type').value =  data_type;

}
window.editFocus = editFocus;

function emailBlur() {
  const tableNameElement = document.getElementById('unload_table_name');
  if (!tableNameElement) return;

  const bodyId = tableNameElement.value + "_body";
  const bodyElement = document.getElementById(bodyId);
  if (!bodyElement) return;

  const iframes = bodyElement.getElementsByTagName('iframe');
  if (iframes.length === 0) return;

  let myIframe = iframes[0];
  let iframeIndex = 1;

  // Find the iframe with className "yui-editor-editable"
  while (myIframe.className !== "yui-editor-editable" && iframeIndex < iframes.length) {
    myIframe = iframes[iframeIndex];
    iframeIndex++;
  }

  if (!myIframe || !myIframe.contentDocument || !myIframe.contentDocument.body) return;

  let textContent = myIframe.contentDocument.body.innerHTML;

  textContent = textContent.replace(/&lt;/g, '<').replace(/&gt;/g, '>');

  const bodyValueElement = document.getElementById('body_value');
  if (bodyValueElement) {
    bodyValueElement.value = textContent;
  }
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

function createNewEntry(create_entry) {
    console.log("Calling createNewEntry for " + create_entry); 
    
    const form_id = "create_entry_form_" + create_entry;
    const elem = document.getElementById(form_id);
    Rails.fire(elem, 'submit');
}
window.createNewEntry = createNewEntry;

