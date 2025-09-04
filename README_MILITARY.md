# Hệ thống Quản lý Quân nhân - HRMS

## Tổng quan
Hệ thống đã được customize để phù hợp với môi trường quân đội, bao gồm các chức năng quản lý quân nhân, phòng ban, chức vụ và phân quyền.

## Các tính năng chính

### 1. Quản lý Quân nhân
- **Thêm mới**: Tạo quân nhân mới với đầy đủ thông tin
- **Chỉnh sửa**: Cập nhật thông tin quân nhân
- **Xóa**: Xóa quân nhân khỏi hệ thống
- **Tìm kiếm**: Tìm kiếm theo tên, mã số, cấp bậc

### 2. Cấu trúc Tổ chức
- **Trung tâm**: Quản lý các trung tâm quân sự
- **Phòng ban**: Quản lý các phòng ban trong trung tâm
- **Chức vụ**: Quản lý các chức vụ quân đội
- **Vị trí**: Quản lý các vị trí công việc

### 3. Phân quyền
- **Admin**: Giám đốc, Chính ủy - Toàn quyền hệ thống
- **HR**: Trưởng phòng, Đội trưởng - Quản lý nhân sự
- **AM**: Nhân viên thường - Xem thông tin cơ bản

### 4. Import/Export dữ liệu
- **Import từ JSON**: Nhập dữ liệu từ file quanso.json
- **Export Excel**: Xuất danh sách quân nhân ra Excel

## Cách sử dụng

### Truy cập hệ thống
- URL: `http://laravel.test/structure/employees`
- Đăng nhập với tài khoản đã được tạo

### Thông tin đăng nhập mặc định
- **Admin**: `admin@demo.com` / `123456` (Toàn quyền hệ thống)
- **Quân nhân**: Sử dụng email từ file quanso.json / `123456`
  - Ví dụ: `pdgiang@quandoi.local` / `123456`

### Import dữ liệu quân số
1. Đặt file `quanso.json` vào thư mục `storage/app/public/troops/`
2. Sử dụng chức năng Import từ JSON trong giao diện
3. Hệ thống sẽ tự động tạo:
   - Các phòng ban
   - Các chức vụ
   - Tài khoản người dùng
   - Thông tin quân nhân

### Cấu trúc dữ liệu JSON
```json
{
  "departments": [
    {
      "name": "Tên phòng ban",
      "code": "Mã phòng ban",
      "members": [
        {
          "full_name": "Họ và tên",
          "dob": "Ngày sinh",
          "enlist_td": "Ngày nhập ngũ",
          "rank_code": "Cấp bậc",
          "position": "Chức vụ",
          "username": "Tên đăng nhập"
        }
      ]
    }
  ]
}
```

## Các trường thông tin quân nhân

### Thông tin cơ bản
- Họ và tên
- Ngày sinh
- Giới tính
- Địa chỉ
- Số điện thoại
- Số CMND/CCCD

### Thông tin quân đội
- Cấp bậc
- Chức vụ
- Phòng ban
- Trung tâm
- Ngày nhập ngũ
- Ngày bắt đầu công tác

### Thông tin hệ thống
- Tài khoản đăng nhập
- Email
- Trạng thái hoạt động
- Người tạo/cập nhật

## Lưu ý quan trọng

1. **Password mặc định**: Tất cả tài khoản đều có password là `123456`
2. **Phân quyền tự động**: Hệ thống tự động gán role dựa trên chức vụ
3. **Dữ liệu unique**: Username và email được tự động xử lý để tránh trùng lặp
4. **Backup dữ liệu**: Nên backup dữ liệu trước khi import

## Hỗ trợ kỹ thuật

- **Database**: MySQL với các bảng đã được customize
- **Framework**: Laravel với Livewire
- **Frontend**: Bootstrap + JavaScript
- **Export**: Sử dụng Maatwebsite Excel

## Cập nhật và bảo trì

- Kiểm tra log hệ thống thường xuyên
- Backup database định kỳ
- Cập nhật thông tin quân nhân khi có thay đổi
- Kiểm tra quyền truy cập định kỳ
