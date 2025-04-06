# Helper Scripts for `lm` Tool

This repository provides a collection of Bash helper functions designed to enhance the usage of the `lm` tool, a command-line interface for interacting with language models (LLMs). The main goal is to simplify and standardize common patterns and prompts for leveraging LLM capabilities in various projects.

[lm](https://github.com/WillChangeThisLater/lm)

## Repository Structure

```
.
├── gpt-helpers.sh
└── prompt.sh
```

## Files Overview

### `gpt-helpers.sh`

This Bash script provides two primary functions:

- **`describe-project`**:
  - This function generates a directory tree and lists the contents of a repository. It uses the `tree` command to visually represent the file structure and `files-to-prompt` to display file contents for context.

- **`site-summarize`**:
  - This function fetches and summarizes content from a specified webpage using `lynx` and `lm`. It's helpful for extracting and condensing relevant information from external sources.

**Usage**:

To use the helper functions, run the script followed by the desired command and any applicable arguments:

```bash
./gpt-helpers.sh {describe-project|site-summarize} [arguments...]
```

- `describe-project [directory]`: Displays the directory tree and file contents for the specified project directory (default is the current directory).
- `site-summarize [--prompt "custom prompt"] <URL>`: Summarizes the content of the provided URL using an optional custom prompt.

## Getting Started

To start using the helper scripts in your own projects, clone the repository and make the scripts executable:

```bash
git clone <repository-url>
cd <repository-directory>
chmod +x gpt-helpers.sh
gpt-helpers describe-project
```

## Contribution

Feel free to contribute enhancements, additional functions, or documentation improvements to this repository. Please open an issue or submit a pull request with your ideas.
