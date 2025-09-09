import aura_bot/agent/types.{type Agent, Gemini}
import aura_bot/config
import aura_bot/javascript
import aura_bot/nostr
import aura_bot/nostr/key
import aura_bot/nostr/messaging
import aura_bot/state
import gleam/bool
import gleam/dict
import gleam/int
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
    |> add_message(event)

  let should_respond = event.created_at > agent.created_at
  case should_respond {
    False -> Nil
    True -> respond_to_message(event, agent, app_state)
  }
  // TODO: Integrate ai message
  // TODO: The bot needs to be aware of its own messages in addition to messages received from others

  // Assign the agent to the thread in application state and save it
  state.assign_agent_to_thread(app_state, thread_id, agent)
  |> state.save_state
  Nil
}

fn respond_to_message(
  event: nostr.Event,
  _agent: Agent,
  state: state.State,
) -> Nil {
  let binary_private_key = key.nsec_to_binary_key(state.config.bot_nsec)
  let response =
    "Hello, friend! Responding to message with timestamp: "
    <> int.to_string(event.created_at)

  case state.config.publish_messages {
    False -> {
      echo response
      promise.resolve(Nil)
    }
    True -> {
      messaging.send_private_message(
        binary_private_key,
        event.pubkey,
        "Hello, friend! Responding to message with timestamp: "
          <> int.to_string(event.created_at),
        array.from_list(state.config.relays),
      )
    }
  }
  Nil
}

/// Create a new AI agent
/// ## Parameters
/// - `config`: The application config
fn new(config: config.AppConfig) -> Agent {
  // in the future, we may have options for other agent types
  Gemini(
    api_key: config.gemini_api_key,
    messages: [],
    created_at: javascript.current_time_ms(),
  )
}

/// Add a new message to the agent's message list
/// ## Parameters
/// - `agent`: The agent
/// - `message`: The message to add
fn add_message(agent: Agent, message: nostr.Event) -> Agent {
  Gemini(..agent, messages: [message, ..agent.messages])
}

/// Get the agent for the given chat thread
/// ## Parameters
/// - `thread_id`: The thread id
/// - `app_state`: The state of the application
/// ## Returns
/// - The agent for the given thread
fn get_agent_for_thread(thread_id: String, app_state: state.State) -> Agent {
  let agent_for_thread = dict.get(app_state.agents_by_thread, thread_id)
  // TODO: Make this save the app state if creating a new agent
  case agent_for_thread {
    Ok(agent) -> agent
    Error(_) -> {
      new(app_state.config)
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
