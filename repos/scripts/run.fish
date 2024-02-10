#!/bin/fish

if [ (kitty @ ls | jq ".[].wm_name" | xargs) = kitten_ssh ]
    kitty @ kitten ssh -t $WORK_TARGET -p 55119 -i ~/.ssh/workpc2 "~/repos/scripts/run.fish"
else
    cat ~/.local/share/nvim/workspaces | tr '\0' ' ' | fzf -d " " --with-nth=1,2 | awk {'print $1'} | xargs -I{} fish -c 'if [ "{}" != "" ]; nvim project {}; end'
end
