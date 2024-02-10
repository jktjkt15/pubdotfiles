#!/bin/fish
lpass ls | fzf | rg "\[id: (.*)\]" -o -r '$1' | xargs lpass show --password | wl-copy
