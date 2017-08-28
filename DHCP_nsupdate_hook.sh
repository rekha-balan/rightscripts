#!/bin/sh -e

# ---
# RightScript Name: DHCP nsupdate hook
# Description: Adds a DHCP hook to update DNS using nsupdate (azure dhcp does not register names in DNS) https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-name-resolution-ddns
# Inputs:
#   ENABLE_DHCP_DNS_UPDATE:
#     Category: RightScale
#     Description: Whether to enable the DHCP hook
#     Input Type: single
#     Required: false
#     Advanced: false
#     Default: "text:true"
#     Possible Values: ["text:true", "text:false"]
# Attachments:
# - zz-nsupdate.sh
# ...
#

# Quit if server is not using Azure DNS
if [ "$ENABLE_DHCP_DNS_UPDATE" != "true" ]; then
    echo "DHCP nsupdate hook is not enabled, exiting."
    exit 0
fi

# Copy the DHCP hook into place so DHCP changes will be actioned
sudo cp "$RS_ATTACH_DIR/zz-nsupdate.sh" /etc/dhcp/dhclient-exit-hooks.d/

# Run a DNS update (because this script gets run after the initial DHCP run has happened)
{
    echo "update add $(hostname -f) 900 a $(hostname -i)"
    echo "send"
} | sudo nsupdate
