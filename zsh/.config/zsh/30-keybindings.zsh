# ── keybindings ───────────────────────────────────────
bindkey -e   # emacs keymap: ^A ^E ^K ^W ^U all behave as expected

# Modus Operandi for ZLE's own UI states. Syntax colors come from
# zsh-syntax-highlighting; these cover native selection, search, paste, suffix,
# and non-printing-character regions that the plugin doesn't own.
zle_highlight=(
  'isearch:fg=#000000,bg=#f2e900'
  'region:fg=#000000,bg=#bdbdbd'
  'paste:fg=#000000,bg=#c4c4c4'
  'suffix:fg=#ffffff,bg=#0031a9'
  'special:fg=#a60000,bold'
)

# Which characters count as "part of a word" for ^W / ⌥B / ⌥F. The default
# includes / and . , which makes ^W eat an entire path in one go; dropping them
# means ^W deletes one path segment at a time.
WORDCHARS='*?_[]~&;!#$%^(){}<>'

# ── movement ──────────────────────────────────────────
bindkey '^[[1;3D' backward-word      # ⌥←
bindkey '^[[1;3C' forward-word       # ⌥→
bindkey '^[[1;5D' backward-word      # ^←  (some terminals send this instead)
bindkey '^[[1;5C' forward-word       # ^→
bindkey '^[b'     backward-word      # ⌥B
bindkey '^[f'     forward-word       # ⌥F
bindkey '^[[H'    beginning-of-line  # Home
bindkey '^[[F'    end-of-line        # End

# ── editing ───────────────────────────────────────────
bindkey '^[[3~'  delete-char         # Del
bindkey '^[^?'   backward-kill-word  # ⌥⌫
bindkey '^[[3;3~' kill-word          # ⌥Del
bindkey '^U'     backward-kill-line  # ^U kills to start of line, not the whole
                                     # line — matches bash and readline

# Drop the current line into a buffer, run something else, get it back on the
# next prompt. Useful when you realise mid-command you need to cd first.
bindkey '^Q' push-line-or-edit

# ^X^E opens the current command line in nvim; save + quit runs it.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# ── history ───────────────────────────────────────────
# ↑/↓ search history for what's already typed before the cursor. atuin takes
# over plain ↑ in 40-integrations.zsh; these stay bound for the escape-sequence
# variants and as a fallback if atuin is unavailable.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^P'   up-line-or-beginning-search
bindkey '^N'   down-line-or-beginning-search

# ── misc ──────────────────────────────────────────────
# ^Z again to resume the job you just suspended, instead of typing `fg`.
function _resume-or-suspend() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER='fg'
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N _resume-or-suspend
bindkey '^Z' _resume-or-suspend
