import gleam/json

pub type ArrayBuffer {
  ArrayBuffer
}

/// Type to represent a JSON object converted from a gleam type
pub type Object(gleam_type)

/// Convert the given object
pub fn to_object(gleam_obj: a, json_obj: json.Json) {
  make_js_interop(gleam_obj, json_obj)
}

/// Change the type of the given json object into a type representing
/// the corresponding gleam object (used for js interop type safety)
@external(javascript, "../externals/javascript_ffi.mjs", "makeJsInterop")
fn make_js_interop(gleam_obj: a, json_obj: json.Json) -> Object(a)

/// Wait forever
@external(javascript, "../externals/javascript_ffi.mjs", "waitForever")
pub fn wait_forever() -> Nil
