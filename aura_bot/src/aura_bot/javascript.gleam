/// Type to represent an unknown/generic type that should correspond to a gleam type
pub type Unparsed(actual_type, gleam_type) {
  Unparsed(data: actual_type)
}

/// Wait forever
@external(javascript, "./javascript_ffi.mjs", "waitForever")
pub fn wait_forever() -> Nil

/// Get the current time in seconds since the epoch
@external(javascript, "./javascript_ffi.mjs", "currentTimeSeconds")
pub fn current_time_s() -> Int
