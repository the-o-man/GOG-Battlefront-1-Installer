#!/bin/bash

# Create and call the initial setup box.
cat > .install_gui.py << EOF
import gi
from subprocess import call

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk


class ButtonWindow(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="Dendron PopOS Game Installer")
        Gtk.Window.set_default_size(self, 400, 200)
        Gtk.Window.set_position(self, Gtk.WindowPosition.CENTER)

        main_box = Gtk.VBox()
        box1 = Gtk.VBox()
        text1 = Gtk.Label("Welcome to the Dendron Systems game installer for BattleFront I.")
        text2 = Gtk.Label("This installer requires that a valid copy of the GOG")
        text3 = Gtk.Label("version of BattleFront I is in your Downloads folder.")
        text4 = Gtk.Label("If a .exe is not found, the installer will fail.")

        box1.pack_start(text1, expand = True, fill = True, padding = 10)
        box1.pack_start(text2, expand = True, fill = True, padding = 10)
        box1.pack_start(text3, expand = True, fill = True, padding = 10)
        box1.pack_start(text4, expand = True, fill = True, padding = 10)

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
        sys.exit(20)


win = ButtonWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()

EOF

python3 .install_gui.py

if [ \$? -eq 40 ];
then
  # Create a status GUI for the prerecs installation
  cat > .apt_status.py << EOF
  import gi

  gi.require_version("Gtk", "3.0")
  from gi.repository import Gtk, GLib


  class ProgressBarWindow(Gtk.Window):
      def __init__(self):
          Gtk.Window.__init__(self, title="BattleFront I Installer")
          Gtk.Window.set_position(self, Gtk.WindowPosition.CENTER)
          Gtk.Window.set_default_size(self, 300, 50)
          self.set_border_width(10)

          vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
          text1 = Gtk.Label("Installing needed linux packages")
          vbox.pack_start(text1, expand = True, fill = True, padding = 10)
          self.add(vbox)

          self.progressbar = Gtk.ProgressBar()
          vbox.pack_start(self.progressbar, True, True, 0)

          self.timeout_id = GLib.timeout_add(50, self.on_timeout, None)
          self.activity_mode = True

          if self.activity_mode:
              self.progressbar.pulse()

      def on_timeout(self, user_data):
          """
          Update value on the progress bar
          """
          if self.activity_mode:
              self.progressbar.pulse()
          else:
              new_value = self.progressbar.get_fraction() + 0.01

              if new_value > 1:
                  new_value = 0

              self.progressbar.set_fraction(new_value)

          # As this is a timeout function, return True so that it
          # continues to get called
          return True


  win = ProgressBarWindow()
  win.connect("destroy", Gtk.main_quit)
  win.show_all()
  Gtk.main()
EOF

# Check to make sure that the presrecs are installed
python3 .apt_status.py &
process=$!
echo $process
pkexec apt install python3 python3-pip wine winetricks -y && kill -9 $process

# Create a status GUI for the Wine install
cat > .wine_status.py << EOF
import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib


class ProgressBarWindow(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="BattleFront I Installer")
        Gtk.Window.set_position(self, Gtk.WindowPosition.CENTER)
        Gtk.Window.set_default_size(self, 300, 50)
        self.set_border_width(10)

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        text1 = Gtk.Label("Configuring compatibility layer")
        vbox.pack_start(text1, expand = True, fill = True, padding = 10)
        self.add(vbox)

        self.progressbar = Gtk.ProgressBar()
        vbox.pack_start(self.progressbar, True, True, 0)

        self.timeout_id = GLib.timeout_add(50, self.on_timeout, None)
        self.activity_mode = True

        if self.activity_mode:
            self.progressbar.pulse()

    def on_timeout(self, user_data):
        """
        Update value on the progress bar
        """
        if self.activity_mode:
            self.progressbar.pulse()
        else:
            new_value = self.progressbar.get_fraction() + 0.01

            if new_value > 1:
                new_value = 0

            self.progressbar.set_fraction(new_value)

        # As this is a timeout function, return True so that it
        # continues to get called
        return True


win = ProgressBarWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()

EOF

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
update-desktop-database

else
  exit
fi
