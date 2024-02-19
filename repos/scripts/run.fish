#!/bin/fish

cat ~/.local/share/nvim/workspaces | tr '\0' ' ' | fzf -d " " --with-nth=1,2 | awk {'print $1'} | xargs -I{} fish -c 'if [ "{}" != "" ]; nvim project {}; end'
