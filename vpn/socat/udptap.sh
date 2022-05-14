# bash ip killall socat

ip tuntap add dev tap0 mode tap
ip address add 10.0.5.1/24 dev tap0
bash -c "/usr/bin/socat udp-listen:8443,fork tun,iff-up,tun-type=tap,tun-name=tap0 &" 0</dev/null 1>/dev/null 2>/dev/null

killall /usr/bin/socat
ip address del 10.0.5.1/24 dev tap0
ip tuntap del dev tap0 mode tap

ip tuntap add dev tap0 mode tap
ip address add 10.0.5.2/24 dev tap0
bash -c "/usr/bin/socat udp:SERVERIP:8443 tun,iff-up,tun-type=tap,tun-name=tap0 &" 0</dev/null 1>/dev/null 2>/dev/null

killall /usr/bin/socat
ip address del 10.0.5.2/24 dev tap0
ip tuntap del dev tap0 mode tap
