

function copyright() {
  document.write('<p style="text-align: center; font-size: 32%;"> Agatha database version, 3.10.12.09 © 2010, Robert Verrill O.P.</p>');

}






function hideHeader() {
  document.getElementById('logo_div').style.display = 'none';
  document.getElementById('title_div').style.display = 'none';
  document.getElementById('black_bar_div').style.display = 'none';
  document.getElementById('shrink_button_div').style.display = 'none';
  document.getElementById('menu_div').style.top = '17px';
  document.getElementById('content_div').style.top = '17px';
  document.getElementById('content_div_1').style.top = '17px';
  document.getElementById('content_div_2').style.top = '17px';
  document.getElementById('two_column_div').style.top = '17px';
  document.getElementById('black_bar_separator_div').style.top = '17px';
  document.getElementById('expand_button_div').style.display = '';
}
window.hideHeader = hideHeader;

function showHeader() {
  document.getElementById('logo_div').style.display = '';
  document.getElementById('title_div').style.display = '';
  document.getElementById('black_bar_div').style.display = '';
  document.getElementById('shrink_button_div').style.display = '';
  document.getElementById('menu_div').style.top = '187px';
  document.getElementById('two_column_div').style.top = '187px';
  document.getElementById('content_div').style.top = '187px';
  document.getElementById('content_div_1').style.top = '187px';
  document.getElementById('content_div_2').style.top = '187px';
  document.getElementById('black_bar_separator_div').style.top = '187px';

  document.getElementById('expand_button_div').style.display = 'none';
}
window.showHeader = showHeader;








function template_header() {
  document.write('<div id ="logo_div" style ="position: fixed;left: 0px; top:0px;width:150px;height:154px">');
  document.write('<img src="/images/logo.png" alt="Blackfriars Logo" width="150" height="154" longdesc="http://agatha.bfriars.ox.ac.uk/logo.png"></div>');
  document.write('<div id ="title_div" style ="position: fixed;left: 150px; right:0px; top:0px; height:163px">');
  document.write('<div align="center"> <h1 align="center">Agatha</h1> <h2 align="center">Blackfriars Hall/Studium<br> Studies Database </h2> </div></div>');
  document.write('<div id="shrink_button_div" class="remove_header" style ="position: fixed;top:156px;height:17px;width:10px; right:0px;">');
  document.write('<a href ="#" onclick="hideHeader();return false" >X</a></div>');
  document.write('<div id="black_bar_div" style ="position: fixed;top:173px;height:7px;left:0px; right:0px;background-color: #000000;">&nbsp;</div>');
  document.write('<div id="expand_button_div" class="remove_header" style ="position: fixed;top:0px;height:17px;width:10px; right:0px;">');
  document.write('<a href ="#" onclick="showHeader();return false" >+</a></div>');
  document.getElementById('expand_button_div').style.display = 'none';
}
window.template_header = template_header;

function menu_begin() {



  document.write('<div id="menu_div" style="position: fixed; top: 187px; left:0px; bottom: 7px; width:150px; ">');



}
window.menu_begin = menu_begin;


function menu_end() {

  document.write('<div style ="width: 150px; position:  absolute;bottom:0;"><p style="text-align: center; font-size: 25%;"> </p>');
  copyright();
  document.write('</div></div>');


}
window.menu_end = menu_end;

function content_begin() {
  document.write('<div id="content_div" class="content_div" style="position: fixed;  top: 187px; left: 166px; right:0px; bottom:7px; overflow: auto;">');

}
window.content_begin = content_begin;

function content_end() {
  console.log("content_end called");

  const contentDiv = document.getElementById('content_div');
  if (contentDiv) {
    contentDiv.addEventListener('scroll', scrollHandler);
  }

  window.addEventListener('resize', scrollHandler);
}
window.content_end = content_end;

function display_page(page_name, option_str) {
  const page_name_id = "display_page_name";
  const option_id = "display_page_option";
  const form_id = "display_page";

  const page_name_elt = document.getElementById(page_name_id);
  const option_elt = document.getElementById(option_id);
  const form_elt = document.getElementById(form_id);

  if (page_name_elt) page_name_elt.value = page_name;
  if (option_elt) option_elt.value = option_str;

  // If you want to submit the form:
  // if (form_elt) form_elt.submit();
}
window.display_page = display_page;

function hide_div(div_id) {

  
  const div_elt = document.getElementById(div_id); //rwv vanilla change
  console.log("hide_div called for " + div_id);
  div_elt.style.display = 'none';
}
window.hide_div = hide_div;

function show_div(div_id) {

  
  const div_elt = document.getElementById(div_id); //rwv vanilla change
  div_elt.style.display = '';
}
window.show_div = show_div;

function hide_class(div_id, class_name) {
    const div_elt = document.getElementById(div_id);
    if (!div_elt) return;
    const elements = div_elt.querySelectorAll(class_name);
    elements.forEach(el => {
        el.style.display = 'none';  // hides the element
    });
}

window.hide_class = hide_class;

function show_class(div_id, class_name) {
    const div_elt = document.getElementById(div_id);
    if (!div_elt) return;
    const elements = div_elt.querySelectorAll(class_name);
    elements.forEach(el => {
        el.style.display = '';  // resets to default, showing the element
    });
}
window.show_class = show_class;

function insert_div(div_id, insert_id) {
  const div_elt = document.getElementById(div_id);
  const insert_elt = document.getElementById(insert_id);

  if (div_elt && insert_elt && insert_elt.parentNode) {
    insert_elt.parentNode.insertBefore(div_elt, insert_elt.nextSibling);
  }
}
window.insert_div = insert_div;

function set_body_id(body_id_str) {
  document.body.id = body_id_str;
}
window.set_body_id = set_body_id;

function set_option(table_name, option_id_input) {
  const option_id = "action_select_" + table_name + "_" + option_id_input;

  const option_id258 = "#" + option_id;
  const option_elt = document.getElementById(option_id258.slice(1)); //rwv vanilla change
  if (option_elt != null) {
    option_elt.selected = true;
  }

}
window.set_option = set_option;

const all_invisible_classes = [
  ".add_attendee_options",
  ".add-cell",
  ".add_to_group_title",
  ".add_to_lecture_title",
  ".add_to_tutorial_title",
  ".add_to_willing_lecturer_title",
  ".add_to_willing_tutor_title",
  ".assign-cell",
  ".attach-cell",
  ".attach_title",
  ".attach_to-cell",
  ".attach_to_title",
  ".collection_div",
  ".create-cell",
  ".create-email-cell",
  ".create_emails_title",
  ".create_new_entry",
  ".compulsory-cell",
  ".default_class",
  ".delete-cell",
  ".delete_div",
  ".download-cell",
  ".dummy-cell",
  ".email_template_div",
  ".exam-cell",
  ".help-cell",
  ".group_div",
  ".multi_change_div",
  ".tutorial_no_div",
  ".max_tutorials_div",
  ".remove-cell",
  ".remove_from_group_title",
  ".schedule_div",
  ".search_title",
  ".select-cell",
  ".select_options",
  ".send-cell",
  ".send_div",
  ".suggest-cell",
  ".toadd-cell",
  ".tutorial_add_title",
  ".tutorial_assign_title",
  ".tutorial_schedule_div",
  ".update-cell",
  ".willing-cell"];

// DisplayDiv constructor (improved to avoid global variable issues)
function DisplayDiv(div_id_, insert_id_, visible_ids_, invisible_ids_, visible_classes_, post_javascript_) {
  this.div_id = div_id_;
  this.insert_id = insert_id_;
  this.visible_ids = visible_ids_;
  this.invisible_ids = invisible_ids_;
  this.visible_classes = visible_classes_;
  this.post_javascript = post_javascript_;

  // Use a local variable instead of global tmp_invisible_classes
  let tmp_invisible_classes = [];
  all_invisible_classes.forEach(function (inv_class) {
    if (visible_classes_.indexOf(inv_class) === -1) {
      tmp_invisible_classes.push(inv_class);
    }
  });
  this.invisible_classes = tmp_invisible_classes.map((x) => x);
}

// Global variable for unique option IDs
let next_option_id = 0; // Assuming it starts at 0

// PageView class
class PageView {
  constructor(body_id_, page_name_, page_option_str_, unrestricted_, display_divs_) {
    this.body_id = body_id_;
    this.page_name = page_name_;
    this.page_option_str = page_option_str_;
    this.unrestricted = unrestricted_;
    this.display_divs = display_divs_;
    this.separator_pos = 0.5;
    this.option_id = next_option_id;
    next_option_id = next_option_id + 1;
  }

  RegisterClasses(div_ids_, visible_classes_) {
    this.display_divs.forEach(function (display_div) {
      div_ids_.forEach(function (div_id) {
        if (display_div.div_id === div_id) {
          visible_classes_.forEach(function (visible_class) {
            if (display_div.visible_classes.indexOf(visible_class) === -1) {
              display_div.visible_classes.push(visible_class);
            }
          });
        }
      });
    });
  }
}




