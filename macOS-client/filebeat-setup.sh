#!/bin/bash

echo "Downloading filebeat 7.14.0 for macOS...\n"

curl -k -L https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.14.0-darwin-x86_64.tar.gz -O

echo "Extracting the filebeat archive file...\n"
tar -xzvf filebeat-7.14.0-darwin-x86_64.tar.gz && cd filebeat-7.14.0-darwin-x86_64 && touch esf.log

echo "Please enter the IP address of your HELK server:"
read hIP

echo "Replacing filebeat.yml with an updated filebeat.yml with your HELK settings...\n"
sed -i -e "s/127.0.0.1/$hIP/g" fb.yml

cp fb.yml filebeat.yml



echo "Running filebeat and pointing it to your updated filebeat.yml file...\n"

./filebeat -e -c filebeat.yml
 

