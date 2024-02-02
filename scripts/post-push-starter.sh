#!/usr/bin/env bash
if [ -f "./avmmakefile" ]; then
    echo "This is an AVM repo"
    SCRIPT_FOLDER="avm_scripts"
else
    echo "This is a TFVM repo"
    SCRIPT_FOLDER="scripts"
fi
REMOTE_SCRIPT := "https://raw.githubusercontent.com/Azure/tfmod-scaffold/main/$(SCRIPT_FOLDER)$(AVMSCRIPT_VERSION)"
curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/post-push.sh" | sh -s