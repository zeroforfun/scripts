连接两个进程的输入输出

测试方法

第一个 terminal 执行 ncat -lk 800

第二个 terminal 执行 ncat -lk 801

第三个 terminal 执行 ./fd.pl

在第一个 terminal 输入字符并回车 会在第二个 terminal 看到

在第二个 terminal 输入字符并回车 会在第一个 terminal 看到

perl 支持 socketpair fork dup2 exec 因此支持这样的功能

bash 支持 fork dup2 exec 但不支持 socketpair 因此无法实现这样的功能
