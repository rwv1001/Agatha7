import "@hotwired/turbo-rails"
import jquery from "jquery"
window.jQuery = window.$ = jquery;
import "controllers";

import "edit";
import "template";
import "search_ctl";
import "display_format";

import "group_filters";
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails


// override it



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

document.addEventListener('turbo:load', function () {
  const controller = document.body.getAttribute('data-controller');
  const action = document.body.getAttribute('data-action');

  // Run code only on the articles#index page
  if (controller === 'welcome' && action === 'index') {
    console.log('Articles index page loaded!');
    console.log("RWV commented out b");//on_load();
    jQuery('#select_height').val(jQuery('#dummy_select').height());
    jQuery('#format_height').val(jQuery('#dummy_format').height());
    jQuery('#format_width').val(jQuery('#dummy_format').width());
    jQuery('#format_narrow_width').val(jQuery('#dummy_format_narrow').width());
    jQuery('#fp_height').val(jQuery('#dummy_fp').height());
    jQuery('#fx_height').val(jQuery('#dummy_fx').height());
    content_end();
    jQuery('#content_div').hide();
    //jQuery('#two_column_div').hide();

    load_pages();
    jQuery('#disable_id').hide();
    jQuery(window).name = "main_window";
    jQuery.fn.down = function () {
      var el = this[0] && this[0].firstChild;
      while (el && el.nodeType != 1)
        el = el.nextSibling;
      return jQuery(el);
    };

    
    jQuery("#black_bar_separator_div").draggable({
      containment: "#two_column_div", // Ensure this is the correct selector
      axis: "x", // Restrict to horizontal dragging
    });

    jQuery("#black_bar_separator_div").on("dragstop", function (event, ui) {
      end_drag(); // Ensure end_drag is defined
    });
  }
});









