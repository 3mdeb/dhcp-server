#!/bin/bash

set -e

if [ -e "/sys/class/net/$1" ]; then
    IFACE="$1"
fi

# No arguments mean all interfaces
if [ -z "$1" ]; then
    IFACE=" "
fi

if [ -n "$IFACE" ]; then
    # Run dhcpd for specified interface or all interfaces

    data_dir="/data"
    if [ ! -d "$data_dir" ]; then
        echo "Please ensure '$data_dir' folder is available."
        exit 1
    fi

    dhcpd_conf="$data_dir/dhcpd.conf"
    if [ ! -r "$dhcpd_conf" ]; then
        echo "Please ensure '$dhcpd_conf' exists and is readable."
        exit 1
    fi
    
    # create user, to allow dhcpd using external files
    useradd dhcpd
    uid=$(stat -c%u "$data_dir")
    gid=$(stat -c%g "$data_dir")
    if [ $gid -ne 0 ]; then
        groupmod -g $gid dhcpd
    fi
    if [ $uid -ne 0 ]; then
        usermod -u $uid dhcpd
    fi

    [ -e "$data_dir/dhcpd.leases" ] || touch "$data_dir/dhcpd.leases"
    chown dhcpd:dhcpd "$data_dir/dhcpd.leases"
    if [ -e "$data_dir/dhcpd.leases~" ]; then
        chown dhcpd:dhcpd "$data_dir/dhcpd.leases~"
    fi

    exec /usr/sbin/dhcpd -4 -d -f -cf "$data_dir/dhcpd.conf" -lf "$data_dir/dhcpd.leases" $IFACE
fi
