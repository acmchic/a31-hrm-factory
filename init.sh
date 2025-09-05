#!/bin/bash

echo "=========================================="
echo "  HRMS A31 Factory - Initialization Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if running on macOS/Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
else
    print_error "Unsupported operating system. Use init.bat for Windows."
    exit 1
fi

print_status "Detected OS: $OS"
print_status "Starting HRMS A31 Factory setup..."

# Step 1: Check requirements
print_step "1. Checking system requirements..."

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

print_status "✓ Docker and Docker Compose are installed"

# Step 2: Setup environment
print_step "2. Setting up environment..."

# Generate APP_KEY if not exists
if [ ! -f .env ]; then
    print_warning ".env file not found, creating from template..."
    cp .env.example .env 2>/dev/null || echo "No .env.example found, .env already created"
fi

# Create fresh .env with A31 Factory settings
print_status "Creating fresh .env with A31 Factory settings..."
cat > .env << 'ENVEOF'
APP_NAME="HRMS A31 Factory"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://quanly.a31:8080
APP_TIMEZONE="Asia/Ho_Chi_Minh"

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=a31_factory
DB_USERNAME=a31_user
DB_PASSWORD=A31Factory

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="noreply@quanly.a31"
MAIL_FROM_NAME="${APP_NAME}"

SAIL_XDEBUG_MODE=develop,debug
SAIL_SKIP_CHECKS=true
ENVEOF

print_status "✓ Environment configured"

# Step 3: Install dependencies
print_step "3. Installing dependencies..."

# Start Docker services
print_status "Starting Docker services..."
docker-compose down --remove-orphans 2>/dev/null || true
docker volume rm hrms_sail-mysql 2>/dev/null || true
docker-compose up -d

# Wait for MySQL to be ready
print_status "Waiting for MySQL to be ready..."
sleep 15

# Install Composer dependencies
print_status "Installing PHP dependencies..."
docker exec hrms-quanly.a31-1 composer install --optimize-autoloader --no-dev

# Generate application key
print_status "Generating application key..."
docker exec hrms-quanly.a31-1 php artisan key:generate

# Install NPM dependencies and build assets
print_status "Installing Node.js dependencies..."
docker exec hrms-quanly.a31-1 npm install

print_status "Building frontend assets..."
docker exec hrms-quanly.a31-1 npm run production

print_status "✓ Dependencies installed"

# Step 4: Database setup
print_step "4. Setting up database..."

# Create database and import from backup
print_status "Creating database and importing backup..."
docker exec hrms-mysql-1 mysql -ua31_user -pA31Factory -e "CREATE DATABASE IF NOT EXISTS a31_factory;"

# Check if backup file exists and import
if [ -f "storage/db/hrms_database_2025_09_05_02_59_50.sql" ]; then
    print_status "Importing database from backup with UTF-8 encoding..."
    docker exec hrms-mysql-1 mysql -ua31_user -pA31Factory -e "DROP DATABASE IF EXISTS a31_factory; CREATE DATABASE a31_factory CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    docker exec -i hrms-mysql-1 bash -c "mysql -ua31_user -pA31Factory --default-character-set=utf8mb4 a31_factory" < storage/db/hrms_database_2025_09_05_02_59_50.sql
    print_status "✓ Database imported from backup with UTF-8"
else
    print_status "No backup found, running fresh migrations..."
    docker exec hrms-quanly.a31-1 php artisan migrate:fresh --seed --force
fi

# Create/verify admin user with correct password
print_status "Creating fresh admin user..."
docker exec hrms-quanly.a31-1 php artisan tinker --execute="
// Delete any existing admin user
\$oldAdmin = \App\Models\User::where('username', 'admin')->first();
if (\$oldAdmin) {
    \$oldAdmin->delete();
    echo 'Old admin user deleted' . PHP_EOL;
}

// Create fresh admin user with correct password hash
\$admin = \App\Models\User::create([
    'name' => 'Administrator A31',
    'username' => 'admin',
    'password' => \Illuminate\Support\Facades\Hash::make('admin'),
    'profile_photo_path' => 'profile-photos/.default-photo.jpg',
]);

// Assign Admin role
\$adminRole = \Spatie\Permission\Models\Role::firstOrCreate(['name' => 'Admin']);
\$admin->assignRole(\$adminRole);

echo 'Fresh admin user created:' . PHP_EOL;
echo 'Username: admin' . PHP_EOL;
echo 'Password: admin' . PHP_EOL;
echo 'Name: ' . \$admin->name . PHP_EOL;
echo 'Roles: ' . \$admin->getRoleNames()->implode(', ') . PHP_EOL;

