#!/usr/bin/env bash
# Link the shared custom keymap into the newest local config for each JetBrains IDE.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_ROOT="${JETBRAINS_CONFIG_ROOT:-$HOME/Library/Application Support/JetBrains}"
KEYMAP_SOURCE="$REPO_DIR/jetbrains/keymaps/Ashok.xml"
SELECTION_SOURCE="$REPO_DIR/jetbrains/options/keymap.xml"
INSTALLED=0
SKIPPED=0

is_running() {
  local prefix="$1" executable
  case "$prefix" in
    IntelliJIdea) executable='/IntelliJ IDEA.app/Contents/MacOS/idea' ;;
    PyCharm) executable='/PyCharm.app/Contents/MacOS/pycharm' ;;
    WebStorm) executable='/WebStorm.app/Contents/MacOS/webstorm' ;;
    DataGrip) executable='/DataGrip.app/Contents/MacOS/datagrip' ;;
    *) return 1 ;;
  esac
  pgrep -f "$executable" >/dev/null 2>&1
}

link_config() {
  local source="$1" target="$2"
  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    printf 'already linked: %s\n' "$target"
    return 0
  fi
  if [[ -e "$target" || -L "$target" ]]; then
    printf 'refusing to replace existing config: %s\n' "$target" >&2
    return 1
  fi
  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  printf 'linked: %s\n' "$target"
}

for prefix in IntelliJIdea PyCharm WebStorm DataGrip; do
  latest=""
  for candidate in "$CONFIG_ROOT/$prefix"*; do
    [[ -d "$candidate" ]] || continue
    latest="$candidate"
  done
  if [[ -z "$latest" ]]; then
    printf 'not initialized: %s\n' "$prefix"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi
  if is_running "$prefix"; then
    printf 'close before installing: %s\n' "$prefix"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi
  link_config "$KEYMAP_SOURCE" "$latest/keymaps/Ashok.xml"
  link_config "$SELECTION_SOURCE" "$latest/options/keymap.xml"
  INSTALLED=$((INSTALLED + 1))
done

printf 'installed: %d; skipped: %d\n' "$INSTALLED" "$SKIPPED"
