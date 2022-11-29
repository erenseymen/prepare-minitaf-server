#!/bin/bash

# This script does weekly maintenance on minitaf server
# This script runs automatically by crontab on every Sunday at 00:00.
# Author: Eren Seymen (eren.seymen@orioninc.com)

touch /home/test-$(date +"%Y-%m-%d_%H-%M-%S").log
