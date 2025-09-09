import aura_bot/agent/types
import aura_bot/config
import gleam/dict

pub type State {
  State(
    config: config.AppConfig,
    agents_by_thread: dict.Dict(String, types.Agent),
  )
}

/// Update the state of the thread with the agent
///
/// ## Parameters
/// - `state`: The application state
/// - `thread_id`: The ID of the thread to update
/// - `agent`: The agent to assign with the given thread
///
/// ### Returns
/// - The updated application state
pub fn assign_agent_to_thread(
  state: State,
  thread_id: String,
  agent: types.Agent,
) -> State {
  state.agents_by_thread
  |> dict.insert(for: thread_id, insert: agent)
  |> fn(agents_by_thread) { State(..state, agents_by_thread:) }
}

@external(javascript, "./state_ffi.mjs", "saveState")
pub fn save_state(state: State) -> State

@external(javascript, "./state_ffi.mjs", "loadState")
pub fn load_state() -> State
