openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout /dev/shm/server.key -out /dev/shm/server.crt -subj "/CN=server" 2>/dev/null
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout /dev/shm/client.key -out /dev/shm/client.crt -subj "/CN=client" 2>/dev/null

ip link add name bridge0 type bridge
ip address add 10.0.5.1/24 dev bridge0
ip link set dev bridge0 up
ip tuntap add dev tap0 mode tap
ip link set dev tap0 master bridge0
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -I POSTROUTING -s 10.0.5.0/24 -j MASQUERADE
bash -c "/usr/bin/socat -T5 openssl-listen:8443,cipher=ECDHE-RSA-AES256-GCM-SHA384,verify=1,commonname=client,cafile=/dev/shm/client.crt,certificate=/dev/shm/server.crt,key=/dev/shm/server.key,fork,reuseaddr tun,iff-up,tun-type=tap,tun-name=tap0 &" 0</dev/null 1>/dev/null 2>/dev/null

killall /usr/bin/socat
iptables -t nat -D POSTROUTING -s 10.0.5.0/24 -j MASQUERADE
echo 0 > /proc/sys/net/ipv4/ip_forward
ip link set dev tap0 nomaster
ip tuntap del dev tap0 mode tap
ip link set dev bridge0 down
ip address del 10.0.5.1/24 dev bridge0
ip link delete dev bridge0 type bridge

ip -json route get SERVERIP | jq -r .[0].gateway | xargs ip route add SERVERIP via
ip tuntap add dev tap0 mode tap
ip address add 10.0.5.2/24 dev tap0
ip link set dev tap0 up
ip route add 0.0.0.0/1 via 10.0.5.1 dev tap0
ip route add 128.0.0.0/1 via 10.0.5.1 dev tap0
bash -c "/usr/bin/ping -I tap0 -i 4 10.0.5.1 &" 0</dev/null 1>/dev/null 2>/dev/null
bash -c "/usr/bin/socat -T5 openssl:SERVERIP:8443,cipher=ECDHE-RSA-AES256-GCM-SHA384,verify=1,commonname=server,cafile=/dev/shm/server.crt,certificate=/dev/shm/client.crt,key=/dev/shm/client.key,retry=65536 tun,iff-up,tun-type=tap,tun-name=tap0 &" 0</dev/null 1>/dev/null 2>/dev/null

killall /usr/bin/socat
killall /usr/bin/ping
ip route del 128.0.0.0/1 via 10.0.5.1 dev tap0
ip route del 0.0.0.0/1 via 10.0.5.1 dev tap0
ip link set dev tap0 down
ip address del 10.0.5.2/24 dev tap0
ip tuntap del dev tap0 mode tap
ip route del SERVERIP
