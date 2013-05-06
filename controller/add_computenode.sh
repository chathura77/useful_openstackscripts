#! /bin/sh

#
# This script adds required permissions needed by the contoller, for the
# compute nodes to access the databases remotely.
#
# Chathura S. Magurawalage
# email: csarata@essex.ac.uk
#        77.chathura@gmail.com

((

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

while getopts K:hv option
do 
    case "${option}"
    in
        K) COMPUTE_IP=${OPTARG};;
	v) set -x;;
        h) cat <<EOF 
Usage: $0 [-K computenode_management_ip] 

Add -v for verbose mode, -h to display this message.
EOF
exit 0
;;
	\?) echo "Use -h for help"
	    exit 1;;
    esac
done

# while getopts "K:vh" opt; 
# do
#     case $opt in
# 	K) COMPUTE_IP=${OPTARG};;
# 	h) cat <<EOF 
# Usage: $0 [-K computenode_ip]

# Add -v for verbose mode, -h to display this message.
# EOF
# exit 0;;
# 	v) set -x
#       ;;
#     esac
# done

mysql -u root -ppassword <<EOF
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@$COMPUTE_IP \
IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@$COMPUTE_IP \
IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EOF

echo "Database permissions for compute node $COMPUTE_IP has been submited!"

)) 2>&1 | tee $0.log
