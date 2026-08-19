# ── plugins — this file must stay LAST ────────────────
# Both of these work by wrapping ZLE widgets. Anything that defines a widget
# has to run before them, or it won't be highlighted / suggested against.

# ── zsh-autosuggestions ───────────────────────────────
# Greys out a completion of the current line as you type; → or ^Space accepts.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Modus Operandi fg-dim: visibly secondary while remaining legible on bg-main.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#595959'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20   # don't suggest against huge pasted lines
# ⌥→ accepts just the next word of the suggestion instead of all of it
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(forward-word emacs-forward-word)

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey '^ ' autosuggest-accept      # ^Space — accept the whole suggestion
bindkey '^[^M' autosuggest-execute   # ⌥⏎    — accept and run it

# ── zsh-syntax-highlighting — genuinely last ──────────
# Colours the command line live: valid commands green, unknown ones red,
# unclosed quotes/brackets flagged before you hit enter.
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=512          # skip highlighting on very long lines

# Modus Operandi semantic roles. Set these before loading the plugin; its
# defaults only fill entries that haven't already been defined.
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=#000000'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#a60000,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#721045,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#006800'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#006800,underline'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#005e8b'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#0031a9'
ZSH_HIGHLIGHT_STYLES[function]='fg=#006800'
ZSH_HIGHLIGHT_STYLES[command]='fg=#006800'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#0031a9,underline'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#6f5500'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#005e8b,underline'
ZSH_HIGHLIGHT_STYLES[path]='fg=#005e8b,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#0031a9,bold'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#721045'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#354fcf'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#354fcf'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#721045'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#721045'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#721045'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#0031a9'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#6f5500'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#005f5f'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#6f5500'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#595959,italic'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#884900'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#884900'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#006800'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#0031a9,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#721045,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#005f5f,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=#6f5500,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=#354fcf,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-6]='fg=#531ab6,bold'
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=#a60000,bold'
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='fg=#ffffff,bg=#0031a9,bold'

source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
