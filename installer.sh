#!/bin/bash
unzip ./installation_files.zip

python3 ./install_gui.py

rm gog_bf1_installer.sh install_gui.py prerecs.sh wine_status.py apt_status.py

update-desktop-database
