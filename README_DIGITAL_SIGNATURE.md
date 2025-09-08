# A31 Factory HRMS - Digital Signature System

## 🎯 Tổng Quan

Hệ thống chữ ký số A1 đã được tích hợp hoàn chỉnh cho:
- ✅ **Đơn nghỉ phép** (Leave Requests)
- ✅ **Đăng ký xe** (Vehicle Registration)
- ✅ **Avatar upload** cho users
- ✅ **Auto-certificate creation** - Tự động tạo PFX khi cần

## 🚀 Khởi Động Hệ Thống

### Cách 1: Sử dụng Script Tự Động (Khuyến nghị)
```bash
./startup.sh
```

### Cách 2: Khởi Động Thủ Công
```bash
# 1. Kiểm tra hệ thống
php artisan app:startup-check

# 2. Khởi động server
php artisan serve --host=127.0.0.1 --port=8000
```

## 🔧 Các Commands Hữu Ích

### Kiểm Tra Hệ Thống
```bash
# Kiểm tra toàn bộ hệ thống
php artisan app:startup-check

# Kiểm tra A1 setup
php artisan a1:check

# Đảm bảo PFX certificate tồn tại
php artisan a1:ensure-pfx
```

### Tạo Certificate
```bash
# Tạo PFX certificate mới
php artisan a1:make-pfx --out=storage/certs/a31.pfx --pass="A31_CertSign" --days=3650
```

### Test Chữ Ký Số
```bash
# Test ký PDF demo
php artisan a1:sign-demo

# Test ký PDF đăng ký xe
php artisan test:vehicle-pdf 1

# Ký file PDF bất kỳ
php artisan a1:sign-file input.pdf --out=output_signed.pdf

# Verify chữ ký
php artisan a1:verify signed_file.pdf
```

## 📁 Cấu Trúc File

```
storage/
├── certs/
│   └── a31.pfx                    # Certificate chữ ký số
├── app/
│   ├── signed/
│   │   ├── demo_signed.pdf        # PDF demo đã ký
│   │   ├── leaves/                # PDF đơn nghỉ phép đã ký
│   │   └── vehicles/              # PDF đăng ký xe đã ký
│   ├── temp/                      # File tạm
│   └── public/
│       └── profile-photos/        # Avatar users
└── db/
    └── a31factory.sql             # Backup database
```

## 🔐 Cấu Hình Environment

Trong file `.env`:
```env
# A1 PDF Digital Signature
PDF_CERT_PATH=storage/certs/a31.pfx
PDF_CERT_PASS="A31_CertSign"
```

## 🎯 Tính Năng Chính

### 1. **Auto-Certificate Creation**
- Tự động tạo PFX certificate khi không tìm thấy
- Không cần can thiệp thủ công
- Chạy tự động hàng ngày qua scheduler

### 2. **Digital Signature cho PDF**
- Ký số thật (không chỉ embed image)
- Hiển thị Signature Panel trong Adobe Acrobat/Reader
- Lưu trữ file PDF đã ký để tái sử dụng

### 3. **Avatar Upload**
- Upload avatar cho users
- Tự động tạo storage link
- Hiển thị ngay sau khi upload

### 4. **Approval Workflow**
- **Đơn nghỉ phép**: Phê duyệt → Ký số → Lưu PDF
- **Đăng ký xe**: Trưởng phòng phê duyệt → Ký số → Thủ trưởng phê duyệt → Ký số cuối

## 🐛 Troubleshooting

### Lỗi "Certificate file not found"
```bash
# Chạy command này để tự động tạo certificate
php artisan a1:ensure-pfx
```

### Lỗi "Storage link not found"
```bash
# Tạo storage link
php artisan storage:link
```

### Lỗi Database Connection
```bash
# Khởi động MySQL container
docker-compose -f docker-compose-simple.yml up -d mysql

# Chạy migrations
php artisan migrate
```

### Lỗi 500 Internal Server Error
```bash
# Clear cache
php artisan config:clear
php artisan cache:clear
php artisan view:clear

# Generate app key
php artisan key:generate
```

## 📱 Truy Cập Hệ Thống

- **URL**: http://127.0.0.1:8000
- **Login**: Sử dụng tài khoản có sẵn (vd: `pdgiang`, `htthuy75`, `cahung`)
- **Database**: Đã khôi phục 252 users, 251 employees

## ✅ Kiểm Tra Chữ Ký Số

1. **Tạo/phê duyệt** đơn nghỉ phép hoặc đăng ký xe
2. **Download PDF** từ hệ thống
3. **Mở bằng Adobe Acrobat/Reader**
4. **Kiểm tra Signature Panel** - sẽ hiển thị chữ ký số A1

## 🔄 Auto-Maintenance

Hệ thống tự động:
- ✅ Tạo PFX certificate khi cần (hàng ngày)
- ✅ Tạo thư mục storage khi cần
- ✅ Kiểm tra và sửa lỗi startup
- ✅ Lưu trữ PDF đã ký để tái sử dụng

---

**🎉 Hệ thống đã sẵn sàng sử dụng!**
