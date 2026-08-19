# ── editor ────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

# ── pager ─────────────────────────────────────────────
# -R keep colours · -i smart-case search · -M verbose status line
# -F quit if it fits on one screen · -X don't wipe the screen on exit
# (-F and -X together mean short output just stays printed in the scrollback)
export PAGER="less"
export LESS="-R -i -M -F -X"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# man pages rendered by bat: syntax colours + the same theme as everything else
export MANPAGER="sh -c 'col -bx | bat --language man --plain'"
export MANROFFOPT="-c"

# ── fzf ───────────────────────────────────────────────
# fd instead of find: respects .gitignore, and it's an order of magnitude faster
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# Shared by standalone fzf and fzf-tab. Layout options stay separate because
# fzf-tab's tmux helper owns its popup dimensions and outer border.
export FZF_MODUS_COLORS='fg:#000000,bg:#ffffff,fg+:#000000,bg+:#bdbdbd,hl:#721045,hl+:#531ab6,info:#005e8b,border:#9f9f9f,prompt:#0031a9,pointer:#a60000,marker:#006800,spinner:#6f5500,header:#005e8b,query:#000000,gutter:#ffffff'
export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border=rounded
  --info=inline
  --color='$FZF_MODUS_COLORS'
  --prompt='❯ '
  --pointer='▸'
  --marker='✓'
  --cycle
  --bind='ctrl-/:toggle-preview'
  --bind='ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'
  --bind='ctrl-a:select-all,ctrl-x:deselect-all'
  --bind='ctrl-y:execute-silent(printf %s {} | pbcopy)+abort'
"

# ^T — insert a file path, previewed with bat
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --preview='bat --style=numbers --color=always --line-range=:300 {}'
  --preview-window=right:60%
"

# ⌥C — cd into a directory, previewed as a tree
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="
  --preview='eza --tree --icons --level=2 --color=always {}'
  --preview-window=right:60%
"

# ── eza / ls ─────────────────────────────────────────
# Additional eza-only roles layered over the shared LS_COLORS file loaded by
# 20-completion.zsh. All values come from the Modus Operandi terminal palette.
export EZA_COLORS='xx=38;2;89;89;89:da=38;2;89;89;89:hd=1;38;2;0;49;169:lp=38;2;0;94;139:cc=38;2;166;0;0:bO=1;38;2;166;0;0:im=38;2;114;16;69:vi=38;2;83;26;182:mu=38;2;0;94;139:lo=38;2;0;95;95:cr=38;2;0;104;0:do=38;2;0;49;169:co=38;2;151;37;0:tm=2;38;2;89;89;89:cm=38;2;111;85;0:bu=4;38;2;136;73;0:sc=38;2;0;94;139'
# Native macOS /bin/ls fallback; these ANSI slots resolve to the same Operandi
# colors in Alacritty. Normal `ls` still uses eza through 50-aliases.zsh.
export CLICOLOR=1
export LSCOLORS='ExgxfxdxCxdxdxhbhfagad'

# ── ripgrep ───────────────────────────────────────────
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# ── homebrew ──────────────────────────────────────────
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile"

# ── keep $HOME from collecting dotfiles ───────────────
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node/repl_history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite/history"
