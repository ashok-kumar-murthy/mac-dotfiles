# JetBrains keyboard model

IdeaVim provides the editor-focused Space leader. The `Ashok` native keymap
provides one cross-context chord for places where IdeaVim does not receive
keystrokes, including Terminal and the CC GUI webview.

## Cross-context focus

Press `Ctrl-;`, release it, then press the destination key.

| Keys | Destination |
| --- | --- |
| `Ctrl-; E` | Editor |
| `Ctrl-; T` | Terminal |
| `Ctrl-; A` | CC GUI |
| `Ctrl-; G` | Commit |
| `Ctrl-; P` | Project |
| `Ctrl-; R` | Run |
| `Ctrl-; D` | Debug |
| `Ctrl-; X` | Problems |

Run `./scripts/install-jetbrains-keymap.sh` while the IDEs are closed. The
script links the keymap and its selection file into the newest initialized
IntelliJ IDEA, PyCharm, WebStorm, and DataGrip configuration directories.

## Space leader

| Keys | Action |
| --- | --- |
| `Space s` | Save all |
| `Space e` | Project tool window |
| `Space q` | Close editor tab |
| `Space f f/g/b/h/r/w` | File/text/buffer/action/recent/usage search |
| `Space b b/n/p/d/o/u` | Choose/next/previous/close/only/reopen editor tab |
| `Space w s/v/h/j/k/l/w/c/o/=` | Split and navigate editors |
| `Space c a/f/o/r/m/d` | Intention/format/imports/rename/refactor/definition |
| `Space x x/n/p/f/l` | Problems/next/previous/quick-fix/details |
| `Space u w/l/n/i/z/f` | Wrap/whitespace/numbers/inlays/zen/full-screen |

### AI and CC GUI

| Keys | Action |
| --- | --- |
| `Space a a` | Open CC GUI |
| `Space a n` | New chat tab |
| `Space a s` | Send visual selection |
| `Space a r` | Copy visual selection reference |
| `Space a f` | Send current file path |
| `Space a q` | Quick fix with CC |
| `Space a g` | Generate commit message |
| `Space a h` | Hide CC GUI |

### Terminal

| Keys | Action |
| --- | --- |
| `Space t t` | Focus Terminal |
| `Space t n` | New terminal session |
| `Space t o` | Open Terminal at the current file |
| `Space t a` | Launch the selected terminal AI agent |
| `Space t s` | Terminal settings |

While Terminal has focus, use its native `Cmd-T` for a new session, `Ctrl-D`
to close the shell, `Cmd-K` to clear, `Ctrl-R` for command history, and
`Shift-Esc` or `Ctrl-; E` to return to the editor.

### Git

| Keys | Action |
| --- | --- |
| `Space g g` | VCS operations popup |
| `Space g c` | Commit tool window |
| `Space g p/P/u/f` | Push/pull/update/fetch |
| `Space g b/l` | Branches/log |
| `Space g d/h/a` | Diff with HEAD/file history/annotate |
| `Space g s` | Staging area |
| `Space g S/U` | Stash/unstash |
| `Space g x` | Resolve conflicts |

Git commands open JetBrains workflows and confirmation dialogs; the mappings do
not silently commit, push, reset, or discard changes.

### Run, build, and debug

| Keys | Action |
| --- | --- |
| `Space r r/d` | Run/debug current context |
| `Space r l/s` | Rerun last/stop |
| `Space r c/a` | Choose configuration/Run Anything |
| `Space r b` | Compile or build current context |
| `Space r o/x` | Run/Debug tool window |

### DataGrip

| Keys | Action |
| --- | --- |
| `Space d b` | Database tool window |
| `Space d c/o` | New/choose query console |
| `Space d e/s` | Execute statement/exact selection |
| `Space d x/a` | Explain plan/analyze |
| `Space d h` | Query history |

Use `Space v r` to reload IdeaVim after configuration changes.
