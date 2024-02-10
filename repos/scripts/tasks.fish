#! /bin/fish
task export | jq '.[] | select(.status != "deleted") | .project' | xargs -n 1 | sort | uniq | sd '^null$' all | sort | fzf | xargs -I{} fish -c 'task next (if [ "{}" != "all" ]; echo project:{}; end)'
read
