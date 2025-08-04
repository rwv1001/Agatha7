import { createConsumer } from "@rails/actioncable";

// Create consumer with explicit URL for Docker environment
const getWebSocketURL = () => {
  // In development, try to determine the correct WebSocket URL
  if (typeof window !== 'undefined') {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const host = window.location.host;
    return `${protocol}//${host}/cable`;
  }
  // Fallback to relative URL
  return '/cable';
};

const actionCableConsumer = createConsumer(getWebSocketURL());

// Make consumer available globally for browser compatibility
window.actionCableConsumer = actionCableConsumer;

console.log("ActionCable consumer initialized with URL:", getWebSocketURL());

export default actionCableConsumer;
