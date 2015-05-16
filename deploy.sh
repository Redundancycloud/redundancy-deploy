#!/bin/sh

# Redundancy deployment script
# Purpose: Creates a snapshot of the development branch "Lenticularis" and uploads it to "stable"
# so the user can use a stable snapshot and not the development version.
SINCE=$(whiptail --inputbox "Please enter the date for the beginning of the changelog." 8 78 --title "Redundancy deployment" 3>&1 1>&2 2>&3)
if [ $? != 0 ]; then
        echo "Error."
        exit 127
fi

while [ -z $SINCE ]
do
whiptail --msgbox "Please enter a value" 8 78 --title "Redundancy deployment"
SINCE=$(whiptail --inputbox "Please enter the date for the beginning of the changelog" 8 78 --title "Redundancy deployment" 3>&1 1>&2 2>&3)
if [ $? != 0 ]; then
	echo "Error."
	exit 127
fi
done


mkdir dev
mkdir stable
cd ./dev/
git clone https://github.com/Redundancycloud/redundancy.git -b Lenticularis
cd redundancy
git log --pretty=format:"%h (%ad) %s" --since "$SINCE" > ../../CHANGELOG.txt
whiptail --title "Redundancy deployment" --ok-button "OK" --textbox ../../CHANGELOG.txt 0 60
cd ..
cd ..
cd ./stable
git clone https://github.com/Redundancycloud/redundancy.git -b stable
cd ..
cp -R ./dev/redundancy/* -R ./stable/redundancy/
cp ./README.md ./stable/redundancy/
cat ./dev/redundancy/Includes/Kernel/Kernel.Program.class.php | sed 's/Lenticularis/stable/' >  ./stable/redundancy/Includes/Kernel/Kernel.Program.class.php
cp ./CHANGELOG.txt ./stable/redundancy/CHANGELOG.txt
cd ./stable/redundancy
git add * 
now=$(date +"%d.%m.%Y %H:%M")
host=$(hostname)
who=$(whoami)
#remove unwanted files
rm ./tests/ ./test ./webclient/ ./runTests.xml ./test ./composer.json -R
git rm ./tests/ ./test ./webclient/ ./runTests.xml ./test ./composer.json  -r
git commit -m "Snapshot $now by <$who@$host> [r2-Buildbot]"
git push
cd ..
cd ..
rm ./dev ./stable/ CHANGELOG.txt -Rf
