#!/bin/bash
apt update && apt upgrade
apt install python3 python3-tk python3-pip wine winetricks
pip3 install PyQt5 wxPython
