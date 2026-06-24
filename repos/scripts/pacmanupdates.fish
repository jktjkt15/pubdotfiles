#!/bin/fish

set updates (checkupdates | wc -l | xargs)

echo -e "󰚰 $updates"
