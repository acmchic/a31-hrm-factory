@echo off
REM A31 Factory Database Backup Script for Windows
REM Author: A31 Factory Team
REM Description: Export database backup to storage\db\ folder

echo 🔄 A31 Factory - Database Backup Script
echo =======================================

REM Get current date and time for filename
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "TIMESTAMP=%YYYY%%MM%%DD%_%HH%%Min%%Sec%"

set "BACKUP_DIR=storage\db"
set "BACKUP_FILE=a31_factory_backup_%TIMESTAMP%.sql"
set "BACKUP_PATH=%BACKUP_DIR%\%BACKUP_FILE%"

REM Create backup directory if it doesn't exist
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

REM Database connection details
set "DB_HOST=mysql"
set "DB_PORT=3306"
set "DB_DATABASE=a31_factory"
set "DB_USERNAME=a31_user"
set "DB_PASSWORD=A31Factory"

echo 📅 Backup timestamp: %TIMESTAMP%
echo 📂 Backup location: %BACKUP_PATH%
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
docker-compose exec -T mysql mysql -h localhost -u %DB_USERNAME% -p%DB_PASSWORD% -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Cannot connect to database!
    echo    Please check database credentials and container status.
    pause
    exit /b 1
)

echo ✅ Database connection successful!
echo.
echo 🚀 Starting backup process...

REM Create database backup
docker-compose exec -T mysql mysqldump -h localhost -u %DB_USERNAME% -p%DB_PASSWORD% --single-transaction --routines --triggers --events --add-drop-database --databases %DB_DATABASE% > "%BACKUP_PATH%"

if errorlevel 1 (
    echo ❌ Error: Backup failed!
    echo    Please check the error messages above.
    pause
    exit /b 1
)

REM Get backup file size
for %%A in ("%BACKUP_PATH%") do set "BACKUP_SIZE=%%~zA"
set /a "BACKUP_SIZE_MB=%BACKUP_SIZE% / 1024 / 1024"

echo ✅ Backup completed successfully!
echo 📊 Backup file size: %BACKUP_SIZE% bytes (~%BACKUP_SIZE_MB% MB)
echo 📁 Backup saved to: %BACKUP_PATH%
echo.

REM Keep only last 10 backups to save space
echo 🧹 Cleaning up old backups (keeping last 10)...
cd /d "%BACKUP_DIR%"
for /f "skip=10 delims=" %%F in ('dir /b /o-d a31_factory_backup_*.sql 2^>nul') do del "%%F" 2>nul

REM Count remaining backups
set "REMAINING_COUNT=0"
for %%F in (a31_factory_backup_*.sql) do set /a REMAINING_COUNT+=1

echo 📦 Total backups kept: %REMAINING_COUNT%
echo.

REM Create latest symlink for easy access (Windows doesn't support symlinks easily, so copy)
copy "%BACKUP_FILE%" "latest_backup.sql" >nul
echo 🔗 Created copy: storage\db\latest_backup.sql
echo.

echo 🎉 Backup process completed successfully!
echo 💡 To restore this backup, run: restore-db.bat %BACKUP_FILE%
echo.
echo 📋 Backup Summary:
echo    • File: %BACKUP_PATH%
echo    • Size: %BACKUP_SIZE% bytes (~%BACKUP_SIZE_MB% MB)
echo    • Database: %DB_DATABASE%
echo    • Timestamp: %TIMESTAMP%
echo.
echo ✨ Done!
pause
