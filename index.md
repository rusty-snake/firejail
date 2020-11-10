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

# News

**October 2020** &ndash; released Firejail DoH Proxy Server (FDNS) version 0.9.64
([Download](https://github.com/netblue30/fdns/releases)), featuring a number of new command line
options, monitor enhancements, server list updates and bug fixes. Starting with this release,
AppArmor is supported in Arch Linux. [Release Notes](https://firejaildns.wordpress.com/release-notes/)

<!-- TODO: add the other news -->

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

