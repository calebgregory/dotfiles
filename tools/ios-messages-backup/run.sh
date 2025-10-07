#!/bin/bash

folder="$1"
if [ -z "${folder}" ]; then
  echo "must provide folder name"
  exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR/.secret"

imessage-exporter \
    --format html \
    --db-path "$DEVICE_BACKUP_ROOT" \
    --export-path "$HOME/Documents/iphone-message-backups/$1/export-html" \
    --copy-method full

imessage-exporter \
    --format txt \
    --db-path "$DEVICE_BACKUP_ROOT" \
    --export-path "$HOME/Documents/iphone-message-backups/$1/export-txt" \
