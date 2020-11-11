# Documentation

**I've just installed Firejail, now what?!**

Integrate your sandbox into your desktop by running:

```terminal
$ sudo apt-get install firejail_xyz.deb
$ sudo firecfg
```

Start your programs the way you are used to: desktop manager menus, file manager, desktop
launchers. The integration applies to any program supported by default by Firejail. There are over
800 default applications in the current version of Firejail, and the number goes up with every new
release. We keep the list in `/usr/lib/firejail/firecfg.config` file.

<!-- FIXME: wordpress link -->
By far the most important application you would ever need to sandbox is the browser. Take a look at
[Firefox Sandboxing Guide](https://firejail.wordpress.com/documentation-2/firefox-guide/) or
[Firejail BitTorrent Sandboxing Guide](https://firejaildns.wordpress.com/2020/03/21/firejail-bittorrent-sandboxing-guide/)
to get in the mood. It was written for Firefox, but it applies to all browsers. It describes the
filesystem container created on-the-fly for the sandbox, and several common sandbox setups you can
also apply to other applications.

<!-- FIXME: wordpress link -->
[Firejail Usage](https://firejail.wordpress.com/documentation-2/basic-usage/) document will help
you get started in command line. If you are stuck and need help to figure something out, don't be
afraid to ask.

Another document you might want to look at is [Sandboxing Binary Software](https://github.com/netblue30/firejail/wiki/Sandboxing-Binary-Software).
The latest and greatest version is in our wiki on GitHub. Here you will find information about Tor
browwser and AppImages among other things.

**Do I really need to build a security profile for my application?**

No. If your application is not recognized, Firejail will use a very restrictive default profile.
Yet, we encourage users to customize profiles. [Building Custom Profiles](https://firejail.wordpress.com/documentation-2/building-custom-profiles/)
describe how to change exiting security profiles and how to create new ones. For developers we keep
a more detailed document in our wiki here.

**It's too easy, I'm getting bored!**

There is no _difficult_ in Firejail, at least not _SELinux-difficult_. But if you need something
more challenging, try to customize your security filters, or go into some more advanced security
topics such as X11 sandboxing:

<!-- FIXME: wordpress link -->
 * [Seccomp Guide](https://firejail.wordpress.com/documentation-2/seccomp-guide/)
 * [Linux Capabilities Guide](https://firejail.wordpress.com/documentation-2/linux-capabilities-guide/)
 * [X11 Guide](https://firejail.wordpress.com/documentation-2/x11-guide/)
 * [AppImage Support](https://firejail.wordpress.com/documentation-2/appimage-support/)

**Not quite like that, I was thinking about sandboxing games…**

Take a look at this excellent Steam article on Joris\_VR blog. Both Steam in Wine games are
supported by Firejail sandbox, with full sound and 3D acceleration.

## HowTo Videos

For our less-experienced Linux users, we are building a video HowTo channel &ndash; install guides,
ticks and trick, etc. Hopefully, we can pair each video with a blog entry, if not, we provide the
relevant info in the video description. Currently the videos are on [YouTube](https://www.youtube.com/playlist?list=PLKonu0TSTvsYi_Cqy89ndPrZltk6gRxKP),
but we have a backup channel on [BitChute](https://www.bitchute.com/channel/netblue30/).

-----

<table style="border: 0px">
  <tr>
    <td style="border: 0px">Firejail intro</td>
    <td style="border: 0px">How to disable network access</td>
  </tr>
  <tr>
    <td style="border: 0px"><iframe class='youtube-player' width='300' height='200' src='https://www.youtube.com/embed/7RMz7tePA98?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en&#038;autohide=2&#038;wmode=transparent' allowfullscreen='true' style='border:0;' sandbox='allow-scripts allow-same-origin allow-popups allow-presentation'></iframe></td>
    <td style="border: 0px"><iframe class='youtube-player' width='300' height='200' src='https://www.youtube.com/embed/xuMxRx0zSfQ?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en&#038;autohide=2&#038;wmode=transparent' allowfullscreen='true' style='border:0;' sandbox='allow-scripts allow-same-origin allow-popups allow-presentation'></iframe></td>
  </tr>
</table>

-----

<table style="border: 0px">
  <tr>
    <td style="border: 0px">Arch Linux Install</td>
    <td style="border: 0px">Debian/Ubuntu Install</td>
  </tr>
  <tr>
    <td style="border: 0px"><iframe class='youtube-player' width='300' height='200' src='https://www.youtube.com/embed/Uy2ZTHc4s0w?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en&#038;autohide=2&#038;wmode=transparent' allowfullscreen='true' style='border:0;' sandbox='allow-scripts allow-same-origin allow-popups allow-presentation'></iframe></td>
    <td style="border: 0px"><iframe class='youtube-player' width='300' height='200' src='https://www.youtube.com/embed/EyEz65RYfw4?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en&#038;autohide=2&#038;wmode=transparent' allowfullscreen='true' style='border:0;' sandbox='allow-scripts allow-same-origin allow-popups allow-presentation'></iframe></td>
  </tr>
</table>

-----

## External Reviews

If you are looking for external reviews, these are some of the best: [LWN.net](https://lwn.net/Articles/671534/), 
[DistroWatch.com](https://distrowatch.com/weekly.php?issue=20160222#tips), and
[linux.com](https://www.linux.com/learn/lock-your-untrusted-applications-firejail).
Linux Magazine published a very detailed feature article in April 2015. An online copy is available
[here](http://www.linux-magazine.com/Issues/2015/173/Firejail).

There are a lot of Firejail videos, podcasts, articles out there, you can find some of them
featured in our blog. If you run into one that’s not there, drop us a line in the comments
section below. Big thanks to everybody!

-----

<table style="border: 0px">
  <tr>
    <td style="border: 0px">Linux Action Show</td>
    <td style="border: 0px">Linux Luddites Show</td>
  </tr>
  <tr>
    <td style="border: 0px"><iframe class='youtube-player' width='300' height='200' src='https://www.youtube.com/embed/UgddGZca5XU?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en&#038;autohide=2&#038;wmode=transparent' allowfullscreen='true' style='border:0;' sandbox='allow-scripts allow-same-origin allow-popups allow-presentation'></iframe></td>
    <td style="border: 0px"><iframe class='youtube-player' width='300' height='200' src='https://www.youtube.com/embed/3ALt_eVzT8M?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en&#038;autohide=2&#038;wmode=transparent' allowfullscreen='true' style='border:0;' sandbox='allow-scripts allow-same-origin allow-popups allow-presentation'></iframe></td>
  </tr>
</table>

-----
