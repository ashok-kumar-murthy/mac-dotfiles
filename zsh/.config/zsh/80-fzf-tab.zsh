# ── fzf-tab ───────────────────────────────────────────
# Replaces zsh's built-in completion menu with an fzf picker, with previews.
# Load order is strict: AFTER compinit (oh-my-zsh runs it in .zshrc) and BEFORE
# anything that wraps ZLE widgets — hence 80, immediately ahead of 90-plugins.

source $HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh

# oh-my-zsh sets `zstyle ':completion:*:*:*:*:*' menu select`. zstyle resolves by
# pattern specificity, not load order, so that five-segment pattern beats the
# `menu no` in 20-completion.zsh no matter what loads later — and fzf-tab then
# can't capture the unambiguous prefix. Delete OMZ's entry outright.
zstyle -d ':completion:*:*:*:*:*' menu

# Reuse standalone fzf's Modus palette without inheriting its 60% height and
# border. fzf-tab and its tmux helper calculate their own dimensions.
zstyle ':fzf-tab:*' use-fzf-default-opts no
_fzf_tab_border=rounded

# < and > cycle between completion groups (files vs directories vs flags).
zstyle ':fzf-tab:*' switch-group '<' '>'

# Keep completing without leaving fzf: / accepts the current match and
# immediately re-completes, so you can walk a deep path in one session.
zstyle ':fzf-tab:*' continuous-trigger '/'

# ^Space marks multiple matches (git add of several files, rm of several paths).
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-space:toggle+down'

zstyle ':fzf-tab:*' fzf-min-height 15
zstyle ':fzf-tab:*' prefix ''        # drop the leading '·' marker

# In tmux, float the picker in a popup instead of pushing the pane's scrollback.
if [[ -n $TMUX ]]; then
  zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  zstyle ':fzf-tab:*' popup-min-size 90 15
  # tmux already draws the popup border; don't draw another full box inside it.
  _fzf_tab_border=none
fi

_fzf_tab_flags=(
  "--color=$FZF_MODUS_COLORS"
  "--border=$_fzf_tab_border"
  --info=inline
  '--prompt=❯ '
  '--pointer=▸'
  '--marker=✓'
)
zstyle ':fzf-tab:*' fzf-flags "${_fzf_tab_flags[@]}"
unset _fzf_tab_border _fzf_tab_flags

# No preview pane: completion stays a single clean list inside the tmux popup.
zstyle ':fzf-tab:*' fzf-preview ''

# branch order is meaningful (most recent first) — don't let zsh re-sort it
zstyle ':completion:*:git-(checkout|switch):*' sort false
