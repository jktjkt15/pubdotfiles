#! /bin/fish

set path ~/repos/work
fd --base-directory $path -t d -d 1 -x fish -c "nvim \"a\" --headless -c \"lua require('workspaces').add('{.}', '$path/{.}')\" -c \"qa\""
