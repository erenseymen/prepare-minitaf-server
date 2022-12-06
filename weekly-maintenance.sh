#!/bin/bash

# This script does weekly maintenance on minitaf server
# This script runs automatically by crontab on every Sunday at 00:00.
# Author: Eren Seymen (eren.seymen@orioninc.com)

mkdir -p /root/logs

{

echo "***** Size of the /home folder before maintenance (KB): *****"
BEFORE_SIZE=$(du -s /home | awk '{print $1}')
echo $BEFORE_SIZE

echo "***** Cleanup minitaf's useless logs *****"
rm -rf /home/*/a2-test*/test/*/log
rm -rf /home/*/a2-test*/build/test-results

echo "***** Cleanup old SESM logs *****"
cd /home
./cleanup_minitafs_old_sesm_logs.sh

echo "***** Compressing SESM logs *****"
gzip -r --fast /home/*/a2-test*/build/ServiceTraces/

echo "***** Size of the /home folder after maintenance (KB): *****"
AFTER_SIZE=$(du -s /home | awk '{print $1}')
echo $AFTER_SIZE

echo "***** Disk space saved after maintenance (KB): *****"
expr $BEFORE_SIZE - $AFTER_SIZE

} 2>&1 | tee /root/logs/weekly-maintenance-$(date +"%Y-%m-%d_%H-%M-%S").log
