@echo off
REM A31 Factory Database Restore Script for Windows
REM Author: A31 Factory Team
REM Description: Restore database from backup file in storage\db\

echo 🔄 A31 Factory - Database Restore Script
echo ========================================

REM Check if backup file is provided
if "%~1"=="" (
    echo ❌ Error: No backup file specified!
    echo.
    echo Usage: %0 ^<backup_file^>
    echo.
    echo Available backups:
    if exist "storage\db\a31_factory_backup_*.sql" (
        dir /b "storage\db\a31_factory_backup_*.sql"
    ) else (
        echo    No backup files found in storage\db\
    )
    echo.
    echo Quick restore from latest backup:
    echo    %0 latest_backup.sql
    pause
    exit /b 1
)

set "BACKUP_FILE=%~1"
set "BACKUP_DIR=storage\db"
set "BACKUP_PATH=%BACKUP_DIR%\%BACKUP_FILE%"

REM Check if backup file exists
if not exist "%BACKUP_PATH%" (
    echo ❌ Error: Backup file not found: %BACKUP_PATH%
    echo.
    echo Available backups:
    if exist "storage\db\a31_factory_backup_*.sql" (
        dir /b "storage\db\a31_factory_backup_*.sql"
    ) else (
        echo    No backup files found in storage\db\
    )
    pause
    exit /b 1
)

REM Database connection details
set "DB_HOST=mysql"
set "DB_PORT=3306"
set "DB_DATABASE=a31_factory"
set "DB_USERNAME=a31_user"
set "DB_PASSWORD=A31Factory"

echo 📁 Backup file: %BACKUP_PATH%
echo 🗄️  Target database: %DB_DATABASE%
echo.

REM Check if Docker is running
docker-compose ps | findstr /C:"mysql" | findstr /C:"Up" >nul
if errorlevel 1 (
    echo ❌ Error: MySQL container is not running!
    echo    Please start the containers first: docker-compose up -d
    pause
    exit /b 1
)

echo 🔍 Checking database connection...

REM Test database connection
docker-compose exec -T mysql mysql -h %DB_HOST% -u %DB_USERNAME% -p%DB_PASSWORD% -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Cannot connect to database!
    echo    Please check database credentials and container status.
    pause
    exit /b 1
)

echo ✅ Database connection successful!
echo.

REM Warning message
echo ⚠️  WARNING: This will REPLACE the current database!
echo    Current database '%DB_DATABASE%' will be dropped and restored from backup.
echo.
set /p "CONFIRM=   Are you sure you want to continue? (yes/no): "

if not "%CONFIRM%"=="yes" (
    echo ❌ Restore cancelled by user.
    pause
    exit /b 0
)

echo.
echo 🚀 Starting restore process...

REM Get backup file size for progress info
for %%A in ("%BACKUP_PATH%") do set "BACKUP_SIZE=%%~zA"
set /a "BACKUP_SIZE_MB=%BACKUP_SIZE% / 1024 / 1024"
echo 📊 Restoring from backup (%BACKUP_SIZE% bytes, ~%BACKUP_SIZE_MB% MB)...

REM Restore database
docker-compose exec -T mysql mysql -h %DB_HOST% -u %DB_USERNAME% -p%DB_PASSWORD% < "%BACKUP_PATH%"
if errorlevel 1 (
    echo ❌ Error: Restore failed!
    echo    Please check the error messages above.
    echo    The database may be in an inconsistent state.
    pause
    exit /b 1
)

echo ✅ Database restored successfully!
echo.

REM Verify restore by checking tables
echo 🔍 Verifying restore...
for /f %%i in ('docker-compose exec -T mysql mysql -h %DB_HOST% -u %DB_USERNAME% -p%DB_PASSWORD% %DB_DATABASE% -e "SHOW TABLES;" ^| find /c /v ""') do set TABLE_COUNT=%%i

if %TABLE_COUNT% gtr 1 (
    set /a "ACTUAL_TABLES=%TABLE_COUNT% - 1"
    echo ✅ Verification successful! Found !ACTUAL_TABLES! tables in database.
    echo.
    
    REM Clear Laravel caches after restore
    echo 🧹 Clearing Laravel caches...
    docker-compose exec quanly.a31 php artisan cache:clear >nul 2>&1
    docker-compose exec quanly.a31 php artisan config:clear >nul 2>&1
    docker-compose exec quanly.a31 php artisan route:clear >nul 2>&1
    docker-compose exec quanly.a31 php artisan view:clear >nul 2>&1
    echo ✅ Laravel caches cleared!
    echo.
    
    echo 🎉 Database restore completed successfully!
    echo.
    echo 📋 Restore Summary:
    echo    • Source: %BACKUP_PATH%
    echo    • Size: %BACKUP_SIZE% bytes (~%BACKUP_SIZE_MB% MB)
    echo    • Database: %DB_DATABASE%
    echo    • Tables: !ACTUAL_TABLES!
    echo.
    echo 💡 You can now access the application with restored data.
    
) else (
    echo ⚠️  Warning: Restore completed but database appears empty!
    echo    Please check the backup file and try again.
)

echo.
echo ✨ Done!
pause
