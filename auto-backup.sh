#!/bin/bash

# A31 Factory Auto Backup Script
# Author: A31 Factory Team
# Description: Automated daily backup with rotation
# Usage: Add to crontab for daily execution
# Crontab example: 0 2 * * * /path/to/auto-backup.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔄 A31 Factory - Auto Backup ($(date))"
echo "======================================="

# Run the backup script
if ./backup-db.sh; then
    echo "✅ Auto backup completed successfully at $(date)"
    
    # Optional: Send notification or log to external system
    # curl -X POST "https://your-monitoring-service.com/backup-success" \
    #      -d "service=a31_factory&status=success&timestamp=$(date -Iseconds)"
    
else
    echo "❌ Auto backup failed at $(date)"
    
    # Optional: Send alert notification
    # curl -X POST "https://your-monitoring-service.com/backup-failed" \
    #      -d "service=a31_factory&status=failed&timestamp=$(date -Iseconds)"
    
    exit 1
fi

echo "🎯 Auto backup process finished at $(date)"
