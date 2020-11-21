# Features
{:.no_toc}

+ ToC
{:toc}

## Linux namespaces

The core technology behind Firejail is [Linux Namespaces](https://lwn.net/Articles/531114/). We use
this lightweight visualization technology as the first step of isolating the application.

## Filesystem container

We build the application containers automatically when we start the sandbox, and we destroy them
when we close the sandbox. The container is based on the filesystem currently installed. If the
user keeps his system updated with all the security patches provided by the Linux distribution, the
containers are also up to date.

Filesystem operations:

 * **blacklisting** &ndash; deny access to files and directories. Access attempts are reported to syslog.
 * **whitelisting** &ndash; allow only the files and directories specified by the user.
 * **read-only, read-write, noexec** &ndash; set file and directory attributes.
 * **temporary filesystem** &ndash; mount a temporary filesystem on top of a directory.
 * **bind** &ndash; bind-mount a file or directory on top of another file or directory.
 * **private** &ndash; mount copies of files and directories and discard them when the sandbox is closed.
 * **restricted user home** &ndash; only the current user home directory is available inside the sandbox.
   This is also reflected in the structure of `/etc/passwd` and `/etc/group` files.
 * **reduced system information leakage** &ndash; restrict access to directories such as `/boot`, `/proc`, and `/sys`.

Container types:

 * **regular filesystem** &ndash; container created using files and directories from the current filesystem
 * **chroot filesystem** &ndash; use a regular chroot filesystem as the container.
 * **overlay filesystem** &ndash; mount a Linux `overlayfs` ilesystem on top of regular filesystem.
   All modifications stay in overlay layer. The user can reload the overlay later in a different sandbox.

The filesystem operations described above are available for all three types of containers.

## Security filters

The following security filters are currently implemented:

 * **seccomp-bpf** &ndash; a simple, yet effective sandboxing technology, [seccomp-bpf](https://www.kernel.org/doc/Documentation/prctl/seccomp_filter.txt)
   allows the user to attach a system call filter to a process and all its descendants, thus reducing the attack surface of the kernel.
 * **protocol** &ndash; based on seccomp, it filters the first argument of `socket` system call.
   Most default profiles allow only unix, inet and inet6 communication protocols.
 * **noroot user namespace** &ndash; install a [user namespace](https://lwn.net/Articles/532593/) with only one valid user, the current user.
 * **Linux capabilities** &ndash; Linux Capabilities (POSIX 1003.1e) are designed to split up the root privilege
   into a set of distinct privileges which can be independently enabled or disabled. These are used to restrict
   what a process running as root can do in the system. Most default profiles disable all capabilities.
 * **X11 sandboxing** &ndash; support is built around two external X11 server software packages,
   [Xpra](http://xpra.org/) and [Xephyr](https://en.wikipedia.org/wiki/Xephyr).
 * direct support for **Grsecurity** and **AppArmor**.

## Networking support

Firejail can attach a new TCP/IP networking stack to the sandbox. The new stack comes with its own
routing table, firewall and set of interfaces. Implemented as a Linux namespace inside the kernel,
the stack is totally independent of host network stack.

Some people use the networking features as a means to block the access to all listening system
sockets &ndash; most sandbox escape exploits are based on this type of interprocess communication.
For example, the only way to disable X11 support inside a sandbox is using a network namespace.

These are the networking operations supported by Firejail:

 * **create new interfaces** &ndash; create Linux kernel **macvlan** and **bridge** devices and move them in the sandbox.
 * **move existing interfaces** inside the sandbox. The interface configuration is preserved.
   We use this feature to connect sandboxes to specific VLANs.
 * **assign addresses** &ndash; Firejail assigns IP addresses automatically using a simple ARP-scan mechanism.
   The user can also specify IP addresses. Both IPv4 and IPv6 are supported.
 * **hostname support**.
 * **DNS support**.
 * **Linux netfilter support** &ndash; a custom netfilter configuration can be installed in the sandbox.
 * **traffic shaping** &ndash; control the amount of data that flows into and out of sandboxes.

## Security profiles

Located in `/etc/firejal` directory, profile files describe the filesystem container, the security
filters and network configuration.

Most default security profiles use a restrictive seccomp-bpf dual 32-bit/64-bit filter, disable all
capabilities, and enable a noroot user namespace inside the sandbox. The filesystem denies access
to password and encryption keys. Some application classes such as web browsers use a whitelisted
home directory, hiding all user files.

## Resource allocation

Allocate resources such as CPU time, system memory, and network bandwidth, using
**Linux Control Groups** and **Linux rlimits**.

## Universal packaging formats

Firejail supports [AppImage](https://appimage.org/) packaging format natively. Simply add
`--appimage` command line option and the package is mounted and run inside the sandbox.

Firejail also supports Ubuntu Snap packages using a regular security profile.

## Sandbox auditing

Audit feature allows the user to point out gaps in security profiles. The implementation replaces
the program to be sandboxed with a test program. We distribute a generic auditing program, but the
user can also use custom programs.

## Statistics and monitoring

Firejail provides a large number of options to track all the aspects of sandboxed applications.
This includes monitoring CPU/memory/bandwidth usage, tracing system calls, monitoring exec and fork
events, and logging accesses to blacklisted files and directories.

## Graphical user interface

A GUI application, firetools, is available as a separate software package.
