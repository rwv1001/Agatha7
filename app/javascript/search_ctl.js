import Rails from "@rails/ujs";


function wait() {

  document.getElementById('disable_id').style.display = '';
  document.getElementById('disable_id').style.cursor = 'wait';


}
window.wait = wait;
function unwait() {
  document.getElementById('disable_id').style.display = 'none';
  document.getElementById('disable_id').style.cursor = 'default';

}
window.unwait = unwait;



function setSearchIndices(table_name) {
  const rows = document.querySelectorAll(".row_" + table_name);
  let row_count = 0;
  let row_str = "";

  rows.forEach(function (row) {
    const id_td = row.children[0];
    if (id_td != null) {
      const id_array = id_td.innerHTML.match(/\b\d+\b/);
      if (id_array != null) {
        row_count++;
        if (row_str.length !== 0) {
          row_str += ", " + id_array[0];
        } else {
          row_str = id_array[0];
        }
      }
    }
  });

  if (row_count > 0 && row_count < 150) {
    const order_index_element = document.getElementById("order_indices_" + table_name);
    if (order_index_element) {
      order_index_element.setAttribute("name", "order_indices");
      order_index_element.setAttribute("value", row_str);
    }
  }
}
window.setSearchIndices = setSearchIndices;

function invert_selection(table_name, check_str) {
  const check_box_strs = `#search_results_${table_name} input.${check_str}`;
  const check_boxes = document.querySelectorAll(check_box_strs);
  check_boxes.forEach(box => {
    box.checked = !box.checked;
    if (check_str === 'check') {
      if (!box.checked) {
        const tr = box.closest('tr');
        const compulsoryCheck = tr.querySelector('.compulsorycheck');
        const examCheck = tr.querySelector('.examcheck');
        if (compulsoryCheck) compulsoryCheck.checked = false;
        if (examCheck) examCheck.checked = false;
      }
    } else {
      if (box.checked) {
        const tr = box.closest('tr');
        const check = tr.querySelector('.check');
        if (check) check.checked = true;
      }
    }
  });
}
window.invert_selection = invert_selection;

function setSelectIndices(table_name) {
  console.log("🔍 setSelectIndices called for table:", table_name);
  const search_results_div = document.getElementById("search_results_" + table_name);
  const specific_div = document.getElementById("order_checks_" + table_name);

  console.log("🔍 search_results_div:", search_results_div);
  console.log("🔍 specific_div:", specific_div);

  // Check if the required elements exist
  if (!search_results_div || !specific_div) {
    console.warn("setSelectIndices: Missing required elements for table " + table_name);
    return;
  }

  // Clear all children from specific_div
  while (specific_div.firstChild) {
    specific_div.removeChild(specific_div.firstChild);
  }

  console.log("🔍 About to copy .check checkboxes");
  insert_specific_div_checks(specific_div, search_results_div, '.check');

  if (table_name === "Lecture") {
    console.log("🔍 About to copy .examcheck and .compulsorycheck for Lecture table");
    insert_specific_div_checks(specific_div, search_results_div, '.examcheck');
    insert_specific_div_checks(specific_div, search_results_div, '.compulsorycheck');
  }

  console.log("🔍 setSelectIndices completed. specific_div now has", specific_div.children.length, "elements");
}
window.setSelectIndices = setSelectIndices;

