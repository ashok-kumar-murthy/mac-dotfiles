#!/usr/bin/env bash
# Inspect, link, and restore one stow-style dotfiles package at a time.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_BASE="${DOTFILES_BACKUP_ROOT:-$HOME/.dotfiles-backups}"
RUN_ID="${DOTFILES_RUN_ID:-$(date +%Y%m%d-%H%M%S)}"
BACKUP_DIR="$BACKUP_BASE/live-$RUN_ID"

PACKAGES=(
  git powerlevel10k bat ripgrep atuin sesh tealdeer
  zsh alacritty tmux nvim ideavim aerospace sketchybar homebrew theme
)

usage() {
  cat <<'EOF'
Usage:
  ./manage.sh status [package]
  ./manage.sh diff [package]
  ./manage.sh link <package>
  ./manage.sh restore <package> [backup-directory]

link always handles one package so migration remains reviewable. Existing
targets are moved to ~/.dotfiles-backups/live-<timestamp>/ before linking.
EOF
}

is_package() {
  local wanted="$1" package
  for package in "${PACKAGES[@]}"; do
    [[ "$package" == "$wanted" ]] && return 0
  done
  return 1
}

directory_links() {
  case "$1" in
    alacritty) printf '%s\n' '.config/alacritty' ;;
    bat) printf '%s\n' '.config/bat' ;;
    nvim) printf '%s\n' '.config/nvim' ;;
    sketchybar) printf '%s\n' '.config/sketchybar' ;;
    zsh) printf '%s\n' '.config/zsh' ;;
  esac
}

is_under_directory_link() {
  local package="$1" inner="$2" linked
  while IFS= read -r linked; do
    [[ -n "$linked" && "$inner" == "$linked"/* ]] && return 0
  done < <(directory_links "$package")
  return 1
}

visit_target() {
  local action="$1" source="$3" target="$4" backup_hint="${5:-}"
  local relative="${target#$HOME/}" backup_source candidate latest=""

  case "$action" in
    status)
      if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        printf 'linked       ~/%s\n' "$relative"
      elif [[ -L "$target" ]]; then
        printf 'other-link   ~/%s -> %s\n' "$relative" "$(readlink "$target")"
      elif [[ -e "$target" ]]; then
        printf 'real-path    ~/%s\n' "$relative"
      else
        printf 'missing      ~/%s\n' "$relative"
      fi
      ;;
    diff)
      if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        printf 'clean        ~/%s\n' "$relative"
      elif [[ ! -e "$target" && ! -L "$target" ]]; then
        printf 'missing      ~/%s\n' "$relative"
      elif [[ -d "$source" ]]; then
        diff -ruN "$target" "$source" || true
      else
        diff -u "$target" "$source" || true
      fi
      ;;
    link)
      if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        printf 'already linked: ~/%s\n' "$relative"
        return 0
      fi
      if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$relative")"
        mv "$target" "$BACKUP_DIR/$relative"
        printf 'backed up:     ~/%s -> %s/%s\n' "$relative" "$BACKUP_DIR" "$relative"
      fi
      mkdir -p "$(dirname "$target")"
      ln -s "$source" "$target"
      printf 'linked:        ~/%s\n' "$relative"
      ;;
    restore)
      if [[ -n "$backup_hint" ]]; then
        latest="$backup_hint"
      else
        for candidate in "$BACKUP_BASE"/live-*; do
          [[ -e "$candidate/$relative" || -L "$candidate/$relative" ]] || continue
          latest="$candidate"
        done
      fi
      if [[ -z "$latest" ]]; then
        if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
          rm "$target"
          printf 'removed link:  ~/%s (no original target)\n' "$relative"
          return 0
        fi
        printf 'no backup found for ~/%s\n' "$relative" >&2
        return 1
      fi
      backup_source="$latest/$relative"
      if [[ ! -e "$backup_source" && ! -L "$backup_source" ]]; then
        if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
          rm "$target"
          printf 'removed link:  ~/%s (no original target)\n' "$relative"
          return 0
        fi
        printf 'backup does not contain ~/%s: %s\n' "$relative" "$latest" >&2
        return 1
      fi
      if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        rm "$target"
      elif [[ -e "$target" || -L "$target" ]]; then
        printf 'refusing to overwrite non-managed target: ~/%s\n' "$relative" >&2
        return 1
      fi
      mkdir -p "$(dirname "$target")"
      mv "$backup_source" "$target"
      printf 'restored:      ~/%s from %s\n' "$relative" "$latest"
      ;;
    *)
      usage >&2
      return 2
      ;;
  esac
}

walk_package() {
  local action="$1" package="$2" backup_hint="${3:-}" linked source rel inner target
  printf '\n[%s]\n' "$package"

  while IFS= read -r linked; do
    [[ -n "$linked" ]] || continue
    source="$REPO_DIR/$package/$linked"
    [[ -d "$source" ]] || continue
    target="$HOME/$linked"
    visit_target "$action" "$package" "$source" "$target" "$backup_hint"
  done < <(directory_links "$package")

  while IFS= read -r -d '' source; do
    rel="${source#$REPO_DIR/$package/}"
    inner="$rel"
    is_under_directory_link "$package" "$inner" && continue
    [[ "$inner" == .* || "$inner" == Library/* ]] || continue
    [[ "$inner" == *.example ]] && continue
    target="$HOME/$inner"
    visit_target "$action" "$package" "$source" "$target" "$backup_hint"
  done < <(find "$REPO_DIR/$package" -type f -print0)
}

main() {
  local action="${1:-}" package="${2:-}" backup_hint="${3:-}" current
  [[ -n "$action" ]] || {
    usage
    exit 2
  }

  case "$action" in
    status | diff)
      if [[ -n "$package" ]]; then
        is_package "$package" || {
          printf 'unknown package: %s\n' "$package" >&2
          exit 2
        }
        walk_package "$action" "$package"
      else
        for current in "${PACKAGES[@]}"; do walk_package "$action" "$current"; done
      fi
      ;;
    link | restore)
      [[ -n "$package" ]] || {
        printf '%s requires one package\n' "$action" >&2
        exit 2
      }
      is_package "$package" || {
        printf 'unknown package: %s\n' "$package" >&2
        exit 2
      }
      walk_package "$action" "$package" "$backup_hint"
      [[ "$action" == link ]] && printf '\nbackup directory: %s\n' "$BACKUP_DIR"
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
}

main "$@"
