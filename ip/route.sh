ip netns add netns0
ip netns add netns1
ip netns add netns2
ip -netns netns0 link add name veth1-0 type veth peer name veth1-1
ip -netns netns0 link add name veth2-0 type veth peer name veth2-1
ip -netns netns0 link set dev veth1-1 netns netns1
ip -netns netns0 link set dev veth2-1 netns netns2
ip -netns netns0 address add 10.0.1.1/24 dev veth1-0
ip -netns netns0 address add 10.0.2.1/24 dev veth2-0
ip -netns netns1 address add 10.0.1.2/24 dev veth1-1
ip -netns netns2 address add 10.0.2.2/24 dev veth2-1
ip -netns netns0 link set dev lo up
ip -netns netns1 link set dev lo up
ip -netns netns2 link set dev lo up
ip -netns netns0 link set dev veth1-0 up
ip -netns netns0 link set dev veth2-0 up
ip -netns netns1 link set dev veth1-1 up
ip -netns netns2 link set dev veth2-1 up
ip netns exec netns0 ping -i 0 -c 3 10.0.1.2
ip netns exec netns0 ping -i 0 -c 3 10.0.2.2
ip netns exec netns1 ping -i 0 -c 3 10.0.1.1
ip netns exec netns2 ping -i 0 -c 3 10.0.2.1
# ip netns exec netns1 ping -i 0 -c 3 10.0.2.1
# ip netns exec netns1 ping -i 0 -c 3 10.0.2.2
# ip netns exec netns2 ping -i 0 -c 3 10.0.1.1
# ip netns exec netns2 ping -i 0 -c 3 10.0.1.2
ip netns exec netns1 ping -i 0 -c 3 10.0.2.1 -I veth1-1
ip netns exec netns2 ping -i 0 -c 3 10.0.1.1 -I veth2-1
# ip netns exec netns1 ping -i 0 -c 3 10.0.2.2 -I veth1-1
# ip netns exec netns2 ping -i 0 -c 3 10.0.1.2 -I veth2-1
ip -netns netns1 route add 10.0.2.0/24 via 10.0.1.1
ip -netns netns2 route add 10.0.1.0/24 via 10.0.2.1
ip netns exec netns1 ping -i 0 -c 3 10.0.2.1
ip netns exec netns2 ping -i 0 -c 3 10.0.1.1
# ip netns exec netns1 ping -i 0 -c 3 10.0.2.2
# ip netns exec netns2 ping -i 0 -c 3 10.0.1.2
ip netns exec netns0 sysctl -w net.ipv4.ip_forward=1
ip netns exec netns1 ping -i 0 -c 3 10.0.2.2
ip netns exec netns2 ping -i 0 -c 3 10.0.1.2

ip netns exec netns0 sysctl -w net.ipv4.ip_forward=0
ip -netns netns2 route del 10.0.1.0/24 via 10.0.2.1
ip -netns netns1 route del 10.0.2.0/24 via 10.0.1.1
ip -netns netns2 link set dev veth2-1 down
ip -netns netns1 link set dev veth1-1 down
ip -netns netns0 link set dev veth2-0 down
ip -netns netns0 link set dev veth1-0 down
ip -netns netns2 link set dev lo down
ip -netns netns1 link set dev lo down
ip -netns netns0 link set dev lo down
ip -netns netns2 address del 10.0.2.2/24 dev veth2-1
ip -netns netns1 address del 10.0.1.2/24 dev veth1-1
ip -netns netns0 address del 10.0.2.1/24 dev veth2-0
ip -netns netns0 address del 10.0.1.1/24 dev veth1-0
ip -netns netns2 link set dev veth2-1 netns netns0
ip -netns netns1 link set dev veth1-1 netns netns0
ip -netns netns0 link delete name veth2-0 type veth peer name veth2-1
ip -netns netns0 link delete name veth1-0 type veth peer name veth1-1
ip netns delete netns2
ip netns delete netns1
ip netns delete netns0

ip netns exec netns0 cat /proc/sys/net/ipv4/ip_forward
ip netns exec netns1 cat /proc/sys/net/ipv4/ip_forward
ip netns exec netns2 cat /proc/sys/net/ipv4/ip_forward
