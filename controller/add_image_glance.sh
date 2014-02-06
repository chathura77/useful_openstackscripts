#!/bin/sh

#
#
# This script adds a new image to Glance.
#
#
# Chathura S. Magurawalage
# email: csarata@essex.ac.uk
#        chathura.sarathchandra@gmail.com
((
NAME="myImage"
DISK_FORMAT=qcow2
IS_PUBLIC=true
CONTAINER_FORMAT=bare

while getopts n:d:c:p:f:l:hv option
do 
    case "${option}"
    in
        n) NAME=${OPTARG};;
        d) DISK_FORMAT=${OPTARG};;	
        c) CONTAINER_FORMAT=${OPTARG};;
	p) IS_PUBLIC=${OPTARG};;
        f) FILE=${OPTARG};;
	l) LINK=${OPTARG};;
	v) set -x;;
        h) cat <<EOF 
Usage: $0 [-n name] [-d disk_format] [-c container_format] [-p is_public] [-f file] [-l url_to_file]

Add -v for verbose mode, -h to display this message.
EOF
exit 0
;;
	\?) echo "Use -h for help"
	    exit 1;;
    esac
done

#not sure if --location switch works with local file locations
if [ -n "$FILE" ]
then
glance image-create --name $NAME --disk-format=$DISK_FORMAT --container-format=$CONTAINER_FORMAT --is-public=$IS_PUBLIC < $FILE 
elif [ -n "$LINK" ]
then
glance image-create --name $NAME --location $LINK --disk-format=$DISK_FORMAT --container-format=$CONTAINER_FORMAT --is-public=$IS_PUBLIC
else
echo "Please provide the image source"
fi

glance image-list

)) 2>&1 | tee $0.log
