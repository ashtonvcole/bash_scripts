#!/bin/bash

# gwa
# Shortcut for git worktree add

VERSION="1.0.0"

show_help() {
    echo "Bash script to run git worktree add."
    echo ""
    echo "Usage:"
    echo "  $0 [options] [branch-name]"
    echo ""
    echo "Clones git@github.com:user/repo to a folder repo/ in the present directory."
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this message, then the same for the program."
    echo "  -hx, --helpx      Show this message, then exit."
}

ARGUMENTS=()
BRANCH=""

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

if [[ ${#ARGUMENTS[@]} -lt 1 ]]; then
    echo "Error: Not enough information provided." >&2
    exit 1
fi

LEN=${#ARGUMENTS[@]}
BRANCH="${ARGUMENTS[$LEN-1]}"

# Add the branch into a directory of the same name
git worktree add \
    "${ARGUMENTS[@]}" \
    $BRANCH

