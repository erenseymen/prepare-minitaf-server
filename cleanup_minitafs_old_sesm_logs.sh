#!/bin/bash

# This script recursively searches for "a2-test*/build/ServiceTraces" folders under the current directory. Under the found folders, the script will keep 10 newest SUCCESS and 10 newest FAILED logs for each TC and delete the others.
# Author: Eren Seymen (eren.seymen@orioninc.com)

find "$(pwd)" -type d -wholename "*/a2-test*/build/ServiceTraces" | while read -r SERVICETRACES_DIR; do
    echo "Cleaning up $SERVICETRACES_DIR"
    ls -d "$SERVICETRACES_DIR"/*/*/ | while read -r TESTCASE_DIR; do
        ls -tp "$TESTCASE_DIR"SUCCESS_* 2> /dev/null | grep -v '/$' | tail -n +11 | xargs -d '\n' -r rm --
        ls -tp "$TESTCASE_DIR"FAILED_* 2> /dev/null | grep -v '/$' | tail -n +11 | xargs -d '\n' -r rm --
    done
done
