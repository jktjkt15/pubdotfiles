#! /bin/fish

set vnpstatus (expressvpn status | head -n 1 | rg "(Connected to .*)" -or '$1' --no-unicode| xargs)

if not test -z $vnpstatus
    echo "exvpn: $vnpstatus"
end
