#!/bin/bash

# A31 Factory Deployment Package Creator
# Creates a complete offline deployment package for Windows server

echo "📦 Creating A31 Factory Deployment Package..."
echo "============================================="

PACKAGE_NAME="A31_Factory_Deployment_$(date +%Y%m%d_%H%M%S)"
PACKAGE_DIR="deployment_packages/$PACKAGE_NAME"

# Create package directory
mkdir -p "$PACKAGE_DIR"

echo "📁 Created package directory: $PACKAGE_DIR"

# 1. Export Docker images
echo "🐳 Exporting Docker images..."
docker save mysql/mysql-server:8.0 > "$PACKAGE_DIR/mysql-image.tar"
docker save nginx:alpine > "$PACKAGE_DIR/nginx-image.tar"
docker save sail-8.2/app > "$PACKAGE_DIR/laravel-image.tar" || echo "⚠️  Laravel image not found, will build on target"

# 2. Create database backup
echo "💾 Creating database backup..."
./backup-db.sh
cp storage/db/latest_backup.sql "$PACKAGE_DIR/"

# 3. Copy project files (excluding unnecessary files)
echo "📂 Copying project files..."
rsync -av --exclude='node_modules' \
          --exclude='.git' \
          --exclude='vendor/bin' \
          --exclude='storage/logs' \
          --exclude='storage/framework/cache' \
          --exclude='storage/framework/sessions' \
          --exclude='storage/framework/views' \
          . "$PACKAGE_DIR/A31_Factory/"

# 4. Copy certificates
echo "🔒 Copying certificates..."
cp -r storage/certs "$PACKAGE_DIR/A31_Factory/storage/" 2>/dev/null || echo "⚠️  No certificates to copy"

# 5. Create Windows setup script
cat > "$PACKAGE_DIR/setup-windows.bat" << 'EOF'
@echo off
echo 🚀 A31 Factory - Windows Server Setup
echo ====================================

echo 📋 System Requirements Check:
echo    - Windows 10/11 or Windows Server 2019+
echo    - At least 8GB RAM
echo    - 20GB free disk space
echo    - Administrator privileges
echo.

REM Check if Docker Desktop is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Desktop not found!
    echo.
    echo 📥 Please install Docker Desktop first:
    echo    1. Download from: https://desktop.docker.com/win/main/amd64/Docker%%20Desktop%%20Installer.exe
    echo    2. Or use offline installer if available
    echo    3. Restart computer after installation
    echo    4. Run this script again
    pause
    exit /b 1
)

echo ✅ Docker Desktop found!

REM Load Docker images
echo 📦 Loading Docker images...
if exist "mysql-image.tar" (
    echo    Loading MySQL image...
    docker load < mysql-image.tar
)
if exist "nginx-image.tar" (
    echo    Loading Nginx image...  
    docker load < nginx-image.tar
)
if exist "laravel-image.tar" (
    echo    Loading Laravel image...
    docker load < laravel-image.tar
)

REM Setup project
echo 🏗️  Setting up A31 Factory...
cd A31_Factory

REM Copy environment file
if not exist ".env" (
    copy ".env.example" ".env"
    echo ✅ Created .env file
)

REM Start services
echo 🚀 Starting services...
docker-compose up -d

REM Wait for services to start
echo ⏳ Waiting for services to start...
timeout /t 30

REM Restore database
echo 💾 Restoring database...
if exist "..\latest_backup.sql" (
    call restore-db.bat ..\latest_backup.sql
) else (
    echo ⚠️  No database backup found, will start with empty database
    docker-compose exec quanly.a31 php artisan migrate --force
    docker-compose exec quanly.a31 php artisan db:seed --force
)

REM Generate application key
echo 🔑 Generating application key...
docker-compose exec quanly.a31 php artisan key:generate --force

REM Clear caches
echo 🧹 Clearing caches...
docker-compose exec quanly.a31 php artisan cache:clear
docker-compose exec quanly.a31 php artisan config:clear
docker-compose exec quanly.a31 php artisan route:clear

REM Get server IP
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /C:"IPv4"') do set "SERVER_IP=%%a"
set "SERVER_IP=%SERVER_IP: =%"

echo.
echo 🎉 A31 Factory setup completed!
echo.
echo 📋 Access Information:
echo    • Local: http://localhost
echo    • Network: http://%SERVER_IP%
echo    • Admin panel: /admin
echo.
echo 💡 Next steps:
echo    1. Configure firewall to allow port 80
echo    2. Add users and configure permissions
echo    3. Upload signature images in user profiles
echo    4. Test PDF generation and digital signatures
echo.
echo ✨ System is ready for use!
pause
EOF

# 6. Create README
cat > "$PACKAGE_DIR/README.md" << 'EOF'
# A31 Factory - Windows Server Deployment Package

## Package Contents

- `A31_Factory/` - Complete application source code
- `mysql-image.tar` - MySQL Docker image
- `nginx-image.tar` - Nginx Docker image  
- `laravel-image.tar` - Laravel application image (if available)
- `latest_backup.sql` - Database backup
- `setup-windows.bat` - Automated setup script

## Installation Steps

1. **Install Docker Desktop**
   - Download from Docker website or use offline installer
   - Restart computer after installation

2. **Run Setup**
   ```cmd
   setup-windows.bat
   ```

3. **Access Application**
   - Local: http://localhost
   - Network: http://[server-ip]

## System Requirements

- Windows 10/11 or Windows Server 2019+
- 8GB+ RAM
- 20GB+ free disk space
- Administrator privileges

## Features

- ✅ Complete offline operation
- ✅ Digital signature support
- ✅ PDF generation with visual signatures
- ✅ Database backup/restore
- ✅ Vietnamese interface
- ✅ Role-based permissions

## Support

For technical support, contact the A31 Factory development team.
EOF

# 7. Create file list
echo "📄 Creating file manifest..."
find "$PACKAGE_DIR" -type f > "$PACKAGE_DIR/file_manifest.txt"

# 8. Create checksum
echo "🔍 Creating checksums..."
cd "$PACKAGE_DIR"
find . -type f -exec md5sum {} \; > checksums.md5
cd - > /dev/null

# Calculate package size
PACKAGE_SIZE=$(du -sh "$PACKAGE_DIR" | cut -f1)

echo ""
echo "✅ Deployment package created successfully!"
echo ""
echo "📦 Package Information:"
echo "   • Name: $PACKAGE_NAME"
echo "   • Location: $PACKAGE_DIR"
echo "   • Size: $PACKAGE_SIZE"
echo ""
echo "📋 Package Contents:"
echo "   • Docker images (MySQL, Nginx)"
echo "   • Complete source code"
echo "   • Database backup"
echo "   • Windows setup script"
echo "   • Documentation"
echo ""
echo "💾 To deploy on Windows server:"
echo "   1. Copy entire '$PACKAGE_DIR' folder to Windows server"
echo "   2. Run 'setup-windows.bat' as Administrator"
echo "   3. Follow on-screen instructions"
echo ""
echo "🎯 System will be fully operational offline!"
