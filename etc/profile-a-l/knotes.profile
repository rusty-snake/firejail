# Firejail profile for knotes
# Description: Sticky notes application
# This file is overwritten after every install/update
# Persistent local customizations
include knotes.local
# Persistent global definitions
# added by included profile
#include globals.local

# knotes has problems launching akonadi in debian and ubuntu.
# one solution is to have akonadi already running when knotes is started

nodeny  ${HOME}/.config/knotesrc
nodeny  ${HOME}/.local/share/knotes
nodeny  ${HOME}/.local/share/kxmlgui5/knotes

# Redirect
include kmail.profile