function restoreSelectIndices(table_name, savedCheckboxStates = null) {
  console.log("🔄 restoreSelectIndices called for table:", table_name);
  console.log("🔄 savedCheckboxStates:", savedCheckboxStates);

  const search_results_div = document.getElementById("search_results_" + table_name);

  // Check if the required elements exist
  if (!search_results_div) {
    console.warn("restoreSelectIndices: Missing search_results_div for table " + table_name);
    return;
  }

  if (savedCheckboxStates && Object.keys(savedCheckboxStates).length > 0) {
    // Use the passed saved states directly
    console.log("🔄 Using passed savedCheckboxStates with", Object.keys(savedCheckboxStates).length, "entries");

    Object.keys(savedCheckboxStates).forEach(function (key) {
      const checked = savedCheckboxStates[key];

      // Extract name and value from key like "row_in_list[][2136]"
      const match = key.match(/^([^[]+\[\])\[([^\]]+)\]$/);
      console.log("🔄 Restoring checkbox state for key:", key, "checked:", checked, "match:", match);
      if (match) {
        const name = match[1];  // This already includes the []
        const value = match[2];

        console.log("🔄 Restoring checkbox - name:", name, "value:", value, "checked:", checked);

        const target_check = search_results_div.querySelector(`input[name="${name}"][value="${value}"]`);
        if (target_check) {
          console.log("🔄 Found target checkbox, setting checked =", checked);
          target_check.checked = checked;
        } else {
          console.warn("🔄 Could not find target checkbox for name:", name, "value:", value);
        }
      } else {
        console.warn("🔄 No match found for key:", key);
      }

    });
  } else {
    // Fallback to old method using order_checks div
    console.log("🔄 No savedCheckboxStates provided, falling back to order_checks div method");
    const specific_div = document.getElementById("order_checks_" + table_name);

    console.log("🔄 specific_div:", specific_div);
    console.log("🔄 specific_div has", specific_div ? specific_div.children.length : 0, "saved elements");

    if (!specific_div) {
      console.warn("restoreSelectIndices: Missing order_checks div for table " + table_name);
      return;
    }

    // Restore checkbox states from specific_div back to search_results_div
    const saved_checks = specific_div.querySelectorAll('input[type="checkbox"]');
    console.log("🔄 Found", saved_checks.length, "saved checkboxes to restore");

    saved_checks.forEach(function (saved_check, index) {
      const name = saved_check.getAttribute('name');
      const value = saved_check.getAttribute('value');
      const checked = saved_check.checked;

      console.log("🔄 Restoring checkbox", index, "- name:", name, "value:", value, "checked:", checked);

      if (name && value) {
        const target_check = search_results_div.querySelector(`input[name="${name}"][value="${value}"]`);
        if (target_check) {
          console.log("🔄 Found target checkbox, setting checked =", checked);
          target_check.checked = checked;
        } else {
          console.warn("🔄 Could not find target checkbox for name:", name, "value:", value);
        }
      }
    });
  }

  console.log("🔄 restoreSelectIndices completed");
}
window.restoreSelectIndices = restoreSelectIndices;



function testOrderToggle(field_name, table_name) {
  console.log('🧪 TEST: testOrderToggle called with field_name=' + field_name + ', table_name=' + table_name);

  // Make AJAX call using FormData like the working increment counter
  const formData = new FormData();
  formData.append('field_name', field_name);
  formData.append('table_name', table_name);

  fetch('/welcome/order_toggle', {
    method: 'POST',
    headers: {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    },
    body: formData
  })
    .then(response => response.json())
    .then(data => {
      console.log('🧪 TEST: Response received:', data);

      // Display the results on the page
      displayOrderToggleResults(data);
    })
    .catch(error => {
      console.error('🧪 TEST: Error:', error);
    });
}
window.testOrderToggle = testOrderToggle;

function displayOrderToggleResults(data) {
  // Find or create a display area for our test results
  let displayDiv = document.getElementById('order_toggle_test_results');
  if (!displayDiv) {
    displayDiv = document.createElement('div');
    displayDiv.id = 'order_toggle_test_results';
    displayDiv.style.cssText = 'background: #ffffcc; border: 2px solid #cccc00; padding: 10px; margin: 10px; font-family: monospace;';

    // Insert at the top of the search results area
    const searchResults = document.querySelector('#search_results_Person, [class*="search_results"]');
    if (searchResults && searchResults.parentNode) {
      searchResults.parentNode.insertBefore(displayDiv, searchResults);
    } else {
      // Fallback: add to body
      document.body.insertBefore(displayDiv, document.body.firstChild);
    }
  }

  displayDiv.innerHTML = `
        <h3>🧪 Order Toggle Test Results</h3>
        <p><strong>🔢 Toggle Counter:</strong> ${data.toggle_counter || 0}</p>
        <p><strong>Field:</strong> ${data.field_name}</p>
        <p><strong>Table:</strong> ${data.table_name}</p>
        <p><strong>Field Index:</strong> ${data.hash_to_index || 'N/A (commented out)'}</p>
        <p><strong>Controller Search Order:</strong> [${data.controller_search_order ? data.controller_search_order.join(', ') : 'N/A (commented out)'}]</p>
        <p><strong>Controller Search Direction:</strong> [${data.controller_search_direction ? data.controller_search_direction.join(', ') : 'N/A (commented out)'}]</p>
        <p><strong>🔑 Session Search Order:</strong> [${data.session_search_order ? data.session_search_order.join(', ') : 'null'}]</p>
        <p><strong>🔑 Session Search Direction:</strong> [${data.session_search_direction ? data.session_search_direction.join(', ') : 'null'}]</p>
        <p><em>Time: ${new Date().toLocaleTimeString()}</em></p>
    `;
}
window.displayOrderToggleResults = displayOrderToggleResults;

