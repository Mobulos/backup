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
install=${2:-"install"}
update=${3:-"update"}
menuef=${4:-"menuef"}
alpha=${5:-"alpha"}
settings={6:-"settings"}

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
if [ -d ".files" ]; then
    jumpto menue;
fi


install:
  apt update
  apt upgrade -y
  apt install wget -y && apt install curl -y && apt install git -y && apt install nano -y && apt install zip -y && apt install unzip -y
  jumpto settings

menue:
  read -t 0.3
  if [ -f `debug` ]; then
    jumpto menuef;
  elif [[ -f `date +%Y-%m-%d` ]]; then
    jumpto menuef;
  elif [[ * ]]; then
    jumpto update;
  fi

  menuef:
  clear
  echo "$yellow########################################"
  echo "######  BackUp Script by Mobulos  ######"
  echo "########################################"
  # exho "ACHTUNG| Alpha Update |ACHTUNG"
  echo "$reset"
  echo
  echo
  read -t 0.2
  echo "Auswahlmöglichkeiten"
  read -t 0.2
  echo "[1] Backup starten"
  read -t 0.2
  echo "[2] Backup löschen"
  read -t 0.2
  echo "[3] Script Updaten"
  read -t 0.2
  echo "[4] Enstellungen Ändern"
  read -t 0.2
  echo "[5] Exit"
  echo "$reset"
  # echo "[] "
  # read -t 0.2
  read -n 1 -p "Was willst du tun?: " befehl
  clear
  case $befehl in
    1)
    jumpto start
    echo "Ich ich funktioniere noch nicht..."
    read -t 3 -n 1
    jumpto menuef
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


update:
  load="#"
  echo "$red Die neuste Version wird heruntergeladen"
  echo "$reset"
  read -t 2 -n 1
  rm 20*
  touch `date +%Y-%m-%d`
  rm backupscript.sh
  if [ -f "alpha" ]; then
wget -N "https://raw.githubusercontent.com/Mobulos/backup/Alpha/backupscript.sh"
  chmod +x backupscript.sh
  ./backupscript.sh
  exit;
  elif [[ * ]]; then
wget -N "https://raw.githubusercontent.com/Mobulos/backup/master/backupscript.sh"
  chmod +x backupscript.sh
  ./backupscript.sh
  exit;
  fi


settings:
    clear
    dir=$(cd `dirname $0` && pwd)
    mkdir -p .files
    touch .files/settings


    find -name '.files/settings'  > liste
    number=`grep -c ".mp3" liste`
    x=1
    while [ $x -le $number ]
        do
          echo $x
          datei=`sed -ne "$x p" liste`
          echo -n "Kommentar zu $datei "
          read kommentar
          echo ""
          echo "$dateicat ist $kommentar"
          x=`expr $x + 1`
        done




    clear
  if [ -f `.files/dir/$dir` ]; then
    exit;
  elif [[ * ]]; then
    touch ".files/dir/$dir"
    read -t 3 -n 1
    echo "Die Einstellungen können bisher noch nicht geändert werden"
    jumpto menue
    echo "Die einstellungen werden erstellt..."
    mkdir settings
    exit;
  fi






exit
