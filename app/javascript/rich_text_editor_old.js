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
  console.log("🖋️ Initializing rich text editor...");
  
  // Look for the body textarea field
  const bodyTextarea = document.querySelector('textarea[name*="body"], #edit_body, textarea[id*="body"]');
  
  if (!bodyTextarea) {
    console.log("ℹ️ No body textarea found, skipping rich text editor initialization");
    return;
  }
  
  // Check if editor is already initialized for this textarea
  if (bodyTextarea.dataset.quillInitialized === 'true') {
    console.log("ℹ️ Rich text editor already initialized for this textarea");
    return;
  }
  
  console.log("✅ Found body textarea:", bodyTextarea.id || bodyTextarea.name);
  
  // Mark as initialized to prevent duplicate initialization
  bodyTextarea.dataset.quillInitialized = 'true';
  
  // Create a container for Quill editor
  const editorContainer = document.createElement('div');
  editorContainer.id = 'quill-editor-container-' + (bodyTextarea.id || 'body');
  editorContainer.className = 'quill-editor-container';
  editorContainer.style.cssText = `
    min-height: 250px;
    width: 100%;
    max-width: 800px;
    background: white;
    border: 1px solid #ccc;
    border-radius: 4px;
  `;
  
  // Hide the original textarea but keep it for form submission
  bodyTextarea.style.display = 'none';
  
  // Insert the editor container after the textarea
  bodyTextarea.parentNode.insertBefore(editorContainer, bodyTextarea.nextSibling);
  
  // Configure Quill with only inline formats to prevent block-level tag insertion
  const toolbarOptions = [
    ['bold', 'italic', 'underline'],                  // basic formatting
    ['link'],                                          // link
    ['clean']                                          // remove formatting
  ];
  
  // Initialize Quill editor with only inline formats - no block formats like paragraphs
  const quill = new Quill(editorContainer, {
    theme: 'snow',
    modules: {
      toolbar: toolbarOptions
    },
    placeholder: 'Enter email body text...',
    formats: ['bold', 'italic', 'underline', 'link'] // only inline formats, no block formats
  });
  
  // Set initial content using a more reliable approach
  const initialContent = bodyTextarea.value;
  if (initialContent && initialContent.trim() !== '') {
    console.log("📝 Original content:", initialContent);
    
    // Wait a moment for Quill to be fully initialized
    setTimeout(() => {
      try {
        // Set content directly - since we restricted formats, Quill won't add unwanted block tags
        quill.root.innerHTML = initialContent;
        console.log("📝 Content set directly with inline-only format restrictions");
      } catch (error) {
        console.log("⚠️ Direct setting failed, trying setText:", error);
        // Ultimate fallback: set as plain text
        quill.setText(initialContent);
      }
    }, 100);
  }
  
  // Function to get content back from Quill editor - simple since no block formats
  function getQuillContent() {
    // Since we're only using inline formats, just get the HTML directly
    const content = quill.root.innerHTML;
    console.log("📝 Got content from Quill (inline formats only):", content);
    return content;
  }
  
  // Sync Quill content back to textarea on change - simple direct approach
  quill.on('text-change', function() {
    const content = getQuillContent();
    bodyTextarea.value = content;
    console.log("📝 Updated textarea with content:", content);
  });
  
  // Sync on form submission to ensure we capture final state
  const form = bodyTextarea.closest('form');
  if (form) {
    form.addEventListener('submit', function() {
      const content = getQuillContent();
      bodyTextarea.value = content;
      console.log("📤 Synced content on form submission:", content.substring(0, 100) + '...');
    });
  }
  
  // Add blur listener similar to the original code - but with our own implementation
  quill.on('selection-change', function(range) {
    if (!range) {
      // Editor lost focus
      console.log("📝 Quill editor lost focus, syncing content");
      const content = getQuillContent();
      bodyTextarea.value = content;
      
      // Save the content without triggering editBlur which causes form submission
      try {
        // Instead of calling editBlur, directly update the hidden form fields
        const field_name_obj = document.getElementById('field_name');
        const field_value_obj = document.getElementById('field_value');
        const field_data_type_obj = document.getElementById('field_data_type');
        const closing_flag_obj = document.getElementById('closing_flag');

        if (field_name_obj) field_name_obj.value = "body";
        if (field_data_type_obj) field_data_type_obj.value = "text";
        if (field_value_obj) field_value_obj.value = content;
        if (closing_flag_obj) closing_flag_obj.value = "0";
        
        console.log("📝 Updated hidden form fields directly (avoiding form submission)");
        console.log("📝 Field value updated to:", content.substring(0, 100) + "...");
        
        // Just trigger a gentle save without the aggressive form submission
        // This will update the backend without destroying our editor
        const form = document.getElementById('update_form');
        if (form) {
          const action = form.action;
          
          // Use a more gentle approach - just post the data without reloading
          const formData = new FormData(form);
          
          fetch(action, {
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
            } else {
              console.log("⚠️ Save response not OK:", response.status);
            }
          })
          .catch(error => {
            console.log("❌ Error saving content:", error);
          });
        }
        
      } catch (error) {
        console.log("❌ Error in blur handler:", error);
        
        // Fallback: just trigger change events to ensure the system knows the content changed
        try {
          console.log("🔄 Using fallback event dispatch...");
          const changeEvent = new Event('change', { bubbles: true });
          bodyTextarea.dispatchEvent(changeEvent);
          
          const inputEvent = new Event('input', { bubbles: true });
          bodyTextarea.dispatchEvent(inputEvent);
        } catch (e) {
          console.log("❌ Fallback event dispatch also failed:", e);
        }
      }
    }
  });
  
  // Store reference globally for debugging
  window.quillEditor = quill;
  window.bodyTextarea = bodyTextarea;
  
    
  console.log("✅ Rich text editor initialized successfully for body field");
  
  console.log("✅ Rich text editor initialized successfully");
  console.log("🔧 Editor size: 250px height, responsive width");
  console.log("🛠️ Available toolbar: bold, italic, underline, lists, headers, etc.");
  console.log("🛡️ Editor protection enabled to prevent interference");
  
  return quill;
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
