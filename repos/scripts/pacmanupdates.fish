#!/bin/fish

set updates (checkupdates | wc -l)

echo "updates: $updates"
