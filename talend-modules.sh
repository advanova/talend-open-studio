#!/bin/bash
# This script manages the talend modules

# Function to display help
function display_help() {
    echo "Usage: $0 <command> [arguments]"
    echo "Available commands:"
    echo "  commit <version-patch> - Commit a Git submodule, extract version/patch, and save to product.properties. Perform a Git commit."
    echo "  clean - Reset Git submodules to the last committed state."
    echo "  update - Initialize and update Git submodules."
    echo "  help - Display this help message."
}

# Function for the commit command
function commit_command() {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 commit <version-patch>"
        exit 1
    fi
    local VERSION_PATCH="$1"
    local VERSION="${VERSION_PATCH%%-*}"
    local MAJOR_VERSION="${VERSION%%.*}"
    local PATCH="${VERSION_PATCH#*-}"

    # Define the base URL
    local PATCH_BASE_URL="https://update.talend.com/Studio/$MAJOR_VERSION/updates/$PATCH"

    # Construct the URL for patch.properties
    local PATCH_PROPERTIES_URL="$PATCH_BASE_URL/patch.properties"

    # Fetch the contents of patch.properties and store it in PATCH_PROPERTIES
    local PATCH_PROPERTIES=$(curl -s "$PATCH_PROPERTIES_URL")

    # Extract the date and time part of product.version and store it in PRODUCT_TIMESTAMP using the specified regex
    if [[ $PATCH_PROPERTIES =~ product\.version=.*([0-9]{8}_[0-9]{4}).* ]]; then
        local PRODUCT_TIMESTAMP="${BASH_REMATCH[1]}"
    else
        echo "Failed to extract PRODUCT_TIMESTAMP"
        exit 1
    fi

    # Ensure that Git submodules are fetched and up to date
    git submodule foreach git fetch --prune --tags --all --force --prune-tags

    # Reset the Git submodule
    git submodule foreach git reset --hard

    # Check out a Git submodule using the extracted VERSION and PATCH
    git submodule foreach git checkout release/"$VERSION"-"$PATCH"

    # Create a properties file with the extracted information
    echo "product.version=$VERSION" > product.properties
    echo "product.patch=$PATCH" >> product.properties
    echo "product.timestamp=$PRODUCT_TIMESTAMP" >> product.properties
    echo "release.suffix=$PATCH" >> product.properties
    echo "revision.filename=-$PATCH" >> product.properties

    # Perform a Git commit with the version as the commit message
    git commit -a -m "$VERSION_PATCH"
}

# Function for the clean command
function clean_command() {
    # Make sure any git index is reset
    git submodule foreach git reset --hard
    # Remove all files not in git submodule repos, including files from .gitignore
    git submodule foreach git clean -fdx
    # Remove all files not in git submodule repos, excluding files from .gitignore
    git clean -fd
    # But remove the target
    rm -rf target
}

# Function for the update command
function update_command() {
    # Update submodules using "git submodule update --init"
    git submodule update --init
}

# Check if a command was provided as the first argument
if [ -z "$1" ]; then
    display_help
    exit 1
fi

# Extract the command
COMMAND="$1"

case "$COMMAND" in
    "commit")
        shift
        commit_command "$@"
        ;;
    "clean")
        clean_command
        ;;
    "update")
        update_command
        ;;
    "help")
        display_help
        ;;
    *)
        echo "Invalid command: $COMMAND"
        display_help
        exit 1
        ;;
esac
