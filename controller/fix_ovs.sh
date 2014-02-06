#!/bin/sh

#
# This script fixes the following bug.
# Has to be run after reboot.
# Bug: https://bugs.launchpad.net/quantum/+bug/1091605
#
#
# Chathura S. Magurawalage
# email: csarata@essex.ac.uk
#        chathura.sarathchandra@gmail.com

((
#Check for root permissions
# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

BRIDGE=${BRIDGE:-br0}

while getopts b:hv option
do 
    case "${option}"
    in
        b) BRIDGE=${OPTARG};;
	v) set -x;;
        h) cat <<EOF 
Usage: $0 [-b bridge_name]

Add -v for verbose mode, -h to display this message.
EOF
exit 0
;;
	\?) echo "Use -h for help"
	    exit 1;;
    esac
done

ovs-vsctl del-br br-int
ovs-vsctl del-br br-ex
ovs-vsctl add-br br-int
ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex $BRIDGE
ip link set up br-ex

service quantum-plugin-openvswitch-agent restart
service quantum-dhcp-agent restart
service quantum-l3-agent restart

)) 2>&1 | tee $0.log
