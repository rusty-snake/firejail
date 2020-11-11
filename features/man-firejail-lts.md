# man firejail (LTS)

```
FIREJAIL(1)                    firejail man page                   FIREJAIL(1)

NAME
       Firejail - Linux namespaces sandbox program

SYNOPSIS
       Start a sandbox:

              firejail [OPTIONS] [program and arguments]

       Network traffic shaping for an existing sandbox:

              firejail --bandwidth={name|pid} bandwidth-command

       Monitoring:

              firejail {--list | --netstats | --top | --tree}

       Miscellaneous:

              firejail  {-? | --debug-caps | --debug-errnos | --debug-syscalls
              | --debug-protocols | --help | --version}

DESCRIPTION
       Firejail is a SUID sandbox program that reduces the  risk  of  security
       breaches  by  restricting the running environment of untrusted applica‐
       tions using Linux namespaces, seccomp-bpf and Linux  capabilities.   It
       allows a process and all its descendants to have their own private view
       of the globally shared kernel resources, such  as  the  network  stack,
       process table, mount table.  Firejail can work in a SELinux or AppArmor
       environment, and it is integrated with Linux Control Groups.

       Written in C with virtually no dependencies, the software runs  on  any
       Linux  computer with a 3.x kernel version or newer.  It can sandbox any
       type of processes: servers, graphical applications, and even user login
       sessions.

       Firejail  allows the user to manage application security using security
       profiles.  Each profile defines a set of  permissions  for  a  specific
       application  or  group  of applications. The software includes security
       profiles for a number of more common Linux programs,  such  as  Mozilla
       Firefox, Chromium, VLC, Transmission etc.

USAGE
       Without  any  options,  the sandbox consists of a filesystem build in a
       new mount namespace, and new PID and UTS namespaces. IPC,  network  and
       user  namespaces  can  be  added  using  the  command line options. The
       default Firejail filesystem is based on the host  filesystem  with  the
       main  system directories mounted read-only. These directories are /etc,
       /var, /usr, /bin, /sbin, /lib, /lib32, /libx32 and /lib64.  Only  /home
       and /tmp are writable.

       As it starts up, Firejail tries to find a security profile based on the
       name of the application.  If an appropriate profile is not found, Fire‐
       jail will use a default profile.  The default profile is quite restric‐
       tive. In case the application doesn't work, use --noprofile  option  to
       disable  it. For more information, please see SECURITY PROFILES section
       below.

       If a program argument  is  not  specified,  Firejail  starts  /bin/bash
       shell.  Examples:

       $ firejail [OPTIONS]                # starting a /bin/bash shell

       $ firejail [OPTIONS] firefox        # starting Mozilla Firefox

       # sudo firejail [OPTIONS] /etc/init.d/nginx start

OPTIONS
       --     Signal  the  end of options and disables further option process‐
              ing.

       --allow-debuggers
              Allow tools such  as  strace  and  gdb  inside  the  sandbox  by
              whitelisting  system  calls  ptrace  and  process_vm_readv. This
              option is only available when running on Linux  kernels  4.8  or
              newer  - a kernel bug in ptrace system call allows a full bypass
              of the seccomp filter.

              Example:
              $  firejail    --allow-debuggers   --profile=/etc/firejail/fire‐
              fox.profile strace -f firefox

       --allusers
              All  directories  under /home are visible inside the sandbox. By
              default, only current user home directory is visible.

              Example:
              $ firejail --allusers

       --apparmor
              Enable AppArmor confinement. For more  information,  please  see
              APPARMOR section below.

       --appimage
              Sandbox  an AppImage (https://appimage.org/) application. If the
              sandbox is started as a regular user, default seccomp and  capa‐
              bilities filters are enabled.

              Example:
              $ firejail --appimage krita-3.0-x86_64.appimage
              $ firejail --appimage --private krita-3.0-x86_64.appimage
              $ firejail --appimage --net=none --x11 krita-3.0-x86_64.appimage

       --apparmor.print=name|pid
              Print the AppArmor confinement status for the sandbox identified
              by name or by PID.

              Example:
              $ firejail --apparmor.print=browser
              5074:netblue:/usr/bin/firejail /usr/bin/firefox-esr
                AppArmor: firejail-default enforce

       --bandwidth=name|pid
              Set bandwidth limits for the sandbox identified by name or  PID,
              see TRAFFIC SHAPING section for more details.

       --bind=filename1,filename2
              Mount-bind  filename1  on  top of filename2. This option is only
              available when running as root.

              Example:
              # firejail --bind=/config/etc/passwd,/etc/passwd

       --blacklist=dirname_or_filename
              Blacklist directory or file. File  globbing  is  supported,  see
              FILE GLOBBING section for more details.

              Example:
              $ firejail --blacklist=/sbin --blacklist=/usr/sbin
              $ firejail --blacklist=~/.mozilla
              $ firejail "--blacklist=/home/username/My Virtual Machines"
              $ firejail --blacklist=/home/username/My\ Virtual\ Machines

       -c     Execute command and exit.

       --caps Linux  capabilities is a kernel feature designed to split up the
              root privilege into a set of distinct privileges.  These  privi‐
              leges can be enabled or disabled independently, thus restricting
              what a process running as root can do in the system.

              By default root programs  run  with  all  capabilities  enabled.
              --caps  option disables the following capabilities: CAP_SYS_MOD‐
              ULE, CAP_SYS_RAWIO, CAP_SYS_BOOT, CAP_SYS_NICE, CAP_SYS_TTY_CON‐
              FIG,   CAP_SYSLOG,  CAP_MKNOD,  CAP_SYS_ADMIN.   The  filter  is
              applied to all processes started in the sandbox.

              Example:
              $ sudo firejail --caps /etc/init.d/nginx start

       --caps.drop=all
              Drop all capabilities for the processes running in the  sandbox.
              This option is recommended for running GUI programs or any other
              program that doesn't require root privileges. It is a  must-have
              option  for sandboxing untrusted programs installed from unoffi‐
              cial sources - such as games, Java programs, etc.

              Example:
              $ firejail --caps.drop=all warzone2100

       --caps.drop=capability,capability,capability
              Define a custom blacklist Linux capabilities filter.

              Example:
              $ firejail --caps.drop=net_broadcast,net_admin,net_raw

       --caps.keep=capability,capability,capability
              Define a custom whitelist Linux capabilities filter.

              Example:
              $  sudo   firejail   --caps.keep=chown,net_bind_service,setgid,\
              setuid /etc/init.d/nginx start

       --caps.print=name|pid
              Print  the  caps filter for the sandbox identified by name or by
              PID.

              Example:
              $ firejail --name=mygame --caps.drop=all warzone2100 &
              $ firejail --caps.print=mygame

              Example:
              $ firejail --list
              3272:netblue::firejail --private firefox
              $ firejail --caps.print=3272

       --cpu=cpu-number,cpu-number,cpu-number
              Set CPU affinity.

              Example:
              $ firejail --cpu=0,1 handbrake

       --cpu.print=name|pid
              Print the CPU cores in use by the sandbox identified by name  or
              by PID.

              Example:
              $ firejail --name=mygame --caps.drop=all warzone2100 &
              $ firejail --cpu.print=mygame

              Example:
              $ firejail --list
              3272:netblue::firejail --private firefox
              $ firejail --cpu.print=3272

       --debug
              Print debug messages.

              Example:
              $ firejail --debug firefox

       --debug-blacklists
              Debug blacklisting.

              Example:
              $ firejail --debug-blacklists firefox

       --debug-caps
              Print  all recognized capabilities in the current Firejail soft‐
              ware build and exit.

              Example:
              $ firejail --debug-caps

       --debug-errnos
              Print all recognized error numbers in the current Firejail soft‐
              ware build and exit.

              Example:
              $ firejail --debug-errnos

       --debug-protocols
              Print  all recognized protocols in the current Firejail software
              build and exit.

              Example:
              $ firejail --debug-protocols

       --debug-syscalls
              Print all recognized system calls in the current Firejail  soft‐
              ware build and exit.

              Example:
              $ firejail --debug-syscalls

       --debug-whitelists
              Debug whitelisting.

              Example:
              $ firejail --debug-whitelists firefox

       --defaultgw=address
              Use  this  address  as default gateway in the new network names‐
              pace.

              Example:
              $ firejail --net=eth0 --defaultgw=10.10.20.1 firefox

       --disable-mnt
              Disable /mnt, /media, /run/mount and /run/media access.

              Example:
              $ firejail --disable-mnt firefox

       --dns=address
              Set a DNS server for the sandbox. Up to three DNS servers can be
              defined.   Use  this  option if you don't trust the DNS setup on
              your network.

              Example:
              $ firejail --dns=8.8.8.8 --dns=8.8.4.4 firefox

              Note: this feature is not supported on systemd-resolved setups.

       --dns.print=name|pid
              Print DNS configuration for a sandbox identified by name  or  by
              PID.

              Example:
              $ firejail --name=mygame --caps.drop=all warzone2100 &
              $ firejail --dns.print=mygame

              Example:
              $ firejail --list
              3272:netblue::firejail --private firefox
              $ firejail --dns.print=3272

       --env=name=value
              Set environment variable in the new sandbox.

              Example:
              $ firejail --env=LD_LIBRARY_PATH=/opt/test/lib

       --fs.print=name|pid
              Print  the  filesystem log for the sandbox identified by name or
              by PID.

              Example:
              $ firejail --name=mygame --caps.drop=all warzone2100 &
              $ firejail --fs.print=mygame

              Example:
              $ firejail --list
              3272:netblue::firejail --private firefox
              $ firejail --fs.print=3272

       -?, --help
              Print options end exit.

       --hostname=name
              Set sandbox hostname.

              Example:
              $ firejail --hostname=officepc firefox

       --hosts-file=file
              Use file as /etc/hosts.

              Example:
              $ firejail --hosts-file=~/myhosts firefox

       --ignore=command
              Ignore command in profile file.

              Example:
              $ firejail --ignore=shell --ignore=seccomp firefox
              $ firejail --ignore="net eth0" firefox

       --interface=interface
              Move interface in a new network namespace. Up to  four  --inter‐
              face  options can be specified.  Note: wlan devices are not sup‐
              ported for this option.

              Example:
              $ firejail --interface=eth1 --interface=eth0.vlan100

       --ip=address
              Assign IP addresses to the last network interface defined  by  a
              --net option. A default gateway is assigned by default.

              Example:
              $ firejail --net=eth0 --ip=10.10.20.56 firefox

       --ip=none
              No IP address and no default gateway are configured for the last
              interface defined by a --net option. Use this option in case you
              intend to start an external DHCP client in the sandbox.

              Example:
              $ firejail --net=eth0 --ip=none

              If  the  corresponding interface doesn't have an IP address con‐
              figured, this option is enabled by default.

       --ip6=address
              Assign IPv6 addresses to the last network interface defined by a
              --net option.

              Example:
              $ firejail --net=eth0 --ip6=2001:0db8:0:f101::1/64 firefox

              Note:  you don't need this option if you obtain your ip6 address
              from router via SLAAC (your ip6 address and default  route  will
              be configured by kernel automatically).

       --iprange=address,address
              Assign  an  IP address in the provided range to the last network
              interface defined by  a  --net  option.  A  default  gateway  is
              assigned by default.

              Example:
              $ firejail --net=eth0 --iprange=192.168.1.100,192.168.1.150

       --ipc-namespace
              Enable  a new IPC namespace if the sandbox was started as a reg‐
              ular user. IPC namespace is enabled  by  default  for  sandboxes
              started as root.

              Example:
              $ firejail --ipc-namespace firefox

       --join=name|pid
              Join  the  sandbox  identified  by  name or by PID. By default a
              /bin/bash shell is started after joining the sandbox.  If a pro‐
              gram  is specified, the program is run in the sandbox. If --join
              command is issued as a regular user, all  security  filters  are
              configured  for  the new process the same they are configured in
              the sandbox.  If --join command is issued as root, the  security
              filters,  cgroups and cpus configurations are not applied to the
              process joining the sandbox.

              Example:
              $ firejail --name=mygame --caps.drop=all warzone2100 &
              $ firejail --join=mygame

              Example:
              $ firejail --list
              3272:netblue::firejail --private firefox
              $ firejail --join=3272

       --join-filesystem=name|pid
              Join the mount namespace of the sandbox identified  by  name  or
              PID.  By  default a /bin/bash shell is started after joining the
              sandbox.  If a program is specified, the program is run  in  the
              sandbox.  This command is available only to root user.  Security
              filters, cgroups and cpus configurations are not applied to  the
              process joining the sandbox.

       --join-network=name|pid
              Join the network namespace of the sandbox identified by name. By
              default a /bin/bash shell is started after joining the  sandbox.
              If  a  program  is specified, the program is run in the sandbox.
              This command is available only to root user.  Security  filters,
              cgroups  and  cpus configurations are not applied to the process
              joining the sandbox. Example:

              # start firefox
              $ firejail --net=eth0 --name=browser firefox &

              # change netfilter configuration
              $ sudo firejail --join-network=browser bash -c  "cat  /etc/fire‐
              jail/nolocal.net | /sbin/iptables-restore"

              # verify netfilter configuration
              $ sudo firejail --join-network=browser /sbin/iptables -vL

              # verify  IP addresses
              $ sudo firejail --join-network=browser ip addr
              Switching  to pid 1932, the first child process inside the sand‐
              box
              1: lo:   mtu  65536  qdisc  noqueue  state
              UNKNOWN group default
                  link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
                  inet 127.0.0.1/8 scope host lo
                     valid_lft forever preferred_lft forever
                  inet6 ::1/128 scope host
                     valid_lft forever preferred_lft forever
              2:  eth0-1931:   mtu 1500 qdisc
              noqueue state UNKNOWN group default
                  link/ether 76:58:14:42:78:e4 brd ff:ff:ff:ff:ff:ff
                  inet  192.168.1.158/24  brd   192.168.1.255   scope   global
              eth0-1931
                     valid_lft forever preferred_lft forever
                  inet6 fe80::7458:14ff:fe42:78e4/64 scope link
                     valid_lft forever preferred_lft forever

       --join-or-start=name
              Join the sandbox identified by name or start a new one.  Same as
              "firejail --join=name" if sandbox with  specified  name  exists,
              otherwise same as "firejail --name=name ..."
              Note  that in contrary to other join options there is respective
              profile option.

       --keep-dev-shm
              /dev/shm directory is untouched (even with --private-dev)

              Example:
              $ firejail --keep-dev-shm --private-dev

       --keep-var-tmp
              /var/tmp directory is untouched.

              Example:
              $ firejail --keep-var-tmp

       --list List all sandboxes, see MONITORING section for more details.

              Example:
              $ firejail --list
              7015:netblue:browser:firejail firefox
              7056:netblue:torrent:firejail --net=eth0 transmission-gtk
              7064:netblue::firejail --noroot xterm
              $

       --mac=address
              Assign MAC addresses to the last network interface defined by  a
              --net  option.  This option is not supported for wireless inter‐
              faces.

              Example:
              $ firejail --net=eth0 --mac=00:11:22:33:44:55 firefox

       --machine-id
              Spoof id number in /etc/machine-id file - a  new  random  id  is
              generated inside the sandbox.

              Example:
              $ firejail --machine-id

       --memory-deny-write-execute
              Install a seccomp filter to block attempts to create memory map‐
              pings that are both writable and executable, to change  mappings
              to  be  executable,  or  to create executable shared memory. The
              filter  examines  the  arguments  of  mmap,   mmap2,   mprotect,
              pkey_mprotect  and  shmat  system calls and kills the process if
              necessary.

              Note: shmat is not implemented as a system call  on  some  plat‐
              forms including i386, and it cannot be handled by seccomp-bpf.

       --mtu=number
              Assign  a  MTU  value to the last network interface defined by a
              --net option.

              Example:
              $ firejail --net=eth0 --mtu=1492

       --name=name
              Set sandbox name. Several options, such as  --join  and  --shut‐
              down, can use this name to identify a sandbox.

              Example:
              $ firejail --name=mybrowser firefox

       --net=bridge_interface
              Enable  a  new  network  namespace and connect it to this bridge
              interface.  Unless specified with option --ip  and  --defaultgw,
              an  IP  address and a default gateway will be assigned automati‐
              cally to the sandbox. The  IP  address  is  verified  using  ARP
              before  assignment. The address configured as default gateway is
              the bridge device IP address. Up to four --net  options  can  be
              specified.

              Example:
              $ sudo brctl addbr br0
              $ sudo ifconfig br0 10.10.20.1/24
              $ sudo brctl addbr br1
              $ sudo ifconfig br1 10.10.30.1/24
              $ firejail --net=br0 --net=br1

       --net=ethernet_interface|wireless_interface
              Enable  a  new network namespace and connect it to this ethernet
              interface using the standard Linux macvlan|ipvaln driver. Unless
              specified  with option --ip and --defaultgw, an IP address and a
              default gateway will be assigned automatically to  the  sandbox.
              The  IP  address  is  verified  using ARP before assignment. The
              address configured as default gateway is the default gateway  of
              the  host.  Up  to four --net options can be specified.  Support
              for ipvlan driver was introduced in Linux kernel 3.19.

              Example:
              $ firejail --net=eth0 --ip=192.168.1.80 --dns=8.8.8.8 firefox
              $ firejail --net=wlan0 firefox

       --net=tap_interface
              Enable a new network namespace and connect it to  this  ethernet
              tap  interface  using  the standard Linux macvlan driver. If the
              tap interface is not configured, the sandbox  will  not  try  to
              configure  the  interface  inside the sandbox.  Please use --ip,
              --netmask and --defaultgw to specify the configuration.

              Example:
              $ firejail --net=tap0  --ip=10.10.20.80  --netmask=255.255.255.0
              --defaultgw=10.10.20.1 firefox

       --net=none
              Enable  a new, unconnected network namespace. The only interface
              available in the new namespace is a new loopback interface (lo).
              Use  this  option  to deny network access to programs that don't
              really need network access.

              Example:
              $ firejail --net=none vlc

              Note: --net=none can crash the application  on  some  platforms.
              In these cases, it can be replaced with --protocol=unix.

       --netfilter
              Enable  a default firewall if a new network namespace is created
              inside the sandbox.  This option has  no  effect  for  sandboxes
              using the system network namespace.

              The  default  firewall is optimized for regular desktop applica‐
              tions. No incoming connections are accepted:

              *filter
              :INPUT DROP [0:0]
              :FORWARD DROP [0:0]
              :OUTPUT ACCEPT [0:0]
              -A INPUT -i lo -j ACCEPT
              -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
              # allow ping
              -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
              -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
              -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
              # drop STUN (WebRTC) requests
              -A OUTPUT -p udp --dport 3478 -j DROP
              -A OUTPUT -p udp --dport 3479 -j DROP
              -A OUTPUT -p tcp --dport 3478 -j DROP
              -A OUTPUT -p tcp --dport 3479 -j DROP
              COMMIT

              Example:
              $ firejail --net=eth0 --netfilter firefox

       --netfilter=filename
              Enable the firewall specified  by  filename  if  a  new  network
              namespace  is  created  inside  the sandbox.  This option has no
              effect for sandboxes using the system network namespace.

              Please use the regular iptables-save/iptables-restore format for
              the  filter  file.  The  following  examples  are  available  in
              /etc/firejail directory:

              webserver.net is a webserver firewall that allows access only to
              TCP ports 80 and 443.  Example:

              $ firejail --netfilter=/etc/firejail/webserver.net --net=eth0 \
              /etc/init.d/apache2 start

              nolocal.net  is a desktop client firewall that disable access to
              local network. Example:

              $ firejail --netfilter=/etc/firejail/nolocal.net \
              --net=eth0 firefox

       --netfilter=filename,arg1,arg2,arg3 ...
              This is the template version of  the  previous  command.  $ARG1,
              $ARG2,  $ARG3 ... in the firewall script are replaced with arg1,
              arg2, arg3 ... passed on the command line. Up  to  16  arguments
              are supported.  Example:

              $ firejail --net=eth0 --ip=192.168.1.105 \
              --netfilter=/etc/firejail/tcpserver.net,5001 server-program

       --netfilter.print=name|pid
              Print the firewall installed in the sandbox specified by name or
              PID. Example:

              $ firejail --name=browser --net=eth0 --netfilter firefox &
              $ firejail --netfilter.print=browser

       --netfilter6=filename
              Enable the IPv6 firewall specified by filename if a new  network
              namespace  is  created  inside  the sandbox.  This option has no
              effect for sandboxes using the system network namespace.  Please
              use  the  regular  iptables-save/iptables-restore format for the
              filter file.

       --netfilter6.print=name|pid
              Print the IPv6 firewall installed in the  sandbox  specified  by
              name or PID. Example:

              $ firejail --name=browser --net=eth0 --netfilter firefox &
              $ firejail --netfilter6.print=browser

       --netmask=address
              Use  this  option when you want to assign an IP address in a new
              namespace and the parent interface specified  by  --net  is  not
              configured.  An  IP  address  and a default gateway address also
              have to be added. By default the new namespace  interface  comes
              without IP address and default gateway configured. Example:

              $ sudo /sbin/brctl addbr br0
              $ sudo /sbin/ifconfig br0 up
              $      firejail     --ip=10.10.20.67     --netmask=255.255.255.0
              --defaultgw=10.10.20.1

       --netns=name
              Run the program in a named, persistent network namespace.  These
              can be created and configured using "ip netns".

       --netstats
              Monitor network namespace statistics, see MONITORING section for
              more details.

              Example:

              $ firejail --netstats
              PID  User    RX(KB/s) TX(KB/s) Command
              1294 netblue 53.355   1.473    firejail --net=eth0 firefox
              7383 netblue 9.045    0.112    firejail --net=eth0 transmission

       --nice=value
              Set nice value for all processes  running  inside  the  sandbox.
              Only root may specify a negative value.

              Example:
              $ firejail --nice=2 firefox

       --no3d Disable 3D hardware acceleration.

              Example:
              $ firejail --no3d firefox

       --noblacklist=dirname_or_filename
              Disable blacklist for this directory or file.

              Example:
              $ firejail
              $ nc dict.org 2628
              bash: /bin/nc: Permission denied
              $ exit

              $ firejail --noblacklist=/bin/nc
              $ nc dict.org 2628
              220 pan.alephnull.com dictd 1.12.1/rf on Linux 3.14-1-amd64

       --nodbus
              Disable D-Bus access. Only the regular UNIX socket is handled by
              this command. To disable the abstract socket you would  need  to
              request  a  new  network  namespace using --net command. Another
              option is to remove unix from --protocol set.

              Example:
              $ firejail --nodbus --net=none

       --nodvd
              Disable DVD and audio CD devices.

              Example:
              $ firejail --nodvd

       --noexec=dirname_or_filename
              Remount directory or file noexec, nodev and nosuid.  File  glob‐
              bing is supported, see FILE GLOBBING section for more details.

              Example:
              $ firejail --noexec=/tmp

              /etc  and  /var are noexec by default if the sandbox was started
              as a regular user. If there are more than one mount operation on
              the  path  of the file or directory, noexec should be applied to
              the last one. Always check if the change took effect inside  the
              sandbox.

       --nogroups
              Disable supplementary groups. Without this option, supplementary
              groups are enabled for the user starting the sandbox.  For  root
              user supplementary groups are always disabled.

              Note:  By  default  all regular user groups are removed with the
              exception of  the  current  user.  This  can  be  changed  using
              --allusers command option.

              Example:
              $ id
              uid=1000(netblue)       gid=1000(netblue)       groups=1000(net‐
              blue),24(cdrom),25(floppy),27(sudo),29(audio)
              $ firejail --nogroups
              Parent pid 8704, child pid 8705
              Child process initialized
              $ id
              uid=1000(netblue) gid=1000(netblue) groups=1000(netblue)
              $

       --noprofile
              Do not use a security profile.

              Example:
              $ firejail
              Reading profile /etc/firejail/default.profile
              Parent pid 8553, child pid 8554
              Child process initialized
              [...]

              $ firejail --noprofile
              Parent pid 8553, child pid 8554
              Child process initialized
              [...]

       --noroot
              Install a user namespace with a single user - the current  user.
              root  user  does  not  exist  in  the new namespace. This option
              requires a Linux kernel version 3.8 or newer. The option is  not
              supported  for  --chroot  and  --overlay  configurations, or for
              sandboxes started as root.

              Example:
              $ firejail --noroot
              Parent pid 8553, child pid 8554
              Child process initialized
              $ ping google.com
              ping: icmp open socket: Operation not permitted
              $

       --nonewprivs
              Sets the NO_NEW_PRIVS prctl.  This ensures that child  processes
              cannot  acquire  new privileges using execve(2);  in particular,
              this means that calling a suid binary (or one with file capabil‐
              ities)  does not result in an increase of privilege. This option
              is enabled by default if seccomp filter is activated.

       --nosound
              Disable sound system.

              Example:
              $ firejail --nosound firefox

       --noautopulse
              Disable automatic ~/.config/pulse init, for complex setups  such
              as remote pulse servers or non-standard socket paths.

              Example:
              $ firejail --noautopulse firefox

       --notv Disable DVB (Digital Video Broadcasting) TV devices.

              Example:
              $ firejail --notv vlc

       --nou2f
              Disable U2F devices.

              Example:
              $ firejail --nou2f

       --novideo
              Disable video devices.

       --nowhitelist=dirname_or_filename
              Disable whitelist for this directory or file.

       --private
              Mount new /root and /home/user directories in temporary filesys‐
              tems. All  modifications  are  discarded  when  the  sandbox  is
              closed.

              Example:
              $ firejail --private firefox

       --private=directory
              Use directory as user home.

              Example:
              $ firejail --private=/home/netblue/firefox-home firefox

       --private-cache
              Mount  an empty temporary filesystem on top of the .cache direc‐
              tory in user home. All  modifications  are  discarded  when  the
              sandbox is closed.

              Example:
              $ firejail --private-cache openbox

       --private-dev
              Create  a  new /dev directory. Only disc, dri, null, full, zero,
              tty, pts, ptmx, random, snd, urandom, video, log and shm devices
              are available.

              Example:
              $ firejail --private-dev
              Parent pid 9887, child pid 9888
              Child process initialized
              $ ls /dev
              cdrom  cdrw  dri  dvd  dvdrw  full  log  null  ptmx  pts  random
              shm  snd  sr0  tty  urandom  zero
              $

       --private-tmp
              Mount an empty temporary filesystem on  top  of  /tmp  directory
              whitelisting X11 and PulseAudio sockets.

              Example:
              $ firejail --private-tmp
              $ ls -al /tmp
              drwxrwxrwt  4 nobody nogroup   80 Apr 30 11:46 .
              drwxr-xr-x 30 nobody nogroup 4096 Apr 26 22:18 ..
              drwx------   2  nobody  nogroup  4096  Apr  30  10:52 pulse-PKd‐
              htXMmr18n
              drwxrwxrwt  2 nobody nogroup 4096 Apr 30 10:52 .X11-unix

       --profile=filename
              Load a custom security profile from filename. For  filename  use
              an  absolute  path  or a path relative to the current path.  For
              more information, see SECURITY PROFILES section below.

              Example:
              $ firejail --profile=myprofile

       --profile.print=name|pid
              Print the name of the profile file for the sandbox identified by
              name or or PID.

              Example:
              $ firejail --profile.print=browser
              /etc/firejail/firefox.profile

       --protocol=protocol,protocol,protocol
              Enable  protocol  filter.  The  filter  is  based on seccomp and
              checks the first argument to  socket  system  call.   Recognized
              values:  unix,  inet,  inet6, netlink and packet. This option is
              not supported for i386 architecture.

              Example:
              $ firejail --protocol=unix,inet,inet6 firefox

       --protocol.print=name|pid
              Print the protocol filter for the sandbox identified by name  or
              PID.

              Example:
              $ firejail --name=mybrowser firefox &
              $ firejail --protocol.print=mybrowser
              unix,inet,inet6,netlink

              Example:
              $ firejail --list
              3272:netblue::firejail --private firefox
              $ firejail --protocol.print=3272
              unix,inet,inet6,netlink

       --quiet
              Turn off Firejail's output.

       --read-only=dirname_or_filename
              Set directory or file read-only. File globbing is supported, see
              FILE GLOBBING section for more details.

              Example:
              $ firejail --read-only=~/.mozilla firefox

              A short note about mixing --whitelist and  --read-only  options.
              Whitelisted  directories should be made read-only independently.
              Making a parent directory read-only, will not make the whitelist
              read-only. Example:

              $ firejail --whitelist=~/work --read-only=~ --read-only=~/work

       --read-write=dirname_or_filename
              Set  directory  or  file  read-write.  Only files or directories
              belonging to the current user are allowed  for  this  operation.
              File  globbing  is supported, see FILE GLOBBING section for more
              details.  Example:

              $ mkdir ~/test
              $ touch ~/test/a
              $ firejail --read-only=~/test --read-write=~/test/a

       --rmenv=name
              Remove environment variable in the new sandbox.

              Example:
              $ firejail --rmenv=DBUS_SESSION_BUS_ADDRESS

       --scan ARP-scan all the networks from inside a network namespace.  This
              makes  it  possible to detect macvlan kernel device drivers run‐
              ning on the current host.

              Example:
              $ firejail --net=eth0 --scan

       --seccomp
              Enable seccomp filter and blacklist the syscalls in the  default
              list  (@default). The default list is as follows: _sysctl, acct,
              add_key, adjtimex, afs_syscall,  bdflush,  bpf,  break,  chroot,
              clock_adjtime, clock_settime, create_module, delete_module, fan‐
              otify_init, finit_module, ftime, get_kernel_syms, getpmsg, gtty,
              init_module,   io_cancel,  io_destroy,  io_getevents,  io_setup,
              io_submit,  ioperm,  iopl,  ioprio_set,  kcmp,  kexec_file_load,
              kexec_load,  keyctl, lock, lookup_dcookie, mbind, migrate_pages,
              modify_ldt,   mount,   move_pages,    mpx,    name_to_handle_at,
              nfsservctl,   ni_syscall,  open_by_handle_at,  pciconfig_iobase,
              pciconfig_read, pciconfig_write,  perf_event_open,  personality,
              pivot_root,  process_vm_readv,  process_vm_writev, prof, profil,
              ptrace,   putpmsg,   query_module,   reboot,   remap_file_pages,
              request_key,  rtas,  s390_mmio_read,  s390_mmio_write, s390_run‐
              time_instr, security, set_mempolicy, setdomainname, sethostname,
              settimeofday,  sgetmask,  ssetmask,  stime,  stty, subpage_prot,
              swapoff,  swapon,  switch_endian,  sys_debug_setcontext,  sysfs,
              syslog,  tuxcall,  ulimit, umount, umount2, uselib, userfaultfd,
              ustat, vhangup, vm86, vm86old, vmsplice and vserver.

              To help creating useful seccomp filters more easily, the follow‐
              ing  system  call  groups  are  defined: @clock, @cpu-emulation,
              @debug, @default, @default-nodebuggers, @default-keep,  @module,
              @obsolete,  @privileged, @raw-io, @reboot, @resources and @swap.
              In addtion, a system call can be specified by its number instead
              of  name  with  prefix  $, so for example $165 would be equal to
              mount on i386.

              System architecture is strictly  imposed  only  if  flag  --sec‐
              comp.block-secondary  is used. The filter is applied at run time
              only if the correct architecture was detected. For the  case  of
              I386 and AMD64 both 32-bit and 64-bit filters are installed.

              Firejail  will  print seccomp violations to the audit log if the
              kernel was compiled with audit support (CONFIG_AUDIT flag).

              Example:
              $ firejail --seccomp

       --seccomp=syscall,@group
              Enable seccomp filter, blacklist the default list (@default) and
              the syscalls or syscall groups specified by the command.

              Example:
              $ firejail --seccomp=utime,utimensat,utimes firefox
              $ firejail --seccomp=@clock,mkdir,unlinkat transmission-gtk

              Instead  of dropping the syscall, a specific error number can be
              returned using syscall:errorno syntax.

              Example: $ firejail --seccomp=unlinkat:ENOENT,utimensat,utimes
              Parent pid 10662, child pid 10663
              Child process initialized
              $ touch testfile
              $ rm testfile
              rm: cannot remove `testfile': Operation not permitted

              If the blocked system calls would also block Firejail from oper‐
              ating, they are handled by adding a preloaded library which per‐
              forms seccomp system calls later.

              Example:
              $ firejail --noprofile --shell=none --seccomp=execve bash
              Parent pid 32751, child pid 32752
              Post-exec seccomp protector enabled
              list in: execve,  check  list:  @default-keep  prelist:  (null),
              postlist: execve
              Child process initialized in 46.44 ms
              $ ls
              Bad system call

       --seccomp.block-secondary
              Enable  seccomp  filter  and filter system call architectures so
              that only the native architecture is allowed.  For  example,  on
              amd64, i386 and x32 system calls are blocked as well as changing
              the execution domain with personality(2) system call.

       --seccomp.drop=syscall,@group
              Enable seccomp filter, and blacklist the syscalls or the syscall
              groups specified by the command.

              Example:
              $ firejail --seccomp.drop=utime,utimensat,utimes,@clock

              Instead  of dropping the syscall, a specific error number can be
              returned using syscall:errorno syntax.

              Example:
              $ firejail --seccomp.drop=unlinkat:ENOENT,utimensat,utimes
              Parent pid 10662, child pid 10663
              Child process initialized
              $ touch testfile
              $ rm testfile
              rm: cannot remove `testfile': Operation not permitted

       --seccomp.keep=syscall,syscall,syscall
              Enable seccomp filter, and whitelist the syscalls  specified  by
              the   command.  The  system  calls  needed  by  Firejail  (group
              @default-keep: prctl,  execve)  are  handled  with  the  preload
              library.

              Example:
              $  firejail --shell=none --seccomp.keep=poll,select,[...] trans‐
              mission-gtk

       --seccomp.print=name|pid
              Print the seccomp filter for the sandbox identified by  name  or
              PID.

              Example:
              $ firejail --name=browser firefox &
              $ firejail --seccomp.print=browser
               line  OP JT JF    K
              =================================
               0000: 20 00 00 00000004   ld  data.architecture
               0001: 15 01 00 c000003e   jeq ARCH_64 0003 (false 0002)
               0002: 06 00 00 7fff0000   ret ALLOW
               0003: 20 00 00 00000000   ld  data.syscall-number
               0004: 35 01 00 40000000   jge X32_ABI true:0006 (false 0005)
               0005: 35 01 00 00000000   jge read 0007 (false 0006)
               0006: 06 00 00 00050001   ret ERRNO(1)
               0007: 15 41 00 0000009a   jeq modify_ldt 0049 (false 0008)
               0008: 15 40 00 000000d4   jeq lookup_dcookie 0049 (false 0009)
               0009: 15 3f 00 0000012a   jeq perf_event_open 0049 (false 000a)
               000a:  15  3e  00  00000137   jeq process_vm_writev 0049 (false
              000b)
               000b: 15 3d 00 0000009c   jeq _sysctl 0049 (false 000c)
               000c: 15 3c 00 000000b7   jeq afs_syscall 0049 (false 000d)
               000d: 15 3b 00 000000ae   jeq create_module 0049 (false 000e)
               000e: 15 3a 00 000000b1   jeq get_kernel_syms 0049 (false 000f)
               000f: 15 39 00 000000b5   jeq getpmsg 0049 (false 0010)
               0010: 15 38 00 000000b6   jeq putpmsg 0049 (false 0011)
               0011: 15 37 00 000000b2   jeq query_module 0049 (false 0012)
               0012: 15 36 00 000000b9   jeq security 0049 (false 0013)
               0013: 15 35 00 0000008b   jeq sysfs 0049 (false 0014)
               0014: 15 34 00 000000b8   jeq tuxcall 0049 (false 0015)
               0015: 15 33 00 00000086   jeq uselib 0049 (false 0016)
               0016: 15 32 00 00000088   jeq ustat 0049 (false 0017)
               0017: 15 31 00 000000ec   jeq vserver 0049 (false 0018)
               0018: 15 30 00 0000009f   jeq adjtimex 0049 (false 0019)
               0019: 15 2f 00 00000131   jeq clock_adjtime 0049 (false 001a)
               001a: 15 2e 00 000000e3   jeq clock_settime 0049 (false 001b)
               001b: 15 2d 00 000000a4   jeq settimeofday 0049 (false 001c)
               001c: 15 2c 00 000000b0   jeq delete_module 0049 (false 001d)
               001d: 15 2b 00 00000139   jeq finit_module 0049 (false 001e)
               001e: 15 2a 00 000000af   jeq init_module 0049 (false 001f)
               001f: 15 29 00 000000ad   jeq ioperm 0049 (false 0020)
               0020: 15 28 00 000000ac   jeq iopl 0049 (false 0021)
               0021: 15 27 00 000000f6   jeq kexec_load 0049 (false 0022)
               0022: 15 26 00 00000140   jeq kexec_file_load 0049 (false 0023)
               0023: 15 25 00 000000a9   jeq reboot 0049 (false 0024)
               0024: 15 24 00 000000a7   jeq swapon 0049 (false 0025)
               0025: 15 23 00 000000a8   jeq swapoff 0049 (false 0026)
               0026: 15 22 00 000000a3   jeq acct 0049 (false 0027)
               0027: 15 21 00 00000141   jeq bpf 0049 (false 0028)
               0028: 15 20 00 000000a1   jeq chroot 0049 (false 0029)
               0029: 15 1f 00 000000a5   jeq mount 0049 (false 002a)
               002a: 15 1e 00 000000b4   jeq nfsservctl 0049 (false 002b)
               002b: 15 1d 00 0000009b   jeq pivot_root 0049 (false 002c)
               002c: 15 1c 00 000000ab   jeq setdomainname 0049 (false 002d)
               002d: 15 1b 00 000000aa   jeq sethostname 0049 (false 002e)
               002e: 15 1a 00 000000a6   jeq umount2 0049 (false 002f)
               002f: 15 19 00 00000099   jeq vhangup 0049 (false 0030)
               0030: 15 18 00 000000ee   jeq set_mempolicy 0049 (false 0031)
               0031: 15 17 00 00000100   jeq migrate_pages 0049 (false 0032)
               0032: 15 16 00 00000117   jeq move_pages 0049 (false 0033)
               0033: 15 15 00 000000ed   jeq mbind 0049 (false 0034)
               0034: 15 14 00 00000130    jeq  open_by_handle_at  0049  (false
              0035)
               0035:  15  13  00  0000012f   jeq name_to_handle_at 0049 (false
              0036)
               0036: 15 12 00 000000fb   jeq ioprio_set 0049 (false 0037)
               0037: 15 11 00 00000067   jeq syslog 0049 (false 0038)
               0038: 15 10 00 0000012c   jeq fanotify_init 0049 (false 0039)
               0039: 15 0f 00 00000138   jeq kcmp 0049 (false 003a)
               003a: 15 0e 00 000000f8   jeq add_key 0049 (false 003b)
               003b: 15 0d 00 000000f9   jeq request_key 0049 (false 003c)
               003c: 15 0c 00 000000fa   jeq keyctl 0049 (false 003d)
               003d: 15 0b 00 000000ce   jeq io_setup 0049 (false 003e)
               003e: 15 0a 00 000000cf   jeq io_destroy 0049 (false 003f)
               003f: 15 09 00 000000d0   jeq io_getevents 0049 (false 0040)
               0040: 15 08 00 000000d1   jeq io_submit 0049 (false 0041)
               0041: 15 07 00 000000d2   jeq io_cancel 0049 (false 0042)
               0042: 15 06 00  000000d8    jeq  remap_file_pages  0049  (false
              0043)
               0043: 15 05 00 00000116   jeq vmsplice 0049 (false 0044)
               0044: 15 04 00 00000087   jeq personality 0049 (false 0045)
               0045: 15 03 00 00000143   jeq userfaultfd 0049 (false 0046)
               0046: 15 02 00 00000065   jeq ptrace 0049 (false 0047)
               0047:  15  01  00  00000136    jeq process_vm_readv 0049 (false
              0048)
               0048: 06 00 00 7fff0000   ret ALLOW
               0049: 06 00 01 00000000   ret KILL
              $

       --shell=none
              Run the program directly, without a user shell.

              Example:
              $ firejail --shell=none script.sh

       --shell=program
              Set default user shell. Use this shell to  run  the  application
              using  -c shell option.  For example "firejail --shell=/bin/dash
              firefox" will start Mozilla Firefox as "/bin/dash  -c  firefox".
              By default Bash shell (/bin/bash) is used.

              Example: $firejail --shell=/bin/dash script.sh

       --shutdown=name|pid
              Shutdown the sandbox identified by name or PID.

              Example:
              $ firejail --name=mygame --caps.drop=all warzone2100 &
              $ firejail --shutdown=mygame

              Example:
              $ firejail --list
              3272:netblue::firejail --private firefox
              $ firejail --shutdown=3272

       --timeout=hh:mm:ss
              Kill  the  sandbox automatically after the time has elapsed. The
              time is specified in hours/minutes/seconds format.

              $ firejail --timeout=01:30:00 firefox

       --tmpfs=dirname
              Mount a tmpfs filesystem on directory dirname.  This  option  is
              available  only when running the sandbox as root.  File globbing
              is supported, see FILE GLOBBING section for more details.

              Example:
              # firejail --tmpfs=/var

       --top  Monitor the most CPU-intensive sandboxes, see MONITORING section
              for more details.

              Example:
              $ firejail --top

       --trace
              Trace open, access and connect system calls.

              Example:
              $ firejail --trace wget -q www.debian.org
              Reading profile /etc/firejail/wget.profile
              3:wget:fopen64 /etc/wgetrc:0x5c8e8ce6c0
              3:wget:fopen /etc/hosts:0x5c8e8cfb70
              3:wget:socket AF_INET SOCK_DGRAM IPPROTO_IP:3
              3:wget:connect 3 8.8.8.8 port 53:0
              3:wget:socket AF_INET SOCK_STREAM IPPROTO_IP:3
              3:wget:connect 3 130.89.148.14 port 80:0
              3:wget:fopen64 index.html:0x5c8e8d1a60

              parent is shutting down, bye...

       --tree Print  a tree of all sandboxed processes, see MONITORING section
              for more details.

              Example:
              $ firejail --tree
              11903:netblue:firejail iceweasel
                11904:netblue:iceweasel
                  11957:netblue:/usr/lib/iceweasel/plugin-container
              11969:netblue:firejail --net=eth0 transmission-gtk
                11970:netblue:transmission-gtk

       --tunnel[=devname]
              Connect the sandbox to a network overlay/VPN tunnel  created  by
              firetunnel  utility. This options tries first the client side of
              the tunnel. If this fails, it tries the server side. If multiple
              tunnels  are  active,  please  specify  the  tunnel device using
              --tunnel=devname.
              The available  tunnel  devices  are  listed  in  /etc/firetunnel
              directory,  one  file  for  each  device.  The files are regular
              firejail profile files containing the network configuration, and
              are  created  and managed by firetunnel utility.  By default ftc
              is the client-side device and fts is the server-side device. For
              more information please see man 1 firetunnel.
              Example:
              $ firejail --tunnel firefox

       --version
              Print program version and exit.

              Example:
              $ firejail --version
              firejail version 0.9.27

       --veth-name=name
              Use  this  name  for  the  interface connected to the bridge for
              --net=bridge_interface commands, instead of the default one.

              Example:
              $ firejail --net=br0 --veth-name=if0

       --whitelist=dirname_or_filename
              Whitelist directory or file. A temporary file system is  mounted
              on the top directory, and the whitelisted files are mount-binded
              inside.  Modifications  to  whitelisted  files  are  persistent,
              everything else is discarded when the sandbox is closed. The top
              directory could be user home, /dev, /etc,  /media,  /mnt,  /opt,
              /srv, /sys/module, /usr/share, /var, and /tmp.

              Symbolic  link  handling:  with the exception of user home, both
              the link and the real file should be in the same top  directory.
              For  user  home, both the link and the real file should be owned
              by the user.

              Example:
              $ firejail --noprofile --whitelist=~/.mozilla
              $ firejail --whitelist=/tmp/.X11-unix --whitelist=/dev/null
              $ firejail "--whitelist=/home/username/My Virtual Machines"

       --writable-etc
              Mount /etc directory read-write.

              Example:
              $ sudo firejail --writable-etc

       --writable-run-user
              Disable the default blacklisting of  /run/user/$UID/systemd  and
              /run/user/$UID/gnupg.

              Example:
              $ sudo firejail --writable-run-user

       --writable-var
              Mount /var directory read-write.

              Example:
              $ sudo firejail --writable-var

       --writable-var-log
              Use  the  real  /var/log  directory,  not a clone. By default, a
              tmpfs is mounted on top of /var/log directory,  and  a  skeleton
              filesystem is created based on the original /var/log.

              Example:
              $ sudo firejail --writable-var-log

DESKTOP INTEGRATION
       A  symbolic link to /usr/bin/firejail under the name of a program, will
       start the program in Firejail sandbox.  The  symbolic  link  should  be
       placed  in  the  first $PATH position. On most systems, a good place is
       /usr/local/bin directory. Example:

              Make a firefox symlink to /usr/bin/firejail:

              $ ln -s /usr/bin/firejail /usr/local/bin/firefox

              Verify $PATH

              $ which -a firefox
              /usr/local/bin/firefox
              /usr/bin/firefox

              Starting firefox in this moment, automatically invokes “firejail
              firefox”.

       This  works  for  clicking on desktop environment icons, menus etc. Use
       "firejail --tree" to verify the program is sandboxed.

              $ firejail --tree
              1189:netblue:firejail firefox
                1190:netblue:firejail firefox
                  1220:netblue:/bin/sh -c "/usr/lib/firefox/firefox"
                    1221:netblue:/usr/lib/firefox/firefox

       We provide a tool that automates all this integration, please see man 1
       firecfg for more details.

FILE GLOBBING
       Globbing is the operation that expands a wildcard pattern into the list
       of pathnames matching the pattern. Matching is defined by:

              - '?' matches any character
              - '*' matches any string
              - '[' denotes a range of characters

       The gobing feature is implemented using glibc glob  command.  For  more
       information on the wildcard syntax see man 7 glob.

       The  following  command line options are supported: --blacklist, --pri‐
       vate-bin, --noexec, --read-only, --read-write, and --tmpfs.

       Examples:

              $ firejail --private-bin=sh,bash,python*
              $ firejail --blacklist=~/dir[1234]
              $ firejail --read-only=~/dir[1-4]

APPARMOR
       AppArmor support is disabled by default at compile time. Use  --enable-
       apparmor configuration option to enable it:

              $ ./configure --prefix=/usr --enable-apparmor

       During  software  install,  a  generic AppArmor profile file, firejail-
       default, is placed in /etc/apparmor.d directory. The  local  customiza‐
       tions  can  be placed in /etc/apparmor.d/local/firejail-local. The pro‐
       file needs to be loaded into the kernel by reloading  apparmor.service,
       rebooting the system or running the following command as root:

              # apparmor_parser -r /etc/apparmor.d/firejail-default

       The  installed  profile is supplemental for main firejail functions and
       among other things does the following:

              - Disable ptrace. With ptrace it  is  possible  to  inspect  and
              hijack  running programs. Usually this is needed only for debug‐
              ging. You should have no problems running Chromium  or  Firefox.
              This feature is available only on Ubuntu kernels.

              -  Whitelist write access to several files under /run, /proc and
              /sys.

              - Allow running programs only from well-known system paths, such
              as /bin, /sbin, /usr/bin etc. Those paths are available as read-
              only. Running programs and  scripts  from  user  home  or  other
              directories writable by the user is not allowed.

              -  Prevent  using non-standard network sockets. Only unix, inet,
              inet6, netlink, raw and packet are allowed.

              - Deny access to known sensitive paths like .snapshots.

       To enable AppArmor confinement on top of your current Firejail security
       features,  pass  --apparmor flag to Firejail command line. You can also
       include apparmor command in a Firejail profile file. Example:

              $ firejail --apparmor firefox

TRAFFIC SHAPING
       Network bandwidth is an expensive resource shared among  all  sandboxes
       running  on a system.  Traffic shaping allows the user to increase net‐
       work performance by controlling the amount of data that flows into  and
       out of the sandboxes.

       Firejail  implements  a simple rate-limiting shaper based on Linux com‐
       mand tc.  The shaper works at sandbox level, and can be used  only  for
       sandboxes configured with new network namespaces.

       Set rate-limits:

            $ firejail --bandwidth=name|pid set network download upload

       Clear rate-limits:

            $ firejail --bandwidth=name|pid clear network

       Status:

            $ firejail --bandwidth=name|pid status

       where:
            name - sandbox name
            pid - sandbox pid
            network - network interface as used by --net option
            download - download speed in KB/s (kilobyte per second)
            upload - upload speed in KB/s (kilobyte per second)

       Example:
            $ firejail --name=mybrowser --net=eth0 firefox &
            $ firejail --bandwidth=mybrowser set eth0 80 20
            $ firejail --bandwidth=mybrowser status
            $ firejail --bandwidth=mybrowser clear eth0

MONITORING
       Option  --list  prints  a  list  of  all sandboxes. The format for each
       process entry is as follows:

            PID:USER:Sandbox Name:Command

       Option --tree prints the tree of processes running in the sandbox.  The
       format for each process entry is as follows:

            PID:USER:Sandbox Name:Command

       Option  --top  is  similar  to the UNIX top command, however it applies
       only to sandboxes.

       Option  --netstats  prints  network  statistics  for  active  sandboxes
       installing new network namespaces.

       Listed  below  are the available fields (columns) in alphabetical order
       for --top and --netstat options:

       Command
              Command used to start the sandbox.

       CPU%   CPU usage, the sandbox share of the elapsed CPU time  since  the
              last screen update

       PID    Unique process ID for the task controlling the sandbox.

       Prcs   Number  of  processes running in sandbox, including the control‐
              ling process.

       RES    Resident Memory Size (KiB), sandbox non-swapped physical memory.
              It  is  a sum of the RES values for all processes running in the
              sandbox.

       RX(KB/s)
              Network receive speed.

       Sandbox Name
              The name of the sandbox, if any.

       SHR    Shared Memory Size (KiB), it reflects memory shared  with  other
              processes.  It is a sum of the SHR values for all processes run‐
              ning in the sandbox, including the controlling process.

       TX(KB/s)
              Network transmit speed.

       Uptime Sandbox running time in hours:minutes:seconds format.

       USER   The owner of the sandbox.

SECURITY PROFILES
       Several command line options can be passed to the program using profile
       files. Firejail chooses the profile file as follows:

       1. If a profile file is provided by the user with --profile option, the
       profile file is loaded.  Example:

              $ firejail --profile=/home/netblue/icecat.profile icecat
              Reading profile /home/netblue/icecat.profile
              [...]

       2. If a profile file with the same name as the application  is  present
       in  ~/.config/firejail  directory  or  in /etc/firejail, the profile is
       loaded. ~/.config/firejail takes precedence over  /etc/firejail.  Exam‐
       ple:

              $ firejail icecat
              Command name #icecat#
              Found icecat profile in /home/netblue/.config/firejail directory
              Reading profile /home/netblue/.config/firejail/icecat.profile
              [...]

       3.  Use  default.profile  file  if  the sandbox is started by a regular
       user, or server.profile file if the sandbox is started by  root.  Fire‐
       jail looks for these files in ~/.config/firejail directory, followed by
       /etc/firejail directory.   To  disable  default  profile  loading,  use
       --noprofile command option. Example:

              $ firejail
              Reading profile /etc/firejail/default.profile
              Parent pid 8553, child pid 8554
              Child process initialized
              [...]

              $ firejail --noprofile
              Parent pid 8553, child pid 8554
              Child process initialized
              [...]

       See man 5 firejail-profile for profile file syntax information.

RESTRICTED SHELL
       To  configure a restricted shell, replace /bin/bash with /usr/bin/fire‐
       jail in /etc/passwd file for each user that  needs  to  be  restricted.
       Alternatively, you can specify /usr/bin/firejail  in adduser command:

       adduser --shell /usr/bin/firejail username

       Additional  arguments  passed  to  firejail  executable  upon login are
       declared in /etc/firejail/login.users file.

EXAMPLES
       firejail
              Sandbox a regular /bin/bash session.

       firejail firefox
              Start Mozilla Firefox.

       firejail --debug firefox
              Debug Firefox sandbox.

       firejail --private firefox
              Start Firefox with a new, empty home directory.

       firejail --net=none vlc
              Start VLC in an unconnected network namespace.

       firejail --net=eth0 firefox
              Start Firefox in a new  network  namespace.  An  IP  address  is
              assigned automatically.

       firejail --net=br0 --ip=10.10.20.5 --net=br1 --net=br2
              Start a /bin/bash session in a new network namespace and connect
              it to br0, br1, and br2 host bridge devices.  IP  addresses  are
              assigned  automatically  for the interfaces connected to br1 and
              b2

       firejail --list
              List all sandboxed processes.

LICENSE
       This program is free software; you can redistribute it and/or modify it
       under  the  terms of the GNU General Public License as published by the
       Free Software Foundation; either version 2 of the License, or (at  your
       option) any later version.

       Homepage: https://firejail.wordpress.com

SEE ALSO
       firemon(1), firecfg(1), firejail-profile(5), firejail-users(5)

0.9.56-LTS                         Oct 2018                        FIREJAIL(1)
```
