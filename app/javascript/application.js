import "@hotwired/turbo-rails"
import jquery from "jquery"
window.jQuery = window.$ = jquery;
import "controllers";

import "edit";
import "template";
import "search_ctl";
import "display_format";

import "group_filters";
import Rails from "@rails/ujs";
Rails.start();
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails


// override it
function getElementHeight(id) {
  const element = document.getElementById(id);
  if (!element) return undefined; // Return undefined if element not found
  const style = window.getComputedStyle(element);
  const paddingTop = parseFloat(style.paddingTop);
  const paddingBottom = parseFloat(style.paddingBottom);
  //console.log('getElementHeight: returns ' + (element.clientHeight - paddingTop - paddingBottom));
  //console.log('jQuery height returns ' + jQuery('#'+id).height());
  return element.clientHeight - paddingTop - paddingBottom;
}
function getWidth(id) {
  const element = document.getElementById(id);
  if (element) {
    const style = getComputedStyle(element);
    //console.log('getWidth: returns ' + parseFloat(style.width));
    //console.log('jQuery width returns ' + jQuery('#'+id).width());
    return parseFloat(style.width);
  }
  return undefined; // If element not found
}
window.getElementHeight = getElementHeight;
window.getWidth = getWidth;
function escapeHTML(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}
window.escapeHTML = escapeHTML;


const _oldGlobalEval = jquery.globalEval;

jquery.globalEval = function (data) {
  if (!data) return;
  const script = document.createElement("script");
  script.text = data;
  if (window._cspNonce) script.nonce = window._cspNonce;
  document.head.appendChild(script);
  document.head.removeChild(script);
};

console.log("Agatha application.js loaded");
document.addEventListener("hide_expand_button", () => {
  document.getElementById('expand_button_div').style.display = 'none';
  });
document.addEventListener('turbo:load', function () {
  document.getElementById('expand_button_div').style.display = 'none';
  const controller = document.body.getAttribute('data-controller');
  const action = document.body.getAttribute('data-action');



  // Run code only on the articles#index page
  if (controller === 'welcome' && action === 'index') {
    console.log('Articles index page loaded!');
    console.log("RWV commented out b");//on_load();
    document.getElementById('select_height').value = getElementHeight('dummy_select');
    document.getElementById('format_height').value = getElementHeight('dummy_format');
    document.getElementById('format_width').value = getWidth('dummy_format');
    document.getElementById('format_narrow_width').value = getWidth('dummy_format_narrow');
    document.getElementById('fp_height').value = getElementHeight('dummy_fp');
    document.getElementById('fx_height').value = getElementHeight('dummy_fx');
    
    document.getElementById('content_div').style.display = 'none';
    
    
    //document.getElementById('two_column_div').style.display = 'none';

    load_pages();
    content_end();
    document.getElementById('disable_id').style.display = 'none';
    jQuery(window).name = "main_window";
    jQuery.fn.down = function () {
      var el = this[0] && this[0].firstChild;
      while (el && el.nodeType != 1)
        el = el.nextSibling;
      return jQuery(el);
    };

const separator = document.getElementById('black_bar_separator_div');
const container = document.getElementById('two_column_div');

separator.addEventListener('mousedown', function(event) {
  event.preventDefault(); // Prevent text selection or other default behaviors
  
  const startingMouseX = event.clientX; // Mouse position at drag start
  const startingLeft = parseFloat(separator.style.left) || 0; // Current left position (default to 0 if unset)
  const containerWidth = container.clientWidth; // Container's inner width
  const separatorWidth = separator.offsetWidth; // Separator's total width

  console.log('Starting drag: startingLeft=', startingLeft, 'containerWidth=', containerWidth, 'separatorWidth=', separatorWidth);

  function onMouseMove(event) {
    const delta = event.clientX - startingMouseX; // Distance moved
    let newLeft = startingLeft + delta; // New position
    // Restrict position within container
    const maxLeft = containerWidth - separatorWidth;
    newLeft = Math.max(0, Math.min(maxLeft, newLeft));
    separator.style.left = `${newLeft}px`; // Update position
    console.log('Dragging: newLeft=', newLeft, 'maxLeft=', maxLeft);
  }

  function onMouseUp(event) {
    // Remove event listeners
    document.removeEventListener('mousemove', onMouseMove);
    document.removeEventListener('mouseup', onMouseUp);
    // Call your function when drag ends
    yourFunction();
  }

  // Add listeners to document to capture movement outside the div
  document.addEventListener('mousemove', onMouseMove);
  document.addEventListener('mouseup', onMouseUp);
});

// Define your function to be called when drag ends
function yourFunction() {
  console.log('Drag ended!'); // Replace with your desired functionality
}


  }
});









