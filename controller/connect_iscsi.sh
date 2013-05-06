#!/bin/sh

#
#
# This script connects to an iSCSI target 
#
#
# Chathura S. Magurawalage
# email: csarata@essex.ac.uk
#        77.chathura@gmail.com

((

#Check for root permissions
# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

while getopts t:i:hv option
do 
    case "${option}"
    in
        t) TARGET=${OPTARG};;
	i) IP=${OPTARG};;
#	p) PASSWORD=${OPTARG};;
	v) set -x;;
        h) cat <<EOF 
Usage: $0 [-t target_name] [-i target_ip]

Add -v for verbose mode, -h to display this message.
EOF
exit 0
;;
	\?) echo "Use -h for help"
	    exit 1;;
    esac
done


#Connect to the iSCSI storage image in the front-end
iscsiadm -m discovery -t sendtargets -p $IP
iscsiadm -m node --targetname $TARGET --portal "$IP:3260" --login

)) 2>&1 | tee $0.log
