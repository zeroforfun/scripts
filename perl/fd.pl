#!/usr/bin/perl
use Socket;
use POSIX qw(:unistd_h);
socketpair($f, $c, AF_UNIX, SOCK_STREAM, PF_UNSPEC);
if (0 == fork) {
  dup2(fileno($c), 0);
  dup2(fileno($c), 1);
  exec 'ncat', '127.0.0.1', '800';
}
dup2(fileno($f), 0);
dup2(fileno($f), 1);
exec 'ncat', '127.0.0.1', '801';
