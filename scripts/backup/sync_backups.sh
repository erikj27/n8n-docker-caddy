#!/bin/bash
set -e
set -x

# Determine repository base directory
BASE_DIR=$(cd "$(dirname "$0")/../../" && pwd)
LOCAL_BACKUP_DIR="$BASE_DIR/backups"
LOG_DIR="$BASE_DIR/logs"
REMOTE_NAME="backupremote"         # Must match the remote name in your rclone config
REMOTE_DIR="n8n-backups"           # The folder/path on the remote storage
RCLONE_CONFIG="$HOME/.config/rclone/rclone.conf"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Sync local backup directory to remote storage and log to the new logs folder
rclone sync "$LOCAL_BACKUP_DIR" "$REMOTE_NAME:$REMOTE_DIR" --config "$RCLONE_CONFIG" --log-file="$LOG_DIR/sync_backups.log"

echo "[$(date)] Offsite backup sync completed." | tee -a "$LOG_DIR/sync_backups.log"
