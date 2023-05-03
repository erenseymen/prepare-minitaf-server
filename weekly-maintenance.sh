#!/bin/bash

# This script does weekly maintenance on minitaf server
# This script runs automatically by crontab on every Sunday at 00:00.
# Author: Eren Seymen (eren.seymen@orioninc.com)

mkdir -p /root/logs

{

echo "***** Size of the disk before maintenance: *****"
df -h | grep "/$"

echo "***** Size of the /home folder before maintenance (KB): *****"
BEFORE_SIZE_home=$(du -s /home | awk '{print $1}')
echo $BEFORE_SIZE_home

echo "***** Size of the /var/lib/Jenkins/workspace folder before maintenance (KB): *****"
BEFORE_SIZE_Jenkins=$(du -s /var/lib/Jenkins/workspace | awk '{print $1}')
echo $BEFORE_SIZE_Jenkins

echo "***** Size of the /var/lib/jenkins/workspace folder before maintenance (KB): *****"
BEFORE_SIZE_jenkins=$(du -s /var/lib/jenkins/workspace | awk '{print $1}')
echo $BEFORE_SIZE_jenkins

echo "***** Cleanup old VSCode Server binaries *****"
cp /root/prepare-minitaf-server/cleanup_old_vscode_server_binaries.sh /home/
cd /home
./cleanup_old_vscode_server_binaries.sh
rm -rf /home/cleanup_old_vscode_server_binaries.sh

echo "***** Cleanup minitaf's useless logs *****"
rm -rf /home/*/a2-test*/test/*/log
rm -rf /home/*/a2-test*/build/test-results

echo "***** Cleanup old SESM logs *****"
cp /root/prepare-minitaf-server/cleanup_minitafs_old_sesm_logs.sh /home/
cd /home
./cleanup_minitafs_old_sesm_logs.sh
rm -rf /home/cleanup_minitafs_old_sesm_logs.sh

echo "***** Cleanup old SESM logs (Jenkins folder) *****"
cp /root/prepare-minitaf-server/cleanup_minitafs_old_sesm_logs.sh /var/lib/Jenkins/workspace/
cd /var/lib/Jenkins/workspace
./cleanup_minitafs_old_sesm_logs.sh
rm -rf /var/lib/Jenkins/workspace/cleanup_minitafs_old_sesm_logs.sh

echo "***** Cleanup old SESM logs (jenkins folder) *****"
cp /root/prepare-minitaf-server/cleanup_minitafs_old_sesm_logs.sh /var/lib/jenkins/workspace/
cd /var/lib/jenkins/workspace
./cleanup_minitafs_old_sesm_logs.sh
rm -rf /var/lib/jenkins/workspace/cleanup_minitafs_old_sesm_logs.sh

echo "***** Size of the /home folder after maintenance (KB): *****"
AFTER_SIZE_home=$(du -s /home | awk '{print $1}')
echo $AFTER_SIZE_home

echo "***** Size of the /var/lib/Jenkins/workspace folder after maintenance (KB): *****"
AFTER_SIZE_Jenkins=$(du -s /var/lib/Jenkins/workspace | awk '{print $1}')
echo $AFTER_SIZE_Jenkins

echo "***** Size of the /var/lib/jenkins/workspace folder after maintenance (KB): *****"
AFTER_SIZE_jenkins=$(du -s /var/lib/jenkins/workspace | awk '{print $1}')
echo $AFTER_SIZE_jenkins

echo "***** Disk space saved after maintenance (KB) in /home folder: *****"
expr $BEFORE_SIZE_home - $AFTER_SIZE_home

echo "***** Disk space saved after maintenance (KB) in /var/lib/Jenkins/workspace folder: *****"
expr $BEFORE_SIZE_Jenkins - $AFTER_SIZE_Jenkins

echo "***** Disk space saved after maintenance (KB) in /var/lib/jenkins/workspace folder: *****"
expr $BEFORE_SIZE_jenkins - $AFTER_SIZE_jenkins

echo "***** Size of the disk after maintenance: *****"
df -h | grep "/$"

} 2>&1 | tee /root/logs/weekly-maintenance-$(date +"%Y-%m-%d_%H-%M-%S").log
