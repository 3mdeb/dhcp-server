# dhcp-server
Simple isc-dhcp-server running in docker container

## Usage

Clone the repo:

```
git clone git@github.com:3mdeb/dhcp-server.git
```

Customize DHCP configuration in `data/dhcpd.conf` to Your needs.

Run:

```
./start.sh
```

The script above builds and runs a docker container with DHCP server. By default
thes server is listening on `eno1` interface. It can be changed by editing
`start.sh` script:

```
"bash /entrypoint.sh eno1;/bin/bash"
```

Running the script with no interface specified will cause DHCP listening on all
possible interfaces.

## Features

The server is reading configuration from `/data` directory and saves a lease
file in that directory to ensure persistency.

`entrypoint.sh` takes care of running the server and checking the existence of
dhcpd and interface files. `dhcpd` user is created with the same gid and uid as
the owner of configuration and leases file, so the server can use them without
changing permissions.


## Notes

The DHCP server is running in the foreground printing debug messages to the
screen. It can be terminated by pressing `Ctrl+C` combination which will
redirect to container's bash. Container can be stopped then by typing `exit`.