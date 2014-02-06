#!/bin/bash

# This script fixes following problem.

# FATAL: Module openvswitch_mod not found.
#  * Inserting openvswitch module
#  * not removing bridge module because bridges exist (virbr0)
# invoke-rc.d: initscript openvswitch-switch, action "load-kmod" failed.

sudo apt-get install linux-headers-$(uname -r)

sudo apt-get remove quantum-plugin-openvswitch openvswitch-switch quantum-plugin-openvswitch-agent openvswitch-datapath-dkms openvswitch-common quantum-common python-quantum

apt-get install openvswitch-switch
mkdir -p /etc/quantum/
apt-get install quantum-plugin-openvswitch-agent quantum-dhcp-agent quantum-l3-agent quantum-server

depmod
modprobe openvswitch
