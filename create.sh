#!/bin/bash

# This script requires two arguments: the parent directory and the name of the application.
# Usage: ./create.sh <PARENT_DIR> <APP_NAME>

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Error: Both PARENT_DIR and APP_NAME are required."
  echo "Usage: $0 <PARENT_DIR> <APP_NAME>"
  exit 1
fi

PARENT_DIR=$1
APP_NAME=$2

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install jq."
    exit 1
fi

# Define the main directory name
SCAFFOLD_DIR="${PARENT_DIR}/${APP_NAME}-scaffold"

# Create the parent directory if it doesn't exist
mkdir -p "$PARENT_DIR" || { echo "Failed to create parent directory $PARENT_DIR"; exit 1; }

# Check if the scaffold directory already exists and prompt for overwrite
if [ -d "$SCAFFOLD_DIR" ]; then
  read -p "Directory '$SCAFFOLD_DIR' already exists. Overwrite? (y/N): " -n 1 -r REPLY
  echo # Move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Removing existing directory $SCAFFOLD_DIR..."
    rm -rf "$SCAFFOLD_DIR" || { echo "Error: Failed to remove existing directory '$SCAFFOLD_DIR'"; exit 1; }
  else
    echo "Aborting."
    exit 0
  fi
fi

# Create the main scaffold directory, exiting if it fails
echo "Creating scaffold directory: $SCAFFOLD_DIR"
mkdir "$SCAFFOLD_DIR" || { echo "Failed to create directory $SCAFFOLD_DIR"; exit 1; }

# Process the base prompt file and copy it to the clipboard
echo "Processing base prompt and copying to clipboard..."
sed "s/{{APP_NAME}}/$APP_NAME/g" "prompts/gemini/base.md" | pbcopy
if [ $? -ne 0 ]; then
  echo "Failed to process base prompt or copy to clipboard"
  exit 1
fi

# Read repository URLs from config.json
CONFIG_FILE="config.json"
EXAMPLE_REPO_URL=$(jq -r '.repos.example' "$CONFIG_FILE")
SKELETON_REPO_URL=$(jq -r '.repos.skeleton' "$CONFIG_FILE")

# Check if URLs were read successfully
if [ -z "$EXAMPLE_REPO_URL" ] || [ "$EXAMPLE_REPO_URL" == "null" ]; then
  echo "Error: Could not read example repository URL from $CONFIG_FILE"
  exit 1
fi
if [ -z "$SKELETON_REPO_URL" ] || [ "$SKELETON_REPO_URL" == "null" ]; then
  echo "Error: Could not read skeleton repository URL from $CONFIG_FILE"
  exit 1
fi


# Clone the example repository
echo "Cloning example repository from $EXAMPLE_REPO_URL into $SCAFFOLD_DIR/example-app..."
git clone "$EXAMPLE_REPO_URL" "$SCAFFOLD_DIR/example-app" || { echo "Failed to clone example repository"; exit 1; }

# Clone the skeleton repository
echo "Cloning skeleton repository from $SKELETON_REPO_URL into $SCAFFOLD_DIR/$APP_NAME..."
git clone "$SKELETON_REPO_URL" "$SCAFFOLD_DIR/$APP_NAME" || { echo "Failed to clone skeleton repository"; exit 1; }


echo "Scaffolding complete for $APP_NAME in $PARENT_DIR."
echo "Running with PARENT_DIR: $PARENT_DIR, APP_NAME: $APP_NAME"

echo
echo "==========================================="
echo "  Base prompt content copied to clipboard. "
echo "===========================================" 