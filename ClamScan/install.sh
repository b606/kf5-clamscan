#!/bin/sh

# PART 1
# make dir /home/$USER/.kde/share/kde4/services/ServiceMenus/ClamScan
# and /home/$USER/.kde/share/kde4/services/ServiceMenus/ClamScan/logs/
#
# copy ClamScan.desktop and ClamScan.sh to /home/$USER/.kde/share/kde4/services/ServiceMenus/ClamScan
path="$(kde4-config --path services)"
spath="$(echo ${path%:*})"

mkdir -p "$spath"ServiceMenus/ClamScan
mkdir -p "$spath"ServiceMenus/ClamScan/logs

cp ClamScan.desktop "$spath"ServiceMenus/ClamScan/
cp ClamScan.sh "$spath"ServiceMenus/ClamScan/
if echo "$spath" | grep '/.kde/share/kde4/services/' > /dev/null; 
  then :
  else sed -i -e "s;~/.kde/share/kde4/services/;$spath;g" "$spath"ServiceMenus/ClamScan/ClamScan.desktop; 
fi

# PART 2
# Copy ClamScan_action.desktop to /home/$USER/.kde/share/apps/solid/actions/
path2="$(kde4-config --localprefix)share/apps/solid/actions"
if [ -d $path2 ]
  then cp ClamScan_action.desktop $path2
fi