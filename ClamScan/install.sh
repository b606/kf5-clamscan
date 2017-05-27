#!/bin/sh

# PART 1
# make dir /home/$USER/.local/share/kservices5/ServiceMenus/ClamScan
# and /home/$USER/.local/share/kservices5/ServiceMenus/ClamScan/logs/
#
# copy ClamScan.desktop and ClamScan.sh to /home/$USER/.local/share/kservices5/ServiceMenus/ClamScan
path="$(kf5-config --path services)"
spath="$(echo ${path%:*})"

mkdir -p "$spath"ServiceMenus/ClamScan
mkdir -p "$spath"ServiceMenus/ClamScan/logs

cp ClamScan.desktop "$spath"ServiceMenus/ClamScan/
cp ClamScan.sh "$spath"ServiceMenus/ClamScan/
if echo "$spath" | grep '/.local/share/kservices5/' > /dev/null; 
  then :
  else sed -i -e "s;~/.local/share/kservices5/;$spath;g" "$spath"ServiceMenus/ClamScan/ClamScan.desktop; 
fi

# PART 2
# Copy ClamScan_action.desktop to /home/$USER/.local/share/solid/actions/
path2="$HOME/.local/share/solid/actions"
mkdir -p $HOME/.local/share/solid
mkdir -p $path2
if [ -d $path2 ]
  then cp ClamScan_action.desktop $path2
fi

# TODO: solid/actions need kbuildsycoca5 after (un)install
# https://www.kubuntuforums.net/showthread.php?t=68016&p=371184&viewfull=1#post371184
# Apparently, need to copy to /usr/share/solid/actions/
# or copy all /usr/share/solid/actions/ to ~/.local/share/solid/actions/

# kbuildsycoca5 --noincremental
