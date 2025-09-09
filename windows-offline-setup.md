# A31 Factory - Windows Server Offline Setup Guide

## 🎯 MỤC TIÊU
Triển khai A31 Factory trên Windows Server không có mạng internet.

## 📋 CHUẨN BỊ (Trên máy có mạng)

### Bước 1: Tạo deployment package
```bash
# Trên Mac/Linux hiện tại
./create-deployment-package.sh
```

### Bước 2: Download Docker Desktop Offline Installer
- Tải từ: https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe
- Hoặc từ máy khác có mạng

### Bước 3: Chuẩn bị USB/External Drive
```
📁 USB_Drive/
├── 📁 A31_Factory_Deployment_[timestamp]/
│   ├── 📁 A31_Factory/                    # Source code
│   ├── 🐳 mysql-image.tar                 # MySQL Docker image  
│   ├── 🐳 nginx-image.tar                 # Nginx Docker image
│   ├── 💾 latest_backup.sql               # Database backup
│   ├── 🚀 setup-windows.bat               # Auto setup script
│   └── 📖 README.md                       # Documentation
├── 🐳 Docker Desktop Installer.exe        # Docker installer
└── 📖 windows-offline-setup.md            # This guide
```

## 🖥️ TRIỂN KHAI TRÊN WINDOWS SERVER

### Bước 1: Install Docker Desktop
```cmd
# Chạy với quyền Administrator
Docker Desktop Installer.exe

# Restart máy sau khi cài xong
shutdown /r /t 0
```

### Bước 2: Load Docker Images
```cmd
# Mở Command Prompt as Administrator
cd C:\path\to\deployment\package

# Load images
docker load < mysql-image.tar
docker load < nginx-image.tar

# Verify images loaded
docker images
```

### Bước 3: Setup Application
```cmd
# Chạy script tự động
setup-windows.bat

# Hoặc setup thủ công:
cd A31_Factory
docker-compose up -d
```

### Bước 4: Restore Database
```cmd
# Nếu có backup
restore-db.bat latest_backup.sql

# Nếu không có backup (fresh install)
docker-compose exec quanly.a31 php artisan migrate --force
docker-compose exec quanly.a31 php artisan db:seed --force
```

### Bước 5: Configure System
```cmd
# Generate application key
docker-compose exec quanly.a31 php artisan key:generate --force

# Clear caches  
docker-compose exec quanly.a31 php artisan cache:clear
docker-compose exec quanly.a31 php artisan config:clear
```

## 🌐 NETWORK CONFIGURATION

### Option 1: Local Access Only
```
Access: http://localhost
Port: 80 (default)
```

### Option 2: Network Access
```cmd
# Get server IP
ipconfig

# Access from other computers:
http://[server-ip]

# Configure Windows Firewall:
netsh advfirewall firewall add rule name="A31 Factory HTTP" dir=in action=allow protocol=TCP localport=80
```

### Option 3: Custom Domain (Optional)
```cmd
# Edit hosts file on client computers:
# C:\Windows\System32\drivers\etc\hosts
192.168.1.100 quanly.a31

# Access: http://quanly.a31
```

## 🔧 TROUBLESHOOTING

### Docker Issues
```cmd
# Check Docker status
docker --version
docker-compose --version

# Restart Docker service
net stop com.docker.service
net start com.docker.service
```

### Container Issues
```cmd
# Check running containers
docker-compose ps

# View logs
docker-compose logs quanly.a31

# Restart specific service
docker-compose restart quanly.a31
```

### Database Issues
```cmd
# Check MySQL connection
docker-compose exec mysql mysql -u a31_user -pA31Factory -e "SELECT 1;"

# Reset database
docker-compose exec quanly.a31 php artisan migrate:fresh --seed --force
```

## 🎯 POST-DEPLOYMENT TASKS

### 1. Create Admin User
```cmd
docker-compose exec quanly.a31 php artisan tinker
# In tinker:
$user = App\Models\User::create([
    'name' => 'Administrator',
    'username' => 'admin', 
    'password' => Hash::make('admin123'),
    'email' => 'admin@a31.local'
]);
$user->assignRole('Admin');
```

### 2. Configure Signatures
- Login vào hệ thống
- Vào Profile → Upload signature images
- Test PDF generation

### 3. System Verification
- ✅ Login works
- ✅ Create leave request
- ✅ Approve leave request  
- ✅ Download PDF with signature
- ✅ Create vehicle registration
- ✅ Two-level approval workflow
- ✅ Download vehicle PDF with dual signatures

## 📊 SYSTEM REQUIREMENTS

### Minimum:
- **OS**: Windows 10/11 or Windows Server 2019+
- **RAM**: 8GB
- **Storage**: 20GB free space
- **Network**: LAN only (no internet required)

### Recommended:
- **OS**: Windows Server 2022
- **RAM**: 16GB+
- **Storage**: 50GB+ SSD
- **Network**: Gigabit LAN

## 🔒 SECURITY NOTES

- System generates self-signed certificates automatically
- All data stays within local network
- No external dependencies after deployment
- Regular database backups recommended

## 📞 SUPPORT

For deployment assistance, contact A31 Factory development team.
