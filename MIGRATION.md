# Migration checklist

For each package: inspect `diff`, run `verify`, link it, test it manually, and
only then mark it complete. Keep the pre-migration snapshot until every item has
been accepted and the public repository has been reviewed.

- [x] Repository scripts and Homebrew inventory
- [ ] Git
- [ ] Powerlevel10k
- [ ] Bat
- [ ] ripgrep
- [ ] Atuin
- [ ] sesh
- [ ] tealdeer
- [ ] Zsh (`~/.zshenv` and `~/.config/zsh`)
- [ ] Alacritty and IoskeleyMono Nerd Font
- [ ] tmux
- [ ] Neovim
- [ ] IdeaVim and JetBrains keymap (install the plugins, link `~/.ideavimrc`, then run `scripts/install-jetbrains-keymap.sh` with the IDEs closed)
- [ ] AeroSpace
- [ ] SketchyBar
- [ ] Full repository verification
- [ ] Public-safety review
- [ ] Create and push `ashokkmr1/mac-dotfiles`
