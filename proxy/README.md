### socks4

支持认证 不支持使用域名 支持 tcp 不支持 udp

支持 socks4 的软件比较少

### socks4a

支持认证 支持使用域名 支持 tcp 不支持 udp

将 socks4 中的 ip 地址设为非法的 ip 地址 0.0.0.1

支持 socks4a 的软件比较少

### socks5

支持认证 支持使用域名 支持 tcp 支持 udp 支持服务端 bind

udp 和 服务端 bind 通常不应被使用 可能带来网络安全风险

有些服务端程序如 dante 会按照协议向客户端发送 tcp 连接目标服务器使用的真实地址 可能带来网络安全风险

microsocks 不会按照协议向客户端发送 tcp 连接目标服务器使用的真实地址 相关字节填充为 0 不支持 udp 不支持 bind 因此 microsocks 为更好选择

后台运行 microsocks 的方法 /usr/bin/bash -c "/usr/bin/microsocks -i 127.0.0.1 -p 1080 &" 0</dev/null 1>/dev/null 2>/dev/null

bind 不安全的原因是会令服务端监听一个端口 不必要不安全

udp 不安全的原因是服务器会监听另外一个 udp 端口 并把地址发送给客户端 不安全

常用 udp 协议仅为 dns 可以使用其他 dns 协议获取 dns 比如 dns over tcp   dns over tls(dot)   dns over https(doh)

测试指令

服务器地址为 127.0.0.1:1080 访问 http://whatismyip.akamai.com

bash -c 'echo -ne "\x5\x1\x0"; sleep 0.5; echo -ne "\x5\x1\x0\x3\x15whatismyip.akamai.com\x0\x50"; sleep 0.5; echo -en "GET / HTTP/1.1\r\nHost: whatismyip.akamai.com\r\n\r\n"; sleep 2' | ncat 127.0.0.1 1080 | xxd

若访问成功看到 http 报文且报文以 0500 0500 0001 0000 0000 0000 开头则服务端没有泄漏服务端连接目标服务器使用的地址

服务器地址为 127.0.0.1:1080 尝试 bind 127.0.0.1:8080

bash -c 'echo -ne "\x5\x1\x0"; sleep 0.5; echo -ne "\x5\x2\x0\x1\x0\x0\x0\x\x1f\x90"; sleep 2' | ncat 127.0.0.1 1080 | xxd

若返回 0500 0507 0001 0000 0000 0000 则不支持 bind 则安全

服务器地址为 127.0.0.1:1080 尝试 udp

bash -c 'echo -ne "\x5\x1\x0"; sleep 0.5; echo -ne "\x5\x3\x0\x1\x8\x8\x8\x8\x0\x35"; sleep 2' | ncat 127.0.0.1 1080 | xxd

若返回 0500 0507 0001 0000 0000 0000 则不支持 udp 则安全

上述的几条命令中仅为 socks5 客户端的极其简陋的实现 sleep 后为秒数 应为 1 个 rtt 的时间 如果命令失败且使用 curl 成功则应延长 sleep 时间并将 xxd 改为 cat -v 直至 cat -v 可以打印期待的报文再换做 xxd 查看具体报文 或可使用 ncat 与 curl 使用 curl 作为 socks5 客户端 使用 ncat 转发并留存通信内

#### socks5 和 socks5h

curl 等一些程序使用 socks5 socks5h 区别在于

若指定客户端使用 socks5 则客户端在本地获取域名 ip 地址放在 socks5 协议中

若指定客户端使用 socks5h 则客户端直接把域名放在 socks5 协议中

但有些软件 比如 chrome 不符合这样的约定 chrome(电脑版) 支持代理且需要在浏览器启动参数中设定 支持 socks5 但不识别 socks5h 的参数

firefox(电脑版) 支持代理 需要在 about:preferences 中设定 且有 Proxy DNS when using SOCKS v5 这样的选项

### http

tinyproxy

分为两种方法 CONNECT 和其他方法

#### 非 CONNECT 方法

非代理的 http 请求 Status Line

GET / HTTP/1.1

GET /advanced HTTP/1.1

http 代理 http 请求 Status Line

GET http://whatismyip.akamai.com/ HTTP/1.1

GET http://whatismyip.akamai.com/advanced HTTP/1.1

POST 其他方法可类比

Headers 其他字段支持其他一些功能 Proxy-Connection Proxy-Authorization 提供认证 连接重用等功能

代理服务器应把代理相关 Headers 删去后发送给目标服务器

#### CONNECT 方法

由于 https 不应由 http 代理获取修改 http 报文 因此需要 CONNECT 方法作为代理协议代理 https 协议

请求 Status Line

CONNECT whatismyip.akamai.com:443 HTTP/1.1

因此 nginx 可作为 http 协议的代理 但不可作为 https 协议的代理

由此可知即使 http 的代理 也可以使用 CONNECT 方法 相应端口设置为 80

curl 使用参数 --proxytunnel 即为为 http 连接使用 CONNECT 方法的代理

#### 两种方法对比

由此可知显然 CONNECT 更为强大

而且由于 http 代理的 Headers 和 http 访问的 Headers 混淆在一起 代理服务端处理不当可能造成死循环

且由于 http 版本的更新 代理服务器使用的 http 版本和目标服务器使用的 http 版本有时不能正确分割 Headers 代理协议需要考虑更为复杂的版本向后兼容问题

但非 CONNECT 方法因少一个阶段 握手时间少一个 RTT 因此很多客户端更加希望使用非 CONNECT 的方法 且不可配置

### https

为使用 tls 加密的 http 代理

例如 curl

curl -x https://127.0.0.1:8443

--proxy-insecure 即为不验证 https 代理服务端的证书

--proxy-cacert --proxy-capath 可为验证 https 代理服务端的证书提供 ca 的证书文件或路径

--proxy-cert --proxy-key 可指定连接 https 代理服务器使用的客户端的证书 私钥

### 软件的支持与代理的转换与嵌套

socks4(涉及 http 域名问题需正确处理 dns 问题) socks4a socks5 均可嵌套 socks4 socks4a socks5 http https代理

http https 代理通过 CONNECT 方法可嵌套 socks4 socks4a socks5 http https 代理

http 非 CONNECT 方法难以嵌套 代理的转发具体情况可以参考反向代理的实现

torsocks -a 127.0.0.1 -P 1080 $cmd 可以让 $cmd 的执行时 tcp 通过 socks5://127.0.0.1:1080 但仅支持 ip 地址 不支持域名

ncat 支持 http socks4 socks5 代理

socat 支持 http socks4 socks4a 代理

curl 支持 http(s) socks 代理

wget 支持 http(s) 代理 

apt 支持 http(s) socks5(h) 代理

chrome firefox socks 部分不再重复 均支持 http 代理

haproxy 新版本的一些功能支持 socks4 socks4a 代理

Windows 系统支持 http 代理
