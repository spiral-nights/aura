import aura_bot/nostr
import aura_bot/nostr/key.{type HexKey, type Public}
import gleam/javascript/promise.{type Promise}

/// An AI agent
pub opaque type Agent {
  Gemini(
    public_key: HexKey(Public),
    api_key: String,
    messages: List(nostr.Event),
    created_at: Int,
    google_gen_ai: GoogleGenAI,
  )
}

// type representing GoogleGenAI from the js-genai sdk
type GoogleGenAI

pub fn new(
  public_key public_key: HexKey(Public),
  api_key api_key: String,
  messages messages: List(nostr.Event),
  created_at created_at: Int,
) -> Agent {
  Gemini(
    public_key:,
    api_key:,
    messages:,
    created_at:,
    google_gen_ai: google_gen_ai(api_key),
  )
}

pub fn created_at(agent: Agent) -> Int {
  agent.created_at
}

/// Add a new message to the agent's context without having it respond
/// ## Parameters
/// - `agent`: The agent
/// - `message`: The message to add
pub fn add_to_context(agent: Agent, message: nostr.Event) -> Agent {
  Gemini(..agent, messages: [message, ..agent.messages])
}

/// Send a message to the agent and get a response
/// ## Parameters
/// - `message`: The message to send
/// - `agent`: The agent
/// ## Returns
/// - A promise that resolves with the agent's response
pub fn send_message(message: String, agent: Agent) -> Promise(String) {
  todo
  // get all the messages from the agent's context
  // call the api using:
  // 1. The context
  //    To create the context, the agent needs to be able to distinguish btw. its npub and others
  // 2. The new message
  // 3. The system prompt
  // 4. The promise should resolve
}

@external(javascript, "./agent_ffi.mjs", "googleGenAI")
fn google_gen_ai(api_key: String) -> GoogleGenAI
