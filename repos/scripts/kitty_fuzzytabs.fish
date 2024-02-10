#! /bin/fish
set a (kitty \@ ls |
    jq -r ' .[] | select(.is_active) | .tabs[] | select(.is_focused == false) | [.title, "id:\(.id)", "__SS__"] | @tsv ')

if [ (echo $a | string split __SS__ | count) -gt 1 ]
    set res (echo $a | string split __SS__ | string trim | sed '/^$/d' | fzf --cycle | awk '{ print $NF }')
    kitty \@ focus-tab -m $res
end
