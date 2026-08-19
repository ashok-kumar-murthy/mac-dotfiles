# ~/.config/zsh/.zprofile — login shells only.
#
# PATH lives here rather than .zshrc on purpose: .zshrc runs for every nested
# interactive shell (tmux panes, subshells, `zsh` inside `zsh`), and prepending
# to PATH there means the same directories pile up over and over. A login shell
# runs this once and every child inherits the result.

# Homebrew. Runs after /etc/zprofile's path_helper, so brew's bin wins over the
# system copies of anything it shadows (git, ruby, python...).
eval "$(/opt/homebrew/bin/brew shellenv)"

# `path` is zsh's array view of $PATH; -U keeps it deduplicated automatically.
typeset -U path PATH

path=(
  $HOME/.local/bin          # pipx, uv, and anything hand-dropped
  $HOME/.cargo/bin          # rustup toolchains
  $HOME/go/bin              # `go install` targets
  $path
)

# ── Go ────────────────────────────────────────────────
export GOPATH="$HOME/go"

# ── Rust ──────────────────────────────────────────────
export RUSTUP_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"

# Drop any entries that do not actually exist, so PATH stays honest.
path=($^path(N-/))
export PATH
