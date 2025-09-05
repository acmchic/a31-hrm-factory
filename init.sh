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

# Update .env with new database settings
print_status "Updating .env with A31 Factory settings..."
sed -i.bak 's/^APP_NAME=.*/APP_NAME="HRMS A31 Factory"/' .env
sed -i.bak 's/^APP_URL=.*/APP_URL=http:\/\/quanly.a31:8080/' .env
sed -i.bak 's/^DB_DATABASE=.*/DB_DATABASE=a31_factory/' .env
sed -i.bak 's/^DB_USERNAME=.*/DB_USERNAME=a31_user/' .env
sed -i.bak 's/^DB_PASSWORD=.*/DB_PASSWORD=A31Factory/' .env
sed -i.bak 's/^APP_TIMEZONE=.*/APP_TIMEZONE="Asia\/Ho_Chi_Minh"/' .env

print_status "✓ Environment configured"

# Step 3: Install dependencies
print_step "3. Installing dependencies..."

# Start Docker services
print_status "Starting Docker services..."
docker-compose down --remove-orphans 2>/dev/null || true
./vendor/bin/sail up -d

# Wait for MySQL to be ready
print_status "Waiting for MySQL to be ready..."
sleep 15

# Install Composer dependencies
print_status "Installing PHP dependencies..."
./vendor/bin/sail composer install --optimize-autoloader --no-dev

# Generate application key
print_status "Generating application key..."
./vendor/bin/sail artisan key:generate

# Install NPM dependencies and build assets
print_status "Installing Node.js dependencies..."
./vendor/bin/sail npm install

print_status "Building frontend assets..."
./vendor/bin/sail npm run production

print_status "✓ Dependencies installed"

# Step 4: Database setup
print_step "4. Setting up database..."

# Run migrations
print_status "Running database migrations..."
./vendor/bin/sail artisan migrate --force

# Seed database
print_status "Seeding database with initial data..."
./vendor/bin/sail artisan db:seed --force

# Verify admin user creation
print_status "Verifying admin user..."
./vendor/bin/sail artisan tinker --execute="
\$admin = \App\Models\User::where('username', 'admin')->first();
if (\$admin) {
    echo 'Admin user found: ' . \$admin->name . ' (' . \$admin->username . ')' . PHP_EOL;
    echo 'Roles: ' . \$admin->getRoleNames()->implode(', ') . PHP_EOL;
} else {
    echo 'Creating admin user manually...' . PHP_EOL;
    \$admin = \App\Models\User::create([
        'name' => 'Administrator A31',
        'employee_id' => '1',
        'username' => 'admin',
        'password' => bcrypt('admin'),
        'profile_photo_path' => 'profile-photos/.default-photo.jpg',
    ]);
    \$adminRole = \Spatie\Permission\Models\Role::firstOrCreate(['name' => 'Admin']);
    \$admin->assignRole(\$adminRole);
    echo 'Admin user created: admin/admin with Admin role' . PHP_EOL;
}
"

# Import vehicles data
print_status "Importing vehicles data..."
./vendor/bin/sail artisan tinker --execute="
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

print_status "✓ Database setup completed"

# Step 5: Final setup
print_step "5. Final configuration..."

# Create storage link
print_status "Creating storage symlink..."
./vendor/bin/sail artisan storage:link

# Clear caches
print_status "Clearing application caches..."
./vendor/bin/sail artisan cache:clear
./vendor/bin/sail artisan config:clear
./vendor/bin/sail artisan route:clear
./vendor/bin/sail artisan view:clear

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
