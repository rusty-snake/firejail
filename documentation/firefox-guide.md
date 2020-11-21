# Firefox Sandboxing Guide
{:.no_toc}

+ ToC
{:toc}

**TLDR**

<iframe class='youtube-player' width='625' height='352' src='https://www.youtube.com/embed/kCnAxD144nU?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en&#038;autohide=2&#038;wmode=transparent' allowfullscreen='true' style='border:0;' sandbox='allow-scripts allow-same-origin allow-popups allow-presentation'></iframe>


## Introduction

In August 2015, Mozilla was notified by security researcher Cody Crews that a malicious
advertisement on a Russian news site was [exploiting](https://blog.mozilla.org/security/2015/08/06/firefox-exploit-found-in-the-wild/)
a vulnerability in Firefox's PDF Viewer. The exploit payload searched for sensitive files on users'
local filesystem, and reportedly uploaded them to the attacker's server. The default Firejail
configuration blocked access to `.ssh`, `.gnupg` and `.filezilla` in all directories present under
`/home`. More advanced sandbox configurations blocked everything else.

This document describes some of the most common Firefox sandbox setups. We start with the default
setup, recommended for entertainment and casual browsing.


## Starting Firefox

The easiest way to start a sandbox is to prefix the command with `firejail`:

~~~ terminal
$ firejail firefox
~~~

<!-- FIXME: wordpress link -->
If the sandbox was already integrated with your desktop manager by running `sudo firecfg` as
described on our [Download](https://firejail.wordpress.com/download-2/) page, just start your
browser as you used to using your desktop manager menus.

_Note: by default, a single Firefox process instance handles multiple browser windows. If you
already have Firefox running, you would need to use `--no-remote` command line option, otherwise
you end up with a new tab or a new window attached to the existing Firefox process:_

~~~ terminal
$ firejail firefox -no-remote
~~~


## Sandbox description

The filesystem container is created when the sandbox is started and destroyed when the sandbox is
closed. It is based on the current filesystem installed on users computers. We strongly recommend
updating the operating system on a regular basis. The sandbox allows Firefox to access only a small
set of files and directories. All private user information has been removed from the home directory.

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2015/12/firefox-whitelist.png)  
_Whitelisting home files and directories for Firefox browser._

_Note: Only `~/Downloads` and `~/.mozilla` directories are real, all other directories are created
by Firefox. The same home directory layout is imposed by Firejail for all supported browsers and
BitTorrent clients. **Please make sure you save all your downloaded files in `~/Downloads` directory.**_

This is how the rest of the filesystem looks like:


 * /boot &ndash; blacklisted
 * /bin &ndash; read-only
 * /dev &ndash; read-only; a small subset of drivers is present, everything else has been removed
 * /etc &ndash; read-only; /etc/passwd and /etc/group have been modified to reference only the current user;
   you can enable a subset of the files by editing /etc/firejail/firefox-common.profile (uncomment private-etc line in that file)
 * /home &ndash; only the current user is visible
 * /lib, /lib32, /lib64 &ndash; read-only
 * /proc, /sys &ndash; re-mounted to reflect the new PID namespace; only processes started by the browser are visible
 * /sbin &ndash; blacklisted
 * /selinux &ndash; blacklisted
 * /usr &ndash; read-only; /usr/sbin blacklisted
 * /var &ndash; read-only; similar to the home directory, only a skeleton filesystem is available
 * /tmp &ndash; only X11 directories are present

Password files, encryption keys and development tools are removed from the sandbox. If Firefox
tries to access a blacklisted file, log messages are sent to syslog. Example:

~~~
Dec 3 11:43:25 debian firejail[70]: blacklist violation - sandbox 26370, exe firefox, syscall open64, path /etc/shadow
Dec 3 11:46:17 debian firejail[70]: blacklist violation - sandbox 26370, exe firefox, syscall opendir, path /boot
~~~

The following security filters are enabled by default. The purpose of these filters is to reduce
the attack surface of the kernel, and to protect the filesystem container:

 * **seccomp-bpf** &ndash; we use a large blacklist seccomp filter. It is a dual 32-bit/64-bit filter.
 * **protocol** &ndash; this seccomp-based filter checks the first argument of socket system call. It allows IPv4, IPv6, UNIX and netlink.
 * **noroot user namespace** &ndash; it installs a namespace with only the current user.
 * **capabilities** &ndash; the sandbox disables all Linux capabilities, restricting what a root user can do in the sandbox.
 * **AppArmor** &ndash; starting with Firejail version 0.9.53, if AppArmor is active on the system and
   /etc/apparmor.d/firejail-default is enabled, the profile will be activated by default for about 140 applications,
   including browsers, BitTorrent clients and media players.

seccomp configuration enforces the rules by killing the browser process. Log messages are sent to
syslog. Example:

~~~
Dec 8 09:48:21 debian kernel: [ 4315.656379] audit: type=1326 audit(1449586101.336:8): auid=1000 uid=1000 gid=1000 ses=1 pid=22006 comm="chmod" exe="/bin/chmod" sig=31 arch=c000003e syscall=268 compat=0 ip=0x7f027999f6b9 code=0x0
Dec 8 12:53:57 debian kernel: [17261.662738] audit: type=1326 audit(1450461237.367:2): auid=1000 uid=1000 gid=1000 ses=1 pid=4750 comm="strace" exe="/usr/bin/strace" sig=31 arch=c000003e syscall=101 compat=0 ip=0x7ff42f8cdc6c code=0x0
~~~

For most users, the default `firejail firefox` setup is enough. The following are some special
cases:


## High security browser setup

Use this setup to access your bank account, or any other site dealing with highly sensitive private
information. The idea is you trust the site, but you don't trust the addons and plugins installed
in your browser. Use `--private` Firejail option to start with a factory default browser
configuration, and an empty home directory.

Also, you would need to take care of your DNS setting - current home routers are ridiculously
insecure, and the easiest attack is to reconfigure DNS, and redirect the traffic to a fake bank
website. Use `--dns` Firejail option to specify a DNS configuration for your sandbox:

~~~ terminal
$ firejail --private --dns=1.1.1.1 --dns=9.9.9.9 firefox -no-remote
~~~


## Work setup

In this setup we use `/home/username/work` directory for work, email and related Internet browsing.
This is how we start all up:

~~~ terminal
$ firejail --private=/home/username/work thunderbird &
$ firejail --private=/home/username/work firefox -no-remote &
~~~

Both Mozilla Thunderbird and Firefox think `~/work` is the user home directory. The configuration
is preserved when the sandbox is closed.


## Network setup

Assuming `eth0` is the main Ethernet interface, we create a new TCP/IP stack, we connect it to the
wired Ethernet network, and we start the browser:

~~~ terminal
$ firejail --net=eth0 firefox
~~~

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2015/12/network-firefox.png)  
_Network namespace configured in a Firejail sandbox_

