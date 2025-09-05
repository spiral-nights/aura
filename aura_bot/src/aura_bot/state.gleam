import aura_bot/agent/types
import aura_bot/config
import gleam/dict

pub type State {
  State(
    config: config.AppConfig,
    agents_by_thread: dict.Dict(String, types.Agent),
  )
}

/// Add the agent to the given thread in the application state
///
/// ## Parameters
/// - `sender_sk`: The sender's private key as an ArrayBuffer.
/// - `recipient_pk`: The recipient's public key as a hex string.
///
/// ### Returns
/// - The updated application state
pub fn add_agent_to_thread(
  agent: types.Agent,
  thread_id: String,
  state: State,
) -> State {
  let agents_by_thread =
    state.agents_by_thread
    |> dict.insert(for: thread_id, insert: agent)
  State(..state, agents_by_thread:)
}

@external(javascript, "../externals/state_ffi.mjs", "saveState")
pub fn save_state(state: State) -> Nil

@external(javascript, "../externals/state_ffi.mjs", "loadState")
pub fn load_state() -> State
