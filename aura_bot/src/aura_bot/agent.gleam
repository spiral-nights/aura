import aura_bot/agent/types.{type Agent, Gemini}
import aura_bot/config
import aura_bot/nostr
import aura_bot/nostr/key
import aura_bot/state
import gleam/bool
import gleam/dict
import gleam/list

pub fn handle_message(event: nostr.Event) -> Nil {
  echo event.content as "Event content:"

  // only handle messages from expected users
  let app_state = state.load_state()
  let sender_not_allowed =
    app_state.config.participant_npubs
    |> list.map(key.npub_to_hex)
    |> list.contains(event.pubkey)
    |> bool.negate

  // if sender not allowed, return Nil "immediately"
  use <- bool.guard(when: sender_not_allowed, return: Nil)

  // TODO: Figure out proper id to use as thread_id
  // get the agent for the chat and add the message to it
  let thread_id = event.pubkey
  let agent_for_thread =
    get_agent_for_thread(thread_id, app_state)
    |> add_message(event)

  // Add the agent to the thread in application state and save it
  state.add_agent_to_thread(agent_for_thread, thread_id, app_state)
  |> state.save_state

  state.load_state() |> echo
  Nil
}

/// Create a new AI agent
/// ## Parameters
/// - `config`: The application config
fn new(config: config.AppConfig) -> Agent {
  // in the future, we may have options for other agent types
  Gemini(api_key: config.gemini_api_key, messages: [])
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
  case agent_for_thread {
    Ok(agent) -> agent
    Error(_) -> {
      new(app_state.config)
    }
  }
}
