#!/bin/bash
sudo apt update && sudo apt upgrade
sudo apt install python3 python3-pip wine winetricks

unzip files.zip

python3 ./install_gui.py

rm install_gui.py
rm gog_bf1_installer.sh
