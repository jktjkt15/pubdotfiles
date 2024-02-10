#! /bin/fish

set isVpnOn (ip addr show | rg ppp0 | wc -l)

if test $isVpnOn -ge 1
    echo "work vpn on"
end
