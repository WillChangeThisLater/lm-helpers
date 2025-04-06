#!/bin/bash

idea() {
    cat <<EOF
I am creating a repository containing a bunch of helper functions for my 'lm' tool,
which calls LLMs from the CLI

For some background: the 'lm' tool takes a prompt from stdin, passes it to a LLM,
and returns the result on stdout. The most basic usage is something like:

    \`\`\`bash
	> echo "what is 1 + 1" | lm
	$(echo "what is 1 + 1" | lm --cache)
    \`\`\`

However, as I have used this script more I've found myself building up
bespoke bash scripts, which I normally call 'prompt.sh', that generate a
base prompt with relevant context for the project I am working on.

For instance, I'm working on a project called 'embed-everything', where the
goal is to create a CLI tool that will let me embed text/image/video/audio files
locally for local RAG. The 'prompt.sh' for that project looks like:

\`\`\`prompt.sh
$(cat -n ~/personal-repos/embed-everything/prompt.sh)
\`\`\`

I've done this for enough project now that some patterns are starting to emerge:

  (a) I often rely on a system prompt for describing a repository. This uses
      'tree' to show the directory tree of the project, and a tool called 'repocat'
	  to show the contents of every file in the repo

  (b) When I need to refer to external webpages for context, I'll use 'lynx -dump <webpage>'
      to pull in the content. However, often this content has a ton of irrelevant information,
	  so something I do pretty often as well is 'lynx -dump <webpage> | lm --prompt "summarize the important info from this webpage verbatim" --cache'

I'm sure there are some other patterns that are missing as well.

My aim now is to build up a bash library where I can reference common prompts/patterns
easily. For instance, I want to be able to define a standard 'describe_project' function
that emits the tree/repocat info detailed in (a), and a 'site_summarize' function that
emits a LLM-summarized version of a site as described in (b)
EOF
}

main() {
	cat <<EOF
Idea:
	$(idea)

What is the best approach for this? Ideally I'd like to have all my helper functions in
one single script, but still be able to call any of them at any time from another script
or the CLI. But I'm not sure how to go about this
EOF
}

main
