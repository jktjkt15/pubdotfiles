#! /bin/fish
wpctl status | rg "\*" | rg -v Microphone | rg "\d+\. (.*) \[vol:" -or '$1' | xargs
