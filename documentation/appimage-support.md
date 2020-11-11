
# AppImage Support

**Contents**

 * [Introduction](#introduction)
 * [Usage](#usage)
 * [A Full Example](#a-full-example)
 * [More Information](#more-information)

**TLDR**

<iframe class='youtube-player' width='625' height='352' src='https://www.youtube.com/embed/jGhYxTvMQJY?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en&#038;autohide=2&#038;wmode=transparent' allowfullscreen='true' style='border:0;' sandbox='allow-scripts allow-same-origin allow-popups allow-presentation'></iframe>

## Introduction

[AppImage](http://appimage.org/) is a universal software packaging format developed by Simon Peter.
The package is a regular ISO 9660 file containing all binaries, libraries and resources necessary
to run the application. You are likely to find this type of packaging used by open-source projects
trying to reach a large audience during fundraising campaigns.

Firajail provides native support for AppImage applications. These are the main features of
AppImage/Firejail combo:

 * state of the art software packaging and seccomp/namespaces sandboxing technology
 * he only requirement to run the application is a Linux kernel version 3 or newer &ndash;
   there are no dependencies, no 200MB runtimes to download and install
 * network and X11 sandboxing support
 * monitoring and auditing capabilities
 * low runtime overhead, no daemons running in the background, all security features are
   implemented in Linux kernel
 * it can be used in parallel with other security frameworks such as [Grsecurity](https://grsecurity.net/),
   [AppArmor](http://wiki.apparmor.net/index.php/Main_Page), [SELinux](https://selinuxproject.org/page/Main_Page)

## Usage

Start your AppImage application in Firajail using `--appimage` command line option:

```terminal
$ firejail --appimage krita-3.0-x86_64.appimage
```

All sandboxing options should be available. A private home directory:

```terminal
$ firejail --appimage --private krita-3.0-x86_64.appimage
```

or some basic X11 sandboxing:

```terminal
$ firejail --appimage --net=none --x11 krita-3.0-x86_64.appimage
```

## A Full Example

I download [Firefox Developer Edition](https://bintray.com/probono/AppImages/Firefox) from AppImage
project repository, and I start the sandbox:

```terminal
$ firejail --appimage --private --net=eth0 --x11 ~/Downloads/Firefox-Dev-48.0a2.en.glibc2.3.3-x86_64.AppImage
```

I use `--appimage` to enter appimage mode, `--private` to create an empty home directory,
`--net=eth0` to create a new network namespace, and `--x11` for X11 sandboxing based on [Xpra](https://xpra.org/).

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/07/appimage-ff.png)
_Firefox Developer Edition AppImage running in Firejail sandbox_

Next, I start the graphical user interface to verify some of the security parameters:

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/07/appimage-tools.png?w=625&h=317)
_Firetools_

I have two sandboxes running in this moment, Firefox AppImage and Transmission BitTorrent client. I
click on Firefox sandbox to get the stats:

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/07/appimage-stats.png)
_Firefox Developer Edition sandbox statistics_

In the stats window I look at seccomp status (enabled) and the capability field (all zero). These
are the two most important settings for a sandbox, everything else is built on top of them.

Since I also have a BitTorrent download going on, I also keep an eye on the network traffic. If
needed, I can limit the traffic for each sandbox using the bandwidth limiting capabilities in
Firejail:

```terminal
$ firejail --bandwidth=32119 set eth0 80 20
```

In this example I use Firefox PID (32119) and limit the sandbox traffic on interface eth0 to
80 KB/s in receive direction, and 20 KB/s in transmit direction.

## More information

 * AppImage project home: <https://appimage.org/>
 * For developers: <https://github.com/probonopd/AppImageKit>
 * Documentation: <https://github.com/probonopd/AppImageKit/wiki>
 * Application repository: <https://bintray.com/probono/AppImages>
