#!/usr/bin/python3
# Made by The_Human
# script which spawns st with pacman -Syu if the day is Friday. You can see the log in real time making this script useful
from datetime import datetime
today_date = datetime.now()
import subprocess

#update only if the day is friday
if today_date.weekday() == 4:
    subprocess.Popen("st -e sudo pacman -Syu && read", shell=True) # read to stop the terminal emulator closing itself after the command is executed
else:
    exit()
