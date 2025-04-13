#!/bin/bash

set -euo pipefail

usage() {
    echo "Usage: $0 {describe|scrape-site|run|scrape-links} [arguments...]" >&2
    exit 1
}

scrape-links() {
    # TODO: handle utf-8 error when it occurs
    cat | llm -s "Extract the URLs. Only include full URL paths (leading with http or https)" --schema-multi "url string" | jq -r '.items[].url'
}

# Describe a project
describe() {
    local directory=${1:-.}
    echo "Directory tree:"
    tree "$directory"

    echo "Repository contents:"
    files-to-prompt "$directory"
}

scrape-site() {
    local url=""
    local summarize=0

    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --summarize)
                summarize=1
                shift
                ;;
            *)
                url="$1"
                shift
                ;;
        esac
    done

    # Check if the URL is provided
    if [ -z "$url" ]; then
        echo "Error: Please provide a URL." >&2
        return 1
    fi

    # if summarize is set, do an additional summarization step
    if [ "$summarize" -eq 1 ]; then
        lynx -dump "$url" | lm --cache --prompt "Summarize the following webpage content succinctly and clearly"
    else
        lynx -dump "$url"
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
        usage
    fi
    
    command="$1"
    shift
    
    case "$command" in
        describe-project)
            describe-project "$@"
            ;;
        scrape-site)
            scrape-site "$@"
            ;;
        run)
            run "$@"
            ;;
        scrape-links)
            scrape-links
            ;;
        *)
            echo "Error: Invalid command '$command'" >&2
            usage
            ;;
    esac
}

main "$@"
