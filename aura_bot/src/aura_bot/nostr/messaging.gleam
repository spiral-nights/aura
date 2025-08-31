import aura_bot/javascript.{type ArrayBuffer}
import gleam/dynamic
import gleam/javascript/array
import gleam/javascript/promise

/// A type representing a Nostr event.
pub type NostrEvent =
  dynamic.Dynamic

/// Sends a private message using NIP-59.
/// This function encrypts the message, wraps it in a gift wrap event, and sends it to the specified relays.
///
/// ## Parameters
/// - `sender_sk`: The sender's private key as an ArrayBuffer.
/// - `recipient_pk`: The recipient's public key as a hex string.
/// - `message`: The message to send.
/// - `relays`: A list of relay URLs to publish the message to.
///
@external(javascript, "../../externals/nostr/messaging_ffi.mjs", "sendPrivateMessage")
pub fn send_private_message(
  sender_sk: ArrayBuffer,
  recipient_pk: String,
  message: String,
  relays: array.Array(String),
) -> promise.Promise(Nil)

/// Decrypts a NIP-44 encrypted event.
///
/// ## Parameters
/// - `data`: The Nostr event to decrypt.
/// - `private_key`: The private key to use for decryption.
///
@external(javascript, "../../externals/nostr/messaging_ffi.mjs", "nip44Decrypt")
pub fn nip44_decrypt(
  data: NostrEvent,
  private_key: ArrayBuffer,
) -> dynamic.Dynamic
