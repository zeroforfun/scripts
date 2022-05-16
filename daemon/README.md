### 后台执行命令

#### /usr/bin/bash -c "$command &" 0</dev/null 1>/dev/null 2>/dev/null

linux 用户经常需要指令后台执行，但很多工具并不支持后台执行

此命令可将命令后台执行

理想的后台的是一个孤儿进程

且 stdin stdout stderr 均重定向至 /dev/null

其他来源相关问题的讨论常用的方法是 $command 1>/dev/null 2>&1 &

这种方法的父进程是与用户交互的 bash 进程 且生成进程的 stdin 是与用户交互的 bash 进程的 tty

与用户交互的 bash 进程仍对后台进程有影响 用户退出 bash 的一些异常情况可能导致后台进程的非预期退出

而此处给出的指令能使生成的进程立即结束当前与用户交互的 bash 进程的父子进程的关系

原理是制造孤儿进程，指令中的 & 使得指令中的 bash 进程不会阻塞，fork exec 后立即退出

指令中的 /usr/bin/bash 进程退出，即 $command 的父进程退出

$command 成为孤儿进程，孤儿进程会被操作系统继续向上寻找可以接受子进程的父进程的父进程接受为子进程

具体而言，linux 所有用户进程不断向上寻找父进程的结果都是 1 号进程 /sbin/init 

通常 $command 的父进程变为为 1 号进程，如 systemd 作为 1 号 init 进程启动操作系统的，systemd 会通过系统调用使某些非 init 进程可以接收孤儿进程

此时若 $command 的历代父进程中有这样的进程，则该进程会成为 $command 的父进程，$command 进程无法干预

0</dev/null 1>/dev/null 2>/dev/null 部分把 $command 的 stdin stdout stderr 均重定向至 /dev/null

由命令 ls -lAF /proc/1/fd/{0,1,2} 可知 1 号进程的 stdin stdout stderr 均重定向至 /dev/null

通过这样的重定向，/usr/bin/bash 的 stdin stdout stderr 就已经重定向至 /dev/null 因此不会输出类似 $command 1>/dev/null 2>&1 & 会输出的进程号，更加干净

### 后台执行 bash 脚本

#### bash -c "bash -c 'while :; do echo; sleep 0.5; done;' &" 0</dev/null 1>/dev/null 2>/dev/null

原理可类比，此处第一个 bash 退出 第二个 bash 作为孤儿进程 后台执行 bash 脚本

### 制作脚本方便使用

脚本在本目录内 daemon 文件

使用方法 ./daemon ncat -l 8080

原理不赘述
