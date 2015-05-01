#!/bin/sh

# Redundancy deployment script
# Purpose: Creates a snapshot of the development branch "Lenticularis" and uploads it to "stable"
# so the user can use a stable snapshot and not the development version.

mkdir dev
mkdir stable
cd ./dev/
git clone https://github.com/Redundancycloud/redundancy.git -b Lenticularis
cd redundancy
cd ..
cd ..
cd ./stable
git clone https://github.com/Redundancycloud/redundancy.git -b stable
cd ..
cp -R ./dev/redundancy/* -R ./stable/redundancy/
cp ./README.md ./stable/redundancy/
less ./stable/redundancy/Includes/Kernel/Kernel.Program.class.php | sed 's/Lenticularis/stable/' >  ./stable/redundancy/Includes/Kernel/Kernel.Program.class.php
cd ./stable/redundancy
git add *
now=$(date +"%m.%d.%Y %H:%M")
host=$(hostname)
who=$(whoami)
git commit -m "Snapshot $now by <$who@$host> [r2-Buildbot]"
git push
cd ..
cd ..
rm ./dev ./stable/ -Rf                                                                                                                         1 ↵