var page_view;
var old_option_id = 0;

var old_page_name = "Person";
var displayPageCl;
var option_hash = new MyHash();
var displayPageCl = new MyHash();

var sub_menu_hash = new MyHash();
function load_pages() {






  console.log("RWV load_pages called");


  sub_menu_hash.set('Person', 'Person');
  sub_menu_hash.set('Course', 'Course');
  sub_menu_hash.set('Lecture', 'Lecture');
  sub_menu_hash.set('Tutorial', 'Tutorial');
  sub_menu_hash.set('Email', 'AgathaEmail');
  sub_menu_hash.set('Group', 'Group');
  sub_menu_hash.set('Option', 'GroupFiltering');

  next_option_id = 0;
  const person_page_views = [];


  person_page_views.push(new PageView("people", "Person", "Select action", true,
    [new DisplayDiv("welcome_Person", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("Person_action_div", "first_menu_div", [], [], [], "")]));
  person_page_views.push(new PageView("people", "Person", "Edit", true,
    [new DisplayDiv("welcome_Person", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("Person_action_div", "first_menu_div", [], [], [], "")]));
  person_page_views.push(new PageView("people", "Person", "Multi-edit", true,
    [new DisplayDiv("welcome_Person", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Person_action_div", "first_menu_div", [], [], [".multi_change_div"], "create_multi_change_table('Person')")]));
  person_page_views.push(new PageView("people", "Person", "Create group", true,
    [new DisplayDiv("welcome_Person", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Person_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  person_page_views.push(new PageView("people", "Person", "Delete people", true,
    [new DisplayDiv("welcome_Person", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("Person_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  person_page_views.push(new PageView("people", "Person", "Make attendee", true,
    [new DisplayDiv("welcome_Person", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], ""),
    new DisplayDiv("Person_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Lecture", "first_div_2", [], ["Lecture_action_div"], [".add_attendee_options", ".add_to_lecture_title", ".toadd-cell", ".select-cell", ".exam-cell", ".compulsory-cell"], " set_action_class('Person','Lecture','add_to_lectures')")]));
  person_page_views.push(new PageView("people", "Person", "Add to groups", true,
    [new DisplayDiv("welcome_Person", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Person_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('people'); set_action_class('Person','Group','add_to_groups')")]));
  person_page_views.push(new PageView("people", "Person", "Remove from groups", true,
    [new DisplayDiv("welcome_Person", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Person_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('people'); set_action_class('Person','Group','remove_from_groups')")]));
  person_page_views.push(new PageView("people", "Person", "Set Max Tutorials", true,
    [new DisplayDiv("welcome_Person", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Person_action_div", "first_menu_div", [], [], [".max_tutorials_div"], "")]));
  person_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_Person"], [".create_new_entry", ".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('Person', person_page_views);
  add_action_items(person_page_views);
  option_hash.set('Person', 0);

  next_option_id = 0;
  const institution_page_views = [];
  institution_page_views.push(new PageView("institutions", "Institution", "Select action", true,
    [new DisplayDiv("welcome_Institution", "first_div", ["content_div"], ["two_column_div"], [".create_new_entry", ".dummy-cell"], ""),
    new DisplayDiv("Institution_action_div", "first_menu_div", [], [], [], "")]));
  institution_page_views.push(new PageView("institutions", "Institution", "Edit", true,
    [new DisplayDiv("welcome_Institution", "first_div", ["content_div"], ["two_column_div"], [".create_new_entry", ".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("Institution_action_div", "first_menu_div", [], [], [], "")]));
  institution_page_views.push(new PageView("institutions", "Institution", "Create group", true,
    [new DisplayDiv("welcome_Institution", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Institution_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  institution_page_views.push(new PageView("institutions", "Institution", "Delete institutions", true,
    [new DisplayDiv("welcome_Institution", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("Institution_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  institution_page_views.push(new PageView("institutions", "Institution", "Add to groups", true,
    [new DisplayDiv("welcome_Institution", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Institution_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('institutions'); set_action_class('Institution','Group','add_to_groups')")]));
  institution_page_views.push(new PageView("institutions", "Institution", "Remove from groups", true,
    [new DisplayDiv("welcome_Institution", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Institution_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('institutions'); set_action_class('Institution','Group','remove_from_groups')")]));
  institution_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_Institution"], [".create_new_entry", ".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('Institution', institution_page_views);
  add_action_items(institution_page_views);
  option_hash.set('Institution', 0);


  next_option_id = 0;
  const course_page_views = [];
  course_page_views.push(new PageView("courses", "Course", "Select Action", true,
    [new DisplayDiv("welcome_Course", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("Course_action_div", "first_menu_div", [], [], [], "")]));
  course_page_views.push(new PageView("courses", "Course", "Edit", true,
    [new DisplayDiv("welcome_Course", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("Course_action_div", "first_menu_div", [], [], [], "")]));
  course_page_views.push(new PageView("courses", "Course", "Create lectures", true,
    [new DisplayDiv("welcome_Course", "first_div", ["content_div"], ["two_column_div"], [".create-cell", ".suggest-cell", ".dummy-cell"], " set_action_class('Course','','create_lecture_from_course');set_suggestion_class('Lecture','Course')"),
    new DisplayDiv("Course_action_div", "first_menu_div", [], [], [".schedule_div"], "")]));
  course_page_views.push(new PageView("courses", "Course", "Create tutorials", true,
    [new DisplayDiv("welcome_Course", "first_div_1", ["two_column_div"], ["content_div"], [".create-cell", ".suggest-cell", ".dummy-cell"], " set_action_class('Course','Person','create_tutorials_from_course');set_suggestion_class('Tutorial','Course')"),
    new DisplayDiv("Course_action_div", "first_menu_div", [], [], [".tutorial_schedule_div"], ""),
    new DisplayDiv("welcome_Person", "first_div_2", [], ["Person_action_div"], [".select_options", ".select-cell", ".add_to_tutorial_title"], "")]));
  course_page_views.push(new PageView("courses", "Course", "Add Willing Tutors", true,
    [new DisplayDiv("welcome_Course", "first_div_1", ["two_column_div"], ["content_div"], [".select_options", ".select-cell"], " set_action_class('Course','Person','make_willing_tutor')"),
    new DisplayDiv("Course_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Person", "first_div_2", [], ["Person_action_div"], [".dummy-cell", ".willing-cell", ".add_to_willing_tutor_title"], "")]));
  course_page_views.push(new PageView("courses", "Course", "Add Willing Lecturers", true,
    [new DisplayDiv("welcome_Course", "first_div_1", ["two_column_div"], ["content_div"], [".select_options", ".select-cell"], " set_action_class('Course','Person','make_willing_lecturer')"),
    new DisplayDiv("Course_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Person", "first_div_2", [], ["Person_action_div"], [".dummy-cell", ".add_to_willing_lecturer_title", ".willing-cell"], "")]));
  course_page_views.push(new PageView("courses", "Course", "Create group", true,
    [new DisplayDiv("welcome_Course", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Course_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  course_page_views.push(new PageView("courses", "Course", "Delete courses", true,
    [new DisplayDiv("welcome_Course", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("Course_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  course_page_views.push(new PageView("courses", "Course", "Add to groups", true,
    [new DisplayDiv("welcome_Course", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Course_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('courses'); set_action_class('Course','Group','add_to_groups')")]));
  course_page_views.push(new PageView("courses", "Course", "Remove from groups", true,
    [new DisplayDiv("welcome_Course", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Course_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('courses'); set_action_class('Course','Group','remove_from_groups')")]));
  course_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_Course"], [".create_new_entry", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell", ".help-cell"]);
    page_view.RegisterClasses(["welcome_Person"], [".help-cell"]);
  });
  displayPageCl.set('Course', course_page_views);
  add_action_items(course_page_views);
  option_hash.set('Course', 0);

  next_option_id = 0;
  const lecture_page_views = [];
  lecture_page_views.push(new PageView("lectures", "Lecture", "Select Action", true,
    [new DisplayDiv("welcome_Lecture", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("Lecture_action_div", "first_menu_div", [], [], [], "")]));
  lecture_page_views.push(new PageView("lectures", "Lecture", "Edit", true,
    [new DisplayDiv("welcome_Lecture", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("Lecture_action_div", "first_menu_div", [], [], [], "")]));
  lecture_page_views.push(new PageView("lectures", "Lecture", "Multi-edit", true,
    [new DisplayDiv("welcome_Lecture", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Lecture_action_div", "first_menu_div", [], [], [".multi_change_div"], "create_multi_change_table('Lecture')")]));
  lecture_page_views.push(new PageView("lectures", "Lecture", "Add attendees", true,
    [new DisplayDiv("welcome_Lecture", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], [".remove-cell", ".update-cell", ".select_options", ".select-cell", ".delete-cell"], "group_unrestriction()"),
    new DisplayDiv("Lecture_action_div", "first_menu_div", [], [], [], [".delete_div", ".group_div"], ""),
    new DisplayDiv("welcome_Person", "first_div_2", [], ["Person_action_div"], [".add_attendee_options", ".add_to_lecture_title", ".toadd-cell", ".select-cell", ".exam-cell", ".compulsory-cell"], "group_restriction('lectures'); set_action_class('Lecture','Person','add_to_lectures')")]));
  lecture_page_views.push(new PageView("lectures", "Lecture", "Create group", true,
    [new DisplayDiv("welcome_Lecture", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Lecture_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  lecture_page_views.push(new PageView("lectures", "Lecture", "Delete lectures", true,
    [new DisplayDiv("welcome_Lecture", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("Lecture_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  lecture_page_views.push(new PageView("lectures", "Lecture", "Add to groups", true,
    [new DisplayDiv("welcome_Lecture", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Lecture_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('lectures'); set_action_class('Lecture','Group','add_to_groups')")]));
  lecture_page_views.push(new PageView("lectures", "Lecture", "Remove from groups", true,
    [new DisplayDiv("welcome_Lecture", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Lecture_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('lectures'); set_action_class('Lecture','Group','remove_from_groups')")]));
  lecture_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_Lecture"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".help-cell", ".select_options", ".select-cell"]);
  });
  displayPageCl.set('Lecture', lecture_page_views);
  add_action_items(lecture_page_views);
  option_hash.set('Lecture', 0);

  next_option_id = 0;
  const willing_lecturer_page_views = [];
  willing_lecturer_page_views.push(new PageView("willing_lecturers", "WillingLecturer", "Select Action", true,
    [new DisplayDiv("welcome_WillingLecturer", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("WillingLecturer_action_div", "first_menu_div", [], [], [], "")]));
  willing_lecturer_page_views.push(new PageView("willing_lecturers", "WillingLecturer", "Edit", true,
    [new DisplayDiv("welcome_WillingLecturer", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("WillingLecturer_action_div", "first_menu_div", [], [], [], "")]));
  willing_lecturer_page_views.push(new PageView("willing_lecturers", "WillingLecturer", "Multi-edit", true,
    [new DisplayDiv("welcome_WillingLecturer", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("WillingLecturer_action_div", "first_menu_div", [], [], [".multi_change_div"], "create_multi_change_table('WillingLecturer')")]));
  willing_lecturer_page_views.push(new PageView("willing_lecturers", "WillingLecturer", "Create group", true,
    [new DisplayDiv("welcome_WillingLecturer", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("WillingLecturer_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  willing_lecturer_page_views.push(new PageView("willing_lecturers", "WillingLecturer", "Delete willing_lecturers", true,
    [new DisplayDiv("welcome_WillingLecturer", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("WillingLecturer_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  willing_lecturer_page_views.push(new PageView("willing_lecturers", "WillingLecturer", "Add to groups", true,
    [new DisplayDiv("welcome_WillingLecturer", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("WillingLecturer_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('willing_lecturers'); set_action_class('WillingLecturer','Group','add_to_groups')")]));
  willing_lecturer_page_views.push(new PageView("willing_lecturers", "WillingLecturer", "Remove from groups", true,
    [new DisplayDiv("welcome_WillingLecturer", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("WillingLecturer_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('willing_lecturers'); set_action_class('WillingLecturer','Group','remove_from_groups')")]));
  willing_lecturer_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_WillingLecturer"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".help-cell", ".select_options", ".select-cell"]);
  });
  displayPageCl.set('WillingLecturer', willing_lecturer_page_views);
  add_action_items(willing_lecturer_page_views);
  option_hash.set('WillingLecturer', 0);

  next_option_id = 0;
  const attendee_page_views = [];
  attendee_page_views.push(new PageView("attendees", "Attendee", "Select Action", true,
    [new DisplayDiv("welcome_Attendee", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("Attendee_action_div", "first_menu_div", [], [], [], "")]));
  attendee_page_views.push(new PageView("attendees", "Attendee", "Edit", true,
    [new DisplayDiv("welcome_Attendee", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("Attendee_action_div", "first_menu_div", [], [], [], "")]));
  attendee_page_views.push(new PageView("attendees", "Attendee", "Multi-edit", true,
    [new DisplayDiv("welcome_Attendee", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Attendee_action_div", "first_menu_div", [], [], [".multi_change_div"], "create_multi_change_table('Attendee')")]));
  attendee_page_views.push(new PageView("attendees", "Attendee", "Create group", true,
    [new DisplayDiv("welcome_Attendee", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Attendee_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  attendee_page_views.push(new PageView("attendees", "Attendee", "Delete attendees", true,
    [new DisplayDiv("welcome_Attendee", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("Attendee_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  attendee_page_views.push(new PageView("attendees", "Attendee", "Add to groups", true,
    [new DisplayDiv("welcome_Attendee", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Attendee_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('attendees'); set_action_class('Attendee','Group','add_to_groups')")]));
  attendee_page_views.push(new PageView("attendees", "Attendee", "Remove from groups", true,
    [new DisplayDiv("welcome_Attendee", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Attendee_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('attendees'); set_action_class('Attendee','Group','remove_from_groups')")]));
  attendee_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_Attendee"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('Attendee', attendee_page_views);
  add_action_items(attendee_page_views);
  option_hash.set('Attendee', 0);


  next_option_id = 0;
  const location_page_views = [];
  location_page_views.push(new PageView("locations", "Location", "Select Action", true,
    [new DisplayDiv("welcome_Location", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("Location_action_div", "first_menu_div", [], [], [], "")]));
  location_page_views.push(new PageView("locations", "Location", "Edit", true,
    [new DisplayDiv("welcome_Location", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("Location_action_div", "first_menu_div", [], [], [], "")]));
  location_page_views.push(new PageView("locations", "Location", "Create group", true,
    [new DisplayDiv("welcome_Location", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Location_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  location_page_views.push(new PageView("locations", "Location", "Delete locations", true,
    [new DisplayDiv("welcome_Location", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("Location_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  location_page_views.push(new PageView("locations", "Location", "Add to groups", true,
    [new DisplayDiv("welcome_Location", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Location_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('locations'); set_action_class('Location','Group','add_to_groups')")]));
  location_page_views.push(new PageView("locations", "Location", "Remove from groups", true,
    [new DisplayDiv("welcome_Location", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Location_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('locations'); set_action_class('Location','Group','remove_from_groups')")]));

  location_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_Location"], [".create_new_entry", ".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('Location', location_page_views);
  add_action_items(location_page_views);
  option_hash.set('Location', 0);

  next_option_id = 0;
  const tutorial_schedule_page_views = [];
  tutorial_schedule_page_views.push(new PageView("tutorial_schedules", "TutorialSchedule", "Select Action", true,
    [new DisplayDiv("welcome_TutorialSchedule", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("TutorialSchedule_action_div", "first_menu_div", [], [], [], "")]));
  tutorial_schedule_page_views.push(new PageView("tutorial_schedules", "TutorialSchedule", "Edit", true,
    [new DisplayDiv("welcome_TutorialSchedule", "first_div", ["content_div", "content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("TutorialSchedule_action_div", "first_menu_div", [], [], [], "")]));
  tutorial_schedule_page_views.push(new PageView("tutorial_schedules", "TutorialSchedule", "Multi-edit", true,
    [new DisplayDiv("welcome_TutorialSchedule", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("TutorialSchedule_action_div", "first_menu_div", [], [], [".multi_change_div"], "create_multi_change_table('TutorialSchedule')")]));
  tutorial_schedule_page_views.push(new PageView("tutorial_schedules", "TutorialSchedule", "Add student", true,
    [new DisplayDiv("welcome_TutorialSchedule", "first_div_1", ["two_column_div"], ["content_div"], [".select_options", ".select-cell"], "group_unrestriction()"),
    new DisplayDiv("TutorialSchedule_action_div", "first_menu_div", [], [], [], [".delete_div", ".group_div"], ""),
    new DisplayDiv("welcome_Person", "first_div_2", [], ["Person_action_div"], [".assign-cell", ".tutorial_add_title", ".dummy-cell"], "set_action_class('TutorialSchedule','Person','add_tutorial_student')")]));

  tutorial_schedule_page_views.push(new PageView("tutorial_schedules", "TutorialSchedule", "Assign tutor", true,
    [new DisplayDiv("welcome_TutorialSchedule", "first_div_1", ["two_column_div"], ["content_div"], [".select_options", ".select-cell"], "group_unrestriction()"),
    new DisplayDiv("TutorialSchedule_action_div", "first_menu_div", [], [], [], [".delete_div", ".group_div"], ""),
    new DisplayDiv("welcome_Person", "first_div_2", [], ["Person_action_div"], [".assign-cell", ".tutorial_assign_title", ".dummy-cell"], "set_action_class('TutorialSchedule','Person','assign_tutor')")]));
  tutorial_schedule_page_views.push(new PageView("tutorial_schedules", "TutorialSchedule", "Set tutorial number", true,
    [new DisplayDiv("welcome_TutorialSchedule", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("TutorialSchedule_action_div", "first_menu_div", [], [], [".tutorial_no_div"], "")]));
  tutorial_schedule_page_views.push(new PageView("tutorial_schedules", "TutorialSchedule", "Create group", true,
    [new DisplayDiv("welcome_TutorialSchedule", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("TutorialSchedule_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  tutorial_schedule_page_views.push(new PageView("tutorial_schedules", "TutorialSchedule", "Delete tutorial schedules", true,
    [new DisplayDiv("welcome_TutorialSchedule", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("TutorialSchedule_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  tutorial_schedule_page_views.push(new PageView("tutorial_schedules", "TutorialSchedule", "Add to groups", true,
    [new DisplayDiv("welcome_TutorialSchedule", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("TutorialSchedule_action_div", "first_menu_div", [], [], [], [".delete_div", ".group_div"], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('tutorial_schedules'); set_action_class('TutorialSchedule','Group','add_to_groups')")]));
  tutorial_schedule_page_views.push(new PageView("tutorial_schedules", "TutorialSchedule", "Remove from groups", true,
    [new DisplayDiv("welcome_TutorialSchedule", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("TutorialSchedule_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('tutorial_schedules'); set_action_class('TutorialSchedule','Group','remove_from_groups')")]));
  tutorial_schedule_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_TutorialSchedule"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('TutorialSchedule', tutorial_schedule_page_views);
  add_action_items(tutorial_schedule_page_views);
  option_hash.set('TutorialSchedule', 0);

  next_option_id = 0;
  const tutorial_page_views = [];
  tutorial_page_views.push(new PageView("tutorials", "Tutorial", "Select Action", true,
    [new DisplayDiv("welcome_Tutorial", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("Tutorial_action_div", "first_menu_div", [], [], [], "")]));
  tutorial_page_views.push(new PageView("tutorials", "Tutorial", "Edit", true,
    [new DisplayDiv("welcome_Tutorial", "first_div", ["content_div", "content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("Tutorial_action_div", "first_menu_div", [], [], [], "")]));
  tutorial_page_views.push(new PageView("tutorials", "Tutorial", "Multi-edit", true,
    [new DisplayDiv("welcome_Tutorial", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Tutorial_action_div", "first_menu_div", [], [], [".multi_change_div"], "create_multi_change_table('Tutorial')")]));
  tutorial_page_views.push(new PageView("tutorials", "Tutorial", "Create group", true,
    [new DisplayDiv("welcome_Tutorial", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Tutorial_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  tutorial_page_views.push(new PageView("tutorials", "Tutorial", "Delete tutorials", true,
    [new DisplayDiv("welcome_Tutorial", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("Tutorial_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  tutorial_page_views.push(new PageView("tutorials", "Tutorial", "Update Collection Status", true,
    [new DisplayDiv("welcome_Tutorial", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("Tutorial_action_div", "first_menu_div", [], [], [".collection_div"], "")]));
  tutorial_page_views.push(new PageView("tutorials", "Tutorial", "Add to groups", true,
    [new DisplayDiv("welcome_Tutorial", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Tutorial_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('tutorials'); set_action_class('Tutorial','Group','add_to_groups')")]));
  tutorial_page_views.push(new PageView("tutorials", "Tutorial", "Remove from groups", true,
    [new DisplayDiv("welcome_Tutorial", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Tutorial_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('tutorials'); set_action_class('Tutorial','Group','remove_from_groups')")]));
  tutorial_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_Tutorial"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('Tutorial', tutorial_page_views);
  add_action_items(tutorial_page_views);
  option_hash.set('Tutorial', 0);

  next_option_id = 0;
  const willing_tutor_page_views = [];
  willing_tutor_page_views.push(new PageView("willing_tutors", "WillingTutor", "Select Action", true,
    [new DisplayDiv("welcome_WillingTutor", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("WillingTutor_action_div", "first_menu_div", [], [], [], "")]));
  willing_tutor_page_views.push(new PageView("willing_tutors", "WillingTutor", "Edit", true,
    [new DisplayDiv("welcome_WillingTutor", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("WillingTutor_action_div", "first_menu_div", [], [], [], "")]));
  willing_tutor_page_views.push(new PageView("willing_tutors", "WillingTutor", "Multi-edit", true,
    [new DisplayDiv("welcome_WillingTutor", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("WillingTutor_action_div", "first_menu_div", [], [], [".multi_change_div"], "create_multi_change_table('WillingTutor')")]));
  willing_tutor_page_views.push(new PageView("willing_tutors", "WillingTutor", "Create group", true,
    [new DisplayDiv("welcome_WillingTutor", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("WillingTutor_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  willing_tutor_page_views.push(new PageView("willing_tutors", "WillingTutor", "Delete willing_tutors", true,
    [new DisplayDiv("welcome_WillingTutor", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("WillingTutor_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  willing_tutor_page_views.push(new PageView("willing_tutors", "WillingTutor", "Add to groups", true,
    [new DisplayDiv("welcome_WillingTutor", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("WillingTutor_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('willing_tutors'); set_action_class('WillingTutor','Group','add_to_groups')")]));
  willing_tutor_page_views.push(new PageView("willing_tutors", "WillingTutor", "Remove from groups", true,
    [new DisplayDiv("welcome_WillingTutor", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], [".update-cell", ".select_options", ".select-cell", ".delete-cell"], "group_unrestriction()"),
    new DisplayDiv("WillingTutor_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('willing_tutors'); set_action_class('WillingTutor','Group','remove_from_groups')")]));
  willing_tutor_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_WillingTutor"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group", "welcome_Person"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('WillingTutor', willing_tutor_page_views);
  add_action_items(willing_tutor_page_views);
  option_hash.set('WillingTutor', 0);

  next_option_id = 0;
  const maximum_tutorial_page_views = [];
  maximum_tutorial_page_views.push(new PageView("maximum_tutorials", "MaximumTutorial", "Select Action", true,
    [new DisplayDiv("welcome_MaximumTutorial", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("MaximumTutorial_action_div", "first_menu_div", [], [], [], "")]));
  maximum_tutorial_page_views.push(new PageView("maximum_tutorials", "MaximumTutorial", "Edit", true,
    [new DisplayDiv("welcome_MaximumTutorial", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("MaximumTutorial_action_div", "first_menu_div", [], [], [], "")]));
  maximum_tutorial_page_views.push(new PageView("maximum_tutorials", "MaximumTutorial", "Delete max tutorials", true,
    [new DisplayDiv("welcome_MaximumTutorial", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("MaximumTutorial_action_div", "first_menu_div", [], [], [".delete_div"], "")]));

  maximum_tutorial_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_MaximumTutorial"], [".help-cell", ".search_title", ".default_class"]);

  });
  displayPageCl.set('MaximumTutorial', maximum_tutorial_page_views);
  add_action_items(maximum_tutorial_page_views);
  option_hash.set('MaximumTutorial', 0);

  next_option_id = 0;
  const group_page_views = [];
  group_page_views.push(new PageView("groups", "Group", "Select Action", true,
    [new DisplayDiv("welcome_Group", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], "")]));
  group_page_views.push(new PageView("groups", "Group", "Edit", true,
    [new DisplayDiv("welcome_Group", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], "")]));
  group_page_views.push(new PageView("groups", "Group", "Delete groups", true,
    [new DisplayDiv("welcome_Group", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_page_views.push(new PageView("groups", "Group", "Add people", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Person", "first_div_2", [], ["Person_action_div"], [".add_to_group_title"], "group_restriction('people');set_action_class('Group','Person','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add institutions", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Institution", "first_div_2", [], ["Institution_action_div"], [".add_to_group_title"], "group_restriction('institutions');set_action_class('Group','Institution','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add courses", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Course", "first_div_2", [], ["Course_action_div"], [".add_to_group_title"], "group_restriction('courses');set_action_class('Group','Course','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add lectures", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Lecture", "first_div_2", [], ["Lecture_action_div"], [".add_to_group_title"], "group_restriction('lectures');set_action_class('Group','Lecture','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add attendees", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Attendee", "first_div_2", [], ["Attendee_action_div"], [".add_to_group_title"], "group_restriction('attendees');set_action_class('Group','Attendee','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add locations", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Location", "first_div_2", [], ["Location_action_div"], [".add_to_group_title"], "group_restriction('locations');set_action_class('Group','Location','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add tutorials", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Tutorial", "first_div_2", [], ["Tutorial_action_div"], [".add_to_group_title"], "group_restriction('tutorials');set_action_class('Group','Tutorial','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add tutorial schedules", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_TutorialSchedule", "first_div_2", [], ["TutorialSchedule_action_div"], [".add_to_group_title"], "group_restriction('tutorial_schedules');set_action_class('Group','TutorialSchedule','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add emails", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_AgathaEmail", "first_div_2", [], ["AgathaEmail_action_div"], [".add_to_group_title"], "group_restriction('agatha_emails');set_action_class('Group','AgathaEmail','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add email templates", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_EmailTemplate", "first_div_2", [], ["EmailTemplate_action_div"], [".add_to_group_title"], "group_restriction('email_templates');set_action_class('Group','EmailTemplate','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add willing lecturers", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_WillingLecturer", "first_div_2", [], ["WillingLecturer_action_div"], [".add_to_group_title"], "group_restriction('willing_lecturers');set_action_class('Group','WillingLecturer','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add willing tutors", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_WillingTutor", "first_div_2", [], ["WillingTutor_action_div"], [".add_to_group_title"], "group_restriction('willing_tutors');set_action_class('Group','WillingTutor','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Add users", false,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_User", "first_div_2", [], ["User_action_div"], [".add_to_group_title"], "group_restriction('users');set_action_class('Group','User','add_to_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove people", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Person", "first_div_2", [], ["Person_action_div"], [".remove_from_group_title"], "group_restriction('people');set_action_class('Group','Person','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove institutions", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Institution", "first_div_2", [], ["Institution_action_div"], [".remove_from_group_title"], "group_restriction('institutions');set_action_class('Group','Institution','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove courses", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Course", "first_div_2", [], ["Course_action_div"], [".remove_from_group_title"], "group_restriction('courses');set_action_class('Group','Course','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove lectures", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Lecture", "first_div_2", [], ["Lecture_action_div"], [".remove_from_group_title"], "group_restriction('lectures');set_action_class('Group','Lecture','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove attendees", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Attendee", "first_div_2", [], ["Attendee_action_div"], [".remove_from_group_title"], "group_restriction('attendees');set_action_class('Group','Attendee','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove locations", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Location", "first_div_2", [], ["Location_action_div"], [".remove_from_group_title"], "group_restriction('locations');set_action_class('Group','Location','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove tutorials", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Tutorial", "first_div_2", [], ["Tutorial_action_div"], [".remove_from_group_title"], "group_restriction('tutorials');set_action_class('Group','Tutorial','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove tutorial schedule", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_TutorialSchedule", "first_div_2", [], ["TutorialSchedule_action_div"], [".remove_from_group_title"], "group_restriction('tutorial_schedules');set_action_class('Group','TutorialSchedule','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove agatha emails", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_AgathaEmail", "first_div_2", [], ["AgathaEmail_action_div"], [".remove_from_group_title"], "group_restriction('agatha_emails');set_action_class('Group','AgathaEmail','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove emails", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_AgathaEmail", "first_div_2", [], ["AgathaEmail_action_div"], [".remove_from_group_title"], "group_restriction('agatha_emails');set_action_class('Group','AgathaEmail','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove email templates", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_EmailTemplate", "first_div_2", [], ["EmailTemplate_action_div"], [".remove_from_group_title"], "group_restriction('email_templates');set_action_class('Group','EmailTemplate','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove willing lecturers", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_WillingLecturer", "first_div_2", [], ["WillingLecturer_action_div"], [".remove_from_group_title"], "group_restriction('willing_lecturers');set_action_class('Group','WillingLecturer','remove_from_group')")]));
  group_page_views.push(new PageView("groups", "Group", "Remove willing tutors", true,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_WillingTutor", "first_div_2", [], ["WillingTutor_action_div"], [".remove_from_group_title"], "group_restriction('willing_tutors');set_action_class('Group','WillingTutor','remove_from_group')")]));

  group_page_views.push(new PageView("groups", "Group", "Remove users", false,
    [new DisplayDiv("welcome_Group", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("Group_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_User", "first_div_2", [], ["User_action_div"], [".remove_from_group_title"], "group_restriction('users');set_action_class('Group','User','remove_from_group')")]));
  group_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_Group"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Person", "welcome_Institution", "welcome_Course", "welcome_Lecture", "welcome_Attendee", "welcome_Tutorial", "welcome_TutorialSchedule", "welcome_Location", "welcome_AgathaEmail", "welcome_EmailTemplate", "welcome_WillingLecturer", "welcome_WillingTutor", "welcome_User"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('Group', group_page_views);
  add_action_items(group_page_views);
  option_hash.set('Group', 0);



  next_option_id = 0;
  const group_person_page_views = [];
  group_person_page_views.push(new PageView("group_people", "GroupPerson", "Select Action", true,
    [new DisplayDiv("welcome_GroupPerson", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupPerson_action_div", "first_menu_div", [], [], [], "")]));
  group_person_page_views.push(new PageView("group_people", "GroupPerson", "Remove members", true,
    [new DisplayDiv("welcome_GroupPerson", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupPerson_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_person_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupPerson"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupPerson', group_person_page_views);
  add_action_items(group_person_page_views);
  option_hash.set('GroupPerson', 0);

  next_option_id = 0;
  const group_institution_page_views = [];
  group_institution_page_views.push(new PageView("group_institutions", "GroupInstitution", "Select Action", true,
    [new DisplayDiv("welcome_GroupInstitution", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupInstitution_action_div", "first_menu_div", [], [], [], "")]));
  group_institution_page_views.push(new PageView("group_institutions", "GroupInstitution", "Remove members", true,
    [new DisplayDiv("welcome_GroupInstitution", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupInstitution_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_institution_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupInstitution"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupInstitution', group_institution_page_views);
  add_action_items(group_institution_page_views);
  option_hash.set('GroupInstitution', 0);

  next_option_id = 0;
  const group_course_page_views = [];
  group_course_page_views.push(new PageView("group_courses", "GroupCourse", "Select Action", true,
    [new DisplayDiv("welcome_GroupCourse", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupCourse_action_div", "first_menu_div", [], [], [], "")]));
  group_course_page_views.push(new PageView("group_courses", "GroupCourse", "Remove members", true,
    [new DisplayDiv("welcome_GroupCourse", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupCourse_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_course_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupCourse"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupCourse', group_course_page_views);
  add_action_items(group_course_page_views);
  option_hash.set('GroupCourse', 0);

  next_option_id = 0;
  const group_lecture_page_views = [];
  group_lecture_page_views.push(new PageView("group_lectures", "GroupLecture", "Select Action", true,
    [new DisplayDiv("welcome_GroupLecture", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupLecture_action_div", "first_menu_div", [], [], [], "")]));
  group_lecture_page_views.push(new PageView("group_lectures", "GroupLecture", "Remove members", true,
    [new DisplayDiv("welcome_GroupLecture", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupLecture_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_lecture_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupLecture"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupLecture', group_lecture_page_views);
  add_action_items(group_lecture_page_views);
  option_hash.set('GroupLecture', 0);

  next_option_id = 0;
  const group_attendee_page_views = [];
  group_attendee_page_views.push(new PageView("group_attendees", "GroupAttendee", "Select Action", true,
    [new DisplayDiv("welcome_GroupAttendee", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupAttendee_action_div", "first_menu_div", [], [], [], "")]));
  group_attendee_page_views.push(new PageView("group_attendees", "GroupAttendee", "Remove members", true,
    [new DisplayDiv("welcome_GroupAttendee", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupAttendee_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_attendee_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupAttendee"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupAttendee', group_attendee_page_views);
  add_action_items(group_attendee_page_views);
  option_hash.set('GroupAttendee', 0);

  next_option_id = 0;
  const group_location_page_views = [];
  group_location_page_views.push(new PageView("group_locations", "GroupLocation", "Select Action", true,
    [new DisplayDiv("welcome_GroupLocation", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupLocation_action_div", "first_menu_div", [], [], [], "")]));
  group_location_page_views.push(new PageView("group_locations", "GroupLocation", "Remove members", true,
    [new DisplayDiv("welcome_GroupLocation", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupLocation_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_location_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupLocation"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupLocation', group_location_page_views);
  add_action_items(group_location_page_views);
  option_hash.set('GroupLocation', 0);

  next_option_id = 0;
  const group_tutorial_page_views = [];
  group_tutorial_page_views.push(new PageView("group_tutorials", "GroupTutorial", "Select Action", true,
    [new DisplayDiv("welcome_GroupTutorial", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupTutorial_action_div", "first_menu_div", [], [], [], "")]));
  group_tutorial_page_views.push(new PageView("group_tutorials", "GroupTutorial", "Remove members", true,
    [new DisplayDiv("welcome_GroupTutorial", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupTutorial_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_tutorial_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupTutorial"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupTutorial', group_tutorial_page_views);
  add_action_items(group_tutorial_page_views);
  option_hash.set('GroupTutorial', 0);

  next_option_id = 0;
  const group_tutorial_schedule_page_views = [];
  group_tutorial_schedule_page_views.push(new PageView("group_tutorial_schedules", "GroupTutorialSchedule", "Select Action", true,
    [new DisplayDiv("welcome_GroupTutorialSchedule", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupTutorialSchedule_action_div", "first_menu_div", [], [], [], "")]));
  group_tutorial_schedule_page_views.push(new PageView("group_tutorial_schedules", "GroupTutorialSchedule", "Remove members", true,
    [new DisplayDiv("welcome_GroupTutorialSchedule", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupTutorialSchedule_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_tutorial_schedule_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupTutorialSchedule"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupTutorialSchedule', group_tutorial_schedule_page_views);
  add_action_items(group_tutorial_schedule_page_views);
  option_hash.set('GroupTutorialSchedule', 0);

  next_option_id = 0;
  const group_agatha_email_page_views = [];
  group_agatha_email_page_views.push(new PageView("group_agatha_emails", "GroupAgathaEmail", "Select Action", true,
    [new DisplayDiv("welcome_GroupAgathaEmail", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupAgathaEmail_action_div", "first_menu_div", [], [], [], "")]));
  group_agatha_email_page_views.push(new PageView("group_agatha_emails", "GroupAgathaEmail", "Remove members", true,
    [new DisplayDiv("welcome_GroupAgathaEmail", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupAgathaEmail_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_agatha_email_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupAgathaEmail"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupAgathaEmail', group_agatha_email_page_views);
  add_action_items(group_agatha_email_page_views);
  option_hash.set('GroupAgathaEmail', 0);

  next_option_id = 0;
  const group_email_template_page_views = [];
  group_email_template_page_views.push(new PageView("group_email_templates", "GroupEmailTemplate", "Select Action", true,
    [new DisplayDiv("welcome_GroupEmailTemplate", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupEmailTemplate_action_div", "first_menu_div", [], [], [], "")]));
  group_email_template_page_views.push(new PageView("group_email_templates", "GroupEmailTemplate", "Remove members", true,
    [new DisplayDiv("welcome_GroupEmailTemplate", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupEmailTemplate_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_email_template_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupEmailTemplate"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupEmailTemplate', group_email_template_page_views);
  add_action_items(group_email_template_page_views);
  option_hash.set('GroupEmailTemplate', 0);

  next_option_id = 0;
  const group_willing_lecturer_page_views = [];
  group_willing_lecturer_page_views.push(new PageView("group_willing_lecturers", "GroupWillingLecturer", "Select Action", true,
    [new DisplayDiv("welcome_GroupWillingLecturer", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupWillingLecturer_action_div", "first_menu_div", [], [], [], "")]));
  group_willing_lecturer_page_views.push(new PageView("group_willing_lecturers", "GroupWillingLecturer", "Remove members", true,
    [new DisplayDiv("welcome_GroupWillingLecturer", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupWillingLecturer_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_willing_lecturer_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupWillingLecturer"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupWillingLecturer', group_willing_lecturer_page_views);
  add_action_items(group_willing_lecturer_page_views);
  option_hash.set('GroupWillingLecturer', 0);

  next_option_id = 0;
  const group_willing_tutor_page_views = [];
  group_willing_tutor_page_views.push(new PageView("group_willing_tutors", "GroupWillingTutor", "Select Action", true,
    [new DisplayDiv("welcome_GroupWillingTutor", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupWillingTutor_action_div", "first_menu_div", [], [], [], "")]));
  group_willing_tutor_page_views.push(new PageView("group_willing_tutors", "GroupWillingTutor", "Remove members", true,
    [new DisplayDiv("welcome_GroupWillingTutor", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupWillingTutor_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  group_willing_tutor_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupWillingTutor"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupWillingTutor', group_willing_tutor_page_views);
  add_action_items(group_willing_tutor_page_views);
  option_hash.set('GroupWillingTutor', 0);

  next_option_id = 0;
  const group_user_page_views = [];

  group_user_page_views.push(new PageView("group_users", "GroupUser", "Select Action", true,
    [new DisplayDiv("welcome_GroupUser", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("GroupUser_action_div", "first_menu_div", [], [], [], "")]));
  group_user_page_views.push(new PageView("group_users", "GroupUser", "Remove members", true,
    [new DisplayDiv("welcome_GroupUser", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("GroupUser_action_div", "first_menu_div", [], [], [".delete_div"], "")]));

  group_user_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_GroupUser"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('GroupUser', group_user_page_views);

  add_action_items(group_user_page_views);

  option_hash.set('GroupUser', 0);

  next_option_id = 0;
  const user_page_views = [];
  user_page_views.push(new PageView("users", "User", "Select Action", false,
    [new DisplayDiv("welcome_User", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("User_action_div", "first_menu_div", [], [], [], "")]));
  user_page_views.push(new PageView("users", "User", "Create group", false,
    [new DisplayDiv("welcome_User", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("User_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  user_page_views.push(new PageView("users", "User", "Delete users", false,
    [new DisplayDiv("welcome_User", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("User_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  user_page_views.push(new PageView("users", "User", "Add to groups", true,
    [new DisplayDiv("welcome_User", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("User_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('users'); set_action_class('User','Group','add_to_groups')")]));
  user_page_views.push(new PageView("users", "User", "Remove from groups", true,
    [new DisplayDiv("welcome_User", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("User_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('users'); set_action_class('User','Group','remove_from_groups')")]));
  user_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_User"], [".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('User', user_page_views);
  add_action_items(user_page_views);
  option_hash.set('User', 0);

  next_option_id = 0;
  const email_template_page_views = [];
  email_template_page_views.push(new PageView("email_templates", "EmailTemplate", "Select Action", true,
    [new DisplayDiv("welcome_EmailTemplate", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("EmailTemplate_action_div", "first_menu_div", [], [], [], "")]));
  email_template_page_views.push(new PageView("email_templates", "EmailTemplate", "Create emails", true,
    [new DisplayDiv("welcome_EmailTemplate", "first_div_1", ["two_column_div"], ["content_div"], [".create-email-cell", ".dummy-cell"], " set_action_class('EmailTemplate','Person','create_email_from_template')"),
    new DisplayDiv("EmailTemplate_action_div", "first_menu_div", [], [], [".email_template_div"], ""),
    new DisplayDiv("welcome_Person", "first_div_2", [], ["Person_action_div"], [".create_emails_title"], "")]));
  email_template_page_views.push(new PageView("email_templates", "EmailTemplate", "Edit", true,
    [new DisplayDiv("welcome_EmailTemplate", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("EmailTemplate_action_div", "first_menu_div", [], [], [], "")]));
  email_template_page_views.push(new PageView("email_templates", "EmailTemplate", "Create group", true,
    [new DisplayDiv("welcome_EmailTemplate", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("EmailTemplate_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  email_template_page_views.push(new PageView("email_templates", "EmailTemplate", "Delete email_templates", true,
    [new DisplayDiv("welcome_EmailTemplate", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("EmailTemplate_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  email_template_page_views.push(new PageView("email_templates", "EmailTemplate", "Add to groups", true,
    [new DisplayDiv("welcome_EmailTemplate", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("EmailTemplate_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('email_templates'); set_action_class('EmailTemplate','Group','add_to_groups')")]));
  email_template_page_views.push(new PageView("email_templates", "EmailTemplate", "Remove from groups", true,
    [new DisplayDiv("welcome_EmailTemplate", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("EmailTemplate_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('email_templates'); set_action_class('EmailTemplate','Group','remove_from_groups')")]));
  email_template_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_EmailTemplate"], [".create_new_entry", ".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group", "welcome_Person"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('EmailTemplate', email_template_page_views);
  add_action_items(email_template_page_views);
  option_hash.set('EmailTemplate', 0);

  next_option_id = 0;
  const agatha_email_page_views = [];
  agatha_email_page_views.push(new PageView("agatha_emails", "AgathaEmail", "Select Action", true,
    [new DisplayDiv("welcome_AgathaEmail", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("AgathaEmail_action_div", "first_menu_div", [], [], [], "")]));
  agatha_email_page_views.push(new PageView("agatha_emails", "AgathaEmail", "Send agatha_emails", true,
    [new DisplayDiv("welcome_AgathaEmail", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".send-cell"], ""),
    new DisplayDiv("AgathaEmail_action_div", "first_menu_div", [], [], [".send_div"], "")]));
  agatha_email_page_views.push(new PageView("agatha_emails", "AgathaEmail", "Edit", true,
    [new DisplayDiv("welcome_AgathaEmail", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("AgathaEmail_action_div", "first_menu_div", [], [], [], "")]));
  agatha_email_page_views.push(new PageView("agatha_emails", "AgathaEmail", "Multi-edit", true,
    [new DisplayDiv("welcome_AgathaEmail", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("AgathaEmail_action_div", "first_menu_div", [], [], [".multi_change_div"], "create_multi_change_table('AgathaEmail')")]));
  agatha_email_page_views.push(new PageView("agatha_emails", "AgathaEmail", "Attach Files", true,
    [new DisplayDiv("welcome_AgathaEmail", "first_div_1", ["two_column_div"], ["content_div"], [".attach-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("AgathaEmail_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_AgathaFile", "first_div_2", [], ["AgathaFile_action_div"], [".select_options", ".select-cell", ".attach_title"], "set_action_class('AgathaEmail','AgathaFile','attach_files')")]));
  agatha_email_page_views.push(new PageView("agatha_emails", "AgathaEmail", "Create group", true,
    [new DisplayDiv("welcome_AgathaEmail", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("AgathaEmail_action_div", "first_menu_div", [], [], [".group_div"], "")]));
  agatha_email_page_views.push(new PageView("agatha_emails", "AgathaEmail", "Delete agatha_emails", true,
    [new DisplayDiv("welcome_AgathaEmail", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("AgathaEmail_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  agatha_email_page_views.push(new PageView("agatha_emails", "AgathaEmail", "Add to groups", true,
    [new DisplayDiv("welcome_AgathaEmail", "first_div_1", ["two_column_div"], ["content_div"], [".add-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("AgathaEmail_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".add_to_group_title"], "group_restriction('agatha_emails'); set_action_class('AgathaEmail','Group','add_to_groups')")]));
  agatha_email_page_views.push(new PageView("agatha_emails", "AgathaEmail", "Remove from groups", true,
    [new DisplayDiv("welcome_AgathaEmail", "first_div_1", ["two_column_div"], ["content_div"], [".remove-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("AgathaEmail_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_Group", "first_div_2", [], ["Group_action_div"], [".remove_from_group_title"], "group_restriction('agatha_emails'); set_action_class('AgathaEmail','Group','remove_from_groups')")]));
  agatha_email_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_AgathaEmail"], [".create_new_entry", ".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group", "welcome_Person"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('AgathaEmail', agatha_email_page_views);
  add_action_items(agatha_email_page_views);
  option_hash.set('AgathaEmail', 0);

  next_option_id = 0;
  const agatha_file_page_views = [];
  agatha_file_page_views.push(new PageView("agatha_files", "AgathaFile", "Select Action", true,
    [new DisplayDiv("welcome_AgathaFile", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("AgathaFile_action_div", "first_menu_div", [], [], [], "")]));
  agatha_file_page_views.push(new PageView("agatha_files", "AgathaFile", "Edit", true,
    [new DisplayDiv("welcome_AgathaFile", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("AgathaFile_action_div", "first_menu_div", [], [], [], "")]));
  agatha_file_page_views.push(new PageView("agatha_files", "AgathaFile", "Download", true,
    [new DisplayDiv("welcome_AgathaFile", "first_div", ["content_div"], ["two_column_div"], [".download-cell", ".dummy-cell"], ""),
    new DisplayDiv("AgathaFile_action_div", "first_menu_div", [], [], [], "")]));
  agatha_file_page_views.push(new PageView("agatha_files", "AgathaFile", "Attach to Emails", true,
    [new DisplayDiv("welcome_AgathaFile", "first_div_1", ["two_column_div"], ["content_div"], [".attach_to-cell", ".dummy-cell"], "group_unrestriction()"),
    new DisplayDiv("AgathaFile_action_div", "first_menu_div", [], [], [], ""),
    new DisplayDiv("welcome_AgathaEmail", "first_div_2", [], ["AgathaEmail_action_div"], [".select_options", ".select-cell", ".attach_to_title"], "set_action_class('AgathaFile','AgathaEmail','attach_to_emails')")]));

  agatha_file_page_views.push(new PageView("agatha_files", "AgathaFile", "Delete agatha_files", true,
    [new DisplayDiv("welcome_AgathaFile", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("AgathaFile_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  agatha_file_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_AgathaFile"], [".create_new_entry", ".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group", "welcome_Person"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('AgathaFile', agatha_file_page_views);
  add_action_items(agatha_file_page_views);
  option_hash.set('AgathaFile', 0);

  next_option_id = 0;
  const emal_attachment_page_views = [];
  emal_attachment_page_views.push(new PageView("email_attachments", "EmailAttachment", "Select Action", true,
    [new DisplayDiv("welcome_EmailAttachment", "first_div", ["content_div"], ["two_column_div"], [".dummy-cell"], ""),
    new DisplayDiv("EmailAttachment_action_div", "first_menu_div", [], [], [], "")]));
  emal_attachment_page_views.push(new PageView("email_attachments", "EmailAttachment", "Edit", true,
    [new DisplayDiv("welcome_EmailAttachment", "first_div", ["content_div"], ["two_column_div"], [".update-cell", ".dummy-cell"], ""),
    new DisplayDiv("EmailAttachment_action_div", "first_menu_div", [], [], [], "")]));
  emal_attachment_page_views.push(new PageView("email_attachments", "EmailAttachment", "Multi-edit", true,
    [new DisplayDiv("welcome_EmailAttachment", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell"], ""),
    new DisplayDiv("EmailAttachment_action_div", "first_menu_div", [], [], [".multi_change_div"], "create_multi_change_table('EmailAttachment')")]));
  emal_attachment_page_views.push(new PageView("email_attachments", "EmailAttachment", "Delete email_attachments", true,
    [new DisplayDiv("welcome_EmailAttachment", "first_div", ["content_div"], ["two_column_div"], [".select_options", ".select-cell", ".delete-cell"], ""),
    new DisplayDiv("EmailAttachment_action_div", "first_menu_div", [], [], [".delete_div"], "")]));
  emal_attachment_page_views.forEach(function (page_view) {
    page_view.RegisterClasses(["welcome_EmailAttachment"], [".create_new_entry", ".help-cell", ".search_title", ".default_class"]);
    page_view.RegisterClasses(["welcome_Group", "welcome_Person"], [".select_options", ".select-cell"]);
  });
  displayPageCl.set('EmailAttachment', emal_attachment_page_views);
  add_action_items(emal_attachment_page_views);
  option_hash.set('EmailAttachment', 0);

  next_option_id = 0;
  const group_filtering_page_views = [];
  group_filtering_page_views.push(new PageView("group_filterings", "GroupFiltering", "Select Action", true,
    [new DisplayDiv("welcome_GroupFiltering", "first_div", ["content_div"], ["two_column_div"], [], "")]));
  displayPageCl.set('GroupFiltering', group_filtering_page_views);
  add_action_items(group_filtering_page_views);
  option_hash.set('GroupFiltering', 0);

  next_option_id = 0;
  const field_display_format_page_views = [];
  field_display_format_page_views.push(new PageView("field_display_formats", "FieldDisplayFormat", "Select Action", true,
    [new DisplayDiv("welcome_FieldDisplayFormat", "first_div", ["content_div"], ["two_column_div"], [], "")]));
  displayPageCl.set('FieldDisplayFormat', field_display_format_page_views);
  add_action_items(field_display_format_page_views);
  option_hash.set('FieldDisplayFormat', 0);


  action_select0();

  const form_id = "display_page"

  const form_id1294 = "#" + form_id;
  const form_elt = document.getElementById((form_id1294).slice(1)); //rwv vanilla change

  //form_elt.submit();
}
window.load_pages = load_pages;

function add_action_items(page_views) {
  // Grab the “administrator_div” if it exists
  const administratorDiv = document.getElementById('administrator_div');

  if (!page_views || page_views.length < 2) {
    return;
  }

  // Determine which <select> we’re targeting
  const table_name = page_views[0].page_name;
  const selectId   = "action_select_" + table_name;
  const selectEl   = document.getElementById(selectId);
  if (!selectEl) {
    return;
  }

  // Loop through each page_view
  page_views.forEach(page_view => {
    // Only add if unrestricted *or* admin div is present
    if (page_view.unrestricted || administratorDiv) {
      // Build a new <option>
      const id_str    = `action_select_${table_name}_${page_view.option_id}`;
      const value_str = String(page_view.option_id);

      const newOption = document.createElement('option');
      newOption.id    = id_str;
      newOption.value = value_str;
      newOption.textContent = page_view.page_option_str;

      // Append into the <select>
      selectEl.appendChild(newOption);

    } else {
      // preserve your original debug behavior
      if (table_name === "GroupUser") {
        alert("add_action_items");
      }
    }
  });
}

window.add_action_items = add_action_items;


function action_select0() {
  console.log("calling action_select0");

  var old_option_id = 0;

  const select_str = "action_select_" + old_page_name;

  const select_str1350 = "#" + select_str;
  console.log("action_select0: select_str = " + select_str1350);
  const select_elt = document.getElementById((select_str1350).slice(1)); //rwv vanilla change
  if (select_elt != null) {

    const option_id = parseInt(select_elt.value);
    const do_js = true;
    console.log("action_select0: option_id = " + option_id);
    display_select_action(old_page_name, option_id, do_js);
  }
  else {
    console.log("action_select0: select_elt is null");
  }

}
window.action_select0 = action_select0;

function action_select_no_js() {
  const select_str = "action_select_" + old_page_name;

  const select_str1362 = "#" + select_str;
  const select_elt = document.getElementById((select_str1362).slice(1)); //rwv vanilla change
  if (select_elt != null) {
    const option_id = parseInt(select_elt.value);
    const do_js = false;
    display_select_action(old_page_name, option_id, do_js);
  }
}
window.action_select_no_js = action_select_no_js;


function action_select2(table_name) {
  const select_str = "action_select_" + table_name;

  const select_str1374 = "#" + select_str;
  const select_elt = document.getElementById((select_str1374).slice(1)); //rwv vanilla change
  if (select_elt != null) {
    const option_id = parseInt(select_elt.value);
    const do_js = true;
    display_select_action(table_name, option_id, do_js);
  }
}
window.action_select2 = action_select2;

function display_page1(menu_name) {
  const table_name = sub_menu_hash.get(menu_name);
  const option_id = option_hash.get(table_name);
  const do_js = true;
  display_select_action(table_name, option_id, do_js);
}
window.display_page1 = display_page1;

function display_page2(menu_name, table_name) {
  sub_menu_hash.set(menu_name, table_name);
  const option_id = option_hash.get(table_name);
  const do_js = true;
  display_select_action(table_name, option_id, do_js);
}
window.display_page2 = display_page2;

function display_select_action(table_name, option_id, do_js) {
  console.log("display_select_action: " + table_name + " option_id: " + option_id);
  option_hash.set(table_name, option_id);
  if (old_page_name == null) {
    console.log("RWV old_page_name is null");
    old_page_name = "Person";
    old_option_id = 0;
  }
  const old_pages = displayPageCl.get(old_page_name);
  const old_page = old_pages[old_option_id];


  let page_views = displayPageCl.get(table_name);
  let page_view = page_views[option_id];
  var visible_divs = [];
  page_view.display_divs.forEach(function (display_div) {
    visible_divs.push(display_div.div_id);
  });
  var invisible_divs = [];
  old_page.display_divs.forEach(function (old_display_div) {
    if (visible_divs.indexOf(old_display_div.div_id) == -1) {
      invisible_divs.push(old_display_div.div_id);
    }
  });
  invisible_divs.forEach(function (invisible_div) {
    hide_div(invisible_div);
  });
  set_body_id(page_view.body_id);
  set_option(page_view.page_name, page_view.option_id);
  page_view.display_divs.forEach(function (display_div) {
    display_div.invisible_ids.forEach(function (invisible_id) {
      hide_div(invisible_id);
    });
    display_div.visible_ids.forEach(function (visible_id) {
      show_div(visible_id);
    });
    insert_div(display_div.div_id, display_div.insert_id);
    show_div(display_div.div_id);
    display_div.invisible_classes.forEach(function (invisible_class) {
      hide_class(display_div.div_id, invisible_class);
    });
    display_div.visible_classes.forEach(function (visible_class) {
      show_class(display_div.div_id, visible_class);
    });
    if (display_div.post_javascript.length > 0 && do_js) {
      eval(display_div.post_javascript);

    }
    scrollHandler();
  });




  old_page_name = table_name;
  old_option_id = option_id;
  separate_resizing();

}
window.display_select_action = display_select_action;

function separate_resizing() {
  const elements = document.querySelectorAll('.separator_class');
  elements.forEach(element => {
    element.style.width = '1px';
  });
  elements.forEach(element => {
    const content_div = element.closest('.content_div');
    const scroll_width = content_div.scrollWidth;
    // console.log("separate_resizing: setting width for " + element.id + " to " + scroll_width);
    element.style.width = scroll_width + 'px';
  });

}
function set_double_scroll() {
  console.log("set_double_scroll called for " + old_page_name + " option_id: " + old_option_id);
  const content_div_1 = document.getElementById('content_div_1');
  const content_div_2 = document.getElementById('content_div_2');


  const black_bar_separator_div = document.getElementById('black_bar_separator_div');

  const left_1_pos = getLeftOffset('content_div_1')
  const black_bar_width = getOuterWidth('black_bar_separator_div');


  //    bar_position_scale = 0.3;

  const bar_position_scale = getBarPositionScale();
  const frac_left_black_bar = getLeftOffset('black_bar_separator_div');
  //const frac_left_black_bar = (window.innerWidth - left_1_pos - black_bar_width) * bar_position_scale + left_1_pos;
  const left_black_bar = Math.floor(frac_left_black_bar + 0.5);

  const right_1_pos = left_black_bar - 1;
  const from_right_1_pos_str = "" + (window.innerWidth - right_1_pos - 1);
  const left_black_bar_str = "" + left_black_bar;

  const left_2_pos = right_1_pos + black_bar_width;




  console.log("left_black_bar_str = " + left_black_bar_str);
  console.log("from_right_1_pos_str = " + from_right_1_pos_str);
  console.log("bar_position_scale = " + bar_position_scale);
  console.log("window.innerWidth = " + window.innerWidth);
  console.log("left_1_pos = " + left_1_pos);
  console.log("right_1_pos = " + right_1_pos);
  console.log("black_bar_width = " + black_bar_width);
  console.log("frac_left_black_bar = " + frac_left_black_bar);
  console.log("left_black_bar = " + left_black_bar);
  content_div_1.style.right = from_right_1_pos_str + "px";
  content_div_2.style.left = left_black_bar_str + "px";
  //black_bar_separator_div.style.left = left_black_bar_str + "px";

}

function getLeftOffset(id) {
  const element = document.getElementById(id);
  const rect = element.getBoundingClientRect();
  const left_1_pos = rect.left + window.scrollX;
  console.log('getLeftOffset for id ' + id + ': returns ' + left_1_pos);
  //console.log('jQuery offset returns ' + jQuery('#'+id).offset().left);
  return left_1_pos;
}
function getOuterWidth(id) {
  const element = document.getElementById(id);
  const rect = element.getBoundingClientRect();
  const outer_width = rect.width;
  //console.log('getOuterWidth: returns ' + outer_width);
  //console.log('jQuery outerWidth returns ' + jQuery('#'+id).outerWidth());
  return outer_width;
}
window.getOuterWidth = getOuterWidth;
function scrollHandler() {
  console.log("scrollHandler called");

  const twoColumnDiv = document.getElementById('two_column_div');
  // “Is visible” → check computed display & visibility
  const twoColStyle = window.getComputedStyle(twoColumnDiv);
  if (twoColStyle.display !== 'none' && twoColStyle.visibility !== 'hidden') {
    set_double_scroll();
  }

  // For each “.separator_class”…
  document.querySelectorAll('.separator_class').forEach(separator => {
    // Find its closest ancestor with class “.content_div”
    const contentDiv = separator.closest('.content_div');
    if (!contentDiv) return;

    // Compute scrollWidth vs clientWidth
    const scrollWidth  = contentDiv.scrollWidth;
    const currentWidth = contentDiv.clientWidth;
    const widthStr     = (currentWidth < scrollWidth)
      ? scrollWidth + 'px'
      : '100%';

    // Set the width attribute
    separator.setAttribute('width', widthStr);
  });

  // finally…
  separate_resizing();
}

function getBarPositionScale() {
  const frac_left_black_bar = getLeftOffset('black_bar_separator_div');
  const left_1_pos = getLeftOffset('content_div_1');
  const black_bar_width = getOuterWidth('black_bar_separator_div');
  const bar_position_scale = (frac_left_black_bar - left_1_pos) / (window.innerWidth - left_1_pos - black_bar_width);
  console.log("getBarPositionScale: frac_left_black_bar = " + frac_left_black_bar);
  console.log("getBarPositionScale: left_1_pos = " + left_1_pos);
  console.log("getBarPositionScale: black_bar_width = " + black_bar_width);
  console.log("getBarPositionScale: bar_position_scale = " + bar_position_scale);
  return bar_position_scale;
}



function end_drag() {
  console.log("end_drag");

  scrollHandler();

}
window.end_drag = end_drag

window.separate_resizing = separate_resizing;

function action_select(table_name) {
  wait();
  const select_str = "action_select_" + table_name;

  const select_str1459 = "#" + select_str;
  const select_elt = document.getElementById((select_str1459).slice(1)); //rwv vanilla change
  if (select_elt != null) {
    const option_name = select_elt.val();
    const page_name_id = "display_page_name"
    const option_id = "display_page_option"
    const form_id = "display_page"

    const page_name_id1466 = "#" + page_name_id;
    const page_name_elt = document.getElementById((page_name_id1466).slice(1)); //rwv vanilla change

    const option_id1467 = "#" + option_id;
    const option_elt = document.getElementById((option_id1467).slice(1)); //rwv vanilla change

    const form_id1468 = "#" + form_id;
    const form_elt = document.getElementById((form_id1468).slice(1)); //rwv vanilla change
    page_name_elt.attr("value", table_name);
    option_elt.attr("value", option_name);

    //form_elt.submit();
  }
  else {
    unwait();
  }
}
window.action_select = action_select;


window.set_double_scroll = set_double_scroll;


