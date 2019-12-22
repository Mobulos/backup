curl --progress-bar https://raw.githubusercontent.com/Mobulos/backup/master/backupscript.sh --output backupscript.
read -t 1
chmod +x backupscript.sh
./backupscript.sh
