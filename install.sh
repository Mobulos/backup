#!/bin/bash
# Init

# root check
FILE="/tmp/out.$$"
GREP="/bin/grep"
if [ "$(id -u)" != "0" ]; then
  echo "Das Script muss als root gestartet werden." 1>&2
  exit 1
fi

apt-get install sudo
sudo apt-get install curl
clear
curl --progress-bar https://raw.githubusercontent.com/Mobulos/backup/master/backupscript.sh --output backupscript.sh
read -t 1
chmod +x backupscript.sh
clear
./backupscript.sh
