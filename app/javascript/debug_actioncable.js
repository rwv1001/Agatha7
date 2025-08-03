// Debug ActionCable for different browsers
console.log("Debug ActionCable script loaded");

// Check if the browser supports ES6 modules and imports
console.log("Testing browser capabilities:");
console.log("- ES6 modules:", typeof window.import !== 'undefined' || 'import' in window);
console.log("- WebSocket support:", 'WebSocket' in window);
console.log("- ActionCable consumer (import):", typeof consumer !== 'undefined');
console.log("- ActionCable consumer (global):", typeof window.actionCableConsumer !== 'undefined');
console.log("- Rails ActionCable:", typeof window.ActionCable !== 'undefined');

// Test WebSocket connection manually
function testWebSocket() {
  try {
    const wsUrl = `ws://${window.location.host}/cable`;
    console.log("Attempting WebSocket connection to:", wsUrl);
    
    const ws = new WebSocket(wsUrl);
    
    ws.onopen = function() {
      console.log("✅ WebSocket connection opened successfully");
      ws.close();
    };
    
    ws.onerror = function(error) {
      console.error("❌ WebSocket error:", error);
    };
    
    ws.onclose = function(event) {
      console.log("WebSocket closed:", event.code, event.reason);
    };
    
  } catch (error) {
    console.error("❌ WebSocket test failed:", error);
  }
}

// Test ActionCable consumer availability
function testActionCableConsumer() {
  try {
    // Try different ways to access consumer
    let consumerObj = null;
    
    if (typeof consumer !== 'undefined') {
      consumerObj = consumer;
      console.log("✅ ActionCable consumer available via ES6 import:", consumer);
    } else if (window.actionCableConsumer) {
      consumerObj = window.actionCableConsumer;
      console.log("✅ ActionCable consumer available via global window.actionCableConsumer:", window.actionCableConsumer);
    } else if (window.consumer) {
      consumerObj = window.consumer;
      console.log("✅ ActionCable consumer available via window.consumer:", window.consumer);
    } else if (window.ActionCable) {
      // Fallback: create consumer manually
      consumerObj = window.ActionCable.createConsumer();
      console.log("✅ ActionCable consumer created manually via window.ActionCable:", consumerObj);
    } else {
      console.error("❌ ActionCable consumer not available");
      console.log("Available globals with 'cable':", Object.keys(window).filter(k => k.toLowerCase().includes('cable')));
      console.log("Available globals with 'action':", Object.keys(window).filter(k => k.toLowerCase().includes('action')));
      return false;
    }
    
    // Try to create a test subscription
    const testChannel = consumerObj.subscriptions.create("SearchTableChannel", {
      connected() {
        console.log("✅ Test ActionCable connection successful");
        setTimeout(() => this.unsubscribe(), 1000);
      },
      
      disconnected() {
        console.log("Test ActionCable connection closed");
      },
      
      rejected() {
        console.error("❌ Test ActionCable connection rejected");
      }
    });
    
    return true;
  } catch (error) {
    console.error("❌ ActionCable consumer test failed:", error);
    return false;
  }
}

// Check browser and version
function getBrowserInfo() {
  const userAgent = navigator.userAgent;
  let browser = "Unknown";
  
  if (userAgent.indexOf("Chrome") > -1) {
    browser = "Chrome";
  } else if (userAgent.indexOf("Firefox") > -1) {
    browser = "Firefox";
  } else if (userAgent.indexOf("Edge") > -1) {
    browser = "Edge";
  } else if (userAgent.indexOf("Safari") > -1) {
    browser = "Safari";
  }
  
  console.log("Browser:", browser);
  console.log("User Agent:", userAgent);
  return browser;
}

// Run all tests
function runDebugTests() {
  console.log("=== ActionCable Browser Debug Tests ===");
  getBrowserInfo();
  testWebSocket();
  
  // Wait a bit for WebSocket test, then test ActionCable
  setTimeout(() => {
    testActionCableConsumer();
  }, 1000);
}

// Export for global access
window.debugActionCable = {
  runTests: runDebugTests,
  testWebSocket: testWebSocket,
  testActionCable: testActionCableConsumer
};

// Auto-run on load
document.addEventListener('DOMContentLoaded', function() {
  console.log("DOM loaded, running ActionCable debug tests...");
  runDebugTests();
});
