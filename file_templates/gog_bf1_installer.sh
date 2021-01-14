#!/bin/bash

# Check if GOG folder for wine prefixes exists. Create it if needed
gog_game_folder=~/GOG-Games

if [ -d $gog_game_folder ]; then
    echo "$gog_game_folder is a directory. Will use as base location for install..."
else
    echo "$gog_game_folder does not exist. Creating directory..."
    mkdir $gog_game_folder
fi

# Check to see if the installer .exe is in the download folder
installer=$(find ~/Downloads/ -name setup_star_wars_battlefront_1*.exe)

if [ -f "$installer" ]; then
    echo "Installer exists."
else
    echo "Installer does not exist."
    exit
fi

echo $installer

# Check for uninstaller location, create if necessary
gog_game_uninstaller_location=$gog_game_folder/Uninstallers
if [ -d $gog_game_uninstaller_location ]; then
    echo "$gog_game_uninstaller_location is a directory. Will use as base location for uninstallers..."
else
    echo "$gog_game_uninstaller_location does not exist. Creating directory..."
    mkdir $gog_game_uninstaller_location
fi

python3 wine_status.py &
pid=$!
echo $pid
# Create a wine prefix to install the game in
wine_prefix_folder=$gog_game_folder/Battlefront-I

WINEARCH=win64 WINEPREFIX=$wine_prefix_folder wineboot

# Create Uninstaller Shortcut
cat > $gog_game_uninstaller_location/Battlefront-I-Uninstaller.sh<< EOF
#!/bin/bash

python3 $wine_prefix_folder/Battlefront-I-Uninstaller.py

if [ \$? -eq 40 ];
then
  prefix_to_remove=$wine_prefix_folder
  rm -r \$prefix_to_remove
  rm -r ~/.local/share/applications/wine/Programs/GOG.com/STAR\ WARS\ Battlefront
  update-desktop-database
  rm -- "\$0"
fi

EOF

chmod +x $gog_game_uninstaller_location/Battlefront-I-Uninstaller.sh

# Create uninstaller GUI in the prefix
cat > $wine_prefix_folder/Battlefront-I-Uninstaller.py<< EOF
import sys
import gi
from subprocess import call

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk


class ButtonWindow(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="Dendron PopOS Game Un-Installer")
        Gtk.Window.set_default_size(self, 400, 200)
        Gtk.Window.set_position(self, Gtk.WindowPosition.CENTER)

        main_box = Gtk.VBox()
        box1 = Gtk.VBox()
        text1 = Gtk.Label("Battlefront I is about to be removed from your computer. Do you wish to continue?")

        box1.pack_start(text1, expand = True, fill = True, padding = 10)

        button1 = Gtk.Button(stock = Gtk.STOCK_OK)
        button1.connect("clicked", self.on_open_clicked)

        button2 = Gtk.Button(stock = Gtk.STOCK_CANCEL)
        button2.connect("clicked", self.on_close_clicked)

        box1.pack_start(button1, expand = True, fill = True, padding = 10)
        box1.pack_start(button2, expand = True, fill = True, padding = 10)
        box1.set_border_width(30)

        main_box.add(box1)
        self.add(main_box)

    def on_open_clicked(self, button1):
        sys.exit(40)

    def on_close_clicked(self, button2):
        sys.exit(10)


win = ButtonWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()

EOF

kill -9 $pid

# Install in game
WINEARCH=win64 WINEPREFIX=$wine_prefix_folder wine $installer

# Remove uninstall desktop applications
rm ~/.local/share/applications/wine/Programs/GOG.com/STAR\ WARS\ Battlefront/Uninstall\ STAR\ WARS\ Battlefront.desktop
