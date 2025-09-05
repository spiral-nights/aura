import aura_bot/nostr

/// An AI agent
pub type Agent {
  Gemini(api_key: String, messages: List(nostr.Event))
}
