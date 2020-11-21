# man firejail-login

~~~
FIREJAIL-LOGIN(5)            login.users man page           FIREJAIL-LOGIN(5)

NAME
       login.users - Login file syntax for Firejail

DESCRIPTION
       /etc/firejail/login.users  file  describes additional arguments passed
       to firejail executable upon user logging into  a  Firejail  restricted
       shell. Each user entry in the file consists of a user name followed by
       the arguments passed to firejail. The format is as follows:

            user_name: arguments

       Example:

            netblue:--net=none --protocol=unix

       Wildcard patterns are accepted in the user name field:

            user*: --private

RESTRICTED SHELL
       To configure a restricted shell, replace /bin/bash with /usr/bin/fire‐
       jail  in  /etc/passwd  file for each user that needs to be restricted.
       Alternatively, you can specify  /usr/bin/firejail   using  adduser  or
       usermod commands:

       adduser --shell /usr/bin/firejail username
       usermod --shell /usr/bin/firejail username

FILES
       /etc/firejail/login.users

LICENSE
       Firejail  is  free  software; you can redistribute it and/or modify it
       under the terms of the GNU General Public License as published by  the
       Free Software Foundation; either version 2 of the License, or (at your
       option) any later version.

       Homepage: https://firejail.wordpress.com

SEE ALSO
       firejail(1),  firemon(1),  firecfg(1),  firejail-profile(5)  firejail-
       users(5)

0.9.56                             Sep 2018                 FIREJAIL-LOGIN(5)
~~~
