#!/bin/fish
set id (wpctl status | grep DX5 | grep vol | tr "*" " " |  awk '{print $2}' | tr "." " ")

wpctl set-volume $id $argv[1]
