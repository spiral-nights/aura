pub type ArrayBuffer {
  ArrayBuffer
}

/// Type to represent an unknown/generic type that should correspond to a gleam type
pub type Unparsed(actual_type, gleam_type) {
  Unparsed(data: actual_type)
}

/// Wait forever
@external(javascript, "../externals/javascript_ffi.mjs", "waitForever")
pub fn wait_forever() -> Nil
