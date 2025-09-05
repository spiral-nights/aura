let appState = null;

export function saveState(state) {
  appState = state;
}

export function loadState() {
  return appState;
}
