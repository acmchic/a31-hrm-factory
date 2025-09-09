#!/bin/bash

# A31 Factory Database Backup Script
# Author: A31 Factory Team
# Description: Export database backup to storage/db/ folder

echo "🔄 A31 Factory - Database Backup Script"
echo "======================================="

# Get current date and time for filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="storage/db"
BACKUP_FILE="a31_factory_backup_${TIMESTAMP}.sql"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"

# Create backup directory if it doesn't exist
mkdir -p ${BACKUP_DIR}

# Database connection details from .env
DB_HOST="mysql"
DB_PORT="3306"
DB_DATABASE="a31_factory"
DB_USERNAME="a31_user"
DB_PASSWORD="A31Factory"

echo "📅 Backup timestamp: ${TIMESTAMP}"
echo "📂 Backup location: ${BACKUP_PATH}"
echo ""

# Check if Docker is running
if ! docker-compose ps | grep -q "mysql.*Up"; then
    echo "❌ Error: MySQL container is not running!"
    echo "   Please start the containers first: docker-compose up -d"
    exit 1
fi

echo "🔍 Checking database connection..."

# Test database connection
if ! docker-compose exec -T mysql mysql -h localhost -u ${DB_USERNAME} -p${DB_PASSWORD} -e "SELECT 1;" > /dev/null 2>&1; then
    echo "❌ Error: Cannot connect to database!"
    echo "   Please check database credentials and container status."
    exit 1
fi

echo "✅ Database connection successful!"
echo ""
echo "🚀 Starting backup process..."

# Create database backup
if docker-compose exec -T mysql mysqldump \
    -h localhost \
    -u ${DB_USERNAME} \
    -p${DB_PASSWORD} \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    --add-drop-database \
    --databases ${DB_DATABASE} > ${BACKUP_PATH}; then
    
    # Get backup file size
    BACKUP_SIZE=$(du -h ${BACKUP_PATH} | cut -f1)
    
    echo "✅ Backup completed successfully!"
    echo "📊 Backup file size: ${BACKUP_SIZE}"
    echo "📁 Backup saved to: ${BACKUP_PATH}"
    echo ""
    
    # Keep only last 10 backups to save space
    echo "🧹 Cleaning up old backups (keeping last 10)..."
    cd ${BACKUP_DIR}
    ls -t a31_factory_backup_*.sql | tail -n +11 | xargs -r rm
    
    REMAINING_COUNT=$(ls -1 a31_factory_backup_*.sql 2>/dev/null | wc -l)
    echo "📦 Total backups kept: ${REMAINING_COUNT}"
    echo ""
    
    # Create latest symlink for easy access
    ln -sf ${BACKUP_FILE} latest_backup.sql
    echo "🔗 Created symlink: storage/db/latest_backup.sql -> ${BACKUP_FILE}"
    echo ""
    
    echo "🎉 Backup process completed successfully!"
    echo "💡 To restore this backup, run: ./restore-db.sh ${BACKUP_FILE}"
    
else
    echo "❌ Error: Backup failed!"
    echo "   Please check the error messages above."
    exit 1
fi

echo ""
echo "📋 Backup Summary:"
echo "   • File: ${BACKUP_PATH}"
echo "   • Size: ${BACKUP_SIZE}"
echo "   • Database: ${DB_DATABASE}"
echo "   • Timestamp: ${TIMESTAMP}"
echo ""
echo "✨ Done!"