function disableSubmitters() {


}
window.disableSubmitters = disableSubmitters;

function resizeX() {
  const dummyX = document.getElementById('dummy_x');
  const dummyA = document.getElementById('dummy_a');

  if (!dummyX || !dummyA) return;

  const clientHeight = parseInt(dummyX.offsetHeight);
  const aHeight = dummyA.offsetHeight;
  const newPadding = (clientHeight - aHeight) / 2;
  const newHeight = clientHeight - newPadding;

  // Apply styles to elements with class "remove_column"
  document.querySelectorAll('.remove_column').forEach(function (el) {
    el.style.height = newHeight + 'px';
    el.style.paddingTop = newPadding + 'px';
  });

  // Apply styles to elements with class "div_column_edit"
  document.querySelectorAll('.div_column_edit').forEach(function (el) {
    el.style.height = newHeight + 'px';
    el.style.paddingTop = newPadding + 'px';
  });
}
window.resizeX = resizeX;

function doEscapeHTML(class_id_name) {
  console.log('doEscapeHTML called for ' + class_id_name);
  const sent_text_element_str = class_id_name + "_sent"

  const sent_text_element_str116 = "#" + sent_text_element_str;
  const sent_text_element = document.getElementById(sent_text_element_str);

  const sent_text_element_str117 = "#" + sent_text_element_str;
  const sent_text_element_value = document.getElementById(sent_text_element_str).value;
  const sent_text_element_value_esc = escapeHTML(sent_text_element_value);
  sent_text_element.setAttribute('value', sent_text_element_value_esc);
}
window.doEscapeHTML = doEscapeHTML;

function updatePostFilterStrings(class_id_name) {
  const sent_text_element_str = class_id_name + "_sent"
  const typed_text_element_str = class_id_name + "_typed"

  const sent_text_element_str125 = "#" + sent_text_element_str;
  const sent_text_element = document.getElementById(sent_text_element_str);

  const typed_text_element_str126 = "#" + typed_text_element_str;
  const typed_text_element = document.getElementById(typed_text_element_str);
  const typed_filter_str = typed_text_element.value;
  const typed_filter_str_esc = escapeHTML(typed_filter_str)
  sent_text_element.setAttribute('value', typed_filter_str_esc);
}
window.updatePostFilterStrings = updatePostFilterStrings;

function updatePostExternalFilter(table_name, class_id_name) {
  console.log('updatePostExternalFilter called for ' + class_id_name + ' in table ' + table_name);
  const sent_text_element_str = class_id_name + "_sent"
  const typed_text_element_str = class_id_name + "_typed"


  const sent_text_element = document.getElementById(sent_text_element_str); //rwv vanilla change

  const typed_text_element = document.getElementById(typed_text_element_str);
  const typed_filter_str = parseInt(typed_text_element.value);
  sent_text_element.value = typed_filter_str; //rwv vanilla change;
  const x = 1;
  const form_id = "search_form_" + table_name;
  submitFormAsPost(form_id);

}
window.updatePostExternalFilter = updatePostExternalFilter;

function submitFormAsPost(form_id, endpoint = '/welcome/table_search') {
  const elem = document.getElementById(form_id);

  // Convert to direct POST request instead of Rails.fire
  if (elem) {
    const formData = new FormData(elem);

    // Make direct POST request to the specified endpoint
    fetch(endpoint, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        'X-Requested-With': 'XMLHttpRequest'
      },
      body: formData
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        return response.text();
      })
      .then(html => {
        try {
          // Check if the response looks like JavaScript or HTML
          const trimmed = html.trim();
          
          if (trimmed.startsWith('<') && !trimmed.startsWith('<!--')) {
            // Looks like HTML content, not JavaScript
            console.warn('Received HTML content instead of JavaScript:', trimmed.substring(0, 100));
            // Try to extract any script tags and execute them
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = html;
            const scripts = tempDiv.querySelectorAll('script');
            scripts.forEach(script => {
              try {
                if (script.textContent) {
                  eval(script.textContent);
                }
              } catch (e) {
                console.error('Error executing extracted script:', e);
              }
            });
          } else {
            // Assume it's JavaScript and execute it
            try {
              const script = document.createElement('script');
              script.textContent = html;
              document.head.appendChild(script);
              document.head.removeChild(script);
            } catch (e) {
              console.error('JavaScript execution error:', e);
              console.log('Response content:', html.substring(0, 200));
              // Try eval as fallback
              try {
                eval(html);
              } catch (evalError) {
                console.error('Eval fallback also failed:', evalError);
                // Ensure unwait is called even if the response doesn't contain it
                if (typeof unwait === 'function') {
                  unwait();
                }
              }
            }
          }
        } catch (outerError) {
          console.error('Outer error in response handling:', outerError);
          // Ensure unwait is called in case of any error
          if (typeof unwait === 'function') {
            unwait();
          }
        }
      })
      .catch(error => {
        console.error('Form submission failed:', error);
        console.error('Error details:', {
          message: error.message,
          stack: error.stack,
          form_id: form_id,
          endpoint: endpoint
        });
        if (window.showNotification) {
          window.showNotification('Form submission failed: ' + error.message, 'error');
        } else {
          alert('Form submission failed: ' + error.message);
        }
        unwait();
      });
  } else {
    console.error('Form not found:', form_id);
    unwait();
  }
}
window.submitFormAsPost = submitFormAsPost;

