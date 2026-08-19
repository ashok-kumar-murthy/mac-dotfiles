# mac-dotfiles

Reproducible, keyboard-first macOS developer environment built around
AeroSpace, SketchyBar, Alacritty, tmux, Neovim, IdeaVim, and a modular XDG zsh
shell. The terminal and editor stack share the light Modus Operandi palette,
IoskeleyMono Nerd Font, and Space-leader conventions.

The repository is the source of truth. Its top-level directories are stow-style
packages whose contents mirror paths below `$HOME`.

## What is included

| Area | Configuration |
| --- | --- |
| Desktop | Ten fixed AeroSpace workspaces with SketchyBar |
| Terminal | Alacritty, window-only tmux, sesh, and Powerlevel10k |
| Shell | XDG zsh with Oh My Zsh, Atuin, fzf-tab, zoxide, and direnv |
| Editors | Neovim, IdeaVim, and a shared JetBrains keymap |
| CLI | Git/delta, bat, ripgrep, eza, fd, and tealdeer |
| Toolchains | Node 24, Temurin 21, npm tools, and basedpyright |

Modus Operandi is applied consistently to Alacritty, tmux, Neovim, Atuin,
Powerlevel10k, bat/delta, fzf, fzf-tab, eza/`LS_COLORS`, and zsh's line editor,
autosuggestions, and syntax highlighting.

## Existing Mac: migrate one package at a time

Before linking anything, keep a private snapshot outside this repository. Then:

```sh
./manage.sh status
./manage.sh diff git
./verify.sh git
./manage.sh link git
./manage.sh status git
```

Repeat `diff`, `verify`, `link`, and manual application testing for each package
in the order recorded in [MIGRATION.md](MIGRATION.md). `link` moves any existing
target into `~/.dotfiles-backups/live-<timestamp>/`; it never overwrites it.

To roll back a package, use the backup directory printed by `link`:

```sh
./manage.sh restore git ~/.dotfiles-backups/live-YYYYMMDD-HHMMSS
```

## Fresh Mac

Clone the repository, review the script, then run:

```sh
./bootstrap.sh --dry-run
./bootstrap.sh
```

The bootstrap installs Homebrew packages, the pinned Oh My Zsh revision, the
pinned IoskeleyMono Nerd Font archive, NVM with Node 24, SDKMAN with Temurin
Java 21, basedpyright with uv, and the pinned global npm tools. It then links
all config packages and installs the repository's Gitleaks pre-commit hook. Use
`--link-only` when software is already installed.

## Shell and terminal workflow

`~/.zshenv` sets `ZDOTDIR=~/.config/zsh`. The active `.zprofile`, `.zshrc`, and
numbered modules therefore live under `~/.config/zsh`; a root `~/.zshrc` is not
used or tracked. The modules load in numeric order so exports, completion,
keybindings, integrations, aliases, functions, Powerlevel10k, fzf-tab, and ZLE
plugins initialize deterministically.

| Keys or command | Action |
| --- | --- |
| `Ctrl-R` / `Up` | Search Atuin history / search by current directory prefix |
| `Ctrl-T` | Insert a file selected with fzf and previewed with bat |
| `Option-C` | Change directory with an fzf/eza preview |
| `Ctrl-Space` | Accept the current zsh autosuggestion |
| `Ctrl-X Ctrl-E` | Edit the current command line in Neovim |
| `cd <query>` / `cdi` | Jump with zoxide / choose a ranked directory |
| `f` / `rgf` | Find files / search contents and open the result in Neovim |
| `s` | Connect to a project or existing tmux session with sesh |

tmux deliberately uses windows rather than panes. `Option-N` creates a window,
`Option-H/L` selects the previous/next window, and `Option-S` enters vi copy
mode. In copy mode, `v`, `V`, or `Ctrl-V` starts a selection and `y` or `Enter`
copies it to the macOS clipboard. The standard `Ctrl-B` prefix remains
available as a fallback.

