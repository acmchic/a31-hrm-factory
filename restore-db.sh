#!/bin/bash

# A31 Factory Database Restore Script
# Author: A31 Factory Team
# Description: Restore database from backup file in storage/db/

echo "🔄 A31 Factory - Database Restore Script"
echo "========================================="

# Check if backup file is provided
if [ $# -eq 0 ]; then
    echo "❌ Error: No backup file specified!"
    echo ""
    echo "Usage: $0 <backup_file>"
    echo ""
    echo "Available backups:"
    if ls storage/db/a31_factory_backup_*.sql 1> /dev/null 2>&1; then
        ls -la storage/db/a31_factory_backup_*.sql | awk '{print "   • " $9 " (" $5 " bytes, " $6 " " $7 " " $8 ")"}'
    else
        echo "   No backup files found in storage/db/"
    fi
    echo ""
    echo "Quick restore from latest backup:"
    echo "   $0 latest_backup.sql"
    exit 1
fi

BACKUP_FILE=$1
BACKUP_DIR="storage/db"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"

# Check if backup file exists
if [ ! -f "${BACKUP_PATH}" ]; then
    echo "❌ Error: Backup file not found: ${BACKUP_PATH}"
    echo ""
    echo "Available backups:"
    if ls storage/db/a31_factory_backup_*.sql 1> /dev/null 2>&1; then
        ls -la storage/db/a31_factory_backup_*.sql | awk '{print "   • " $9}'
    else
        echo "   No backup files found in storage/db/"
    fi
    exit 1
fi

# Database connection details
DB_HOST="mysql"
DB_PORT="3306"
DB_DATABASE="a31_factory"
DB_USERNAME="a31_user"
DB_PASSWORD="A31Factory"

echo "📁 Backup file: ${BACKUP_PATH}"
echo "🗄️  Target database: ${DB_DATABASE}"
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

# Warning message
echo "⚠️  WARNING: This will REPLACE the current database!"
echo "   Current database '${DB_DATABASE}' will be dropped and restored from backup."
echo ""
read -p "   Are you sure you want to continue? (yes/no): " CONFIRM

if [ "${CONFIRM}" != "yes" ]; then
    echo "❌ Restore cancelled by user."
    exit 0
fi

echo ""
echo "🚀 Starting restore process..."

# Get backup file size for progress info
BACKUP_SIZE=$(du -h ${BACKUP_PATH} | cut -f1)
echo "📊 Restoring from backup (${BACKUP_SIZE})..."

# Restore database
if docker-compose exec -T mysql mysql \
    -h localhost \
    -u ${DB_USERNAME} \
    -p${DB_PASSWORD} < ${BACKUP_PATH}; then
    
    echo "✅ Database restored successfully!"
    echo ""
    
    # Verify restore by checking tables
    echo "🔍 Verifying restore..."
    TABLE_COUNT=$(docker-compose exec -T mysql mysql -h localhost -u ${DB_USERNAME} -p${DB_PASSWORD} ${DB_DATABASE} -e "SHOW TABLES;" | wc -l)
    
    if [ ${TABLE_COUNT} -gt 1 ]; then
        echo "✅ Verification successful! Found $((TABLE_COUNT-1)) tables in database."
        echo ""
        
        # Clear Laravel caches after restore
        echo "🧹 Clearing Laravel caches..."
        docker-compose exec quanly.a31 php artisan cache:clear > /dev/null 2>&1
        docker-compose exec quanly.a31 php artisan config:clear > /dev/null 2>&1
        docker-compose exec quanly.a31 php artisan route:clear > /dev/null 2>&1
        docker-compose exec quanly.a31 php artisan view:clear > /dev/null 2>&1
        echo "✅ Laravel caches cleared!"
        echo ""
        
        echo "🎉 Database restore completed successfully!"
        echo ""
        echo "📋 Restore Summary:"
        echo "   • Source: ${BACKUP_PATH}"
        echo "   • Size: ${BACKUP_SIZE}"
        echo "   • Database: ${DB_DATABASE}"
        echo "   • Tables: $((TABLE_COUNT-1))"
        echo ""
        echo "💡 You can now access the application with restored data."
        
    else
        echo "⚠️  Warning: Restore completed but database appears empty!"
        echo "   Please check the backup file and try again."
    fi
    
else
    echo "❌ Error: Restore failed!"
    echo "   Please check the error messages above."
    echo "   The database may be in an inconsistent state."
    exit 1
fi

echo ""
echo "✨ Done!"
