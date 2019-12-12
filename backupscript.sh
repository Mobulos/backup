#!/bin/bash
# Init

# MIT License
#
# Copyright (c) 2019 Mobulos
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.



function jumpto {
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


FILE="/tmp/out.$$"
GREP="/bin/grep"
if [ "$(id -u)" != "0" ]; then
   echo "Das Script muss als root gestartet werden." 1>&2
   exit 1;
fi





# farbcodes:
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`
  #menü
  1m="tput setaf 18"




clear
if [ -d "file" ]; then
    jumpto $menue;
elif [[ * ]]; then
    continue;
fi


  apt update && apt upgrade -y && apt install curl -y && apt install git -y && apt install nano -y && apt install zip -y && apt install unzip -y && apt install tar -y && apt upgrade -y
  jumpto $settings

menue:
  read -t 0.3
  if [ -f `date +%Y-%m-%d` ]; then
    jumpto menuef;
  elif [[ * ]]; then
    jumpto $update;
  fi

  menuef:
  clear
  echo "$yellow########################################"
  echo "######  BackUp Script by Mobulos  ######"
  echo "########################################"
  # echo "ACHTUNG| Alpha Update |ACHTUNG"
  echo "$reset"
  echo
  echo 
  echo
  echo "Auswahlmöglichkeiten"
  read -t 0.2
  echo "[1] Backup starten"
  read -t 0.2
  echo "$red"
  echo "[2] ~Backup löschen~"
  echo "$reset"
  read -t 0.2
  echo "[3] Script Updaten"
  read -t 0.2
  echo "[4] Enstellungen Ändern"
  read -t 0.2
  echo "[5] Exit"
  echo "$reset"
  read -t 0.2
  read -n 1 -p "Was willst du tun?: " befehl
  clear
  case $befehl in
    1)
    jumpto backup
    exit
    ;;
    2)
    echo "Ich komme später dazu!"
    read -t 3 -n 1
    jumpto menuef
    ;;
    3)
    jumpto update
    ;;
    5)
    echo
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
  echo
  bck=""
  bckto=""
  nam=""
  read -e -p "Von welchem Ordner soll ein Backup erstellt werden? " bck

  if [ -d "$bck" ]; then
    echo;
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
    mkdir /root/backup;
  elif [[ * ]]; then
    echo;
  fi

  if [ -d "$bckto" ]; then
    echo;
  elif [[ * ]]; then
    echo "Dieser Ordner existiert nicht!"
    jumpto backup
  fi

  clear
  read -p "Gebe ein Namen für das Backup an: " nam
  clear
  tar -czf - $bck | (pv -n > $bckto$nam.tgz) 2>&1 | dialog --gauge "Wallie erstellt ein Backup, ich wusste garnicht, dass das möglich ist......" 10 70 0
  clear
  echo "Das Backup wurde ertsellt."
  echo
  echo "Bitte beachte, dass du das Backup bissher nur mit diesem Befehl löschen kannst: 'rm $bckto$nam.tgz' "

  exit







update:
  echo "$red Die neuste Version wird heruntergeladen"
  echo "$reset"
  read -t 2 -n 1
  rm 20*
  touch `date +%Y-%m-%d`
  rm backupscript.sh
  if [ -f "alpha" ]; then
  # curl --progress-bar https://raw.githubusercontent.com/Mobulos/backup/master/backupscript.sh --output backupscript.sh
  echo momentan stellen wir keine Beta zur Verfügung.
  echo Daher werde ich dir nun folgende Version herunterladen: "Stable"
  read -t 2
  chmod +x backupscript.sh
  ./backupscript.sh
  exit;
  elif [[ * ]]; then
  curl --progress-bar https://raw.githubusercontent.com/Mobulos/backup/master/backupscript.sh --output backupscript.sh
  chmod +x backupscript.sh
  ./backupscript.sh
  exit;
  fi


settings:
  clear
  if [ -d "files" ]; then
    dir=$(cd `dirname 0` && pwd)
    echo "Die Einstellungen können bisher noch nicht geändert werden"
    read -t 3 -n 1
    jumpto menue
    exit;
  elif [[ * ]]; then
    dir=$(cd `dirname 0` && pwd)
    mkdir -p files/{backupfrom,backupto}
    touch files/dir
    echo "$dir" >> files/dir
    clear
    echo "Die einstellungen werden erstellt..."
    read -t 3 -n 1
    jumpto menue
    exit;
  fi






exit
