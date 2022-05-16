openvpn --daemon --config $server_conf_path

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -j MASQUERADE

iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -j MASQUERADE
echo 0 > /proc/sys/net/ipv4/ip_forward


openvpn --daemon --config $client_conf_path

ip route get $server_ip
ip route add $server_ip via $server_ip_gateway
ip route add 0.0.0.0/1 via 10.8.0.1
ip route add 128.0.0.0/1 via 10.8.0.1

ip route del 128.0.0.0/1
ip route del 0.0.0.0/1
ip route del $server_ip
