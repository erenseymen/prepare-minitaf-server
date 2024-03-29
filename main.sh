#!/bin/bash

# This script prepares minitaf server
# Run this as root ./main.sh
# Author: Eren Seymen (eren.seymen@orioninc.com)

echo "***** Set timezone (Turkey) *****"
timedatectl set-timezone Turkey

echo "***** Install and remove packages *****"
apt update
echo "***** Install: unzip zip net-tools p7zip-full p7zip-rar tldr git nethogs tcpdump expect gdu snmp nala moreutils neofetch trash-cli thefuck mosh ncat maven *****"
apt install -y unzip zip net-tools p7zip-full p7zip-rar tldr git nethogs tcpdump expect gdu snmp nala moreutils neofetch trash-cli thefuck mosh ncat maven
echo "***** Purge: unattended-upgrades snapd apport ufw *****"
apt purge -y unattended-upgrades snapd apport ufw
echo "***** Cleanup packages *****"
apt autoremove --purge

echo "***** Clean snap dirs and prevent snap to be reinstalled *****"
rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd ~/snap
printf "Package: snapd\nPin: release a=*\nPin-Priority: -10" >> no-snap.pref
mv no-snap.pref /etc/apt/preferences.d/
chown root:root /etc/apt/preferences.d/no-snap.pref
apt install --reinstall ca-certificates -y

echo "***** Install Google Chrome (for Selenium) *****"
wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y /tmp/google-chrome-stable_current_amd64.deb
apt --fix-broken install -y

echo "***** Install chromedriver (for Selenium) *****"
CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
echo "Chrome version is $CHROME_VERSION"
wget -O /tmp/chromedriver-linux64.zip https://storage.googleapis.com/chrome-for-testing-public/$CHROME_VERSION/linux64/chromedriver-linux64.zip
unzip -o /tmp/chromedriver-linux64.zip -d /tmp/
mkdir -p /usr/local/bin
mv /tmp/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver

echo "***** Upgrade packages and clean *****"
apt full-upgrade
apt autoremove --purge
apt clean

echo "***** Disable apt automatic update *****"
sed -i 's/APT::Periodic::Update-Package-Lists "1"/APT::Periodic::Update-Package-Lists "0"/' /etc/apt/apt.conf.d/10periodic
sed -i 's/APT::Periodic::Download-Upgradeable-Packages "1"/APT::Periodic::Download-Upgradeable-Packages "0"/' /etc/apt/apt.conf.d/10periodic
sed -i 's/APT::Periodic::AutocleanInterval "1"/APT::Periodic::AutocleanInterval "0"/' /etc/apt/apt.conf.d/10periodic

echo "***** Deploy JDK and Gradle *****"
./deploy-jdk-gradle

echo "***** Add system level aliases *****"
# Add LINEs if not exist to /etc/profile file
FILE_NAME="/etc/profile"
LINE='alias c="rsync -a --info=progress2"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='alias ubuntu-release="lsb_release -a"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='alias ?="compgen -c | grep"'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME
LINE='eval $(thefuck --alias)'
grep -qxF "$LINE" $FILE_NAME || echo "$LINE" >> $FILE_NAME

echo "***** Allow tcpdump for all users *****"
setcap cap_net_raw,cap_net_admin=eip /usr/bin/tcpdump

echo "***** Allow nethogs for all users *****"
setcap "cap_net_admin,cap_net_raw=ep" /usr/sbin/nethogs

echo "***** Disable ssh login banner *****"
sed -i 's/^session    optional     pam_motd\.so  motd=\/run\/motd\.dynamic/# session    optional     pam_motd\.so  motd=\/run\/motd\.dynamic/' /etc/pam.d/sshd
sed -i 's/^session    optional     pam_motd\.so noupdate/# session    optional     pam_motd\.so noupdate/' /etc/pam.d/sshd

echo "***** Add mtaf user *****"
adduser mtaf

echo "***** Add jenkins user *****"
adduser jenkins

echo "***** crontab setup *****"
crontab crontab

echo "***** Remove cache etc. for root user *****"
rm -rf /root/.gradle
rm -rf /root/.cache