function Search(table_name) {
  console.log("Calling Search for " + table_name);
  wait();
  resizeFilters();
  //   jQuery('#person_id_Person_x').hasAttribute('style')
  // jQuery('#person_first_name_Person_x').attr('style','float:right; height: 190px');

  const current_filter_str = "current_filters_" + table_name;

  const current_filter_str152 = "#" + current_filter_str;
  const current_filter_element = document.getElementById((current_filter_str152).slice(1)); //rwv vanilla change
  hideElement(current_filter_element);
  const do_search_str = "do_search_" + table_name;

  const do_search_str155 = "#" + do_search_str;
  const do_search_element = document.getElementById((do_search_str155).slice(1)); //rwv vanilla change
  do_search_element.setAttribute("name", "do_search");

  const form_id = "search_form_" + table_name

  // Use the new reusable form submission function
  submitFormAsPost(form_id);

}
window.Search = Search;


function AddField(table_name) {
  wait();

  const textElementId = "add_filter_value_" + table_name;
  const selectId = "possible_filters_" + table_name;

  const selectEl = document.getElementById(selectId);
  if (!selectEl) return;

  const selectedVal = selectEl.value;

  if (selectedVal === "do_nothing") {
    return;
  }

  const currentFilterId = "current_filters_" + table_name;
  const currentFilterEl = document.getElementById(currentFilterId);

  const noResults = currentFilterEl && currentFilterEl.offsetParent !== null; // roughly `.is(':visible')`

  const doSearchId = "do_search_" + table_name;
  const doSearchEl = document.getElementById(doSearchId);

  if (doSearchEl) {
    doSearchEl.name = noResults ? "do_not_search" : "do_search";
  }

  const textEl = document.getElementById(textElementId);
  if (textEl) {
    textEl.name = selectedVal;
    textEl.value = "%";
  }

  const formId = "search_form_" + table_name;

  submitFormAsPost(formId);
}

window.AddField = AddField;

function AddFilter(table_name) {
  wait();

  // 1) Get the “possible” <select> and its selected value
  const selectId = `possible_external_filters_${table_name}`;
  const selectEl = document.getElementById(selectId);
  if (!selectEl) return;
  const selectedVal = selectEl.value;
  if (selectedVal === "do_nothing") return;

  // 2) Remove the chosen <option> from that <select>
  const optionId = `${selectId}_${selectedVal}`;
  const optionEl = document.getElementById(optionId);
  if (optionEl) optionEl.remove();

  // 3) Store the picked filter id in a hidden input
  const textInputId = `add_external_filter_id_${table_name}`;
  const textInput = document.getElementById(textInputId);
  if (textInput) textInput.value = selectedVal;

  // 4) Update the count of external filters
  const countInputId = `number_of_external_filters_${table_name}`;
  const countInput = document.getElementById(countInputId);
  let currentCount = countInput ? parseInt(countInput.value, 10) : 0;

  // If this is the first filter, show the header label
  if (currentCount === 0) {
    const headerId = `external_filters_header_${table_name}`;
    const headerEl = document.getElementById(headerId);
    if (headerEl) headerEl.innerHTML = "<label>Search Filters </label>";
  }

  // Increment and save back
  const newCount = currentCount + 1;
  if (countInput) countInput.value = newCount;

  // 5) Submit the form
  const formId = `add_external_filter_${table_name}`;
  const formEl = document.getElementById(formId);

  submitFormAsPost(formId, "/welcome/add_external_filter");

}

