#! /bin/fish

# set vnpstatus (expressvpn status | rg "(Connected to .*)" -or '$1' --no-unicode| xargs)
#
# if not test -z $vnpstatus
#     echo "exvpn: $vnpstatus"
# end

set vpnstatus (mullvad status --json | jq -r ".state")

if [ $vpnstatus = connected ]
    echo "mullvad: $(mullvad status --json | jq -r ".details.location.hostname")"
end

# mullvad status --json | jq -r ".details.location.hostname"
