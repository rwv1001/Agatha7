// ActionCable Search Table Updates
import consumer from "./consumer";

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
  
  const actionCableConsumer = getActionCableConsumer();
  
  if (!actionCableConsumer) {
    console.error("❌ Failed to initialize ActionCable consumer");
    return;
  }
  
  console.log("✅ ActionCable consumer available:", actionCableConsumer);
  
  // Subscribe to search table updates
  const searchTableChannel = actionCableConsumer.subscriptions.create("SearchTableChannel", {
    connected() {
      console.log("✅ Connected to SearchTableChannel - ActionCable working!");
    },

    disconnected() {
      console.log("❌ Disconnected from SearchTableChannel");
    },

    received(data) {
      console.log("📡 Received ActionCable message:", data);
      if (data.action === 'update_search_rows') {
        console.log("🎯 Processing update_search_rows action");
        this.handleSearchTableUpdate(data);
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
