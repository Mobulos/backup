#!/bin/bash
# Init
#
#
#
# BSD 2-Clause License
#
# Copyright (c) 2019, Fabian Schmeltzer
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function jumpto() {
	label=$1
	cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
	eval "$cmd"
	exit
}

menue=${1:-"menue"}
update=${2:-"update"}
settings=${3:-"settings"}
backup=${4:-"backup"}
restore=${5:-"restore"}

FILE="/tmp/out.$$"
GREP="/bin/grep"
if [ "$(id -u)" != "0" ]; then
	echo "Das Script muss als root gestartet werden." 1>&2
	exit 1
fi

# farbcodes:

red=($(tput setaf 1))
green=($(tput setaf 2))
yellow=($(tput setaf 3))
reset=($(tput sgr0))

#menü

clear

if [[ -d "files" ]]; then
	jumpto update
elif [[ * ]]; then
	apt-get update
	clear
	apt-get upgrade -y
	clear
	apt-get install curl -y
	clear
	apt-get install zip -y
	clear
	apt-get install unzip -y
	clear
	apt-get install tar -y
	clear
	jumpto update
fi

# ███    ███ ███████ ███    ██ ██    ██
# ████  ████ ██      ████   ██ ██    ██
# ██ ████ ██ █████   ██ ██  ██ ██    ██
# ██  ██  ██ ██      ██  ██ ██ ██    ██
# ██      ██ ███████ ██   ████  ██████

menue:
mkdir files
mkdir files/backup
touch files/backup/name
touch files/backup/list
touch files/backup/to
mkdir files/backupink
touch files/backupink/name
touch files/backupink/list
touch files/backupink/to
clear

echo "
██████   █████   ██████ ██   ██ ██    ██ ██████
██   ██ ██   ██ ██      ██  ██  ██    ██ ██   ██
██████  ███████ ██      █████   ██    ██ ██████
██   ██ ██   ██ ██      ██  ██  ██    ██ ██
██████  ██   ██  ██████ ██   ██  ██████  ██
"
set -u
clear
echo "$yellow########################################"
read -t 0.1
echo "######  BackUp Script by Mobulos  ######"
read -t 0.1
echo "########################################"
read -t 0.1
echo "ACHTUNG|      Alpha Update      |ACHTUNG"
echo
echo "Version 2.2.3"
read -t 0.1
echo "Update 22.12.2019" #TODO Version und Datum ändern
echo "$reset"
echo
read -t 0.1
echo "Auswahlmöglichkeiten"
read -t 0.1
tmp=($(tput setaf 3))
echo -n "$tmp"
echo "[1] Backup erstellen"
read -t 0.1
tmp=($(tput setaf 3))
echo -n "$tmp"
echo "[2] Inkrementelles-Backup erstellen"
read -t 0.1
tmp=($(tput setaf 3))
echo -n "$tmp"
echo "[3] Backup wiederherstellen"
read -t 0.1
tmp=($(tput setaf 1))
echo -n "$tmp"
echo "[4] Backup löschen"
read -t 0.1
tmp=($(tput setaf 2))
echo -n "$tmp"
echo "[5] Liste der Backups"
read -t 0.1
tmp=($(tput setaf 6))
echo -n "$tmp"
echo "[6] Script Updaten"
read -t 0.1
tmp=($(tput setaf 5))
echo -n "$tmp"
echo "[7] Enstellungen Ändern"
read -t 0.1
tmp=($(tput setaf 4))
echo -n "$tmp"
echo "[8] Exit"
echo "$reset"
read -t 0.1
read -n1 -p "Was willst du tun?: " befehl
clear
case $befehl in
	1)
		jumpto backup
		exit
		;;
	2)
		jumpto backupink
		exit
		;;
	3)
		jumpto restore
		exit
		;;
	4)
		jumpto delete
		exit
		;;
	5)
		jumpto list
		exit
		;;
	6)
		rm 20*
		clear
		jumpto update
		exit
		;;
	7)
		jumpto settings
		;;
	8)
		clear
		exit
		;;
	*)
		echo "Dieser Befehl existiert nicht!"
		read -t 3 -n 1
		jumpto menue
		exit
		;;
esac

# ██      ██ ███████ ████████
# ██      ██ ██         ██
# ██      ██ ███████    ██
# ██      ██      ██    ██
# ███████ ██ ███████    ██

