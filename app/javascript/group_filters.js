import Rails from "@rails/ujs";

function UpdateGroupFilter(table_name, foreign_key) {
    wait();

    const group_id_str = "group_filters_option_" + table_name + "_" + foreign_key;
    const group_id_obj = document.getElementById(group_id_str);
    if (!group_id_obj) return;

    const group_id = group_id_obj.value;

    document.getElementById('group_filters_table_name').value = table_name;
    document.getElementById('group_filters_foreign_key').value = foreign_key;
    document.getElementById('group_filters_group_id').value = group_id;

    const elem = document.getElementById('group_filters_form');
    Rails.fire(elem, 'submit');
}

function UpdateGroupFilter2(table_name, foreign_key)
{
    const x = 2;


}