window.AddFilter = AddFilter;

function onUpdateExternalFilterGroup(class_name, filter_id, elt_id) {
  // Build IDs
  const filterIdInputId = `update_external_filter_id_${class_name}`;
  const eltIdInputId = `update_external_elt_index_${class_name}`;
  const memberIdInputId = `update_external_member_id_${class_name}`;
  const groupIdInputId = `update_external_group_id_${class_name}`;

  const groupSelectId = `group_selection_${class_name}_${filter_id}_${elt_id}`;
  const memberSelectId = `argument_selection_${class_name}_${filter_id}_${elt_id}`;

  // Grab inputs
  const filterIdInput = document.getElementById(filterIdInputId);
  const eltIdInput = document.getElementById(eltIdInputId);
  const memberIdInput = document.getElementById(memberIdInputId);
  const groupIdInput = document.getElementById(groupIdInputId);

  // Grab selects
  const groupSelect = document.getElementById(groupSelectId);
  const memberSelect = document.getElementById(memberSelectId);

  // Get current values
  const selectedGroupId = groupSelect ? groupSelect.value : '';
  const selectedMemberId = memberSelect ? memberSelect.value : '';

  // Update hidden inputs
  if (filterIdInput) filterIdInput.value = filter_id;
  if (eltIdInput) eltIdInput.value = elt_id;
  if (memberIdInput) memberIdInput.value = selectedMemberId;
  if (groupIdInput) groupIdInput.value = selectedGroupId;

  // Submit the form

  submitFormAsPost(`update_external_filter_${class_name}`, "/welcome/update_external_filter")
}
window.onUpdateExternalFilterGroup = onUpdateExternalFilterGroup;

function addExternalFilterElement(class_name, filter_id) {
  // 1) Update element counts
  const countElId = `number_of_filter_elements_${class_name}_${filter_id}`;
  const maxElId = `max_filter_elements_${class_name}_${filter_id}`;
  const countEl = document.getElementById(countElId);
  const maxEl = document.getElementById(maxElId);

  let currentNum = parseInt(countEl.value, 10);
  const newEltId = currentNum;
  const newCount = currentNum + 1;

  countEl.value = newCount;
  maxEl.value = newEltId + 1;

  // 2) Find the last existing element to clone
  let prevEltId = newEltId - 1;
  let prevElt = null;
  while (prevEltId >= 0 && prevElt === null) {
    prevElt = document.getElementById(
      `external_filter_selection_${class_name}_${filter_id}_${prevEltId}`
    );
    prevEltId--;
  }
  if (!prevElt) return; // nothing to clone

  // 3) Clone the node (deep clone)
  const newElt = prevElt.cloneNode(true);
  newElt.id = `external_filter_selection_${class_name}_${filter_id}_${newEltId}`;

  // 4) Update its group-selection <select>, if present
  const groupSelect = newElt.querySelector(`.external_filter_group_selection_${class_name}`);
  if (groupSelect) {
    groupSelect.id = `group_selection_${class_name}_${filter_id}_${newEltId}`;
    groupSelect.setAttribute(
      'onchange',
      `onUpdateExternalFilterGroup('${class_name}','${filter_id}','${newEltId}');return false`
    );

    // carry over the old selection
    const oldGroupSelect = prevElt.querySelector(`.external_filter_group_selection_${class_name}`);
    const oldValue = oldGroupSelect ? oldGroupSelect.value : null;
    if (oldValue !== null) {
      const opt = groupSelect.querySelector(`.group_class_${oldValue}`);
      if (opt) opt.selected = true;
    }
  }

  // 5) Update argument span and selection elements
  const argSpan = newElt.querySelector('.external_filter_argument_span');
  if (argSpan) {
    argSpan.id = `external_filter_argument_span_${class_name}_${filter_id}_${newEltId}`;
  }
  const argSel = newElt.querySelector('.external_filter_argument_selection');
  if (argSel) {
    argSel.id = `argument_selection_${class_name}_${filter_id}_${newEltId}`;
    argSel.name = `argument_selection_${filter_id}_${newEltId}`;
  }

  // 6) Update its remove link
  const removeField = newElt.querySelector('.remove_filter_element_field a');
  if (removeField) {
    removeField.setAttribute(
      'onclick',
      `deleteExternalFilterElement('${class_name}','${filter_id}','${newEltId}');return false`
    );
  }

  // 7) Insert a spacer <div> after prevElt
  const spacer = document.createElement('div');
  spacer.style.float = 'left';
  const parent = prevElt.parentNode;
  parent.insertBefore(spacer, prevElt.nextSibling);

  // 8) Insert the cloned element after that spacer
  parent.insertBefore(newElt, spacer.nextSibling);
}