list:
clear
read -t 0.1
tmp=($(tput setaf 1))
echo -n "$tmp"
echo "[1] Backups"
read -t 0.1
tmp=($(tput setaf 2))
echo -n "$tmp"
echo "[2] Inkrementelle-Backups"
read -t 0.1
tmp=($(tput setaf 3))
echo -n "$tmp"
echo "[3] Zurück zum Menü"
echo -n "$reset"
echo
read -n1 -p "Welcher art von Backups möchtest du dir anzeigen lassen?" art
case $art in
	1)
		clear
		echo "Follgende Backups wurden erstellt: "
		paste files/backup/name files/backup/list > temp
		cat -n temp
		rm temp
		read -n1
		jumpto list
		;;
	2)
		clear
		echo "Follgende Inkrementelle-Backups wurden erstellt: "
		paste files/backupink/name files/backupink/list > temp
		cat -n temp
		rm temp
		read -n1
		jumpto list
		;;
	3)
		clear
		jumpto menue
		;;
	*)
		clear
		echo -n "$red"
		echo "Befehl nicht gefunden!"
		echo -n "$reset"
		read -n1 -t 3
		jumpto list
		;;
esac
jumpto menue
exit

# ██████   █████   ██████ ██   ██ ██    ██ ██████
# ██   ██ ██   ██ ██      ██  ██  ██    ██ ██   ██
# ██████  ███████ ██      █████   ██    ██ ██████
# ██   ██ ██   ██ ██      ██  ██  ██    ██ ██
# ██████  ██   ██  ██████ ██   ██  ██████  ██

backup:
clear
echo "Folgende Backups exsistieren: "

paste files/backup/name files/backup/list > temp
cat -n temp
rm temp

echo
echo
bck=""
bckto=""
nam=""
read -e -p "Von welchem Ordner soll ein Backup erstellt werden? " bck
if [ -d "$bck" ]; then
	echo
elif [[ * ]]; then
	echo "Dieser Ordner existiert nicht!"
	jumpto backup
fi

clear
echo "Wo soll das Backup gespeichert werden?"
echo
echo 'Bitte im folgenden Format angeben: "/pfad/zum/ordner/" '
echo
read -e -p 'Standardmäßig lautet der Pfad: "/root/backup/" ' bckto

if [ -z "$bckto" ]; then
	bckto="/root/backup/"
	mkdir -p "$bckto"
	clear
elif [[ * ]]; then
	echo
fi

clear
if [ -d "$bckto" ]; then
	echo
elif [[ * ]]; then
	for i in . .. ...; do
		clear
		echo "Dieser Ordner existiert nicht!"
		echo "Daher wird er nun erstellt $i"
		read -t 1
	done
	mkdir -p "$bckto"
fi

clear
read -p "Gebe ein Namen für das Backup an: " nam
clear
echo "$nam" >> files/backup/name
echo "$bck" >> files/backup/list
echo "$bckto" >> files/backup/to
tar -cpz $bck | (pv -n > $bckto$nam.tgz) 2>&1 | dialog --gauge "Wallie erstellt ein Backup, ich wusste garnicht, dass das möglich ist......" 10 70 0
# rsync -a --delete $bck $bckto/$nam
clear
echo "Das Backup wurde erstellt!"
read -n1
exit

# ██████   █████   ██████ ██   ██ ██    ██ ██████  ██ ███    ██ ██   ██
# ██   ██ ██   ██ ██      ██  ██  ██    ██ ██   ██ ██ ████   ██ ██  ██
# ██████  ███████ ██      █████   ██    ██ ██████  ██ ██ ██  ██ █████
# ██   ██ ██   ██ ██      ██  ██  ██    ██ ██      ██ ██  ██ ██ ██  ██
# ██████  ██   ██  ██████ ██   ██  ██████  ██      ██ ██   ████ ██   ██

backupink:
bck=""
bckto=""
nam=""
clear
echo -n "$red"
read -n1 -p "WARNUNG: Inkrementelle-Backpus können noch nicht wiederhergestellt werden!" # TODO: Wiederherstellen für ink Backups coden
echo -n "$reset"
clear
echo "Folgende Inkrementelle-Backups exsistieren: "
paste files/backupink/name files/backupink/list > temp
cat -n temp
rm temp
echo
echo
read -p "Gebe ein Namen für das Backup an: " nam
clear
read -e -p "Von welchem Ordner soll ein Inkrementelles-Backup erstellt werden? " bck
if [ -d "$bck" ]; then
	echo
elif [[ * ]]; then
	echo "Dieser Ordner existiert nicht!"
	read -t 3
	jumpto backupink
	exit
fi

clear
echo "Wo soll das Backup gespeichert werden?"
echo
read -e -p 'Standardmäßig lautet der Pfad: "/root/backup/ink/" ' bckto

if [ -z "$bckto" ]; then
	bckto="/root/backup/ink/"
fi

last="${bckto: -1}"

if [[ $last == "/" ]]; then
	bckto="${bckto%?}"
