#!/usr/bin/bash
# Took from arch wiki
echo term > /tmp/dwm.fifo
sleep 10
while true; do
    # Log stderror to a file 
    #dwm 2> ~/.dwm.log
    # No error logging
    dwm > /dev/null 2>&1
done
