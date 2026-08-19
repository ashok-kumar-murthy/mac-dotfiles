# ── eza (replaces ls) ────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --git --group-directories-first'
alias la='eza -lah --icons --git --group-directories-first'
alias lt='eza --tree --icons --level=2 --git-ignore'
alias lm='eza -lh --icons --git --sort=modified'
alias lsize='eza -lh --icons --sort=size --reverse'
alias tree='eza --tree --icons --git-ignore'

# ── bat (replaces cat) ───────────────────────────────
alias cat='bat --paging=never'
alias catp='bat'                       # paged, for when you want to scroll
alias catn='bat --style=plain'         # no line numbers/git gutter — copy-friendly

# ── fd / rg ───────────────────────────────────────────
alias fda='fd --hidden --no-ignore'    # include dotfiles and .gitignore'd paths
alias rga='rg --hidden --no-ignore'

# ── git ───────────────────────────────────────────────
# (oh-my-zsh's git plugin already supplies the big g* family; these are the
#  handful worth overriding or adding)
alias lg='lazygit'
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gll='git log --oneline --graph --decorate --all'
alias gsw='git switch'
alias gundo='git reset --soft HEAD~1'  # uncommit, keep the changes staged
alias gwt='git worktree'

# ── github / gitlab ───────────────────────────────────
alias ghpr='gh pr list'
alias ghprc='gh pr create --web'
alias ghv='gh repo view --web'
alias ghrun='gh run watch'
alias glmr='glab mr list'

# ── tmux / sesh ───────────────────────────────────────
alias t='tmux'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
alias tk='tmux kill-session -t'
alias s='sesh connect'

# ── containers ────────────────────────────────────────
alias lzd='lazydocker'

# ── system ────────────────────────────────────────────
alias top='btop'
alias du='dust'
alias df='duf'
alias ports='lsof -i -P -n | grep LISTEN'
alias path='print -l $path'            # one PATH entry per line
alias ip='ipconfig getifaddr en0'
alias myip='xh -b https://ifconfig.me'

# ── files / viewers ───────────────────────────────────
alias md='glow --pager'                # render markdown in the terminal
alias jl='jless'                       # interactive JSON/YAML explorer
alias yl='jless --yaml'
alias jqp='jq -C . | less -R'          # pretty + paged JSON

# ── http ──────────────────────────────────────────────
alias http='xh'
alias https='xhs'
alias GET='xh GET'
alias POST='xh POST'

# ── ssh / db ──────────────────────────────────────────
alias ssh-pick='sshs'                  # fuzzy-pick a host from ~/.ssh/config
alias pg='pgcli'

# ── docs ──────────────────────────────────────────────
alias help='tldr'                      # tealdeer: practical examples, not man
alias tldru='tldr --update'

# ── formatting ────────────────────────────────────────
alias fmtsh='shfmt -w -i 2 -ci'
alias fmtlua='stylua'

# ── editor ────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias nv='nvim'

# ── homebrew ──────────────────────────────────────────
alias bi='brew install'
alias bs='brew search'
alias bu='brew update && brew upgrade && brew cleanup'
alias bl='brew leaves'                 # only what you asked for, not deps
alias bdump='brew bundle dump --force'   # writes $HOMEBREW_BUNDLE_FILE

# ── general quality of life ──────────────────────────
alias reload='exec zsh'                # full restart; `source` leaves stale state
alias zshrc='$EDITOR $ZDOTDIR/.zshrc'
alias zconf='cd $ZDOTDIR && $EDITOR .'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'                      # back to the previous directory
alias mkdir='mkdir -p'
alias watch='watchexec'
alias ff='onefetch'                    # repo summary, like neofetch for git

# ── global aliases ────────────────────────────────────
# These expand at ANY word position, not just in command position — which is
# what makes them useful and also what makes them dangerous. A bare `G` as a
# loop item or a make variable would expand too, so the single-letter names are
# kept to ones that never show up as a plain argument. Two-char names for the
# rest, for the same reason.
alias -g L='| less'
alias -g J='| jq'
alias -g Y='| yq'
alias -g RG='| rg'
alias -g HD='| head -20'
alias -g TL='| tail -20'
alias -g CP='| pbcopy'
alias -g NE='2>/dev/null'
alias -g NUL='>/dev/null 2>&1'

# ── suffix aliases ────────────────────────────────────
# Typing a bare filename opens it in the right tool.
alias -s {json,yaml,yml}=jless
# md is in the nvim list, not on glow: markdown is edited far more often than
# it is skimmed, and `md <file>` above still renders it read-only.
alias -s {md,ts,tsx,js,jsx,py,rs,go,lua,sh,zsh,toml}=nvim
