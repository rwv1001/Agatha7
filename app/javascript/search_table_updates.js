// ActionCable Search Table Updates
import consumer from "./consumer";

// Initialize external filters on page load
function initializeExternalFilters() {
  console.log("🔧 Initializing external filters on page load...");
  
  // Find all external filter tables
  const externalFilterTables = document.querySelectorAll('[id^="external_filters_"]');
  console.log("🔧 Found", externalFilterTables.length, "external filter tables");
  
  externalFilterTables.forEach(function(table) {
    const tableName = table.id.replace('external_filters_', '');
    console.log("🔧 Processing external filters for table:", tableName);
    
    // Find all external filter rows in this table
    const filterRows = table.querySelectorAll('[id^="external_filter_"]');
    console.log("🔧 Found", filterRows.length, "external filter rows for", tableName);
    
    filterRows.forEach(function(filterRow, rowIndex) {
      console.log("🔧 Processing external filter row:", filterRow.id);
      
      // Find all select elements in this filter row
      const selectElements = filterRow.querySelectorAll('select');
      console.log("🔧 Found", selectElements.length, "select elements in filter row");
      
      selectElements.forEach(function(select, selectIndex) {
        console.log("🔧 Processing select element:", select.id);
        
        // For group selection elements, trigger change to populate dependent selects
        if (select.classList.contains('Group_select')) {
          console.log("🔧 Initializing group selection:", select.id);
          setTimeout(function() {
            if (select.onchange) {
              console.log("🔧 Triggering onchange for group select:", select.id);
              select.onchange();
            } else {
              console.log("🔧 Dispatching change event for group select:", select.id);
              const event = new Event('change', { bubbles: true });
              select.dispatchEvent(event);
            }
          }, (rowIndex * 200) + (selectIndex * 100)); // Stagger initialization
        }
        
        // For argument selection elements that are empty, try to populate them
        if (select.classList.contains('external_filter_argument_selection')) {
          console.log("🔧 Checking argument selection:", select.id, "Options count:", select.options.length);
          
          if (select.options.length <= 1) { // Only default option or empty
            console.log("🔧 Argument selection needs population, looking for group selector");
            
            // Find the corresponding group selector in the same filter row
            const groupSelector = filterRow.querySelector('select.Group_select');
            if (groupSelector) {
              console.log("🔧 Found group selector, will trigger after group initialization");
              setTimeout(function() {
                if (groupSelector.onchange) {
                  console.log("🔧 Triggering group selector to populate argument selection");
                  groupSelector.onchange();
                }
              }, (rowIndex * 200) + (selectIndex * 100) + 50); // Slightly after group selector
            } else {
              console.log("⚠️ No group selector found for argument selection:", select.id);
            }
          } else {
            console.log("✅ Argument selection already has options:", select.options.length);
          }
        }
      });
    });
  });
  
  console.log("✅ External filter initialization completed");
}

// Fallback function to get ActionCable consumer across browsers
function getActionCableConsumer() {
  // Try multiple ways to get the consumer for cross-browser compatibility
  if (typeof consumer !== 'undefined') {
    return consumer;
  } else if (window.actionCableConsumer) {
    return window.actionCableConsumer;
  } else if (window.consumer) {
    return window.consumer;
  } else if (window.ActionCable) {
    return window.ActionCable.createConsumer();
  } else {
    console.error("ActionCable not available in this browser");
    return null;
  }
}

