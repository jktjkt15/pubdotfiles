#!/bin/fish
set t ( 
cat ~/.local/share/nvim/workspaces \
| tr '\0x00' ' ' \
| fzf -d " " --with-nth=1,2)

set res (string split " " $t)
nvim project $res[1]
