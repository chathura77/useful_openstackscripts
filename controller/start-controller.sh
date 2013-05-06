#! /bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

# External bridge that we have configured 
# into l3_agent.ini (Don't change it!)
EXT_NET_BRIDGE=br-ex

# IP of external bridge (br-ex) - this node's 
# IP in our official Internet IP address space:
EXT_GW_IP="192.168.2.225"

# External Network addressing - our official 
# Internet IP address space
EXT_NET_CIDR="192.168.2.0/24"
EXT_NET_LEN=${EXT_NET_CIDR#*/}

service networking restart
service ntp restart
service mysql restart
service keystone restart
keystone-manage db_sync
service glance-api restart 
service glance-registry restart
glance-manage db_sync
service nova-api restart
service nova-cert restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-novncproxy restart
nova-manage db sync
service iscsitarget restart
service open-iscsi restart
start tgt
#./connect_iscsi_front-end.sh
./connect_iscsi.sh -t iqn.2013-02.uk.ac.essex.dcl.cluster:cronus-share -i 10.10.10.84
cinder-manage db sync
service cinder-api restart
service cinder-scheduler restart
service cinder-volume restart
service quantum-server restart
service openvswitch-switch restart
service quantum-plugin-openvswitch-agent restart
service quantum-dhcp-agent restart
service quantum-l3-agent restart
