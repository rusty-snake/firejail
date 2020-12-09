# Firejail Usage
{:.no_toc}

Welcome to Firejail, a SUID security sandbox based on Linux namespaces and seccomp-bpf. We are a
volunteer weekend project and our target is the desktop. Linux beginner or accomplished programmer,
you are welcome to join us at <https://github.com/netblue30/firejail>.

This document is an effort to centralize Firejail information currently spread across several
howtos, blogs and discussion threads. I'll start with a short description of the kernel
technologies involved, move to sandbox configuration and management, and explore some of the most
common usage scenarios.

+ ToC
{:toc}

## 1. Technology

There is nothing magic about the internal workings of a sandbox, just some kernel security
technologies stack one on top of the other. As a user you don't deal with them directly, Firejail
takes care of it. We offer preconfigured security profiles for more than 400 Linux applications,
and if your application is not among them, no problem &ndash; the default configuration should just
work!

### 1.1. The Linux Kernel

All Firejail security features are implemented inside Linux kernel. The sandbox program configures
the kernel and goes to sleep. The setup is very fast, usually tens of milliseconds. In very
complicated setups it can go as high as 1 second. The memory requirements are low, all it needs is
a few MB of memory. As for slowing down the application, I don't think you'll notice any.

We divide the kernel technologies used for sandboxing in three categories:

 * Front-end sandboxing technologies:
   * Mount namespace
   * PID namespace
   * Network namespace
   * Optional: chroot, overlayfs, netfilter
 * Back-end sandboxing technologies
   * seccomp-bpf
   * Linux capabilities
   * Optional: noroot user namespace, AppArmor
 * Kernel config technologies:
   * SUID

Front-end technologies are simple and very effective. They are designed to withstand a massive
attack. We use mount, PID and network namespaces. The user can also request chroot, overlayfs and a
netfilter firewall.

Back-end technologies are smart and sophisticated. They play a support role: to keep the front-end
in place. Our main support technologies are seccomp and Linux capabilities. We use them to lock the
attacker inside the sandbox, and prevent him from becoming root. If requested, we also start a
noroot user namespace, and configure an AppArmor profile.

In the third category, we place the technologies we use to configure the kernel. Currently there
are exactly two technologies available: SUID and user namespaces. Both of them are insecure. User
namespace has the advantage when things go wrong you can blame it on kernel developers. For
Firejail we use SUID.

### 1.2 What is SUID, and how does it affect me?

SUID (**S**et owner **U**ser **ID** upon execution) is a special type of file permissions. Most
programs running on your computer inherit access permissions from the user logged in. SUID allows
the program to run as root, rather that the user who started the program.

We use this Linux feature to start the sandbox, since most kernel technologies involved in
sandboxing require root access. Once the sandbox is installed, root permissions are dropped, and
the real program is started with regular user permissions. For example in the case of a Firefox
browser, we start the sandbox as root, drop privileges, then we start the browser as a regular
user.

SUID programs are considered dangerous on multiuser systems. It is not a great idea to install
Firejail on such systems. If you have a server full of people logging in over SSH, forget about it!

