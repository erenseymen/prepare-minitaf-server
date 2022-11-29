#!/bin/bash

# This script does weekly maintenance on minitaf server
# This script runs automatically by crontab on every Sunday at 00:00.
# Author: Eren Seymen (eren.seymen@orioninc.com)

{

mkdir -p /root/logs


echo "***** Cleanup minitaf's useless logs *****"
rm -rf /home/*/a2-test/test/*/log
rm -rf /home/*/a2-test/build/test-results

echo "***** Cleanup old SESM logs *****"
cd /home
./cleanup_minitafs_old_sesm_logs.sh

echo "***** Compressing SESM logs *****"
gzip -r --fast /home/*/a2-test/build/ServiceTraces/


} 2>&1 | tee /root/logs/weekly-maintenance-$(date +"%Y-%m-%d_%H-%M-%S").log
