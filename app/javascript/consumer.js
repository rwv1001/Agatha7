import { createConsumer } from "@rails/actioncable";

const actionCableConsumer = createConsumer();

// Make consumer available globally for browser compatibility
window.actionCableConsumer = actionCableConsumer;

export default actionCableConsumer;
