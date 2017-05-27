#!/bin/sh
path="$(kde4-config --path services)"
spath="$(echo ${path%:*})"
rm "$spath"ServiceMenus/ClamScan/ClamScan.desktop
rm "$spath"ServiceMenus/ClamScan/ClamScan.sh
rm -r "$spath"ServiceMenus/ClamScan/
path2="$(kde4-config --localprefix)share/apps/solid/actions"
rm $path2/ClamScan_action.desktop