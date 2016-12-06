#!/bin/bash

DIRECTORY="/usr/local/share/man/man7"

cp brt.sh /usr/bin/
if [ ! -d "$DIRECTORY" ]; then
	mkdir "$DIRECTORY"
	echo "/usr/local/share/man/man7  is created..."
fi
cp brt.7 /usr/local/share/man/man7/
echo "-- Updating man page database..."	
mandb

printf "\nInstallation done!\nUse 'man brt' for man-page and 'brt' for execution\n"