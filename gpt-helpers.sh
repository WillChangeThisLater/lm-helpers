#!/bin/bash

set -euo pipefail

scrape-links() {
    # TODO: update this to use input from stdin
    cat | llm -s "Extract the URLs. Only include full URL paths (leading with http or https)" --schema-multi "url string" | jq -r '.items[].url'
}

# Describe a project
describe-project() {
    local directory=${1:-.}
    echo "Directory tree:"
    tree "$directory"

    echo "Repository contents:"
    files-to-prompt "$directory"
}

# Summarize relevant content from a website
site-summarize() {
    local url=""
    local prompt=""

    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --prompt)
                prompt="$2"
                shift 2
                ;;
            *)
                url="$1"
                shift
                ;;
        esac
    done

    # Check if the URL is provided
    if [ -z "$url" ]; then
        echo "Error: Please provide a URL to summarize." >&2
        return 1
    fi

    # Fetch and process the website content
    website_content=$(lynx -dump "$url")

    # Check if prompt is provided and format the input for 'lm'
    if [ -n "$prompt" ]; then
        lynx -dump "$url" | lm --cache --prompt "$prompt"
    else
        lynx -dump "$url" | lm --cache
    fi
}

run() {
    if [ $# -eq 0 ]; then
        echo "run requires input" >&2
        exit 1
    fi

    set +euo >/dev/null
    echo '```bash'
    echo "> $@" 
    /bin/bash -c "source ~/.bashrc; $@" 2>&1
    echo '```'
    set -euo >/dev/null
}



main() {
    if [ $# -eq 0 ]; then
        echo "Usage: $0 {describe-project|site-summarize} [arguments...]" >&2
        exit 1
    fi
    
    command="$1"
    shift
    
    case "$command" in
        describe-project)
            describe-project "$@"
            ;;
        site-summarize)
            site-summarize "$@"
            ;;
        run)
            run "$@"
            ;;
        scrape-links)
            scrape-links
            ;;
        *)
            echo "Error: Invalid command '$command'" >&2
            echo "Usage: $0 {describe-project|site-summarize|run|scrape-links} [arguments...]" >&2
            exit 1
            ;;
    esac
}

main "$@"
