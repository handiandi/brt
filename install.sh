#!/bin/bash

DIRECTORY="/usr/local/share/man/man7"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root: sudo ./install.sh" 1>&2
    exit 1
fi

cp brt.sh /usr/bin/brt
if [ ! -d "$DIRECTORY" ]; then
	mkdir "$DIRECTORY"
	echo "/usr/local/share/man/man7  is created..."
fi
cp brt.7 /usr/local/share/man/man7/
echo "-- Updating man page database..."	
mandb

printf "\nInstallation done!\nUse 'man brt' for man-page and 'brt' for execution\n"