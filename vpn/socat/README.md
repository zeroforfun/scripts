### 使用 socat 搭建 vpn

惊奇地发现号称 ncat 升级版的 socat 支持 tun 设备的 io

且支持 tun 与 tap 两种模式

#### 经过测试 socat 可用于搭建 vpn

socat 的 tun 模块支持指定 tun/tap 设备的名称

若设备不存在 socat 支持生成 tun/tap 设备

若设备存在 socat 支持读写已有的 tun/tap 设备

socat 支持连接成功时启动原本关闭的 tun/tap 设备

因此 socat 可以配合 bridge 支撑搭建交换机类似的网络拓扑

#### socat 支持 tls 的一些功能

此处测试时使用的 socat 版本支持 tls 1.2 不支持 tls 1.3 支持设置双方验证对方的 ca 支持验证对方 CN 不支持 crl 验证

支持指定加密算法为 ECDHE-RSA-AES256-GCM-SHA384 不支持指定 ECDHE 中使用的曲线 支持指定客户端的 sni

因此 socat 对与 tls 的有限支持可以支撑 tls 加密的 vpn

### 备注

因 tap 设备比 tun 设备支持更复杂的功能 此处不讨论 tun 设备

### 文件简介

testvpn.sh 为利用 socat 和内核对于 network namespace (netns) 的支持在一个系统内搭建测试 vpn

tcpvpn.sh 为不经加密的 vpn

tlsvpn.sh 为经 tls 加密的 vpn
