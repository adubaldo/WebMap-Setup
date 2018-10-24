#!/bin/bash
# Project: Rev3rseSecurity/WebMap
# Subtitle: A Web Dashbord for Nmap XML Report
# Author: @s3th_0x setup script
# Description: Download, Install and run WebMap-Django-Projectt
 
sudo apt-get update
read -e -p "[?] Set custom installation dir [$WEBMAP_ROOT]:" -i "/opt" WEBMAP_ROOT
echo $WEBMAP_ROOT
 
echo "[+] Check for requirements..."
if ! type "pip3" > /dev/null; then
  echo "pip3 is required. Installing pip3"
  sudo apt-get -y install python3-pip
  python3 get-pip.py --user
  #prably you will face an error with old pip versions, the...
  sudo python3 -m pip uninstall pip && sudo apt install python3-pip --reinstall
  echo "done."
fi
 
if ! type "git" > /dev/null ; then
  echo "git is required. Installing git..."
  sudo apt-get install git
  echo "done."
fi
 
echo "[+] Creating application output dirs..."
sudo mkdir /opt/xml ; mkdir /opt/notes
echo "[+]installing django, pytz and xmltodict..."
pip3 install django ; pip3 install pytz ; pip3 install xmltodict
 
echo "[+] Installing wkhtmltopdf dependencies and binary files..."
cd /opt || return
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
 
echo "[+] Cloning WebMap repo..."
 
cd $WEBMAP_ROOT || return
git clone https://github.com/Rev3rseSecurity/WebMap.git
cd WebMap
git checkout django-project
git submodule update --init
 
mkdir /opt/nmapdashboard
cp $WEBMAP_ROOT/WebMap/db.sqlite3 /opt/nmapdashboard
 
echo "Server started at 127.0.0.1:8000 ..."
cd $WEBMAP_ROOT/WebMap
python3 manage.py runserver
