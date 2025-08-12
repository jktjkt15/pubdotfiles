#! /bin/fish
wpctl status | rg "\*" | rg -v Microphone | rg "\d+\. (.*) \[vol:" -or '$1' | awk '{print $1" "$2}' | xargs
