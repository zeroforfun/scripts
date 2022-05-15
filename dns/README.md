### dns 协议

成文的 dns 协议 dns(udp 53) dns(tcp 53) dot(dns over tls 853) doh(dns over https 443)

不成文的 dns 协议 dot+json(dns over https json 443)

### 主流 dns 服务器

google 8.8.8.8 8.8.4.4 dns.google

cloudflare 1.1.1.1 1.0.0.1 cloudflare-dns.com

quad9(ibm) 9.9.9.9

均支持成文的 dns 协议

google cloudflare 支持 dot+json

quad 未找到对于 dot+json 的支持

墙国 dns 114.114.114.114

关于 dns 服务器域名 ip 和证书

域名 dns.google 的 dns 解析结果即为 8.8.8.8 8.8.4.4

8.8.8.8 8.8.4.4 853 443 默认发送的证书 CN 均为 dns.google

域名 cloudflare-dns.com 的 dns 解析结果不为 1.1.1.1 或 1.0.0.1

1.1.1.1 1.0.0.1 853 443 默认发送的证书 CN 均为 cloudflare-dns.com

域名 quad9.net 的 dns 解析结果不为 9.9.9.9

9.9.9.9 853 443 默认发送的证书 CN 均为 *.quad9.net

当访问 https://8.8.8.8/ https://8.8.4.4/ https://1.1.1.1/ https://1.0.0.1/ https://9.9.9.9/ 时

相应服务器仍然发送 dns.google 或 cloudflare-dns.com *.quad9.net 的证书

这些证书均使用了 X509v3 Subject Alternative Name 的扩展

相应字段例如

DNS:dns.google, DNS:dns.google.com, DNS:*.dns.google.com, DNS:8888.google, DNS:dns64.dns.google, IP Address:8.8.8.8, IP Address:8.8.4.4, IP Address:2001:4860:4860:0:0:0:0:8888, IP Address:2001:4860:4860:0:0:0:0:8844, IP Address:2001:4860:4860:0:0:0:0:6464, IP Address:2001:4860:4860:0:0:0:0:64

DNS:cloudflare-dns.com, DNS:*.cloudflare-dns.com, DNS:one.one.one.one, IP Address:1.1.1.1, IP Address:1.0.0.1, IP Address:162.159.36.1, IP Address:162.159.46.1, IP Address:2606:4700:4700:0:0:0:0:1111, IP Address:2606:4700:4700:0:0:0:0:1001, IP Address:2606:4700:4700:0:0:0:0:64, IP Address:2606:4700:4700:0:0:0:0:6400

DNS:*.quad9.net, DNS:quad9.net, IP Address:9.9.9.9, IP Address:9.9.9.10, IP Address:9.9.9.11, IP Address:9.9.9.12, IP Address:9.9.9.13, IP Address:9.9.9.14, IP Address:9.9.9.15, IP Address:149.112.112.9, IP Address:149.112.112.10, IP Address:149.112.112.11, IP Address:149.112.112.12, IP Address:149.112.112.13, IP Address:149.112.112.14, IP Address:149.112.112.15, IP Address:149.112.112.112, IP Address:2620:FE:0:0:0:0:0:9, IP Address:2620:FE:0:0:0:0:0:10, IP Address:2620:FE:0:0:0:0:0:11, IP Address:2620:FE:0:0:0:0:0:12, IP Address:2620:FE:0:0:0:0:0:13, IP Address:2620:FE:0:0:0:0:0:14, IP Address:2620:FE:0:0:0:0:0:15, IP Address:2620:FE:0:0:0:0:0:FE, IP Address:2620:FE:0:0:0:0:FE:9, IP Address:2620:FE:0:0:0:0:FE:10, IP Address:2620:FE:0:0:0:0:FE:11, IP Address:2620:FE:0:0:0:0:FE:12, IP Address:2620:FE:0:0:0:0:FE:13, IP Address:2620:FE:0:0:0:0:FE:14, IP Address:2620:FE:0:0:0:0:FE:15

https 客户端支持这样的扩展 因此访问 https://8.8.8.8/ https://8.8.4.4/ https://1.1.1.1/ https://1.0.0.1/ https://9.9.9.9/ 仍然可以识别认可为 dns.google cloudflare-dns.com *.quad9.net 签发的证书

### dns(udp 53)

此处不详述

简单而言客户端将请求报文发送到服务端 udp 53 端口

服务端 udp 53 端口回复客户端请求结果

### dns(tcp 53)

请求报文是 dns(udp 53) 请求报文前面加上两个字节的报文长度

回复报文是 dns(udp 53) 回复报文前面加上两个字节的报文长度

### dot(dns over tls 853)

通信是经 tls 加密的 dns(tcp 53)

### doh(dns over https 443)

url

https://8.8.8.8/dns-query

https://1.1.1.1/dns-query

https://9.9.9.9/dns-query

请求分为 GET 和 POST 两种方法

GET 方法为把 dns(udp 53) 报文经过 base64 转码处理放在 url 里面

例如

curl -s -H 'accept: application/dns-message' -o - https://8.8.8.8/dns-query?dns=AAABAAABAAAAAAAAA2RucwZnb29nbGUAAAEAAQ | xxd

curl -s -H 'accept: application/dns-message' -o - https://1.1.1.1/dns-query?dns=AAABAAABAAAAAAAADmNsb3VkZmxhcmUtZG5zA2NvbQAAAQAB | xxd

此处使用 STRING 需要对 base64 转码结果进行的处理 + 替换为 -   / 替换为 _   删去 =

Headers 需要 accept: application/dns-message

POST 方法为把 dns(udp 53) 报文放在 https 的 Body 里面

Heads 需要 content-type: application/dns-message

回复均把 dns(udp 53) 报文放在 https 的 Body 里面

### dot+json(dns over https json 443)

向 google cloudflare 发送的请求中 Headers 需要 accept: application/dns-json

google url https://8.8.8.8/resolve?name=www.google.com&type=A

cloudflare url  https://1.1.1.1/dns-query?name=www.google.com&type=A

### 墙国下三滥的手段

#### dns(udp 53)

墙国检测到报文有有 google.com 共产党就发送一个伪造的干扰包

干扰包比正确的包先到达 程序收到共产党的干扰包就返回了共产党伪造的 dns 结果

如果端口不关闭可以收到后续到达的正确的包

#### dns(tcp 53)

墙国检测到报文有有 google.com 共产党就断开连接

#### dot(dns over tls 853) doh(dns over https 443) dot+json(dns over https json 443)

共产党屏蔽端口

google

8.8.8.8:443 8.8.8.8:853  8.8.4.4:443 均被共产党屏蔽 8.8.4.4:853 可正常使用

cloudflare

1.1.1.1:443 1.1.1.1:853 1.0.0.1:443 1.0.0.1:853 均可正常使用

quad

9.9.9.9:443 9.9.9.9:853 均可正常使用

### Android 对于加密 dns 支持

不完全不完善的测试

发现 Android 自动有时使用的是 1.1.1.1 853 端口

手动设置有时不支持设置为 ip 地址 即使 1.1.1.1 也不支持 必须设置为域名 可能会形成死循环
