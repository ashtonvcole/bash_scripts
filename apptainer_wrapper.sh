#!/bin/bash

# container_wrapper.sh
# Wrapper for containerized figuregen
# This lets the user call the container as if they were running the software

VERSION="1.0.0"
CONTAINER="docker://alpine"
PROGRAM=""
CONTAINER_TYPE="apptainer"
CONTAINER_RUNCOMMAND="apptainer exec"

show_help() {
    echo "Bash script wrapper to run $PROGRAM."
    echo ""
    echo "Container name: $CONTAINER"
    echo "Container type: $CONTAINER_TYPE"
    echo ""
    echo "Usage:"
    echo "  $PROGRAM [program options]"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this message, then the same for the program."
    echo "  -hx, --helpx      Show this message, then exit."
    echo "  -v, --version     Show the version, then the same for the program."
    echo "  -vx, --versionx   Show the version, then exit."
    echo "  -cx, --container-args \"args\" Pass arguments to $CONTAINER_RUNCOMMAND."
}

# Accumulate arguments in the appropriate bins
CONTAINER_RUNOPTIONS=""
PROGRAM_ARGS=()

# Iterate through user arguments and parse them appropriately
while [[ $# -gt 0 ]]; do
    case "$1" in
        -hx|--helpx)
            show_help
            exit 0
            ;;
        -h|--help)
            show_help
            PROGRAM_ARGS+=("$1") # Add argument
            shift # Discard $1
            ;;
        -vx|--versionx)
            echo "Wrapper for $PROGRAM, version: $VERSION"
            exit 0
            ;;
        -v|--version)
            echo "Wrapper for $PROGRAM, version: $VERSION"
            PROGRAM_ARGS+=("$1") # Add argument
            shift # Discard $1
            ;;
        -cx|--container-args)
            if [[ -n "$2" && "$2" != -* ]]; then
                CONTAINER_RUNOPTIONS="$2" # Get the arg contents as well
                shift 2 # Discard $1 and $2
            else
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            fi
            ;;
        --) # Double-dash convention: everything after is for the program
            shift # Skip the double-dash per se
            PROGRAM_ARGS+=("$@") # Add everything
            break # Terminate loop
            ;;
        *) # Anything else is a program argument
            PROGRAM_ARGS+=("$1") # Add argument
            shift # Discard $1
            ;;
    esac
done

exec apptainer exec \
    $CONTAINER_RUNOPTIONS \
    "$CONTAINER" \
    "$PROGRAM" "${PROGRAM_ARGS[@]}"
