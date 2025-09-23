# Aura Bot

A bot that runs on NOSTR and replies to messages using AI.

## Overview

Aura Bot listens for messages from a specific set of users on the NOSTR network. When a message is received, it uses an AI to generate a reply and sends it back to the user.

This project is built with [Gleam](https://gleam.run) and compiles to JavaScript. It uses the [nostr-tools](https://github.com/nostr-protocol/nostr-tools) library for NOSTR operations.

## Configuration

The bot is configured using environment variables. You can create a `.env` file in the root of the project to store these variables.

-   `GEMINI_API_KEY`: Your Gemini API key.
-   `BOT_NSEC`: The bot's private key in `nsec` format.
-   `PARTICIPANT_NPUBS`: A comma-separated list of `npub`s of the users who are allowed to interact with the bot.
-   `RELAYS`: A comma-separated list of relays to connect to.
-   `PUBLISH_MESSAGES`: Set to `true` to send messages to the relays. Set to `false` for local development to print messages to the console.

## Architecture

The project is structured into several modules:

-   `aura_bot.gleam`: The main entry point of the application. It initializes the bot, connects to the relays, and listens for messages.
-   `nostr.gleam`: Handles the decoding of Nostr events.
-   `ai.gleam`: Manages the interaction with the AI, sending messages and receiving replies.
-   `config.gleam`: Reads and parses the application configuration from environment variables.
-   `state.gleam`: Manages the application state, including the agents for each chat thread.

## Development

To get started, you'll need to have [Bun](https://bun.sh/) installed.

1.  Install dependencies:
    ```sh
    bun install
    ```

2.  Create a `.env` file and add the required environment variables (see the "Configuration" section).

3.  Run the project:
    ```sh
    gleam run
    ```

4.  Run the tests:
    ```sh
    gleam test
    ```
