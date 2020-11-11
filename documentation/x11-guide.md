# X11 Guide

**Contents**

 * [Introduction](#introduction)
 * [Installing Xpra on Arch Linux](#installing-xpra-on-arch-linux)
 * [Configuring Xpra](#configuring-xpra)
 * [Configuring Xephyr](#configuring-xephyr)
 * [How to test](#how-to-test)
 * [Attaching new sandboxes to an existing X11 server](#attaching-new-sandboxes-to-an-existing-x11-server)
 * [Resizing Xephyr window](#resizing-xephyr-window)


## Introduction

Firejail X11 sandboxing support is built around an external X11 server software package. Both
[Xpra](http://xpra.org/) and [Xephyr](https://en.wikipedia.org/wiki/Xephyr) are supported
(`apt-get install xpra xserver-xephyr` on Debian/Ubuntu). To allow people to use the sandbox on
headless systems, Firejail compile and install is not be dependent on Xpra or Xephyr packages.

The sandbox replaces the regular X11 server with Xpra or Xephyr server. This prevents X11 keyboard
loggers and screenshot utilities from accessing the main X11 server.

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/04/firefox-x11.png)  
_Mozilla Firefox running in a X11 sandbox. The regular X11 server (X0 Unix socket) is not visible,
and it was replaced by another X11 server (X723 Unix socket)._

The commands are as follows:

```terminal
$ firejail --x11=xpra --net=eth0 program-and-arguments
$ firejail --x11=xephyr --net=eth0 program-and-arguments
```

A shorter form is also available:

```terminal
$ firejail --x11 --net=eth0 program-and-arguments
```

In this case, Firejail will try first Xpra, and if Xpra is not installed on the system, it will try
to find Xephyr. For various reasons, X11 sandboxing features are not supported if the sandbox is
started as root user.

The main X11 server running on a Linux computer has two sockets active:

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/02/x11-x0.png)  
_Regular X11 server sockets_

`/tmp/.X11-unix/X0` is disabled using a temporary filesystem mounted on `/tmp/.X11-unix` directory.
The only way to disable the abstract socket `@/tmp/.X11-unix/X0` is by using a network namespace.
If for any reasons you cannot use a network namespace, the abstract socket will still be visible
inside the sandbox. Hackers can attach keylogger and screenshot programs to this socket.


## Installing Xpra on Arch Linux

Install [xpra-winswitch](https://aur.archlinux.org/packages/xpra-winswitch/) package from AUR, and
in `/etc/X11/Xwrapper.config` modify `allowed_users=anybody`.


## Configuring Xpra

Xpra is a persistent remote display server and client for forwarding X11 applications and desktop
screens. The default configuration of the software package works fine in most cases, text
configuration files are located in `/etc/xpra` directory.

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/02/xpra-clipboard.png)

The current running session adds a small icon in the system tray. This can be used to enable or
disable at run time the clipboard and a number of other parameters. It also provides statistics for
the current session. Each active sandbox can be configured independently in such a window.


## Configuring Xephyr

<!-- FIXME: wordpress link -->
Xephyr runs in its own window just like any other X application, but it is an X server itself.
Firejail sandboxed applications are started in this window. The default Xephyr window size is
800x600. This can be modified in /etc/firejail/firejail.config file, see `man 5 firejail-config`
for more details. Or you can use `xrandr`, see [below](https://firejail.wordpress.com/documentation-2/x11-guide/#resize).

The recommended way to use this feature is to run a window manager inside the sandbox. This is the
only way to resize or minimize the windows running on Xephyr server. Lots of light window managers
are available on Linux platform, Firejail software provides a security profile for [Openbox](http://www.openbox.org/)
(`apt-get install openbox`) as a reference in `/etc/firejail/openbox.profile`.

```terminal
$ firejail --x11=xephyr --net=eth0 openbox
```

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/04/openbox.png)
_Openbox running in a Firejail sandbox &ndash; right-click to access the application menu._

Applications can be started using the window manager &ndash; right-click on an empty area of the
window to open the application menu in Openbox. All apps started this way share the same sandbox
with the window manager.


## How to test

Start a sandboxed terminal (`firejail --x11 --net=eth0 xterm`) and run `netstat` command.
`/tmp/.X11-unix/X0` sockets should not be visible:

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/02/x11-x305.png)  
_X11 server sockets visible in a Firejail sandbox._

To test the keyboard, I start an xterm sandbox (`firejail --x11 --net=eth0 --noprofile xterm`) and
use xinput (`sudo apt-get install xinput`).

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/02/x11-x642.png)  
_Testing keyboard events in a Firejail sandbox_

Testing screenshots is even easier: `firejail --x11 --net=none gimp`.


## Attaching new sandboxes to an existing X11 server

[Drag and drop](https://en.wikipedia.org/wiki/Drag_and_drop) between windows running on different
X11 servers is not possible. The way to get around this limitation is to run multiple sandboxed
applications on the same server.

firemon command was enhanced to print X11 display information:

```terminal
$ firemon --x11
2142:netblue:firejail --x11 --net=eth0 firefox
DISPLAY :470
```

We have Firefox already running in a sandbox, on X11 display server :470. We start a new sandbox
and place it on the same server:

```terminal
$ DISPLAY=:470 firejail --net=eth0 transmission-gtk
```

Please note, a `--x11` option is not necessary when the second sandbox is started, DISPLAY
environment variable does all the magic.

`--net` command line option is still required for both sandboxes in order to disable access to the
main X11 server. Each sandbox has a different IP addresses and different container filesystems, but
they share the X11 socket in `/tmp/.X11-unix` directory. User Downloads directory is also shared
between the sandboxes. Drag and drop between the two sandboxes is possible.


## Resizing Xephyr window

You can use `xrandr` utility to resize a Xephyr window. I sandbox an xterm, find out the display
number used by the sandbox, and resize the window:

```terminal
$ firejail --x11=xephyr xterm &
$ firemon --x11
16148:netblue:firejail xterm
DISPLAY :139
$ xrandr --display :139
default connected 640x400+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
1600x1200 0.00
1400x1050 0.00
1280x960 0.00
1280x1024 0.00
1152x864 0.00
1024x768 0.00
832x624 0.00
800x600 0.00
720x400 0.00
480x640 0.00
640x480 0.00
640x400 0.00*
320x240 0.00
240x320 0.00
160x160 0.00
$ xrandr --display :139 --output default --mode 1280x1024
```
