ip netns add netns0
ip netns add netns0-0-0
ip netns add netns0-1-0
ip netns add netns0-1-1
ip netns add netns1
ip netns add netns1-0-0
ip netns add netns1-1-0
ip netns add netns1-1-1
ip netns add netns2
ip -netns netns0 link add name bridge0-0 type bridge
ip -netns netns0 link add name bridge0-1 type bridge
ip -netns netns1 link add name bridge1-0 type bridge
ip -netns netns1 link add name bridge1-1 type bridge
ip -netns netns0 link add name veth0-0-0-0 type veth peer name veth0-0-0-1
ip -netns netns0 link add name veth0-0-1-0 type veth peer name veth0-0-1-1
ip -netns netns0 link add name veth0-1-0-0 type veth peer name veth0-1-0-1
ip -netns netns0 link add name veth0-1-1-0 type veth peer name veth0-1-1-1
ip -netns netns1 link add name veth1-0-0-0 type veth peer name veth1-0-0-1
ip -netns netns1 link add name veth1-0-1-0 type veth peer name veth1-0-1-1
ip -netns netns1 link add name veth1-1-0-0 type veth peer name veth1-1-0-1
ip -netns netns1 link add name veth1-1-1-0 type veth peer name veth1-1-1-1
ip -netns netns0 link set dev veth0-0-0-0 master bridge0-0
ip -netns netns0 link set dev veth0-0-1-0 master bridge0-0
ip -netns netns0 link set dev veth0-1-0-0 master bridge0-1
ip -netns netns0 link set dev veth0-1-1-0 master bridge0-1
ip -netns netns1 link set dev veth1-0-0-0 master bridge1-0
ip -netns netns1 link set dev veth1-0-1-0 master bridge1-0
ip -netns netns1 link set dev veth1-1-0-0 master bridge1-1
ip -netns netns1 link set dev veth1-1-1-0 master bridge1-1
ip -netns netns0 link set dev veth0-0-0-1 netns netns0-0-0
ip -netns netns0 link set dev veth0-0-1-1 netns netns2
ip -netns netns0 link set dev veth0-1-0-1 netns netns0-1-0
ip -netns netns0 link set dev veth0-1-1-1 netns netns0-1-1
ip -netns netns1 link set dev veth1-0-0-1 netns netns1-0-0
ip -netns netns1 link set dev veth1-0-1-1 netns netns2
ip -netns netns1 link set dev veth1-1-0-1 netns netns1-1-0
ip -netns netns1 link set dev veth1-1-1-1 netns netns1-1-1
ip -netns netns0 address add 10.0.0.1/24 dev bridge0-0
ip -netns netns0 address add 10.0.1.1/24 dev bridge0-1
ip -netns netns1 address add 10.1.0.1/24 dev bridge1-0
ip -netns netns1 address add 10.1.1.1/24 dev bridge1-1
ip -netns netns2 address add 10.0.0.254/24 dev veth0-0-1-1
ip -netns netns2 address add 10.1.0.254/24 dev veth1-0-1-1
ip -netns netns0-0-0 address add 10.0.0.2/24 dev veth0-0-0-1
ip -netns netns0-1-0 address add 10.0.1.2/24 dev veth0-1-0-1
ip -netns netns0-1-1 address add 10.0.1.254/24 dev veth0-1-1-1
ip -netns netns1-0-0 address add 10.1.0.2/24 dev veth1-0-0-1
ip -netns netns1-1-0 address add 10.1.1.2/24 dev veth1-1-0-1
ip -netns netns1-1-1 address add 10.1.1.254/24 dev veth1-1-1-1
ip -netns netns0 link set dev lo up
ip -netns netns1 link set dev lo up
ip -netns netns2 link set dev lo up
ip -netns netns0-0-0 link set dev lo up
ip -netns netns0-1-0 link set dev lo up
ip -netns netns0-1-1 link set dev lo up
ip -netns netns1-0-0 link set dev lo up
ip -netns netns1-1-0 link set dev lo up
ip -netns netns1-1-1 link set dev lo up
ip -netns netns0 link set dev bridge0-0 up
ip -netns netns0 link set dev bridge0-1 up
ip -netns netns1 link set dev bridge1-0 up
ip -netns netns1 link set dev bridge1-1 up
ip -netns netns0 link set dev veth0-0-0-0 up
ip -netns netns0 link set dev veth0-0-1-0 up
ip -netns netns0 link set dev veth0-1-0-0 up
ip -netns netns0 link set dev veth0-1-1-0 up
ip -netns netns1 link set dev veth1-0-0-0 up
ip -netns netns1 link set dev veth1-0-1-0 up
ip -netns netns1 link set dev veth1-1-0-0 up
ip -netns netns1 link set dev veth1-1-1-0 up
ip -netns netns2 link set dev veth0-0-1-1 up
ip -netns netns2 link set dev veth1-0-1-1 up
ip -netns netns0-0-0 link set dev veth0-0-0-1 up
ip -netns netns0-1-0 link set dev veth0-1-0-1 up
ip -netns netns0-1-1 link set dev veth0-1-1-1 up
ip -netns netns1-0-0 link set dev veth1-0-0-1 up
ip -netns netns1-1-0 link set dev veth1-1-0-1 up
ip -netns netns1-1-1 link set dev veth1-1-1-1 up
ip -netns netns0-0-0 route add 10.0.1.0/24 via 10.0.0.1
ip -netns netns0-1-0 route add 10.0.0.0/24 via 10.0.1.1
ip -netns netns0-1-1 route add 10.0.0.0/24 via 10.0.1.1
ip -netns netns1-0-0 route add 10.1.1.0/24 via 10.1.0.1
ip -netns netns1-1-0 route add 10.1.0.0/24 via 10.1.1.1
ip -netns netns1-1-1 route add 10.1.0.0/24 via 10.1.1.1
ip -netns netns2 route add 10.0.1.0/24 via 10.0.0.1
ip -netns netns2 route add 10.1.1.0/24 via 10.1.0.1
ip -netns netns0-0-0 route add 10.1.0.0/16 via 10.0.0.254
ip -netns netns1-0-0 route add 10.0.0.0/16 via 10.1.0.254
ip -netns netns0 route add 10.1.0.0/16 via 10.0.0.254
ip -netns netns1 route add 10.0.0.0/16 via 10.1.0.254
ip -netns netns0-1-0 route add 10.1.0.0/16 via 10.0.1.1
ip -netns netns0-1-1 route add 10.1.0.0/16 via 10.0.1.1
ip -netns netns1-1-0 route add 10.0.0.0/16 via 10.1.1.1
ip -netns netns1-1-1 route add 10.0.0.0/16 via 10.1.1.1
ip netns exec netns0 sysctl -w net.ipv4.ip_forward=1
ip netns exec netns1 sysctl -w net.ipv4.ip_forward=1
ip netns exec netns2 sysctl -w net.ipv4.ip_forward=1

