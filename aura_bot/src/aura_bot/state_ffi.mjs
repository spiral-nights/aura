let appState = null;

export function saveState(state) {
  appState = state;
  return appState;
}

export function loadState() {
  return appState;
}
