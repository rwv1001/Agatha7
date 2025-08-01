
function deleteElement(table, count) {
  count = parseInt(count, 10);
  const currentEltsId = "display_format_count_" + table;
  const currentEltsInput = document.getElementById(currentEltsId);
  let currentElts = parseInt(currentEltsInput.value, 10);

  if (currentElts === 1) {
    return;
  }

  // Gather values of all fields and strings after the one being deleted
  const fieldNames = [];
  const insertStrings = [];
  for (let i = count + 1; i < currentElts; i++) {
    const fieldInput = document.getElementById(`display_format_field_${table}_${i}`);
    fieldNames.push(fieldInput.value);

    const stringInput = document.getElementById(`display_format_string_${table}_${i}`);
    insertStrings.push(stringInput.value);
  }

  // Decrement total
  currentElts -= 1;

  // Shift values down by one
  for (let i = count; i < currentElts; i++) {
    const fieldInput = document.getElementById(`display_format_field_${table}_${i}`);
    fieldInput.value = fieldNames[i - count];

    const stringInput = document.getElementById(`display_format_string_${table}_${i}`);
    stringInput.value = insertStrings[i - count];
  }

  // Update the counter input
  currentEltsInput.value = currentElts;

  // Remove the last element row
  const deleteElt = document.querySelector(`#display_format_${table}_${currentElts}`);
  if (deleteElt) {
    deleteElt.remove();
  }

  // If we’re down to one element, also remove its “remove” link
  if (currentElts === 1) {
    const removeLink = document.querySelector("#display_format_" + table + "_0 .remove_format_field");
    if (removeLink) removeLink.remove();
  }

  // Finally, adjust the min-width on the container
  const minWidthDiv = document.getElementById("min_width_" + table);
  if (minWidthDiv) {
    // each element is 230px wide
    minWidthDiv.style.minWidth = (currentElts * 230) + "px";
  }
}
window.deleteElement = deleteElement;

function addElement(table, count) {
  count = parseInt(count);
  const current_elts_obj = document.getElementById("display_format_count_" + table);
  let current_elts = parseInt(current_elts_obj.value);

  if (current_elts === 1) {
    const first_textbox = document.getElementById("display_format_string_div_" + table + "_0");

    const new_a = document.createElement("a");
    new_a.href = "/";
    new_a.dataset.remote = "true";
    new_a.rel = "nofollow";
    new_a.onclick = function () {
      deleteElement(table, "0");
      return false;
    };
    new_a.innerHTML = "X";

    const new_a_div = document.createElement("div");
    new_a_div.className = "remove_format_field";
    new_a_div.id = "remove_format_" + table + "_0";
    new_a_div.appendChild(new_a);

    first_textbox.insertAdjacentElement("afterend", new_a_div);
  }

  for (let i = current_elts - 1; i >= count; i--) {
    const new_count = i + 1;
    const div_obj = document.getElementById("display_format_" + table + "_" + i);
    const display_format_string_div = document.getElementById("display_format_string_div_" + table + "_" + i);
    const display_format_field = document.getElementById("display_format_field_" + table + "_" + i);
    const display_format_string = document.getElementById("display_format_string_" + table + "_" + i);
    const remove_format = document.getElementById("remove_format_" + table + "_" + i);
    const add_format = document.getElementById("add_format_" + table + "_" + i);

    const aref_remove_format = remove_format.querySelector("a");
    const aref_add_format = add_format.querySelector("a");

    div_obj.id = "display_format_" + table + "_" + new_count;
    display_format_string_div.id = "display_format_string_div_" + table + "_" + new_count;
    display_format_field.id = "display_format_field_" + table + "_" + new_count;
    display_format_field.name = "display_format_field_" + table + "_" + new_count;
    display_format_string.id = "display_format_string_" + table + "_" + new_count;
    display_format_string.name = "display_format_string_" + table + "_" + new_count;
    aref_remove_format.setAttribute("onclick", "deleteElement('" + table + "','" + new_count + "');return false");
    remove_format.id = "remove_format_" + table + "_" + new_count;
    add_format.id = "add_format_" + table + "_" + new_count;
    aref_add_format.setAttribute("onclick", "addElement('" + table + "','" + (new_count + 1) + "');return false");
  }

  const div_str = (count === current_elts)
    ? "display_format_" + table + "_" + (count - 1)
    : "display_format_" + table + "_" + (count + 1);

  const first_div_obj = document.getElementById(div_str);
  const div_obj = first_div_obj.cloneNode(true);

  const display_format_string = div_obj.querySelector("input");
  const display_format_string_div = div_obj.querySelector(".display_format_string_div");
  const display_format_field = div_obj.querySelector("select");
  const remove_format = div_obj.querySelector(".remove_format_field");
  const aref_remove_format = remove_format.querySelector("a");
  const add_format = div_obj.querySelector(".add_format_field");
  const aref_add_format = add_format.querySelector("a");

  const new_count = count;
  div_obj.id = "display_format_" + table + "_" + new_count;
  display_format_string_div.id = "display_format_string_div_" + table + "_" + new_count;
  display_format_field.id = "display_format_field_" + table + "_" + new_count;
  display_format_field.name = "display_format_field_" + table + "_" + new_count;
  display_format_string.id = "display_format_string_" + table + "_" + new_count;
  display_format_string.name = "display_format_string_" + table + "_" + new_count;
  aref_remove_format.setAttribute("onclick", "deleteElement('" + table + "','" + new_count + "');return false");
  remove_format.id = "remove_format_" + table + "_" + new_count;
  add_format.id = "add_format_" + table + "_" + new_count;
  aref_add_format.setAttribute("onclick", "addElement('" + table + "','" + (new_count + 1) + "');return false");

  display_format_string.value = "";
  display_format_field.value = "";

  if (count === current_elts) {
    first_div_obj.insertAdjacentElement("afterend", div_obj);
  } else {
    first_div_obj.insertAdjacentElement("beforebegin", div_obj);
  }

  current_elts_obj.value = current_elts + 1;

  const min_width_div = document.getElementById("min_width_" + table);
  min_width_div.style.minWidth = (current_elts + 1) * 230 + "px";
}

window.addElement = addElement;

function resizeFormat() {
    var client_height = parseInt(getElementHeight('dummy_format'));
    var x_height = parseInt(getElementHeight('dummy_fx'));
    var p_height = parseInt(getElementHeight('dummy_fp'));
    var x_padding = (client_height - x_height) / 2.0;
    var p_padding = (client_height - p_height) / 2.0;
    var new_x_height = client_height - x_padding;
    var new_p_height = client_height - p_padding;

    var x_style_str = "background: #AAAAAA; border-left: 1px solid; border-color: #000000; float:right; height: " + new_x_height + "px; padding-top: " + x_padding + "px";
    var p_style_str = "background: #AAAAAA; border: 1px solid #000; float:left; height: " + new_p_height + "px; padding-top: " + p_padding + "px";
    var select_style_str = "border:none; background-color: transparent; overflow:hidden; height: " + client_height + "px";
    var input_style_str = "border:none; height: " + client_height + "px";

    document.querySelectorAll('.add_format_field').forEach(function(el) {
        el.setAttribute('style', p_style_str);
    });
    document.querySelectorAll('.remove_format_field').forEach(function(el) {
        el.setAttribute('style', x_style_str);
    });
    document.querySelectorAll('.format_select').forEach(function(el) {
        el.setAttribute('style', select_style_str);
    });
    document.querySelectorAll('.format_input').forEach(function(el) {
        el.setAttribute('style', input_style_str);
    });
}
window.resizeFormat = resizeFormat;