window.addExternalFilterElement = addExternalFilterElement;

function deleteExternalFilterElement(class_name, filter_id, elt_id) {
  // 1) Remove the selected filter element and its spacer
  const selId = `external_filter_selection_${class_name}_${filter_id}_${elt_id}`;
  const selEl = document.getElementById(selId);

  if (selEl) selEl.remove();
  // (optionally remove the spacer too)
  // if (spacer) spacer.remove();

  // 2) Update the count
  const countId = `number_of_filter_elements_${class_name}_${filter_id}`;
  const countEl = document.getElementById(countId);
  let currentCount = parseInt(countEl.value, 10);
  const newCount = currentCount - 1;

  if (newCount === 0) {
    // No elements left: remove the whole filter block
    const headerId = `external_filters_header_${class_name}`;
    const headerEl = document.getElementById(headerId);

    const containerId = `external_filter_header_${class_name}_${filter_id}`;
    const containerEl = document.getElementById(containerId);
    const headerHTML = containerEl?.innerHTML || "";

    const extFilterId = `external_filter_${class_name}_${filter_id}`;
    const extFilterEl = document.getElementById(extFilterId);
    if (extFilterEl) extFilterEl.remove();

    // Decrement total filters
    const totalFiltersId = `number_of_external_filters_${class_name}`;
    const totalFiltersEl = document.getElementById(totalFiltersId);
    let totalFilters = parseInt(totalFiltersEl.value, 10) - 1;
    totalFiltersEl.value = totalFilters;
    if (totalFilters === 0 && headerEl) {
      headerEl.innerHTML = "";
    }

    // Re-insert an option into the “possible_external_filters” <select>
    const possibleId = `possible_external_filters_${class_name}`;
    const possibleEl = document.getElementById(possibleId);
    if (possibleEl) {
      const opts = Array.from(possibleEl.options);
      const firstOpt = opts[0];
      const nextOpt = opts[1] || null;

      // Create new <option>
      const newOpt = document.createElement('option');
      newOpt.id = `possible_external_filters_${class_name}_${filter_id}`;
      newOpt.value = String(filter_id);
      newOpt.textContent = headerHTML;

      if (!nextOpt) {
        // only one existing option
        possibleEl.appendChild(newOpt);
      } else {
        // decide where to insert
        const currentValue = parseInt(nextOpt.value, 10);
        if (currentValue > filter_id) {
          possibleEl.insertBefore(newOpt, nextOpt);
        } else {
          // find correct spot
          let idx = 1;
          while (idx < opts.length && parseInt(opts[idx].value, 10) < filter_id) {
            idx++;
          }
          possibleEl.insertBefore(newOpt, possibleEl.options[idx] || null);
        }
      }
    }
  } else {
    // Still have elements: update the count and shift IDs/names
    countEl.value = newCount;

    for (let i = parseInt(elt_id, 10) + 1; i <= currentCount; i++) {
      const oldSelId = `external_filter_selection_${class_name}_${filter_id}_${i}`;
      const newSelId = `external_filter_selection_${class_name}_${filter_id}_${i - 1}`;
      const el = document.getElementById(oldSelId);
      if (el) el.id = newSelId;

      const oldSpanId = `external_filter_argument_span_${class_name}_${filter_id}_${i}`;
      const newSpanId = `external_filter_argument_span_${class_name}_${filter_id}_${i - 1}`;
      const spanEl = document.getElementById(oldSpanId);
      if (spanEl) {
        spanEl.id = newSpanId;
        // update its <a> onclick
        const a = spanEl.querySelector('a');
        if (a) {
          a.setAttribute(
            'onclick',
            `deleteExternalFilterElement('${class_name}','${filter_id}','${i - 1}');return false;`
          );
        }
      }

      const oldArgId = `argument_selection_${class_name}_${filter_id}_${i}`;
      const argEl = document.getElementById(oldArgId);
      if (argEl) {
        argEl.id = `argument_selection_${class_name}_${filter_id}_${i - 1}`;
        argEl.name = `argument_selection_${filter_id}_${i - 1}`;
      }
    }
  }
}

