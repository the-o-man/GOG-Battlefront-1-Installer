#!/bin/bash
python3 apt_status.py &
process=$!
echo $process
pkexec apt install python3 python3-pip wine winetricks -y && kill -9 $process
