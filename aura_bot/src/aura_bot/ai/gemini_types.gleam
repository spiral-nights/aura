import gleam/json
import gleam/option.{type Option}

pub type GenerateContentParameters {
  GenerateContentParameters(
    config: Option(GenerateContentConfig),
    contents: ContentListUnion,
    model: Model,
  )
}

/// Convert GenerateContentParameters into a JSON value suitable for the JS API.
///
/// ## Parameters
/// - `generate_content_parameters`: Parameters describing the request to generate content.
///
/// ## Returns
/// - A gleam json.Json representation of the parameters.
pub fn generate_content_parameters_to_json(
  generate_content_parameters: GenerateContentParameters,
) -> json.Json {
  let GenerateContentParameters(config:, contents:, model:) =
    generate_content_parameters
  json.object([
    #("config", case config {
      option.None -> json.null()
      option.Some(value) -> generate_content_config_to_json(value)
    }),
    #("contents", content_list_union_to_json(contents)),
    #("model", model_to_json(model)),
  ])
}

/// https://googleapis.github.io/js-genai/release_docs/types/types.ContentListUnion.html
pub type ContentListUnion {
  CluContents(List(Content))
  CluParts(List(PartUnion))
}

fn content_list_union_to_json(content: ContentListUnion) -> json.Json {
  case content {
    CluContents(content_list) -> json.array(content_list, content_to_json)
    CluParts(pu_list) -> json.array(pu_list, part_union_to_json)
  }
}

/// https://googleapis.github.io/js-genai/release_docs/types/types.ContentUnion.html
pub type ContentUnion {
  CuContent(Content)
  CuPartUnion(List(PartUnion))
}

fn content_union_to_json(value: ContentUnion) -> json.Json {
  case value {
    CuContent(content) -> content_to_json(content)
    CuPartUnion(pu) -> json.array(pu, part_union_to_json)
  }
}

/// https://googleapis.github.io/js-genai/release_docs/interfaces/types.Content.html
pub type Content {
  Content(parts: Option(List(Part)), role: Option(Role))
}

fn content_to_json(content: Content) -> json.Json {
  let Content(parts:, role:) = content
  json.object([
    #("parts", case parts {
      option.None -> json.null()
      option.Some(value) -> json.array(value, part_to_json)
    }),
    #("role", case role {
      option.None -> json.null()
      option.Some(value) -> role_to_json(value)
    }),
  ])
}

pub type Role {
  User
  Model
}

fn role_to_json(role: Role) -> json.Json {
  case role {
    User -> json.string("user")
    Model -> json.string("model")
  }
}

pub type Model {
  Flash
  Pro
}

fn model_to_json(model: Model) -> json.Json {
  case model {
    Flash -> json.string("gemini-2.5-flash")
    Pro -> json.string("gemini-2.5-pro")
  }
}

pub type PartUnion {
  PuPart(Part)
  PuString(String)
}

pub fn part_union_string(value: String) -> PartUnion {
  PuString(value)
}

fn part_union_to_json(part_union: PartUnion) -> json.Json {
  case part_union {
    PuPart(part) -> part_to_json(part)
    PuString(str) -> json.string(str)
  }
}

pub type Part {
  Part(text: String)
}

fn part_to_json(part: Part) -> json.Json {
  let Part(text:) = part
  json.object([
    #("text", json.string(text)),
  ])
}

/// https://googleapis.github.io/js-genai/release_docs/interfaces/types.GenerateContentConfig.html
pub opaque type GenerateContentConfig {
  /// ## Parameters
  /// - `system_instruction`: The system instruction
  GenerateContentConfig(system_instruction: Option(ContentUnion))
}

/// Generate the configuration for the Gemini AI model
pub fn generate_content_config(
  system_instruction: String,
) -> GenerateContentConfig {
  GenerateContentConfig(
    option.Some(
      CuPartUnion([
        PuString(system_instruction),
      ]),
    ),
  )
}

fn generate_content_config_to_json(
  generate_content_config: GenerateContentConfig,
) -> json.Json {
  let GenerateContentConfig(system_instruction:) = generate_content_config
  json.object([
    #("system_instruction", case system_instruction {
      option.None -> json.null()
      option.Some(value) -> content_union_to_json(value)
    }),
  ])
}
