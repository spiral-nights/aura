import aura_bot/javascript

@external(javascript, "../../externals/nostr/key_ffi.mjs", "bech32ToUint8Array")
fn bech32_to_array_buffer(bech32_key: String) -> javascript.ArrayBuffer

@external(javascript, "../../externals/nostr/key_ffi.mjs", "derivePublicKey")
fn derive_public_key(private_key: javascript.ArrayBuffer) -> String

/// Derive the public key from the bech32 secret key
pub fn derive_public_key_from_bech32(bech32: String) -> String {
  bech32
  |> bech32_to_array_buffer
  |> derive_public_key
}
