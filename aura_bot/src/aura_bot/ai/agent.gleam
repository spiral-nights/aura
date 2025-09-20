import aura_bot/ai/gemini_types.{
  type Role, CluContents, Content, CuPartUnion, Flash, GenerateContentConfig,
  GenerateContentParameters, Model, Part, PuString, User,
  generate_content_parameters_to_json,
}
import aura_bot/nostr
import aura_bot/nostr/key.{type HexKey, type Public}
import gleam/javascript/promise.{type Promise}
import gleam/json
import gleam/list
import gleam/option

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
  let config =
    GenerateContentConfig(
      option.Some(
        CuPartUnion([
          PuString(
            "A user is trying to chat with you. Please do what they ask.",
          ),
        ]),
      ),
    )
    |> option.Some

  let parts =
    agent.messages
    |> list.map(fn(msg) { #(msg.content, get_role_for_msg(msg.pubkey, agent)) })
    |> list.append([#(message, User)])
    |> list.map(fn(msg_and_role) {
      let role = option.Some(msg_and_role.1)
      Content(parts: option.Some([Part(msg_and_role.0)]), role:)
    })

  let contents = CluContents(parts)

  let parameters = GenerateContentParameters(config:, contents:, model: Flash)
  generate_content(
    agent.google_gen_ai,
    generate_content_parameters_to_json(parameters),
  )
}

fn get_role_for_msg(hex_public_key: String, agent: Agent) -> Role {
  case hex_public_key == agent.public_key.value {
    True -> Model
    False -> User
  }
}

@external(javascript, "./agent_ffi.mjs", "googleGenAI")
fn google_gen_ai(api_key: String) -> GoogleGenAI

@external(javascript, "./agent_ffi.mjs", "generateContent")
fn generate_content(
  google_gen_ai: GoogleGenAI,
  params: json.Json,
) -> Promise(String)
