import aura_bot/ai/agent.{type Agent}
import aura_bot/javascript
import aura_bot/nostr
import aura_bot/nostr/key
import aura_bot/nostr/messaging
import aura_bot/state
import gleam/bool
import gleam/dict
import gleam/javascript/array
import gleam/javascript/promise
import gleam/set

/// Handle the nostr event
/// ## Parameters
/// - `event`: The nostr event
pub fn handle_message(event: nostr.Event) -> Nil {
  // only handle messages from expected users
  let app_state = state.load_state()
  use <- bool.guard(when: ignore_event(event, app_state), return: Nil)

  // TODO: Figure out proper id to use as thread_id
  // It should likely be a concatentation of all pubkeys in the "p" tag of the event
  // get the agent for the chat and add the message to it
  let thread_id = event.pubkey
  let agent =
    get_agent_for_thread(thread_id, app_state)
    |> agent.add_to_context(event)

  let should_respond = event.created_at > agent.created_at(agent)
  // TODO: Figure out better way to test AI behavior
  // let should_respond =
  //   event.id
  //   == "c35080c3fe980ba3e6a4ae3b55352b973ae8b122002a8f0711765a7b373002b5"
  case should_respond {
    False -> Nil
    True -> respond_to_message(event, agent, app_state)
  }
  // TODO: The bot needs to be aware of its own messages in addition to messages received from others

  // Assign the agent to the thread in application state and save it
  state.assign_agent_to_thread(app_state, thread_id, agent)
  |> state.save_state
  Nil
}

fn respond_to_message(
  event: nostr.Event,
  agent: Agent,
  state: state.State,
) -> Nil {
  let binary_private_key = key.nsec_to_binary_key(state.config.bot_nsec)

  let agent_promise =
    agent.send_message("How tall is Mount Fuji? Answer in Japanese", agent)

  promise.map(agent_promise, fn(response) {
    case state.config.publish_messages {
      False -> {
        // log the response instead of publishing
        echo response as "Agent Response:"
        Nil
      }
      True -> {
        // publish the response to the network
        messaging.send_private_message(
          response,
          binary_private_key,
          event.pubkey,
          array.from_list(state.config.relays),
        )
        Nil
      }
    }
  })

  Nil
}

/// Get the agent for the given chat thread
/// ## Parameters
/// - `thread_id`: The thread id
/// - `app_state`: The state of the application
/// ## Returns
/// - The agent for the given thread
fn get_agent_for_thread(thread_id: String, app_state: state.State) -> Agent {
  let agent_for_thread = dict.get(app_state.agents_by_thread, thread_id)

  let bot_public_key =
    key.derive_public_key_from_nsec(app_state.config.bot_nsec)

  case agent_for_thread {
    Ok(agent) -> agent
    Error(_) -> {
      agent.new(
        public_key: bot_public_key,
        api_key: app_state.config.gemini_api_key,
        messages: [],
        created_at: javascript.current_time_s(),
      )
    }
  }
}

/// Ignore the event if:
///   1. The sender is not in the allowed list of senders
fn ignore_event(event: nostr.Event, app_state: state.State) -> Bool {
  app_state.config.participant_npubs
  |> set.from_list
  |> set.map(fn(npub_str) { key.npub_to_hex(npub_str).value })
  |> set.contains(event.pubkey)
  |> bool.negate
}
