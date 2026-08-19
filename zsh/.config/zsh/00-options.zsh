# ── shell options ─────────────────────────────────────
# `man zshoptions` for the full list.

# ── directories ───────────────────────────────────────
setopt AUTO_CD              # a bare `src/` cds into it
setopt AUTO_PUSHD           # every cd pushes onto the dir stack, so `cd -<TAB>`
setopt PUSHD_IGNORE_DUPS    # ...without the same dir appearing twice
setopt PUSHD_SILENT         # ...and without printing the stack every time

# ── globbing ──────────────────────────────────────────
setopt EXTENDED_GLOB        # ^ ~ # operators: `ls ^*.md`, `ls **/*.ts~*test*`
setopt GLOB_DOTS            # * matches dotfiles too
setopt NUMERIC_GLOB_SORT    # file2 sorts before file10
unsetopt NOMATCH            # a pattern with no matches is passed through
                            # literally instead of erroring — this is what keeps
                            # `git show HEAD^` working under EXTENDED_GLOB

# ── history ───────────────────────────────────────────
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000             # entries kept in memory
SAVEHIST=100000             # entries written to disk
mkdir -p "${HISTFILE:h}"

setopt EXTENDED_HISTORY       # record timestamp + duration per entry
setopt SHARE_HISTORY          # live-share history between open shells
setopt HIST_EXPIRE_DUPS_FIRST # trim duplicates before unique entries
setopt HIST_IGNORE_ALL_DUPS   # a repeated command moves, it doesn't accumulate
setopt HIST_IGNORE_SPACE      # leading space keeps a command out of history
setopt HIST_FIND_NO_DUPS      # searching never shows the same line twice
setopt HIST_REDUCE_BLANKS     # tidy up whitespace before storing
setopt HIST_VERIFY            # !! expands into the buffer for review, no
                              # surprise execution

# ── completion ────────────────────────────────────────
setopt ALWAYS_TO_END        # completing mid-word leaves the cursor at the end
setopt COMPLETE_IN_WORD     # complete from the cursor, not just end of word
setopt AUTO_MENU            # a second <TAB> starts cycling matches
unsetopt MENU_COMPLETE      # ...but the first <TAB> never auto-inserts one
unsetopt FLOW_CONTROL       # frees ^S and ^Q for keybindings

# ── misc ──────────────────────────────────────────────
setopt INTERACTIVE_COMMENTS # `# ...` is a comment when typed interactively
setopt MULTIOS              # `cmd > a > b` tees to both
setopt LONG_LIST_JOBS       # `jobs` in the verbose format
setopt NO_BEEP
setopt NO_CLOBBER           # `>` won't overwrite an existing file; use `>|`
