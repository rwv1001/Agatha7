function wait() {

    jQuery('#disable_id').show();
    jQuery('#disable_id').css('cursor', 'wait');


}
window.wait = wait;
function unwait() {
    jQuery('#disable_id').hide();
    jQuery('#disable_id').css('cursor', 'default');

}
window.unwait = unwait;

function deleteColumn(field_name, table_name) {
    wait();
    const table_text_element_str = "table_selector_text_" + table_name

    const table_text_element_str29 = "#" + table_text_element_str;
    const table_text_element = jQuery(table_text_element_str29);
    if (table_text_element[0] != null) {
        table_text_element.attr("value", table_name);
    }
    const class_name = field_name + "_" + table_name
    let column_elements = jQuery("td." + class_name)
    column_elements.each(function () {
        jQuery(this).remove()
    });
    column_elements = jQuery("th." + class_name)
    column_elements.each(function () {
        jQuery(this).remove()
    });
    const num_filters_obj = jQuery('#all_display_indices_' + table_name);
    const num_filters = parseInt(num_filters_obj.val()) - 1;
    num_filters_obj.val(num_filters);
    if (num_filters <= 1) {

        const search_div = jQuery('#search_results_' + table_name);
        const current_div = jQuery('#current_filters_' + table_name);
        var x_elements_search = search_div.find('.remove_column').first();
        var x_elements_current = current_div.find('remove_column.').first();
        if (typeof (x_elements_search) != "undefined") {
            x_elements_search.remove();
        }
        if (typeof (x_elements_current) != "undefined") {
            x_elements_current.remove();
        }
    }

    const do_search_str = "do_search_" + table_name;

    const do_search_str64 = "#" + do_search_str;
    const do_search_element = jQuery(do_search_str64);
    do_search_element.attr("name", "do_not_search");


    const form_id = 'search_form_' + table_name;
    const elem = document.getElementById(form_id);
    Rails.fire(elem, 'submit');;
}
window.deleteColumn = deleteColumn;

function setSearchIndices(table_name) {
    const rows_class_str = ".row_" + table_name;
    const row_count = 0;
    const row_str = ""
    jQuery(rows_class_str).each(function () {
        const id_td = jQuery(this).children().first()
        if (id_td != null) {
            const id_array = id_td.html().match(/\b\d+\b/)
            if (id_array != null) {
                const row_count = row_count + 1;
                if (row_str.length != 0) {
                    const row_str = row_str + ", " + id_array[0];

                }
                else {
                    const row_str = row_str + id_array[0];
                }
            }
        }
    });
    if (row_count > 0 && row_count < 150) {
        const order_index_element_str = "#order_indices_" + table_name;
        const order_index_element = jQuery(order_index_element_str);

        order_index_element.attr("name", "order_indices");
        order_index_element.attr("value", row_str);
    }

}
window.setSearchIndices = setSearchIndices;

function invert_selection(table_name, check_str) {
    const check_box_strs = '#search_results_' + table_name + ' input.' + check_str;
    const check_boxes = jQuery(check_box_strs);
    check_boxes.each(function () {
        const box = jQuery(this);
        box.prop('checked', !box.is(':checked'));
        if (check_str == 'check') {
            if (!box.is(':checked')) {
                box.closest('tr').find('.compulsorycheck:first').prop('checked', false);
                box.closest('tr').find('.examcheck:first').prop('checked', false);
            }

        } else {
            if (box.is(':checked')) {
                box.closest('tr').find('.check:first').prop('checked', true);
            }
        }
    });

}
window.invert_selection = invert_selection;

function setSelectIndices(table_name) {
    const search_results_div_str = "#search_results_" + table_name;
    const search_results_div = jQuery(search_results_div_str);
    const specific_div_str = "#order_checks_" + table_name;
    const specific_div = jQuery(specific_div_str);
    specific_div.children().each(function () { jQuery(this).remove() });

    insert_specific_div_checks(specific_div, search_results_div, '.check');

    if (table_name == "Person") {
        insert_specific_div_checks(specific_div, search_results_div, '.examcheck');
        insert_specific_div_checks(specific_div, search_results_div, '.compulsorycheck');
    }

}
window.setSelectIndices = setSelectIndices;

