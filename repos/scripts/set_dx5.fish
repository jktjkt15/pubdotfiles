#! /bin/fish
wpctl status | rg '(\d+)\. DX5 Headphones' -or '$1' | xargs -I{} wpctl set-default {}
