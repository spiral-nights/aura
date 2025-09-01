import gleam/dynamic
import gleam/json

pub type ArrayBuffer {
  ArrayBuffer
}

/// Type to represent a JSON object that should correspond to a gleam type
pub type JSObject(gleam_type) {
  JSObject(json.Json)
}

/// Type to represent a dynamic object that should correspond to a gleam type
pub type DynamicObject(gleam_type) {
  DynamicObject(dynamic.Dynamic)
}

/// Wait forever
@external(javascript, "../externals/javascript_ffi.mjs", "waitForever")
pub fn wait_forever() -> Nil
