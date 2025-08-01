function deleteElement(table, count) {
    count = parseInt(count, 10);
    const counterId = "display_format_count_" + table;
    const counterInput = document.getElementById(counterId);
    let currentElts = parseInt(counterInput.value, 10);

    if (currentElts === 1) return;

    const fieldNames = [];
    const insertStrings = [];
    for (let i = count + 1; i < currentElts; i++) {
        const fieldInput = document.getElementById(`display_format_field_${table}_${i}`);
        fieldNames.push(fieldInput.value);

        const stringInput = document.getElementById(`display_format_string_${table}_${i}`);
        insertStrings.push(stringInput.value);
    }

    currentElts -= 1;

    for (let i = count; i < currentElts; i++) {
        const fieldInput = document.getElementById(`display_format_field_${table}_${i}`);
        fieldInput.value = fieldNames[i - count];

        const stringInput = document.getElementById(`display_format_string_${table}_${i}`);
        stringInput.value = insertStrings[i - count];
    }

    counterInput.value = currentElts;

    const toDelete = document.getElementById(`display_format_${table}_${currentElts}`);
    if (toDelete) toDelete.remove();

    if (currentElts === 1) {
        const removeLink = document.querySelector(`#display_format_${table}_0 .remove_format_field`);
        if (removeLink) removeLink.remove();
    }

    const minWidthDiv = document.getElementById("min_width_" + table);
    if (minWidthDiv) {
        minWidthDiv.style.minWidth = (currentElts * 230) + "px";
    }
}
window.deleteElement = deleteElement;

