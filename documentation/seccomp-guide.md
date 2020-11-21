# Seccomp Guide
{:.no_toc}

+ ToC
{:toc}

## Introduction

[Seccomp-bpf](https://www.kernel.org/doc/Documentation/prctl/seccomp_filter.txt) stands for secure
computing mode. It is a simple, yet effective sandboxing tool introduced in Linux kernel 3.5. It
allows the user to attach a system call filter to a process and all its descendants, thus reducing
the attack surface of the kernel. Seccomp filters are expressed in Berkeley Packet Filter (BPF)
format.

In this article we build a whitelist seccomp filter and we attach it to a user program using
Firejail sandbox. Throughout the article we use [Transmission](http://www.transmissionbt.com/)
BitTorrent client as an example.

We start by extracting a list of syscalls the program uses, build the filter and run the program in
Firejail. As new syscalls are discovered during testing, the filter is updated. When everything
looks fine, we integrate the filter into a security profile suitable for Firejail. These are the
steps:


## Syscalls

Linux has several tools for listing syscalls. The easiest one to use seems to be [strace](http://sourceforge.net/projects/strace/)
(`apt-get install strace`). We start `transmission-gtk` in `strace` using `-qcf` options (`quiet`,
`count`, `follow`).

~~~ terminal
$ strace -qcf transmission-gtk
~~~

We play for about 5 minutes with the program, go through some menus, start and stop a download etc.

<!-- FIXME: wordpress image -->
![](https://l3net.files.wordpress.com/2015/04/seccomp-transmission.png)  
_transmission-gtk BitTorrent client_

As we close the program, strace prints the syscall list on the terminal:

~~~ terminal
% time seconds usecs/call calls errors syscall
------ ----------- ----------- --------- --------- ----------------
42.93 3.095527 247 12512 poll
19.64 1.416000 2975 476 select
13.65 0.984000 3046 323 nanosleep
12.09 0.871552 389 2239 330 futex
11.47 0.827229 77 10680 epoll_wait
0.08 0.005779 66 88 fadvise64
0.06 0.004253 4 1043 193 read
0.06 0.004000 3 1529 3 lstat
0.00 0.000344 0 2254 1761 stat
[...]
0.00 0.000000 0 1 fallocate
0.00 0.000000 0 24 eventfd2
0.00 0.000000 0 1 inotify_init1
------ ----------- ----------- --------- --------- ----------------
100.00 7.210150 95061 23256 total
~~~


## Firejail

We bring `strace` output (cut&paste) in a text editor and clean it up. We extract a comma-separated
list without any blanks, something like:

~~~
poll,select,nanosleep,futex,epoll_wait,fadvise64,read,lstat,stat,[...]
~~~

We use `--seccomp.keep` option to start Firejail, and `--shell=none` to run the program directly
without the extra syscalls required by a shell:

~~~ terminal
$ firejail --shell=none --seccomp.keep=poll,select,[...] transmission-gtk
~~~

<!-- FIXME: wordpress image -->
![](https://l3net.files.wordpress.com/2015/04/seccomp-xterm2.png)

It looks ugly in this moment, a kilometer-long command line that doesn't even work. For some
reasons `strace` missed some syscalls. Time to bring in the system logger.


## Syslog

If we get errors in the terminal, we just add the missing syscall to the list and try again. But
this is not always the case. Most of the time Linux kernel will just kill the process and send
audit messages to syslog. For this reason, we keep another terminal open monitoring syslog:

~~~ terminal
$ sudo tail -f /var/log/syslog
~~~

<!-- FIXME: wordpress image -->
![](https://l3net.files.wordpress.com/2015/04/seccomp-syslog.png)

The log entry tells us exactly what system call number crashed the program, `syscall=201` in the
example above. To associate the number with a name, we use firejail as follows:

~~~ terminal
$ firejail --debug-syscalls | grep 201
201 - time
~~~

We keep on adding syscalls to the list as they are reported and try again. To get Transmission
working we ended up adding `pwrite64,time,exit,exit_group` on top of what `strace` reported &ndash;
not too bad!


## Security profiles

Firejail installs in `/etc/firejail` directory security profiles for several popular programs. The
profiles define a manicured filesystem with most directories mounted read-only, and several files
and directories blanked in $HOME, mainly files holding passwords and encryption keys.

Transmission BitTorrent client is supported, and the profile also defines a default seccomp
blacklist filter. I want to upgrade this filter to the whitelist filter I've just built. For this,
I go into `~/.config/firejail` directory and copy the default Transmission profile there:

~~~ terminal
$ cd ~/.config/firejail
$ cp /etc/firejail/transmission-gtk.profile .
$ vim transmission-gtk.profile
~~~

We add a `shell none` line, and we replace `seccomp` with `seccomp.keep poll,select,nanosleep,futex,epoll_wait,fadvise64,[...]`.
The result looks like this:

~~~ terminal
$ cd ~/.config/firejail
$ cat transmission-gtk.profile
# transmission-gtk profile
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
blacklist ${HOME}/.pki/nssdb
blacklist ${HOME}/.lastpass
blacklist ${HOME}/.keepassx
blacklist ${HOME}/.password-store
blacklist ${HOME}/.wine
caps.drop all
protocol unix,inet,inet6
netfilter
noroot
tracelog
shell none
seccomp.keep poll,select,nanosleep,futex,epoll_wait,fadvise64,read,lstat,stat,epoll_ctl,sendto,readv,recvfrom,ioctl,write,inotify_add_watch,writev,socket,getdents,mprotect,mmap,open,close,fstat,lseek,munmap,brk,rt_sigaction,rt_sigprocmask,access,pipe,madvise,connect,sendmsg,recvmsg,bind,listen,getsockname,getpeername,socketpair,setsockopt,getsockopt,clone,execve,uname,fcntl,ftruncate,rename,mkdir,rmdir,unlink,readlink,umask,getrlimit,getrusage,times,getuid,getgid,geteuid,getegid,getresuid,getresgid,statfs,fstatfs,prctl,arch_prctl,epoll_create,set_tid_address,clock_getres,inotify_rm_watch,set_robust_list,fallocate,eventfd2,inotify_init1,pwrite64,time,exit,exit_group
$
~~~

The command `caps.drop all` in the security profile above disables all capabilities.
[Linux capabilities](https://l3net.wordpress.com/2015/03/16/firejail-linux-capabilities-guide/)
feature of Linux kernel is similar to seccomp, but works deep inside the kernel.

The command `protocol unix,inet,inet6` is the protocol filter. Only UNIX socket, IPv4 and IPv6
protocols are allowed. The protocol filter is also built as a seccomp filter.

Between seccomp, capabilities and protocols more than half the kernel code is disabled.

Firejail chooses the profile automatically, based on the name of the executable. To run
Transmission with all security features enabled, the command is:

~~~ terminal
$ firejail transmission-gtk
~~~

<!-- FIXME: wordpress image -->
![](https://l3net.files.wordpress.com/2015/04/seccomp-transmission-final.png)  
_transmission-gtk started in Firejail using the profile file_


## Conclusion

Whitelist seccomp filters are easy to build, yet they need lots of testing. The filters are not
portable. For example this filter build on Debian Wheezy will not work on Ubuntu 14.04. The exact
list of syscalls depends on the kernel running the system, the version of the program and all the
libraries the program is linking in.

