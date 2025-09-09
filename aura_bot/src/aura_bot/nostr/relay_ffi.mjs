import { SimplePool } from "nostr-tools/pool";
import { useWebSocketImplementation } from "nostr-tools/pool";
import WebSocket from "ws";

useWebSocketImplementation(WebSocket);

/**
 * Connects to a list of relays and listens for gift wrap events (kind 1059).
 *
 * @param {string[]} relays - A list of relay URLs to connect to.
 * @param {dict} filter - A filter to control the returned content.
 * @param {(event: import("nostr-tools").Event) => void} onEventCallback - A callback function to handle received events.
 * @returns {() => void} A function to close the connection.
 */
export function listenToRelays(relays, filter, onEventCallback) {
  const pool = new SimplePool();
  const sub = pool.subscribe(relays, filter, {
    onevent(event) {
      onEventCallback(event);
    },
  });

  // return a function that closes the pool when called
  return () => {
    sub.close();
    pool.close(relays);
  };
}