window.deleteExternalFilterElement = deleteExternalFilterElement;

function resizeExternalFilters(class_name) {
  // Get the base height and build a CSS string
  const clientHeight = getElementHeight('dummy_x');
  const heightStr = clientHeight + 'px';

  // Helper to apply a height style to all matching elements
  function applyHeight(selector) {
    document.querySelectorAll(selector).forEach(el => {
      el.style.height = heightStr;
    });
  }

  // Apply to each group of filters
  applyHeight(`.external_filter_group_selection_${class_name}`);
  applyHeight('.external_filter_argument_selection');
  applyHeight('.external_filter_element');

  // Compute new padding/height for add/remove buttons
  const aHeight = parseInt(getElementHeight('dummy_a'), 10);
  const newPadding = (clientHeight - aHeight) / 2;
  const newHeight = clientHeight - newPadding;
  const newHeightPx = newHeight + 'px';
  const newPadPx = newPadding + 'px';

  // Apply to add/remove buttons
  ['.add_external_filter_element', '.remove_filter_element_field'].forEach(selector => {
    document.querySelectorAll(selector).forEach(el => {
      el.style.height = newHeightPx;
      el.style.paddingTop = newPadPx;
    });
  });
}
window.resizeExternalFilters = resizeExternalFilters;

function resizeFilters() {
  const clientHeight = parseInt(getElementHeight('dummy_x'), 10);
  const narrowWidth = parseInt(getWidth('dummy_format_narrow'), 10);
  const wideWidth = parseInt(getWidth('dummy_format'), 10);
  const xHeight = parseInt(getElementHeight('dummy_fx'), 10);
  const pHeight = parseInt(getElementHeight('dummy_fp'), 10);
  const xPadding = (clientHeight - xHeight) / 2;
  const pPadding = (clientHeight - pHeight) / 2;
  const newXHeight = clientHeight - xPadding;
  const newPHeight = clientHeight - pPadding;

  const heightStr = clientHeight + "px";
  const wideWidthStr = wideWidth + "px";
  const narrowWidthStr = narrowWidth + "px";

  const xStyleStr =
    "background: #AAAAAA; border-left: 1px solid #000;" +
    " float: right; height: " + newXHeight + "px; padding-top: " + xPadding + "px";

  const pStyleStr =
    "background: #AAAAAA; border: 1px solid #000;" +
    " float: left; height: " + newPHeight + "px; padding-top: " + pPadding + "px";

  const selectStyleStr =
    "border: none; background-color: transparent;" +
    " overflow: hidden; height: " + (clientHeight * 2) + "px";

  const inputStyleStr =
    "border: none; height: " + clientHeight + "px";

  // Apply height attribute to all .select_filter elements
  document.querySelectorAll('.select_filter').forEach(el => {
    // If you intended to set a CSS height, use:
    // el.style.height = heightStr;
    // Otherwise, to set the HTML attribute:
    el.setAttribute('height', heightStr);
  });

  // If you need to apply the xStyleStr or pStyleStr to elements:
  // document.querySelectorAll('.wide_filter').forEach(el => {
  //   el.style.cssText = xStyleStr; // or pStyleStr for left filters
  // });
}
window.resizeFilters = resizeFilters;

function group_unrestriction() {
  const externalFilter = document.getElementById('external_filter_Group_0');
  if (externalFilter) {
    // “.show()” in jQuery removes any inline “display: none;”
    // Resetting to empty lets your stylesheet take over
    externalFilter.style.display = '';
  }
}
window.group_unrestriction = group_unrestriction;

function group_restriction_timeout(table_name, do_update) {
  const externalFilter = document.getElementById('external_filter_Group_0');
  const selectObj = document.getElementById('argument_selection_Group_0_0');

  // If either element isn’t present yet, retry shortly
  if (!externalFilter || !selectObj) {
    setTimeout(() => group_restriction_timeout(table_name, do_update), 10);
    return;
  }

  // Hide the external filter container
  externalFilter.style.display = 'none';

  // Get the current selected value
  let selectValue = selectObj.value;

  // If it doesn’t match the table name, pick the matching option
  if (selectValue !== table_name) {
    do_update = true;
    let class_name = null;

    for (let opt of selectObj.options) {
      if (opt.value === table_name) {
        opt.selected = true;
        class_name = opt.textContent;
        break;
      }
    }
  }

  // If we changed anything, trigger the search
  if (do_update) {
    Search('Group');
  }
}
window.group_restriction_timeout = group_restriction_timeout;


