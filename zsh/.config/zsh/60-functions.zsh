# ── yazi: cd to wherever you navigated on quit ───────
# (a plain alias can't do this — yazi runs in a subshell, so it can't change
# its parent shell's directory itself)
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ── mkdir + cd in one shot ────────────────────────────
function mkcd() {
	mkdir -p "$1" && cd "$1"
}

# ── cd up N levels: `up 3` == `cd ../../..` ───────────
function up() {
	local levels=${1:-1}
	local target=""
	for ((i = 0; i < levels; i++)); do target="../$target"; done
	cd "$target" || return
}

# ── cd to the repo root ───────────────────────────────
function cdg() {
	local root
	root=$(git rev-parse --show-toplevel 2>/dev/null) || {
		echo "not a git repo" >&2
		return 1
	}
	cd "$root"
}

# ── fzf: open files in nvim ───────────────────────────
# `f` with no args picks from all files; `f <pattern>` seeds the query.
function f() {
	local -a files
	files=("${(@f)$(fd --type f --hidden --follow --exclude .git |
		fzf --multi --query="${1:-}" \
			--preview='bat --style=numbers --color=always --line-range=:300 {}')}")
	[[ -n "$files" ]] && ${EDITOR} "${files[@]}"
}

# ── fzf + ripgrep: search file *contents*, open at the line ──
# Live search — every keystroke re-runs rg, so it scales to big repos.
function rgf() {
	local result
	result=$(
		FZF_DEFAULT_COMMAND="rg --column --line-number --no-heading --color=always --smart-case ${1:+-- ${(q)1}}" \
			fzf --ansi --disabled --query="${1:-}" \
			--bind="change:reload:rg --column --line-number --no-heading --color=always --smart-case -- {q} || true" \
			--delimiter=: \
			--preview='bat --style=numbers --color=always --highlight-line {2} {1}' \
			--preview-window='right:60%:+{2}+3/3'
	) || return
	local file=${result%%:*}
	local line=${${result#*:}%%:*}
	[[ -n "$file" ]] && ${EDITOR} "+${line}" "$file"
}

# ── fzf: kill a process ───────────────────────────────
function fkill() {
	local -a pids
	pids=("${(@f)$(ps -eo pid,ppid,%cpu,%mem,comm,args |
		fzf --multi --header-lines=1 --query="${1:-}" |
		awk '{print $1}')}")
	[[ -n "$pids" ]] && kill "${@:-}" "${pids[@]}" && echo "killed ${pids[*]}"
}

# ── fzf: what's listening on a port, and kill it ──────
function port() {
	if [[ -n "$1" ]]; then
		lsof -nP -iTCP:"$1" -sTCP:LISTEN
	else
		lsof -nP -iTCP -sTCP:LISTEN | fzf --header-lines=1
	fi
}

# ── fzf: switch git branch ────────────────────────────
function fbr() {
	local branch
	branch=$(git branch --all --sort=-committerdate --format='%(refname:short)' |
		grep -v '^origin/HEAD' |
		fzf --preview='git log --oneline --graph --decorate --color=always -30 {}') || return
	git switch "${branch#origin/}" 2>/dev/null || git switch --track "$branch"
}

# ── fzf: browse commits, preview the diff through delta ──
function fshow() {
	local commit
	commit=$(git log --oneline --decorate --color=always "$@" |
		fzf --ansi --no-sort --preview='git show --color=always {1} | delta' \
			--preview-window=right:65%) || return
	[[ -n "$commit" ]] && git show "${commit%% *}"
}

# ── fzf: stage individual files ───────────────────────
function fadd() {
	local -a files
	files=("${(@f)$(git status --porcelain |
		fzf --multi --preview='git diff --color=always -- {2..} | delta' |
		awk '{print $2}')}")
	[[ -n "$files" ]] && git add "${files[@]}" && git status -sb
}

# ── git worktree helpers ──────────────────────────────
# Add a worktree for a branch as a sibling dir, then drop into a sesh session
function wta() {
	local branch="$1"
	if [ -z "$branch" ]; then
		echo "usage: wta <branch-name>"
		return 1
	fi
	local repo_name="$(basename "$(git rev-parse --show-toplevel)")"
	local dir="../${repo_name}-${branch}"
	git worktree add "$dir" -b "$branch" && sesh connect "$dir"
}

# List worktrees, fzf-pick one, sesh-connect into it
function wts() {
	local dir
	dir=$(git worktree list | fzf | awk '{print $1}')
	[ -n "$dir" ] && sesh connect "$dir"
}

# Remove a worktree — fzf-pick, confirm, prune
function wtrm() {
	local dir
	dir=$(git worktree list | grep -v "$(git rev-parse --show-toplevel)$" | fzf | awk '{print $1}')
	if [ -n "$dir" ]; then
		git worktree remove "$dir" && echo "removed $dir"
	fi
}

# ── timestamped backup of a file ──────────────────────
function bak() {
	local f
	for f in "$@"; do
		cp -a "$f" "${f}.$(date +%Y%m%d-%H%M%S).bak" && echo "→ ${f}.$(date +%Y%m%d-%H%M%S).bak"
	done
}

# ── serve the current dir over http ───────────────────
function serve() {
	local port="${1:-8000}"
	echo "serving $PWD on http://localhost:$port"
	python3 -m http.server "$port"
}

# ── what is this command, really? ─────────────────────
# Unwraps aliases, functions, and builtins down to the actual binary.
function what() {
	local cmd
	for cmd in "$@"; do
		whence -va "$cmd"
	done
}

# ── how long did that take? ───────────────────────────
# Prints the elapsed wall time of the previous command; handy after the fact.
function benchmark() {
	local start=$EPOCHREALTIME
	"$@"
	local status=$?
	printf '\n%.3fs\n' "$((EPOCHREALTIME - start))"
	return $status
}
zmodload zsh/datetime   # provides $EPOCHREALTIME used above
