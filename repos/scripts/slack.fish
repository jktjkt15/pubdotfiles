#! /bin/fish

hyprctl workspaces | rg "lastwindowtitle: Slack" | rg -v hyprctl | rg " Slack Server - (.*+) new item" -or '$1'
