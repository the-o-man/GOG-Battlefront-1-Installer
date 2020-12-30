#!/bin/bash
sudo apt update && sudo apt upgrade
sudo apt install python3 python3-pip wine winetricks

python3 ./install_gui.py

update-desktop-database
