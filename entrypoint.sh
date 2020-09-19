#!/usr/bin/env bash

set -x

# Set UID
if [[ -n "${PUID}" ]]; then
    usermod -u "${PUID}" debian-deluged
fi

# Set GID
if [[ -n "${PGID}" ]]; then
    groupmod -g "${PGID}" debian-deluged
fi

# Get default connection details
eval $(/sbin/ip route list match default | awk '{if($5!="tun0"){print "DEFAULT_GW="$3"\nDEFAULT_INT="$5; exit}}')
eval $(ip r l dev "${DEFAULT_INT}" | awk '{if($5=="link"){print "GW_CIDR="$1; exit}}')

echo DEFAULT_GW="$DEFAULT_GW"
echo DEFAULT_INT="$DEFAULT_INT"
echo GW_CIDR="$GW_CIDR"
echo VPN_INTERFACE_IP="$VPN_INTERFACE_IP"

# Start VPN
if ! wg-quick up "${WG_I_NAME}"
then
  >&2 echo "Please check your VPN configuration."
  exit 1
fi

#VPN_INTERFACE_IP=$(ip addr show "${WG_I_NAME}" | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

# Allow internal route
ip route add "${LOCAL_NETWORK}" via "${DEFAULT_GW}" dev "${DEFAULT_INT}"

# Set deluge configs
su -s /bin/sh debian-deluged -c VPN_INTERFACE_IP="${VPN_INTERFACE_IP}" set-deluge-config.py

exec "$@"