## Neovim keyboard model

Space is the leader in both Neovim and IdeaVim.

| Keys | Action |
| --- | --- |
| `Space s` / `Space q` | Save / quit |
| `Space f f/g/b/h/r/w/c` | Find files/text/buffers/help/recent/word/config |
| `Space b b/n/p/d` | Choose/next/previous/delete buffer |
| `Space w s/v/h/j/k/l/w/c/o/=` | Split and navigate windows |
| `Space e` / `-` | Open Oil / browse the parent directory |
| `Space u w/l` | Toggle wrapping / visible whitespace |
| `Space m p/v/g` | Toggle rendered Markdown / side preview / Glow preview |

Neovim uses Modus Operandi, relative line numbers, the system clipboard,
persistent undo, smart-case search, and automatic wrapping, spell checking,
and rendered structure for Markdown files.

## Machine-local steps

- Copy `git/.config/git/local.config.example` to
  `~/.config/git/local.config`, then set your name and email.
- Authenticate GitHub with `gh auth login`.
- Sign into Tailscale.
- Grant the macOS accessibility, automation, and calendar permissions needed by
  AeroSpace and SketchyBar.
- Log into applications normally; credentials and application state are not
  stored here.

## AeroSpace keyboard model

Command is the AeroSpace modifier everywhere. Shift consistently means move
instead of focus or switch. Workspaces are permanent and task-based so their
numbers remain stable:

| Workspace | Purpose |
| --- | --- |
| `1 WEB` | Browser and web apps |
| `2 TERM` | Terminals |
| `3 CODE` | Editors and development |
| `4 FILES` | Finder and file management |
| `5 KNOW` | Obsidian and knowledge work |
| `6 LIFE` | Journal and personal life |
| `7 MEDIA` | Podcasts, photos, TV, and music |
| `8 PLAN` | Reminders, Calendar, and planning |
| `9 AI` | AI tools and conversations |
| `10 COMMS` | WhatsApp, Telegram, Slack, and messaging |

Alacritty windows are assigned to workspace 2. SketchyBar shows these names,
the ordered windows in the focused workspace, the focused window, and calendar,
battery, volume, network, Tailscale, and clock status.

| Keys | Action |
| --- | --- |
| `Cmd-H/J/K/L` | Focus the window to the left/down/up/right |
| `Cmd-Shift-H/J/K/L` | Move the window left/down/up/right |
| `Cmd-Shift-[` / `Cmd-Shift-]` | Focus the previous/next window in bar order |
| `` Cmd-` `` | Return to the previously focused window, or previous workspace |
| `Cmd-1` ... `Cmd-0` | Switch to workspace 1 ... 10 |
| `Cmd-Shift-1` ... `Cmd-Shift-0` | Move the window to workspace 1 ... 10 |
| `Cmd-Tab` | Switch back to the previous workspace |
| `Cmd-Shift-Tab` | Move the workspace to the next monitor |
| `Cmd-/` / `Cmd-,` | Cycle tiled / accordion orientations |
| `Cmd--` / `Cmd-=` | Shrink/grow the focused window |
| `Cmd-Shift-,` | Rename the focused window in SketchyBar |
| `Cmd-Shift-;` | Enter service mode |

In service mode, `Esc` reloads the config, `R` flattens the tree and restores
horizontal accordion, `B` balances window sizes, `F` toggles floating, and
`Backspace` closes every window except the focused one. `Cmd-Shift-H/J/K/L`
joins in a direction and returns to main mode.

### macOS shortcuts to disable

Open **System Settings > Keyboard > Keyboard Shortcuts** and make these changes:

- Under **Screenshots**, disable **Save picture of screen as a file**
  (`Cmd-Shift-3`), **Save picture of selected area as a file** (`Cmd-Shift-4`),
  and **Screenshot and recording options** (`Cmd-Shift-5`). On a Touch Bar Mac,
  also disable **Capture Touch Bar** (`Cmd-Shift-6`). They conflict with moving
  windows to workspaces 3, 4, 5, and (when present) 6.
- Under **Mission Control**, disable any **Switch to Desktop 1...10** shortcuts
  assigned to `Cmd-1`...`Cmd-0`. AeroSpace owns those combinations for its ten
  permanent workspaces.

Several other combinations deliberately replace standard macOS or application
shortcuts. `Cmd-Tab`/`Cmd-Shift-Tab` replace the application switcher, `Cmd-H`
replaces Hide, `` Cmd-` `` replaces the native next-window shortcut, `Cmd-,`
replaces application Settings, and `Cmd--`/`Cmd-=` replace zoom. Letter
navigation and `Cmd-Shift-[`/`]` may also replace
app-specific shortcuts. macOS has no single Keyboard Shortcuts checkbox for
these; while AeroSpace is running, its global bindings own them. The config also
sets `automatically-unhide-macos-hidden-apps = true` so a native Hide action
cannot leave an AeroSpace-managed application hidden.

