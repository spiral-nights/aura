import aura_bot/javascript.{type Unparsed}
import gleam/dynamic
import gleam/dynamic/decode

/// A type representing a Nostr event.
pub type Event {
  Event(id: String, pubkey: String, content: String, created_at: Int)
}

/// create a JSON decoder for nostr events
fn event_decoder() -> decode.Decoder(Event) {
  use id <- decode.field("id", decode.string)
  use pubkey <- decode.field("pubkey", decode.string)
  use content <- decode.field("content", decode.string)
  use created_at <- decode.field("created_at", decode.int)
  decode.success(Event(id:, pubkey:, content:, created_at:))
}

/// Convert a JSON nostr event into an event
pub fn decode(
  event: Unparsed(dynamic.Dynamic, Event),
) -> Result(Event, List(decode.DecodeError)) {
  let decoder = event_decoder()
  decode.run(event.data, decoder)
}
