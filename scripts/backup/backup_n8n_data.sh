#!/bin/bash
set -e
set -x

# Determine repository base directory
BASE_DIR=$(cd "$(dirname "$0")/../../" && pwd)
LOG_DIR="$BASE_DIR/logs"
BACKUP_DIR="$BASE_DIR/backups/n8n_data"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/n8n_data_${DATE}.tar.gz"

# Ensure log and backup directories exist
mkdir -p "$LOG_DIR"
mkdir -p "$BACKUP_DIR"

# Log start message
echo "[$(date)] Starting n8n_data backup. Backup file: $BACKUP_FILE" | tee -a "$LOG_DIR/backup_n8n_data.log"

# Run tar inside the n8n container instead of host
docker exec n8n-docker-caddy-n8n-1 tar -czf - -C /home/node/.n8n . > "$BACKUP_FILE"

# Remove backups older than 7 days
find "$BACKUP_DIR" -type f -mtime +7 -delete

# Log completion message
echo "[$(date)] n8n_data backup completed: $BACKUP_FILE" | tee -a "$LOG_DIR/backup_n8n_data.log"
