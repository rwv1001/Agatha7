// ActionCable Search Table Updates
import consumer from "./consumer";

// Notification System
function showNotification(message, type = 'success') {
  // Calculate position for new notification
  const existingNotifications = document.querySelectorAll('.custom-notification');
  let topPosition = 20; // Start at 20px from top
  
  // Stack notifications vertically
  existingNotifications.forEach(notification => {
    const rect = notification.getBoundingClientRect();
    topPosition = Math.max(topPosition, rect.bottom + 10); // 10px gap between notifications
  });
  
  // Create notification element
  const notification = document.createElement('div');
  notification.className = 'custom-notification';  
  notification.innerHTML = message;
  
  // Style the notification
  notification.style.position = 'fixed';
  notification.style.top = topPosition + 'px';
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
    }, 10000); // Check every 10 seconds
  }
  
  // Function to reset reconnection state on successful connection
  function resetReconnectionState() {
    reconnectAttempts = 0;
    if (reconnectTimer) {
      clearTimeout(reconnectTimer);
      reconnectTimer = null;
    }
  }

  // Function to reset reconnection state with a delay to ensure stable connection
  function delayedResetReconnectionState() {
    setTimeout(() => {
      resetReconnectionState();
    }, 2000); // Wait 2 seconds to ensure connection is stable
  }

  // Subscribe to search table updates
  const searchTableChannel = actionCableConsumer.subscriptions.create("SearchTableChannel", {
    connected() {
      console.log("✅ Connected to SearchTableChannel - ActionCable working!");
      console.log("🎯 ActionCable connection established successfully");
      
      // Show success immediately but delay resetting reconnection state
      showConnectionStatus('connected', '✅ Real-time updates active');
      
      // Reset reconnection state after a delay to ensure stable connection
      delayedResetReconnectionState();
      
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
        const changedCells = this.updateChangedCells(rowElement, rowData.html, updateType, affectedExtendedFilters, tableName);
        
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

    updateChangedCells(currentRowElement, newRowHtml, updateType, affectedExtendedFilters, tableName = null) {
      console.log('🔧 updateChangedCells: updateChangedCells called with:', {
        updateType,
        affectedExtendedFilters,
        newRowHtml: newRowHtml.substring(0, 800) + '...'
      });
      
      // Clean up the HTML and try multiple parsing approaches
      const cleanedHtml = newRowHtml.trim();
      console.log('🧹 updateChangedCells: Cleaned HTML starts with:', cleanedHtml.substring(0, 100));
      
      // Create a temporary element to parse the new HTML
      const tempDiv = document.createElement('table');
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
        console.log('❌ updateChangedCells: Could not parse new row HTML after multiple attempts, falling back to full replacement');
        console.log('Raw HTML:', newRowHtml);
        currentRowElement.outerHTML = newRowHtml;
        
        // Add glow effect to the updated row after replacement
        const newlyInsertedRow = document.getElementById(currentRowElement.id);
        if (newlyInsertedRow) {
          console.log(`✨ updateChangedCells: Glow effect added to newly inserted row with id ${currentRowElement.id}`);
          newlyInsertedRow.classList.add('row-updated');
          setTimeout(() => {
            newlyInsertedRow.classList.remove('row-updated');
          }, 1500);
        }
        return 1; // Count full replacement as 1 change
      }
      
      console.log('✅ updateChangedCells: Successfully parsed new row element');
      
      // Get all cells from both current and new rows
      const currentCells = Array.from(currentRowElement.querySelectorAll('td'));
      const newCells = Array.from(newRowElement.querySelectorAll('td'));

      console.log(`🔍 updateChangedCells: Comparing ${currentCells.length} current cells with ${newCells.length} new cells`);

      // Warn if cell counts differ
      if (currentCells.length !== newCells.length) {
        console.warn(`⚠️ updateChangedCells: Cell count mismatch: current=${currentCells.length}, new=${newCells.length}. Some cells may not be updated correctly.`);
      }
      
      let changedCellCount = 0;
      
      // Create a mapping of IDs to cells for new cells
      const newCellsById = new Map();
      newCells.forEach((newCell, index) => {
        const cellId = newCell.id;
        if (cellId) {
          newCellsById.set(cellId, newCell);
        } else {
          console.log(`⚠️ updateChangedCells: New cell at index ${index} has no ID, skipping`);
        }
      });
      
      console.log(`🔍 updateChangedCells: Built mapping of ${newCellsById.size} new cells by ID`);
      
      // Compare each cell and update only those that changed using ID-based matching
      currentCells.forEach((currentCell, index) => {
        const currentCellId = currentCell.id;
        
        if (!currentCellId) {
          console.log(`⚠️ updateChangedCells: Current cell at index ${index} has no ID, skipping`);
          return;
        }
        
        let newCell = null;
        let matchType = 'none';
        
        if (newCellsById.has(currentCellId)) {
          // Found matching cell by ID
          newCell = newCellsById.get(currentCellId);
          matchType = 'id';
        } else {
          console.log(`⚠️ updateChangedCells: No matching new cell found for current cell ID "${currentCellId}"`);
          return;
        }
        
        if (newCell) {
          const currentContent = this.normalizeContent(currentCell.innerHTML);
          const newContent = this.normalizeContent(newCell.innerHTML);
          
          // Also compare the text content as a fallback
          const currentText = this.normalizeContent(currentCell.textContent || '');
          const newText = this.normalizeContent(newCell.textContent || '');
          
          const htmlChanged = currentContent !== newContent;
          const textChanged = currentText !== newText;
          
          if (htmlChanged || textChanged) {
            console.log(`🎯 updateChangedCells: Cell ${index} changed (${matchType} match), updating content`);
            console.log(`   updateChangedCells: Matched by ID: "${currentCellId}"`);
            console.log(`   updateChangedCells: Old HTML: "${currentContent}"`);
            console.log(`   updateChangedCells: New HTML: "${newContent}"`);
            console.log(`   updateChangedCells: Old Text: "${currentText}"`);
            console.log(`   updateChangedCells: New Text: "${newText}"`);
            console.log(`   updateChangedCells: Change type: ${htmlChanged ? 'HTML' : 'Text only'}`);
            
            // Update the cell content
            currentCell.innerHTML = newCell.innerHTML;
            
            // Add visual feedback for updated cells (for targeted cell updates)
            console.log(`✨ updateChangedCells: Cell ${index} updated, adding highlight`);
            currentCell.classList.add('cell-updated');
            setTimeout(() => {
              currentCell.classList.remove('cell-updated');
            }, 10000); // Remove highlight after 10 seconds
            
            changedCellCount++;
          }
        }
      });

      console.log(`✅ updateChangedCells: Updated ${changedCellCount} cells with targeted updates`);
      
      // Apply proper cell visibility after updates if we have the table name
      if (tableName) {
        this.hideCellsBasedOnCurrentDisplay(currentRowElement, tableName);
      }
      
      // If no cells changed but we got an update, there might be background color changes 
      // or other styling differences that we should ignore for targeted updates
      if (changedCellCount === 0) {
        console.log('ℹ️ updateChangedCells: No content cells changed - likely just styling differences (background colors, etc.)');
        console.log('   updateChangedCells: Skipping update to avoid unnecessary highlights');
        // Don't update anything if only styling changed
        return 0;
      }
      
      // Handle case where new row has more cells than current (shouldn't happen normally)
      if (newCells.length > currentCells.length) {
        console.log('⚠️ updateChangedCells: New row has more cells, perhaps you have two windows open?');

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
          console.log(`✨ highlightExtendedFilterCells: Cell ${index} contains ExtendedFilter data`);
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
          const changedCells = this.updateChangedCells(rowElement, newRowData.html, 'new_row', [], tableName);
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
              console.log(`✨ handleNewRows: New row added with id ${rowId}`);
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
              console.log(`✨ handleNewRows: 2 New row added with id ${newElement.id}`);
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
      console.log("🔄handleDataInvalidation: Handling data invalidation:", data);
      console.log("🔄handleDataInvalidation: Triggered by:", data.triggered_by);
      
      // Track that we're handling data invalidation to prevent legacy system conflicts
      this.lastDataInvalidation = Date.now();
      
      // Initialize circuit breaker to prevent infinite loops
      if (!this.refreshAttempts) {
        this.refreshAttempts = new Map();
      }
      
      // Process each affected relationship that needs updating
      if (data.affected_relationships && Array.isArray(data.affected_relationships)) {
        data.affected_relationships.forEach(relationship => {
          console.log(`📋handleDataInvalidation: Processing invalidation for relationship:`, relationship);
          const tableName = relationship.table || relationship.table_name;
          const affectedIds = relationship.ids || relationship.affected_ids || [];
          const operation = relationship.operation;
          const reason = relationship.reason;

          console.log(`🔄handleDataInvalidation: Table: ${tableName}, affected IDs:`, affectedIds);
          console.log(`🔄handleDataInvalidation: Operation: ${operation}, Reason: ${reason}`);

          // Create a unique key for this refresh attempt
          const refreshKey = `${tableName}_${affectedIds.join(',')}_${operation}_${reason}`;
          const now = Date.now();
          
          // Check if we've attempted this refresh recently (within 10 seconds)
          if (this.refreshAttempts.has(refreshKey)) {
            const lastAttempt = this.refreshAttempts.get(refreshKey);
            if (now - lastAttempt < 3000) {
              console.log(`🚫 handleDataInvalidation: Skipping refresh - attempted too recently for ${refreshKey}`);
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
          console.log("🔄handleDataInvalidation: calling refreshTableWithContext with invalidationContext: ", invalidationContext);
          this.refreshTableWithContext(tableName, affectedIds, invalidationContext);
        });
      } else {
        console.log("⚠️ 🔄handleDataInvalidation: No affected_relationships found in data:", data);
      }
      
      // Handle select box updates based on the trigger model
      if (data.triggered_by) {
        console.log("🔄handleDataInvalidation: calling handleSelectBoxUpdates Triggered by:", data.triggered_by);
        this.handleSelectBoxUpdates(data.triggered_by, data.affected_relationships);
      } else {
        console.log("⚠️ 🔄handleDataInvalidation: No triggered_by found in data:", data);
      }
    },

    handleSelectBoxUpdates(triggeredBy, affectedRelationships) {
      console.log("🔄 handleSelectBoxUpdates: Handling select box updates for triggered_by:", triggeredBy);
      console.log("🔄 handleSelectBoxUpdates: Affected relationships:", affectedRelationships);
      
      // Extract trigger information based on operation type
      let triggerTable, triggerObjectIds, operation;
      
      if (triggeredBy.operation === 'new_group') {
        triggerTable = 'Group';
        triggerObjectIds = [triggeredBy.group_id];
        operation = 'create';
        console.log(`🔄 handleSelectBoxUpdates: Handling new_group operation - Group ID ${triggerObjectIds[0]}`);
      } else if (triggeredBy.operation === 'create_tutorial_schedules') {
        // For tutorial schedule creation, we need to handle multiple affected entities
        console.log(`🔄 handleSelectBoxUpdates: Handling create_tutorial_schedules operation`);
        
        // Handle updates for Person (both tutor and students)
        if (triggeredBy.tutor_id) {
          this.handleCreateTutorialSchedulesUpdates('Person', [triggeredBy.tutor_id], 'update', affectedRelationships);
        }
        if (triggeredBy.student_ids && triggeredBy.student_ids.length > 0) {
          this.handleCreateTutorialSchedulesUpdates('Person', triggeredBy.student_ids, 'update', affectedRelationships);
        }
        
        // Handle updates for Course
        if (triggeredBy.course_id) {
          this.handleCreateTutorialSchedulesUpdates('Course', [triggeredBy.course_id], 'update', affectedRelationships);
        }
        
        // Handle creation for TutorialSchedule and Tutorial
        if (triggeredBy.tutorial_schedule_ids && triggeredBy.tutorial_schedule_ids.length > 0) {
          this.handleCreateTutorialSchedulesUpdates('TutorialSchedule', triggeredBy.tutorial_schedule_ids, 'create', affectedRelationships);
        }
        if (triggeredBy.tutorial_ids && triggeredBy.tutorial_ids.length > 0) {
          this.handleCreateTutorialSchedulesUpdates('Tutorial', triggeredBy.tutorial_ids, 'create', affectedRelationships);
        }
        
        // Continue with edit page updates only (no external filter updates for tutorial creation)
        if (triggeredBy.tutor_id) {
          this.handleEditPageSelectBoxUpdates('Person', triggeredBy.tutor_id);
        }
        if (triggeredBy.student_ids && triggeredBy.student_ids.length > 0) {
          triggeredBy.student_ids.forEach(studentId => {
            this.handleEditPageSelectBoxUpdates('Person', studentId);
          });
        }
        return; // Exit early since we handled everything
      } else if (triggeredBy.operation === 'delete' && triggeredBy.ids) {
        triggerTable = triggeredBy.table;
        triggerObjectIds = Array.isArray(triggeredBy.ids) ? triggeredBy.ids : [triggeredBy.ids];
        operation = 'delete';
        console.log(`🔄 handleSelectBoxUpdates: Handling delete operation - ${triggerTable} IDs ${triggerObjectIds.join(', ')}`);
      } else {
        triggerTable = triggeredBy.table;
        triggerObjectIds = [triggeredBy.object_id];
        operation = triggeredBy.operation;
      }

      console.log(`🔄 handleSelectBoxUpdates: Trigger details: table=${triggerTable}, objectIds=${triggerObjectIds}, operation=${operation}`);

      // Handle create/delete operations for external filter select boxes
      if (operation === 'new_group' || operation === 'create' || operation === 'delete') {
        triggerObjectIds.forEach(objectId => {
          this.handleExternalFilterCreateDelete(triggerTable, objectId, operation, affectedRelationships);
        });
      }

      // Dynamic discovery: Find all external filter select elements that need updating
      // Look for elements with both 'external_filter_argument_selection' and '{triggerTable}_select' classes
      const selectorQuery = `.external_filter_argument_selection.${triggerTable}_select`;
      const affectedSelects = document.querySelectorAll(selectorQuery);
      
      console.log(`🔄 handleSelectBoxUpdates: Found ${affectedSelects.length} external filter selects for ${triggerTable} using query: ${selectorQuery}`);
      
      affectedSelects.forEach(selectElement => {
        console.log(`🔄 handleSelectBoxUpdates: Processing external filter select: ${selectElement.id}`);
        
        // Parse the ID format: argument_selection_#{class_name}_#{filter_id}_#{element_id}
        // Example: argument_selection_Person_5_0 -> class_name=Person, filter_id=5, element_id=0
        const match = selectElement.id.match(/^argument_selection_(\w+)_(\d+)_(\d+)$/);
        if (match) {
          const className = match[1];
          const filterId = parseInt(match[2]);
          const elementId = parseInt(match[3]);
          
          console.log(`🔄 handleSelectBoxUpdates: Parsed select ID - className: ${className}, filterId: ${filterId}, elementId: ${elementId}`);
          
          // Update this specific external filter select for each trigger object
          triggerObjectIds.forEach(objectId => {
            this.updateExternalFilterSelect(selectElement, className, filterId, elementId, triggerTable, objectId);
          });
        } else {
          console.log(`⚠️ handleSelectBoxUpdates: Could not parse select element ID: ${selectElement.id}`);
        }
      });
      
      // Handle edit page select box updates
      triggerObjectIds.forEach(objectId => {
        this.handleEditPageSelectBoxUpdates(triggerTable, objectId);
      });
    },

    handleCreateTutorialSchedulesUpdates(tableName, objectIds, operation, affectedRelationships) {
      console.log(`🔄 handleCreateTutorialSchedulesUpdates: Handling ${operation} for ${tableName} IDs: ${objectIds.join(', ')}`);
      
      // For tutorial schedule creation, we mainly need to update existing rows, not add/remove options from selects
      // The focus should be on refreshing the data in search tables
      
      objectIds.forEach(objectId => {
        // Handle edit page select box updates for this table/ID
        this.handleEditPageSelectBoxUpdates(tableName, objectId);
      });
      
      console.log(`✅ handleCreateTutorialSchedulesUpdates: Completed updates for ${tableName}`);
    },

    handleExternalFilterCreateDelete(triggerTable, triggerObjectId, operation, affectedRelationships) {
      console.log(`🔄 handleExternalFilterCreateDelete: Handling ${operation} for ${triggerTable} ID ${triggerObjectId}`);
      
      // For Group creation, we need to be more selective about which select boxes to update
      if (triggerTable === 'Group' && (operation === 'new_group' || operation === 'create')) {
        console.log(`🔄 handleExternalFilterCreateDelete: Special handling for Group creation`);
        this.handleGroupCreationForExternalFilters(triggerObjectId, affectedRelationships);
        return;
      }
      
      // Find all external filter select boxes that display options from the trigger table
      const selectorQuery = `.external_filter_argument_selection.${triggerTable}_select`;
      const affectedSelects = document.querySelectorAll(selectorQuery);
      
      console.log(`🔄 handleExternalFilterCreateDelete: Found ${affectedSelects.length} external filter selects for ${triggerTable}`);
      
      affectedSelects.forEach(selectElement => {
        console.log(`🔄 handleExternalFilterCreateDelete: Processing select ${selectElement.id} for ${operation}`);
        
        if (operation === 'new_group' || operation === 'create') {
          // Add new option to select box alphabetically
          this.addOptionToSelectAlphabetically(selectElement, triggerObjectId, triggerTable);
        } else if (operation === 'delete') {
          // Remove option from select box
          this.removeOptionFromSelect(selectElement, triggerObjectId);
        }
      });
    },

    handleGroupCreationForExternalFilters(groupId, affectedRelationships) {
      console.log(`🔄 handleGroupCreationForExternalFilters: Handling Group creation ID ${groupId}`);
      console.log(`🔄 handleGroupCreationForExternalFilters: Affected relationships:`, affectedRelationships);
      
      // Determine what type of group was created by examining the affected relationships
      let groupMemberType = null;
      
      // Look for GroupMembership creation relationships to determine the member type
      const groupMembershipRelation = affectedRelationships?.find(rel => 
        rel.table && rel.table.startsWith('Group') && rel.operation === 'create'
      );
      
      if (groupMembershipRelation) {
        // Extract member type from table name like "GroupLecture" -> "Lecture"
        const match = groupMembershipRelation.table.match(/^Group(.+)$/);
        if (match) {
          groupMemberType = match[1];
          console.log(`🔍 handleGroupCreationForExternalFilters: Detected group member type: ${groupMemberType}`);
        }
      }
      
      // If we couldn't determine the member type, this might be an empty group
      // In that case, we should be very conservative about updates
      if (!groupMemberType) {
        console.log(`⚠️ handleGroupCreationForExternalFilters: Could not determine group member type - skipping external filter updates`);
        return;
      }
      
      // Only update external filter select boxes that are specifically for Groups containing this member type
      // Look for pattern: external_filter_argument_selection Group_select Group_{MemberType}_select
      const specificGroupFilterQuery = `.external_filter_argument_selection.Group_select.Group_${groupMemberType}_select`;
      const specificGroupFilterSelects = document.querySelectorAll(specificGroupFilterQuery);
      
      console.log(`🔄 handleGroupCreationForExternalFilters: Looking for specific Group filters with query: ${specificGroupFilterQuery}`);
      console.log(`🔄 handleGroupCreationForExternalFilters: Found ${specificGroupFilterSelects.length} specific Group filter selects`);
      
      specificGroupFilterSelects.forEach(selectElement => {
        console.log(`✅ handleGroupCreationForExternalFilters: Updating select ${selectElement.id} for Group of ${groupMemberType}`);
        this.addOptionToSelectAlphabetically(selectElement, groupId, 'Group');
      });
      
      // Also handle the general Group_Group_select case (Groups that contain Groups)
      // But only if the member type is actually "Group"
      if (groupMemberType === 'Group') {
        const groupGroupFilterSelects = document.querySelectorAll('.external_filter_argument_selection.Group_select.Group_Group_select');
        console.log(`🔄 handleGroupCreationForExternalFilters: Found ${groupGroupFilterSelects.length} Group-to-Group filter selects`);
        
        groupGroupFilterSelects.forEach(selectElement => {
          console.log(`✅ handleGroupCreationForExternalFilters: Updating Group-to-Group select ${selectElement.id}`);
          this.addOptionToSelectAlphabetically(selectElement, groupId, 'Group');
        });
      }
    },

    addOptionToSelectAlphabetically(selectElement, objectId, tableName) {
      console.log(`🔄 addOptionToSelectAlphabetically: Adding option ${objectId} to ${selectElement.id}`);
      
      // First, get the display name for this object using the SearchController.GetShortField method
      this.getDisplayNameForObject(objectId, tableName)
        .then(displayName => {
          if (!displayName) {
            console.log(`⚠️ addOptionToSelectAlphabetically: No display name found for ${tableName} ID ${objectId}`);
            return;
          }
          
          console.log(`✅ addOptionToSelectAlphabetically: Got display name "${displayName}" for ${tableName} ID ${objectId}`);
          
          // Check if option already exists
          const existingOption = selectElement.querySelector(`option[value="${objectId}"]`);
          if (existingOption) {
            console.log(`⚠️ addOptionToSelectAlphabetically: Option ${objectId} already exists in ${selectElement.id}`);
            // Update the text in case it changed
            existingOption.textContent = displayName;
            return;
          }
          
          // Create new option element
          const newOption = document.createElement('option');
          newOption.value = objectId;
          newOption.textContent = displayName;
          
          // Copy style from the first visible option to maintain consistency
          const options = Array.from(selectElement.options);
          const firstVisibleOption = options.find(option => option.style.display !== 'none' && option.value !== '-1');
          if (firstVisibleOption) {
            // Copy the style from the first visible option
            newOption.style.cssText = firstVisibleOption.style.cssText;
            console.log(`✅ addOptionToSelectAlphabetically: Copied style "${newOption.style.cssText}" from existing option`);
          } else {
            // Fallback to default style if no visible options found
            newOption.style.direction = 'rtl';
            console.log(`⚠️ addOptionToSelectAlphabetically: No visible options found, using default style`);
          }
          
          // Find the correct alphabetical position (skip hidden options)
          const visibleOptions = options.filter(option => option.style.display !== 'none' && option.value !== '-1');
          let insertIndex = options.length; // Default to end
          
          for (let i = 0; i < visibleOptions.length; i++) {
            // Compare display names alphabetically (case-insensitive)
            if (displayName.toLowerCase() < visibleOptions[i].textContent.toLowerCase()) {
              // Find the actual index in the full options array
              insertIndex = options.indexOf(visibleOptions[i]);
              break;
            }
          }
          
          // Insert the option at the correct position
          if (insertIndex >= options.length) {
            selectElement.appendChild(newOption);
          } else {
            selectElement.insertBefore(newOption, options[insertIndex]);
          }
          
          console.log(`✅ addOptionToSelectAlphabetically: Added option "${displayName}" (ID ${objectId}) at position ${insertIndex} in ${selectElement.id}`);
        })
        .catch(error => {
          console.log(`❌ addOptionToSelectAlphabetically: Failed to get display name for ${tableName} ID ${objectId}:`, error);
        });
    },

    removeOptionFromSelect(selectElement, objectId) {
      console.log(`🔄 removeOptionFromSelect: Removing option ${objectId} from ${selectElement.id}`);
      
      const optionToRemove = selectElement.querySelector(`option[value="${objectId}"]`);
      if (optionToRemove) {
        const optionText = optionToRemove.textContent;
        optionToRemove.remove();
        console.log(`✅ removeOptionFromSelect: Removed option "${optionText}" (ID ${objectId}) from ${selectElement.id}`);
        
        // If this was the selected option, reset to default
        if (selectElement.value === objectId.toString()) {
          selectElement.selectedIndex = 0;
          console.log(`🔄 removeOptionFromSelect: Reset selection to first option in ${selectElement.id}`);
        }
      } else {
        console.log(`⚠️ removeOptionFromSelect: Option ${objectId} not found in ${selectElement.id}`);
      }
    },

    getDisplayNameForObject(objectId, tableName) {
      console.log(`🔄 getDisplayNameForObject: Getting display name for ${tableName} ID ${objectId}`);
      
      // Make AJAX request to get the display name using SearchController.GetShortField
      const formData = new FormData();
      formData.append('class_name', tableName);
      formData.append('object_id', objectId);
      
      // Get CSRF token
      const csrfTokenElement = document.querySelector('meta[name="csrf-token"]');
      if (!csrfTokenElement) {
        console.log(`⚠️ getDisplayNameForObject: Cannot find CSRF token - skipping`);
        return Promise.reject('No CSRF token');
      }
      
      return fetch('/welcome/get_object_display_name', {
        method: 'POST',
        headers: {
          'X-CSRF-Token': csrfTokenElement.getAttribute('content'),
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
        console.log(`✅ getDisplayNameForObject: Received display name data:`, data);
        return data.display_name;
      });
    },

    updateExternalFilterSelect(selectElement, className, filterId, elementId, triggerTable, triggerObjectId) {
      console.log(`🔄 updateExternalFilterSelect: Updating select ${selectElement.id} for ${className} filter ${filterId}, element ${elementId}`);
      
      // Make AJAX request to get updated external filter element
      const formData = new FormData();
      formData.append('class_name', className);
      formData.append('filter_id', filterId);
      formData.append('element_id', elementId);
      formData.append('trigger_table', triggerTable);
      formData.append('trigger_object_id', triggerObjectId);
      
      // Get CSRF token
      const csrfTokenElement = document.querySelector('meta[name="csrf-token"]');
      if (!csrfTokenElement) {
        console.log(`⚠️ updateExternalFilterSelect: Cannot find CSRF token for ${selectElement.id} - skipping refresh`);
        return;
      }
      
      fetch('/welcome/refresh_external_filter_select', {
        method: 'POST',
        headers: {
          'X-CSRF-Token': csrfTokenElement.getAttribute('content'),
          'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData
      })
      .then(response => {
        if (!response.ok) {
          return response.text().then(text => {
            console.log(`❌ updateExternalFilterSelect: Server error for ${selectElement.id}: ${response.status} ${response.statusText}`);
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
          });
        }
        return response.json();
      })
      .then(data => {
        console.log(`✅ updateExternalFilterSelect: Received updated options for ${selectElement.id}:`, data);
        
        // Find the specific option that corresponds to the trigger object
        if (data.updated_option && data.updated_option.id == triggerObjectId) {
          const updatedOption = data.updated_option;
          
          // Find the option element in the select
          const optionElement = selectElement.querySelector(`option[value="${updatedOption.id}"]`);
          if (optionElement) {
            // Update the option's text content
            optionElement.textContent = updatedOption.name;
            console.log(`✅ updateExternalFilterSelect: Updated option ${updatedOption.id} to "${updatedOption.name}" in ${selectElement.id}`);
          } else {
            console.log(`⚠️ updateExternalFilterSelect: Option ${updatedOption.id} not found in ${selectElement.id} - may need full refresh`);
            // If the option doesn't exist, refresh all options
            this.refreshAllOptionsInSelect(selectElement, data.all_options);
          }
        } else if (data.all_options) {
          // Refresh all options if no specific update was provided
          this.refreshAllOptionsInSelect(selectElement, data.all_options);
        }
      })
      .catch(error => {
        console.log(`❌ updateExternalFilterSelect: Failed to refresh ${selectElement.id}:`, error);
      });
    },

    refreshAllOptionsInSelect(selectElement, newOptions) {
      console.log(`🔄 refreshAllOptionsInSelect: Refreshing all options in ${selectElement.id}`);
      
      // Store the current selected value
      const currentValue = selectElement.value;
      
      // Get the style from the first visible option before clearing
      const options = Array.from(selectElement.options);
      const firstVisibleOption = options.find(option => option.style.display !== 'none' && option.value !== '-1');
      const optionStyle = firstVisibleOption ? firstVisibleOption.style.cssText : 'direction: rtl;';
      
      console.log(`🔄 refreshAllOptionsInSelect: Using style "${optionStyle}" for new options`);
      
      // Clear existing options
      selectElement.innerHTML = '';
      
      // Add new options
      newOptions.forEach(option => {
        const optionElement = document.createElement('option');
        optionElement.value = option.id;
        optionElement.textContent = option.name;
        optionElement.style.cssText = optionStyle;
        
        // Restore selection if this was the previously selected option
        if (option.id.toString() === currentValue) {
          optionElement.selected = true;
        }
        
        selectElement.appendChild(optionElement);
      });
      
      console.log(`✅ refreshAllOptionsInSelect: Added ${newOptions.length} options to ${selectElement.id}`);
    },

    handleEditPageSelectBoxUpdates(triggerTable, triggerObjectId) {
      console.log("🔄 handleEditPageSelectBoxUpdates: Handling edit page select box updates for:", triggerTable, "ID:", triggerObjectId);
            
      // Find all edit select boxes with the new format: edit_ModelClass_foreign_key_id
      // These should be refreshed when the triggerTable data changes
      const allSelectElements = document.querySelectorAll('select[id^="edit_"]');
      const selectElementsToUpdate = [];
      
      allSelectElements.forEach(selectElement => {
        const selectId = selectElement.id;
        
        // Parse the ID format: edit_ModelClass_foreign_key_id
        // Example: edit_Lecture_person_id -> ModelClass=Lecture, foreign_key=person_id
        const match = selectId.match(/^edit_(\w+)_(\w+_id)$/);
        if (match) {
          const modelClass = match[1];
          const foreignKey = match[2];
          const foreignClass = foreignKey.replace(/_id$/, '').replace(/^(\w)/, (m) => m.toUpperCase()); // person_id -> Person
          console.log(`🔄 handleEditPageSelectBoxUpdates: Found edit select box: ${selectId} (${modelClass} -> ${foreignClass}) with foreign key: ${foreignKey}`);

          // Check if this select box should be updated based on the trigger table
          if (foreignClass === triggerTable) {
            selectElementsToUpdate.push({
              element: selectElement,
              selectId: selectId,
              modelClass: modelClass,
              foreignKey: foreignKey,
              foreignClass: foreignClass
            });
          }
        }
      });
      
      console.log(`🔄 handleEditPageSelectBoxUpdates: Found ${selectElementsToUpdate.length} select boxes to update for ${triggerTable}`);

      selectElementsToUpdate.forEach(selectInfo => {
        console.log(`🔄 handleEditPageSelectBoxUpdates: Found edit page select box: ${selectInfo.selectId} (${selectInfo.modelClass} -> ${selectInfo.foreignClass})`);

        // Store the current selected value
        const currentValue = selectInfo.element.value;
        
        // Refresh the select box options by making an AJAX call
        this.refreshEditSelectBox(selectInfo.element, selectInfo.modelClass, selectInfo.foreignKey, selectInfo.foreignClass, currentValue);
      });
    },

    refreshEditSelectBox(selectElement, modelClass, foreignKey, foreignClass, currentValue) {
      const selectId = selectElement.id;      
      console.log(`🔄 refreshEditSelectBox: Refreshing edit select box: ${selectId}, modelClass: ${modelClass}, foreignKey: ${foreignKey}, foreignClass: ${foreignClass}, currentValue: ${currentValue}`);
            
      
      
      // Validate that we have all required data
      if (!modelClass || !foreignKey || !foreignClass) {
        console.log(`⚠️ refreshEditSelectBox: Missing required data for ${selectId} (modelClass: ${modelClass}, foreignKey: ${foreignKey}, foreignClass: ${foreignClass}) - skipping refresh`);
        return;
      }

      console.log(`🔄 refreshEditSelectBox: Making AJAX request to refresh ${selectId} for ${modelClass} Foreign Key ID ${currentValue}`);

      // Make AJAX request to get updated select options
      const formData = new FormData();
      formData.append('model_class', modelClass);
      formData.append('foreign_key', foreignKey);
      formData.append('foreign_class', foreignClass);
      formData.append('current_value', currentValue);
      formData.append('select_element_id', selectId);
      
      // Get CSRF token with fallback
      const csrfTokenElement = document.querySelector('meta[name="csrf-token"]');
      if (!csrfTokenElement) {
        console.log(`⚠️ refreshEditSelectBox: Cannot find CSRF token for ${selectId} - skipping refresh`);
        return;
      }
      
      fetch('/welcome/refresh_edit_select', {
        method: 'POST',
        headers: {
          'X-CSRF-Token': csrfTokenElement.getAttribute('content'),
          'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData
      })
      .then(response => {
        if (!response.ok) {
          // Provide more detailed error information
          return response.text().then(text => {
            console.log(`❌ refreshEditSelectBox: Server error for ${selectId}: ${response.status} ${response.statusText}`);
            console.log(`❌ refreshEditSelectBox: Response body:`, text.substring(0, 500));
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
          });
        }
        return response.json();
      })
      .then(data => {
        console.log(`✅ refreshEditSelectBox: Received updated options for ${selectId}:`, data);

        // Validate user ID to prevent cross-user data contamination
        
        let expectedUserId = this.getCurrentUserId();

        
        if (data.user_id && expectedUserId && data.user_id.toString() !== expectedUserId.toString()) {
          console.warn(`🚫 refreshEditSelectBox: User ID mismatch! Expected ${expectedUserId}, received ${data.user_id}. Discarding response to prevent data mixing.`);
          return;
        }
        
        if (data.user_id && expectedUserId) {
          console.log(`✅ refreshEditSelectBox: User ID validated (${data.user_id}) - updating select options`);
        } else {
          console.log(`⚠️ refreshEditSelectBox: User ID validation skipped (server: ${data.user_id}, client: ${expectedUserId})`);
        }
        
        // Update the select box options
        this.updateSelectOptions(selectElement, data.options, currentValue);
      })
      .catch(error => {
        console.log(`❌ refreshEditSelectBox: Failed to refresh ${selectId}:`, error);
        console.log(`❌ refreshEditSelectBox: This error occurred while refreshing select for ${modelClass} with ${foreignClass} data`);
        console.log(`❌ refreshEditSelectBox: The select box will not be updated but functionality should continue normally`);
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
      console.log(`🔄 refreshTableWithContext: Processing ${tableName} with ${affectedRowIds.length} affected rows`);
      console.log(`🔄 refreshTableWithContext: Invalidation context:`, invalidationContext);
      
      const operation = invalidationContext.operation;
      const reason = invalidationContext.reason;
      
      // Ensure we have the search results div before proceeding
      const searchResultsDiv = document.getElementById(`search_results_${tableName}`);
      if (!searchResultsDiv) {
        console.log(`⚠️ refreshTableWithContext: No search results div found for table: ${tableName} - skipping refresh`);
        return;
      }
      
      // Two main scenarios:
      // (a) DELETE operations - remove rows from the table
      // (b) UPDATE operations - update existing rows with new data
      
      if (operation === 'delete' || this.isRowRemovalOperation(reason)) {
        console.log(`🗑️ refreshTableWithContext:Row removal operation detected for ${tableName}`);
        this.handleRowRemovals(tableName, affectedRowIds, invalidationContext);
        return;
      }
      
      // All other operations are row updates
      console.log(`🔄 refreshTableWithContext:Row update operation detected for ${tableName}`);
      this.handleRowUpdates(tableName, affectedRowIds, invalidationContext);
    },
    
    isRowRemovalOperation(reason) {
      // Determine if this operation should result in row removal
      const removalReasons = [
        'member_removed',
        'attendee_removed', 
        'group_member_removed',
        'tutorial_attendee_removed',
        'lecture_attendee_removed'
      ];
      return removalReasons.includes(reason);
    },
    
    handleRowRemovals(tableName, affectedRowIds, invalidationContext) {
      console.log(`�️ Handling row removals for ${tableName}: ${affectedRowIds.join(', ')}`);
      
      if (affectedRowIds.length === 0) {
        console.log(`ℹ️ No specific rows to remove from ${tableName}`);
        return;
      }
      
      this.removeTableRows(tableName, affectedRowIds, invalidationContext);
    },
    
    handleRowUpdates(tableName, affectedRowIds, invalidationContext) {
      console.log(`🔄 Handling row updates for ${tableName}: ${affectedRowIds.join(', ')}`);
      
      if (affectedRowIds.length === 0) {
        console.log(`ℹ️ No specific rows to update in ${tableName}`);
        return;
      }
      
      // Use targeted row updates for all update operations
      this.updateSpecificRows(tableName, affectedRowIds, invalidationContext);
    },

    updateSpecificRows(tableName, affectedRowIds, invalidationContext) {
      console.log(`🎯 updateSpecificRows: Updating specific rows in ${tableName}: ${affectedRowIds.join(', ')}`);
      
      // Get current user ID for validation
      let expectedUserId = this.getCurrentUserId();
      
      if (expectedUserId) {
        console.log(`🔍 updateSpecificRows: Expected user ID for validation: ${expectedUserId}`);
      } else {
        console.log(`⚠️ updateSpecificRows: Could not determine current user ID - skipping user validation`);
      }
      
      // Make AJAX request to fetch updated row data
      const params = new URLSearchParams();
      params.append('table_name', tableName);
      params.append('row_ids', affectedRowIds.join(','));
      params.append('action', 'fetch_rows');
      
      console.log(`🌐 updateSpecificRows: Fetching updated row data for ${tableName} rows: ${affectedRowIds.join(', ')}`);
      
      fetch(`/welcome/fetch_updated_rows?${params.toString()}`, {
        method: 'GET',
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      .then(response => {
        if (!response.ok) {
          console.log(`❌ updateSpecificRows: HTTP Error ${response.status}: ${response.statusText}`);
          response.text().then(text => {
            console.log(`❌ updateSpecificRows: Error response:`, text);
          });
          throw new Error(`updateSpecificRows: HTTP ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        console.log(`✅ updateSpecificRows: Received updated row data for ${tableName}`);
        
        // Validate user ID to prevent cross-user data contamination
        if (data.user_id && expectedUserId && data.user_id.toString() !== expectedUserId.toString()) {
          console.warn(`🚫 updateSpecificRows: User ID mismatch! Expected ${expectedUserId}, received ${data.user_id}. Discarding response.`);
          return;
        }
        
        if (data.user_id && expectedUserId) {
          console.log(`✅ updateSpecificRows: User ID validated (${data.user_id})`);
        }

        // Verify search results container exists
        const searchResultsDiv = document.getElementById(`search_results_${tableName}`);
        if (!searchResultsDiv) {
          console.log(`⚠️ updateSpecificRows: No search results div found for ${tableName} - skipping row updates`);
          return;
        }
        
        // Update each row using the improved cell matching system
        let totalUpdatedCells = 0;
        data.rows.forEach(rowData => {
          const rowElement = document.getElementById(`${rowData.id}_${tableName}`);
          if (rowElement && rowData.html) {
            console.log(`🔄 updateSpecificRows: Updating row ${rowData.id}_${tableName}`);
            const updatedCells = this.updateChangedCells(rowElement, rowData.html, 'ajax_update', [], tableName);
            totalUpdatedCells += updatedCells;
            console.log(`✅ updateSpecificRows: Updated ${updatedCells} cells in row ${rowData.id}_${tableName}`);
          } else {
            console.log(`⚠️ updateSpecificRows: Could not update row ${rowData.id}_${tableName} - element not found or no HTML provided`);
          }
        });

        console.log(`✅ updateSpecificRows: Total cells updated: ${totalUpdatedCells}`);
      })
      .catch(error => {
        console.log(`❌ updateSpecificRows: Failed to fetch/update rows for ${tableName}:`, error);
        
        // Add subtle visual indication that these rows were affected
        affectedRowIds.forEach(rowId => {
          const rowElement = document.getElementById(`${rowId}_${tableName}`);
          if (rowElement) {
            console.log(`🔄 updateSpecificRows: Adding visual indication for row ${rowId}_${tableName}`);
            rowElement.classList.add('row-involved');
            setTimeout(() => {
              rowElement.classList.remove('row-involved');
            }, 2000);
          }
        });
      });
    },
    
    getCurrentUserId() {
      // First try to get from the specific logged-in user ID field
      const loggedInUserElement = document.getElementById('logged_in_user_id');
      if (loggedInUserElement && loggedInUserElement.value) {
        return loggedInUserElement.value;
      }
      
      // Fallback to window/session storage if available
      if (window.current_user_id) {
        return window.current_user_id;
      }
      
      if (sessionStorage.getItem('current_user_id')) {
        return sessionStorage.getItem('current_user_id');
      }
      
      return null;
    },

    highlightAffectedRows(tableName, rowIds) {
      if (!rowIds || rowIds.length === 0) return;

      console.log(`✨ highlightAffectedRows: Checking for specific cell changes in ${tableName} for rows:`, rowIds);

      rowIds.forEach(rowId => {
        // Find the specific row using the standard ID pattern
        const rowElement = document.getElementById(`${rowId}_${tableName}`);
        
        if (rowElement) {
          console.log(`🔍 highlightAffectedRows: Found row ${rowId}_${tableName}, checking for changed cells`);
          
          // Check if any cells in this row have been marked as updated during the refresh
          const updatedCells = rowElement.querySelectorAll('.cell-updated');
          
          if (updatedCells.length > 0) {
            console.log(`✨ highlightAffectedRows: Found ${updatedCells.length} cells already marked as updated in row ${rowId}`);
            // The cells are already highlighted by the updateChangedCells method
            // No additional highlighting needed
          } else {
            console.log(`ℹ️ highlightAffectedRows: No cells marked as updated in row ${rowId} - this may be a new row or unchanged data`);

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
      console.log(`🔍 compareAndHighlightChanges: Comparing before/after values for ${tableName} rows:`, affectedRowIds);
      
      affectedRowIds.forEach(rowId => {
        const rowElement = document.getElementById(`${rowId}_${tableName}`);
        const beforeData = beforeRefreshData[rowId];
        
        console.log(`\n📊 compareAndHighlightChanges: === DETAILED COMPARISON FOR ROW ${rowId}_${tableName} ===`);
        
        if (rowElement && beforeData) {
          const afterCells = Array.from(rowElement.querySelectorAll('td'));
          let changedCellCount = 0;

          console.log(`🔍 compareAndHighlightChanges: Row has ${afterCells.length} cells, comparing with ${beforeData.length} before-cells`);

          afterCells.forEach((cell, cellIndex) => {
            const cellClasses = Array.from(cell.classList).join(', ');
            console.log(`\n🔍 compareAndHighlightChanges: Cell ${cellIndex} (classes: "${cellClasses}"):`);
            
            if (cellIndex < beforeData.length) {
              const beforeCell = beforeData[cellIndex];
              const afterInnerHTML = cell.innerHTML.trim();
              const afterTextContent = (cell.textContent || '').trim();
              
              // Normalize content for better comparison
              const beforeHTMLNorm = this.normalizeContent(beforeCell.innerHTML);
              const afterHTMLNorm = this.normalizeContent(afterInnerHTML);
              const beforeTextNorm = this.normalizeContent(beforeCell.textContent);
              const afterTextNorm = this.normalizeContent(afterTextContent);
              
              console.log(`compareAndHighlightChanges:   📋 BEFORE HTML: "${beforeCell.innerHTML}"`);
              console.log(`compareAndHighlightChanges:   📋 AFTER  HTML: "${afterInnerHTML}"`);
              console.log(`compareAndHighlightChanges:   📋 BEFORE TEXT: "${beforeCell.textContent}"`);
              console.log(`compareAndHighlightChanges:   📋 AFTER  TEXT: "${afterTextContent}"`);
              console.log(`compareAndHighlightChanges:   📋 BEFORE HTML (normalized): "${beforeHTMLNorm}"`);
              console.log(`compareAndHighlightChanges:   📋 AFTER  HTML (normalized): "${afterHTMLNorm}"`);
              console.log(`compareAndHighlightChanges:   📋 BEFORE TEXT (normalized): "${beforeTextNorm}"`);
              console.log(`compareAndHighlightChanges:   📋 AFTER  TEXT (normalized): "${afterTextNorm}"`);
              
              // Compare both HTML and text content to catch all types of changes
              const htmlChanged = beforeHTMLNorm !== afterHTMLNorm;
              const textChanged = beforeTextNorm !== afterTextNorm;
              
              if (htmlChanged || textChanged) {
                console.log(`   🎯 compareAndHighlightChanges: *** CELL ${cellIndex} CHANGED! ***`);
                console.log(`   🎯 compareAndHighlightChanges: HTML changed: ${htmlChanged}, Text changed: ${textChanged}`);

                // NOTE: Cell highlighting is now handled by updateChangedCells method
                // This method is only used for full table refresh comparison logging
                
                changedCellCount++;
              } else {
                console.log(`   ✅ compareAndHighlightChanges: Cell ${cellIndex} unchanged`);
              }
            } else {
              console.log(`   ⚠️ compareAndHighlightChanges: Cell ${cellIndex} has no corresponding before-data`);
            }
          });
          
          console.log(`\n📊 compareAndHighlightChanges: === SUMMARY FOR ROW ${rowId} ===`);
          if (changedCellCount > 0) {
            console.log(`✨ compareAndHighlightChanges: Highlighted ${changedCellCount} changed cells in row ${rowId}`);
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
            console.log(`⚠️ compareAndHighlightChanges: Could not find row element for comparison: ${rowId}_${tableName}`);
          }
          if (!beforeData) {
            console.log(`⚠️ compareAndHighlightChanges: No before-data captured for row: ${rowId}`);
          }
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
      console.log(`✨ attendee_added listener: Highlighting person row for ID: ${person_id}`);
      personRow.classList.add('row-updated');
      setTimeout(() => {
        personRow.classList.remove('row-updated');
      }, 1500);
    }
    
    // Add highlight effects to lecture rows
    lecture_ids.forEach(lectureId => {
      const lectureRow = document.getElementById(`${lectureId}_Lecture`);
      if (lectureRow) {
        console.log(`✨ attendee_added listener: Highlighting lecture row for ID: ${lectureId}`);
        lectureRow.classList.add('row-updated');
        setTimeout(() => {
          lectureRow.classList.remove('row-updated');
        }, 1500);
      }
    });
    
    console.log("✨ Applied visual highlights to attendee rows");
  });
});
