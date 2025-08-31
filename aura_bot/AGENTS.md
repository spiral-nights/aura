# Agent Development Guidelines

When creating functions for agents, please ensure that you specify the type of each input parameter and the return value. This helps with clarity and maintainability.

## Example

```javascript
/**
 * @param {string} name - The name of the person to greet.
 * @returns {string} A greeting message.
 */
function greet(name) {
  return `Hello, ${name}!`;
}
```

## Gleam Functions

All public Gleam functions should have a documentation comment.

### Example

```gleam
/// Calculates the sum of two integers.
///
/// ## Examples
///
///   sum(1, 2)
///   // -> 3
///
pub fn sum(a: Int, b: Int) -> Int {
  a + b
}
```
