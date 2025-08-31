import aura_bot/config
import aura_bot/javascript
import aura_bot/nostr/key
import aura_bot/nostr/relay
import gleam/io
import gleam/javascript/array

pub fn main() -> Nil {
  io.println("Hello from aura_bot!")
  // read env variables for bot private key, bot public key, and allowed users
  let config = config.read_config_from_env()
  echo config

  // connect to relays
  let bot_npub = key.derive_public_key_from_bech32(config.bot_nsec)
  let filter =
    relay.Filter(kinds: [1059], recipients: [bot_npub])
    |> relay.filter_to_object()

  // make it so javascript.Object can't be created from outside that file
  relay.listen_to_relays(array.from_list(config.relays), filter, fn(a) {
    echo a
    Nil
  })

  // download gift wrapped messages, then unseal them
  // continue listening for new messages
  // send hard coded response to messages

  //sys
  javascript.wait_forever()
}
