# man firecfg

~~~
FIRECFG(1)                     firecfg man page                    FIRECFG(1)

NAME
       Firecfg - Desktop integration utility for Firejail software.

SYNOPSIS
       firecfg [OPTIONS]

DESCRIPTION
       Firecfg  is  the desktop integration utility for Firejail sandbox.  It
       allows the user to sandbox applications automatically by  clicking  on
       desktop manager icons and menus.

       The integration covers:

              -  programs  started  in a terminal - typing "firefox" would be
              enough to start a sandboxed Firefox browser

              - programs started by clicking on desktop manager menus  -  all
              major desktop managers are supported

              -  programs started by clicking on file icons in file manager -
              only Cinnamon, KDE, LXDE/LXQT, MATE and XFCE  desktop  managers
              are supported in this moment

       To  set  it up, run "sudo firecfg" after installing Firejail software.
       The same command should also be run after installing new programs.  If
       the   program   is   supported  by  Firejail,  the  symbolic  link  in
       /usr/local/bin will be created. For a full list of programs  supported
       by default run "cat /usr/lib/firejail/firecfg.config".

       For user-driven manual integration, see DESKTOP INTEGRATION section in
       man 1 firejail.

DEFAULT ACTIONS
       The following actions are  implemented  by  default  by  running  sudo
       firecfg:

              - set or update the symbolic links for desktop integration;

              -  add  the  current  user  to  Firejail  user  access database
              (firecfg --add-users);

              -fix desktop files in $HOME/.local/share/applications/ (firecfg
              --fix).

OPTIONS
       --add-users user [user]
              Add the list of users to Firejail user access database.

              Example:
              $ sudo firecfg --add-users dustin lucas mike eleven

       --clean
              Remove all firejail symbolic links.

       --fix  Fix  .desktop  files. Some .desktop files use full path to exe‐
              cutable. Firecfg will check .desktop files in /usr/share/appli‐
              cations/, replace full path by name if it is in PATH, and write
              result to  $HOME/.local/share/applications/.   This  action  is
              done  by  default  when running "sudo firecfg". We have it as a
              separate option for regular users.

       --fix-sound
              Create a proper ~/.config/pulse/client.conf  file  without  shm
              support.  On  some  PulseAudio  versions, shared memory support
              (shm) breaks the process ID namespace. PulseAudio software  was
              designed a long time ago, and the introduction of PID namespace
              in Linux kernel breaks their design. This was reportedly  fixed
              in  PulseAudio  version  9.  If you have sound problems on your
              system, run "firecfg --fix-sound" command in a  terminal,  fol‐
              lowed by logout/login in order to apply the changes.

       --debug
              Print debug messages.

       -?, --help
              Print options end exit.

       --list List all firejail symbolic links

       --version
              Print program version and exit.

       Example:

       $ sudo firecfg
       /usr/local/bin/firefox created
       /usr/local/bin/vlc created
       [...]
       $ firecfg --list
       /usr/local/bin/firefox
       /usr/local/bin/vlc
       [...]
       $ sudo firecfg --clean
       /usr/local/bin/firefox removed
       /usr/local/bin/vlc removed
       [...]

LICENSE
       This  program  is free software; you can redistribute it and/or modify
       it under the terms of the GNU General Public License as  published  by
       the  Free Software Foundation; either version 2 of the License, or (at
       your option) any later version.

       Homepage: https://firejail.wordpress.com

SEE ALSO
       firejail(1), firemon(1), firejail-profile(5), firejail-login(5)  fire‐
       jail-users(5)

0.9.56                             Sep 2018                        FIRECFG(1)
~~~
