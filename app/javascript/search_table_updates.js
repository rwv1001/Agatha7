// ActionCable Search Table Updates
import consumer from "./consumer";

// Notification System
function showNotification(message, type = 'success') {
  // Remove any existing notifications first
  const existingNotifications = document.querySelectorAll('.custom-notification');
  existingNotifications.forEach(notification => notification.remove());
  
  // Create notification element
  const notification = document.createElement('div');
  notification.className = 'custom-notification';
  notification.textContent = message;
  
  // Style the notification
  notification.style.position = 'fixed';
  notification.style.top = '20px';
  notification.style.right = '20px';
  notification.style.padding = '12px 20px';
  notification.style.borderRadius = '8px';
  notification.style.fontFamily = 'Arial, sans-serif';
  notification.style.fontSize = '14px';
  notification.style.fontWeight = '500';
  notification.style.boxShadow = '0 4px 12px rgba(0, 0, 0, 0.15)';
  notification.style.zIndex = '10000';
  notification.style.maxWidth = '400px';
  notification.style.wordWrap = 'break-word';
  
  // Apply type-specific styling
  if (type === 'success') {
    notification.style.backgroundColor = '#d4edda';
    notification.style.color = '#155724';
    notification.style.border = '2px solid #28a745';
  } else if (type === 'error') {
    notification.style.backgroundColor = '#f8d7da';
    notification.style.color = '#721c24';
    notification.style.border = '2px solid #dc3545';
  }
  
  // Add to page
  document.body.appendChild(notification);
  
  // Animate in
  notification.style.opacity = '0';
  notification.style.transform = 'translateX(100%)';
  setTimeout(() => {
    notification.style.transition = 'all 0.3s ease-in-out';
    notification.style.opacity = '1';
    notification.style.transform = 'translateX(0)';
  }, 10);
  
  // Auto-remove after 10 seconds
  setTimeout(() => {
    if (notification.parentNode) {
      notification.style.opacity = '0';
      notification.style.transform = 'translateX(100%)';
      setTimeout(() => {
        if (notification.parentNode) {
          notification.remove();
        }
      }, 300);
    }
  }, 10000);
}

// Make showNotification globally available
window.showNotification = showNotification;

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

// Global function to hide cells based on current display settings
// This can be called from anywhere, including ERB templates
window.hideCellsBasedOnCurrentDisplay = function(rowElement, tableName) {
  console.log(`🔧 Applying proper display classes for row in table ${tableName}`);
  
  // FIRST: Check for manually deleted columns by comparing with existing rows
  hideDeletedColumns(rowElement, tableName);
  
  // SECOND: Apply PageView-based visibility for multi-table actions
  // Get the current page view configuration from the global variables
  if (typeof window.displayPageCl === 'undefined' || typeof window.old_page_name === 'undefined') {
    console.log(`⚠️ Display configuration not available, skipping PageView class updates`);
    return;
  }
  
  // Use the current page being displayed (e.g., "Person" for Make attendee action)
  const currentPageName = window.old_page_name;
  console.log(`🔧 Current page being displayed: ${currentPageName}`);
  
  // Get the current option ID from the action_select DOM element for the current page
  const selectStr = "action_select_" + currentPageName;
  const selectElement = document.getElementById(selectStr);
  
  if (!selectElement) {
    console.log(`⚠️ No action select element found for ${currentPageName} (looking for ${selectStr}), skipping PageView class updates`);
    return;
  }
  
  const currentOptionId = parseInt(selectElement.value);
  console.log(`🔧 Found current option ID from DOM element ${selectStr}: ${currentOptionId}`);
  
  // Get the page views for the current page
  const pageViews = window.displayPageCl.get(currentPageName);
  if (!pageViews || currentOptionId >= pageViews.length) {
    console.log(`⚠️ No page view found for ${currentPageName} option ${currentOptionId}, skipping PageView class updates`);
    return;
  }
  
  const currentPageView = pageViews[currentOptionId];
  console.log(`🔧 Using page view: ${currentPageView.page_name} - ${currentPageView.option_name} (option ${currentOptionId})`);
  
  // Find the display div configuration for the table we're updating
  // For "Make attendee", this could be welcome_Person or welcome_Lecture
  let targetDisplayDiv = null;
  currentPageView.display_divs.forEach(displayDiv => {
    if (displayDiv.div_id === `welcome_${tableName}`) {
      targetDisplayDiv = displayDiv;
    }
  });
  
  if (!targetDisplayDiv) {
    console.log(`⚠️ No display div found for welcome_${tableName} in current page view, skipping PageView class updates`);
    console.log(`⚠️ Available display divs: ${currentPageView.display_divs.map(d => d.div_id).join(', ')}`);
    return;
  }
  
  console.log(`🔧 Found display div config for welcome_${tableName}:`);
  console.log(`   Visible classes: [${targetDisplayDiv.visible_classes.join(', ')}]`);
  console.log(`   Invisible classes: [${targetDisplayDiv.invisible_classes.join(', ')}]`);
  
  // Apply the invisible classes (hide them)
  targetDisplayDiv.invisible_classes.forEach(invisibleClass => {
    const elementsToHide = rowElement.querySelectorAll(invisibleClass);
    elementsToHide.forEach(element => {
      element.style.display = 'none';
      console.log(`🔧 Hidden element with class: ${invisibleClass}`);
    });
  });
  
  // Apply the visible classes (show them)
  targetDisplayDiv.visible_classes.forEach(visibleClass => {
    const elementsToShow = rowElement.querySelectorAll(visibleClass);
    elementsToShow.forEach(element => {
      element.style.display = '';
      console.log(`🔧 Shown element with class: ${visibleClass}`);
    });
  });
  
  console.log(`✅ Applied PageView display classes for ${tableName} row based on current page view ${currentPageName} option ${currentOptionId}`);
};

