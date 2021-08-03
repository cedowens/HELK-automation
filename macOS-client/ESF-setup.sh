#!/bin/bash

echo "Downloading and extracting Objective See's ProcessMonitor ESF tool...\n"

curl -L -k https://bitbucket.org/objective-see/deploy/downloads/ProcessMonitor_1.5.0.zip -O

echo "Running ProcessMonitor..."
unzip ProcessMonitor_1.5.0.zip && cd ProcessMonitor.app/Contents/MacOS && xattr -c ProcessMonitor && sudo ./ProcessMonitor > ~/Downloads/filebeat-7.13.4-darwin-x86_64/esf.log