function searchOrder(field_name, table_name) {
    wait();
    const order_element_str = "order_text_" + table_name;

    const order_element_str74 = "#" + order_element_str;
    const order_element = jQuery(order_element_str74);

    order_element.attr("name", "order_text");
    order_element.attr("value", field_name);


    setSearchIndices(table_name);
    setSelectIndices(table_name);

    disableSubmitters();

    const do_search_str = "do_search_" + table_name;

    const do_search_str81 = "#" + do_search_str;
    const do_search_element = jQuery(do_search_str81);
    do_search_element.attr("name", "do_search");

    const search_form_str = "search_form_" + table_name;

    const search_form_str85 = "#" + search_form_str;
    const my_form = jQuery(search_form_str85);
    const elem = document.getElementById(search_form_str);
    Rails.fire(elem, 'submit');;
}
window.searchOrder = searchOrder;

function disableSubmitters() {


}
window.disableSubmitters = disableSubmitters;

function resizeX() {
    var client_height = parseInt(jQuery('#dummy_x').height());
    var a_height = jQuery('#dummy_a').height();
    var new_padding = (client_height - parseInt(a_height)) / 2;
    var new_height = client_height - new_padding;
    var style_str = "background: #AAAAAA;  border-left: 1px solid; border-color: #000000;  float: right; height: " + new_height + "px; padding-top: " + new_padding + "px"
    jQuery('.remove_column').each(function () {
        //  jQuery(this).attr('style',style_str)
        jQuery(this).css('height', new_height);
        jQuery(this).css('padding-top', new_padding);
    });


    jQuery('.div_column_edit').each(function () {
        jQuery(this).css('height', new_height);
        jQuery(this).css('padding-top', new_padding);
    });

}
window.resizeX = resizeX;

function doEscapeHTML(class_id_name) {
    const sent_text_element_str = class_id_name + "_sent"

    const sent_text_element_str116 = "#" + sent_text_element_str;
    const sent_text_element = jQuery(sent_text_element_str116);

    const sent_text_element_str117 = "#" + sent_text_element_str;
    const sent_text_element_value = jQuery(sent_text_element_str117).val();
    const sent_text_element_value_esc = sent_text_element_value.escapeHTML();
    sent_text_element.attr("value", sent_text_element_value_esc);
}
window.doEscapeHTML = doEscapeHTML;

function updatePostFilterStrings(class_id_name) {
    const sent_text_element_str = class_id_name + "_sent"
    const typed_text_element_str = class_id_name + "_typed"

    const sent_text_element_str125 = "#" + sent_text_element_str;
    const sent_text_element = jQuery(sent_text_element_str125);

    const typed_text_element_str126 = "#" + typed_text_element_str;
    const typed_text_element = jQuery(typed_text_element_str126);
    const typed_filter_str = typed_text_element.val();
    const typed_filter_str_esc = typed_filter_str.escapeHTML()
    sent_text_element.attr("value", typed_filter_str_esc);
}
window.updatePostFilterStrings = updatePostFilterStrings;

function updatePostExternalFilter(class_id_name) {
    const sent_text_element_str = class_id_name + "_sent"
    const typed_text_element_str = class_id_name + "_typed"

    const sent_text_element_str136 = "#" + sent_text_element_str;
    const sent_text_element = jQuery(sent_text_element_str136);

    const typed_text_element_str137 = "#" + typed_text_element_str;
    const typed_text_element = jQuery(typed_text_element_str137);
    const typed_filter_str = parseInt(typed_text_element.val());
    sent_text_element.val(typed_filter_str);
    const x = 1;

}
window.updatePostExternalFilter = updatePostExternalFilter;

function Search(table_name) {
    wait();
    resizeFilters();
    //   jQuery('#person_id_Person_x').hasAttribute('style')
    // jQuery('#person_first_name_Person_x').attr('style','float:right; height: 190px');

    const current_filter_str = "current_filters_" + table_name;

    const current_filter_str152 = "#" + current_filter_str;
    const current_filter_element = jQuery(current_filter_str152);
    current_filter_element.style.display = 'none';
    const do_search_str = "do_search_" + table_name;

    const do_search_str155 = "#" + do_search_str;
    const do_search_element = jQuery(do_search_str155);
    do_search_element.attr("name", "do_search");

    const form_id = "search_form_" + table_name

    const form_id159 = "#" + form_id;
    const form_element = jQuery(form_id159);
    const elem = document.getElementById(form_id);
    Rails.fire(elem, 'submit');

}
window.Search = Search;