function group_restriction(table_name) {
  // Check if the argument-selection dropdown already exists
  const selectObj = document.getElementById('argument_selection_Group_0_0');
  let do_update = false;

  // If it doesn't exist, default the “possible_external_filters_Group” to option value 0
  if (!selectObj) {
    const selectEl = document.getElementById('possible_external_filters_Group');
    if (selectEl) {
      // selectEl.options is an HTMLCollection of <option> elements
      for (let i = 0; i < selectEl.options.length; i++) {
        const opt = selectEl.options[i];
        if (opt.value === '0') {
          opt.selected = true;
          break;  // stop after we find and select the “0” option
        }
      }
    }

    AddFilter('Group');
    do_update = true;
  }

  // Call the timeout helper with whether we did an update
  group_restriction_timeout(table_name, do_update);
}
window.group_restriction = group_restriction;

function refreshExternalFilterSelects(table_name, triggerTable) {
  console.log("🔄 Refreshing external filter selects for table:", table_name, " and triggerTable:", triggerTable);

  // Find the external filters container for this table
  const externalFiltersContainer = document.getElementById(`external_filters_${table_name}`);
  if (!externalFiltersContainer) {
    console.log("⚠️ No external filters container found for table:", table_name);
    return;
  }

  // Find all external filter divs within the container
  const externalFilterDivsCandidates = externalFiltersContainer.querySelectorAll(`[id^="external_filter_${table_name}_"]`);

  const externalFilterDivs = Array.from(externalFilterDivsCandidates).filter(el => {
  const prefix = 'external_filter_Person_';
  const suffix = el.id.substring(prefix.length);
  // Check if suffix is one or more digits and greater than 0
  return /^\d+$/.test(suffix) && parseInt(suffix, 10) > 0;
  });

  console.log("🔄 Found", externalFilterDivs.length, "external filter divs to refresh");

  if (externalFilterDivs.length === 0) {
    console.log("ℹ️ No external filters to refresh for table:", table_name);
    return;
  }

  // For each external filter, trigger a refresh by making a server request
  externalFilterDivs.forEach(filterDiv => {
    const filterId = filterDiv.id;
    console.log("🔄 Processing external filter:", filterId);

    // Extract class_name and filter_id from the div ID
    // Format: external_filter_CLASS_FILTERID
    const idParts = filterId.match(/external_filter_([^_]+)_(\d+)/);
    const argumentClassDiv = document.getElementById("argument_class_"+filterId);
    if (argumentClassDiv) {
      console.log("🔍 Found argument class div:", argumentClassDiv.id, "with content:", argumentClassDiv.value);


      if (idParts && argumentClassDiv.value === triggerTable) {
        const class_name = idParts[1];
        const filter_id = idParts[2];

        console.log(`🔄 Refreshing external filter partial: class=${class_name}, filter=${filter_id}`);

        // Make an AJAX request to refresh this specific external filter partial
        const formData = new FormData();
        formData.append('class_name', class_name);
        formData.append('filter_id', filter_id);
        formData.append('table_name', table_name);

        fetch('/welcome/refresh_external_filter', {
          method: 'POST',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
            'X-Requested-With': 'XMLHttpRequest'
          },
          body: formData
        })
          .then(response => {
            if (!response.ok) {
              throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
            return response.text();
          })
          .then(html => {
            console.log(`✅ Received updated HTML for ${filterId}`);
            // Replace the current filter div with the updated HTML
            const tempDiv = document.createElement('table');
            tempDiv.innerHTML = html.trim();
            const newFilterDiv = tempDiv.firstElementChild.firstElementChild;

            if (newFilterDiv) {
              filterDiv.parentNode.replaceChild(newFilterDiv, filterDiv);
              console.log(`🔄 Successfully refreshed external filter: ${filterId}`);
              //resizeFilters();
              // Resize the filters after updating
              //resizeExternalFilters(class_name);
            } else {
              console.log(`⚠️ No valid HTML returned for ${filterId}`);
            }
          })
          .catch(error => {
            console.log(`❌ Failed to refresh external filter ${filterId}:`, error);
          });

      } else {
        console.log("⚠️ Could not parse external filter ID format:", filterId);
      }
    } else {
      console.log("⚠️ No argument class div found for filter:","argument_class_"+ filterId );
    }
    
  });
}
window.refreshExternalFilterSelects = refreshExternalFilterSelects;
