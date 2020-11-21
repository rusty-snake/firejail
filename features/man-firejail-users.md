# man firejail-users

~~~
FIREJAIL-USERS(5)          firejail.users man page          FIREJAIL-USERS(5)

NAME
       firejail.users - Firejail user access database

DESCRIPTION
       /etc/firejail/firejail.users  lists  the users allowed to run firejail
       SUID executable.  root user is allowed  by  default,  user  nobody  is
       never allowed.

       If the user is not allowed to start the sandbox, Firejail will attempt
       to run the program without sandboxing it.

       If the file is not present in the system, all users are allowed to use
       the sandbox.

       Example:

            $ cat /etc/firejail/firejail.users
            dustin
            lucas
            mike
            eleven

       Use  a  text editor to add or remove users from the list. You can also
       use firecfg --add-users command. Example:

            $ sudo firecfg --add-users dustin lucas mike eleven

       By default, running firecfg creates the file and adds the current user
       to the list. Example:

            $ sudo firecfg

       See man 1 firecfg for details.

ALTERNATIVE SOLUTION
       An  alternative  way of restricting user access to firejail executable
       is to create a special firejail user group and  allow  only  users  in
       this group to run the sandbox:

            # addgroup firejail
            # chown root:firejail /usr/bin/firejail
            # chmod 4750 /usr/bin/firejail

FILES
       /etc/firejail/firejail.users

LICENSE
       Firejail  is  free  software; you can redistribute it and/or modify it
       under the terms of the GNU General Public License as published by  the
       Free Software Foundation; either version 2 of the License, or (at your
       option) any later version.

       Homepage: https://firejail.wordpress.com

SEE ALSO
       firejail(1),  firemon(1),  firecfg(1),  firejail-profile(5)  firejail-
       login(5)

0.9.56                             Sep 2018                 FIREJAIL-USERS(5)
~~~
