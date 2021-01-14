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
