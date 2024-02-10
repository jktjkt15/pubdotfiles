#!/bin/fish
wpctl status | rg vol | rg DX | rg "(\d+)\." -or '$1' | head -n 1 | xargs -I{} wpctl set-volume {} 1

# wpctl status | rg "\*" | rg -v "Microphone"
