### 说明

脚本需要 bash echo ip iptables jq killall openssl ping xargs 指令可以正确执行

确保客户端可联网 需要登录的 wifi 需要额外的考虑 尤其是登录网页的 ip 地址路由路径不会改变 可使用指令 ip -json route get LOGWEBIP | jq -r .[0].gateway | xargs ip route add LOGWEBIP via

均没有其他执行且重要不可退出的 socat ping 进程

均没有 10.0.5.0/24 网段的设备

服务端没有与 bridge0 tap0 重名的网络设备

服务端的防火墙不会干扰连接转发或服务端没有防火墙

服务端没有 nat 其他网端 或不会对脚本有冲突或干扰

服务端 8443 端口没有被占用

客户端没有与 tap0 重名的网络设备

客户端 10.0.5.0/24 网段没有被占用

客户端路由表原本 0.0.0.0/1  128.0.0.0/1 没有配置

脚本中的 SERVERIP 应被替换为 服务端的 ip 地址

可使用命令 sed 's/SERVERIP/1.2.3.4/g' ./tlsvpn.sh 打印转换后脚本

若不希望使用 10.0.5.0/24 网段 可替换为其他网段和地址

脚本分为 5 个部分 分别为 自签名证书 服务端开启代码 服务端关闭代码 客户端开启代码 客户端关闭代码 此处对部分指令做简单说明

### 自签名证书

openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout /dev/shm/server.key -out /dev/shm/server.crt -subj "/CN=server" 2>/dev/null

应被在服务端执行

openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout /dev/shm/client.key -out /dev/shm/client.crt -subj "/CN=client" 2>/dev/null

应被在客户端执行

/dev/shm/ 中的文件储存在 linux 内存中 关机后文件丢失 应根据习惯与情况更换文件路径

双方应把自己的证书 (server.crt client.crt) 发送给对方作为 cafile 证书可公开 私钥 (server.key client.key) 不可公开

指令会读取默认路径为 /etc/ssl/openssl.cfg 作为配置文件 可使用默认的文件 无配置文件 openssl 指令执行会失败

若不希望使用自签名证书 可参考 https://github.com/zeroforfun/scripts/tree/main/tls/pki.sh 构建 pki

### 服务端开启代码

echo 1 > /proc/sys/net/ipv4/ip_forward 开启路由转发 关机后失效

iptables -t nat -I POSTROUTING -s 10.0.5.0/24 -j MASQUERADE 添加 nat 路由表 关机后失效

MASQUERADE 参数是将 10.0.5.0/24 的请求根据默认的路由表进行处理

iptables -t nat -L 可用于查看 nat 表 iptables -t nat -F 可用于清理 nat 表

 iptables-save 可查看当前防火墙的多种规则

### 服务端关闭代码

### 客户端开启代码

ip -json route get SERVERIP | jq -r .[0].gateway | xargs ip route add SERVERIP via

ip -json route get SERVERIP | jq -r .[0].gateway 获取服务端 ip 原有的路由网关

ip route add SERVERIP via GATEWAY 确保服务端 ip 路由路径没有改变 否则数据会在客户端死循环发生错误

ip route add 0.0.0.0/1 via 10.0.5.1 dev tap0 和 ip route add 128.0.0.0/1 via 10.0.5.1 dev tap0

确保对于除内网 ip 服务端 ip 外 ip 的访问全部路由到服务端 不使用 ip route add 0.0.0.0/0 via 10.0.5.1 dev tap0 是因为避免与原有默认路由的冲突 并且不需要删除默认路由便于恢复

### 客户端关闭代码
