#!/bin/bash

echo "Downloading and extracting Objective See's ProcessMonitor ESF tool...\n"

curl -L -k https://bitbucket.org/objective-see/deploy/downloads/ProcessMonitor_1.5.0.zip -O

echo "ProcessMonitor has been downloaded. You will need to give it full disk access and then run it as sudo...\n"
pwd

unzip ProcessMonitor_1.5.0.zip && cd ProcessMonitor.app/Contents/MacOS && xattr -c ProcessMonitor

