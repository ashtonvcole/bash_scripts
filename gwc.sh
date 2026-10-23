#!/bin/bash

# gwc
# Shortcut for git clone and a clean worktree setup

VERSION="1.0.0"

show_help() {
    echo "Bash script to run git clone with a clean worktree setup."
    echo ""
    echo "Usage:"
    echo "  $0 [options] [user] [repo]"
    echo ""
    echo "Clones git@github.com:user/repo to a folder repo/ in the present directory."
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this message, then the same for the program."
    echo "  -hx, --helpx      Show this message, then exit."
}

# For cloning
ARGUMENTS=()
GIT_USER=""
GIT_REPO=""

# Iterate through user arguments and parse them appropriately
while [[ $# -gt 0 ]]; do
    case "$1" in
        -hx|--helpx)
            show_help
            exit 0
            ;;
        -h|--help)
            show_help
            ARGUMENTS+=("$1")
            shift
            ;;
        *)
            ARGUMENTS+=("$1")
            shift
            ;;
    esac
done

if [[ ${#ARGUMENTS[@]} -lt 2 ]]; then
    echo "Error: Not enough information provided." >&2
    echo "Read ${ARGUMENTS[@]}" >&2
    exit 1
fi

LEN=${#ARGUMENTS[@]}
GIT_USER="${ARGUMENTS[$LEN-2]}"
GIT_REPO="${ARGUMENTS[$LEN-1]}"
GIT_DIR_PATH="$GIT_REPO/.git"
REMOTE_URL="git@github.com:$GIT_USER/$GIT_REPO.git"

# First, make a new directory to clone into
mkdir -p "$GIT_REPO"

# Clone as a bare repository
git clone \
    --bare \
    --config remote.origin.fetch="+refs/heads/*:refs/remotes/origin/*" \
    "$REMOTE_URL" "$GIT_DIR_PATH" || exit 1

# Bare clones do not write remote.origin.url, so set it explicitly
git --git-dir="$GIT_DIR_PATH" config remote.origin.url "$REMOTE_URL"

# Populate refs/remotes/origin/* so each local branch has a remote to track
git --git-dir="$GIT_DIR_PATH" fetch origin || exit 1

# Set upstream for each local branch
while read -r b; do
    git --git-dir="$GIT_DIR_PATH" config "branch.$b.remote" origin
    git --git-dir="$GIT_DIR_PATH" config "branch.$b.merge" "refs/heads/$b"
done < <(git --git-dir="$GIT_DIR_PATH" for-each-ref --format='%(refname:short)' refs/heads)

# Let worktree creation from origin/<name> set up tracking automatically
git --git-dir="$GIT_DIR_PATH" config branch.autoSetupMerge always

