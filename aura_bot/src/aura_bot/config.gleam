import envoy
import gleam/list
import gleam/result
import gleam/string

pub type AppConfig {
  AppConfig(
    gemini_api_key: String,
    bot_nsec: String,
    participant_npubs: List(String),
    relays: List(String),
  )
}

/// Read the application config from
pub fn read_config_from_env() -> AppConfig {
  let api_key_result = envoy.get("GEMINI_API_KEY")
  let nsec_result = envoy.get("BOT_NSEC")
  let participant_result = envoy.get("PARTICIPANT_NPUBS")
  let relay_result = envoy.get("RELAYS")

  let assert Ok([gemini_api_key, bot_nsec, participant_str, relay_str]) =
    result.all([api_key_result, nsec_result, participant_result, relay_result])

  AppConfig(
    gemini_api_key:,
    bot_nsec:,
    participant_npubs: string_to_list(participant_str),
    relays: string_to_list(relay_str),
  )
}

fn string_to_list(s: String) -> List(String) {
  s
  |> string.split(on: ",")
  |> list.map(string.trim)
}