fi
bckto=($bckto/$nam)
clear
if [ -d "$bckto" ]; then
	echo
elif [[ * ]]; then
	echo -n "$green"
	for i in . .. ...; do
		clear
		echo "Der Ordner wird nun erstellt $i"
		read -t 1
	done
	echo -n "$reset"
	mkdir -p "$bckto"
fi

clear
echo "$nam" >> files/backupink/name
echo "$bck" >> files/backupink/list
echo "$bckto" >> files/backupink/to
rdiff-backup $bck $bckto
echo "Das Backup wurde erstellt!"
exit

# Backup machen
# rdiff-backup /home/1-14-3/ /root/backup

# backup list
# rdiff-backup -l /root/backup

# ██████  ███████ ███████ ████████  ██████  ██████  ███████
# ██   ██ ██      ██         ██    ██    ██ ██   ██ ██
# ██████  █████   ███████    ██    ██    ██ ██████  █████
# ██   ██ ██           ██    ██    ██    ██ ██   ██ ██
# ██   ██ ███████ ███████    ██     ██████  ██   ██ ███████

restore:
clear
echo "Welche der folgenden Backups möchtest du wiederherstellen?"
echo
paste files/backup/name files/backup/list > temp
cat -n temp
rm temp
echo
read -p 'Bitte gebe die Zahl des Backups ein: ' resup
resto=$(sed -ne "$resup"'p' files/backup/to)
reslist=$(sed -ne "$resup"'p' files/backup/list)
resname=$(sed -ne "$resup"'p' files/backup/name)
echo -n "$red"
echo "ACHTUNG: IN EINIGEN FÄLLEN WAR DAS ERSTELLEN DES BACKUPS FEHLERHAFT!"
echo "				 üBERPRÜFE UNBEDING, OB DAS BACKUP ERFOLGREICH WAR(Die .tar Datei öffnen und auf vollständigkeit überprüfen)"
echo "$reset"
read -n1 -p 'WARNUNG: Das Zielverzeichnis wird überschrieben !!! (Y/N): ' warn
case $warn in
	Y | y | J | j)
		(tar -xzf $resto$resname.tgz -C /) | dialog --gauge "Wallie stell das Backup wiederher, das ist echt unglaublich......" 10 70 0
		clear
		echo "Das Backup wurde wiederhergestellt!"
		read -t 5 -n 1
		clear
		jumpto menue
		;;
	N | n)
		echo -n "$red"
		echo "Es tut mir leid, doch ich darf das Backup nicht wiederherstellen, wenn Du mich das Zielverzeichnis nicht überschreiben lässt!"
		echo -n "$reset"
		read -n1
		jumpto menue
		exit
		;;
esac

# ██████  ███████ ██      ███████ ████████ ███████
# ██   ██ ██      ██      ██         ██    ██
# ██   ██ █████   ██      █████      ██    █████
# ██   ██ ██      ██      ██         ██    ██
# ██████  ███████ ███████ ███████    ██    ███████

delete:
clear
echo "Welche der folgenden Backups möchtest du löschen?"
echo
paste files/backup/name files/backup/list > temp
cat -n temp
rm temp
echo
read -n1 -p "Bitte gebe die Zahl des Backups ein: " delup
delto=$(sed -ne "$delup"'p' files/backup/to)
delname=$(sed -ne "$delup"'p' files/backup/name)
clear
read -n1 -p "Soll Backup-Datei '$delto$delname.tgz' ebenfalls gelöscht werden?! (Y/N) [Empfohlen: (Y)] " delyn
case $delyn in
	Y | y | J | j)
		rm -r $delto$delname.tgz
		sed -i "$delup D" "files/backup/list"
		sed -i "$delup D" "files/backup/name"
		sed -i "$delup D" "files/backup/to"
		;;
	*)
		echo -n "$red"
		echo "Der Ordner wurde nicht gelöscht, du musst dies ggf. selber Löschen!"
		echo -n "$reset"
		read -t 5 -n 1
		;;
esac
clear
echo "Das Backup wurde gelöscht!"
read -t 3 -n 1
jumpto menue
exit

# ██    ██ ██████  ██████   █████  ████████ ███████
# ██    ██ ██   ██ ██   ██ ██   ██    ██    ██
# ██    ██ ██████  ██   ██ ███████    ██    █████
# ██    ██ ██      ██   ██ ██   ██    ██    ██
#  ██████  ██      ██████  ██   ██    ██    ███████

update:
if [ -f $(date +%Y-%m-%d) ]; then
	jumpto menue
elif [[ * ]]; then
	clear
