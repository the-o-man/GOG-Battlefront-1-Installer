#!/usr/bin/python
# -*- coding: utf-8 -*-
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
from subprocess import call



class ourwindow(Gtk.Window):

    def __init__(self):
        Gtk.Window.__init__(self, title="BattleFront I Installer")
        Gtk.Window.set_default_size(self, 200, 200)
        Gtk.Window.set_position(self, Gtk.WindowPosition.CENTER)

        button1 = Gtk.Button("Continue")
        button1.connect("clicked", self.whenbutton1_clicked)
        self.add(button1)

    def whenbutton1_clicked(self, button):
        call("./gog_bf1_installer.sh")
        Gtk.main_quit()


window = ourwindow()
window.connect("delete-event", Gtk.main_quit)
window.show_all()
Gtk.main()


