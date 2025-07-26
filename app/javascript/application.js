import "@hotwired/turbo-rails"
import jquery from "jquery"
import "controllers";

import "edit";    
import "template";
import "search_ctl";
import "display_format";
    
import "group_filters";   
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails


// override it

window.jQuery = window.$ = jquery;

const _oldGlobalEval = jquery.globalEval;

jquery.globalEval = function(data) {
  if (!data) return;
  const script = document.createElement("script");
  script.text = data;
  if (window._cspNonce) script.nonce = window._cspNonce;
  document.head.appendChild(script);
  document.head.removeChild(script);
};

console.log("Agatha application.js loaded");





   



