// Rich Text Editor for AgathaEmail body field
// Simple contenteditable approach that preserves HTML exactly

function initializeRichTextEditor() {
  console.log("🖋️ Initializing simple rich text editor...");
  
  // Look for the body textarea field
  const bodyTextarea = document.querySelector('textarea[name*="body"], #edit_body, textarea[id*="body"]');
  
  if (!bodyTextarea) {
    console.log("ℹ️ No body textarea found, skipping rich text editor initialization");
    return;
  }
  
  // Check if editor is already initialized for this textarea
  if (bodyTextarea.dataset.simpleEditorInitialized === 'true') {
    console.log("ℹ️ Rich text editor already initialized for this textarea");
    return;
  }
  
  console.log("✅ Found body textarea:", bodyTextarea.id || bodyTextarea.name);
  
  // Mark as initialized to prevent duplicate initialization
  bodyTextarea.dataset.simpleEditorInitialized = 'true';
  
  // Create a simple contenteditable div
  const editorDiv = document.createElement('div');
  editorDiv.id = 'simple-editor-' + (bodyTextarea.id || 'body');
  editorDiv.contentEditable = true;
  editorDiv.style.cssText = `
    min-height: 250px;
    width: 100%;
    max-width: 800px;
    padding: 15px;
    border: 1px solid #ccc;
    border-radius: 4px;
    background: white;
    font-family: inherit;
    font-size: inherit;
    line-height: 1.4;
    overflow-y: auto;
  `;
  
  // Set the initial content exactly as it is in the textarea
  const initialContent = bodyTextarea.value;
  editorDiv.innerHTML = initialContent;
  console.log("📝 Set initial content:", initialContent);
  
  // Hide the original textarea but keep it for form submission
  bodyTextarea.style.display = 'none';
  
  // Insert the editor div after the textarea
  bodyTextarea.parentNode.insertBefore(editorDiv, bodyTextarea.nextSibling);
  
  // Add basic formatting toolbar
  const toolbar = document.createElement('div');
  toolbar.style.cssText = `
    margin-bottom: 5px;
    padding: 5px;
    border: 1px solid #ccc;
    border-bottom: none;
    border-radius: 4px 4px 0 0;
    background: #f8f9fa;
  `;
  
  // Add formatting buttons
  const buttons = [
    { command: 'bold', text: 'B', title: 'Bold' },
    { command: 'italic', text: 'I', title: 'Italic' },
    { command: 'underline', text: 'U', title: 'Underline' }
  ];
  
  buttons.forEach(btn => {
    const button = document.createElement('button');
    button.type = 'button';
    button.innerHTML = btn.text;
    button.title = btn.title;
    button.style.cssText = `
      margin-right: 5px;
      padding: 5px 10px;
      border: 1px solid #ddd;
      background: white;
      cursor: pointer;
      font-weight: ${btn.command === 'bold' ? 'bold' : 'normal'};
      font-style: ${btn.command === 'italic' ? 'italic' : 'normal'};
      text-decoration: ${btn.command === 'underline' ? 'underline' : 'none'};
    `;
    
    button.addEventListener('click', function(e) {
      e.preventDefault();
      document.execCommand(btn.command, false, null);
      editorDiv.focus();
    });
    
    toolbar.appendChild(button);
  });
  
  // Insert toolbar before the editor
  bodyTextarea.parentNode.insertBefore(toolbar, editorDiv);
  
  // Sync content back to textarea on input
  editorDiv.addEventListener('input', function() {
    bodyTextarea.value = editorDiv.innerHTML;
    console.log("📝 Updated textarea:", editorDiv.innerHTML);
  });
  
  // Sync on blur and handle auto-save
  editorDiv.addEventListener('blur', function() {
    const content = editorDiv.innerHTML;
    bodyTextarea.value = content;
    console.log("📝 Editor lost focus, syncing content");
    
    // Update hidden form fields for auto-save
    try {
      const field_name_obj = document.getElementById('field_name');
      const field_value_obj = document.getElementById('field_value');
      const field_data_type_obj = document.getElementById('field_data_type');
      const closing_flag_obj = document.getElementById('closing_flag');

      if (field_name_obj) field_name_obj.value = "body";
      if (field_data_type_obj) field_data_type_obj.value = "text";
      if (field_value_obj) field_value_obj.value = content;
      if (closing_flag_obj) closing_flag_obj.value = "0";
      
      console.log("📝 Updated hidden form fields for auto-save");
      
      // Gentle AJAX save
      const form = document.getElementById('update_form');
      if (form) {
        const formData = new FormData(form);
        
        fetch(form.action, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
            'X-Requested-With': 'XMLHttpRequest'
          },
          body: formData
        })
        .then(response => {
          if (response.ok) {
            console.log("✅ Content saved successfully via AJAX");
          }
        })
        .catch(error => {
          console.log("❌ Error saving content:", error);
        });
      }
      
    } catch (error) {
      console.log("❌ Error in blur handler:", error);
    }
  });
  
  // Sync on form submission
  const form = bodyTextarea.closest('form');
  if (form) {
    form.addEventListener('submit', function() {
      bodyTextarea.value = editorDiv.innerHTML;
      console.log("📤 Synced content on form submission");
    });
  }
  
  // Store references globally for debugging
  window.simpleEditor = editorDiv;
  window.bodyTextarea = bodyTextarea;
  
  console.log("✅ Simple rich text editor initialized successfully");
  console.log("🔧 Editor preserves HTML exactly as provided");
  console.log("🛠️ Available formatting: bold, italic, underline");
  
  return editorDiv;
}

// Global flag to prevent multiple initializations
let richTextEditorInitialized = false;

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
  if (!richTextEditorInitialized) {
    richTextEditorInitialized = true;
    // Small delay to ensure all other scripts have loaded
    setTimeout(initializeRichTextEditor, 100);
  }
});

// Also export for manual initialization
window.initializeRichTextEditor = function() {
  if (!richTextEditorInitialized) {
    richTextEditorInitialized = true;
    initializeRichTextEditor();
  } else {
    console.log("ℹ️ Rich text editor already initialized globally");
  }
};
