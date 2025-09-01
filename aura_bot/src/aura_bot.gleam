import aura_bot/config
import aura_bot/javascript.{DynamicObject, JSObject}
import aura_bot/nostr
import aura_bot/nostr/key
import aura_bot/nostr/messaging
import aura_bot/nostr/relay
import gleam/io
import gleam/javascript/array

pub fn main() -> Nil {
  io.println("Hello from aura_bot!")
  // read env variables for bot private key, bot public key, and allowed users
  let config = config.read_config_from_env()
  echo config

  // connect to relays
  let bot_private_key = key.bech32_to_array_buffer(config.bot_nsec)
  let bot_npub = key.derive_public_key_from_bech32(config.bot_nsec)
  let filter =
    relay.Filter(kinds: [1059], recipients: [bot_npub])
    |> relay.filter_to_json()
  let JSObject(filter_json) = filter

  relay.listen_to_relays(
    array.from_list(config.relays),
    filter_json,
    fn(gift_wrapped_msg) {
      let seal_dynamic =
        messaging.nip44_decrypt(gift_wrapped_msg, bot_private_key)
      let DynamicObject(seal) = seal_dynamic
      let rumor_dynamic = messaging.nip44_decrypt(seal, bot_private_key)
      let rumor = nostr.decode(rumor_dynamic)
      case rumor {
        nostr.Event(_pubkey, content) -> {
          echo content as "Event content:"
        }
        nostr.Invalid -> echo "Invalid content"
      }

      echo Nil
    },
  )

  // TODO:
  // send hard coded response to new messages

  javascript.wait_forever()
}
