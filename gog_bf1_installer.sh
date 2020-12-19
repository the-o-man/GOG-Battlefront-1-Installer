#!/bin/bash

# Check if GOG folder for wine prefixes exists. Create it if needed
gog_game_folder=~/GOG-Games

if [ -d $gog_game_folder ]; then
    echo "$gog_game_folder is a directory. Will use as base location for install..."
else
    echo "$gog_game_folder does not exist. Creating directory..."
    mkdir $gog_game_folder
fi

# Create a wine prefix to install the game in
wine_prefix_folder=$gog_game_folder/battlefront_1_gog

WINEARCH=win64 WINEPREFIX=$wine_prefix_folder winecfg

# Check to see if the installer .exe is in the download folder

installer=$(find ~/Downloads/ -name setup_star_wars_battlefront*.exe)

if [ -f "$installer" ]; then
    echo "Installer exists."
else
    echo "Installer does not exist."
    exit
fi

echo $installer

# Install in game
WINEARCH=win64 WINEPREFIX=$wine_prefix_folder wine $installer