function AddField(table_name) {
    wait();
    const text_element_id = "add_filter_value_" + table_name
    const select_id = "possible_filters_" + table_name

    const select_id168 = "#" + select_id;
    const selected_val = jQuery(select_id168).val();

    if (selected_val == "do_nothing") {
        return;
    }

    const current_filter_str = "current_filters_" + table_name;

    const current_filter_str176 = "#" + current_filter_str;
    const current_filter_element = jQuery(current_filter_str176);
    const no_results = current_filter_element.is(':visible');
    const do_search_str = "do_search_" + table_name;

    const do_search_str179 = "#" + do_search_str;
    const do_search_element = jQuery(do_search_str179);
    if (no_results) {
        do_search_element.attr("name", "do_not_search");
    }
    else {
        do_search_element.attr("name", "do_search");
    }


    const text_element_id189 = "#" + text_element_id;
    const text_element = jQuery(text_element_id189);
    text_element.attr("name", selected_val);
    text_element.attr("value", "%");
    const form_id = "search_form_" + table_name

    const form_id193 = "#" + form_id;
    const form_element = jQuery(form_id193);
    const elem = document.getElementById(form_id);
    Rails.fire(elem, 'submit');
}
window.AddField = AddField;

function AddFilter(table_name) {
    wait();
    const select_elt_str = "possible_external_filters_" + table_name;

    const select_elt_str200 = "#" + select_elt_str;
    const select_elt = jQuery(select_elt_str200);
    const selected_val = select_elt.val();



    if (selected_val == "do_nothing") {
        return;
    }

    const option_idd = "possible_external_filters_" + table_name + "_" + selected_val;

    const option_id211 = "#" + option_idd;
    const option_elt = jQuery(option_id211);
    option_elt.remove();

    const text_element_str = "add_external_filter_id_" + table_name;

    const text_element_str215 = "#" + text_element_str;
    const text_elt = jQuery(text_element_str215);
    text_elt.attr("value", selected_val);

    const text_num_filters_str = "number_of_external_filters_" + table_name;

    const text_num_filters_str219 = "#" + text_num_filters_str;
    const text_num_filters_elt = jQuery(text_num_filters_str219);
    const current_num_filters = parseInt(text_num_filters_elt.val());
    if (current_num_filters == 0) {
        const header_str = "external_filters_header_" + table_name;

        const header_str224 = "#" + header_str;
        const header_elt = jQuery(header_str224);
        header_elt.html("<label>Search Filters </label>")
    }
    const new_num_filters = current_num_filters + 1;
    text_num_filters_elt.attr("value", new_num_filters);

    const form_id = "add_external_filter_" + table_name;

    const form_id231 = "#" + form_id;
    const form_element = jQuery(form_id231);
    const elem = document.getElementById(form_id);
    Rails.fire(elem, 'submit');
}
window.AddFilter = AddFilter;

function onUpdateExternalFilterGroup(class_name, filter_id, elt_id) {
    const filter_id_str = "update_external_filter_id_" + class_name;
    const elt_id_str = "update_external_elt_index_" + class_name;
    const member_id_str = "update_external_member_id_" + class_name;
    const group_id_str = "update_external_group_id_" + class_name;


    const filter_id_str242 = "#" + filter_id_str;
    const filter_id_elt = jQuery(filter_id_str242);

    const elt_id_str243 = "#" + elt_id_str;
    const elt_id_elt = jQuery(elt_id_str243);

    const member_id_str244 = "#" + member_id_str;
    const member_id_elt = jQuery(member_id_str244);

    const group_id_str245 = "#" + group_id_str;
    const group_id_elt = jQuery(group_id_str245);

    const group_select_id_str = "group_selection_" + class_name + "_" + filter_id + "_" + elt_id;
    const member_select_id_str = "argument_selection_" + class_name + "_" + filter_id + "_" + elt_id;

    const group_select_id_str249 = "#" + group_select_id_str;
    const group_select_elt = jQuery(group_select_id_str249);

    const member_select_id_str250 = "#" + member_select_id_str;
    const member_select_elt = jQuery(member_select_id_str250);
    const group_id = group_select_elt.val();
    const member_id = member_select_elt.val();

    filter_id_elt.attr("value", filter_id);
    elt_id_elt.attr("value", elt_id);

    member_id_elt.attr("value", member_id);
    group_id_elt.attr("value", group_id);

    const form_str = "update_external_filter_" + class_name;

    const form_str261 = "#" + form_str;
    const form_elt = jQuery(form_str261);

    const elem = document.getElementById(form_str);
    Rails.fire(elem, 'submit');

}
window.onUpdateExternalFilterGroup = onUpdateExternalFilterGroup;

