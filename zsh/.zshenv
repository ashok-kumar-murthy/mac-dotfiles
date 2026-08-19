# ~/.zshenv — sourced by EVERY zsh: login, interactive, and scripts alike.
# Keep this file tiny and side-effect free. Anything slow or interactive-only
# belongs in .zshrc; anything PATH-shaped belongs in .zprofile.

# XDG base directories. Set here (not .zprofile) so non-interactive scripts and
# tools launched outside a login shell still find their config.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# From here on zsh reads .zprofile / .zshrc / .zlogin out of ~/.config/zsh
# instead of $HOME. This file is the only zsh dotfile left in the home dir —
# zsh hardcodes its location, so it cannot move.
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
. "$HOME/.cargo/env"
