#!/bin/bash

VAULT_PATH="$HOME/personal/Workspace"

cd "$VAULT_PATH" || exit

if [[ -n $(git status --porcelain) ]]; then
    git add .
    git commit -m "Auto-update: $(date +'%Y-%m-%d %H:%M')"
    git push origin main
fi
