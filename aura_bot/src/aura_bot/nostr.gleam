import aura_bot/javascript.{type Unparsed}
import gleam/dynamic
import gleam/dynamic/decode

/// A type representing a Nostr event.
pub type Event {
  Event(pubkey: String, content: String)
}

/// create a JSON decoder for nostr events
fn event_decoder() -> decode.Decoder(Event) {
  use pubkey <- decode.field("pubkey", decode.string)
  use content <- decode.field("content", decode.string)
  decode.success(Event(pubkey:, content:))
}

/// Convert a JSON nostr event into an event
pub fn decode(
  event: Unparsed(dynamic.Dynamic, Event),
) -> Result(Event, List(decode.DecodeError)) {
  let decoder = event_decoder()
  decode.run(event.data, decoder)
}
