# ── prompt: Powerlevel10k ─────────────────────────────
# Installed by Homebrew; the tracked configuration is linked to ~/.p10k.zsh.
# Load after Oh My Zsh and before the ZLE-wrapping plugins in 90-plugins.zsh.
_p10k_theme="$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"

if [[ -r "$_p10k_theme" ]]; then
  source "$_p10k_theme"
  [[ ! -r "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
else
  print -u2 "Powerlevel10k is not installed; run: brew bundle --file=$XDG_CONFIG_HOME/homebrew/Brewfile"
fi

unset _p10k_theme
