#! /bin/fish

string split ',' 'é,è,ê,à,ù,ç' | fzf | xargs | wl-copy
