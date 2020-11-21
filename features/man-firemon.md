# man firemon

~~~
FIREMON(1)                     firemon man page                     FIREMON(1)

NAME
       Firemon  - Monitoring program for processes started in a Firejail sand‐
       box.

SYNOPSIS
       firemon [OPTIONS] [PID]

DESCRIPTION
       Firemon monitors programs started in a Firejail sandbox.  Without a PID
       specified, all processes started by Firejail are monitored. Descendants
       of these processes are also being monitored. On Grsecurity systems only
       root user can run this program.

OPTIONS
       --apparmor
              Print AppArmor confinement status for each sandbox.

       --arp  Print ARP table for each sandbox.

       --caps Print capabilities configuration for each sandbox.

       --cgroup
              Print control group information for each sandbox.

       --cpu  Print CPU affinity for each sandbox.

       --debug
              Print debug messages

       -?, --help
              Print options end exit.

       --interface
              Print network interface information for each sandbox.

       --list List all sandboxes.

       --name=name
              Print information only about named sandbox.

       --netstats
              Monitor  network statistics for sandboxes creating a new network
              namespace.

       --route
              Print route table for each sandbox.

       --seccomp
              Print seccomp configuration for each sandbox.

       --top  Monitor the most CPU-intensive sandboxes. This command  is simi‐
              lar  to the regular UNIX top command, however it applies only to
              sandboxes.

       --tree Print a tree of all sandboxed processes.

       --version
              Print program version and exit.

       --wrap Enable line wrapping in terminals.  By  default  the  lines  are
              trimmed.

       --x11  Print X11 display number.

       The format for each listed sandbox entry is as follows:

            PID:USER:Sandbox Name:Command

       Listed below are the available fields (columns) in various firemon com‐
       mands in alphabetical order:

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

       Sandbox Name
              The name of the sandbox, if any.

       SHR    Shared Memory Size (KiB), it reflects memory shared  with  other
              processes.  It is a sum of the SHR values for all processes run‐
              ning in the sandbox, including the controlling process.

       Uptime Sandbox running time in hours:minutes:seconds format.

       USER   The owner of the sandbox.

LICENSE
       This program is free software; you can redistribute it and/or modify it
       under  the  terms of the GNU General Public License as published by the
       Free Software Foundation; either version 2 of the License, or (at  your
       option) any later version.

       Homepage: https://firejail.wordpress.com

SEE ALSO
       firejail(1),  firecfg(1),  firejail-profile(5), firejail-login(5) fire‐
       jail-users(5)

0.9.64                             Oct 2020                         FIREMON(1)
~~~
