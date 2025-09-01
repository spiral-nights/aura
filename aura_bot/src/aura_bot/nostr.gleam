import aura_bot/javascript.{type DynamicObject, DynamicObject}
import gleam/dynamic/decode

/// A type representing a Nostr event.
pub type Event {
  Event(pubkey: String, content: String)
  Invalid
}

/// create a JSON decoder for nostr events
fn event_decoder() -> decode.Decoder(Event) {
  use pubkey <- decode.field("pubkey", decode.string)
  use content <- decode.field("content", decode.string)
  decode.success(Event(pubkey:, content:))
}

/// Convert a JSON nostr event into an event
pub fn decode(event_data: DynamicObject(Event)) -> Event {
  let decoder = event_decoder()
  let DynamicObject(event_json) = event_data
  let event_result = decode.run(event_json, decoder)

  case event_result {
    Ok(evt) -> evt
    Error(_decode_errors) -> {
      echo event_data as "Received invalid event:"
      Invalid
    }
  }
}
