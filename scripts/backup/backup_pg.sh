#!/bin/bash
set -e
set -x

# Determine repository base directory
BASE_DIR=$(cd "$(dirname "$0")/../../" && pwd)
LOG_DIR="$BASE_DIR/logs"
BACKUP_DIR="$BASE_DIR/backups/pg"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/n8n_${DATE}.sql"

# Ensure log and backup directories exist
mkdir -p "$LOG_DIR"
mkdir -p "$BACKUP_DIR"

# Log start message
echo "[$(date)] Starting PostgreSQL backup. Backup file: $BACKUP_FILE" | tee -a "$LOG_DIR/backup_pg.log"

# Run pg_dump inside the PostgreSQL container without sudo
docker exec -t "n8n-docker-caddy-postgres-1" pg_dump -U "n8nuser" "n8n" > "$BACKUP_FILE"

RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    echo "[$(date)] Error: pg_dump command failed with exit code $RETVAL" | tee -a "$LOG_DIR/backup_pg.log"
    exit 1
fi

# Remove backups older than 7 days
find "$BACKUP_DIR" -type f -mtime +7 -delete

echo "[$(date)] PostgreSQL backup completed: $BACKUP_FILE" | tee -a "$LOG_DIR/backup_pg.log"
