export function waitForever() {
  setInterval(
    () => {
      // This empty function keeps the event loop active
    },
    1000 * 60 * 60,
  ); // Check every hour, for example, to prevent excessive CPU usage

  return null;
}

export function currentTimeSeconds() {
  return Math.round(new Date().getTime() / 1000);
}
