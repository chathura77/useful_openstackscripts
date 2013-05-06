#! /bin/sh

((

# Make sure only root can run our script                                        
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

service networking restart
service ntp restart
service libvirt-bin restart
service nova-compute restart
service openvswitch-switch start
service quantum-plugin-openvswitch-agent restart

echo "Compute Node has been restarted!"

)) 2>&1 | tee $0.log
