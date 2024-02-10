#!/bin/fish
set vol (wpctl status | rg vol | rg DX | rg "\d+\. DX5 Headphones.*?\[vol: (\d\.\d\d)\]" -or '$1')

echo $vol | awk "{print (\$1 * 100)\"%\"}"
