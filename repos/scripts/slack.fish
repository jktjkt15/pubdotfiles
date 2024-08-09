#! /bin/fish

hyprctl workspaces | rg '!.* MAG Slack Server - (\d+) new' -or '$1'
