#!/bin/sh

# only execute on the primary nic
if [ "$interface" != "eth0" ]
then
    return
fi

fqdn=$(hostname -f)

case $reason in
    BOUND|RENEW|REBIND|REBOOT)
        {
            echo "update delete $fqdn a"
            echo "update add $fqdn 900 a $new_ip_address"
            echo "send"
        } | nsupdate ;;
    RELEASE)
        {
            echo "update delete $fqdn a"
            echo "send"
        } | nsupdate ;;
esac
