// Rich Text Editor for AgathaEmail body field
// Using Editor.js for better control over formatting

function initializeRichTextEditor() {
  console.log("🖋️ Initializing Editor.js rich text editor...");
  
  // Look for the body textarea field
  const bodyTextarea = document.querySelector('textarea[name*="body"], #edit_body, textarea[id*="body"]');
  
  if (!bodyTextarea) {
    console.log("ℹ️ No body textarea found, skipping rich text editor initialization");
    return;
  }
  
  // Check if editor is already initialized for this textarea
  if (bodyTextarea.dataset.editorjsInitialized === 'true') {
    console.log("ℹ️ Rich text editor already initialized for this textarea");
    return;
  }
  
  console.log("✅ Found body textarea:", bodyTextarea.id || bodyTextarea.name);
  
  // Mark as initialized to prevent duplicate initialization
  bodyTextarea.dataset.editorjsInitialized = 'true';
  
  // Create a container for Editor.js
  const editorContainer = document.createElement('div');
  editorContainer.id = 'editorjs-container-' + (bodyTextarea.id || 'body');
  editorContainer.className = 'editorjs-container';
  editorContainer.style.cssText = `
    min-height: 250px;
    width: 100%;
    max-width: 800px;
    background: white;
    border: 1px solid #ccc;
    border-radius: 4px;
    padding: 10px;
  `;
  
  // Hide the original textarea but keep it for form submission
  bodyTextarea.style.display = 'none';
  
  // Insert the editor container after the textarea
  bodyTextarea.parentNode.insertBefore(editorContainer, bodyTextarea.nextSibling);
  
  // Get initial content and handle it as raw HTML
  const initialContent = bodyTextarea.value;
  let editorData = { blocks: [] };
  
  if (initialContent && initialContent.trim() !== '') {
    console.log("📝 Original content:", initialContent);
    
    // For now, create a simple raw HTML block that preserves everything
    editorData = {
      blocks: [
        {
          type: 'raw',
          data: {
            html: initialContent
          }
        }
      ]
    };
  }
  
  // Check if Editor.js is available
  if (typeof EditorJS === 'undefined') {
    console.log("⚠️ Editor.js not loaded, falling back to simple contenteditable div");
    
    // Create a simple contenteditable div as fallback
    const editableDiv = document.createElement('div');
    editableDiv.contentEditable = true;
    editableDiv.innerHTML = initialContent;
    editableDiv.style.cssText = `
      min-height: 250px;
      width: 100%;
      padding: 15px;
      border: 1px solid #ccc;
      border-radius: 4px;
      background: white;
      font-family: inherit;
      font-size: inherit;
      line-height: 1.4;
    `;
    
    editorContainer.appendChild(editableDiv);
    
    // Sync content back to textarea
    editableDiv.addEventListener('input', function() {
      bodyTextarea.value = editableDiv.innerHTML;
      console.log("📝 Updated textarea from contenteditable:", editableDiv.innerHTML);
    });
    
    // Sync on blur
    editableDiv.addEventListener('blur', function() {
      bodyTextarea.value = editableDiv.innerHTML;
      console.log("📝 Synced content on blur");
    });
    
    console.log("✅ Fallback contenteditable editor initialized");
    return editableDiv;
  }
  
  // Initialize Editor.js with Raw HTML tool
  const editor = new EditorJS({
    holder: editorContainer.id,
    data: editorData,
    tools: {
      raw: {
        class: RawTool // This would need to be included
      }
    },
    placeholder: 'Enter email body text...',
    
    onChange: function() {
      // Sync content back to textarea on change
      editor.save().then((outputData) => {
        const htmlContent = convertEditorJsToHtml(outputData);
        bodyTextarea.value = htmlContent;
        console.log("📝 Updated textarea with content:", htmlContent);
      }).catch((error) => {
        console.log('Saving failed: ', error);
      });
    }
  });
  
  // Function to convert Editor.js output back to HTML
  function convertEditorJsToHtml(data) {
    let html = '';
    
    data.blocks.forEach(block => {
      if (block.type === 'raw') {
        // For raw HTML blocks, just return the HTML content
        html += block.data.html;
      }
    });
    
    return html;
  }
  
  // Sync on form submission
  const form = bodyTextarea.closest('form');
  if (form) {
    form.addEventListener('submit', function() {
      editor.save().then((outputData) => {
        const htmlContent = convertEditorJsToHtml(outputData);
        bodyTextarea.value = htmlContent;
        console.log("📤 Synced content on form submission:", htmlContent);
      });
    });
  }
  
  console.log("✅ Editor.js rich text editor initialized successfully");
  
  return editor;
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
