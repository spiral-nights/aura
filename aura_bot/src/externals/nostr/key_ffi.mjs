import { getPublicKey } from "nostr-tools/pure";
import * as nip19 from "nostr-tools/nip19";

/**
 * @param {string} bech32
 * @returns {Uint8Array}
 */
export function bech32ToUint8Array(bech32) {
  const { type, data } = nip19.decode(bech32);
  return data;
}

/**
 * @param {Uint8Array} privateKey
 * @returns {string}
 */
export function derivePublicKey(privateKey) {
  return getPublicKey(privateKey);
}

/**
 * @param {string} npub
 * @returns {string} hex public key
 */
export function npubToHex(npub) {
  return nip19.decode(npub);
}