function addExternalFilterElement(class_name, filter_id) {
    const num_elts_str = "number_of_filter_elements_" + class_name + "_" + filter_id;

    const num_elts_str268 = "#" + num_elts_str;
    const num_elts_elt = jQuery(num_elts_str268);
    const max_filter_element_str = "#max_filter_elements_" + class_name + "_" + filter_id;
    const max_filter_element = jQuery(max_filter_element_str);
    const current_num_elts = parseInt(num_elts_elt.val());
    const new_elt_id = current_num_elts;
    const new_current_num = current_num_elts + 1;
    num_elts_elt.attr("value", new_current_num);
    max_filter_element.attr("value", new_elt_id + 1);

    const prev_elt_id = new_elt_id - 1;
    const prev_elt = null;
    const max_id = 0;
    let new_elt = null;
    while (prev_elt_id >= 0 && prev_elt == null) {
        const prev_elt_str = "external_filter_selection_" + class_name + "_" + filter_id + "_" + prev_elt_id;


        const prev_elt_str277 = "#" + prev_elt_str;
        const prev_elt = jQuery(prev_elt_str277)[0];
        const prev_elt_id = prev_elt_id - 1;

    }
    new_elt = jQuery(prev_elt).clone(true);


    new_elt.attr('id', "external_filter_selection_" + class_name + "_" + filter_id + "_" + new_elt_id);
    const external_filter_group_selection = new_elt.find('.external_filter_group_selection_' + class_name)[0];
    if (typeof (external_filter_group_selection) != "undefined") {
        jQuery(external_filter_group_selection).attr('id', "group_selection_" + class_name + "_" + filter_id + "_" + new_elt_id);

        jQuery(external_filter_group_selection).attr("onchange", "onUpdateExternalFilterGroup('" + class_name + "','" + filter_id + "','" + new_elt_id + "');return false");
        const old_filter_group_selection = jQuery(prev_elt).find('.external_filter_group_selection_' + class_name)[0];
        const old_group_selection_value = jQuery(old_filter_group_selection).val();
        const group_class_str = ".group_class_" + old_group_selection_value
        const external_filter_group_selected = jQuery(external_filter_group_selection).find(group_class_str)[0];
        jQuery(external_filter_group_selected).prop('selected', true);

    }
    const external_filter_argument_span_element = new_elt.find('.external_filter_argument_span').first();
    external_filter_argument_span_element.attr('id', "external_filter_argument_span_" + class_name + "_" + filter_id + "_" + new_elt_id);
    const argument_selection_element = new_elt.find('.external_filter_argument_selection').first();
    argument_selection_element.attr('id', "argument_selection_" + class_name + "_" + filter_id + "_" + new_elt_id);
    argument_selection_element.attr('name', "argument_selection_" + filter_id + "_" + new_elt_id);
    const filter_element_field = new_elt.find('.remove_filter_element_field').first();;
    const filter_element_field_a = filter_element_field.find('a').first();
    filter_element_field_a.attr('onclick', "deleteExternalFilterElement('" + class_name + "','" + filter_id + "','" + new_elt_id + "');return false");

    var new_space = jQuery("<div></div>").attr({ style: 'float: left' });
    //   new_space.html("&nbsp")
    new_space.insertAfter(prev_elt)
    //prev_elt.after(new_space);
    const next_space = prev_elt.next('div');
    new_elt.insertAfter(next_space);
    //next_space.after(new_elt);
}
window.addExternalFilterElement = addExternalFilterElement;

