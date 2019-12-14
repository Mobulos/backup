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
menuef=${3:-"menuef"}
alpha=${4:-"alpha"}
settings=${5:-"settings"}
backup=${6:-"backup"}
restore=${7:-"restore"}

FILE="/tmp/out.$$"
GREP="/bin/grep"
if [ "$(id -u)" != "0" ]; then
  echo "Das Script muss als root gestartet werden." 1>&2
  exit 1
fi

# farbcodes:
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)
#menü
1m="tput setaf 18"

mkdir files
mkdir files/backup
touch files/backup/name
touch files/backup/list
touch files/backup/to
touch files/backup/name

clear
if [ -d $(files) ]; then
  jumpto menue
elif [[ * ]]; then
  apt update && apt upgrade -y && apt install curl -y && apt install git -y && apt install nano -y && apt install zip -y && apt install unzip -y && apt install tar -y
  jumpto $settings
fi

menue:
if [ -f $(date +%Y-%m-%d) ]; then
  jumpto menuef
elif [[ * ]]; then
  jumpto $update
fi

menuef:
clear
echo "$yellow########################################"
echo "######  BackUp Script by Mobulos  ######"
echo "########################################"
# echo "ACHTUNG| Alpha Update |ACHTUNG"
echo
echo "Version 2.0.3"
echo "Update 14.12.2019"
echo "$reset"
echo
echo "Auswahlmöglichkeiten"
read -t 0.1
tmp=$(tput setaf 1)
echo "$tmp"
echo "[1] Backup erstellen"
read -t 0.1
tmp=$(tput setaf 2)
echo -n "$tmp"
echo "[2] Backup wiederherstellen"
read -t 0.1
tmp=$(tput setaf 3)
echo -n "$tmp"
echo "[3] Backup löschen"
read -t 0.1
tmp=$(tput setaf 4)
echo -n "$tmp"
echo "[4] Liste der Backups"
read -t 0.1
tmp=$(tput setaf 5)
echo -n "$tmp"

paste files/backup/name files/backup/list >temp
cat -n temp
rm temp

echo "[5] Script Updaten"
read -t 0.1
tmp=$(tput setaf 6)
echo -n "$tmp"
echo "[6] Enstellungen Ändern"
read -t 0.1
tmp=$(tput setaf 7)
echo -n "$tmp"
echo "[7] Exit"
echo "$reset"
read -t 0.1
read -n 1 -p "Was willst du tun?: " befehl
clear
case $befehl in
1)
  jumpto backup
  exit
  ;;
1)
  jumpto restore
  exit
  ;;
3)
  clear
  jumpto delete
  ;;
4)
  clear
  paste files/backup/name files/backup/list >temp
  cat -n temp
  rm temp
  read -n 1
  jumpto menuef
  ;;
5)
  jumpto update
  ;;
6)
  jumpto settings
  ;;
7)
  clear
  exit
  ;;
*)
  echo "Dieser Befehl existiert nicht!"
  read -t 3 -n 1
  jumpto menuef
  exit
  ;;
esac

backup:
clear
echo "Folgende Backups exsistieren: "

paste files/backup/name files/backup/list >temp
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
  mkdir /root/backup
  clear
elif [[ * ]]; then
  echo
fi

clear
if [ -d "$bckto" ]; then
  echo
elif [[ * ]]; then
  echo "Dieser Ordner existiert nicht!"
  for i in . .. ...; do
    echo "Daher wird er nun erstellt $i"
    read -t 1
  done
  mkdir $bckto
  echo
fi

clear
read -p "Gebe ein Namen für das Backup an: " nam
clear
echo "$nam" >>files/backup/name
echo "$bck" >>files/backup/list
echo "$bckto" >>files/backup/to
tar -cpz $bck | (pv -n >$bckto$nam.tgz) 2>&1 | dialog --gauge "Wallie erstellt ein Backup, ich wusste garnicht, dass das möglich ist......" 10 70 0
clear
echo "Das Backup wurde ertsellt."
exit

restore:
clear

clear
read -p "WARNUNG: Das Zielverzeichnis wird überschrieben !!! (Y/N)" warn
case warn in
Y)
  (tar -xzf test.tar.gz -C /) | dialog --gauge "Wallie stell das Backup wiederher, das ist echt unglaublich......" 10 70 0
  clear
  ;;
N)
  echo "Es tut mir leid, doch ich darf das Backup nicht wiederherstellen, wenn Du mich die Daten nicht überschreiben lässt!"
  ;;
esac

delete:
clear
echo "Welche der folgenden Backups möchtest du löschen?"

paste files/backup/name files/backup/list >temp
cat -n temp
rm temp

read -p "Bitte gebe die Zahl von dem Backup ein " delup
del=$(sed -ne "$delup"'p' files/backup/to)
read -p "Der Ordner '$del' wird gelöscht! (Y/N)" delyn
case delyn in
Y | y | J | j)
  rm -r $del
  ;;
*)
  echo "Der Ordner wurde nicht gelöscht, du musst ihn ggf. selber Löschen!"
  ;;
esac
sed -i "$delup D" "files/backup/list"
sed -i "$delup D" "files/backup/name"
sed -i "$delup D" "files/backup/to"
clear
echo "Das Backup wurde gelöscht!"
read -t 3 -n 0
exit

update:
echo "$red Die neuste Version wird heruntergeladen"
echo "$reset"
read -t 2 -n 1
rm 20*
touch $(date +%Y-%m-%d)
rm backupscript.sh
# if [ -f "alpha" ]; then
# curl --progress-bar https://raw.githubusercontent.com/Mobulos/backup/master/backupscript.sh --output backupscript.sh
echo "momentan stellen wir keine Beta zur Verfügung."
echo 'Daher werde ich nun folgende Version herunterladen: "Stable" '
echo
curl --progress-bar https://raw.githubusercontent.com/Mobulos/backup/master/backupscript.sh --output backupscript.sh
read -t 2
# chmod +x backupscript.sh
# ./backupscript.sh
# exit;
# elif [[ * ]]; then
clear
chmod +x backupscript.sh
./backupscript.sh
exit
# fi

settings:
clear
if [ -d "files" ]; then
  dir=$(cd $(dirname 0) && pwd)
  echo "Momentan existierteine Alpha Phase."
  read -p "Möchtest du teil ein Teil des Alpha Rings werden? (Y/N)" version
  case version in
  Y | y | J | j)
    touch .alpha
    read -t 3 "Du Bist nun Teil des Beta Rings."
    jumpto update
    exit
    ;;
  *)
    rm .alpha
    clear
    echo "Ab jetzt bist du kein Alpha Tester (mehr)."
    jumpto update
    exit
    ;;
  esac
elif [[ * ]]; then
  dir=$(cd $(dirname 0) && pwd)
  mkdir -p files/backup
  rm files/dir
  touch files/dir
  echo "$dir" >>files/dir
  clear
  echo "Die einstellungen werden erstellt..."
  read -t 3 -n 1
  jumpto menue
  exit
fi

exit
