# Aura Bot

A bot that runs on NOSTR and replies to messages using AI.

## Overview

Aura Bot listens for messages from a specific set of users on the NOSTR network. When a message is received, it uses an AI to generate a reply and sends it back to the user.

This project is built with [Gleam](https://gleam.run) and compiles to JavaScript. It uses the [nostr-tools](https://github.com/nostr-protocol/nostr-tools) library for NOSTR operations.

## Development

To get started, you'll need to have [Bun](https://bun.sh/) installed.

1. Install dependencies:
   ```sh
   bun install
   ```

2. Run the project:
   ```sh
   gleam run
   ```

3. Run the tests:
   ```sh
   gleam test
   ```