To assign an IP address, Firejail ARP-scans the network and picks up a random address not already
in use. Of course, we can be as explicit as we need to be:

~~~ terminal
$ firejail --net=eth0 --ip=192.168.1.207 firefox
~~~

_Note: Ubuntu runs a local DNS server in the host network namespace. The server is not visible
inside the sandbox. Use `--dns` option to configure an external DNS server:_

~~~ terminal
$ firejail --net=eth0 --dns=9.9.9.9 firefox
~~~

By default, if a network namespace is requested, Firejail installs a network filter customized for
regular Internet browsing. It is a regular iptable filter. This is a setup example, where no access
to the local network is allowed:

~~~ terminal
$ firejail --net=eth0 --netfilter=/etc/firejail/nolocal.net firefox
~~~

On top of that, you can even add a hosts file implementing an adblocker:

~~~ terminal
$ firejail --net=eth0 --netfilter=/etc/firejail/nolocal.net \
--hosts-file=~/adblock firefox
~~~


## X11 sandbox

Firejail replaces the regular X11 server with [Xpra](http://xpra.org/) or [Xephyr](https://en.wikipedia.org/wiki/Xephyr)
servers (`apt-get install xpra xserver-xephyr` on Debian/Ubuntu), preventing X11 keyboard loggers
and screenshot utilities from accessing the main X11 server.

The commands is as follows:

~~~ terminal
$ firejail --x11 --net=eth0 firefox
~~~

A network namespace initialized with `--net` is necessary in order to disable the abstract X11
socket. If for any reasons you cannot use a network namespace, the socket will still be visible
inside the sandbox, and hackers can attach keylogger and screenshot programs to this socket.
