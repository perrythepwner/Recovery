#!/bin/bash

set -ex

# setup network namespace + vlan + port forwarding to isolate servers
/bin/bash /root/scripts/setup-netns.sh

# hide processes
mount -o remount,rw,hidepid=2 /proc

# start sshd
/usr/sbin/sshd

# start startup scripts inside the internal network namespace
for script in /root/startup/*; do
    echo "[*] running $script"
    ip netns exec internal env \
    ELECTRS_IP=$ELECTRS_IP \
    ELECTRS_PORT=$ELECTRS_PORT \
    HANDLER_PORT=$HANDLER_PORT \
    FLAG=$FLAG \
    /bin/bash "$script"
done

tail -f /root/logs/chall/*
