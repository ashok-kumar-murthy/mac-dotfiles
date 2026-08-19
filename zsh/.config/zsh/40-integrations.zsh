# ── tool integrations ─────────────────────────────────
# Order matters here: whoever binds a key last wins. fzf claims ^R, then atuin
# takes it back — that's intentional, atuin's history search is the better one.

# NVM — Node.js versions and global npm tools.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# SDKMAN — Java, Gradle, and other JVM tools.
export SDKMAN_DIR="${SDKMAN_DIR:-$HOME/.sdkman}"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# direnv — auto-load/unload .envrc when entering a directory.
# Hooked before zoxide so a `cd` always triggers it.
eval "$(direnv hook zsh)"

# zoxide — learns the directories you visit. `cd` still works exactly as before
# for real paths; when the argument isn't a path it jumps to the best match.
#   cd dotfiles   → jumps to the highest-ranked dir matching "dotfiles"
#   cdi           → pick from the ranked list with fzf
eval "$(zoxide init zsh --cmd cd)"

# fzf — ^T insert a file, ⌥C cd somewhere, ^R history (superseded below).
# Also loads fzf's **<TAB> completion trigger: `nvim **<TAB>`, `kill **<TAB>`.
source <(fzf --zsh)

# atuin — full-text searchable, dedup'd, optionally synced shell history.
# Rebinds ^R and ↑ over whatever fzf and our keybindings set.
eval "$(atuin init zsh)"
