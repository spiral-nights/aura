import aura_bot/javascript.{type Unparsed, Unparsed}
import aura_bot/nostr
import aura_bot/nostr/key.{type BinaryKey, type Private}
import gleam/dynamic
import gleam/javascript/array
import gleam/javascript/promise

/// Sends a private message using NIP-59.
/// This function encrypts the message, wraps it in a gift wrap event, and sends it to the specified relays.
///
/// ## Parameters
/// - `sender_sk`: The sender's private key as an ArrayBuffer.
/// - `recipient_pk`: The recipient's public key as a hex string.
/// - `message`: The message to send.
/// - `relays`: A list of relay URLs to publish the message to.
///
@external(javascript, "./messaging_ffi.mjs", "sendPrivateMessage")
pub fn send_private_message(
  sender_sk: BinaryKey(Private),
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
pub fn nip44_decrypt(
  data: dynamic.Dynamic,
  private_key: BinaryKey(Private),
) -> Unparsed(dynamic.Dynamic, nostr.Event) {
  let event_data = nip44_decrypt_ffi(data, private_key)
  Unparsed(event_data)
}

@external(javascript, "./messaging_ffi.mjs", "nip44Decrypt")
fn nip44_decrypt_ffi(
  data: dynamic.Dynamic,
  private_key: BinaryKey(Private),
) -> dynamic.Dynamic