// Helper function for checking deleted columns
function hideDeletedColumns(rowElement, tableName) {
  console.log(`🔧 Checking for manually deleted columns in ${tableName} table`);
  
  // Find the search results table to see which columns are currently visible
  const searchResultsDiv = document.getElementById(`search_results_${tableName}`);
  if (!searchResultsDiv) {
    console.log(`⚠️ No search results div found for ${tableName}, skipping deleted column check`);
    return;
  }
  
  // Find an existing row to use as a template for visibility
  const existingRow = searchResultsDiv.querySelector('tr[id*="_' + tableName + '"]');
  if (!existingRow) {
    console.log(`⚠️ No existing rows found in ${tableName} table, skipping deleted column check`);
    return;
  }
  
  // Get the cells from both the existing row and the new row
  const existingCells = Array.from(existingRow.querySelectorAll('td'));
  const newCells = Array.from(rowElement.querySelectorAll('td'));
  
  console.log(`🔧 Comparing visibility: existing row has ${existingCells.length} cells, new row has ${newCells.length} cells`);
  
  // Apply the same visibility to the new row's cells
  newCells.forEach((newCell, index) => {
    if (index < existingCells.length) {
      const existingCell = existingCells[index];
      const isHidden = existingCell.style.display === 'none' || 
                       window.getComputedStyle(existingCell).display === 'none';
      
      if (isHidden) {
        newCell.style.display = 'none';
        console.log(`🔧 Hidden new cell ${index} to match existing row visibility`);
      }
    }
  });
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
  
  // Add reconnection logic and connection monitoring
  let reconnectAttempts = 0;
  const maxReconnectAttempts = 10;
  const baseReconnectDelay = 1000; // 1 second
  let reconnectTimer = null;
  let connectionHealthTimer = null;
  
  // Function to show connection status to users
  function showConnectionStatus(status, message) {
    console.log(`🔗 Connection Status: ${status} - ${message}`);
    
    // Create or update a connection status indicator
    let statusIndicator = document.getElementById('actioncable-status');
    if (!statusIndicator) {
      statusIndicator = document.createElement('div');
      statusIndicator.id = 'actioncable-status';
      statusIndicator.style.cssText = `
        position: fixed;
        top: 10px;
        right: 10px;
        z-index: 10000;
        padding: 8px 12px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: bold;
        transition: all 0.3s ease;
      `;
      document.body.appendChild(statusIndicator);
    }
    
    statusIndicator.textContent = message;
    
    if (status === 'connected') {
      statusIndicator.style.backgroundColor = '#28a745';
      statusIndicator.style.color = 'white';
      // Hide after 3 seconds if connected
      setTimeout(() => {
        if (statusIndicator && statusIndicator.textContent === message) {
          statusIndicator.style.opacity = '0';
          setTimeout(() => {
            if (statusIndicator && statusIndicator.style.opacity === '0') {
              statusIndicator.remove();
            }
          }, 300);
        }
      }, 3000);
    } else if (status === 'connecting') {
      statusIndicator.style.backgroundColor = '#ffc107';
      statusIndicator.style.color = 'black';
      statusIndicator.style.opacity = '1';
    } else if (status === 'disconnected') {
      statusIndicator.style.backgroundColor = '#dc3545';
      statusIndicator.style.color = 'white';
      statusIndicator.style.opacity = '1';
    }
  }
  
  // Function to attempt reconnection with exponential backoff
  function attemptReconnection() {
    if (reconnectAttempts >= maxReconnectAttempts) {
      console.log(`❌ Max reconnection attempts (${maxReconnectAttempts}) reached`);
      showConnectionStatus('disconnected', '🔴 Connection failed - reload page');
      return;
    }
    
    reconnectAttempts++;
    const delay = Math.min(baseReconnectDelay * Math.pow(2, reconnectAttempts - 1), 30000); // Max 30 seconds
    
    console.log(`🔄 Reconnection attempt ${reconnectAttempts}/${maxReconnectAttempts} in ${delay}ms`);
    showConnectionStatus('connecting', `🔄 Reconnecting... (${reconnectAttempts}/${maxReconnectAttempts})`);
    
    reconnectTimer = setTimeout(() => {
      console.log(`🔄 Attempting to reconnect ActionCable (attempt ${reconnectAttempts})`);
      
      try {
        // Force reconnection
        actionCableConsumer.connection.open();
      } catch (error) {
        console.log(`❌ Reconnection attempt ${reconnectAttempts} failed:`, error);
        attemptReconnection(); // Try again
      }
    }, delay);
  }
  
  // Function to check connection health periodically
  function startConnectionHealthMonitoring() {
    if (connectionHealthTimer) {
      clearInterval(connectionHealthTimer);
    }
    
    connectionHealthTimer = setInterval(() => {
      const state = actionCableConsumer.connection.getState();
      console.log(`🔍 Connection health check: ${state}`);
      
      if (state === 'disconnected' || state === 'closed') {
        console.log('🚨 Connection health check detected disconnection, attempting reconnection');
        clearInterval(connectionHealthTimer);
        attemptReconnection();
      }
    }, 30000); // Check every 30 seconds
  }
  
  // Function to reset reconnection state on successful connection
  function resetReconnectionState() {
    reconnectAttempts = 0;
    if (reconnectTimer) {
      clearTimeout(reconnectTimer);
      reconnectTimer = null;
    }
  }

  // Subscribe to search table updates
  const searchTableChannel = actionCableConsumer.subscriptions.create("SearchTableChannel", {
    connected() {
      console.log("✅ Connected to SearchTableChannel - ActionCable working!");
      console.log("🎯 ActionCable connection established successfully");
      
      // Reset reconnection state and show success
      resetReconnectionState();
      showConnectionStatus('connected', '✅ Real-time updates active');
      
      // Start health monitoring
      startConnectionHealthMonitoring();
    },

    disconnected() {
      console.log("❌ Disconnected from SearchTableChannel");
      showConnectionStatus('disconnected', '🔴 Connection lost');
      
      // Stop health monitoring and attempt reconnection
      if (connectionHealthTimer) {
        clearInterval(connectionHealthTimer);
      }
      
      // Start reconnection attempts after a short delay
      setTimeout(() => {
        attemptReconnection();
      }, 1000);
    },

    received(data) {
      console.log("📡 Received ActionCable message:", data);
      console.log("📡 Message action type:", data.action);
      
      if (data.action === 'data_invalidation') {
        console.log("🔄 Processing data_invalidation action (NEW SYSTEM)");
        console.log("🔄 Invalidation data:", data);
        this.handleDataInvalidation(data);
      } else if (data.action === 'update_search_rows') {
        console.log("🎯 Processing update_search_rows action (LEGACY SYSTEM)");
        // Only process legacy updates if there's no data_invalidation in progress
        if (!this.hasRecentDataInvalidation()) {
          this.handleSearchTableUpdate(data);
        } else {
          console.log("⏭️ Skipping legacy update - data_invalidation already handled this");
        }
      } else if (data.action === 'remove_search_rows') {
        console.log("�️ Processing remove_search_rows action");
        this.handleSearchRowRemovals(data);
      } else {
        console.log("⚠️ Unknown action received:", data.action);
      }
    },

    hasRecentDataInvalidation() {
      // Check if we've had a data_invalidation message in the last 5 seconds
      if (!this.lastDataInvalidation) return false;
      return (Date.now() - this.lastDataInvalidation) < 5000;
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
            
            // NOTE: Special Group highlighting is disabled - let the unified system handle all highlighting
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

        // Skip recolour entirely when doing targeted cell updates - highlighting is handled centrally
        if (tableChangedCells > 0) {
          console.log(`✅ Completed targeted cell updates for table ${tableName} (${tableChangedCells} content changes)`);
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
            
            // NOTE: Highlighting is now handled centrally in applyRowUpdates method
            // No need to highlight here to avoid conflicts
            
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
              // Apply proper cell display based on current display settings
              console.log(`🔧 Applying hideCellsBasedOnCurrentDisplay to newly added row ${rowId}`);
              if (typeof window.hideCellsBasedOnCurrentDisplay === 'function') {
                window.hideCellsBasedOnCurrentDisplay(newRowElement, tableName);
              } else {
                this.hideCellsBasedOnCurrentDisplay(newRowElement, tableName);
              }
              
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
              // Apply proper cell display based on current display settings
              console.log(`🔧 Applying hideCellsBasedOnCurrentDisplay to newly added row ${newElement.id}`);
              if (typeof window.hideCellsBasedOnCurrentDisplay === 'function') {
                window.hideCellsBasedOnCurrentDisplay(newElement, tableName);
              } else {
                this.hideCellsBasedOnCurrentDisplay(newElement, tableName);
              }
              
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
      
      // Track that we're handling data invalidation to prevent legacy system conflicts
      this.lastDataInvalidation = Date.now();
      
      // Initialize circuit breaker to prevent infinite loops
      if (!this.refreshAttempts) {
        this.refreshAttempts = new Map();
      }
      
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
          
          // Create a unique key for this refresh attempt
          const refreshKey = `${tableName}_${affectedIds.join(',')}_${operation}_${reason}`;
          const now = Date.now();
          
          // Check if we've attempted this refresh recently (within 10 seconds)
          if (this.refreshAttempts.has(refreshKey)) {
            const lastAttempt = this.refreshAttempts.get(refreshKey);
            if (now - lastAttempt < 3000) {
              console.log(`🚫 Skipping refresh - attempted too recently for ${refreshKey}`);
              return;
            }
          }
          
          // Record this refresh attempt
          this.refreshAttempts.set(refreshKey, now);
          
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
      
      // Handle select box updates based on the trigger model
      if (data.triggered_by) {
        this.handleSelectBoxUpdates(data.triggered_by, data.affected_relationships);
      }
    },

    handleSelectBoxUpdates(triggeredBy, affectedRelationships) {
      console.log("🔄 Handling select box updates for triggered_by:", triggeredBy);
      
      const triggerTable = triggeredBy.table;
      const triggerObjectId = triggeredBy.object_id;
      
      // Define model dependencies for select box refreshing
      const modelDependencies = {
        'Person': ['Person','Lecture', 'Tutorial', 'Attendee', 'TutorialSchedule'],
        'Course': ['Lecture', 'TutorialSchedule'],
        'Institution': ['Person'],
        'Term': ['Lecture', 'TutorialSchedule'],
        'Day': ['Lecture'],
        'Location': ['Lecture'],
        'Lecture': ['Attendee'],
        'TutorialSchedule': ['Tutorial']
      };
      
      // Get dependent models for the trigger table
      const dependentModels = modelDependencies[triggerTable] || [];
      
      // Update select boxes for each dependent model
      dependentModels.forEach(dependentModel => {
        console.log(`🔄 Refreshing ${dependentModel}_select elements due to ${triggerTable} update`);
        
        // Find all select elements with class dependentModel_select
        const selectElements = document.getElementsByClassName(`${dependentModel}_select`);
        Array.from(selectElements).forEach(selectElement => {
          console.log(`🔄 Processing select element:`, selectElement.id);
          
          // For external filter selects, use refreshExternalFilterSelects
          if (selectElement.classList.contains('external_filter_argument_selection')) {
            console.log(`🔄 Refreshing external filter select: ${selectElement.id}`);
            
            // Find the parent external filter container to get the table name
            const externalFilterContainer = selectElement.closest('[id^="external_filters_"]');
            if (externalFilterContainer && typeof window.refreshExternalFilterSelects === 'function') {
              const containerTableName = externalFilterContainer.id.replace('external_filters_', '');
              console.log(`🔄 Calling refreshExternalFilterSelects for table: ${containerTableName}`);
              setTimeout(() => {
                 window.refreshExternalFilterSelects(containerTableName, triggerTable);
              }, 1000);
            }
            else {
              console.log(`⚠️ No external filter container found for: ${selectElement.id}`);
            }
          }
          
          // For regular select elements, trigger their onchange handler
          else if (selectElement.onchange) {
            console.log(`🔄 Triggering onchange for select: ${selectElement.id}`);
            setTimeout(() => {
              selectElement.onchange();
            }, 50);
          }
        });
      });
      
      // Handle edit page select boxes
      this.handleEditPageSelectBoxUpdates(triggerTable, triggerObjectId);
    },

    handleEditPageSelectBoxUpdates(triggerTable, triggerObjectId) {
      console.log("🔄 Handling edit page select box updates for:", triggerTable, "ID:", triggerObjectId);
      
      // Define which edit select boxes need updating based on the trigger table
      const editSelectDependencies = {
        'Person': ['edit_person_id'],
        'Course': ['edit_course_id'],
        'Institution': ['edit_institution_id'],
        'Term': ['edit_term_id'],
        'Day': ['edit_day_id'],
        'Location': ['edit_location_id'],
        'Lecture': ['edit_lecture_id'],
        'TutorialSchedule': ['edit_tutorial_schedule_id'],
        'Tutorial': ['edit_tutorial_id'],
        'Group': ['edit_group_id'],
        'Programme': ['edit_programme_id']
      };
      
      const selectIdsToUpdate = editSelectDependencies[triggerTable] || [];
      
      selectIdsToUpdate.forEach(selectId => {
        const selectElement = document.getElementById(selectId);
        if (selectElement) {
          console.log(`🔄 Found edit page select box: ${selectId}`);
          
          // Store the current selected value
          const currentValue = selectElement.value;
          
          // Refresh the select box options by making an AJAX call
          this.refreshEditSelectBox(selectElement, triggerTable, triggerObjectId, currentValue);
        } else {
          console.log(`⚠️ Edit page select box not found: ${selectId} (this may be normal if the page doesn't have this select box)`);
        }
      });
    },

    refreshEditSelectBox(selectElement, triggerTable, triggerObjectId, currentValue) {
      const selectId = selectElement.id;
      console.log(`🔄 Refreshing edit select box: ${selectId}`);
      
      // Extract the field name from the select ID (e.g., 'edit_person_id' -> 'person_id')
      const fieldName = selectId.replace('edit_', '');
      
      // Get the table name from the current page (this should be available in the DOM)
      const tableNameElement = document.querySelector('input[name="table_name"]');
      if (!tableNameElement) {
        console.log(`⚠️ Cannot find table_name input for ${selectId}`);
        return;
      }
      
      const tableName = tableNameElement.value;
      
      // Get the current object ID
      const idElement = document.querySelector('input[name="id"], input[id="id_value_updater"]');
      if (!idElement) {
        console.log(`⚠️ Cannot find object ID input for ${selectId}`);
        return;
      }
      
      const objectId = idElement.value;
      
      console.log(`🔄 Making AJAX request to refresh ${selectId} for ${tableName} ID ${objectId}`);
      
      // Make AJAX request to get updated select options
      const formData = new FormData();
      formData.append('table_name', tableName);
      formData.append('object_id', objectId);
      formData.append('field_name', fieldName);
      formData.append('current_value', currentValue);
      
      fetch('/welcome/refresh_edit_select', {
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
        return response.json();
      })
      .then(data => {
        console.log(`✅ Received updated options for ${selectId}:`, data);
        
        // Update the select box options
        this.updateSelectOptions(selectElement, data.options, currentValue);
      })
      .catch(error => {
        console.log(`❌ Failed to refresh ${selectId}:`, error);
      });
    },

    updateSelectOptions(selectElement, newOptions, previousValue) {
      console.log(`🔄 Updating select options for ${selectElement.id}`);
      
      // Clear existing options
      selectElement.innerHTML = '';
      
      // Add new options
      newOptions.forEach(option => {
        const optionElement = document.createElement('option');
        optionElement.value = option.id;
        optionElement.textContent = option.name;
        
        // Restore the previous selection if it still exists
        if (option.id.toString() === previousValue) {
          optionElement.selected = true;
          console.log(`✅ Restored previous selection: ${option.name} (ID: ${option.id})`);
        }
        
        selectElement.appendChild(optionElement);
      });
      
      console.log(`✅ Updated ${selectElement.id} with ${newOptions.length} options`);
      
      // If the previous value is no longer available, select the first option
      if (selectElement.selectedIndex === -1 && newOptions.length > 0) {
        selectElement.selectedIndex = 0;
        console.log(`⚠️ Previous value no longer available, selected first option: ${newOptions[0].name}`);
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
        console.log(`🔄 Search button found for ${tableName} but automatic refresh disabled`);
        
        // Store checkbox states for restoration after refresh
        if (window.savedCheckboxStates) {
          window.savedCheckboxStates[tableName] = currentCheckboxes;
        } else {
          window.savedCheckboxStates = { [tableName]: currentCheckboxes };
        }
        
        // AUTOMATIC REFRESH DISABLED: User must manually click Search button
        // searchButton.click(); // REMOVED - No automatic page refreshes
        console.log(`⚠️ Table ${tableName} needs manual refresh - automatic refresh disabled`);
        
        // Since we're not doing automatic refresh, just add subtle indication to affected rows
        setTimeout(() => {
          affectedRowIds.forEach(rowId => {
            const rowElement = document.getElementById(`${rowId}_${tableName}`);
            if (rowElement) {
              rowElement.classList.add('row-involved');
              setTimeout(() => {
                rowElement.classList.remove('row-involved');
              }, 2000);
            }
          });
        }, 100);
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
      
      const operation = invalidationContext.operation;
      const sourceOperation = invalidationContext.sourceOperation;
      
      // Handle DELETE operations - remove rows from the table
      if (operation === 'delete') {
        console.log(`🗑️ DELETE operation detected for ${tableName} - removing ${affectedRowIds.length} rows`);
        this.removeTableRows(tableName, affectedRowIds, invalidationContext);
        return;
      }
      
      // For make_attendee operations, ONLY use targeted updates - never fall back to full refresh
      const isAttendeeOperation = sourceOperation === 'make_attendee' || 
                                  invalidationContext.reason === 'attendance_added' ||
                                  invalidationContext.reason === 'attendee_count_change';
      
      if (isAttendeeOperation) {
        console.log(`🎯 Attendee operation detected - using ONLY targeted updates, no fallback to full refresh`);
        if (affectedRowIds.length > 0) {
          this.updateSpecificRows(tableName, affectedRowIds, invalidationContext);
          return;
        } else {
          console.log(`ℹ️ No specific row IDs for attendee operation - skipping update for ${tableName}`);
          return;
        }
      }
      
      // Initialize circuit breaker for targeted updates (for non-attendee operations)
      if (!this.targetedUpdateAttempts) {
        this.targetedUpdateAttempts = new Map();
      }
      
      // Create a unique key for this targeted update attempt
      const updateKey = `${tableName}_${affectedRowIds.join(',')}_targeted`;
      const now = Date.now();
      
      // Check if we've attempted targeted updates for this recently (within 30 seconds)
      if (this.targetedUpdateAttempts.has(updateKey)) {
        const lastAttempt = this.targetedUpdateAttempts.get(updateKey);
        if (now - lastAttempt < 50) {
          console.log(`🚫 Skipping targeted updates - attempted too recently, using full refresh instead`);
          // Skip to full table refresh
        } else {
          // Clear old attempt and try targeted updates
          this.targetedUpdateAttempts.delete(updateKey);
          
          // For cross-tab/cross-user updates, try targeted row updates first
          if (affectedRowIds.length > 0 && affectedRowIds.length <= 10) {
            console.log(`🎯 Attempting targeted row updates for ${affectedRowIds.length} specific rows`);
            this.targetedUpdateAttempts.set(updateKey, now);
            this.updateSpecificRows(tableName, affectedRowIds, invalidationContext);
            return;
          }
        }
      } else {
        // First attempt - try targeted updates
        if (affectedRowIds.length > 0 && affectedRowIds.length <= 10) {
          console.log(`🎯 Attempting targeted row updates for ${affectedRowIds.length} specific rows`);
          this.targetedUpdateAttempts.set(updateKey, now);
          this.updateSpecificRows(tableName, affectedRowIds, invalidationContext);
          return;
        }
      }
      
      // Fallback to full table refresh for larger changes or circuit breaker triggered
      // (This will only happen for non-attendee operations)
      console.log(`🔄 Falling back to full table refresh for non-attendee operation`);
      
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
        console.log(`🔄 Search button found for ${tableName} but automatic refresh disabled`);
        
        // Store checkbox states for restoration after refresh
        if (window.savedCheckboxStates) {
          window.savedCheckboxStates[tableName] = currentCheckboxes;
        } else {
          window.savedCheckboxStates = { [tableName]: currentCheckboxes };
        }
        
        // AUTOMATIC REFRESH DISABLED: User must manually click Search button  
        // searchButton.click(); // REMOVED - No automatic page refreshes
        console.log(`⚠️ Table ${tableName} needs manual refresh - automatic refresh disabled`);
        
        // Since we're not doing automatic refresh, just add subtle indication to affected rows
        setTimeout(() => {
          affectedRowIds.forEach(rowId => {
            const rowElement = document.getElementById(`${rowId}_${tableName}`);
            if (rowElement) {
              rowElement.classList.add('row-involved');
              setTimeout(() => {
                rowElement.classList.remove('row-involved');
              }, 2000);
            }
          });
        }, 100);
      } else {
        console.log(`⚠️ No search button found for table: ${tableName}`);
        console.log(`Looking for: input[onclick*="Search('${tableName}')"]`);
        
        // Try to find any search-related buttons as fallback
        const allSearchButtons = document.querySelectorAll('input[onclick*="Search"]');
        console.log(`Found ${allSearchButtons.length} search buttons:`, 
          Array.from(allSearchButtons).map(btn => btn.getAttribute('onclick')));
      }
    },

    updateSpecificRows(tableName, affectedRowIds, invalidationContext) {
      console.log(`🎯 Updating specific rows in ${tableName}: ${affectedRowIds.join(', ')}`);
      
      // Check if this is an attendee operation
      const sourceOperation = invalidationContext.sourceOperation;
      const isAttendeeOperation = sourceOperation === 'make_attendee' || 
                                  invalidationContext.reason === 'attendance_added' ||
                                  invalidationContext.reason === 'attendee_count_change';
      
      // Capture before state for comparison
      const beforeRefreshData = {};
      affectedRowIds.forEach(rowId => {
        const rowElement = document.getElementById(`${rowId}_${tableName}`);
        if (rowElement) {
          const cells = Array.from(rowElement.querySelectorAll('td'));
          beforeRefreshData[rowId] = cells.map(cell => ({
            innerHTML: cell.innerHTML.trim(),
            textContent: (cell.textContent || '').trim()
          }));
          console.log(`📸 Captured before-state for targeted update of row ${rowId}:`, beforeRefreshData[rowId].length, 'cells');
        }
      });
      
      // Make AJAX request to fetch updated row data
      const params = new URLSearchParams();
      params.append('table_name', tableName);
      params.append('row_ids', affectedRowIds.join(','));
      params.append('action', 'fetch_rows');
      
      console.log(`🌐 Fetching updated row data for ${tableName} rows: ${affectedRowIds.join(', ')}`);
      
      fetch(`/welcome/fetch_updated_rows?${params.toString()}`, {
        method: 'GET',
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      .then(response => {
        console.log(`📡 Received response for row updates:`, response.status);
        if (!response.ok) {
          console.log(`❌ HTTP Error ${response.status}: ${response.statusText}`);
          response.text().then(text => {
            console.log(`❌ Error response body:`, text);
          });
          throw new Error(`HTTP ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        console.log(`✅ Received updated row data:`, data);
        this.applyRowUpdates(tableName, data.rows, beforeRefreshData);
      })
      .catch(error => {
        console.log(`❌ Failed to fetch specific rows for ${tableName} (IDs: ${affectedRowIds.join(', ')}):`, error);
        
        if (isAttendeeOperation) {
          console.log(`🚫 Attendee operation failed - NOT falling back to full refresh to preserve checkboxes`);
          console.log(`ℹ️ Adding subtle indication that these rows were affected by the operation`);
          
          // For attendee operations, just add a subtle visual indication without disturbing checkboxes
          affectedRowIds.forEach(rowId => {
            const rowElement = document.getElementById(`${rowId}_${tableName}`);
            if (rowElement) {
              rowElement.classList.add('row-involved');
              setTimeout(() => {
                rowElement.classList.remove('row-involved');
              }, 2000);
            }
          });
        } else {
          // For non-attendee operations, allow fallback to full refresh
          console.log(`🔄 Non-attendee operation failed, falling back to full refresh`);
          
          // Clear the targeted update attempt to prevent repeated failures
          const updateKey = `${tableName}_${affectedRowIds.join(',')}_targeted`;
          if (this.targetedUpdateAttempts) {
            this.targetedUpdateAttempts.delete(updateKey);
          }
          
          // Fallback to full table refresh
          //this.performFullTableRefresh(tableName, affectedRowIds, beforeRefreshData);
        }
      });
    },

    applyRowUpdates(tableName, updatedRows, beforeRefreshData) {
      console.log(`🔄 Applying updates to ${updatedRows.length} rows in ${tableName}`);
      
      updatedRows.forEach(rowData => {
        const rowId = rowData.id;
        const rowElement = document.getElementById(`${rowId}_${tableName}`);
        
        if (rowElement && rowData.html) {
          console.log(`🔄 Updating row ${rowId}_${tableName} with new HTML`);
          
          // PRESERVE CHECKBOX STATES before replacing content
          const checkboxStates = {};
          const checkboxes = rowElement.querySelectorAll('input[type="checkbox"]');
          checkboxes.forEach(checkbox => {
            if (checkbox.id) {
              checkboxStates[checkbox.id] = checkbox.checked;
              console.log(`💾 Preserving checkbox state: ${checkbox.id} = ${checkbox.checked}`);
            }
          });
          
          // Parse the new HTML
          const tempDiv = document.createElement('table');
          tempDiv.innerHTML = rowData.html.trim();
          const newRowElement = tempDiv.querySelector('tr');
          
          if (newRowElement) {
            // Do the comparison BEFORE replacing the content
            const beforeData = beforeRefreshData[rowId];
            const changedCellIndices = [];
            
            if (beforeData) {
              console.log(`🔍 Comparing row ${rowId} BEFORE replacing content`);
              
              // Get current (before) cells for comparison
              const currentCells = Array.from(rowElement.querySelectorAll('td'));
              const newCells = Array.from(newRowElement.querySelectorAll('td'));
              
              console.log(`🔍 Row has ${currentCells.length} current cells, ${newCells.length} new cells`);
              
              // Compare and track differences
              let changedCellCount = 0;
              newCells.forEach((newCell, cellIndex) => {
                if (cellIndex < currentCells.length && cellIndex < beforeData.length) {
                  const currentCell = currentCells[cellIndex];
                  const beforeCell = beforeData[cellIndex];
                  
                  const newInnerHTML = newCell.innerHTML.trim();
                  const beforeInnerHTML = beforeCell.innerHTML.trim();
                  
                  // Normalize content for comparison
                  const newNorm = this.normalizeContent(newInnerHTML);
                  const beforeNorm = this.normalizeContent(beforeInnerHTML);
                  
                  if (newNorm !== beforeNorm) {
                    console.log(`🎯 Cell ${cellIndex} changed!`);
                    console.log(`   BEFORE: "${beforeInnerHTML}"`);
                    console.log(`   AFTER:  "${newInnerHTML}"`);
                    
                    changedCellCount++;
                    changedCellIndices.push(cellIndex);
                  }
                }
              });
              
              if (changedCellCount > 0) {
                console.log(`✨ Row ${rowId} has ${changedCellCount} changed cells - will be highlighted`);
              } else {
                console.log(`ℹ️ Row ${rowId} updated but no visible changes detected`);
              }
            }
            
            // Now replace the row content
            rowElement.innerHTML = newRowElement.innerHTML;
            
            // IMMEDIATELY HIDE CELLS that should be hidden (before highlighting)
            this.hideCellsBasedOnCurrentDisplay(rowElement, tableName);
            
            // RESTORE CHECKBOX STATES after replacing content
            Object.keys(checkboxStates).forEach(checkboxId => {
              const restoredCheckbox = document.getElementById(checkboxId);
              if (restoredCheckbox) {
                restoredCheckbox.checked = checkboxStates[checkboxId];
                console.log(`✅ Restored checkbox state: ${checkboxId} = ${checkboxStates[checkboxId]}`);
              }
            });
            
            // AFTER replacing content and hiding cells, highlight the changed cells
            if (changedCellIndices.length > 0) {
              setTimeout(() => {
                const updatedCells = Array.from(rowElement.querySelectorAll('td'));
                changedCellIndices.forEach(cellIndex => {
                  if (cellIndex < updatedCells.length) {
                    const cellToHighlight = updatedCells[cellIndex];
                    console.log(`✨ Highlighting cell ${cellIndex} in updated row ${rowId}`);
                    cellToHighlight.classList.add('cell-updated');
                    setTimeout(() => {
                      cellToHighlight.classList.remove('cell-updated');
                    }, 10000);
                  }
                });
              }, 50); // Small delay to ensure hiding is applied first
            }
          } else {
            console.log(`⚠️ Could not parse new row HTML for ${rowId}, applying subtle indication`);
            rowElement.classList.add('row-involved');
            setTimeout(() => {
              rowElement.classList.remove('row-involved');
            }, 1500);
          }          
        } else {
          console.log(`⚠️ Could not update row ${rowId}_${tableName} - element not found or no HTML provided`);
        }
      });
    },

    performFullTableRefresh(tableName, affectedRowIds, beforeRefreshData) {
      console.log(`🔄 Performing full table refresh for ${tableName} (circuit breaker fallback)`);
      
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
        console.log(`🔄 Search button found for ${tableName} but automatic refresh disabled`);
        
        // Store checkbox states for restoration after refresh
        if (window.savedCheckboxStates) {
          window.savedCheckboxStates[tableName] = currentCheckboxes;
        } else {
          window.savedCheckboxStates = { [tableName]: currentCheckboxes };
        }
        
        // AUTOMATIC REFRESH DISABLED: User must manually click Search button
        // searchButton.click(); // REMOVED - No automatic page refreshes
        console.log(`⚠️ Table ${tableName} needs manual refresh - automatic refresh disabled`);
        
        // Since we're not doing automatic refresh, just add subtle indication to affected rows
        setTimeout(() => {
          affectedRowIds.forEach(rowId => {
            const rowElement = document.getElementById(`${rowId}_${tableName}`);
            if (rowElement) {
              rowElement.classList.add('row-involved');
              setTimeout(() => {
                rowElement.classList.remove('row-involved');
              }, 2000);
            }
          });
        }, 100);
      } else {
        console.log(`⚠️ No search button found for table: ${tableName}`);
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
        
        console.log(`\n📊 === DETAILED COMPARISON FOR ROW ${rowId}_${tableName} ===`);
        
        if (rowElement && beforeData) {
          const afterCells = Array.from(rowElement.querySelectorAll('td'));
          let changedCellCount = 0;
          
          console.log(`🔍 Row has ${afterCells.length} cells, comparing with ${beforeData.length} before-cells`);
          
          afterCells.forEach((cell, cellIndex) => {
            const cellClasses = Array.from(cell.classList).join(', ');
            console.log(`\n🔍 Cell ${cellIndex} (classes: "${cellClasses}"):`);
            
            if (cellIndex < beforeData.length) {
              const beforeCell = beforeData[cellIndex];
              const afterInnerHTML = cell.innerHTML.trim();
              const afterTextContent = (cell.textContent || '').trim();
              
              // Normalize content for better comparison
              const beforeHTMLNorm = this.normalizeContent(beforeCell.innerHTML);
              const afterHTMLNorm = this.normalizeContent(afterInnerHTML);
              const beforeTextNorm = this.normalizeContent(beforeCell.textContent);
              const afterTextNorm = this.normalizeContent(afterTextContent);
              
              console.log(`   📋 BEFORE HTML: "${beforeCell.innerHTML}"`);
              console.log(`   📋 AFTER  HTML: "${afterInnerHTML}"`);
              console.log(`   📋 BEFORE TEXT: "${beforeCell.textContent}"`);
              console.log(`   📋 AFTER  TEXT: "${afterTextContent}"`);
              console.log(`   📋 BEFORE HTML (normalized): "${beforeHTMLNorm}"`);
              console.log(`   📋 AFTER  HTML (normalized): "${afterHTMLNorm}"`);
              console.log(`   📋 BEFORE TEXT (normalized): "${beforeTextNorm}"`);
              console.log(`   📋 AFTER  TEXT (normalized): "${afterTextNorm}"`);
              
              // Compare both HTML and text content to catch all types of changes
              const htmlChanged = beforeHTMLNorm !== afterHTMLNorm;
              const textChanged = beforeTextNorm !== afterTextNorm;
              
              if (htmlChanged || textChanged) {
                console.log(`   🎯 *** CELL ${cellIndex} CHANGED! ***`);
                console.log(`   🎯 HTML changed: ${htmlChanged}, Text changed: ${textChanged}`);
                
                // NOTE: Cell highlighting is now handled centrally in applyRowUpdates
                // This method is only used for full table refresh comparison
                
                changedCellCount++;
              } else {
                console.log(`   ✅ Cell ${cellIndex} unchanged`);
              }
            } else {
              console.log(`   ⚠️ Cell ${cellIndex} has no corresponding before-data`);
            }
          });
          
          console.log(`\n📊 === SUMMARY FOR ROW ${rowId} ===`);
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
              // Use pattern matching to catch variations like "Lectures_attended_in_term_Person"
              cellsToHighlight = this.findCellsByPattern(rowElement, [
                'Lectures_attended',  // Pattern match for lectures attended (will catch Lectures_attended_in_term_Person)
                'Courses_in_Person'   // Exact match for courses attended
              ]);
              console.log(`🎯 Looking for lecture attendance cells in Person table for row ${rowId}`);
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
            console.log(`✨ Found ${cellsToHighlight.length} operation-specific cells in row ${rowId}`);
            console.log(`ℹ️ NOTE: Cell highlighting is now handled centrally in applyRowUpdates method`);
            console.log(`ℹ️ These cells will be highlighted when the row update is applied`);
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
    },

    hideCellsBasedOnCurrentDisplay(rowElement, tableName) {
      console.log(`🔧 Applying proper display classes for updated row in table ${tableName}`);
      
      // FIRST: Check for manually deleted columns by comparing with existing rows
      this.hideDeletedColumns(rowElement, tableName);
      
      // SECOND: Apply PageView-based visibility for multi-table actions
      // Get the current page view configuration from the global variables
      if (typeof window.displayPageCl === 'undefined' || typeof window.old_page_name === 'undefined') {
        console.log(`⚠️ Display configuration not available, skipping PageView class updates`);
        return;
      }
      
      // Use the current page being displayed (e.g., "Person" for Make attendee action)
      const currentPageName = window.old_page_name;
      console.log(`🔧 Current page being displayed: ${currentPageName}`);
      
      // Get the current option ID from the action_select DOM element for the current page
      const selectStr = "action_select_" + currentPageName;
      const selectElement = document.getElementById(selectStr);
      
      if (!selectElement) {
        console.log(`⚠️ No action select element found for ${currentPageName} (looking for ${selectStr}), skipping PageView class updates`);
        return;
      }
      
      const currentOptionId = parseInt(selectElement.value);
      console.log(`🔧 Found current option ID from DOM element ${selectStr}: ${currentOptionId}`);
      
      // Get the page views for the current page
      const pageViews = window.displayPageCl.get(currentPageName);
      if (!pageViews || currentOptionId >= pageViews.length) {
        console.log(`⚠️ No page view found for ${currentPageName} option ${currentOptionId}, skipping PageView class updates`);
        return;
      }
      
      const currentPageView = pageViews[currentOptionId];
      console.log(`🔧 Using page view: ${currentPageView.page_name} - ${currentPageView.option_name} (option ${currentOptionId})`);
      
      // Find the display div configuration for the table we're updating
      // For "Make attendee", this could be welcome_Person or welcome_Lecture
      let targetDisplayDiv = null;
      currentPageView.display_divs.forEach(displayDiv => {
        if (displayDiv.div_id === `welcome_${tableName}`) {
          targetDisplayDiv = displayDiv;
        }
      });
      
      if (!targetDisplayDiv) {
        console.log(`⚠️ No display div found for welcome_${tableName} in current page view, skipping PageView class updates`);
        console.log(`⚠️ Available display divs: ${currentPageView.display_divs.map(d => d.div_id).join(', ')}`);
        return;
      }
      
      console.log(`🔧 Found display div config for welcome_${tableName}:`);
      console.log(`   Visible classes: [${targetDisplayDiv.visible_classes.join(', ')}]`);
      console.log(`   Invisible classes: [${targetDisplayDiv.invisible_classes.join(', ')}]`);
      
      // Apply the invisible classes (hide them)
      targetDisplayDiv.invisible_classes.forEach(invisibleClass => {
        const elementsToHide = rowElement.querySelectorAll(invisibleClass);
        elementsToHide.forEach(element => {
          element.style.display = 'none';
          console.log(`🔧 Hidden element with class: ${invisibleClass}`);
        });
      });
      
      // Apply the visible classes (show them)
      targetDisplayDiv.visible_classes.forEach(visibleClass => {
        const elementsToShow = rowElement.querySelectorAll(visibleClass);
        elementsToShow.forEach(element => {
          element.style.display = '';
          console.log(`🔧 Shown element with class: ${visibleClass}`);
        });
      });
      
      console.log(`✅ Applied PageView display classes for ${tableName} updated row based on current page view ${currentPageName} option ${currentOptionId}`);
    },

    hideDeletedColumns(rowElement, tableName) {
      console.log(`🔧 Checking for manually deleted columns in ${tableName} table`);
      
      // Find the search results table to see which columns are currently visible
      const searchResultsDiv = document.getElementById(`search_results_${tableName}`);
      if (!searchResultsDiv) {
        console.log(`⚠️ No search results div found for ${tableName}, skipping deleted column check`);
        return;
      }
      
      // Find an existing row to use as a template for visibility
      const existingRow = searchResultsDiv.querySelector('tr[id*="_' + tableName + '"]');
      if (!existingRow) {
        console.log(`⚠️ No existing rows found in ${tableName} table, skipping deleted column check`);
        return;
      }
      
      // Get the cells from both the existing row and the new row
      const existingCells = Array.from(existingRow.querySelectorAll('td'));
      const newCells = Array.from(rowElement.querySelectorAll('td'));
      
      console.log(`🔧 Comparing visibility: existing row has ${existingCells.length} cells, new row has ${newCells.length} cells`);
      
      // Apply the same visibility state from existing cells to new cells
      existingCells.forEach((existingCell, index) => {
        if (index < newCells.length) {
          const newCell = newCells[index];
          const isHidden = existingCell.style.display === 'none' || 
                          getComputedStyle(existingCell).display === 'none';
          
          if (isHidden) {
            newCell.style.display = 'none';
            console.log(`🔧 Hidden cell ${index} in new row (matching existing row visibility)`);
          } else {
            // Ensure it's visible (remove any display:none)
            if (newCell.style.display === 'none') {
              newCell.style.display = '';
              console.log(`🔧 Showed cell ${index} in new row (matching existing row visibility)`);
            }
          }
        }
      });
      
      // Also check the header cells for additional visibility rules
      const headerRow = searchResultsDiv.querySelector('tr th');
      if (headerRow) {
        const headerCells = Array.from(headerRow.parentElement.querySelectorAll('th'));
        console.log(`🔧 Also checking ${headerCells.length} header cells for visibility rules`);
        
        headerCells.forEach((headerCell, index) => {
          if (index < newCells.length) {
            const newCell = newCells[index];
            const isHeaderHidden = headerCell.style.display === 'none' || 
                                  getComputedStyle(headerCell).display === 'none';
            
            if (isHeaderHidden && newCell.style.display !== 'none') {
              newCell.style.display = 'none';
              console.log(`🔧 Hidden cell ${index} in new row (header is hidden)`);
            }
          }
        });
      }
      
      console.log(`✅ Applied deleted column visibility rules for ${tableName} updated row`);
    },

    removeTableRows(tableName, rowIds, invalidationContext = {}) {
      console.log(`🗑️ Removing ${rowIds.length} rows from ${tableName} table:`, rowIds);
      
      rowIds.forEach(rowId => {
        const rowElementId = `${rowId}_${tableName}`;
        const rowElement = document.getElementById(rowElementId);
        
        if (rowElement) {
          console.log(`🗑️ Removing row element: ${rowElementId}`);
          
          // Add fade-out effect before removal
          rowElement.style.transition = 'opacity 0.5s ease-out';
          rowElement.style.opacity = '0.3';
          
          setTimeout(() => {
            rowElement.remove();
            console.log(`✅ Successfully removed row: ${rowElementId}`);
            
            // Re-stripe the table rows after removal
            this.restripeTableRows(tableName);
          }, 500);
        } else {
          console.log(`⚠️ Row element ${rowElementId} not found for removal`);
        }
      });
    },

    restripeTableRows(tableName) {
      // Re-apply alternating row colors after row deletion
      const searchResultsDiv = document.getElementById(`search_results_${tableName}`);
      if (searchResultsDiv) {
        const rows = searchResultsDiv.querySelectorAll('tr[id*="_' + tableName + '"]');
        rows.forEach((row, index) => {
          row.style.background = index % 2 === 0 ? '#CCCCCC' : '#EEEEEE';
        });
        console.log(`🎨 Re-striped ${rows.length} rows in ${tableName} table`);
      }
    },

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
