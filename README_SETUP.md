# HRMS A31 Factory - Setup Guide

## Quick Start

### For Linux/macOS:
```bash
chmod +x init.sh
./init.sh
```

### For Windows:
```cmd
init.bat
```

## Manual Setup

### 1. Environment Configuration
Copy `.env.example` to `.env` and update:
```env
APP_NAME="HRMS A31 Factory"
APP_URL=http://quanly.a31
DB_DATABASE=a31_factory
DB_USERNAME=a31_user
DB_PASSWORD=A31Factory
APP_TIMEZONE="Asia/Ho_Chi_Minh"
```

### 2. Docker Configuration
Updated `docker-compose.yml`:
- Service name: `quanly.a31`
- Database: `a31_factory`
- User: `a31_user`
- Password: `A31Factory`

### 3. Domain Setup
Add to hosts file:
- Linux/macOS: `/etc/hosts`
- Windows: `C:\Windows\System32\drivers\etc\hosts`

```
127.0.0.1    quanly.a31
```

### 4. Database Export
Export current database:
```bash
php artisan db:export                    # SQL format
php artisan db:export --format=json      # JSON format
php artisan db:export --path=backup/     # Custom path
```

## Access Information
- **URL**: http://quanly.a31:8080
- **Database**: a31_factory
- **Admin**: admin / admin (full quyền)
- **Vehicles**: 26 xe thực tế (25 QA-, 3 XN-, 1 MTZ)

## Admin User Details
- **Username**: admin
- **Password**: admin
- **Role**: Admin (full permissions)
- **Name**: Administrator A31
