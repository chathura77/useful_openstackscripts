#!/bin/sh

#
#
# Adds a user to keystone, who holds a "Member role"
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

while getopts p:n:u:e:t:hv option
do 
    case "${option}"
    in
	p) PASSWORD=${OPTARG};;
	u) USER=${OPTARG};;
	e) EMAIL=${OPTARG};;
	t) TENANT_ID=${OPTARG};;
	n) NEW_TENANT_NAME=${OPTARG};;
	v) set -x;;
        h) cat <<EOF
Usage: $0 [-u username] [-t existing_tenant_id] [-n new_tenant_name] [-p user_password] [-e user_email]

Add -v for verbose mode, -h to display this message.
EOF
exit 0
;;
	\?) echo "Use -h for help"
	    exit 1;;
    esac
done

if [ -z "$USER" ];
then
echo "Please insert the username"
exit 1;
fi

get_id () {
    echo `$@ | awk '/ id / { print $4 }'`
}

PASSWORD=${PASSWORD:-1234}

#Role member

ROLE=${ROLE:- #Add role id here}

if [ -n "$NEW_TENANT_NAME" ];
then
#Tenant
TENANT_ID=$(get_id keystone tenant-create --name="$NEW_TENANT_NAME")
fi

if [ -z "$TENANT_ID" ];
then
echo "Please insert Tenant id or new tenant name!"
exit 1;
fi

#User
USER_ID=$(get_id keystone user-create --name="$USER" --pass="$PASSWORD" --email="$EMAIL")

#Add roles to users in tenants
keystone user-role-add --user-id "$USER_ID" --role-id "$ROLE" --tenant-id "$TENANT_ID"

)) 2>&1 | tee $0.log
