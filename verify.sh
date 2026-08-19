#!/usr/bin/env bash
# Static and smoke checks for the repository or one package.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE="${1:-all}"
FAILURES=0

pass() { printf 'ok:   %s\n' "$*"; }
fail() {
  printf 'fail: %s\n' "$*" >&2
  FAILURES=$((FAILURES + 1))
}
skip() { printf 'skip: %s\n' "$*"; }

run_check() {
  local description="$1"
  shift
  if "$@"; then pass "$description"; else fail "$description"; fi
}

check_shells() {
  run_check "Bash scripts parse" bash -n "$REPO_DIR/bootstrap.sh" "$REPO_DIR/manage.sh" "$REPO_DIR/verify.sh" "$REPO_DIR/scripts/install-font.sh" "$REPO_DIR/scripts/install-jetbrains-keymap.sh"
  if command -v shellcheck >/dev/null 2>&1; then
    run_check "Shell scripts pass ShellCheck" shellcheck \
      "$REPO_DIR/bootstrap.sh" \
      "$REPO_DIR/manage.sh" \
      "$REPO_DIR/verify.sh" \
      "$REPO_DIR/scripts/install-font.sh" \
      "$REPO_DIR/scripts/install-jetbrains-keymap.sh" \
      "$REPO_DIR/sketchybar/.config/sketchybar/sketchybarrc" \
      "$REPO_DIR"/sketchybar/.config/sketchybar/plugins/*.sh
  else
    skip "shellcheck is unavailable"
  fi
  if command -v zsh >/dev/null 2>&1; then
    run_check "Zsh configuration parses" zsh -n "$REPO_DIR/zsh/.zshenv" "$REPO_DIR/zsh/.config/zsh/.zprofile" "$REPO_DIR/zsh/.config/zsh/.zshrc" "$REPO_DIR"/zsh/.config/zsh/[0-9][0-9]-*.zsh
    run_check "Zsh autosuggestions use Modus Operandi" grep -Fq \
      "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#595959'" \
      "$REPO_DIR/zsh/.config/zsh/90-plugins.zsh"
    run_check "Zsh syntax highlighting uses Modus Operandi" grep -Fq \
      "ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#a60000,bold'" \
      "$REPO_DIR/zsh/.config/zsh/90-plugins.zsh"
    run_check "Zsh line editor uses Modus Operandi" grep -Fq \
      "'region:fg=#000000,bg=#bdbdbd'" \
      "$REPO_DIR/zsh/.config/zsh/30-keybindings.zsh"
    run_check "fzf uses Modus Operandi" grep -Fq -- \
      "export FZF_MODUS_COLORS='fg:#000000,bg:#ffffff" \
      "$REPO_DIR/zsh/.config/zsh/10-exports.zsh"
    run_check "fzf-tab avoids a nested tmux border" grep -Fq \
      '_fzf_tab_border=none' \
      "$REPO_DIR/zsh/.config/zsh/80-fzf-tab.zsh"
    run_check "fzf-tab preview is disabled" grep -Fq \
      "zstyle ':fzf-tab:*' fzf-preview ''" \
      "$REPO_DIR/zsh/.config/zsh/80-fzf-tab.zsh"
    run_check "eza uses Modus Operandi" grep -Fq \
      "export EZA_COLORS='xx=38;2;89;89;89" \
      "$REPO_DIR/zsh/.config/zsh/10-exports.zsh"
    run_check "macOS ls uses Modus Operandi terminal slots" grep -Fq \
      "export LSCOLORS='ExgxfxdxCxdxdxhbhfagad'" \
      "$REPO_DIR/zsh/.config/zsh/10-exports.zsh"
    if command -v gdircolors >/dev/null 2>&1; then
      run_check "LS_COLORS uses Modus Operandi" sh -c \
        'gdircolors -b "$1" | grep -Fq "di=01;38;2;0;49;169"' \
        sh "$REPO_DIR/zsh/.config/zsh/dircolors"
    else
      skip "gdircolors is unavailable for LS_COLORS verification"
    fi
  else
    skip "zsh is unavailable"
  fi
  run_check "SketchyBar scripts parse" sh -n "$REPO_DIR/sketchybar/.config/sketchybar/sketchybarrc" "$REPO_DIR"/sketchybar/.config/sketchybar/plugins/*.sh
}

check_atuin() {
  local theme="$REPO_DIR/atuin/.config/atuin/themes/modus-operandi.toml"
  run_check "Atuin selects the Modus Operandi theme" grep -Fq \
    'name = "modus-operandi"' "$REPO_DIR/atuin/.config/atuin/config.toml"
  run_check "Atuin uses semantic Modus Operandi errors" grep -Fq \
    'AlertError = "#a60000"' "$theme"
}

check_toml() {
  if command -v python3 >/dev/null 2>&1; then
    run_check "AeroSpace and Alacritty TOML parse" python3 -c 'import pathlib,tomllib,sys; [tomllib.loads(pathlib.Path(p).read_text()) for p in sys.argv[1:]]' "$REPO_DIR/aerospace/.aerospace.toml" "$REPO_DIR/alacritty/.config/alacritty/alacritty.toml"
  else
    skip "python3 is unavailable for TOML parsing"
  fi
}

check_git() {
  run_check "Git config parses" git config --file="$REPO_DIR/git/.gitconfig" --list
  if command -v pre-commit >/dev/null 2>&1; then
    run_check "Pre-commit configuration parses" pre-commit validate-config \
      "$REPO_DIR/.pre-commit-config.yaml"
  else
    skip "pre-commit is unavailable"
  fi
}

check_tmux() {
  if command -v tmux >/dev/null 2>&1; then
    local socket="mac-dotfiles-verify-$$"
    if tmux -L "$socket" -f "$REPO_DIR/tmux/.tmux.conf" new-session -d; then
      tmux -L "$socket" kill-server >/dev/null 2>&1 || true
      pass "tmux starts with repository config"
    else
      fail "tmux starts with repository config"
    fi
  else
    skip "tmux is unavailable"
  fi
}

check_powerlevel10k() {
  local config="$REPO_DIR/powerlevel10k/.p10k.zsh"
  if command -v zsh >/dev/null 2>&1; then
    run_check "Powerlevel10k configuration parses" zsh -n "$config"
    run_check "Powerlevel10k configuration loads the tracked layout" zsh -f -c \
      'source "$1"; [[ $POWERLEVEL9K_MODE == nerdfont-v3 && ${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[-1]} == prompt_char ]]' \
      zsh "$config"
    run_check "Powerlevel10k uses the Modus Operandi palette" zsh -f -c \
      'source "$1"; [[ $POWERLEVEL9K_DIR_FOREGROUND == \#005e8b && $POWERLEVEL9K_DIR_ANCHOR_FOREGROUND == \#0031a9 && $POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND == \#006800 && $POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND == \#a60000 && $POWERLEVEL9K_RULER_FOREGROUND == \#595959 ]]' \
      zsh "$config"
    run_check "Every Powerlevel10k segment stays within Modus Operandi" zsh -f -c '
      source "$1"
      local allowed="|#000000|#595959|#a60000|#972500|#006800|#315b00|#6f5500|#884900|#0031a9|#354fcf|#721045|#531ab6|#005e8b|#005f5f|#ffffff|"
      local name value
      for name in ${(k)parameters[(I)POWERLEVEL9K_*_(FOREGROUND|COLOR)]}; do
        value=${(P)name}
        [[ -z $value || $allowed == *"|$value|"* ]] || exit 1
      done
    ' zsh "$config"
  else
    skip "zsh is unavailable for Powerlevel10k verification"
  fi
}

check_nvim() {
  if command -v nvim >/dev/null 2>&1; then
    run_check "Neovim starts headlessly" env XDG_CONFIG_HOME="$REPO_DIR/nvim/.config" nvim --headless +qa
  else
    skip "nvim is unavailable"
  fi
}

check_ideavim() {
  local config="$REPO_DIR/ideavim/.ideavimrc"
  run_check "IdeaVim uses Space as leader" grep -Fxq 'let mapleader=" "' "$config"
  run_check "IdeaVim keeps Space-s for save" grep -Fxq 'nmap <leader>s <Action>(SaveAll)' "$config"
  run_check "IdeaVim enables Which-Key" grep -Fxq 'set which-key' "$config"
  run_check "IdeaVim gives the global focus chord to the IDE" grep -Fxq 'sethandler <C-;> a:ide' "$config"
  if grep -E '^[[:space:]]*(noremap|nnoremap|vnoremap).*<Action>' "$config" >/dev/null; then
    fail "IdeaVim action mappings avoid noremap"
  else
    pass "IdeaVim action mappings avoid noremap"
  fi
}

check_jetbrains() {
  local keymap="$REPO_DIR/jetbrains/keymaps/Ashok.xml"
  local selection="$REPO_DIR/jetbrains/options/keymap.xml"
  if command -v python3 >/dev/null 2>&1; then
    run_check "JetBrains keymap XML parses" python3 -c \
      'import sys, xml.etree.ElementTree as ET; [ET.parse(path) for path in sys.argv[1:]]' \
      "$keymap" "$selection"
  else
    skip "python3 is unavailable for JetBrains keymap XML parsing"
  fi
  run_check "JetBrains focus chord includes Terminal" grep -Fq \
    'first-keystroke="control SEMICOLON" second-keystroke="T"' "$keymap"
}

check_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    run_check "Brewfile parses" brew bundle list --all --file="$REPO_DIR/homebrew/.config/homebrew/Brewfile"
  else
    skip "Homebrew is unavailable"
  fi
}

check_public_safety() {
  if command -v gitleaks >/dev/null 2>&1; then
    run_check "Git history passes Gitleaks" gitleaks git \
      --no-banner --redact "$REPO_DIR"
  else
    skip "gitleaks is unavailable"
  fi
  if command -v rg >/dev/null 2>&1; then
    if rg -n '/Users/[^/$[:space:]]+|BEGIN (RSA |OPENSSH )?PRIVATE KEY|(api[_-]?key|access[_-]?token|client[_-]?secret|password)[[:space:]]*[:=]' "$REPO_DIR" --hidden -g '!.git/**' -g '!verify.sh' >/dev/null; then
      fail "no personal absolute paths or obvious secrets"
    else
      pass "no personal absolute paths or obvious secrets"
    fi
  else
    skip "ripgrep is unavailable for public-safety scan"
  fi
}

check_modes() {
  local script mode_failure=0
  for script in "$REPO_DIR/bootstrap.sh" "$REPO_DIR/manage.sh" "$REPO_DIR/verify.sh" "$REPO_DIR/scripts/install-font.sh" "$REPO_DIR/scripts/install-jetbrains-keymap.sh" "$REPO_DIR"/sketchybar/.config/sketchybar/plugins/*.sh; do
    if [[ ! -x "$script" ]]; then
      fail "executable bit: ${script#$REPO_DIR/}"
      mode_failure=1
    fi
  done
  [[ "$mode_failure" -eq 0 ]] && pass "required scripts are executable"
}

case "$PACKAGE" in
  all)
    check_shells
    check_toml
    check_git
    check_tmux
    check_powerlevel10k
    check_atuin
    check_nvim
    check_ideavim
    check_jetbrains
    check_homebrew
    check_public_safety
    check_modes
    ;;
  zsh | sketchybar) check_shells ;;
  aerospace | alacritty) check_toml ;;
  git) check_git ;;
  tmux) check_tmux ;;
  nvim) check_nvim ;;
  ideavim) check_ideavim ;;
  jetbrains) check_jetbrains ;;
  homebrew) check_homebrew ;;
  powerlevel10k)
    check_powerlevel10k
    check_public_safety
    ;;
  atuin)
    check_atuin
    check_public_safety
    ;;
  bat | ripgrep | sesh | tealdeer) check_public_safety ;;
  *)
    printf 'unknown package: %s\n' "$PACKAGE" >&2
    exit 2
    ;;
esac

[[ "$FAILURES" -eq 0 ]] || exit 1
