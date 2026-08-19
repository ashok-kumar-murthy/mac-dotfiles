#!/usr/bin/env bash
# Bootstrap a fresh macOS developer environment, then link all packages.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=""
LINK_ONLY=""
NVM_VERSION="v0.40.6"
NODE_VERSION="24"
JAVA_VERSION="21.0.12-tem"
BASEDPYRIGHT_VERSION="1.39.9"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
SDKMAN_DIR="${SDKMAN_DIR:-$HOME/.sdkman}"

usage() {
  cat <<'EOF'
Usage: ./bootstrap.sh [--dry-run] [--link-only]

  --dry-run    print actions without changing the machine
  --link-only  skip software installation and only link configurations

For an existing Mac, prefer `./manage.sh link <package>` so each package can be
reviewed independently. bootstrap.sh is the full path for a fresh machine.
EOF
}

for argument in "$@"; do
  case "$argument" in
    --dry-run) DRY_RUN=1 ;;
    --link-only) LINK_ONLY=1 ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      printf 'unknown argument: %s\n' "$argument" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[[ "$(uname -s)" == Darwin ]] || {
  echo "bootstrap.sh supports macOS only" >&2
  exit 1
}

run() {
  if [[ -n "$DRY_RUN" ]]; then
    printf 'would run:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

install_homebrew() {
  command -v brew >/dev/null 2>&1 && return 0
  if [[ -n "$DRY_RUN" ]]; then
    echo "would install Homebrew using the official installer"
    return 0
  fi
  printf 'Homebrew is required. Run the official installer now? [y/N] '
  read -r answer
  [[ "$answer" == y || "$answer" == Y ]] || {
    echo "Homebrew installation declined" >&2
    exit 1
  }
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash
}

activate_homebrew() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_oh_my_zsh() {
  local commit="97b27bb2ec0701330b18c2d3e340b22e742b3fa8"
  if [[ -d "$HOME/.oh-my-zsh/.git" ]]; then
    printf 'Oh My Zsh already exists at %s\n' "$HOME/.oh-my-zsh"
    return 0
  fi
  run git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  run git -C "$HOME/.oh-my-zsh" checkout "$commit"
}

install_node() {
  if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    if [[ -n "$DRY_RUN" ]]; then
      printf 'would install NVM %s into %s\n' "$NVM_VERSION" "$NVM_DIR"
    else
      curl --fail --location --silent --show-error \
        "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" |
        PROFILE=/dev/null NVM_DIR="$NVM_DIR" /bin/bash
    fi
  fi

  if [[ -z "$DRY_RUN" ]]; then
    # NVM is a sourced shell function, not an executable.
    # shellcheck source=/dev/null
    source "$NVM_DIR/nvm.sh"
  fi
  run nvm install "$NODE_VERSION"
  run nvm alias default "$NODE_VERSION"
  run nvm use "$NODE_VERSION"
}

install_java() {
  if [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    if [[ -n "$DRY_RUN" ]]; then
      printf 'would install SDKMAN into %s\n' "$SDKMAN_DIR"
    else
      curl --fail --location --silent --show-error \
        'https://get.sdkman.io?rcupdate=false' |
        SDKMAN_DIR="$SDKMAN_DIR" /bin/zsh
    fi
  fi

  if [[ -z "$DRY_RUN" ]]; then
    # SDKMAN is also a sourced shell function. Avoid its default-selection prompt;
    # the explicit default command below makes the intended state deterministic.
    # SDKMAN probes unset shell-specific variables and optional arguments, so keep
    # nounset disabled while initializing and invoking it.
    set +u
    # shellcheck source=/dev/null
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    export sdkman_auto_answer=true
  fi
  run sdk install java "$JAVA_VERSION"
  run sdk default java "$JAVA_VERSION"
  run sdk use java "$JAVA_VERSION"
  [[ -n "$DRY_RUN" ]] || set -u
}

install_python_tools() {
  if [[ -n "$DRY_RUN" ]] || command -v uv >/dev/null 2>&1; then
    run uv tool install --force "basedpyright==$BASEDPYRIGHT_VERSION"
  else
    echo "skipping Python tools: uv is not available" >&2
  fi
}

if [[ -z "$LINK_ONLY" ]]; then
  install_homebrew
  activate_homebrew
  if command -v brew >/dev/null 2>&1; then
    run brew bundle --file="$REPO_DIR/homebrew/.config/homebrew/Brewfile"
  fi
  install_oh_my_zsh
  run env DRY_RUN="$DRY_RUN" "$REPO_DIR/scripts/install-font.sh"
  install_node
  install_java
  install_python_tools
  if [[ -n "$DRY_RUN" ]] || command -v npm >/dev/null 2>&1; then
    if [[ -n "$DRY_RUN" ]]; then
      echo "would install pinned global npm packages"
    else
      while IFS= read -r npm_package; do
        [[ -n "$npm_package" ]] || continue
        npm install --global "$npm_package"
      done <"$REPO_DIR/homebrew/.config/homebrew/npm-globals.txt"
    fi
  else
    echo "skipping global npm packages: activate an nvm-managed Node.js first"
  fi
  command -v bat >/dev/null 2>&1 && run bat cache --build
fi

packages=(git powerlevel10k bat ripgrep atuin sesh tealdeer zsh alacritty tmux nvim ideavim aerospace sketchybar homebrew)
for package in "${packages[@]}"; do
  if [[ -n "$DRY_RUN" ]]; then
    printf 'would link package: %s\n' "$package"
  else
    "$REPO_DIR/manage.sh" link "$package"
  fi
done

if [[ -e "$REPO_DIR/.git" ]] && { [[ -n "$DRY_RUN" ]] || command -v pre-commit >/dev/null 2>&1; }; then
  (
    cd "$REPO_DIR"
    run pre-commit install --install-hooks
  )
fi

echo "bootstrap complete"