function deleteExternalFilterElement(class_name, filter_id, elt_id) {


    const filter_selection_str = "external_filter_selection_" + class_name + "_" + filter_id + "_" + elt_id;

    const filter_selection_str316 = "#" + filter_selection_str;
    const filter_selection_elt = jQuery(filter_selection_str316);
    const div_space = filter_selection_elt.next('div');
    filter_selection_elt.remove();
    //  div_space.remove();

    const num_elts_str = "number_of_filter_elements_" + class_name + "_" + filter_id;

    const num_elts_str322 = "#" + num_elts_str;
    const num_elts_elt = jQuery(num_elts_str322);

    const current_num_elts = parseInt(num_elts_elt.val());
    const new_current_num = current_num_elts - 1;
    if (new_current_num == 0) {

        let header_str = "external_filters_header_" + class_name;

        const header_str330 = "#" + header_str;
        const header_elt = jQuery(header_str330);


        const header_container_str = "external_filter_header_" + class_name + "_" + filter_id;

        const header_container_str334 = "#" + header_container_str;
        const header_container = jQuery(header_container_str334);
        header_str = header_container.html();
        const extended_filter_str = "external_filter_" + class_name + "_" + filter_id;

        const extended_filter_str337 = "#" + extended_filter_str;
        const extended_filter_elt = jQuery(extended_filter_str337);
        extended_filter_elt.remove();
        const num_filters_str = "number_of_external_filters_" + class_name;

        const num_filters_str340 = "#" + num_filters_str;
        const num_filters_elt = jQuery(num_filters_str340);
        const current_num_filters = parseInt(num_filters_elt.val());
        const new_num_filters = current_num_filters - 1;
        num_filters_elt.attr("value", new_num_filters);
        if (new_num_filters == 0) {
            header_elt.html("")
        }



        const possible_select_str = "possible_external_filters_" + class_name;

        const possible_select_str352 = "#" + possible_select_str;
        const possible_select_elt = jQuery(possible_select_str352);
        const not_set_option = possible_select_elt.find('option').first();
        const first_option = not_set_option.next();

        var new_option = jQuery("<option>", { id: 'possible_external_filters_' + class_name + '_' + filter_id, value: filter_id });
        new_option.html(header_str)
        if (first_option[0] == null) {
            new_option.insertAfter(not_set_option);
        }
        else {
            const current_elt = first_option;
            const current_value = parseInt(current_elt.val());
            if (current_value > filter_id) {
                new_option.insertAfter(not_set_option);
            }
            else {
                const next_elt = current_elt.next();
                while (next_elt[0] != null && parseInt(next_elt.val()) < filter_id) {
                    const current_elt = next_elt;
                    const next_elt = current_elt.next();
                }
                new_option.insertAfter(current_elt);
            }
        }
    }
    else {
        num_elts_elt.attr("value", new_current_num);

        for (reorder_index = parseInt(elt_id) + 1; reorder_index <= new_current_num; reorder_index++) {
            const filter_selection_str = "external_filter_selection_" + class_name + "_" + filter_id + "_" + reorder_index;
            const new_id = "external_filter_selection_" + class_name + "_" + filter_id + "_" + (reorder_index - 1);

            const filter_selection_str316 = "#" + filter_selection_str;
            const filter_selection_elt = jQuery(filter_selection_str316);
            filter_selection_elt.prop('id', new_id);

            const external_filter_argument_span_str = "external_filter_argument_span_" + class_name + "_" + filter_id + "_" + reorder_index;
            const new_external_filter_argument_span_str = "external_filter_argument_span_" + class_name + "_" + filter_id + "_" + (reorder_index - 1);
            const external_filter_argument_span_elt = jQuery("#" + external_filter_argument_span_str);
            external_filter_argument_span_elt.prop('id', new_external_filter_argument_span_str);

            const onclick_str = "deleteExternalFilterElement('" + class_name + "','" + filter_id + "','" + (reorder_index - 1) + "');return false;"
            external_filter_argument_span_elt.find('a').attr('onclick', onclick_str);


            const argument_selection_str = '#argument_selection_' + class_name + '_' + filter_id + '_' + reorder_index;
            const new_namer = 'argument_selection_' + filter_id + '_' + (reorder_index - 1);
            const new_idr = 'argument_selection_' + class_name + '_' + filter_id + '_' + (reorder_index - 1);
            const argument_selection_elt = jQuery(argument_selection_str);
            argument_selection_elt.prop('id', new_idr);
            argument_selection_elt.prop('name', new_namer);
        }
    }

}
window.deleteExternalFilterElement = deleteExternalFilterElement;

