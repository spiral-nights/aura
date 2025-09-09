import {
  getPublicKey,
  getEventHash,
  nip44,
  finalizeEvent,
  generateSecretKey,
} from "nostr-tools";
import { SimplePool, useWebSocketImplementation } from "nostr-tools/pool";
import WebSocket from "ws";

useWebSocketImplementation(WebSocket);

const TWO_DAYS = 2 * 24 * 60 * 60;
const now = () => Math.round(Date.now() / 1000);
const randomNow = () => Math.round(now() - Math.random() * TWO_DAYS);

const nip44ConversationKey = (privateKey, publicKey) =>
  nip44.v2.utils.getConversationKey(privateKey, publicKey);

const nip44Encrypt = (data, privateKey, publicKey) =>
  nip44.v2.encrypt(
    JSON.stringify(data),
    nip44ConversationKey(privateKey, publicKey),
  );

/**
 * @param {import("nostr-tools").Event} data
 * @param {Uint8Array} privateKey
 * @returns {any}
 */
export const nip44Decrypt = (data, privateKey) =>
  JSON.parse(
    nip44.v2.decrypt(
      data.content,
      nip44ConversationKey(privateKey, data.pubkey),
    ),
  );

const createRumor = (event, privateKey) => {
  const rumor = {
    created_at: now(),
    content: "",
    tags: [],
    ...event,
    pubkey: getPublicKey(privateKey),
  };

  rumor.id = getEventHash(rumor);

  return rumor;
};

const createSeal = (rumor, privateKey, recipientPublicKey) => {
  return finalizeEvent(
    {
      kind: 13,
      content: nip44Encrypt(rumor, privateKey, recipientPublicKey),
      created_at: randomNow(),
      tags: [],
    },
    privateKey,
  );
};

const createWrap = (event, recipientPublicKey) => {
  const randomKey = generateSecretKey();

  return finalizeEvent(
    {
      kind: 1059,
      content: nip44Encrypt(event, randomKey, recipientPublicKey),
      created_at: randomNow(),
      tags: [["p", recipientPublicKey]],
    },
    randomKey,
  );
};

/**
 * Sends a private message using NIP-59.
 *
 * @param {Uint8Array} senderSk - The sender's private key.
 * @param {string} recipientPublicKey - The recipient's hex public key.
 * @param {string} message - The message to send.
 * @param {string[]} relays - The relays to publish the message to.
 * @returns {Promise<void>}
 */
export async function sendPrivateMessage(
  senderSk,
  recipientPublicKey,
  message,
  relays,
) {
  const rumor = createRumor(
    {
      kind: 14,
      content: message,
      tags: [["p", recipientPublicKey]],
    },
    senderSk,
  );

  const seal = createSeal(rumor, senderSk, recipientPublicKey);
  const giftWrap = createWrap(seal, recipientPublicKey);

  const pool = new SimplePool();
  await Promise.any(pool.publish(relays, giftWrap));
  pool.close(relays);
}