ip netns exec netns2 ping -i 0 -c 3 10.0.0.1
ip netns exec netns2 ping -i 0 -c 3 10.0.0.2
ip netns exec netns2 ping -i 0 -c 3 10.0.1.1
ip netns exec netns2 ping -i 0 -c 3 10.0.1.2
ip netns exec netns2 ping -i 0 -c 3 10.0.1.254
ip netns exec netns2 ping -i 0 -c 3 10.1.0.1
ip netns exec netns2 ping -i 0 -c 3 10.1.0.2
ip netns exec netns2 ping -i 0 -c 3 10.1.1.1
ip netns exec netns2 ping -i 0 -c 3 10.1.1.2
ip netns exec netns2 ping -i 0 -c 3 10.1.1.254
ip netns exec netns0-1-0 ping -i 0 -c 3 10.0.0.2
ip netns exec netns0-1-0 ping -i 0 -c 3 10.0.0.254
ip netns exec netns0-1-0 ping -i 0 -c 3 10.1.1.2
ip netns exec netns1-1-0 ping -i 0 -c 3 10.1.0.2
ip netns exec netns1-1-0 ping -i 0 -c 3 10.1.0.254
ip netns exec netns1-1-0 ping -i 0 -c 3 10.0.1.2

ip netns exec netns2 sysctl -w net.ipv4.ip_forward=0
ip netns exec netns1 sysctl -w net.ipv4.ip_forward=0
ip netns exec netns0 sysctl -w net.ipv4.ip_forward=0
ip -netns netns1-1-1 route del 10.0.0.0/16 via 10.1.1.1
ip -netns netns1-1-0 route del 10.0.0.0/16 via 10.1.1.1
ip -netns netns0-1-1 route del 10.1.0.0/16 via 10.0.1.1
ip -netns netns0-1-0 route del 10.1.0.0/16 via 10.0.1.1
ip -netns netns1 route del 10.0.0.0/16 via 10.1.0.254
ip -netns netns0 route del 10.1.0.0/16 via 10.0.0.254
ip -netns netns1-0-0 route del 10.0.0.0/16 via 10.1.0.254
ip -netns netns0-0-0 route del 10.1.0.0/16 via 10.0.0.254
ip -netns netns2 route del 10.1.1.0/24 via 10.1.0.1
ip -netns netns2 route del 10.0.1.0/24 via 10.0.0.1
ip -netns netns1-1-1 route del 10.1.0.0/24 via 10.1.1.1
ip -netns netns1-1-0 route del 10.1.0.0/24 via 10.1.1.1
ip -netns netns1-0-0 route del 10.1.1.0/24 via 10.1.0.1
ip -netns netns0-1-1 route del 10.0.0.0/24 via 10.0.1.1
ip -netns netns0-1-0 route del 10.0.0.0/24 via 10.0.1.1
ip -netns netns0-0-0 route del 10.0.1.0/24 via 10.0.0.1
ip -netns netns1-1-1 link set dev veth1-1-1-1 down
ip -netns netns1-1-0 link set dev veth1-1-0-1 down
ip -netns netns1-0-0 link set dev veth1-0-0-1 down
ip -netns netns0-1-1 link set dev veth0-1-1-1 down
ip -netns netns0-1-0 link set dev veth0-1-0-1 down
ip -netns netns0-0-0 link set dev veth0-0-0-1 down
ip -netns netns2 link set dev veth1-0-1-1 down
ip -netns netns2 link set dev veth0-0-1-1 down
ip -netns netns1 link set dev veth1-1-1-0 down
ip -netns netns1 link set dev veth1-1-0-0 down
ip -netns netns1 link set dev veth1-0-1-0 down
ip -netns netns1 link set dev veth1-0-0-0 down
ip -netns netns0 link set dev veth0-1-1-0 down
ip -netns netns0 link set dev veth0-1-0-0 down
ip -netns netns0 link set dev veth0-0-1-0 down
ip -netns netns0 link set dev veth0-0-0-0 down
ip -netns netns1 link set dev bridge1-1 down
ip -netns netns1 link set dev bridge1-0 down
ip -netns netns0 link set dev bridge0-1 down
ip -netns netns0 link set dev bridge0-0 down
ip -netns netns1-1-1 link set dev lo down
ip -netns netns1-1-0 link set dev lo down
ip -netns netns1-0-0 link set dev lo down
ip -netns netns0-1-1 link set dev lo down
ip -netns netns0-1-0 link set dev lo down
ip -netns netns0-0-0 link set dev lo down
ip -netns netns2 link set dev lo down
ip -netns netns1 link set dev lo down
ip -netns netns0 link set dev lo down
ip -netns netns1-1-1 address del 10.1.1.254/24 dev veth1-1-1-1
ip -netns netns1-1-0 address del 10.1.1.2/24 dev veth1-1-0-1
ip -netns netns1-0-0 address del 10.1.0.2/24 dev veth1-0-0-1
ip -netns netns0-1-1 address del 10.0.1.254/24 dev veth0-1-1-1
ip -netns netns0-1-0 address del 10.0.1.2/24 dev veth0-1-0-1
ip -netns netns0-0-0 address del 10.0.0.2/24 dev veth0-0-0-1
ip -netns netns2 address del 10.1.0.254/24 dev veth1-0-1-1
ip -netns netns2 address del 10.0.0.254/24 dev veth0-0-1-1
ip -netns netns1 address del 10.1.1.1/24 dev bridge1-1
ip -netns netns1 address del 10.1.0.1/24 dev bridge1-0
ip -netns netns0 address del 10.0.1.1/24 dev bridge0-1
ip -netns netns0 address del 10.0.0.1/24 dev bridge0-0
ip -netns netns1-1-1 link set dev veth1-1-1-1 netns netns1
ip -netns netns1-1-0 link set dev veth1-1-0-1 netns netns1
ip -netns netns2 link set dev veth1-0-1-1 netns netns1
ip -netns netns1-0-0 link set dev veth1-0-0-1 netns netns1
ip -netns netns0-1-1 link set dev veth0-1-1-1 netns netns0
ip -netns netns0-1-0 link set dev veth0-1-0-1 netns netns0
ip -netns netns2 link set dev veth0-0-1-1 netns netns0
ip -netns netns0-0-0 link set dev veth0-0-0-1 netns netns0
ip -netns netns1 link set dev veth1-1-1-0 nomaster
ip -netns netns1 link set dev veth1-1-0-0 nomaster
ip -netns netns1 link set dev veth1-0-1-0 nomaster
ip -netns netns1 link set dev veth1-0-0-0 nomaster
ip -netns netns0 link set dev veth0-1-1-0 nomaster
ip -netns netns0 link set dev veth0-1-0-0 nomaster
ip -netns netns0 link set dev veth0-0-1-0 nomaster
ip -netns netns0 link set dev veth0-0-0-0 nomaster
ip -netns netns1 link delete name veth1-1-1-0 type veth peer name veth1-1-1-1
ip -netns netns1 link delete name veth1-1-0-0 type veth peer name veth1-1-0-1
ip -netns netns1 link delete name veth1-0-1-0 type veth peer name veth1-0-1-1
ip -netns netns1 link delete name veth1-0-0-0 type veth peer name veth1-0-0-1
ip -netns netns0 link delete name veth0-1-1-0 type veth peer name veth0-1-1-1
ip -netns netns0 link delete name veth0-1-0-0 type veth peer name veth0-1-0-1
ip -netns netns0 link delete name veth0-0-1-0 type veth peer name veth0-0-1-1
ip -netns netns1 link delete name bridge1-1 type bridge
ip -netns netns1 link delete name bridge1-0 type bridge
ip -netns netns0 link delete name bridge0-1 type bridge
ip -netns netns0 link delete name bridge0-0 type bridge
ip netns delete netns2
ip netns delete netns1-1-1
ip netns delete netns1-1-0
ip netns delete netns1-0-0
ip netns delete netns1
ip netns delete netns0-1-1
ip netns delete netns0-1-0
ip netns delete netns0-0-0
ip netns delete netns0