function resizeExternalFilters(class_name) {

    var client_height = jQuery('#dummy_x').height();
    var height_str = "" + client_height + "px"
    jQuery('.external_filter_group_selection_' + class_name).each(function () {
        jQuery(this).css({ height: height_str });
    });
    jQuery('.external_filter_argument_selection').each(function () {
        jQuery(this).css({ height: height_str });
    });
    jQuery('.external_filter_element').each(function () {
        jQuery(this).css({ height: height_str });
    });

    var a_height = jQuery('#dummy_a').height();
    var new_padding = ((client_height - parseInt(a_height)) / 2);
    var new_height = client_height - new_padding;



    jQuery('.add_external_filter_element').each(function () {
        jQuery(this).css("height", new_height);
        jQuery(this).css("padding-top", new_padding);
    });
    jQuery('.remove_filter_element_field').each(function () {
        jQuery(this).css("height", new_height);
        jQuery(this).css("padding-top", new_padding);
    });
}
window.resizeExternalFilters = resizeExternalFilters;

function resizeFilters() {
    var client_height = parseInt(jQuery('#dummy_x').height());
    var narrow_width = parseInt(jQuery('#dummy_format_narrow').width());
    var wide_width = parseInt(jQuery('#dummy_format').width());
    var x_height = parseInt(jQuery('#dummy_fx').height());
    var p_height = parseInt(jQuery('#dummy_fp').height());
    var x_padding = (client_height - x_height) / 2.0;
    var p_padding = (client_height - p_height) / 2.0;
    var new_x_height = client_height - x_padding;
    var new_p_height = client_height - p_padding;

    var x_style_str = "background: #AAAAAA;  border-left: 1px solid;  border-color: #000000; float:right; height: " + new_x_height + "px; padding-top: " + x_padding + "px";
    var p_style_str = "background: #AAAAAA;  border: 1px solid #000; float:left; height: " + new_p_height + "px; padding-top: " + p_padding + "px";
    var select_style_str = "border:none; background-color: transparent; overflow:hidden; height: " + client_height * 2 + "px"
    var input_style_str = "border:none; height: " + client_height + "px"
    var height_str = "" + client_height + "px"
    var wide_width_str = "" + wide_width + "px"
    var narrow_width_str = "" + narrow_width + "px"
    //  var p_style_str = "background: #AAAAAA;  border: 1px solid #000; float:left; height: 60px: padding-top: " + p_padding + "px";


    jQuery('.select_filter').each(function () {
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

function group_unrestriction() {
    const external_filter_Group_0 = jQuery('#external_filter_Group_0');
    if (external_filter_Group_0[0] != null) {
        external_filter_Group_0.style.display = '';
    }


}
window.group_unrestriction = group_unrestriction;

function group_restriction_timeout(table_name, do_update) {
    const external_filter_Group_0 = jQuery('#external_filter_Group_0');
    const select_obj = jQuery('#argument_selection_Group_0_0');

    if (external_filter_Group_0[0] == null || select_obj[0] == null) {
        const function_str = 'group_restriction_timeout("' + table_name + '",' + do_update + ')';
        //       setTimeout("alert('hi there')", 100);
        setTimeout(function_str, 10);
    }
    else {
        external_filter_Group_0.style.display = 'none';
        const select_value = select_obj.val();
        if (select_value != table_name) {
            const do_update = true;
            const options = select_obj.find('option');
            options.each(function () {
                const x = 1;
                if (jQuery(this).val() == table_name) {

                    jQuery(this).prop('selected', true);
                    const class_name = jQuery(this).text()
                    return false;
                }

            });

        }
        if (do_update) {
            Search("Group")


        }
    }
}
window.group_restriction_timeout = group_restriction_timeout;

function group_restriction(table_name) {

    const select_obj = jQuery('#argument_selection_Group_0_0');

    const do_update = false;
    if (select_obj[0] == null) {
        const select_elt_str = "possible_external_filters_Group";

        const select_elt_str567 = "#" + select_elt_str;
        const select_elt = jQuery(select_elt_str567);
        const options = select_elt.find('option');
        options.each(function () {
            const x = 1;
            if (jQuery(this).val() == 0) {
                jQuery(this).prop('selected', true);
                return false;
            }

        });

        AddFilter('Group');
        const do_update = true;


    }

    group_restriction_timeout(table_name, do_update)
}
window.group_restriction = group_restriction;
