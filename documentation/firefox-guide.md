# Firefox Sandboxing Guide

**Contents**

 * [Introduction](#introduction)
 * [Starting Firefox](#starting-firefox)
 * [Sandbox description](#sandbox-description)
 * [High security browser setup](#high-security-browser-setup)
 * [Work setup](#work-setup)
 * [Basic network setup](#basic-network-setup)
 * [X11 sandbox](#x11-sandbox)

**TLDR**

<iframe class='youtube-player' width='625' height='352' src='https://www.youtube.com/embed/kCnAxD144nU?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en&#038;autohide=2&#038;wmode=transparent' allowfullscreen='true' style='border:0;' sandbox='allow-scripts allow-same-origin allow-popups allow-presentation'></iframe>

## Introduction

In August 2015, Mozilla was notified by security researcher Cody Crews that a malicious
advertisement on a Russian news site was [exploiting](https://blog.mozilla.org/security/2015/08/06/firefox-exploit-found-in-the-wild/)
a vulnerability in Firefox's PDF Viewer. The exploit payload searched for sensitive files on users'
local filesystem, and reportedly uploaded them to the attacker's server. The default Firejail
configuration blocked access to `.ssh`, `.gnupg` and `.filezilla` in all directories present under
`/home`. More advanced sandbox configurations blocked everything else.

This document describes some of the most common Firefox sandbox setups. We start with the default
setup, recommended for entertainment and casual browsing.