## IdeaVim keyboard model

The shared `~/.ideavimrc` is used by IntelliJ IDEA, PyCharm, WebStorm, and
DataGrip. Install and enable the IdeaVim and Which-Key plugins in each IDE, then
link the configuration with `./manage.sh link ideavim`. Space is the leader,
matching Neovim.

| Keys | Action |
| --- | --- |
| `Space s` | Save all |
| `Space f f/g/b/h/r/w` | Find file/text/buffer/actions/recent/usages |
| `Space b b/n/p/d/o/u` | Choose/next/previous/close/only/reopen tab |
| `Space w s/v/h/j/k/l/w/c/o/=` | Split and navigate editor windows |
| `Space a …` | CC GUI and AI actions |
| `Space c a/f/o/r/m/d` | Intention/format/imports/rename/refactor/definition |
| `Space g …` | Commit, sync, branches, history, staging, and conflicts |
| `Space r r/d/l/s/c/a/b/o/x` | Run, debug, build, configurations, and output |
| `Space t …` | Terminal sessions and terminal AI |
| `Space u w/l/n/i/z/f` | Editor and presentation toggles |
| `g d/i/r`, `K` | Declaration/implementation/usages/documentation |
| `[d`, `]d`, `gl` | Previous/next/show diagnostic |
| `Space d b` | Open Database tool window in DataGrip |

Use `Space v r` after editing the file to reload it without restarting the IDE.
The cross-context `Ctrl-;` chord and complete mapping reference are in
[jetbrains/README.md](jetbrains/README.md). Install that native keymap while the
IDEs are closed with `./scripts/install-jetbrains-keymap.sh`.

## Verification

Run all repository checks before committing:

```sh
./verify.sh
```

The verifier parses shell, TOML, Git, pre-commit, and JetBrains configuration;
starts tmux and Neovim; checks the selected Modus palette and IdeaVim mappings;
scans for secrets; and validates executable bits. During migration, use
`./verify.sh <package>` for the focused package, then still test the application
interactively after linking it.

## Updating

- Refresh Homebrew declarations deliberately with `brew bundle dump`, then
  review the diff instead of blindly committing generated output.
- Global npm tools and their versions are recorded in
  `homebrew/.config/homebrew/npm-globals.txt` and installed with Node 24.
- Update `NVM_VERSION`, `NODE_VERSION`, `JAVA_VERSION`, and
  `BASEDPYRIGHT_VERSION` together with their bootstrap behavior when changing
  managed runtime versions.
- Commit Neovim's `lazy-lock.json` whenever plugin versions change.
- Change the font URL and checksum together in `scripts/install-font.sh`.
- After changing the bat theme, run `bat cache --build` so bat and delta can
  resolve `Modus Operandi`.

## Deliberately excluded

Credentials, shell histories, databases, caches, downloaded plugins, Git
identity, Tailscale state, application login state, Emacs configuration, and AI
tool configuration are not tracked.
