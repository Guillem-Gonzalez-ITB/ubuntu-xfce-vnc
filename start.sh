#!/bin/bash

# Arrencar el servidor SSH
sudo service ssh start

# Arrencar X virtual framebuffer (XVFB) i XFCE4
Xvfb :1 -screen 0 1280x800x16 &

export DISPLAY=:1

# Arrencar xfce4 session en background
startxfce4 &

# Arrencar servidor VNC amb x11vnc en mode no interactiu (sense password aquí)
x11vnc -display :1 -forever -nopw -shared &

# Mantenir el container en execució
tail -f /dev/null