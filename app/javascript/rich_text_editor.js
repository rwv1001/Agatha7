// Rich Text Editor for AgathaEmail body field
// Replaces the old Yahoo! Widget Library editor

function initializeRichTextEditor() {
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
  
  // Configure Quill with simpler toolbar to avoid format issues
  const toolbarOptions = [
    ['bold', 'italic', 'underline'],                  // basic formatting
    [{ 'list': 'ordered'}, { 'list': 'bullet' }],     // lists
    [{ 'header': [1, 2, 3, false] }],                 // headers
    ['link'],                                          // link
    ['clean']                                          // remove formatting
  ];
  
  // Initialize Quill editor with minimal formats to avoid conflicts
  const quill = new Quill(editorContainer, {
    theme: 'snow',
    modules: {
      toolbar: toolbarOptions
    },
    placeholder: 'Enter email body text...',
    formats: [
      'header',
      'bold', 'italic', 'underline',
      'list',
      'link'
    ]
  });
  
  // Set initial content from textarea with better HTML handling
  const initialContent = bodyTextarea.value;
  if (initialContent) {
    // Convert the existing HTML format to be compatible with Quill
    let convertedContent = initialContent;
    
    console.log("📝 Original content:", initialContent);
    
    // If the content already has proper HTML structure, use it as-is
    if (initialContent.includes('<p>') || initialContent.includes('<div>')) {
      // Content already has block elements, use directly
      convertedContent = initialContent;
    } else {
      // Convert <br> tags to paragraph structure for Quill
      // But preserve the original format for conversion back
      const lines = initialContent.split(/<br\s*\/?>/i);
      convertedContent = lines.map(line => {
        const trimmedLine = line.trim();
        if (trimmedLine === '') {
          return '<p><br></p>';
        } else {
          // Preserve any existing formatting within the line
          return `<p>${trimmedLine}</p>`;
        }
      }).join('');
    }
    
    // Convert <u> to underline format since Quill handles underline differently
    convertedContent = convertedContent.replace(/<u>/gi, '<span style="text-decoration: underline;">');
    convertedContent = convertedContent.replace(/<\/u>/gi, '</span>');
    
    console.log("📝 Converted content for Quill:", convertedContent);
    
    // Set the content
    quill.root.innerHTML = convertedContent;
  }
  
  // Function to convert Quill HTML back to the original format
  function convertQuillToOriginalFormat(quillHtml) {
    let converted = quillHtml;
    
    // Remove the outer container div that Quill sometimes adds
    converted = converted.replace(/^<div[^>]*>/, '').replace(/<\/div>$/, '');
    
    // Convert Quill's paragraph format back to simpler format
    // Handle empty paragraphs first
    converted = converted.replace(/<p><br><\/p>/gi, '<br>');
    
    // Convert paragraphs with content to just the content followed by <br>
    // But only if the original content didn't use <p> tags
    if (!initialContent.includes('<p>')) {
      converted = converted.replace(/<p>([^<]+)<\/p>/gi, '$1<br>');
      
      // Handle paragraphs with nested formatting
      converted = converted.replace(/<p>([^<]*<[^>]+>[^<]*)<\/p>/gi, '$1<br>');
    }
    
    // Convert underline spans back to <u> tags if the original used them
    if (initialContent.includes('<u>')) {
      converted = converted.replace(/<span style="text-decoration:\s*underline;">([^<]*)<\/span>/gi, '<u>$1</u>');
    }
    
    // Remove trailing <br> if it exists
    converted = converted.replace(/<br>$/, '');
    
    // Handle bold tags - Quill uses <strong>, convert to <b> if that's what was originally used
    if (initialContent.includes('<b>') && !initialContent.includes('<strong>')) {
      converted = converted.replace(/<strong>/gi, '<b>');
      converted = converted.replace(/<\/strong>/gi, '</b>');
    }
    
    // Handle italic tags - Quill uses <em>, convert to <i> if that's what was originally used
    if (initialContent.includes('<i>') && !initialContent.includes('<em>')) {
      converted = converted.replace(/<em>/gi, '<i>');
      converted = converted.replace(/<\/em>/gi, '</i>');
    }
    
    // Clean up any double <br> tags that might have been created
    converted = converted.replace(/<br><br>/gi, '<br>');
    
    return converted;
  }
  
  // Sync Quill content back to textarea on change with format conversion
  quill.on('text-change', function() {
    const quillHtml = quill.root.innerHTML;
    const convertedHtml = convertQuillToOriginalFormat(quillHtml);
    bodyTextarea.value = convertedHtml;
    console.log("📝 Updated textarea with converted content:", convertedHtml);
  });
  
  // Sync on form submission to ensure we capture final state
  const form = bodyTextarea.closest('form');
  if (form) {
    form.addEventListener('submit', function() {
      const quillHtml = quill.root.innerHTML;
      const convertedHtml = convertQuillToOriginalFormat(quillHtml);
      bodyTextarea.value = convertedHtml;
      console.log("📤 Synced content on form submission:", convertedHtml.substring(0, 100) + '...');
    });
  }
  
  // Add blur listener similar to the original code - but with our own implementation
  quill.on('selection-change', function(range) {
    if (!range) {
      // Editor lost focus
      console.log("📝 Quill editor lost focus, syncing content");
      const quillHtml = quill.root.innerHTML;
      const convertedHtml = convertQuillToOriginalFormat(quillHtml);
      bodyTextarea.value = convertedHtml;
      
      // Save the content without triggering editBlur which causes form submission
      try {
        // Instead of calling editBlur, directly update the hidden form fields
        const field_name_obj = document.getElementById('field_name');
        const field_value_obj = document.getElementById('field_value');
        const field_data_type_obj = document.getElementById('field_data_type');
        const closing_flag_obj = document.getElementById('closing_flag');

        if (field_name_obj) field_name_obj.value = "body";
        if (field_data_type_obj) field_data_type_obj.value = "text";
        if (field_value_obj) field_value_obj.value = convertedHtml;
        if (closing_flag_obj) closing_flag_obj.value = "0";
        
        console.log("📝 Updated hidden form fields directly (avoiding form submission)");
        console.log("📝 Field value updated to:", convertedHtml.substring(0, 100) + "...");
        
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
  
  // Store observer for cleanup if needed
  window.quillObserver = observer;
  
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
