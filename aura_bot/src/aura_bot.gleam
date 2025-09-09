import aura_bot/agent
import aura_bot/config
import aura_bot/javascript.{Unparsed}
import aura_bot/nostr
import aura_bot/nostr/key.{type BinaryKey, type Private}
import aura_bot/nostr/messaging
import aura_bot/nostr/relay
import aura_bot/state
import gleam/dict
import gleam/io
import gleam/javascript/array

pub fn main() -> Nil {
  io.println("Hello from aura_bot!")
  // read env variables for bot private key, bot public key, and allowed users
  let config = config.read_config_from_env()
  echo config

  // connect to relays
  let bot_private_key = key.nsec_to_binary_key(config.bot_nsec)
  let bot_npub = key.derive_public_key_from_nsec(config.bot_nsec)
  let filter =
    relay.Filter(kinds: [1059], recipients: [bot_npub.value])
    |> relay.filter_to_json()
  let Unparsed(filter_json) = filter
  state.save_state(state.State(config:, agents_by_thread: dict.new()))

  relay.listen_to_relays(
    array.from_list(config.relays),
    filter_json,
    fn(gift_wrapped_msg) { handle_message(gift_wrapped_msg, bot_private_key) },
  )

  // TODO:
  // send hard coded response to new messages

  javascript.wait_forever()
}

fn handle_message(gift_wrapped_msg, bot_private_key: BinaryKey(Private)) {
  let seal = messaging.nip44_decrypt(gift_wrapped_msg, bot_private_key)
  let decrypted_rumor = messaging.nip44_decrypt(seal.data, bot_private_key)
  let rumor = nostr.decode(decrypted_rumor)
  case rumor {
    Ok(event) -> {
      agent.handle_message(event)
    }
    Error(decode_errors) -> {
      echo decode_errors as "Invalid message content:"
      Nil
    }
  }
}
