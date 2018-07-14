#!/usr/bin/python3
# Made by The_Human
# dwm status written in python. requires psutil to display CPU usage and RAM usage
import datetime
import time
import subprocess
import psutil
from datetime import datetime

while True:
    ram_usage = "[RAM {}%] ".format(psutil.virtual_memory().percent)
    cpu_usage = "[CPU {}%] ".format(psutil.cpu_percent())
    date = datetime.now().strftime("[%d-%m-%Y] [%H:%M:%S]")   
    status_bar = cpu_usage + ram_usage + str(date)
    # uncomment the following line to start flashfocus at startup. starting using xinitrc doesn't work, unfortunately
#    subprocess.Popen("flashfocus", shell=True)
    subprocess.Popen(["xsetroot", "-name", "".join(status_bar)])
    time.sleep(1.0)
