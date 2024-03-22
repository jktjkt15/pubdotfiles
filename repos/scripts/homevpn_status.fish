#! /bin/fish

set vnpstatus (expressvpn status | rg "(Connected to .*)" -or '$1' --no-unicode| xargs)

if not test -z $vnpstatus
    echo "exvpn: $vnpstatus"
end
