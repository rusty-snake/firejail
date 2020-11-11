# Linux Capabilities Guide

**Contents**

 * [Introduction](#introduction)
 * [Building a Whitelist Capabilities Set](#building-a-whitelist-capabilities-set)
 * [Common Servers](#common-servers)
 * [Unprivileged Programs](#unprivileged-programs)
 * [Conclusion](#conclusion)

## Introduction

Traditional UNIX implementations distinguish between two categories of processes: privileged and
unprivileged. Privileged processes bypass all kernel permission checks, while unprivileged
processes are subject to full permission checking based on effective user and group ids (UID/GID),
and supplementary group list.

With the introduction of capabilities in Linux kernel 2.2, this has changed. Capabilities (POSIX
1003.1e) are designed to split up the root privilege into a set of distinct privileges which can be
independently enabled or disabled. These are used to restrict what a process running as root can do
in the system. For instance, it is possible to deny filesystem mount operations, deny kernel module
loading, prevent packet spoofing by denying access to raw sockets, deny altering attributes in the
file system.

In this article we describe the Linux capabilities feature of [Firejail](http://l3net.wordpress.com/projects/firejail/)
security sandbox. Firejail allows the user to start programs with a specified set of capabilities.
The set is applied to all processes running inside the sandbox, thus restricting what processes can
do, and somehow reducing the attack surface of the kernel.

## Building a Whitelist Capabilities Set

We start with a simple [nginx](http://nginx.org/) web server example, and we use `--caps.keep`
option to configure the allowed set of capabilities for the server processes. The set is expressed
as a comma-separated list of names. For a list of all capabilities available on your system run
`man 7 capabilities` or `firejail --debug-caps`:

```terminal
$ firejail --debug-caps
0 - chown
1 - dac_override
2 - dac_read_search
3 - fowner
4 - fsetid
5 - kill
6 - setgid
7 - setuid
8 - setpcap
...
```

For our nginx server we can tell off the bat that we need at least the following: `CAP_SETUID`,
`CAP_SETGID` and `CAP_NET_BIND_SERVICE`. We need the first two because the server changes the user
and group ids of the working processes from root to a generic unprivileged user. We need
`CAP_NET_BIND_SERVICE` to bind to TCP port 80. We start the sandbox with this whitelist, and add
more capabilities as required. First try:

```terminal
(started as root)
# firejail --caps.keep=setgid,setuid,net_bind_service /etc/init.d/nginx start
Reading profile /etc/firejail/server.profile
Reading profile /etc/firejail/disable-mgmt.inc

** Note: you can use --noprofile to disable server.profile **

Parent pid 6943, child pid 6944
The new log directory is /proc/6944/root/var/log
Child process initialized
Starting nginx: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: [emerg] chown("/var/lib/nginx/body", 33) failed (1: Operation not permitted)
nginx: configuration file /etc/nginx/nginx.conf test failed

parent is shutting down, bye...
```

The server tries to change the ownership of `/var/lib/nginx/body`, and failing to do so, shuts
down. We need to add `CAP_CHOWN` to our whitelist:

```terminal
# firejail --caps.keep=setgid,setuid,net_bind_service,chown /etc/init.d/nginx start
Reading profile /etc/firejail/server.profile
Reading profile /etc/firejail/disable-mgmt.inc

** Note: you can use --noprofile to disable server.profile **

Parent pid 6953, child pid 6954
The new log directory is /proc/6954/root/var/log
Child process initialized
Starting nginx: nginx.
```

With this modification, the server is running. The same way we can build capabilities list for all
regular servers we use everyday.

## Common Servers

These are whitelist examples for some common servers. For increased security, we also enable the
default [seccomp](http://en.wikipedia.org/wiki/Seccomp) filter:

```terminal
(nginx web server)
# firejail --caps.keep=chown,net_bind_service,setgid,setuid --seccomp /etc/init.d/nginx start

(apache web server)
# firejail --caps.keep=chown,sys_resource,net_bind_service,setuid,setgid --seccomp /etc/init.d/apache2 start

(net-snmp server)
# firejail --caps.keep=net_bind_service,setuid,setgid --seccomp /etc/init.d/snmpd start
# firejail --caps.keep=net_bind_service,setuid,setgid --seccomp /usr/sbin/snmptrapd start

(ISC DHCP server)
# firejail --caps.keep=net_bind_service,net_raw --seccomp /etc/init.d/isc-dhcp-server start
```

Notice how [ISC DHCP](https://www.isc.org/downloads/dhcp/) server doesn't require `CAP_SETUID` and
`CAP_SETGID`, and it doesn't drop root privileges. The server runs strictly as root. In this case
capabilities and/or seccomp are the only solutions to restrict the server.

## Unprivileged Programs

No capabilities are needed for running unprivileged user programs. Full permission checking is in
effect inside the kernel for these processes. However, an attacker getting control of a user
process can rise the process privileges by running setuid (SUID) programs or by exploiting the
kernel directly. Once the process becomes root, it has all capabilities available to root user.

Firejail mitigates this case by dropping all capabilities from the inheritable capabilities set in
profile files:

```terminal
$ cat /etc/firejail/firefox.profile
# Firejail profile for Mozilla Firefox (Iceweasel in Debian)
noblacklist ${HOME}/.mozilla
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
[...]
```

## Conclusion

Linux capabilities are a simple, yet very effective method to restrict processes running as root.
Firejail security sandbox can apply the same whitelist or blacklist filter to all processes in the
sandbox.

Building whitelist filters is easy, usually based on errors reported as the program starts. There
are about 35 capabilities available in the later Linux kernels, most servers need only a few of
them. On kernels 3.5 or newer capabilities are used in conjunction with seccomp filters for
increased security.
