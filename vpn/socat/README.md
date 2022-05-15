### 使用 socat 搭建 vpn

惊奇地发现号称 ncat 升级版的 socat 支持 tun 设备的 io

且支持 tun 与 tap 两种模式

同时 socat 支持 tls 可以尝试用来搭建 tls vpn

因 tap 设备比 tun 设备支持更复杂的功能 此处不讨论 tun 设备

### 警示

socat 不是足够可靠服务端的加密软件

尤其是尝试让其作为服务器

本系列脚本只应用于内网的通信以及非敏感数据的加密处理

本系列脚本可充分展示 vpn 的主要原理以及 tls vpn 的主要原理

如果寻求更加可靠服务端的加密软件 应使用 haproxy nginx httpd openvpn 等

#### 经过测试 socat 可用于搭建 vpn

socat 的 tun 模块支持指定 tun/tap 设备的名称

若设备不存在 socat 支持生成 tun/tap 设备

若设备存在 socat 支持读写已有的 tun/tap 设备

socat 支持连接成功时启动原本关闭的 tun/tap 设备

因此 socat 可以配合 bridge 支撑搭建交换机类似的网络拓扑

#### socat 支持 tls 的一些功能

此处测试时使用的 socat 版本支持 tls 1.2 不支持 tls 1.3 支持设置双方验证对方的 ca 支持验证对方 CN 不支持 crl 验证

支持指定加密算法为 ECDHE-RSA-AES256-GCM-SHA384 不支持指定 ECDHE 中使用的曲线 支持客户端设置 sni

因此 socat 对与 tls 的有限支持可以支撑 tls 加密的 vpn

ECDHE-RSA-AES256-GCM-SHA384 是 tls 1.2 中最安全的加密方法

RSA 算法支持签名和不对称加密 保证后续密钥协商期间不会被篡改避免中间人攻击

ECDHE 使用曲线算法类比 DHE 算法进行密钥协商为后续对称加密通信提供密钥

AES256 为 256 位的 AES 对称加密算法

GCM 为 AES256 加密算法使用的密文连接算法

SHA384 为 384 位的哈希算法 避免信息被篡改 但作用不关键

其中 ECDHE 的密钥协商算法的特色决定服务端和客户端都无法单独决定协商成功的密钥 可避免重放攻击

且若服务端和客户端没有存储协商成功的密钥 即使第三方留存了通信内容 后续双方私钥被泄漏 第三方也无法根据通讯数据解密通信内容 密钥协商提供前向安全

如果服务端私钥被泄露 却仍在使用 第三方可实施中间人攻击 篡改密钥协商过程 中间人分别与服务端和客户端进行密钥协商 便可篡改 AES 对称加密的内容 可监听篡改被 tls 1.2 加密的通信内容

### 文件简介

testvpn.sh 为利用 socat 和内核对于 network namespace (netns) 的支持在一个系统内搭建测试 vpn

tcpvpn.sh 为不经加密的 vpn 下层协议使用 tcp

udpvpn.sh 为不经加密的 vpn 下层协议使用 udp

tlsvpn.sh 为经 tls 加密的 vpn 下层协议使用 tcp

dtlsvpn.sh 为经 dtls 加密的 vpn 下层协议使用 udp

tcptap.sh 为连接两个 tap 设备 不加密 不做路由转发 下层协议使用 tcp

udptap.sh 为连接两个 tap 设备 不加密 不做路由转发 下层协议使用 udp

### 特点

不加密的协议可被篡改 监听 ddos攻击

本系列的脚本若使用加密 均使用 tls/dtls 版本为 1.2 的加密协议

且均选择 ECDHE-RSA-AES256-GCM-SHA384 加密算法

### 应用场景和协议选择

tcp 协议面向连接 udp 协议无连接

tls 时在 tcp 协议基础上构建的加密协议

dtls 时在 udp 协议基础上构建的加密协议

tcptap 与 udptap 适用于内网的通过 tcp/udp 端口连接两个 tap 设备

墙国防火墙针对 udp 协议的手段是发错误的包干扰 有时端口不关闭仍会收到正确的报文 但正常状态程序收到干扰报文就返回了共产党的错误结果

墙国防火墙针对 tcp 协议的手段是断开

### 测试

测试指令主要为

ping google.com

curl http://www.google.com/ -I

curl https://www.google.com/ -I

curl https://1.0.0.1/ -I

curl http://whatismyip.akamai.com/

#### 针对 tcpvpn.sh 的测试

dns 协议共产党无法干扰成功 因此 ping google.com 会正确执行

墙国会检测到以太网协议中的 tls 流量并进行干扰 因此

curl http://www.google.com/ -I 可以正确执行

curl https://www.google.com/ -I 执行非常慢有时不会成功

#### 针对 udpvpn.sh 的测试

虽然为不加密未经混淆的协议

但测试指令均正确执行

且速度没有严重损失

#### 针对 tlsvpn.sh 的测试

使用 tls 1.2 的加密协议

此处最优的选择

但服务器与客户端的私钥不应被泄漏

仅供一个客户端使用

若多客户端使用正确的密钥同时连接 将发生复杂的错误 新客户端的请求不会被正确回复 此处不详述

若有其他发生故障的客户端 服务端收不到数据会在 5 秒后断开

最优的处理方法是一旦有新的客户端正确连接 应不再处理旧客户端的请求 但脚本实现将更为复杂 此处不予实现

若客户端私钥泄漏 其他人可使用密钥文件 作为客户端 可实施 ddos

若无私钥的客户端尝试连接 连接不会成功 不会影响系统

双方 5 秒没有新的数据 均会断开连接 客户端有一个 ping 服务器的后台进程 每 4 秒 ping 一次向服务器发送一个数据包 正确连接的客户端不会因此关闭

socat 支持 tls 协议中设置 sni

sni 的作用是支持一个服务器端口可配置多个证书

由客户端握手时会发送请求服务段时期望连接的域名 即为 sni host

服务端收到后将发送指定域名的公钥

共产党有时会检测 tls 的 sni

因此可在客户端配置 sni 绕开共产党的审查

#### 针对 dtlsvpn.sh 的测试

dlts 被共产党干扰 近乎无法使用
