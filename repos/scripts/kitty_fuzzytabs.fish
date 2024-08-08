#! /bin/fish
set a (kitty \@ ls |
    jq -r ' .[] | select(.is_active) | .tabs[] | select(.is_focused == false) | [.title, "id:\(.id)", "__SS__"] | @tsv ' |
    column -ts '\t')

set res (echo $a | string split __SS__ | sed '/^$/d' | fzf --cycle | awk '{ print $NF }')

kitty \@ focus-tab -m $res

# allow fzf to loop around