function addElement(table, count_str) {
    const count = parseInt(count_str, 10);
    const current_elts_str = "display_format_count_" + table;
    const current_elts_obj = document.getElementById(current_elts_str);
    const current_elts = parseInt(current_elts_obj.value, 10);

    if (current_elts === 1) {
        const first_textbox_str = "display_format_string_div_" + table + "_0";
        const first_textbox = document.getElementById(first_textbox_str);
        const parent_textbox = first_textbox.offsetParent;

        // Create remove link
        const new_a = document.createElement('a');
        new_a.href = "/";
        new_a.setAttribute('data-remote', "true");
        new_a.setAttribute('rel', "nofollow");
        new_a.onclick = function (e) {
            e.preventDefault();
            deleteElement(table, '0');
            return false;
        };
        new_a.textContent = "X";

        const new_a_div = document.createElement('div');
        new_a_div.className = 'remove_format_field';
        new_a_div.id = "remove_format_" + table + "_0";
        new_a_div.appendChild(new_a);

        parent_textbox.insertAdjacentElement('afterend', new_a_div);
    }

    let i, new_count;
    for (i = current_elts - 1; i >= count; i--) {
        const div_obj = document.getElementById('display_format_' + table + "_" + i);
        const display_format_string_div = document.getElementById('display_format_string_div_' + table + "_" + i);
        const display_format_field = document.getElementById('display_format_field_' + table + "_" + i);
        const display_format_string = document.getElementById('display_format_string_' + table + "_" + i);
        const remove_format = document.getElementById('remove_format_' + table + "_" + i);
        const aref_remove_format = remove_format.querySelector('a');
        const add_format = document.getElementById('add_format_' + table + "_" + i);
        const aref_add_format = add_format ? add_format.querySelector('a') : null;

        new_count = i + 1;

        div_obj.id = "display_format_" + table + "_" + new_count;
        display_format_string_div.id = "display_format_string_div_" + table + "_" + new_count;
        display_format_field.id = "display_format_field_" + table + "_" + new_count;
        display_format_field.name = "display_format_field_" + table + "_" + new_count;
        display_format_string.id = "display_format_string_" + table + "_" + new_count;
        display_format_string.name = "display_format_string_" + table + "_" + new_count;
        if (aref_remove_format) {
            aref_remove_format.onclick = function (e) {
                e.preventDefault();
                deleteElement(table, String(new_count));
                return false;
            };
        }
        remove_format.id = "remove_format_" + table + "_" + new_count;
        if (add_format) add_format.id = "add_format_" + table + "_" + new_count;
        if (aref_add_format) {
            aref_add_format.onclick = function (e) {
                e.preventDefault();
                addElement(table, String(new_count + 1));
                return false;
            };
        }
    }

    let pos_str, div_str;
    if (count === current_elts) {
        pos_str = 'after';
        div_str = "display_format_" + table + "_" + (count - 1);
    } else {
        pos_str = 'before';
        div_str = "display_format_" + table + "_" + (count + 1);
    }

    const first_div_obj = document.getElementById(div_str);
    const div_obj = first_div_obj.cloneNode(true);

    // Find elements inside the cloned div
    const display_format_string = div_obj.querySelector('input');
    const display_format_string_div = div_obj.querySelector('[id^="display_format_string_div_"]');
    const display_format_field = div_obj.querySelector('select');
    const remove_format = div_obj.querySelector('.remove_format_field');
    const aref_remove_format = remove_format ? remove_format.querySelector('a') : null;
    const add_format = div_obj.querySelector('.add_format_field');
    const aref_add_format = add_format ? add_format.querySelector('a') : null;

    new_count = count;
    div_obj.id = "display_format_" + table + "_" + new_count;
    if (display_format_string_div) display_format_string_div.id = "display_format_string_div_" + table + "_" + new_count;
    if (display_format_field) {
        display_format_field.id = "display_format_field_" + table + "_" + new_count;
        display_format_field.name = "display_format_field_" + table + "_" + new_count;
        display_format_field.value = "";
    }
    if (display_format_string) {
        display_format_string.id = "display_format_string_" + table + "_" + new_count;
        display_format_string.name = "display_format_string_" + table + "_" + new_count;
        display_format_string.value = "";
    }
    if (aref_remove_format) {
        aref_remove_format.onclick = function (e) {
            e.preventDefault();
            deleteElement(table, String(new_count));
            return false;
        };
    }
    if (remove_format) remove_format.id = "remove_format_" + table + "_" + new_count;
    if (add_format) add_format.id = "add_format_" + table + "_" + new_count;
    if (aref_add_format) {
        aref_add_format.onclick = function (e) {
            e.preventDefault();
            addElement(table, String(new_count + 1));
            return false;
        };
    }

    if (pos_str === 'before') {
        first_div_obj.parentNode.insertBefore(div_obj, first_div_obj);
    } else {
        first_div_obj.parentNode.insertBefore(div_obj, first_div_obj.nextSibling);
    }

    current_elts_obj.value = current_elts + 1;
    const min_width_div_str = "min_width_" + table;
    const width = (current_elts + 1) * 230;
    const minWidthDiv = document.getElementById(min_width_div_str);
    if (minWidthDiv) minWidthDiv.style.minWidth = width + "px";
}
window.addElement = addElement;

function resizeFormat() {
    function setStyleAll(selector, styleStr) {
        document.querySelectorAll(selector).forEach(function (el) {
            el.setAttribute('style', styleStr);
        });
    }

    function getElementHeight(id) {
        const el = document.getElementById(id);
        return el ? el.offsetHeight : 0;
    }

    var client_height = parseInt(getElementHeight('dummy_format'));
    var x_height = parseInt(getElementHeight('dummy_fx'));
    var p_height = parseInt(getElementHeight('dummy_fp'));
    var x_padding = (client_height - x_height) / 2.0;
    var p_padding = (client_height - p_height) / 2.0;
    var new_x_height = client_height - x_padding;
    var new_p_height = client_height - p_padding;

    var x_style_str = "background: #AAAAAA;  border-left: 1px solid;  border-color: #000000; float:right; height: " + new_x_height + "px; padding-top: " + x_padding + "px";
    var p_style_str = "background: #AAAAAA;  border: 1px solid #000; float:left; height: " + new_p_height + "px; padding-top: " + p_padding + "px";
    var select_style_str = "border:none; background-color: transparent; overflow:hidden; height: " + client_height + "px";
    var input_style_str = "border:none; height: " + client_height + "px";

    setStyleAll('.add_format_field', p_style_str);
    setStyleAll('.remove_format_field', x_style_str);
    setStyleAll('.format_select', select_style_str);
    setStyleAll('.format_input', input_style_str);
}
window.resizeFormat = resizeFormat;
