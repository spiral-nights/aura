import aura_bot/nostr

/// An AI agent
pub opaque type Agent {
  Gemini(api_key: String, messages: List(nostr.Event), created_at: Int)
}

pub fn new(
  api_key api_key: String,
  messages messages: List(nostr.Event),
  created_at created_at: Int,
) -> Agent {
  Gemini(api_key:, messages:, created_at:)
}

pub fn created_at(agent: Agent) -> Int {
  agent.created_at
}

/// Add a new message to the agent's message list
/// ## Parameters
/// - `agent`: The agent
/// - `message`: The message to add
pub fn add_message(agent: Agent, message: nostr.Event) -> Agent {
  Gemini(..agent, messages: [message, ..agent.messages])
}
