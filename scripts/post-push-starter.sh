#!/usr/bin/env bash
REMOTE_SCRIPT="https://raw.githubusercontent.com/Azure/tfmod-scaffold/main/$SCRIPT_FOLDER$AVMSCRIPT_VERSION"
curl -H 'Cache-Control: no-cache, no-store' -sSL "$REMOTE_SCRIPT/post-push.sh" | bash