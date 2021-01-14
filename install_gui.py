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
        call("./prerecs.sh")
        call("./gog_bf1_installer.sh")
        Gtk.main_quit()

    def on_close_clicked(self, button2):
        Gtk.main_quit()


win = ButtonWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()