fi
read -t 2 -n 1
rm 20*
touch $(date +%Y-%m-%d)
clear
echo "$red Die neuste Version wird heruntergeladen"
echo "$reset"
rm backupscript.sh
if [ -f ".alpha" ]; then
	echo "$red"
	curl --progress-bar https://raw.githubusercontent.com/Mobulos/backup/alpha/backupscript.sh --output backupscript.sh
	echo "$reset"
	read -t 1
	chmod +x backupscript.sh
	./backupscript.sh
	exit
elif [[ * ]]; then
	echo "$red"
	curl --progress-bar https://raw.githubusercontent.com/Mobulos/backup/master/backupscript.sh --output backupscript.sh
	echo "$reset"
	read -t 1
	chmod +x backupscript.sh
	./backupscript.sh
	exit
fi

# ███████ ███████ ████████ ████████ ██ ███    ██  ██████  ███████
# ██      ██         ██       ██    ██ ████   ██ ██       ██
# ███████ █████      ██       ██    ██ ██ ██  ██ ██   ███ ███████
#      ██ ██         ██       ██    ██ ██  ██ ██ ██    ██      ██
# ███████ ███████    ██       ██    ██ ██   ████  ██████  ███████

settings:
dir=$(cd $(dirname 0) && pwd)
rm files/dir
touch files/dir
clear

tmp=($(tput setaf 1))
echo -n "$tmp"
echo "######## #### ##    ##  ######  ######## ######## ##       ##       ##     ## ##    ##  ######   ######## ##    ##"
tmp=($(tput setaf 2))
echo -n "$tmp"
read -t 0.1
echo "##        ##  ###   ## ##    ##    ##    ##       ##       ##       ##     ## ###   ## ##    ##  ##       ###   ##"
tmp=($(tput setaf 3))
echo -n "$tmp"
read -t 0.1
tmp=($(tput setaf 4))
echo -n "$tmp"
read -t 0.1
echo "######    ##  ## ## ##  ######     ##    ######   ##       ##       ##     ## ## ## ## ##   #### ######   ## ## ##"
tmp=($(tput setaf 5))
echo -n "$tmp"
read -t 0.1
echo "##        ##  ##   ### ##    ##    ##    ##       ##       ##       ##     ## ##   ### ##    ##  ##       ##   ###"
tmp=($(tput setaf 6))
echo -n "$tmp"
read -t 0.1
echo "##        ##  ##  ####       ##    ##    ##       ##       ##       ##     ## ##  #### ##    ##  ##       ##  ####"
tmp=($(tput setaf 8))
echo -n "$tmp"
read -t 0.1
echo "######## #### ##    ##  ######     ##    ######## ######## ########  #######  ##    ##  ######   ######## ##    ##"
echo
echo
echo "$reset"
read -t 0.1
echo "Follgende Einstellungen können geändert werden:"
read -t 0.1
echo "[1] Alpha Updates"
read -t 0.1
echo "[2] Zurück zum Menü"
read -t 0.1
read -n1 -p "Was mächtest du ändern?" set
case $set in
	1)
		if [ -f ".alpha" ]; then
			clear
			echo "Du bist bereits im Alpha ring!"
			echo
			read -n1 -p "Möchtest du diesen jetzt verlassen? (Y/N) " versionl
			case $versionl in
				Y | y | J | j)
					rm .alpha
					rm 20*
					clear
					echo "Du erhältst nun keine Test-Versionen mehr!"
					read -t 3 -n 1
					jumpto update
					exit
					;;
				N | n)
					touch .alpha
					rm 20*
					clear
					echo "Du erhälstst weiterhin Alpha Updates."
					read -t 3
					jumpto update
					exit
					;;
				*)
					clear
					read -n1 "Eingabe nicht erkannt"
					jumpto settings
					exit
					;;
			esac
		elif [[ * ]]; then
			clear
			read -n1 -p "Möchtest du jetzt der Alpha beitreten? (Y/N) " versionj
			case $versionj in
				Y | y | j | J)
					touch .alpha
					rm 20*
					clear
					echo "Du erhälst ab jetzt die neuste (Alpha) Version!"
					read -t 3 -n 1
					jumpto update
					exit
					;;
				N | n)
					rm .alpha
					rm 20*
					clear
					echo "Du erhältst weiterhin die offizielle Version!"
					read -t 3 -n 1
					jumpto update
					exit
					;;
				*)
					clear
					read -n1 "Eingabe nicht erkannt"
					jumpto settings
					exit
					;;
			esac

		fi
		;;
	2)
		jumpto menue
		exit
		;;
	*)
		clear
		read -n1 "Eingabe nicht erkannt"
		jumpto settings
		exit
		;;
esac
exit
