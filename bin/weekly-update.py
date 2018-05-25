from datetime import datetime
today_date = datetime.now()
import subprocess

#update only if the day is friday
if today_date.weekday() == 4:
    subprocess.Popen(["st","sh", "/home/the_human/bin/update.sh"])
else:
    exit()
