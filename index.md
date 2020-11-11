# About

**Firejail** is a SUID program that reduces the risk of security breaches by restricting the
running environment of untrusted applications using [Linux namespaces](https://lwn.net/Articles/531114/)
and [seccomp-bpf](https://l3net.wordpress.com/2015/04/13/firejail-seccomp-guide/). It allows a
process and all its descendants to have their own private view of the globally shared kernel
resources, such as the network stack, process table, mount table.

Written in C with virtually no dependencies, the software runs on any Linux computer with a 3.x
kernel version or newer. The sandbox is lightweight, the overhead is low. There are no complicated
configuration files to edit, no socket connections open, no daemons running in the background. All
security features are implemented directly in Linux kernel and available on any Linux computer. The
program is released under [GPL v2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
license.

Firejail can sandbox any type of processes: servers, graphical applications, and even user login
sessions. The software includes security profiles for a large number of Linux programs: Mozilla
Firefox, Chromium, VLC, Transmission etc. To start the sandbox, prefix your command with `firejail`:

```terminal
$ firejail firefox                       # starting Mozilla Firefox
$ firejail transmission-gtk              # starting Transmission BitTorrent 
$ firejail vlc                           # starting VideoLAN Client
$ sudo firejail /etc/init.d/nginx start  # starting nginx web server
```


# Latest Video

<iframe class='youtube-player' width='625' height='352' src='https://www.youtube.com/embed/nDkolbNpIQI?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en&#038;autohide=2&#038;wmode=transparent' allowfullscreen='true' style='border:0;' sandbox='allow-scripts allow-same-origin allow-popups allow-presentation'></iframe>

_Firejail Introduction &ndash; Aaron Jones, [Phoenix Linux User Group](https://www.meetup.com/Phoenix-Linux-Users-Group/)_


# Available Software Packages

We offer two Firejail flavors (mainline and long term support) and a number of additional sandbox plug-ins.

 * **Mainline** is our latest and greatest sandbox version. It includes new features and
   developments, updated profiles, and support for the latest desktop applications. The target
   audience is desktop home users. ([development page](https://github.com/netblue30/firejail))

 * **Long Term Support (LTS)** &ndash; Every two or three years we cut a branch from mainline git,
   we remove rarely used features (chroot, overlay, rlimits, cgroups, etc.), incomplete features
   (private-bin, private-lib, etc.), and a lot of instrumentation (build profile feature, tracing,
   auditing, etc). Sandbox-specific security features such as seccomp, capabilities, filesystem
   whitelist/blacklist and networking are updated and hardened. LTS receives periodic security
   updates, but no new features are ever added. The end result is a more stable software base, and
   a much smaller attack surface. Please use this version for any kind of enterprise deployment.
   ([development page](https://github.com/netblue30/firejail/tree/LTSbase))

 * **[Firetools](https://firejailtools.wordpress.com/)** is the graphical user interface of
   Firejail. The application is built using Qt4/Qt5 libraries. It provides a sandbox launcher
   integrated with the system tray, sandbox editing, management and statistics.
   ([project webpage](https://firejailtools.wordpress.com/),
   [development page](https://github.com/netblue30/firetools))

 * **[FDNS](https://firejaildns.wordpress.com/)** is a DNS over HTTPS (DoH) proxy server. FDNS
   protects your computer against some of the most common cyber threats, all while improving the
   privacy and the system performance. We use only DoH services from non-logging providers, while
   preferring small operators such as open-source enthusiasts and privacy-oriented non-profit
   organizations. ([project webpage](https://firejaildns.wordpress.com/),
   [development page](https://github.com/netblue30/fdns))

 * **Firetunnel** allows the user to connect multiple Firejail sandboxes on a virtualized Ethernet
   network. Applications include virtual private networks (VPN), overlay networks, peer-to-peer
   applications. Currently the project is in beta-testing phase, you can find out more on our
   [development page](https://github.com/netblue30/firetunnel).


# About Us

**Firejail** is a community project. We are not affiliated with any company, and we don't have any
commercial goals. Our focus is the Linux desktop. Home users and Linux beginners are our target
market. The software is built by a large international team of volunteers on [GitHub](http://github.com/netblue30/firejail).
Expert or regular Linux user, you are welcome to join us!

Security bugs are taken seriously, please email them to _netblue30 at protonmail.com_.


# News  <!-- FIXME: wordpress links -->

**October 2020** &ndash; released Firejail DoH Proxy Server (FDNS) version 0.9.64
([Download](https://github.com/netblue30/fdns/releases)), featuring a number of new command line
options, monitor enhancements, server list updates and bug fixes. Starting with this release,
AppArmor is supported in Arch Linux. [Release Notes](https://firejaildns.wordpress.com/release-notes/)

**October 2020** &ndash; released Firejail 0.9.64. In this release we introduce SELinux labeling
support, fine-grained D-Bus sandboxing with xdg-dbus-proxy, custom 32-bit seccomp filter support,
whitelist globbing, mkdir and mkfile support for /run/user directory, and a number of new command
line options. The blocking action of seccomp filters has been changed from killing the process to
returning EPERM to the caller. On the network side we are introducing DHCP support, and integration
with [FDNS](https://firejaildns.wordpress.com/), our own DNS over HTTPS proxy handled for now as a
separate plug-in. There are also lots of bug fixes and additional code hardening, and the number of
supported applications supported by default grew over 1000. ([Release Notes](https://firejail.wordpress.com/download-2/release-notes/)).

**September 2020** &ndash; released FDNS 0.9.62.10 ([Download](https://github.com/netblue30/fdns/releases)).
In this release we are adding support for DNS over TLS and HTTP 1.1, restructure geographical
zones, keepalive timer randomization, server list updates and bugfixes.
[Release Notes](https://firejaildns.wordpress.com/release-notes/)

**August 2020** &ndash; released Firejail 0.9.62.4 ([Download](https://sourceforge.net/projects/firejail/files/firejail/)).
This release fixes an AppArmor problem on Arch Linux distribution introduced in the previous
release. ([Release Notes](https://firejail.wordpress.com/download-2/release-notes/)).

**August 2020** &ndash; released Firejail 0.9.62.2 ([Download](https://sourceforge.net/projects/firejail/files/firejail/)).
This release fixes <span style="color: red;">two security vulnerabilities</span>
([CVE-2020-17367](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-17367) and
[CVE-2020-17368](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-17368)) and a number of
bugs. LTS version is not affected. ([Release Notes](https://firejail.wordpress.com/download-2/release-notes/)).

**March 2020** &ndash; documentation: [Firejail BitTorrent Sandboxing Guide](https://firejaildns.wordpress.com/2020/03/21/firejail-bittorrent-sandboxing-guide/)

**March 2020** &ndash; released FDNS 0.9.62.4. In this release we introduce
[CNAME cloaking protection](https://medium.com/nextdns/cname-cloaking-the-dangerous-disguise-of-third-party-trackers-195205dc522a),
[DNS rebinding protection](https://en.wikipedia.org/wiki/DNS_rebinding), SNI cloaking whenever
possible, we disable all known DoH service on the local network, and we increased DNS cache TTL to
40 minutes. Also bugfixes and a DoH server list update. [more...](https://firejaildns.wordpress.com/)

**Feruary 2020** &ndash; released FDNS 0.9.62.2. The project is feature-complete! We added over 60
new DNS over HTTPS servers, documentation, an automated test framework, and lots of bugfixes. You
can find the project [here](https://firejaildns.wordpress.com/).

**December 2019** &ndash; released Firejail 0.9.62 ([Download](https://sourceforge.net/projects/firejail/files/firejail/)
with a number of new features, additional SUID hardening, lots of bugfixes, and a large number of
new applications supported by default. Basically, during 2019 we doubled the number of default
apps, and we stand now at 884. This number will go way up in 2020. Happy New Year!
([Release Notes](https://firejail.wordpress.com/download-2/release-notes/).

**December 2019** &ndash; released Firetools 0.9.62 ([Download](https://sourceforge.net/projects/firejail/files/firetools/)).
In this release we introduce support for Firejail DNS over HTTPS proxy server (fdns), a separate
system tray icon to control the stats application, the network statistics were enhanced and split
out in a separate window, support for our Firejail LTS release, and a number of bugfixes.
([Release Notes](https://firejailtools.wordpress.com/release-notes))

We also have a new webpage for the project at <https://firejailtools.wordpress.com>.

**December 2019** &ndash; We are proud to announce a new addition to the Firejail family of
security tools: **Firejail DNS over HTTPS proxy server**.  
Targeted at small networks and Linux desktops, the proxy adds strong encryption and authentication
on top of the regular DNS protocol. You can run it as a regular DNS server for a network of
computers, or as a plug-in for your Firejail sandboxes. The software is written in C, and is
licensed under GPLv3.

 * Webpage: <https://firejaildns.wordpress.com>
 * Development: <https://github.com/netblue30/fdns>
 * Download: <https://firejaildns.wordpress.com/download>
 * FAQ: <https://firejaildns.wordpress.com/support/#faq>

**June 2019** &ndash; released Firejail 0.9.56.2-LTS ([Download](https://sourceforge.net/projects/firejail/files/LTS/)).
This a regular bugfix-only release for our LTS branch ([Release Notes](https://firejail.wordpress.com/download-2/release-notes/)).
<span style="color: red;">This version also fixes two security issues, details [here](https://firejail.wordpress.com/download-2/cve-status/).</span>

**May 2019** &ndash; released Firejail 0.9.60 ([Download](https://sourceforge.net/projects/firejail/files/firejail/)).
This release brings in a several new features, lots of new application profiles, bugfixes and
general SUID hardening ([Release Notes](https://firejail.wordpress.com/download-2/release-notes/)).
<span style="color: red;">This version also fixes two security issues, details [here](https://firejail.wordpress.com/download-2/cve-status/).</span>

**February 2019** &ndash; released Firejail 0.9.58.2 ([Download](https://sourceforge.net/projects/firejail/files/firejail/)).
In this release we are fixing a number of bugs introduced by 0.9.58. [Release Notes](https://firejail.wordpress.com/download-2/release-notes/).

**January 2019** &ndash; released Firejail 0.9.58 ([Download](https://sourceforge.net/projects/firejail/files/firejail/)).
This is a maintenance release including bugfixes and security profile updates for over 600 Linux
applications. [Release Notes](https://firejail.wordpress.com/download-2/release-notes/).

**January 2019** &ndash; released Firetools 0.9.58 ([Download](https://sourceforge.net/projects/firejail/files/firetools/)).
[Release Notes](https://firejail.wordpress.com/download-2/release-notes/).

**October 2018** &ndash; released Firejail LTS 0.9.56 ([Download](https://sourceforge.net/projects/firejail/files/LTS/)).
We are rebasing our Long Term Support branch of Firejail. The previous LTS version (0.9.38.x) is
more than two years old. The new version updates the code base to 0.9.56. We target a reduction of
approx. 40% of the code by removing rarely used features (chroot, overlay, rlimits, cgroups),
incomplete features (private-bin, private-lib), and a lot of instrumentation (build profile
feature, tracing, auditing, etc). Sandbox-specific security features such as seccomp, capabilities,
filesystem whitelist/blacklist and networking are updated and hardened.
[Release Notes](https://firejail.wordpress.com/download-2/release-notes/).

**September 2018** &ndash; eleased Firejail 0.9.56 ([Download](https://sourceforge.net/projects/firejail/files/firejail/)).
New features: wireless interface support for `--net` command, tunneling support (TAP device support
in `--net` command), temporary filesystem support for /home/user/.cache directory
(`--private-cache`), support for U2F devices, additional hardening of SUID executable, and much
more. [Release Notes](https://firejail.wordpress.com/download-2/release-notes/).


# External projects

 * [Firewarden](https://github.com/pigmonkey/firewarden) is a bash script used to open a
   program within a private Firejail sandbox.

<!-- 404: * [Firejail Profile Generator](https://github.com/SpotComms/FirejailProfileGenerator) -->

 * [Ansible role](https://github.com/debops-contrib/ansible-firejail) to setup Firejail

<!-- 404: * [firejail-extras](https://aur.archlinux.org/packages/firejail-extras/): Arch Linux AUR
   package containing extra security profiles for Firejail -->

 * <https://github.com/chiraag-nataraj/firejail-profiles> &ndash; This is a collection of tighter
   security profiles maintained by a member of Firejail development team.

 * Firejail package on [SlackBuilds.org](https://slackbuilds.org/repository/14.2/system/firejail/?search=firejail)

 * [Firectl](https://github.com/rahiel/firectl) is a tool to integrate Firejail sandboxing in the
   Linux desktop. Enable Firejail for an application and enjoy a more secure desktop.
   [PyPI](https://pypi.org/project/firectl/)

 * [ansible-firejail](https://bitbucket.org/aaaaaaaaaaaaaaaaaaaaa1/ansible-firejail/overview)
   &ndash; Ansible playbook for Firejail.

