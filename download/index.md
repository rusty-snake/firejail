# Download

{::options parse_block_html="true" /}
<div id="top-box">

Download the latest version:

 * Firejail development: 0.9.64.1 ([GitHub](https://github.com/netblue30/firejail)).
 * Firejail current: 0.9.64 ([SourceForge](https://sourceforge.net/projects/firejail/files/firejail/)).
 * Firejail Long Term Support: 0.9.56.2-LTS ([SourceForge](https://sourceforge.net/projects/firejail/files/LTS/)).
 * Firetools current: 0.9.62 ([SourceForge](https://sourceforge.net/projects/firejail/files/firetools/)).
 * fdns current: 0.9.62.10 ([GitHub](https://github.com/netblue30/fdns/releases)).


In case SourceForge is down, a mirror is available on [Open Source Developer Network](https://osdn.net/projects/sfnet_firejail/releases/).

For release notifications subscribe to the atom feeds below:

 * <https://github.com/netblue30/firejail/releases.atom>
 * <https://github.com/netblue30/firetools/releases.atom>
 * <https://github.com/netblue30/fdns/releases.atom>

</div>
{::options parse_block_html="false" /}

-----

Try installing Firejail from your system packages first. Firejail is included in Alpine, ALT Linux,
Arch, Chakra, Debian, Deepin, Devuan, Fedora, Gentoo, Manjaro, Mint, NixOS, Parabola, Parrot,
PCLinuxOS, ROSA, Solus, Slackware/SlackBuilds, Trisquel, Ubuntu, Void. You can also install one of
the [released packages](http://sourceforge.net/projects/firejail/files/firejail), or clone
Firejail's source code from our [Git repository](https://github.com/netblue30/firejail).

After install run `sudo firecfg` in a terminal. The command integrates Firejail into your desktop.
You will be able to start your sandboxed applications by:

 * clicking on the app icon in your window manager menus
 * clicking on a file in the file manager will automatically sandbox the application opening the file
 * no need to prefix your application with firejail when starting in command line

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

To install our binary packages run:

~~~ terminal
(Debian/Ubuntu)
$ sudo dpkg -i firejail_X.Y.Z_amd64.deb
or
$ sudo dpkg -i firejail_X.Y.Z_i386.deb
(Fedora)
$ sudo rpm -i firejail-X.Y.Z.rpm 
~~~

## Source Code

Download the source code archive and extract the files:

~~~ terminal
$ tar -xJvf firejail-X.Y.Z.tar.xz 
~~~

Compile and install

~~~ terminal
$ cd firejail-X.Y.Z
$ ./configure && make && sudo make install-strip 
~~~

AppArmor support is not enabled by default at compile time. It is also missing from the binary
packages we distribute on this site. Add `--enable-apparmor` in configure command to include this
support:

~~~ terminal
$ ./configure --enable-apparmor && make && sudo make install-strip
~~~

<!-- FIXME: wordpress link -->
You can find more AppArmor information in our [Firejail Usage](https://firejail.wordpress.com/documentation-2/basic-usage/#apparmor)
document.

Firetools compilation is described [here](https://firejailtools.wordpress.com/downloads/).

## Git Repository

Firejail's source code is hosted in a [Git](https://github.com/netblue30/firejail) repository on
GitHub. You can access and compile it with the following commands:

~~~ terminal
$ git clone https://github.com/netblue30/firejail.git
$ cd firejail
$ ./configure && make && sudo make install 
~~~

## Checksums

For each release we provide a firejail-X.Y.Z.asc file that contains SHA256 checksums for each
archive released. You can check the checksum using _sha256sum_ utility from [GNU Coreutils](http://www.gnu.org/software/coreutils/)
package.

firejail-X.Y.Z.asc file also includes a [GnuPG](https://www.gnupg.org/) signature. You can check
the integrity of the file using our public key below. We use this key across all Firejail-related
projects.

~~~
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.12 (GNU/Linux)

mQENBFRaIzYBCACvfLk+0CpSK+03h0svI3XfbSuGppB1jSd70QoX6jgjcJ6ble+G
V8gQEd8hU6Rhw4oa6klY+sVY2Si+7ZLaGQAiucERNG0aJA23gYVw91OyaARNZ1SZ
8Ju7GowCxLOT6Ie8RyWCCv1yXGxQT36j2I1Z9/UvYHvIJISZ48K4Dk8OuF5lcCH7
jN5X/7pqhmBKKx3Ve4UWmiKjisZcEdhJ9U5nyrHNSngPYSia+YIK/wG4nqY3ooZi
HvLA21HeaVBaILmRuRCO7akqxFB9SfJTHDqC0czZ0/3NJ3AyQv/qEkIkxGOHogKx
hNqGUBxYhba9Hl9Sl3IX72aQ28CxUngpXLNJABEBAAG0LG5ldGJsdWUgKGZpcmVq
YWlsIGtleSkgPG5ldGJsdWUzMEB5YWhvby5jb20+iQE4BBMBAgAiBQJUWiM2AhsD
BgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRAsyzat/FhJp7daB/0UlljRMtJ7
/Ht9gDcQm1pqsShGw29QtLSxDWV7A250GdveGNs2yZTCJQIyoK1Pa+Q5GOUwv0I2
VOxqTgnG3j1pCtcCbb7rkRQa6dix71IgKG+F4wUlWLdgaVsH7h1MtVobZ+nNSQAY
Bl+9vd9cKuyIYI+e6pdlLP/yCT78ehI/wVDD2V/w3ixnvnSLIgoRQRX9gAbRIf3i
/cXpyVn7wLYNMUwBrH3hPDTJPTdNih75ZcMMBWDnkt+IMijtxM++4J+45odoPKb6
bCvq0e0WtWmscOx/jN5cgOyC/87lcQuHSyjiSJowJzJUnO0sL9r1X1RFsU+XhGfN
8Ml/9flP/ojYuQENBFRaIzYBCADCE9S6rB7FI4z07H0PZ97XKh5U7r5hIxWrt1nC
yzD/Hprfy9ZZRJklAa+XlMMIPHHv3h8JEL2B5TWKxCa7KbNYfoLoLGywp6aIw6+X
kDhKXesEDN5WFUCW186hlmEExgNpOGZlbBLqJnaFfxhunSGgdHd5YHiASkts5Uwd
zzo2uFMcn0q0HlLLGAVwI787P6xAsAvgf4BCFuc4XGCWl8XDQbChZ8LC/ovHPq4Q
H8g6cIzya6f5E/VT2+dYGpME0bPmjTm0ZzvTHWfjw+B2d5AO5mNQiewHejnPxrcq
qJkO+Y6S80R/JPfmOI3RCHcoyB+QJ1I2I4yQ6G5dFwKl/IknABEBAAGJAR8EGAEC
AAkFAlRaIzYCGwwACgkQLMs2rfxYSad2pAf8CaKsDD1yj1mvYcUX1chrUlYmZVuR
PSFKf90OETlGSCYqdi4yyeJJnis4HBDcGPa+hFpLVksJlRCKqKQiqjndaNHhRgyM
ZouoeJvBiwCdwpQmZHgpgTv1V8n4PJ4anqISC5/ZGN9HDJ68gDx2hzeuilc+6umK
E99f7Qo8rdaeu5IGhujQhxnemAyTBNGZh3tABZcni5m7uVJKihdDUogghXSnIBxh
ilSqRQrPqyCjic8MUB9S+eBQC4Z67i9YqJaBfb80x9HqINLncGFDHKIajwy8f7Sh
k67z733GYXrAnyHsia4IF4UGRLW4+1xtKE9xmUThmwMdkgqtJ9eqBpAF9A==
=/BT3
-----END PGP PUBLIC KEY BLOCK-----
~~~
