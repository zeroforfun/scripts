ip netns add netns0
ip netns add netns1
ip -netns netns0 link set dev lo up
ip -netns netns1 link set dev lo up
ip -netns netns0 link add name veth0 type veth peer name veth1
ip -netns netns0 link set dev veth1 netns netns1
ip -netns netns0 address add 10.0.0.1/24 dev veth0
ip -netns netns1 address add 10.0.0.2/24 dev veth1
ip -netns netns0 link set dev veth0 up
ip -netns netns1 link set dev veth1 up
ip -netns netns0 link add name bridge0 type bridge
ip -netns netns0 address add 10.0.5.1/24 dev bridge0
ip -netns netns0 link set dev bridge0 up
ip -netns netns0 tuntap add dev tap0 mode tap
ip -netns netns1 tuntap add dev tap1 mode tap
ip -netns netns0 link set dev tap0 master bridge0
ip -netns netns0 link set dev tap0 up
ip -netns netns1 address add 10.0.5.2/24 dev tap1
ip -netns netns1 link set dev tap1 up
ip netns exec netns1 bash -c "/usr/bin/ping -I tap1 -i 4 10.0.5.1 &" 0</dev/null 1>/dev/null 2>/dev/null
ip netns exec netns0 bash -c "/usr/bin/socat -T5 tcp-listen:1500,fork,reuseaddr tun,iff-up,tun-type=tap,tun-name=tap0 &" 0</dev/null 1>/dev/null 2>/dev/null
ip netns exec netns1 bash -c "/usr/bin/socat -T5 tcp:10.0.0.1:1500,forever tun,iff-up,tun-type=tap,tun-name=tap1 &" 0</dev/null 1>/dev/null 2>/dev/null
ip netns exec netns0 ping -i 0 -c 3 10.0.5.2
ip netns exec netns1 ping -i 0 -c 3 10.0.5.1
killall /usr/bin/socat
killall /usr/bin/ping
ip -netns netns1 link set dev tap1 down
ip -netns netns1 address del 10.0.5.2/24 dev tap1
ip -netns netns0 link set dev tap0 down
ip -netns netns0 link set dev tap0 nomaster
ip -netns netns1 tuntap del dev tap1 mode tap
ip -netns netns0 tuntap del dev tap0 mode tap
ip -netns netns0 link set dev bridge0 down
ip -netns netns0 address del 10.0.5.1/24 dev bridge0
ip -netns netns0 link delete dev bridge0 type bridge
ip -netns netns1 link set dev veth1 down
ip -netns netns0 link set dev veth0 down
ip -netns netns1 address del 10.0.0.2/24 dev veth1
ip -netns netns0 address del 10.0.0.1/24 dev veth0
ip -netns netns1 link set dev veth1 netns netns0
ip -netns netns0 link delete dev veth0 type veth peer name veth1
ip -netns netns1 link set dev lo down
ip -netns netns0 link set dev lo down
ip netns delete netns1
ip netns delete netns0
