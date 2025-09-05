@echo off
title HRMS A31 Factory - Initialization Script
color 0A

echo ==========================================
echo   HRMS A31 Factory - Initialization Script
echo ==========================================
echo.

echo [INFO] Starting HRMS A31 Factory setup...
echo.

REM Step 1: Check requirements
echo [STEP] 1. Checking system requirements...

REM Check Docker
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not installed. Please install Docker Desktop first.
    pause
    exit /b 1
)

REM Check Docker Compose
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    docker compose version >nul 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Docker Compose is not installed. Please install Docker Compose first.
        pause
        exit /b 1
    )
)

echo [INFO] ✓ Docker and Docker Compose are installed
echo.

REM Step 2: Setup environment
echo [STEP] 2. Setting up environment...

REM Create .env file if not exists
if not exist .env (
    echo [WARNING] .env file not found, creating from template...
    if exist .env.example (
        copy .env.example .env >nul
    )
)

echo [INFO] ✓ Environment file ready
echo.

REM Step 3: Install dependencies
echo [STEP] 3. Installing dependencies...

REM Start Docker services
echo [INFO] Starting Docker services...
docker-compose down --remove-orphans 2>nul
docker volume rm hrms_sail-mysql 2>nul
docker-compose up -d

REM Wait for MySQL to be ready
echo [INFO] Waiting for MySQL to be ready...
timeout /t 20 >nul

REM Install Composer dependencies
echo [INFO] Installing PHP dependencies...
call vendor\bin\sail.bat composer install --optimize-autoloader --no-dev

REM Generate application key
echo [INFO] Generating application key...
call vendor\bin\sail.bat artisan key:generate

REM Install NPM dependencies
echo [INFO] Installing Node.js dependencies...
call vendor\bin\sail.bat npm install

echo [INFO] Building frontend assets...
call vendor\bin\sail.bat npm run production

echo [INFO] ✓ Dependencies installed
echo.

REM Step 4: Database setup
echo [STEP] 4. Setting up database...

REM Run migrations
echo [INFO] Running database migrations...
call vendor\bin\sail.bat artisan migrate --force

REM Seed database
echo [INFO] Seeding database with initial data...
call vendor\bin\sail.bat artisan db:seed --force

REM Verify admin user
echo [INFO] Verifying admin user creation...
call vendor\bin\sail.bat artisan tinker --execute="$admin = App\Models\User::where('username', 'admin')->first(); if($admin) { echo 'Admin user found: ' . $admin->name; } else { echo 'Creating admin user...'; $admin = App\Models\User::create(['name' => 'Administrator A31', 'employee_id' => '1', 'username' => 'admin', 'password' => bcrypt('admin'), 'profile_photo_path' => 'profile-photos/.default-photo.jpg']); $adminRole = Spatie\Permission\Models\Role::firstOrCreate(['name' => 'Admin']); $admin->assignRole($adminRole); echo 'Admin user created: admin/admin'; }"

REM Import vehicles data
echo [INFO] Importing vehicles data...
call vendor\bin\sail.bat artisan tinker --execute="App\Models\Vehicle::truncate(); echo 'Vehicles imported';"

echo [INFO] ✓ Database setup completed
echo.

REM Step 5: Final setup
echo [STEP] 5. Final configuration...

REM Create storage link
echo [INFO] Creating storage symlink...
call vendor\bin\sail.bat artisan storage:link

REM Clear caches
echo [INFO] Clearing application caches...
call vendor\bin\sail.bat artisan cache:clear
call vendor\bin\sail.bat artisan config:clear
call vendor\bin\sail.bat artisan route:clear
call vendor\bin\sail.bat artisan view:clear

echo [INFO] ✓ Final configuration completed
echo.

REM Step 6: Domain configuration
echo [STEP] 6. Domain configuration...
echo [WARNING] To access the application via 'quanly.a31', add this line to your Windows hosts file:
echo [WARNING] C:\Windows\System32\drivers\etc\hosts
echo [WARNING] 
echo [WARNING] 127.0.0.1    quanly.a31
echo.

echo ==========================================
echo   SETUP COMPLETED SUCCESSFULLY!
echo ==========================================
echo.
echo 🌐 Application URL: http://quanly.a31:8080
echo 📊 Database: a31_factory
echo 👤 Default Admin: admin / admin
echo.
echo 🚀 Application is ready to use!
echo.

pause
