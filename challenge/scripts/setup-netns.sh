#!/bin/bash

set -ex

ip netns add internal

ip netns exec internal ip addr add 127.0.0.1/8 dev lo
ip netns exec internal ip link set lo up

ip link add veth0 type veth peer name veth1
ip link set veth0 up
ip link set veth1 netns internal up

ip addr add 10.0.0.1/24 dev veth0
ip netns exec internal ip addr add 10.0.0.2/24 dev veth1
ip netns exec internal ip route add default via 10.0.0.1 dev veth1

iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -j MASQUERADE
sysctl net.ipv4.ip_forward=1

# Port forwarding for electrs port 
iptables -t nat -A PREROUTING -p tcp --dport $ELECTRS_PORT -j DNAT --to-destination 10.0.0.2:$ELECTRS_PORT
iptables -A FORWARD -p tcp -d 10.0.0.2 --dport $ELECTRS_PORT -j ACCEPT

# Port forwarding for chall handler port
iptables -t nat -A PREROUTING -p tcp --dport $HANDLER_PORT -j DNAT --to-destination 10.0.0.2:$HANDLER_PORT
iptables -A FORWARD -p tcp -d 10.0.0.2 --dport $HANDLER_PORT -j ACCEPT