# ── completion styling ────────────────────────────────
# oh-my-zsh has already run compinit by the time this file loads; the guard
# below only matters if OMZ is ever dropped from .zshrc.
if ! (( $+functions[compdef] )); then
  autoload -Uz compinit
  mkdir -p "$XDG_CACHE_HOME/zsh"
  compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
fi

zmodload -i zsh/complist   # provides the menuselect keymap used below

# Colour file completions the same way eza/ls colours them. The tracked
# dircolors file uses true-color Modus Operandi roles rather than GNU defaults.
if (( $+commands[gdircolors] )); then
  eval "$(gdircolors -b "$ZDOTDIR/dircolors")"
fi

# No built-in menu: fzf-tab (80-fzf-tab.zsh) intercepts completion and renders
# it in fzf instead. It can only do that if zsh doesn't open its own menu first
# — with `menu select` here, fzf-tab silently never engages.
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Match leniently, in escalating order of desperation:
#   1. exact  2. case-insensitive  3. partial-word (fb -> foo_bar)  4. substring
zstyle ':completion:*' matcher-list \
  '' \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# Group matches by type with a labelled header for each group. fzf-tab reads
# this format to build its groups, and needs a plain `%d` to parse them — the
# fancier bordered version breaks group switching with < and >.
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:messages'     format '%F{#721045}%d%f'
zstyle ':completion:*:warnings'     format '%F{#a60000}no matches for %d%f'
zstyle ':completion:*:corrections'  format '%F{#006800}%d (errors: %e)%f'

# Cache the expensive completions (brew, apt-style tools) on disk.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

zstyle ':completion:*' verbose true
zstyle ':completion:*' squeeze-slashes true   # a//b completes as a/b
zstyle ':completion:*' special-dirs true      # offer . and .. where they help

# Don't offer the current directory back to `cd ..`
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# Don't re-offer a filename already present on the line
zstyle ':completion:*:(rm|cp|mv|diff|delta):*' ignore-line other

# Processes: complete against real ps output, highlight the PID.
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# man pages grouped by section rather than one giant list
zstyle ':completion:*:manuals' separate-sections true

# ssh/scp: hosts from ~/.ssh/config, not from a stale /etc/hosts
zstyle ':completion:*:(ssh|scp|sftp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain'
zstyle ':completion:*:(ssh|scp|sftp|rsync):*:hosts-host' ignored-patterns \
  '*(.|:)*' loopback localhost broadcasthost

# Fallback bindings for zsh's native menu. Unused while fzf-tab is active — it
# never enters the menuselect keymap — but they make the shell usable if
# 80-fzf-tab.zsh is ever commented out.
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^@' accept-and-infer-next-history
