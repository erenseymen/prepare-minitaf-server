#!/bin/bash

# This script recursively searches for "*/.vscode-server/bin" folders under the current directory. Under the found folders, the script will keep the latest vscode-server binary folder and delete the others.
# Author: Eren Seymen (eren.seymen@orioninc.com)

find "$(pwd)" -type d -wholename "*/.vscode-server/bin" | while read -r VSCODE_SERVER_BIN_DIR; do
    echo "Cleaning up $VSCODE_SERVER_BIN_DIR"
    cd "$VSCODE_SERVER_BIN_DIR"
    ls -tp 2> /dev/null | grep '/$' | tail -n +2 | xargs -d '\n' -r rm -r --
done
