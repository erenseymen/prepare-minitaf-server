#!/bin/bash

# This script prepares minitaf server
# Author: Eren Seymen (eren.seymen@orioninc.com)

echo "***** Install and remove packages *****"
apt update
echo "***** Install: unzip zip net-tools p7zip-full p7zip-rar tldr git nethogs tcpdump *****"
apt install -y unzip zip net-tools p7zip-full p7zip-rar tldr git nethogs tcpdump
echo "***** Purge: unattended-upgrades snapd apport ufw *****"
apt purge -y unattended-upgrades snapd apport ufw
echo "***** Cleanup packages *****"
apt autoremove --purge -y

echo "***** Clean snap dirs and prevent snap to be reinstalled *****"
rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd ~/snap
printf "Package: snapd\nPin: release a=*\nPin-Priority: -10" >> no-snap.pref
mv no-snap.pref /etc/apt/preferences.d/
chown root:root /etc/apt/preferences.d/no-snap.pref
apt install --reinstall ca-certificates -y

echo "***** Upgrade packages *****"
apt full-upgrade

echo "***** Disable apt automatic update *****"
sed -i 's/APT::Periodic::Update-Package-Lists "1"/APT::Periodic::Update-Package-Lists "0"/' /etc/apt/apt.conf.d/10periodic
sed -i 's/APT::Periodic::Download-Upgradeable-Packages "1"/APT::Periodic::Download-Upgradeable-Packages "0"/' /etc/apt/apt.conf.d/10periodic
sed -i 's/APT::Periodic::AutocleanInterval "1"/APT::Periodic::AutocleanInterval "0"/' /etc/apt/apt.conf.d/10periodic

echo "***** Deploy JRE, Gradle and mcfly *****"
./deploy-jre-gradle-mcfly jre-8u351-linux-x64.tar.gz gradle-4.10.2-bin.zip mcfly

echo "***** Add system level aliases *****"
# Add LINEs if not exist to /etc/profile file
FILE_NAME="/etc/profile"
LINE='alias enable="systemctl enable"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='alias disable="systemctl disable"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='alias start="systemctl start"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='alias stop="systemctl stop"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='alias list="systemctl -a list-units | grep -i"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='alias c="rsync -a --info=progress2"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='alias ubuntu-release="lsb_release -a"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='alias cheat="tldr"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='alias ?="compgen -c | grep"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='eval "$(mcfly init bash)"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME

echo "***** Allow tcpdump for all users *****"
setcap cap_net_raw,cap_net_admin=eip /usr/bin/tcpdump

echo "***** Allow nethogs for all users *****"
setcap "cap_net_admin,cap_net_raw=ep" /usr/sbin/nethogs

read -p "!!! Press enter to REBOOT !!!"

reboot
