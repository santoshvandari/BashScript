#!/bin/bash

set -euo pipefail

# Variables and configuration
MONGO_DATA_DIR=${MONGO_DATA_DIR:-"/var/lib/mongodb"}
BACKUP_DIR=${BACKUP_DIR:-"/backups/mongodb"}
MONGO_SERVICE=${MONGO_SERVICE:-"mongod"}
RETENTION_DAYS=${RETENTION_DAYS:-7}
LOG_FILE=${LOG_FILE:-""}
BACKUP_METHOD=${BACKUP_METHOD:-"stop"}


#  Create log directory and redirect output if LOG_FILE is set
if [[ -n "$LOG_FILE" ]]; then
    mkdir -p "$(dirname -- "$LOG_FILE")"
    exec >>"$LOG_FILE" 2>&1
fi

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Generate timestamped archive name
timestamp=$(date +"%F_%H-%M-%S")
archive_name="mongodb_backup_${timestamp}.tar.gz"
archive_path="$BACKUP_DIR/$archive_name"
temp_copy_dir="$BACKUP_DIR/temp_${timestamp}"

# Check mongo data dir and service
if [[ ! -d "$MONGO_DATA_DIR" ]]; then
    echo "ERROR: MongoDB data directory not found: $MONGO_DATA_DIR" >&2
    echo "Set MONGO_DATA_DIR to the correct path." >&2
    exit 1
fi

if ! systemctl list-units --type=service --all | grep -q "^[[:space:]]*${MONGO_SERVICE}.service"; then
    echo "ERROR: MongoDB service '$MONGO_SERVICE' not found." >&2
    echo "Check 'systemctl list-units | grep mongo' and set MONGO_SERVICE." >&2
    exit 1
fi

# Backup execution
echo "[INFO] Starting MongoDB file-level backup: $(date)"
echo "[INFO] Data directory: $MONGO_DATA_DIR"
echo "[INFO] Backup directory: $BACKUP_DIR"
echo "[INFO] Method: $BACKUP_METHOD"

if [[ "$BACKUP_METHOD" == "stop" ]]; then
    # Stop MongoDB for consistent backup
    echo "[INFO] Stopping MongoDB service: $MONGO_SERVICE"
    systemctl stop "$MONGO_SERVICE"
    
    # Ensure it's stopped
    sleep 2
    
    if systemctl is-active --quiet "$MONGO_SERVICE"; then
        echo "ERROR: Failed to stop MongoDB service" >&2
        exit 1
    fi
    
    echo "[INFO] MongoDB stopped. Creating backup archive..."
    
    # Create compressed archive directly from data directory
    tar -czf "$archive_path" -C "$(dirname "$MONGO_DATA_DIR")" "$(basename "$MONGO_DATA_DIR")"
    
    echo "[INFO] Backup archive created: $archive_path"
    echo "[INFO] Starting MongoDB service: $MONGO_SERVICE"
    
    # Restart MongoDB
    systemctl start "$MONGO_SERVICE"
    
    # Wait and verify
    sleep 2
    
    if systemctl is-active --quiet "$MONGO_SERVICE"; then
        echo "[INFO] MongoDB restarted successfully"
    else
        echo "ERROR: MongoDB failed to restart! Check 'systemctl status $MONGO_SERVICE'" >&2
        exit 1
    fi
    
elif [[ "$BACKUP_METHOD" == "snapshot" ]]; then
    echo "[WARN] Snapshot method: copying files while MongoDB is running" >&2
    echo "[WARN] This may create inconsistent backups unless using LVM/ZFS snapshots" >&2
    
    # Copy to temp directory first
    mkdir -p "$temp_copy_dir"
    rsync -a "$MONGO_DATA_DIR/" "$temp_copy_dir/"
    
    echo "[INFO] Creating compressed archive..."
    tar -czf "$archive_path" -C "$BACKUP_DIR" "$(basename "$temp_copy_dir")"
    
    # Cleanup temp
    rm -rf "$temp_copy_dir"
    
    echo "[INFO] Backup archive created: $archive_path"
else
    echo "ERROR: Unknown BACKUP_METHOD: $BACKUP_METHOD (use 'stop' or 'snapshot')" >&2
    exit 1
fi

echo "[INFO] Backup completed successfully: $(date)"


# Cleanup old backups
if [[ "$RETENTION_DAYS" =~ ^[0-9]+$ ]]; then
    echo "[INFO] Deleting backups older than $RETENTION_DAYS days from $BACKUP_DIR"
    find "$BACKUP_DIR" -type f -name 'mongodump_*_*.archive.gz' -mtime +"$RETENTION_DAYS" -print -delete || true
else
    echo "[WARN] RETENTION_DAYS is not numeric; skipping cleanup: $RETENTION_DAYS" >&2
fi

echo "[INFO] Done. File: $archive_path"
