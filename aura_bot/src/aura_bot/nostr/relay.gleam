import aura_bot/javascript
import gleam/dynamic
import gleam/javascript/array
import gleam/json

/// Alias for nostr event; can eventually be a typed record
pub type Event =
  dynamic.Dynamic

/// Alias for the hex version of a key
pub type HexKey =
  String

/// This is a type representing a Nostr event.
/// For now we use Dynamic, but it could be a typed record later.
/// This is a type representing a Nostr filter.
pub type Filter {
  Filter(kinds: List(Int), recipients: List(HexKey))
}

pub fn filter_to_object(filter: Filter) -> javascript.Object(Filter) {
  let obj =
    json.object([
      #("kinds", json.array(filter.kinds, of: json.int)),
      #("#p", json.array(filter.recipients, of: json.string)),
    ])

  javascript.to_object(filter, obj)
}

/// Connects to a list of relays and listens for events.
///
/// ## Parameters
/// - `relays`: A list of relay URLs to connect to.
/// - `filter`: A filter to control the returned content.
/// - `on_event`: A callback function to handle received events.
///
@external(javascript, "../../externals/nostr/relay_ffi.mjs", "listenToRelays")
pub fn listen_to_relays(
  relays: array.Array(String),
  filter: javascript.Object(Filter),
  on_event: fn(Event) -> Nil,
) -> fn() -> Nil
