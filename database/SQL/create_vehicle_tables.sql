-- Create vehicles table
CREATE TABLE vehicles (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL COMMENT 'Tên xe',
    category VARCHAR(255) NOT NULL COMMENT 'Danh mục xe',
    license_plate VARCHAR(255) NOT NULL UNIQUE COMMENT 'Biển số xe',
    brand VARCHAR(255) NULL COMMENT 'Hãng xe',
    model VARCHAR(255) NULL COMMENT 'Dòng xe',
    year INT NULL COMMENT 'Năm sản xuất',
    color VARCHAR(255) NULL COMMENT 'Màu sắc',
    fuel_type VARCHAR(255) NULL COMMENT 'Loại nhiên liệu',
    capacity INT NULL COMMENT 'Số chỗ ngồi',
    status ENUM('available', 'in_use', 'maintenance', 'broken') DEFAULT 'available' COMMENT 'Trạng thái xe',
    description TEXT NULL COMMENT 'Mô tả',
    is_active TINYINT(1) DEFAULT 1 COMMENT 'Kích hoạt',
    created_by VARCHAR(255) NULL,
    updated_by VARCHAR(255) NULL,
    deleted_by VARCHAR(255) NULL,
    created_at TIMESTAMP NULL DEFAULT NULL,
    updated_at TIMESTAMP NULL DEFAULT NULL,
    deleted_at TIMESTAMP NULL DEFAULT NULL
);

-- Create vehicle_registrations table
CREATE TABLE vehicle_registrations (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL COMMENT 'Người đăng ký',
    vehicle_id BIGINT UNSIGNED NOT NULL COMMENT 'Xe đăng ký',
    departure_date DATE NOT NULL COMMENT 'Ngày đi',
    return_date DATE NOT NULL COMMENT 'Ngày về',
    departure_time TIME NOT NULL COMMENT 'Giờ đi',
    return_time TIME NOT NULL COMMENT 'Giờ về',
    route TEXT NOT NULL COMMENT 'Tuyến đường',
    purpose TEXT NOT NULL COMMENT 'Lý do xin xe',
    passenger_count INT DEFAULT 1 COMMENT 'Số người đi',
    driver_name VARCHAR(255) NULL COMMENT 'Tên lái xe',
    driver_license VARCHAR(255) NULL COMMENT 'Bằng lái xe',
    
    -- Status workflow
    status ENUM('pending', 'dept_approved', 'approved', 'rejected') DEFAULT 'pending' COMMENT 'Trạng thái',
    workflow_status ENUM('submitted', 'dept_review', 'director_review', 'approved', 'rejected') DEFAULT 'submitted' COMMENT 'Trạng thái workflow',
    
    -- Department approval
    department_approved_by BIGINT UNSIGNED NULL COMMENT 'Người phê duyệt cấp phòng',
    department_approved_at TIMESTAMP NULL COMMENT 'Thời gian phê duyệt cấp phòng',
    digital_signature_dept TEXT NULL COMMENT 'Chữ ký số cấp phòng',
    
    -- Director approval
    director_approved_by BIGINT UNSIGNED NULL COMMENT 'Người phê duyệt cấp giám đốc',
    director_approved_at TIMESTAMP NULL COMMENT 'Thời gian phê duyệt cấp giám đốc',
    digital_signature_director TEXT NULL COMMENT 'Chữ ký số cấp giám đốc',
    
    -- Rejection
    rejection_reason TEXT NULL COMMENT 'Lý do từ chối',
    rejection_level ENUM('department', 'director') NULL COMMENT 'Cấp từ chối',
    
    created_by VARCHAR(255) NULL,
    updated_by VARCHAR(255) NULL,
    deleted_by VARCHAR(255) NULL,
    created_at TIMESTAMP NULL DEFAULT NULL,
    updated_at TIMESTAMP NULL DEFAULT NULL,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    
    -- Foreign keys
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE,
    FOREIGN KEY (department_approved_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (director_approved_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Insert some sample vehicles
INSERT INTO vehicles (name, category, license_plate, brand, model, year, color, fuel_type, capacity, status, is_active, created_by) VALUES
('Xe ô tô Toyota Camry', 'Xe con', '30A-12345', 'Toyota', 'Camry', 2020, 'Trắng', 'Xăng', 5, 'available', 1, 'System'),
('Xe ô tô Honda CR-V', 'Xe SUV', '30A-67890', 'Honda', 'CR-V', 2021, 'Đen', 'Xăng', 7, 'available', 1, 'System'),
('Xe tải Hyundai', 'Xe tải', '30C-11111', 'Hyundai', 'Porter', 2019, 'Xanh', 'Dầu', 3, 'available', 1, 'System'),
('Xe buýt Thaco', 'Xe buýt', '30B-22222', 'Thaco', 'Universe', 2018, 'Vàng', 'Dầu', 45, 'available', 1, 'System');

-- Show results
SELECT * FROM vehicles;
SELECT COUNT(*) as total_vehicles FROM vehicles;
