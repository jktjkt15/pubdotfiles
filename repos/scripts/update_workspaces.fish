#! /bin/fish

set path ~/repos/work
exa -D1 --icons=never $path | xargs -I{} echo $path/{} | xargs -I{} fish -c "cd {} && nvim --headless -c 'lua require(\'workspaces\').add(\'{}\')' -c 'q'"
