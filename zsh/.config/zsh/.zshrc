# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.config/zsh/.zshrc — interactive shells only.
#
# Load order, and why it matters:
#   1. fpath additions      — must precede compinit, which oh-my-zsh runs
#   2. oh-my-zsh            — runs compinit, defines its aliases/widgets
#   3. ~/.config/zsh/*.zsh  — our config, numbered, sourced in order
#   4. 90-plugins.zsh       — last file in that loop; syntax highlighting has to
#                             wrap every widget defined above it

: ${HOMEBREW_PREFIX:=/opt/homebrew}   # fallback if this isn't a login shell

# ── completion search path ────────────────────────────
# Anything we generate by hand (rustup, sesh, ...) lands here. Homebrew's
# site-functions is already on fpath courtesy of `brew shellenv`.
fpath=(
  $XDG_DATA_HOME/zsh/completions(N)
  $HOMEBREW_PREFIX/share/zsh/site-functions(N)
  $fpath
)

# ── oh-my-zsh ─────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

# Empty on purpose: the Homebrew-installed Powerlevel10k theme is sourced by
# 70-prompt.zsh. It doesn't live in Oh My Zsh's theme directory.
ZSH_THEME=""

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

# Deliberately short. Runtime managers, fzf, zoxide, and direnv are initialised in
# 40-integrations.zsh so their load order is explicit and controllable, and
# colored-man-pages is redundant now that bat is the man pager.
plugins=(
  git       # the g* alias family + git completion
  macos     # ofd, pfd, quick-look, cdf, showfiles
  extract   # `x <any archive>`
)

# Keep OMZ's generated completion dump out of the config dir — it's a cache,
# not config, and it's regenerated whenever fpath changes.
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-${SHORT_HOST:-$HOST}-${ZSH_VERSION}"

source $ZSH/oh-my-zsh.sh

# ── our config ────────────────────────────────────────
# Numeric prefixes give a deterministic order; (N) keeps an empty dir quiet.
for _zfile in $ZDOTDIR/[0-9][0-9]-*.zsh(N); do
  source "$_zfile"
done
unset _zfile

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
