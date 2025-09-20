import aura_bot/javascript.{type Unparsed, Unparsed}
import gleam/dynamic
import gleam/javascript/array
import gleam/json

/// Alias for the hex version of a key
pub type HexKey =
  String

/// A type representing a Nostr filter.
pub type Filter {
  Filter(kinds: List(Int), recipients: List(HexKey))
}

/// Convert the given filter to a json object representing the filter
pub fn filter_to_json(filter: Filter) -> Unparsed(json.Json, Filter) {
  let obj =
    json.object([
      #("kinds", json.array(filter.kinds, of: json.int)),
      #("#p", json.array(filter.recipients, of: json.string)),
    ])

  Unparsed(obj)
}

/// Connects to a list of relays and listens for events.
///
/// ## Parameters
/// - `relays`: A list of relay URLs to connect to.
/// - `filter`: A filter to control the returned content.
/// - `on_event`: A callback function to handle received events.
///
@external(javascript, "./relay_ffi.mjs", "listenToRelays")
pub fn listen_to_relays(
  relays: array.Array(String),
  filter: json.Json,
  on_event: fn(dynamic.Dynamic) -> Nil,
) -> fn() -> Nil
