### 生成大的零文件

#### true | dd status=none bs=1G of=$output_file_path seek=8

很多时候 linux 需要大的零文件

尤其是把一个文件充当硬盘类似角色时，需要大小精确的大的零文件

在格式化挂载 虚拟机 chroot cryptsetup 等场景有时必不可少

一些教程使用 dd if=/dev/zero of=$output_file_path bs=1G count=8 的方法费时、并且会真实占用 8g 空间

有时可以使用 qemu-img create -f raw $output_file_path 8g

此时省时、不会真实占用 8g 空间

但有时 qemu-img 需要额外安装 且文件仍会占用极小空间

此处提供的方法为

true | dd status=none bs=1G of=$output_file_path seek=8

使用指令 du $output_file_path 或 stat $output_file_path 可看见 此方法生成的文件占用 block 为 0 而 qemu-img 生成的文件不为 0

### 进度显示

#### 在 stderr 显示实时进度 dd status=progress if=/dev/zero of=/dev/null
#### 结束时不 stderr 在显示进度 dd status=none if=/dev/zero of=/dev/null

dd 接收到 USR1 信号也会向 stderr 输出进度

USR1 信号可由 kill killall 发出 但使用 USR1 信号并不必要

### 替换大文件、二进制文件的一部分

#### dd status=none conv=notrunc if=$input_file_path of=$big_file_path bs=1 seek=$start_int

或者使用通道

#### cat $input_file_path | dd status=none conv=notrunc of=$big_file_path bs=1 seek=$start_int

修改的起始位置为 bs * seek

如果没有参数 conv=notrunc 所修改的大文件会在 修改结束处截断 文件的大小在文件系统中会变化 恢复困难

由于计算容易出错 建议使用非重要文件测试 熟练后使用

此处为了便于计算 bs 为 1

每次读 1 个字节 写入 1 个字节

果修改部分较大 修改时间会相应变长

如有必要优化速度 应不使用 bs 而是使用 ibs obs 等参数 并修改 seek 起始为 obs * seek 但有时不能整除 需要使具体情况而定 此处不详述

