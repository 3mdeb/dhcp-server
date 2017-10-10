#!/bin/bash

set -e

docker build -t 3mdeb/dhcp-server .

if [ $? -ne 0 ]; then
    echo "ERROR: Unable to build container"
    exit 1
fi


docker run --rm --name dhcpserver --privileged --net=host\
	 -p 67:67/udp -p 67:67/tcp \
	 -v ${PWD}/data:/data \
	 -t -i 3mdeb/dhcp-server /bin/bash -c \
	 "bash /entrypoint.sh eno1;/bin/bash"


