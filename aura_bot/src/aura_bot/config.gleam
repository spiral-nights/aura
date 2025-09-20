import envoy
import gleam/list
import gleam/string

/// The application configuration
pub type AppConfig {
  AppConfig(
    gemini_api_key: String,
    bot_nsec: String,
    participant_npubs: List(String),
    relays: List(String),
    publish_messages: Bool,
  )
}

/// Read the application config from environment variables
pub fn read_config_from_env() -> AppConfig {
  let assert Ok(gemini_api_key) = envoy.get("GEMINI_API_KEY")
  let assert Ok(bot_nsec) = envoy.get("BOT_NSEC")
  let assert Ok(participant_str) = envoy.get("PARTICIPANT_NPUBS")
  let assert Ok(relay_str) = envoy.get("RELAYS")
  let assert Ok(publish_messages) = envoy.get("PUBLISH_MESSAGES")

  AppConfig(
    gemini_api_key:,
    bot_nsec:,
    participant_npubs: string_to_list(participant_str),
    relays: string_to_list(relay_str),
    publish_messages: publish_messages == "true",
  )
}

fn string_to_list(s: String) -> List(String) {
  s
  |> string.split(on: ",")
  |> list.map(string.trim)
}
