# Building Custom Profiles

**Contents**

 * [Introduction](#introduction)
 * [Blacklisted Profiles](#blacklisted-profiles)
 * [Whitelisted Profiles](#whitelisted-profiles)

## Introduction

There are two distinct types of profiles: blacklisted and whitelisted. In blacklisted profiles the
user "blacklists" the files the application is not allowed to access. In whitelisted profiles the
user "whitelists" the files necessary for the application to run, while everything else is off
limits.

We present below both cases. For more information, you can also read our profile development
document on [GitHub](https://github.com/netblue30/firejail/wiki/Creating-Profiles).

## Blacklisted Profiles

Several Firejail command line configuration options can be passed to the program using profile
files. User-defined profiles are stored in ~/.config/firejail directory. Assuming `app_name` is the
name of command you use to start the application, the steps for building a custom profile are as
follows:

**1.** Create a .config/firejail directory in your home directory:

```terminal
$ cd ~
$ mkdir -p .config/firejail
$ cd .config/firejail
```

**2.** Copy in this directory the default security profile used by Firejail to run unrecognized
applications:

```terminal
$ cp /etc/firejail/default.profile app_name.profile
```

The new profile file &ndash; `app_name.profile` &ndash; needs to have the same name as the
application, with only a .profile extension added. For example, if you intend to run `mplayer`,
your file name will be `mplayer.profile`.

**3.** Edit and modify the new profile file, comment out lines, blacklist directories, whitelist
files, etc. Use `man 5 firejail-profile` for a description and the correct syntax of all commands.

**4.** Start your application:

```terminal
$ firejail app_name
```

As you start the application, you'll see Firejail picking up the new security profile file
(`Reading profile /home/username/.config/firejail/app_name.profile.`):

```terminal
$ firejail app_name
Reading profile /home/username/.config/firejail/app_name.profile
Reading profile /etc/firejail/disable-common.inc
Reading profile /etc/firejail/disable-programs.inc
Reading profile /etc/firejail/disable-passwdmgr.inc
```

## Whitelisted Profiles

**1.** Create a simple bash sandbox using `--private`. The sandbox has an empty home directory,
with only a skeleton of files needed to run GUI applications. The directory is built in a temporary
(`tmpfs`) filesystem. When the sandbox is closed, all files in this directory will be destroyed,
and the regular home directory is restored.

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/09/whitelist-step1.png)
_Start a private sandbox and list the default files in home directory_

**2.** Start the program in this bash session. I use [Simutrans](http://www.simutrans.com/en/) game
as an example (`sudo apt-get install simutrans`). Play around for a while, then close the game and
list all the files in the home directory using `find` utility.

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/09/whitelist-step2.png)
_Run the program, and list again the files in home directory_

Notice the game creates a `~/.simutrans` directory where it keeps program configuration and game
data. This is the only directory that needs to be whitelisted. We have in this moment all the
information we need, so we can type `exit` and close the sandbox.

**3.** Create the new profile in `~/.config/firejail` directory using your favorite text editor.
The file name is always `appname.profile`, in this case `simutrans.profile`. The content of the
file is as follows:

```
# simutrans profile

noblacklist ~/.simutrans
mkdir ~/.simutrans
whitelist ~/.simutrans

include /etc/firejail/whitelist-common.inc
include /etc/firejail/default.profile
```

I use `mkdir` to create the new `~/.simutrans` directory in the real user home in case it doesn't
exist, and whitelist it. I also bring in session configuration such as fonts, desktop themes, GTK,
Qt etc. by including `/etc/firejail/whitelist-common.inc`. In the end I also include the default
blacklisting configuration from include `/etc/firejail/default.profile` in order to import the
security filters such as seccomp and capabilities.

**4.** Test the new profile:

<!-- FIXME: wordpress image -->
![](https://firejail.files.wordpress.com/2016/09/whitelist-step4.png)
_Test the new profile._