Firejail was built for single-user desktop systems. We try to address desktop specific threats,
such as:

 * [Mozilla Firefox PDF exploit](https://blog.mozilla.org/security/2015/08/06/firefox-exploit-found-in-the-wild/) (2015).
   You click on a link on a website, and by the time anything shows on the screen, the guys already
   read various passwords and encryption keys stored in your home directory. Among them, the
   private SSH keys in ~/.ssh.
 * [Google Chrome scanning files in your Documents directory](http://www.dailymail.co.uk/sciencetech/article-5577055/Chromes-built-anti-virus-tool-scanning-private-files-computer.html)
   (2018). They say they scan for Windows malware and viruses. It is only a mater of time until
   this "technology" comes to Linux.

We make the assumption data stored on user's computer is more valuable then the computer itself.
This stands in direct contrast with the corporate/multiuser system philosophy, where the software
the company is trying to sell is more important than user's data. We also assume a clean, updated
system without any malicious software already installed.

There are ways to mitigate some of the problems introduced by SUID. Here are some of them:

**1. Use `firecfg`**

<!-- FIXME: wordpress link -->
Integrate your desktop software with Firejail, by running `firecfg` utility described in
[Desktop Integration](https://firejail.wordpress.com/documentation-2/basic-usage/#integration)
section. As a result, most of your desktop programs will be sandboxed automatically. From inside a
sandbox it is not possible to run SUID programs, including Firejail.

**2. Set `force-nonewprivs` flag**

If you are not using Chromium or a browser based on Chromium (Opera, etc.) turn on
`force-nonewprivs` flag in `/etc/firejail/firejail.config` file. As root, open the file in a text
editor and add this line:

~~~
force-nonewprivs yes
~~~

The flag prevents rising privileges after the sandbox was started. It is believed to clean most
SUID problems that will ever be attributed to Firejail. Unfortunately, Chromium-based browsers need
to rise privileges in order to install their own SUID sandbox.

**3. Create a special `firejail` group**

To further restrict the SUID binary, create a `firejail` group, set `/usr/bin/firejail` executable
as part of this group, change the file mode to 4750, and add only the users allowed to use Firejail
to the group. Sample set of instructions on Debian:

~~~ terminal
$ su
# addgroup firejail
# chown root:firejail /usr/bin/firejail
# chmod 4750 /usr/bin/firejail
# ls -l /usr/bin/firejail
-rwsr-x--- 1 root firejail 1584496 Apr 5 21:53 /usr/bin/firejail
~~~

To add the user to the group, type:

~~~ terminal
# usermod -a -G firejail username
~~~

A logout and login back is necessary after adding the user to the group.

**4. Consider running the long term support release**

The current LTS release was branched out from version 0.9.38 in February 2016. It includes only
bugfixes and additional SUID hardening. The code base is much smaller, and easier to audit.

## 2. Usage and Configuration

### 2.1 Installation

Try installing Firejail using your package manager first. Firejail is included in a large number of
distributions. Among them Arch, Debian, Gentoo, Mint, Slackware, Ubuntu.

<!-- FIXME: wordpress link -->
You can find newer versions of the software on our [download](https://firejail.wordpress.com/download-2/)
page. We keep there up to date .deb packages for Debian/Ubuntu/Mint and .rpm packages for
CentOS/Fedora/OpenSUSE. You can also download the source archive and compile it yourself. There are
no external dependencies, all you need is a C compiler (`sudo apt-get install build-essential`) and
a regular compile/install (`./configure && make && make install`).

After install run:

~~~ terminal
$ firecfg --fix-sound
~~~

This command fixes some bugs in PulseAudio software versions available on most Linux platforms.
After running it, logout and login again for the modifications to take effect.

### 2.2 Basic Usage

Start the sandbox by prefixing your application with `firejail`:

~~~ terminal
$ firejail firefox
Reading profile /etc/firejail/firefox.profile
Reading profile /etc/firejail/disable-common.inc
Reading profile /etc/firejail/disable-programs.inc
Reading profile /etc/firejail/disable-devel.inc
Reading profile /etc/firejail/whitelist-common.inc
Blacklist violations are logged to syslog
Child process initialized
~~~

Any type of GUI programs should work, with sound, video and hardware acceleration support. This
makes Firejail ideal for running desktop applications such as web browsers, media players, and
games.

### 2.3 Desktop Integration

To integrate Firejail with your desktop environment run:

~~~ terminal
$ sudo firecfg
~~~

As a result:

 * Clicking on desktop manager icons and menus will sandbox the application automatically. We
   support Cinnamon, KDE, LXDE/LXQT, MATE and XFCE desktop managers, and partially Gnome 3 and
   Unity. This part works well across all Linux distributions.
 * Clicking on files in your file manager will open the file in a sandboxed application. It works
   fine in newer Linux distributions like Debian "stretch", Ubuntu 17.04, Arch, Gentoo.

You can always check if your application was sandboxed by running `firejail --list` in a terminal.
Or you can keep a terminal running `firejail --top` to track your sandboxes.

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2017/07/top1.png)  
_Monitoring sandboxes with `firejail --top`_

Some users prefer desktop launchers for stating applications. A launcher is a regular text file
with .desktop extension placed in `~/Desktop` directory. This is an example for Mozilla Firefox
browser:

~~~ terminal
$ cat ~/Desktop/firefox.desktop
[Desktop Entry]
Type=Application
Name=Firefox
Icon=firefox.png
Exec=firejail firefox
Terminal=false
~~~

### 2.4 Security profiles

We distribute Firejail with over 400 security profiles, covering most common Linux applications.
Profile files have a friendly syntax, and are stored in `/etc/firejail` directory.

Profiles build by users should be placed in `~/.config/firejail` directory. If you need to add
something to an existing profile, use `include` command to bring in the original profile file,
then add your commands. For example, this is a profile for a [VLC](https://www.videolan.org/vlc/index.html)
media player without network access:

~~~ terminal
$ cat ~/.config/firejail/vlc.profile
include /etc/firejail/vlc.profile
net none
~~~

For more information see [Building Custom Profiles](https://firejail.wordpress.com/documentation-2/building-custom-profiles/)
and [Building Whitelisted Profiles](https://firejail.wordpress.com/documentation-2/building-whitelisted-profiles/)
documents.

### 2.5 Managing Sandboxes

The relevant command line options are as follow:

 * `firejail --list` &ndash; list all running sandboxes
 * `firejail --tree` &ndash; list all running sandboxes and the processes running in each sandbox
 * `firejail --top` &ndash; similar to Linux `top` command

In case a sandbox is not responding and you need to shut it down, use `--shutdown` option. First,
list the sandboxes,

~~~ terminal
$ firejail --list
3787:netblue:firejail --private
3860:netblue:firejail firefox
3963:root:firejail /etc/init.d/nginx start
~~~

and then shutdown the sandbox using the PID number from the list. In this example I shut down Firefox browser:

~~~ terminal
$ firejail --shutdown=3860
~~~

Use `--join` option if you need to join an already running sandbox and modify the filesystem, the
network parameters, or do some other admin work. I am using firefox sandbox from the previous
example:

~~~ terminal
$ firejail --join=3860
Switching to pid 3861, the first child process inside the sandbox

[netblue@debian ~]$ ps aux
USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
netblue 1 12.1 4.5 996168 320576 ? Sl 07:33 1:59 firefox
netblue 77 2.5 0.0 20916 3716 pts/2 S 07:49 0:00 /bin/bash
netblue 120 0.0 0.0 16840 1256 pts/2 R+ 07:49 0:00 ps aux

[netblue@debian ~]$
~~~

`--join` works like a regular terminal login in the sandbox. The new shell session inherits all the
sandbox restrictions.

## 3. Filesystem

### 3.1 Private Mode

Private mode is a quick way to hide all the files in your home directory from sandboxed programs.
Enable it using `--private` command line option:

~~~ terminal
$ firejail --private firefox
~~~

Firejail mounts a temporary `tmpfs` filesystem on top of `/home/user` directory. Any files created
in this directory will be deleted when you close the sandbox. You can also use an existing
directory as home for your sandbox, allowing you to have a persistent home:

~~~ terminal
$ firejail --private=~/my_private_dir firefox
~~~

### 3.2 Chroot

Most of the time I'm happy with the applications distributed by Debian "stable", but occasionally I
need a much newer version of a program or another. In this case, I build a Debian "unstable" chroot
on my "stable" system, and run my application using Firejail's chroot feature. These are the steps:

**Step 1: Build a basic Debian sid filesystem:**

~~~ terminal
$ sudo mkdir /chroot
$ sudo debootstrap --arch=amd64 sid /chroot/sid
~~~

**Step 2: Add a regular user account and install the target application** ([youtube-dl](https://rg3.github.io/youtube-dl/)
in this example):

~~~ terminal
$ sudo firejail --noprofile --chroot=/chroot/sid
# adduser netblue
# apt-get install youtube-dl
# exit
~~~

**Step 3: Run the application:**

~~~ terminal
$ firejail --chroot=/chroot/sid
$ youtube-dl https://www.youtube.com/watch?v=Yk1HVPOeoTc
~~~

The setup also works for GUI programs such as [mpv](https://mpv.io/) and [HandBrake](https://handbrake.fr/),
you just have to bring the programs in:

~~~ terminal
$ sudo firejail --noprofile --chroot=/chroot/sid
# apt-get update
# apt-get upgrade
# apt-get install handbrake mpv
~~~

### 3.3 OverlayFS

One use case for Firejail's [OverlayFS](https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt)
front-end is testing new software packages. All filesystem modifications performed while installing
and running the software are stored in overlay layer. The host filesystem is not touched.

This is an example of testing [Gnome AisleRiot](https://help.gnome.org/users/aisleriot/stable/)
game from the regular Debian repository. AisleRiot is a collection of over eighty different
solitaire card games, including popular variants such as spider, freecell, klondike, thirteen
(pyramid), yukon, canfield and many more.

The steps are as follow:

**Step 1: Start a root sandbox with a temporary OverlayFS filesystem**

~~~ terminal
$ sudo firejail --noprofile --overlay-tmpfs
~~~

This is a very relaxed sandbox. All directories are visible, with an overlay on top of them. The
only filter installed is seccomp. This means you package manager will not be able to install and
load new kernel modules. Also, if you are thinking about installing server programs, it will not
work &ndash; systemd lives in a different namespace, and it will fail to find your new server.

**Step 2: Install the program**

~~~ terminal
# apt-get install aisleriot
~~~

**Step 3: Switch to your regular user and run the program**

~~~ terminal
# su netblue
$ sol
~~~

<!-- FIXME: wordpress images -->
![](https://firejail.files.wordpress.com/2018/04/aisleriot.png)  
_Playing Klondike (AisleRiot) in a Firejail sandbox_

### 3.4 AppImage

The previous chroot and OverlayFS tricks will only get you so far. As more and more complex
applications are built by thousands of Linux users, new ways of distributing software emerged. My
favourite is [AppImage](https://appimage.org/).

We introduced AppImage support in 2016, and since then we added more features, bug fixes etc. On
their side, AppImage team kept on bringing in new cool stuff, such as a new filesystem layout and a
croud-sourced repository of [appimages](https://appimage.github.io/) for most Linux applications.

Here is a simple usage example: the latest and greatest [Kdenlive](https://kdenlive.org/) video
editor built and distributed by the developer.

<!-- FIXME: wordpress images -->
![](https://firejail.files.wordpress.com/2018/04/kdenlive.png)  
_Kdenlive AppImage running in Firejail_

I create a private home directory for this application and start the appimage in this directory:

~~~ terminal
$ mkdir ~/mykdenlive
$ firejail --private=~/mykdenlive --appimage ~/Downloads/Kdenlive-17.12.0d-x86_64.AppImage
Mounting appimage type 2
Reading profile /etc/firejail/default.profile
Reading profile /etc/firejail/disable-common.inc
Reading profile /etc/firejail/disable-passwdmgr.inc
Reading profile /etc/firejail/disable-programs.inc

** Note: you can use --noprofile to disable default.profile **

Parent pid 17670, child pid 17673
Dropping all Linux capabilities and enforcing default seccomp filter
Child process initialized in 60.82 ms
...
~~~

All the files I am editing are in `~/mykdenlive` directory, no other files in my home are visible
in the sandbox. You can find more examples in our [AppImage Support](https://firejail.wordpress.com/documentation-2/appimage-support/)
document.

### 3.5 AppArmor

Currently, AppArmor Linux security module is enabled by default on Ubuntu. On other distribution
you'll have to enable it yourself. The setup process is very easy, and it can be followed even by
Linux beginners. Here are the official instructions for [Debian](https://wiki.debian.org/AppArmor/HowToUse):

~~~ terminal
$ sudo apt install apparmor apparmor-utils
$ sudo mkdir -p /etc/default/grub.d
$ echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT apparmor=1 security=apparmor"' \
| sudo tee /etc/default/grub.d/apparmor.cfg
$ sudo update-grub
~~~

Long story short, run these commands in a terminal and restart the computer. And these are the
instructions for [Arch Linux](https://wiki.archlinux.org/index.php/AppArmor) and
[Gentoo](https://wiki.gentoo.org/wiki/AppArmor).

Like Firejail, AppArmor restricts programs' capabilities with per-program profiles. If you have an
AppArmor profile for your application, enable it. Firejail should work fine on top of AppArmor.
There is some overlap between the two technologies: both of them blacklist the same filesystem. In
case one of them misses something important, hopefully the other one picks it up.

If you don't have an AppArmor profile for your specific application, we give you one. The profile
is installed in `/etc/apparmor.d/firejail-default` file when you install Firejail. You would need
to load it into the kernel by running the following command:

~~~ terminal
$ sudo aa-enforce firejail-default
~~~

_Note: next time you start your computer, Firejail AppArmor profile will be loaded automatically
into the kernel._

Use `--apparmor` command line option to enable AppArmor confinement inside your sandboxed application:

~~~ terminal
$ firejail --apparmor warzon2100
~~~

In profile files, use `apparmor` command. This is the previous VLC profile with AppArmor support:

~~~ terminal
$ cat ~/.config/firejail/vlc.profile
include /etc/firejail/vlc.profile
net none
apparmor
~~~

### 3.6 EncFS and SSHFS

[EncFS](https://github.com/vgough/encfs) is an encrypted filesystem built on top of [FUSE](https://github.com/libfuse/libfuse)
library. It is available on most Linux distributions, and it runs in user space. Integrating EncFS
with Firejail brings up an interesting problem. Take a look at this paragraph in _man encfs_:

_By default, all FUSE based filesystems are visible only to the user who mounted them. No other
users (including root) can view the filesystem contents._

For various reasons, during sandbox setup Firejail handles EncFS filesystems as root user. FUSE
will prevent the root access to user's files and the sandbox will fail to start.

This problem affects all filesystems based on FUSE library. Quite popular among them is [sshfs](https://github.com/libfuse/sshfs).
The solution is to allow root user to access the filesystem using `allow_root` FUSE mount flag. On
some distributions (Debian & friends) you might have to change FUSE config file in `/etc/fuse.conf`
and uncomment `user_allow_other` line:

~~~ terminal
$ cat /etc/fuse.conf
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)

# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000

# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
~~~

This is how to start a Firejail-friendly EncFS:

~~~ terminal
$ encfs -o allow_root ~/.crypt ~/crypt
~~~

And this is a SSHFS:

~~~ terminal
$ sshfs -o reconnect,allow_root netblue@192.168.1.25:/home/netblue/work work
~~~

After mounting your FUSE filesystem, start your sandboxes the regular way.

## 4. Networking

A network namespace is a new, independent TCP/IP stack attached to the sandbox. The stack has its
own routing table, firewall and set of interfaces. Apart from `net none` and an optional
`netfilter`, we never configure networking features in the security profiles distributed with the
sandbox software.

You can create a network namespace with `--net` command. There are three setups to choose from:

 * `--net=none` creates a network namespace unconnected to the real network. The sandbox looks like
    a computer without any network interfaces.
 * `--net=macvlan-device` creates a direct network setup. The namespace is connected on the same
   network as your Ethernet interface using a macvlan kernel device. This is the easiest setup for
   home users. Unfortunately, the macvlan Linux kernel device works only for wired Ethernet
   interfaces.
 * `--net=bridge-device` connects the sandbox to a bridge kernel device. The regular network stack
   routes the sandbox traffic to your main wired/wireless interface.

### 4.1 Direct Network Setup

Run `ip addr show` to find the name of your wired Ethernet interface (eth0 in my case):

~~~ terminal
$ ip addr show
1: lo: mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
inet 127.0.0.1/8 scope host lo
valid_lft forever preferred_lft forever
inet6 ::1/128 scope host
valid_lft forever preferred_lft forever
2: eth0: mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
link/ether e0:3f:4f:72:14:a9 brd ff:ff:ff:ff:ff:ff
inet 192.168.1.50/24 brd 192.168.1.255 scope global eth0
valid_lft forever preferred_lft forever
inet6 fe80::e23f:49ff:fe7a:1409/64 scope link
valid_lft forever preferred_lft forever
~~~

and start the sandbox

~~~ terminal
$ firejail --net=eth0 firefox
~~~

You can specify an IP address (`--ip=192.168.1.207`), a range of IP addresses
(`--iprange=192.168.1.100,192.168.1.240`) to choose from, or you can let the sandbox find an unused
IP address on your network.

Because of the way macvlan kernel drivers are wired to the real Ethernet interface, it is not
possible for the sandboxed application to access TCP/IP services running on the host, and the other
way around. The sandbox and the host are totally disconnected, even if both of them are on the same
network.

<!-- FIXME: wordpress images -->
![](https://firejail.files.wordpress.com/2016/03/directnet.png)  
_Direct network_

This is a Firefox profile adding network namespace support to the sandbox:

~~~ terminal
$ cat ~/.config/firejail/firefox-exr.profile
include /etc/firejail/firefox-esr.profile
net eth0
iprange 192.168.1.100,192.168.1.240
~~~

Similar, a profile for [Transmission](https://transmissionbt.com/):

~~~ terminal
$ cat ~/.config/firejail/transmission-qt.profile
include /etc/firejail/transmission-qt.profile
net eth0
iprange 192.168.1.100,192.168.1.240
~~~

In the examples above, I let Firefox and Transmission fight for address in
`192.168.1.100 - 192.168.1.240` range. Actually, all network clients on my home network are
fighting for addresses in this range. To monitor the traffic use `firejail --netstats`.

<!-- FIXME: wordpress images -->
![](https://firejail.files.wordpress.com/2017/07/netstats1.png)  
_Monitoring network traffic with `firejail --netstats`_

### 4.2 Routed Network Setup

In a routed setup sandboxes are connected to a Linux bridge, and the bridge traffic is routed by
the host. This setup works for both wired and wireless interfaces. Address translation needs to be
enabled on the host in order for the sandbox traffic to go out on Internet:

<!-- FIXME: wordpress images -->
![](https://firejail.files.wordpress.com/2016/03/routednet.png)

Script for setting this up &ndash; I assume a wired eth0 interface for the system:

~~~ bash
#!/bin/bash

#
# Routed network configuration script
#

# bridge setup
brctl addbr br0
ifconfig br0 10.10.20.1/24 up

# enable ipv4 forwarding
echo "1" > /proc/sys/net/ipv4/ip_forward

# netfilter cleanup
iptables --flush
iptables -t nat -F
iptables -X
iptables -Z
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# netfilter network address translation
iptables -t nat -A POSTROUTING -o eth0 -s 10.10.20.0/24 -j MASQUERADE
``

Starting the sandbox:

~~~ terminal
$ firejail --net=br0 firefox
~~~

For running servers I replace network address translation with port forwarding in the script above:

~~~ terminal
# host port 80 forwarded to sandbox port 80
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to 10.10.20.10:80
~~~

### 4.3 Traffic shaping

Network bandwidth is an expensive resource shared among all sandboxes running on a system. Traffic
shaping allows the user to increase network performance by controlling the amount of data that
flows into and out of sandboxes. Firejail implements a simple rate-limiting shaper based on Linux
`tc` command. The shaper works at sandbox level:

~~~ terminal
$ firejail --name=browser --net=eth0 firefox &
$ firejail --bandwidth=browser set eth0 80 20
~~~

In this example I set a bandwidth of 80 kilobytes per second on receive side and a bandwidth of 20
kilobytes per second on transmit side. As the sandbox is running, I can change the values or even
reset them:

~~~ terminal
$ firejail --bandwidth=browser set eth0 40 10
$ firejail --bandwidth=browser clear eth0
~~~

## 5. X11 Sandboxing

If you don't have Wayland running, the most reliable way to sandbox X11 with Firejail is [Xephyr](https://en.wikipedia.org/wiki/Xephyr).
Xephyr is a light X11 server you can run in parallel with the main xorg server on your machine. The
software is part of [X.Org](https://www.x.org/wiki/).

In this example I use Firejail to sandbox two applications, Inkscape and Firefox, in a the same
Xephyr window.

**Step 1. Sandbox Xephyr**

In order to be able to rearrange and resize windows, I start OpenBox window manager on top of
Xephyr. Notice `--net=none` command option.

~~~ terminal
$ firejail --x11=xephyr --net=none openbox&
~~~

_Note: You can replace openbox with any other supported window manager. Currently we support
openbox, fluxbox, blackbox, awesome and i3._

As a rule, whenever we are dealing with X11 we also need to install a new network namespace. This
is the only way to block access to the abstract Unix socket opened by the main X11 server already
running on your box. Every application sandboxed on this display server is required to install a
network namespace, either `--net=none` or `--net=eth0`.

**Step 2. Find the display number for the new server**

Each X11 server server running on your box is identified by a unique display number. This number is
used to connect X11 applications to a specific X11 server. Run `firemon --x11` to find Xephyr's
display number:

~~~ terminal
$ firemon --x11
2377:netblue::/usr/bin/firejail /usr/bin/Xephyr -ac -br -noreset -screen 1024x
2394:netblue::firejail --net=none openbox
DISPLAY :265
~~~

The display number is 265. Notice how Xephyr and OpenBox are running in independent Firejal
sandboxes. Let's start some more sandboxes:

**Step 3. Start your applications**

~~~ terminal
$ DISPLAY=:265 firejail --net=eth0 firefox -no-remote &
$ DISPALY=:265 firejail --net=none inkscape &
~~~

<!-- FIXME: wordpress images -->
![](https://firejail.files.wordpress.com/2018/04/hb-x11-xephyr.png)  
_Independent Inkscape and Firefox sandboxes running in a Xephyr X11 window_

In this moment I have 4 independent sandboxes, one for each program involved: Xephyr, OpenBox,
Inkscape and Firefox.

<!-- FIXME: wordpress images -->
![](https://firejail.files.wordpress.com/2018/04/hb-x11-list.png)  
_X11 sandboxing using Xephyr_

## 6. Servers

As a rule, always use a new network namespace for server sandboxes in order to isolate services
such as SSH, X11, DBus running on your workstation. This is an Apache server example:

~~~ terminal
# firejail --net=eth0 --ip=192.168.1.244 /etc/init.d/apache2 start
~~~

The default server profile is /etc/firejail/server.profile. To further restrict your servers, here
are some ideas:

~~~
# capabilities list for Apache server
caps.keep chown,sys_resource,net_bind_service,setuid,setgid

# capabilities list for nginx server
caps.keep chown,net_bind_service,setgid,setuid

# use a netfilter configuration
netfilter /etc/firejail/webserver.net

# instead of /var/www/html for webpages, use a different directory
bind /server/web1,/var/www/html
~~~

You can run thousands of webservers on a regular system, each one with its own IP address,
webpages, and applications.
