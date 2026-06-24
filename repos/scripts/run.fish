#! /usr/bin/env bash

# if [ (kitty @ ls | jq ".[].wm_name" | xargs) = kitten_ssh ]
#     # kitty @ kitten ssh -tx $WORK_TARGET -p 55119 -i ~/.ssh/workpc2 -- "fish ~/repos/scripts/run.fish"
# else
cat ~/.local/share/nvim/workspaces | tr '\0' ' ' | fzf --cycle -d " " --with-nth=1,2 | awk {'print $1'} | xargs -I{} nvim project {}

# end
