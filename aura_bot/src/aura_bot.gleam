import aura_bot/config
import aura_bot/javascript.{Unparsed}
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
  let Unparsed(filter_json) = filter

  relay.listen_to_relays(
    array.from_list(config.relays),
    filter_json,
    fn(gift_wrapped_msg) {
      let seal = messaging.nip44_decrypt(gift_wrapped_msg, bot_private_key)
      let decrypted_rumor = messaging.nip44_decrypt(seal.data, bot_private_key)
      let rumor = nostr.decode(decrypted_rumor)
      case rumor {
        Ok(event) -> {
          echo event.content as "Event content:"
        }
        Error(decode_errors) -> {
          echo decode_errors as "Invalid message content."
          "Invalid message content"
        }
      }

      echo Nil
    },
  )

  // TODO:
  // send hard coded response to new messages

  javascript.wait_forever()
}
