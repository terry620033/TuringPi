#!/bin/bash
#
#errorExit() {
#    echo "*** $*" 1>&2
#    exit 1
#}
#
#curl --silent --max-time 2 --insecure https://localhost:6443/ -o /dev/null || errorExit "Error GET https://localhost:6443/"
#if ip addr | grep -q {{ virtual_ip }}; then
#    curl --silent --max-time 2 --insecure https://{{ virtual_ip }}:6443/ -o /dev/null || errorExit "Error GET https://{{ virtual_ip }}:6443/"
#fi


#!/bin/sh

VIRTUAL_IP="10.1.8.60"  # Replace with your virtual IP

errorExit() {
    echo "*** $*" 1>&2
    exit 1
}

# Check the API server on localhost
curl --silent --max-time 2 --insecure https://10.1.8.60:6443/healthz -o /dev/null || errorExit "Error GET https://10.1.8.60:6443/healthz"

# Check the API server on the virtual IP
if ip addr | grep -q "$VIRTUAL_IP"; then
    curl --silent --max-time 2 --insecure https://$VIRTUAL_IP:6443/healthz -o /dev/null || errorExit "Error GET https://$VIRTUAL_IP:6443/healthz"
fi

