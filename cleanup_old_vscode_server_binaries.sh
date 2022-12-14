#!/bin/bash

# This script recursively searches for "/home/*/.vscode-server/bin" folders under /home directory. Under the found folders, the script will keep the latest vscode-server binary folder and delete the others.
# Author: Eren Seymen (eren.seymen@orioninc.com)

find "/home" -type d -wholename "/home/*/.vscode-server/bin" | while read -r VSCODE_SERVER_BIN_DIR; do
    echo "Cleaning up $VSCODE_SERVER_BIN_DIR"
    ls -tp "$VSCODE_SERVER_BIN_DIR" 2> /dev/null | grep '/$' | tail -n +2 | xargs -d '\n' -r rm -rf --
done
