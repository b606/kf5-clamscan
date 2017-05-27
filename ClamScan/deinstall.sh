#!/bin/sh
path="$(kf5-config --path services)"
spath="$(echo ${path%:*})"
rm "$spath"ServiceMenus/ClamScan/ClamScan.desktop
rm "$spath"ServiceMenus/ClamScan/ClamScan.sh
rm -r "$spath"ServiceMenus/ClamScan/
path2="$HOME/.local/share/solid/actions"
rm $path2/ClamScan_action.desktop

# TODO: solid/actions need kbuildsycoca5 after (un)install
# https://www.kubuntuforums.net/showthread.php?t=68016&p=371184&viewfull=1#post371184
# Apparently, need to copy to /usr/share/solid/actions/
# or copy all /usr/share/solid/actions/ to ~/.local/share/solid/actions/

# kbuildsycoca5 --noincremental
