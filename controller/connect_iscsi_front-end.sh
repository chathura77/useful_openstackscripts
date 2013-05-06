#! /bin/bash

((

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

#Connect to the iSCSI storage image in the front-end

iscsiadm -m node --targetname "iqn.2013-01.com.ncl:xbmc-server" --portal "10.10.10.43:3260" --login

)) 2>&1 | tee $0.log
