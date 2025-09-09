pub type Public

pub type Private

pub type BinaryKey(some)

pub type HexKey(some) {
  HexKey(value: String)
}

@external(javascript, "./key_ffi.mjs", "bech32ToUint8Array")
pub fn npub_to_binary_key(npub: String) -> BinaryKey(Public)

@external(javascript, "./key_ffi.mjs", "bech32ToUint8Array")
pub fn nsec_to_binary_key(nsec: String) -> BinaryKey(Private)

@external(javascript, "./key_ffi.mjs", "bech32ToHex")
fn bech32_to_hex(bech32: String) -> String

pub fn npub_to_hex(npub: String) -> HexKey(Public) {
  HexKey(value: bech32_to_hex(npub))
}

@external(javascript, "./key_ffi.mjs", "bech32ToHex")
pub fn nsec_to_hex(nsec: String) -> HexKey(Private) {
  HexKey(value: bech32_to_hex(nsec))
}

@external(javascript, "./key_ffi.mjs", "derivePublicKey")
fn derive_public_key_hex_string(private_key: BinaryKey(Private)) -> String

pub fn derive_public_key_from_nsec(nsec: String) -> HexKey(Public) {
  let public_key_hex_value =
    nsec
    |> nsec_to_binary_key
    |> derive_public_key_hex_string

  HexKey(public_key_hex_value)
}
