# Hyperware App Scaffolder

This repository contains a script to scaffold a new Hyperware application based on a skeleton template and an example application.

## Usage

To create a new scaffolded application, run the `create.sh` script from the root of this repository:

```bash
./create.sh <parent_directory> <app_name>
```

**Arguments:**

*   `<parent_directory>`: The directory where the new scaffold directory will be created. This directory will be created if it doesn't exist.
*   `<app_name>`: The name for your new Hyperware application.

**Example:**

```bash
./create.sh ./my_apps my_cool_app
```

This will create a directory structure like:

```
my_apps/
└── my_cool_app-scaffold/
    ├── example-app/  # Cloned from the example repo
    └── my_cool_app/  # Cloned from the skeleton repo
```

## Script Actions (`create.sh`)

1.  **Checks Prerequisites:** Verifies that `jq` is installed.
2.  **Parses Arguments:** Takes the parent directory and application name as input.
3.  **Handles Existing Directory:** Checks if `<parent_directory>/<app_name>-scaffold` already exists. If it does, it prompts the user whether to overwrite it. If the user declines, the script exits.
4.  **Creates Scaffold Directory:** Creates the main directory: `<parent_directory>/<app_name>-scaffold`.
5.  **Processes Base Prompt:** Reads the template prompt from `prompts/gemini/base.md`, replaces the `{{APP_NAME}}` placeholder with the provided `<app_name>`, and copies the resulting text to the system clipboard.
6.  **Reads Configuration:** Reads the URLs for the example and skeleton Git repositories from `config.json`.
7.  **Clones Repositories:**
    *   Clones the example repository into `<parent_directory>/<app_name>-scaffold/example-app`.
    *   Clones the skeleton repository into `<parent_directory>/<app_name>-scaffold/<app_name>`.
8.  **Completion Message:** Prints a confirmation message upon successful completion and reminds the user that the base prompt content has been copied to the clipboard.

## Configuration

The Git repository URLs used for cloning are defined in `config.json`.
