# Talend Modules Management Script (talend-modules.sh)

This Bash script is designed to simplify the management of Talend modules using Git submodules and perform various tasks such as committing, cleaning, updating, and building your project. It also helps extract version and patch information from a given version-patch and generate a `product.properties` file.

## Prerequisites

Before using this script, make sure you have the following prerequisites installed on your system:

- Git
- cURL
- Maven (if you intend to use the "build" command)

## Usage

The script accepts several commands and arguments as follows:

- `commit <version-patch>`: Commit a Git submodule, extract version/patch, and save to `product.properties`. Perform a Git commit.

  Example:
  ```bash
  ./talend-modules.sh commit 8.0.1-R2023-10
  ```

- `clean`: Reset Git submodules to the last committed state and clean the project's working directory.

  Example:
  ```bash
  ./talend-modules.sh clean
  ```

- `update`: Initialize and update Git submodules.

  Example:
  ```bash
  ./talend-modules.sh update
  ```

- `build`: Run the build command using Maven: `./mvnw clean install -P-nonofficial -DskipTests`.

  Example:
  ```bash
  ./talend-modules.sh build
  ```

- `help`: Display usage instructions.

  Example:
  ```bash
  ./talend-modules.sh help
  ```

## Notes

- When using the "commit" command, the script will fetch patch information from the specified version-patch, reset the submodule to its last committed state, and then check out the submodule with the extracted version and patch. It will also create a `product.properties` file with version, patch, timestamp, release.suffix, and revision.filename and perform a Git commit using the provided version-patch as the commit message.

- The "clean" command resets Git submodules to the last committed state and removes untracked files from the project's working directory, excluding files specified in `.gitignore`.

- The "build" command runs the specified Maven build command for your project.

- The "update" command initializes and updates Git submodules to their latest versions.

- The "help" command displays this help message.

## License

This script is provided as-is with no warranties. You may use, modify, and distribute it under the terms of your preferred open-source license.