document.addEventListener('DOMContentLoaded', function() {
  console.log("🚀 DOM loaded, initializing ActionCable...");
  console.log("🔍 Checking for ActionCable consumer availability...");
  
  // Initialize external filters on page load
  initializeExternalFilters();
  
  const actionCableConsumer = getActionCableConsumer();
  
  if (!actionCableConsumer) {
    console.error("❌ Failed to initialize ActionCable consumer");
    console.error("❌ Available objects:", {
      consumer: typeof consumer,
      window_actionCableConsumer: typeof window.actionCableConsumer,
      window_consumer: typeof window.consumer,
      window_ActionCable: typeof window.ActionCable
    });
    return;
  }
  
  console.log("✅ ActionCable consumer available:", actionCableConsumer);
  console.log("🔗 Attempting to create SearchTableChannel subscription...");
  
  // Subscribe to search table updates
  const searchTableChannel = actionCableConsumer.subscriptions.create("SearchTableChannel", {
    connected() {
      console.log("✅ Connected to SearchTableChannel - ActionCable working!");
      console.log("🎯 ActionCable connection established successfully");
    },

    disconnected() {
      console.log("❌ Disconnected from SearchTableChannel");
    },

    received(data) {
      console.log("📡 Received ActionCable message:", data);
      console.log("📡 Message action type:", data.action);
      
      if (data.action === 'update_search_rows') {
        console.log("🎯 Processing update_search_rows action");
        this.handleSearchTableUpdate(data);
      } else if (data.action === 'remove_search_rows') {
        console.log("🗑️ Processing remove_search_rows action");
        this.handleSearchRowRemovals(data);
      } else if (data.action === 'data_invalidation') {
        console.log("🔄 Processing data_invalidation action");
        console.log("🔄 Invalidation data:", data);
        this.handleDataInvalidation(data);
      } else {
        console.log("⚠️ Unknown action received:", data.action);
      }
    },

    handleSearchTableUpdate(data) {
      const editedTableName = data.edited_table_name;
      const searchControllers = data.search_controllers;
      let totalChangedCells = 0;

      // Process updates for each search controller
      Object.keys(searchControllers).forEach(tableName => {
        const controllerData = searchControllers[tableName];
        const updateType = controllerData.update_type || 'standard';
        const affectedExtendedFilters = controllerData.affected_extended_filters || [];
        let tableChangedCells = 0;
        
        // Update existing rows
        if (controllerData.updated_objects) {
          controllerData.updated_objects.forEach(rowData => {
            console.log(`🔄 Processing row update for ${tableName}, row ID: ${rowData.id}`);
            const changedCells = this.updateSearchRow(tableName, rowData, updateType, affectedExtendedFilters);
            console.log(`📊 Row ${rowData.id} returned ${changedCells} changed cells`);
            tableChangedCells += changedCells;
            console.log(`📈 Table ${tableName} total changed cells now: ${tableChangedCells}`);
            
            // Special handling for Group table member count updates
            if (tableName === 'Group' && updateType === 'group_member_count_update') {
              console.log(`🎯 Applying special highlighting for Group member count update on group ${rowData.id}`);
              const groupRowElement = document.getElementById(`${rowData.id}_Group`);
              if (groupRowElement) {
                // Specifically highlight the Number_of_group_members_Group cell
                const membersCell = groupRowElement.querySelector('.Number_of_group_members_Group');
                if (membersCell) {
                  console.log(`✨ Highlighting group member count cell for group ${rowData.id}`);
                  membersCell.classList.add('cell-updated');
                  setTimeout(() => {
                    membersCell.classList.remove('cell-updated');
                  }, 2000); // Longer highlight for cross-tab updates
                }
              }
            }
          });
        }

        // Handle new rows if this is the edited table
        if (tableName === editedTableName && controllerData.new_rows) {
          console.log(`🆕 Processing ${controllerData.new_rows.length} new rows for table ${tableName}`);
          this.handleNewRows(tableName, controllerData);
          tableChangedCells += controllerData.new_rows.length; // Count new rows as changes
          console.log(`📈 Added ${controllerData.new_rows.length} new rows to table ${tableName} change count, total now: ${tableChangedCells}`);
        }

        // Update select options only if there were actual content changes
        if (tableChangedCells > 0 && controllerData.updated_objects) {
          controllerData.updated_objects.forEach(rowData => {
            if (typeof window.select_update === 'function') {
              window.select_update(tableName, rowData.id, rowData.short_field);
            }
          });
        }

        // Skip recolour entirely when doing targeted cell updates - the cell-level highlighting is handled by updateChangedCells
        if (tableChangedCells > 0) {
          console.log(`✨ Completed targeted cell updates for table ${tableName} (${tableChangedCells} content changes) - skipping row-level recolor`);
        } else if (tableChangedCells === 0) {
          console.log(`⏭️ Skipping recolor for ${tableName} - no content changes detected`);
        }

        totalChangedCells += tableChangedCells;
      });

      // Call action_select_no_js only if there were actual changes
      if (totalChangedCells > 0 && typeof window.action_select_no_js === 'function') {
        window.action_select_no_js();
      }
    },

    updateSearchRow(tableName, rowData, updateType, affectedExtendedFilters) {
      const rowId = `${rowData.id}_${tableName}`;
      const rowElement = document.getElementById(rowId);
      
      console.log(`🔍 Looking for element with ID: ${rowId}`);
      console.log(`📍 Element found:`, rowElement);
      
      if (rowElement) {
        console.log(`✅ Updating row ${rowId} with targeted cell updates`);
        
        // Instead of replacing the entire row, update only the cells that changed
        const changedCells = this.updateChangedCells(rowElement, rowData.html, updateType, affectedExtendedFilters);
        
        // Set checkbox state if setcheck function exists
        if (typeof window.setcheck === 'function') {
          window.setcheck(`${tableName}_check_${rowData.id}`, true);
        }
        
        return changedCells;
      } else {
        console.log(`❌ Row element ${rowId} not found in DOM`);
        console.log(`🔍 Available elements with similar IDs:`, 
          Array.from(document.querySelectorAll(`[id*="${rowData.id}"]`)).map(el => el.id)
        );
        return 0;
      }
    },

    updateChangedCells(currentRowElement, newRowHtml, updateType, affectedExtendedFilters) {
      console.log('🔧 updateChangedCells called with:', {
        updateType,
        affectedExtendedFilters,
        newRowHtml: newRowHtml.substring(0, 200) + '...'
      });
      
      // Clean up the HTML and try multiple parsing approaches
      const cleanedHtml = newRowHtml.trim();
      console.log('🧹 Cleaned HTML starts with:', cleanedHtml.substring(0, 100));
      
      // Create a temporary element to parse the new HTML
      const tempDiv = document.createElement('div');
      tempDiv.innerHTML = cleanedHtml;
      
      // Try different ways to find the row element
      let newRowElement = tempDiv.querySelector('tr');
      
      // If that doesn't work, check if the HTML itself is a tr element
      if (!newRowElement && cleanedHtml.toLowerCase().startsWith('<tr')) {
        // The HTML might be the tr element itself
        tempDiv.innerHTML = cleanedHtml;
        newRowElement = tempDiv.firstElementChild;
      }
      
      // If still no luck, try creating a table wrapper
      if (!newRowElement) {
        const tableWrapper = document.createElement('table');
        tableWrapper.innerHTML = `<tbody>${cleanedHtml}</tbody>`;
        newRowElement = tableWrapper.querySelector('tr');
      }
      
      if (!newRowElement) {
        console.log('❌ Could not parse new row HTML after multiple attempts, falling back to full replacement');
        console.log('Raw HTML:', newRowHtml);
        currentRowElement.outerHTML = newRowHtml;
        
        // Add glow effect to the updated row after replacement
        const newlyInsertedRow = document.getElementById(currentRowElement.id);
        if (newlyInsertedRow) {
          newlyInsertedRow.classList.add('row-updated');
          setTimeout(() => {
            newlyInsertedRow.classList.remove('row-updated');
          }, 1500);
        }
        return 1; // Count full replacement as 1 change
      }
      
      console.log('✅ Successfully parsed new row element');
      
      // Get all cells from both current and new rows
      const currentCells = Array.from(currentRowElement.querySelectorAll('td'));
      const newCells = Array.from(newRowElement.querySelectorAll('td'));
      
      console.log(`🔍 Comparing ${currentCells.length} current cells with ${newCells.length} new cells`);
      
      let changedCellCount = 0;
      
      // Compare each cell and update only those that changed
      currentCells.forEach((currentCell, index) => {
        if (index < newCells.length) {
          const newCell = newCells[index];
          const currentContent = this.normalizeContent(currentCell.innerHTML);
          const newContent = this.normalizeContent(newCell.innerHTML);
          
          // Also compare the text content as a fallback
          const currentText = this.normalizeContent(currentCell.textContent || '');
          const newText = this.normalizeContent(newCell.textContent || '');
          
          const htmlChanged = currentContent !== newContent;
          const textChanged = currentText !== newText;
          
          if (htmlChanged || textChanged) {
            console.log(`🎯 Cell ${index} changed, updating content`);
            console.log(`   Old HTML: "${currentContent}"`);
            console.log(`   New HTML: "${newContent}"`);
            console.log(`   Old Text: "${currentText}"`);
            console.log(`   New Text: "${newText}"`);
            console.log(`   Change type: ${htmlChanged ? 'HTML' : 'Text only'}`);
            
            // Update the cell content
            currentCell.innerHTML = newCell.innerHTML;
            
            // Add highlight effect to the changed cell
            currentCell.classList.add('cell-updated');
            setTimeout(() => {
              currentCell.classList.remove('cell-updated');
            }, 1500);
            
            changedCellCount++;
          }
        }
      });
      
      console.log(`✅ Updated ${changedCellCount} cells with targeted updates`);
      
      // If no cells changed but we got an update, there might be background color changes 
      // or other styling differences that we should ignore for targeted updates
      if (changedCellCount === 0) {
        console.log('ℹ️ No content cells changed - likely just styling differences (background colors, etc.)');
        console.log('   Skipping update to avoid unnecessary highlights');
        // Don't update anything if only styling changed
        return 0;
      }
      
      // Handle case where new row has more cells than current (shouldn't happen normally)
      if (newCells.length > currentCells.length) {
        console.log('⚠️ New row has more cells, falling back to full replacement');
        currentRowElement.outerHTML = newRowHtml;
        
        // Add glow effect to the updated row after replacement
        const newlyInsertedRow = document.getElementById(currentRowElement.id);
        if (newlyInsertedRow) {
          newlyInsertedRow.classList.add('row-updated');
          setTimeout(() => {
            newlyInsertedRow.classList.remove('row-updated');
          }, 1500);
        }
        return 1; // Count full replacement as 1 change
      }
      
      return changedCellCount;
    },

    normalizeContent(htmlContent) {
      // Remove whitespace variations and normalize content for comparison
      return htmlContent
        .replace(/\s+/g, ' ')  // Replace multiple whitespace with single space
        .replace(/>\s+</g, '><')  // Remove whitespace between tags
        .replace(/^\s+|\s+$/g, '') // Remove leading and trailing whitespace
        .toLowerCase(); // Make case-insensitive comparison
    },

    highlightExtendedFilterCells(rowElement, affectedFilters) {
      // Find cells that contain ExtendedFilter data
      // This looks for cells with data attributes or specific patterns that indicate ExtendedFilter content
      const cells = rowElement.querySelectorAll('td');
      
      cells.forEach((cell, index) => {
        // Check if this cell contains ExtendedFilter data by looking for common patterns
        const cellContent = cell.textContent || '';
        const hasExtendedFilterData = this.cellContainsExtendedFilterData(cellContent, affectedFilters);
        
        if (hasExtendedFilterData) {
          cell.classList.add('extended-filter-updated');
          setTimeout(() => {
            cell.classList.remove('extended-filter-updated');
          }, 1500);
        }
      });
    },

    cellContainsExtendedFilterData(cellContent, affectedFilters) {
      // Check if cell content matches patterns from affected ExtendedFilters
      // This is a heuristic approach - could be made more precise with data attributes
      
      if (!cellContent || cellContent.trim() === '') return false;
      
      // For course-related updates, look for course name patterns
      if (affectedFilters.some(filter => filter.includes('lecture') || filter.includes('tutorial'))) {
        // Look for patterns like "CourseName, Term" or course names
        return cellContent.includes(',') || cellContent.length > 10;
      }
      
      // For group-related updates
      if (affectedFilters.some(filter => filter.includes('group'))) {
        return cellContent.includes('group') || cellContent.includes(';');
      }
      
      // For collection-related updates
      if (affectedFilters.some(filter => filter.includes('collection'))) {
        return cellContent.includes(',') && cellContent.length > 15;
      }
      
      // Default: if it's a long text field with structured data, it's likely an ExtendedFilter
      return cellContent.includes(',') && cellContent.includes(' ') && cellContent.length > 20;
    },

    handleNewRows(tableName, controllerData) {
      // Hide current filters if they exist
      const currentFilterName = controllerData.current_filter_name;
      if (currentFilterName) {
        const filterElement = document.getElementById(currentFilterName);
        if (filterElement) {
          filterElement.style.display = 'none';
        }
      }

      controllerData.new_rows.forEach(newRowData => {
        const rowId = `${newRowData.id}_${tableName}`;
        const rowElement = document.getElementById(rowId);
        const resultsTableName = controllerData.results_table_name;
        const tableElement = document.getElementById(resultsTableName);

        if (rowElement) {
          // Use targeted cell updates instead of full row replacement to maintain consistency
          console.log(`🔄 New row data for existing row ${rowId}, using targeted cell updates`);
          const changedCells = this.updateChangedCells(rowElement, newRowData.html, 'new_row', []);
          console.log(`📊 New row processing for ${rowId} updated ${changedCells} cells`);
        } else if (tableElement) {
          // Append to table (this is for truly new rows)
          const lastTr = tableElement.querySelector('tr:last-child');
          if (lastTr) {
            console.log(`➕ Adding truly new row ${rowId} to table`);
            lastTr.insertAdjacentHTML('afterend', newRowData.html);
            
            // For truly new rows, use row-level highlighting since the entire row is new
            const newRowElement = document.getElementById(rowId);
            if (newRowElement) {
              newRowElement.classList.add('row-updated');
              setTimeout(() => {
                newRowElement.classList.remove('row-updated');
              }, 1500);
            }
          }
        } else {
          // Create new results container if needed
          const searchResultsContainer = document.getElementById(`search_results_${tableName}`);
          if (searchResultsContainer) {
            // You might need to render a complete search results partial here
            // For now, just append the row
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = newRowData.html;
            const newElement = tempDiv.firstChild;
            searchResultsContainer.appendChild(newElement);
            
            // Add glow effect to the new row
            if (newElement && newElement.id) {
              newElement.classList.add('row-updated');
              setTimeout(() => {
                newElement.classList.remove('row-updated');
              }, 1500);
            }
            
            // Call resizeX if it exists
            if (typeof window.resizeX === 'function') {
              window.resizeX();
            }
          }
        }

        // Update select options
        if (typeof window.select_update === 'function') {
          window.select_update(tableName, newRowData.id, newRowData.short_field);
        }
      });
    },
    
    handleSearchRowRemovals(data) {
      console.log("🗑️ Handling search row removals:", data);
      const editedTableName = data.edited_table_name;
      const searchControllers = data.search_controllers;
      
      // Process removals for each search controller
      Object.keys(searchControllers).forEach(tableName => {
        const controllerData = searchControllers[tableName];
        const deletedIds = controllerData.deleted_ids || [];
        
        console.log(`🗑️ Removing ${deletedIds.length} rows from ${tableName} table`);
        
        deletedIds.forEach(deletedId => {
          const rowId = `${deletedId}_${tableName}`;
          const rowElement = document.getElementById(rowId);
          
          if (rowElement) {
            console.log(`🗑️ Removing row element: ${rowId}`);
            
            // Add fade-out effect before removal
            rowElement.style.transition = 'opacity 0.5s ease-out';
            rowElement.style.opacity = '0.3';
            
            setTimeout(() => {
              rowElement.remove();
              console.log(`✅ Successfully removed row: ${rowId}`);
            }, 500);
          } else {
            console.log(`⚠️ Row element ${rowId} not found for removal`);
          }
        });
      });
    },

    handleDataInvalidation(data) {
      console.log("🔄 Handling data invalidation:", data);
      
      // Process each affected relationship that needs updating
      if (data.affected_relationships && Array.isArray(data.affected_relationships)) {
        data.affected_relationships.forEach(relationship => {
          console.log(`📋 Processing invalidation for relationship:`, relationship);
          const tableName = relationship.table || relationship.table_name;
          const affectedIds = relationship.ids || relationship.affected_ids || [];
          const operation = relationship.operation;
          const reason = relationship.reason;
          
          console.log(`🔄 Table: ${tableName}, affected IDs:`, affectedIds);
          console.log(`🔄 Operation: ${operation}, Reason: ${reason}`);
          
          // Store the invalidation context for use after refresh
          const invalidationContext = {
            operation: operation,
            reason: reason,
            sourceOperation: relationship.source_operation,
            triggeredBy: data.triggered_by
          };
          
          this.refreshTableWithContext(tableName, affectedIds, invalidationContext);
        });
      } else {
        console.log("⚠️ No affected_relationships found in data:", data);
      }
    },

    refreshTable(tableName, affectedRowIds = []) {
      console.log(`🔄 Refreshing table: ${tableName} with affected rows:`, affectedRowIds);
      
      // Find the search results div for this table
      const searchResultsDiv = document.getElementById(`search_results_${tableName}`);
      if (!searchResultsDiv) {
        console.log(`⚠️ No search results div found for table: ${tableName} (looking for search_results_${tableName})`);
        return;
      }

      // Store current checkbox states before refresh
      const currentCheckboxes = {};
      searchResultsDiv.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
        currentCheckboxes[checkbox.value] = checkbox.checked;
      });
      
      // IMPORTANT: Capture the current cell values for comparison after refresh
      const beforeRefreshData = {};
      affectedRowIds.forEach(rowId => {
        const rowElement = document.getElementById(`${rowId}_${tableName}`);
        if (rowElement) {
          const cells = Array.from(rowElement.querySelectorAll('td'));
          beforeRefreshData[rowId] = cells.map(cell => ({
            innerHTML: cell.innerHTML.trim(),
            textContent: (cell.textContent || '').trim()
          }));
          console.log(`📸 Captured before-state for row ${rowId}:`, beforeRefreshData[rowId].length, 'cells');
        }
      });
      
      // Find the search button for this table
      const searchButton = document.querySelector(`input[onclick*="Search('${tableName}')"]`);
      if (searchButton) {
        console.log(`🔄 Triggering refresh for ${tableName} via search button click`);
        
        // Store checkbox states for restoration after refresh
        if (window.savedCheckboxStates) {
          window.savedCheckboxStates[tableName] = currentCheckboxes;
        } else {
          window.savedCheckboxStates = { [tableName]: currentCheckboxes };
        }
        
        searchButton.click();
        
        // After the search completes, compare before/after values and highlight only changed cells
        setTimeout(() => {
          this.compareAndHighlightChanges(tableName, affectedRowIds, beforeRefreshData);
        }, 1500); // Increased delay to allow search to complete
      } else {
        console.log(`⚠️ No search button found for table: ${tableName}`);
        console.log(`Looking for: input[onclick*="Search('${tableName}')"]`);
        
        // Try to find any search-related buttons as fallback
        const allSearchButtons = document.querySelectorAll('input[onclick*="Search"]');
        console.log(`Found ${allSearchButtons.length} search buttons:`, 
          Array.from(allSearchButtons).map(btn => btn.getAttribute('onclick')));
      }
    },

    refreshTableWithContext(tableName, affectedRowIds = [], invalidationContext = {}) {
      console.log(`🔄 Refreshing table with context: ${tableName} with affected rows:`, affectedRowIds);
      console.log(`🔄 Invalidation context:`, invalidationContext);
      
      // Find the search results div for this table
      const searchResultsDiv = document.getElementById(`search_results_${tableName}`);
      if (!searchResultsDiv) {
        console.log(`⚠️ No search results div found for table: ${tableName} (looking for search_results_${tableName})`);
        return;
      }

      // Store current checkbox states before refresh
      const currentCheckboxes = {};
      searchResultsDiv.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
        currentCheckboxes[checkbox.value] = checkbox.checked;
      });
      
      // Find the search button for this table
      const searchButton = document.querySelector(`input[onclick*="Search('${tableName}')"]`);
      if (searchButton) {
        console.log(`🔄 Triggering refresh for ${tableName} via search button click`);
        
        // Store checkbox states for restoration after refresh
        if (window.savedCheckboxStates) {
          window.savedCheckboxStates[tableName] = currentCheckboxes;
        } else {
          window.savedCheckboxStates = { [tableName]: currentCheckboxes };
        }
        
        searchButton.click();
        
        // After the search completes, highlight based on the operation context
        setTimeout(() => {
          this.highlightBasedOnOperation(tableName, affectedRowIds, invalidationContext);
        }, 1500); // Increased delay to allow search to complete
      } else {
        console.log(`⚠️ No search button found for table: ${tableName}`);
        console.log(`Looking for: input[onclick*="Search('${tableName}')"]`);
        
        // Try to find any search-related buttons as fallback
        const allSearchButtons = document.querySelectorAll('input[onclick*="Search"]');
        console.log(`Found ${allSearchButtons.length} search buttons:`, 
          Array.from(allSearchButtons).map(btn => btn.getAttribute('onclick')));
      }
    },

    highlightAffectedRows(tableName, rowIds) {
      if (!rowIds || rowIds.length === 0) return;
      
      console.log(`✨ Checking for specific cell changes in ${tableName} for rows:`, rowIds);
      
      rowIds.forEach(rowId => {
        // Find the specific row using the standard ID pattern
        const rowElement = document.getElementById(`${rowId}_${tableName}`);
        
        if (rowElement) {
          console.log(`🔍 Found row ${rowId}_${tableName}, checking for changed cells`);
          
          // Check if any cells in this row have been marked as updated during the refresh
          const updatedCells = rowElement.querySelectorAll('.cell-updated');
          
          if (updatedCells.length > 0) {
            console.log(`✨ Found ${updatedCells.length} cells already marked as updated in row ${rowId}`);
            // The cells are already highlighted by the updateChangedCells method
            // No additional highlighting needed
          } else {
            console.log(`ℹ️ No cells marked as updated in row ${rowId} - this may be a new row or unchanged data`);
            
            // For truly new rows (like when creating attendees), we can add a subtle border highlight
            // to indicate the row was involved in the operation without being too aggressive
            rowElement.classList.add('row-involved');
            setTimeout(() => {
              rowElement.classList.remove('row-involved');
            }, 2000);
          }
        } else {
          console.log(`⚠️ Could not find row element for ID: ${rowId}_${tableName}`);
        }
      });
    },

    compareAndHighlightChanges(tableName, affectedRowIds, beforeRefreshData) {
      console.log(`🔍 Comparing before/after values for ${tableName} rows:`, affectedRowIds);
      
      affectedRowIds.forEach(rowId => {
        const rowElement = document.getElementById(`${rowId}_${tableName}`);
        const beforeData = beforeRefreshData[rowId];
        
        if (rowElement && beforeData) {
          const afterCells = Array.from(rowElement.querySelectorAll('td'));
          let changedCellCount = 0;
          
          afterCells.forEach((cell, cellIndex) => {
            if (cellIndex < beforeData.length) {
              const beforeCell = beforeData[cellIndex];
              const afterInnerHTML = cell.innerHTML.trim();
              const afterTextContent = (cell.textContent || '').trim();
              
              // Compare both HTML and text content to catch all types of changes
              const htmlChanged = beforeCell.innerHTML !== afterInnerHTML;
              const textChanged = beforeCell.textContent !== afterTextContent;
              
              if (htmlChanged || textChanged) {
                console.log(`🎯 Cell ${cellIndex} in row ${rowId} changed`);
                console.log(`   Before: "${beforeCell.textContent}" -> After: "${afterTextContent}"`);
                
                // Highlight only the changed cell
                cell.classList.add('cell-updated');
                setTimeout(() => {
                  cell.classList.remove('cell-updated');
                }, 2000);
                
                changedCellCount++;
              }
            }
          });
          
          if (changedCellCount > 0) {
            console.log(`✨ Highlighted ${changedCellCount} changed cells in row ${rowId}`);
          } else {
            console.log(`ℹ️ No visible changes detected in row ${rowId} after refresh`);
            // Add subtle indication that this row was involved in the operation
            rowElement.classList.add('row-involved');
            setTimeout(() => {
              rowElement.classList.remove('row-involved');
            }, 1500);
          }
        } else {
          if (!rowElement) {
            console.log(`⚠️ Could not find row element for comparison: ${rowId}_${tableName}`);
          }
          if (!beforeData) {
            console.log(`⚠️ No before-data captured for row: ${rowId}`);
          }
        }
      });
    },

    highlightBasedOnOperation(tableName, affectedRowIds, invalidationContext) {
      console.log(`🎯 Highlighting based on operation for ${tableName}:`, invalidationContext);
      
      const { operation, reason, sourceOperation, triggeredBy } = invalidationContext;
      console.log(`🔍 Operation details: sourceOperation="${sourceOperation}", operation="${operation}", reason="${reason}"`);
      
      affectedRowIds.forEach(rowId => {
        const rowElement = document.getElementById(`${rowId}_${tableName}`);
        
        if (rowElement) {
          console.log(`🔍 Processing row ${rowId} for operation ${sourceOperation}/${operation}`);
          
          // Determine which cells to highlight based on the operation type
          let cellsToHighlight = [];
          
          if (sourceOperation === 'make_attendee') {
            if (tableName === 'Person' && reason === 'attendance_added') {
              // Highlight lecture/course related cells in Person table - be specific about attendance, not teaching
              cellsToHighlight = this.findCellsByExactPattern(rowElement, [
                'Lectures_attended_Person',  // Exact match for lectures attended
                'Courses_in_Person'    // Exact match for courses attended
              ]);
            } else if (tableName === 'Lecture' && reason === 'attendee_count_change') {
              // Highlight attendee count cells in Lecture table
              cellsToHighlight = this.findCellsByPattern(rowElement, [
                'Number_of_attendees', 'attendee', 'count', 'students'
              ]);
            }
          } else if (sourceOperation === 'delete' || sourceOperation === 'delete_array' || 
                     (operation === 'delete') || (operation === 'update' && tableName === 'Group')) {
            console.log(`🗑️ Processing delete/update operation for ${tableName} table`);
            
            // Handle group member deletion or group updates
            if (tableName === 'Group') {
              console.log(`🎯 Looking for group member count cells in Group table for row ${rowId}`);
              // For Group table, highlight the member count cell
              cellsToHighlight = this.findCellsByExactPattern(rowElement, [
                'Number_of_group_members_Group'
              ]);
            } else {
              // For other tables, highlight group-related cells
              cellsToHighlight = this.findCellsByPattern(rowElement, [
                'Groups_in_', 'Number_of_group_members', 'group'
              ]);
            }
          } else {
            console.log(`⚠️ Unhandled operation combination: sourceOperation="${sourceOperation}", operation="${operation}", reason="${reason}"`);
          }
          
          if (cellsToHighlight.length > 0) {
            console.log(`✨ Highlighting ${cellsToHighlight.length} operation-specific cells in row ${rowId}`);
            cellsToHighlight.forEach(cell => {
              cell.classList.add('cell-updated');
              setTimeout(() => {
                cell.classList.remove('cell-updated');
              }, 2500); // Slightly longer for cross-user updates
            });
          } else {
            // Fallback: add subtle row indication
            console.log(`ℹ️ No specific cells found, adding subtle row indication for ${rowId}`);
            rowElement.classList.add('row-involved');
            setTimeout(() => {
              rowElement.classList.remove('row-involved');
            }, 2000);
          }
        } else {
          console.log(`⚠️ Could not find row element for operation highlighting: ${rowId}_${tableName}`);
        }
      });
    },

    findCellsByPattern(rowElement, patterns) {
      const matchingCells = [];
      const cells = Array.from(rowElement.querySelectorAll('td'));
      
      console.log(`🔍 Searching for pattern matches in ${cells.length} cells`);
      console.log(`🔍 Looking for patterns: [${patterns.join(', ')}]`);
      
      cells.forEach((cell, cellIndex) => {
        // Check if the cell has a class that matches any pattern
        const cellClasses = Array.from(cell.classList);
        const cellText = (cell.textContent || '').toLowerCase();
        
        console.log(`   Cell ${cellIndex}: classes = [${cellClasses.join(', ')}], text = "${cellText.substring(0, 50)}..."`);
        
        const matches = patterns.some(pattern => {
          const patternLower = pattern.toLowerCase();
          
          // Check class names for pattern
          const classMatch = cellClasses.some(className => {
            const match = className.toLowerCase().includes(patternLower);
            if (match) {
              console.log(`     ✅ Class match: "${className}" contains "${patternLower}"`);
            }
            return match;
          });
          
          // Check text content for pattern (but be more selective)
          const textMatch = cellText.includes(patternLower) && cellText.length > 5; // Avoid matching single words
          if (textMatch) {
            console.log(`     ✅ Text match: content contains "${patternLower}"`);
          }
          
          return classMatch || textMatch;
        });
        
        if (matches) {
          matchingCells.push(cell);
        }
      });
      
      console.log(`🔍 Found ${matchingCells.length} cells matching patterns [${patterns.join(', ')}]`);
      return matchingCells;
    },

    findCellsByExactPattern(rowElement, exactClassNames) {
      const matchingCells = [];
      const cells = Array.from(rowElement.querySelectorAll('td'));
      
      console.log(`🔍 Searching for exact class matches in ${cells.length} cells`);
      console.log(`🔍 Looking for exact classes: [${exactClassNames.join(', ')}]`);
      
      cells.forEach((cell, cellIndex) => {
        // Check if the cell has an exact class match
        const cellClasses = Array.from(cell.classList);
        console.log(`   Cell ${cellIndex}: classes = [${cellClasses.join(', ')}]`);
        
        const matches = exactClassNames.some(exactClassName => {
          const hasExactMatch = cellClasses.includes(exactClassName);
          if (hasExactMatch) {
            console.log(`     ✅ Found exact match: "${exactClassName}"`);
          }
          return hasExactMatch;
        });
        
        if (matches) {
          console.log(`🎯 Found exact class match: ${cellClasses.join(', ')} contains one of [${exactClassNames.join(', ')}]`);
          matchingCells.push(cell);
        }
      });
      
      // If no exact matches found, try a more flexible approach
      if (matchingCells.length === 0) {
        console.log(`⚠️ No exact matches found, trying flexible pattern matching...`);
        return this.findCellsByPattern(rowElement, exactClassNames);
      }
      
      console.log(`🔍 Found ${matchingCells.length} cells with exact class matches [${exactClassNames.join(', ')}]`);
      return matchingCells;
    }
  });

  // Store the channel reference globally if needed
  window.searchTableChannel = searchTableChannel;
  
  // Listen for custom attendee_added events
  document.addEventListener('attendee_added', function(event) {
    console.log("👂 Received attendee_added event:", event.detail);
    
    const { person_id, lecture_ids, compulsory_ids, exam_ids } = event.detail;
    
    // Manually trigger visual updates for the affected rows
    // Add highlight effects to person row
    const personRow = document.getElementById(`${person_id}_Person`);
    if (personRow) {
      personRow.classList.add('row-updated');
      setTimeout(() => {
        personRow.classList.remove('row-updated');
      }, 1500);
    }
    
    // Add highlight effects to lecture rows
    lecture_ids.forEach(lectureId => {
      const lectureRow = document.getElementById(`${lectureId}_Lecture`);
      if (lectureRow) {
        lectureRow.classList.add('row-updated');
        setTimeout(() => {
          lectureRow.classList.remove('row-updated');
        }, 1500);
      }
    });
    
    console.log("✨ Applied visual highlights to attendee rows");
  });
});
