# Support

Please report the problems you run into on our [GitHub](https://github.com/netblue30/firejail/issues)
bug tracker. For general questions you can also use the comment section on any page on this website.

## Profile fixes

Fixed security profile fixes are available for various Firejail versions in this
[GitHub](https://github.com/netblue30/firejail/tree/master/etc-fixes) directory. The fixes cover
applications such as Firefox browser (version 60 is breaking badly!), LibreOffice (crashes on
Ubuntu 18.04), gedit. Manually overwrite the files in `/etc/firejail` directory with the files from
GitHub.

Firefox example:

 1. in your browser, open the GitHub page corresponding to your Firejail version (
    [0.9.38](https://github.com/netblue30/firejail/blob/master/etc-fixes/0.9.38/firefox.profile),
    [0.9.52](https://github.com/netblue30/firejail/blob/master/etc-fixes/0.9.52/firefox.profile))
 2. in a text editor, open the file with the same name in `/etc/firejail` directory
    (`sudo /usr/bin/gedit /etc/firejail/firefox.profile`)
 3. cut&paste from the web page into the text editor

## Frequently Asked Questions

We keep this section on our GitHub wiki here: <https://github.com/netblue30/firejail/wiki/Frequently-Asked-Questions>