// Verify password works
if (\Illuminate\Support\Facades\Hash::check('admin', \$admin->password)) {
    echo 'Password verification: SUCCESS ✓' . PHP_EOL;
} else {
    echo 'Password verification: FAILED ✗' . PHP_EOL;
}
"

# Import vehicles data (skip if backup was imported)
if [ ! -f "storage/db/hrms_database_2025_09_05_02_59_50.sql" ]; then
    print_status "Importing vehicles data..."
    docker exec hrms-quanly.a31-1 php artisan tinker --execute="
// Load and import vehicles
\$jsonData = file_get_contents('storage/app/public/vehicles/vehicles.json');
\$vehiclesData = json_decode(\$jsonData, true);

function findActualVehicles(\$data, \$parentCategory = '') {
    \$vehicles = [];
    foreach (\$data as \$id => \$vehicle) {
        if (isset(\$vehicle['QA']) && !empty(\$vehicle['QA'])) {
            \$vehicles[] = [
                'name' => \$vehicle['name'],
                'license_plate' => 'QA-' . \$vehicle['QA'],
                'category' => \$parentCategory ?: 'Khác'
            ];
        }
        if (isset(\$vehicle['children'])) {
            \$childVehicles = findActualVehicles(\$vehicle['children'], \$vehicle['name']);
            \$vehicles = array_merge(\$vehicles, \$childVehicles);
        }
    }
    return \$vehicles;
}

\$actualVehicles = findActualVehicles(\$vehiclesData);
foreach (\$actualVehicles as \$vehicleData) {
    \App\Models\Vehicle::create([
        'name' => \$vehicleData['name'],
        'category' => \$vehicleData['category'],
        'license_plate' => \$vehicleData['license_plate'],
        'status' => 'available',
        'is_active' => 1
    ]);
}

// Add xe nâng hàng
\$xeNang = [
    ['name' => 'Xe nâng TCM-4,0 - FD40T9', 'license_plate' => 'XN-001'],
    ['name' => 'Xe nâng TOYOTAF8F050N', 'license_plate' => 'XN-002'],
    ['name' => 'Xe nâng FB10-MQC2', 'license_plate' => 'XN-003']
];
foreach(\$xeNang as \$xe) {
    \App\Models\Vehicle::create([
        'name' => \$xe['name'],
        'category' => 'Xe nâng hàng',
        'license_plate' => \$xe['license_plate'],
        'status' => 'available',
        'is_active' => 1
    ]);
}

// Add MTZ vehicle
\App\Models\Vehicle::create([
    'name' => 'Rơ moóc',
    'category' => 'Moóc kéo', 
    'license_plate' => 'MTZ - 80',
    'status' => 'available',
    'is_active' => 1
]);

echo 'Vehicles imported: ' . \App\Models\Vehicle::count() . PHP_EOL;
"
else
    print_status "Vehicles data already imported from backup"
fi

print_status "✓ Database setup completed"

# Step 5: Final setup
print_step "5. Final configuration..."

# Create storage link
print_status "Creating storage symlink..."
docker exec hrms-quanly.a31-1 php artisan storage:link

# Clear caches
print_status "Clearing application caches..."
docker exec hrms-quanly.a31-1 php artisan cache:clear
docker exec hrms-quanly.a31-1 php artisan config:clear
docker exec hrms-quanly.a31-1 php artisan route:clear
docker exec hrms-quanly.a31-1 php artisan view:clear

# Set permissions
print_status "Setting file permissions..."
chmod -R 755 storage
chmod -R 755 bootstrap/cache

print_status "✓ Final configuration completed"

# Step 6: Add domain to hosts file (optional)
print_step "6. Domain configuration..."
print_warning "To access the application via 'quanly.a31', add this line to your /etc/hosts file:"
print_warning "127.0.0.1    quanly.a31"
print_warning ""
print_warning "Run this command to add it automatically (requires sudo):"
print_warning "echo '127.0.0.1    quanly.a31' | sudo tee -a /etc/hosts"

echo ""
echo "=========================================="
echo -e "${GREEN}  SETUP COMPLETED SUCCESSFULLY!${NC}"
echo "=========================================="
echo ""
echo -e "🌐 Application URL: ${BLUE}http://quanly.a31:8080${NC}"
echo -e "📊 Database: ${BLUE}a31_factory${NC}"
echo -e "👤 Default Admin: ${BLUE}admin${NC} / ${BLUE}admin${NC}"
echo ""
echo -e "🚀 ${GREEN}Application is ready to use!${NC}"
echo ""
