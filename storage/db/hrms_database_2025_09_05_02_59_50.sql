-- HRMS Database Export
-- Generated on: 2025-09-05 02:59:50
-- Database: hrms_database

SET FOREIGN_KEY_CHECKS = 0;

-- Structure for table `assets`
DROP TABLE IF EXISTS `assets`;
CREATE TABLE `assets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `old_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serial_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `class` enum('Electronic','Furniture','Gear') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('Good','Fine','Bad','Damaged') COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `in_service` tinyint(1) NOT NULL DEFAULT '1',
  `is_gpr` tinyint(1) NOT NULL DEFAULT '1',
  `real_price` int DEFAULT NULL,
  `expected_price` int DEFAULT NULL,
  `acquisition_date` date DEFAULT NULL,
  `acquisition_type` enum('Directed','Founded','Transferred') COLLATE utf8mb4_unicode_ci NOT NULL,
  `funded_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `bulk_messages`
DROP TABLE IF EXISTS `bulk_messages`;
CREATE TABLE `bulk_messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `numbers` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_sent` tinyint(1) NOT NULL DEFAULT '0',
  `error` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `categories`
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `category_sub_category`
DROP TABLE IF EXISTS `category_sub_category`;
CREATE TABLE `category_sub_category` (
  `category_id` bigint unsigned NOT NULL,
  `sub_category_id` bigint unsigned NOT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`category_id`,`sub_category_id`),
  KEY `category_sub_category_sub_category_id_foreign` (`sub_category_id`),
  CONSTRAINT `category_sub_category_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `category_sub_category_sub_category_id_foreign` FOREIGN KEY (`sub_category_id`) REFERENCES `sub_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `center_holiday`
DROP TABLE IF EXISTS `center_holiday`;
CREATE TABLE `center_holiday` (
  `center_id` bigint unsigned NOT NULL,
  `holiday_id` bigint unsigned NOT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`center_id`,`holiday_id`),
  KEY `center_holiday_holiday_id_foreign` (`holiday_id`),
  CONSTRAINT `center_holiday_center_id_foreign` FOREIGN KEY (`center_id`) REFERENCES `centers` (`id`),
  CONSTRAINT `center_holiday_holiday_id_foreign` FOREIGN KEY (`holiday_id`) REFERENCES `holidays` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `centers`
DROP TABLE IF EXISTS `centers`;
CREATE TABLE `centers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_work_hour` time NOT NULL,
  `end_work_hour` time NOT NULL,
  `weekends` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `centers`
INSERT INTO `centers` VALUES ('16', 'Trung tâm Quân sự', '08:00:00', '17:00:00', 'Thứ 7,Chủ nhật', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);

-- Structure for table `changelogs`
DROP TABLE IF EXISTS `changelogs`;
CREATE TABLE `changelogs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `contracts`
DROP TABLE IF EXISTS `contracts`;
CREATE TABLE `contracts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `work_rate` int NOT NULL,
  `notes` longtext COLLATE utf8mb4_unicode_ci,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `contracts`
INSERT INTO `contracts` VALUES ('5', 'Test', '100', NULL, 'System', 'System', NULL, '2025-09-03 04:34:38', '2025-09-03 04:34:38', NULL);
INSERT INTO `contracts` VALUES ('12', 'Hợp đồng quân đội', '100', NULL, 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);

-- Structure for table `departments`
DROP TABLE IF EXISTS `departments`;
CREATE TABLE `departments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `departments`
INSERT INTO `departments` VALUES ('26', 'BAN GIÁM ĐỐC', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `departments` VALUES ('27', 'Phòng Kế hoạch', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `departments` VALUES ('28', 'Ban Chính trị', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `departments` VALUES ('29', 'Phòng Kỹ thuật', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `departments` VALUES ('30', 'Phòng Cơ điện', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `departments` VALUES ('31', 'Phòng Vật tư', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `departments` VALUES ('32', 'Phòng kiểm tra chất lượng', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `departments` VALUES ('33', 'Phòng Tài chính', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `departments` VALUES ('34', 'Phòng Hành chính-Hậu cần', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `departments` VALUES ('35', 'PX1: Đài điều khiển', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `departments` VALUES ('36', 'PX2: BỆ PHÓNG', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `departments` VALUES ('37', 'PX3: SC XE ĐẶC CHỦNG', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `departments` VALUES ('38', 'PX4: CƠ KHÍ', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `departments` VALUES ('39', 'PX5: KÍP, ĐẠN TÊN LỬA', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `departments` VALUES ('40', 'PX6: XE MÁY-TNĐ', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `departments` VALUES ('41', 'PX7:  ĐO LƯỜNG', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `departments` VALUES ('42', 'PX8: ĐỘNG CƠ-BIẾN THẾ', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `departments` VALUES ('43', 'PX 9: HÓA NGHIỆM PHỤC HỒI \"O, G\"', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);

-- Structure for table `discounts`
DROP TABLE IF EXISTS `discounts`;
CREATE TABLE `discounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint unsigned NOT NULL,
  `rate` int NOT NULL,
  `date` date NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_auto` tinyint(1) NOT NULL DEFAULT '0',
  `is_sent` tinyint(1) NOT NULL DEFAULT '0',
  `batch` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `discounts_employee_id_foreign` (`employee_id`),
  CONSTRAINT `discounts_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `employee_leave`
DROP TABLE IF EXISTS `employee_leave`;
CREATE TABLE `employee_leave` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint unsigned NOT NULL,
  `leave_id` bigint unsigned NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `start_at` time DEFAULT NULL,
  `end_at` time DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `approved_by` bigint unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text COLLATE utf8mb4_unicode_ci,
  `digital_signature` text COLLATE utf8mb4_unicode_ci,
  `signature_certificate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `workflow_status` enum('draft','submitted','under_review','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `reviewer_id` bigint unsigned DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `is_authorized` tinyint(1) NOT NULL DEFAULT '0',
  `is_checked` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_leave_leave_id_foreign` (`leave_id`),
  KEY `employee_leave_approved_by_foreign` (`approved_by`),
  KEY `employee_leave_reviewer_id_foreign` (`reviewer_id`),
  KEY `employee_leave_employee_id_foreign` (`employee_id`),
  CONSTRAINT `employee_leave_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employee_leave_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  CONSTRAINT `employee_leave_leave_id_foreign` FOREIGN KEY (`leave_id`) REFERENCES `leaves` (`id`),
  CONSTRAINT `employee_leave_reviewer_id_foreign` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `employee_leave`
INSERT INTO `employee_leave` VALUES ('1', '215', '2', '2025-09-04', '2025-09-05', NULL, NULL, 'dddd', 'approved', '203', '2025-09-04 13:02:54', NULL, 'approved_by_Nguyễn Đình Sự_at_2025-09-04_13-02-54', NULL, 'approved', NULL, NULL, '0', '0', 'Nguyễn Địch Linh', 'Nguyễn Đình Sự', NULL, '2025-09-04 13:02:13', '2025-09-04 13:02:54', NULL);
INSERT INTO `employee_leave` VALUES ('2', '215', '2', '2025-09-04', '2025-09-06', NULL, NULL, NULL, 'approved', '203', '2025-09-04 13:33:13', NULL, 'approved_by_Nguyễn Đình Sự_at_2025-09-04_13-33-13', NULL, 'approved', NULL, NULL, '0', '0', 'Nguyễn Địch Linh', 'Nguyễn Đình Sự', NULL, '2025-09-04 13:32:52', '2025-09-04 13:33:13', NULL);
INSERT INTO `employee_leave` VALUES ('3', '208', '1', '2025-01-10', '2025-01-11', NULL, NULL, 'test', 'approved', '203', '2025-09-04 13:35:45', NULL, 'approved_by_Nguyễn Đình Sự_at_2025-09-04_13-35-45', NULL, 'approved', NULL, NULL, '0', '0', 'System', 'System', NULL, '2025-09-04 13:35:45', '2025-09-04 13:35:45', NULL);

-- Structure for table `employees`
DROP TABLE IF EXISTS `employees`;
CREATE TABLE `employees` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `contract_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `enlist_date` date DEFAULT NULL,
  `rank_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position_id` bigint unsigned DEFAULT NULL,
  `department_id` bigint unsigned DEFAULT NULL,
  `center_id` bigint unsigned DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `quit_date` date DEFAULT NULL,
  `CCCD` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` tinyint(1) NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_leave_allowed` int NOT NULL DEFAULT '0',
  `annual_leave_balance` int NOT NULL DEFAULT '12' COMMENT 'Số ngày nghỉ phép còn lại trong năm',
  `annual_leave_total` int NOT NULL DEFAULT '12' COMMENT 'Tổng số ngày nghỉ phép trong năm',
  `annual_leave_used` int NOT NULL DEFAULT '0' COMMENT 'Số ngày nghỉ phép đã sử dụng',
  `delay_counter` time NOT NULL DEFAULT '00:00:00',
  `hourly_counter` time NOT NULL DEFAULT '00:00:00',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `profile_photo_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employees_national_number_unique` (`CCCD`),
  UNIQUE KEY `employees_mobile_number_unique` (`phone`),
  KEY `employees_contract_id_foreign` (`contract_id`),
  KEY `employees_user_id_foreign` (`user_id`),
  KEY `employees_position_id_foreign` (`position_id`),
  KEY `employees_department_id_foreign` (`department_id`),
  KEY `employees_center_id_foreign` (`center_id`),
  CONSTRAINT `employees_center_id_foreign` FOREIGN KEY (`center_id`) REFERENCES `centers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`),
  CONSTRAINT `employees_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_position_id_foreign` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=441 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `employees`
INSERT INTO `employees` VALUES ('190', '197', '12', 'Pham Duc Giang', '1973-09-05', '1991-09-01', '4//', '103', '26', '16', '1991-09-01', NULL, 'pdgiang_1', '0813607408', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'Administrator', NULL, '2025-09-03 04:47:33', '2025-09-03 11:13:45', NULL);
INSERT INTO `employees` VALUES ('191', '198', '12', 'Hà Tiến Thụy', NULL, NULL, '4//', '104', '26', '16', '2025-09-03', NULL, 'htthuy_1', '0484231487', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `employees` VALUES ('192', '199', '12', 'Cao Anh Hùng', '1974-08-06', '1991-09-01', '4//', '105', '26', '16', '1991-09-01', NULL, 'cahung_1', '0256921095', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `employees` VALUES ('193', '200', '12', 'Bùi Tân Chinh', '1979-12-04', '1903-09-01', '3//', '105', '26', '16', '1903-09-01', NULL, 'btchinh_1', '0595085624', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `employees` VALUES ('194', '201', '12', 'Nguyễn Văn  Bảy', '1972-09-20', '1991-03-01', '3//', '105', '26', '16', '1991-03-01', NULL, 'nvbay_1', '0865445790', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `employees` VALUES ('195', '202', '12', 'Phạm Ngọc Sơn', '1967-10-22', '1985-08-01', '4//', '106', '26', '16', '1985-08-01', NULL, 'pnson_1', '0171566265', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `employees` VALUES ('196', '203', '12', 'Nguyễn Đình Sự', '1986-09-16', '1905-09-01', '2//', '107', '27', '16', '1905-09-01', NULL, 'ndsu_1', '0581680562', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `employees` VALUES ('197', '204', '12', 'Phạm Tiến Long', '1977-05-30', '1996-09-01', '3//', '108', '27', '16', '1996-09-01', NULL, 'ptlong_1', '0727924802', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('198', '205', '12', 'Đặng Đình Quỳnh', '1983-09-18', '1904-09-01', '2//', '109', '27', '16', '1904-09-01', NULL, 'ddquynh_1', '0909713395', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('199', '206', '12', 'Lục Viết Hợp', NULL, NULL, '1//', '109', '27', '16', '2025-09-03', NULL, 'lvhop_1', '0982200405', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('200', '207', '12', 'Trần Đình Tài', '1968-11-20', '1986-02-01', '3//CN', '110', '27', '16', '1986-02-01', NULL, 'tdtai_1', '0170600909', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('201', '208', '12', 'Trịnh Thị Thuý Hà', '1982-09-03', '1905-07-01', '2//', '111', '27', '16', '1905-07-01', NULL, 'tttha_1', '0216999815', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('202', '209', '12', 'Trịnh Văn Cương', '1993-08-23', '1911-08-01', '4/', '111', '27', '16', '1911-08-01', NULL, 'tvcuong_1', '0239429583', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('203', '210', '12', 'Nguyễn T Thu Hà', '1995-08-29', '1924-07-01', '2/', '111', '27', '16', '1924-07-01', NULL, 'nttha_1', '0871344116', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('204', '211', '12', 'Vũ Thành Trung', '1980-02-24', '1998-02-01', '1//CN', '112', '27', '16', '1998-02-01', NULL, 'vttrung_1', '0970483478', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('205', '212', '12', 'Phạm Thị Thuý', '1976-10-15', '1903-12-01', '1//CN', '113', '27', '16', '1903-12-01', NULL, 'ptthuy_1', '0448462377', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('206', '213', '12', 'Phạm Thị Trà', '1975-06-02', '1999-03-01', '1//CN', '114', '27', '16', '1999-03-01', NULL, 'pttra_1', '0990778255', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('207', '214', '12', 'Vũ Thanh Hà', '1987-08-12', '1906-02-01', '1//CN', '115', '27', '16', '1906-02-01', NULL, 'vtha_1', '0808504069', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('208', '215', '12', 'Nguyễn Địch Linh', '1990-07-18', '1908-09-01', '1//CN', '116', '27', '16', '1908-09-01', NULL, 'ndlinh_1', '0861266287', '1', 'Địa chỉ quân đội', '0', '10', '12', '2', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-04 13:35:45', NULL);
INSERT INTO `employees` VALUES ('209', '216', '12', 'Tạ Quốc Bảo', '1997-09-06', '1917-02-01', '2/CN', '117', '27', '16', '1917-02-01', NULL, 'tqbao_1', '0813718880', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('210', '217', '12', 'Trần Ngọc Liễu', '1985-05-14', '1911-10-01', '1//CN', '112', '27', '16', '1911-10-01', NULL, 'tnlieu_1', '0700456648', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `employees` VALUES ('211', '218', '12', 'Nguyễn T Thu Thanh', '1974-04-28', '1992-02-01', '2//CN', '115', '27', '16', '1992-02-01', NULL, 'nttthanh_1', '0908926259', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('212', '219', '12', 'Trần Hữu Ngọc', '1985-12-16', '1905-02-01', '1//CN', '118', '27', '16', '1905-02-01', NULL, 'thngoc_1', '0701776136', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('213', '220', '12', 'Nguyễn Minh Thanh', '1973-07-10', '1992-02-01', '2//CN', '119', '27', '16', '1992-02-01', NULL, 'nmthanh_1', '0956693140', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('214', '221', '12', 'Nông Tiến Tân', '1993-09-22', '1911-09-01', '4/CN', '119', '27', '16', '1911-09-01', NULL, 'nttan_1', '0198649828', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('215', '222', '12', 'Nguyễn Trọng Toàn', '1975-10-01', '1994-02-01', '1//CN', '119', '27', '16', '1994-02-01', NULL, 'nttoan_1', '0395650715', '1', 'Địa chỉ quân đội', '0', '9', '12', '3', '00:00:00', '00:00:00', '1', '', 'System', 'Nguyễn Đình Sự', NULL, '2025-09-03 04:47:35', '2025-09-04 13:33:13', NULL);
INSERT INTO `employees` VALUES ('216', '223', '12', 'Phạm Văn Bảy', '1974-05-05', '1993-03-01', '1//CN', '120', '27', '16', '1993-03-01', NULL, 'pvbay_1', '0994877811', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('217', '224', '12', 'Phạm Văn Tặng', '1978-03-27', '1999-03-01', '1//CN', '121', '27', '16', '1999-03-01', NULL, 'pvtang_1', '0682543112', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('218', '225', '12', 'Bùi Thanh Quân', '1979-01-15', '1999-03-01', '4/CN', '121', '27', '16', '1999-03-01', NULL, 'btquan_1', '0497697513', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('219', '226', '12', 'Vũ Hữu Hải', '1980-09-30', '1901-02-01', '4/CN', '121', '27', '16', '1901-02-01', NULL, 'vhhai_1', '0729289086', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('220', '227', '12', 'Lê Ngọc Duy', '1990-01-31', '1909-02-01', '3/CN', '121', '27', '16', '1909-02-01', NULL, 'lnduy_1', '0101042101', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('221', '228', '12', 'Nguyễn Văn Thắng', '1973-08-01', '1991-09-01', '1//CN', '121', '27', '16', '1991-09-01', NULL, 'nvthang_1', '0320889580', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('222', '229', '12', 'Nguyễn Tiến Cường', '1986-07-04', '1913-03-01', '1//CN', '121', '27', '16', '1913-03-01', NULL, 'ntcuong_1', '0334798263', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('223', '230', '12', 'Hoàng Văn Tình', '1979-08-01', '1999-03-01', '1//CN', '121', '27', '16', '1999-03-01', NULL, 'hvtinh_1', '0495730722', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('224', '231', '12', 'Hoàng Anh Đức', '2004-10-31', '1923-02-01', '1/CN', '121', '27', '16', '1923-02-01', NULL, 'haduc_1', '0785020284', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('225', '232', '12', 'Hoàng Bảo Chung', '1995-11-23', '1914-09-01', '3/CN', '121', '27', '16', '1914-09-01', NULL, 'hbchung_1', '0854819970', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('226', '233', '12', 'Phạm Thị Thu Hương', '1974-09-22', '1992-03-01', '3//', '122', '28', '16', '1992-03-01', NULL, 'ptthuong_1', '0780781213', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `employees` VALUES ('227', '234', '12', 'Phan Minh Nghĩa', '1984-07-20', '1904-02-01', '1//', '123', '28', '16', '1904-02-01', NULL, 'pmnghia_1', '0920903836', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('228', '235', '12', 'Nguyễn Trung Kiên', NULL, '1996-11-01', '2//', '124', '28', '16', '1996-11-01', NULL, 'ntkien_1', '0558266144', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('229', '236', '12', 'Nguyễn Văn Thắng', '1987-01-02', '1906-09-01', '1//', '124', '28', '16', '1906-09-01', NULL, 'nvthang_2', '0374825969', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('230', '237', '12', 'Đặng Trọng Chánh', NULL, NULL, '3/', '124', '28', '16', '2025-09-03', NULL, 'dtchanh_1', '0170893421', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('231', '238', '12', 'Nguyễn Minh Hiếu', '1999-10-17', '1917-09-01', '3/', '124', '28', '16', '1917-09-01', NULL, 'nmhieu_1', '0727463273', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('232', '239', '12', 'Bùi Thị Nhật Lệ', '1997-03-29', '1916-02-01', '1/', '125', '28', '16', '1916-02-01', NULL, 'btnle_1', '0491873758', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('233', '240', '12', 'Nguyễn Văn Ngà', '1983-09-05', '1902-09-01', '2//', '107', '29', '16', '1902-09-01', NULL, 'nvnga_1', '0377043208', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('234', '241', '12', 'Nguyễn Trung Kiên', '1985-10-16', '1903-09-01', '2//', '126', '29', '16', '1903-09-01', NULL, 'ntkien_2', '0942201346', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('235', '242', '12', 'Phạm Duy Thái', '1993-11-17', '1911-08-01', '4/', '126', '29', '16', '1911-08-01', NULL, 'pdthai_1', '0797918461', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('236', '243', '12', 'Lê Quý Vũ', '1983-06-24', '1901-09-01', '2//', '127', '29', '16', '1901-09-01', NULL, 'lqvu_1', '0248603802', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('237', '244', '12', 'Nguyên Hữu Ngọc', '1991-11-09', '1909-09-01', '1//', '128', '29', '16', '1909-09-01', NULL, 'nhngoc_1', '0750761331', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('238', '245', '12', 'Lại Hoàng Hà', '1988-09-12', '1906-09-01', '1//', '129', '29', '16', '1906-09-01', NULL, 'lhha_1', '0454602011', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('239', '246', '12', 'Dương Thế Vinh', '1993-07-22', '1911-08-01', '4/', '129', '29', '16', '1911-08-01', NULL, 'dtvinh_1', '0342975142', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('240', '247', '12', 'Đỗ Văn Quân', NULL, NULL, '4/', '129', '29', '16', '2025-09-03', NULL, 'dvquan_1', '0603485352', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('241', '248', '12', 'Nguyễn Văn Bình', '1992-10-30', '1911-09-01', '4/', '129', '29', '16', '1911-09-01', NULL, 'nvbinh_1', '0758046096', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('242', '249', '12', 'Bùi Công Đoài', '1988-09-25', '1906-09-01', '1//', '129', '29', '16', '1906-09-01', NULL, 'bcdoai_1', '0467053948', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `employees` VALUES ('243', '250', '12', 'Đặng Hùng', '1983-06-23', '1903-09-01', '1//', '129', '29', '16', '1903-09-01', NULL, 'dhung_1', '0819551514', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('244', '251', '12', 'Ngô Văn Hiển', '1986-12-10', '1904-09-01', '2//', '129', '29', '16', '1904-09-01', NULL, 'nvhien_1', '0501356527', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('245', '252', '12', 'Đỗ Văn Linh', '1994-03-25', '1912-09-01', '4/', '129', '29', '16', '1912-09-01', NULL, 'dvlinh_1', '0820823468', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('246', '253', '12', 'Hoàng Công Thành', '1992-12-04', '1909-09-01', '4/', '129', '29', '16', '1909-09-01', NULL, 'hcthanh_1', '0393908735', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('247', '254', '12', 'Văn Sỹ Lực', '1997-05-07', '1915-09-01', '3/', '129', '29', '16', '1915-09-01', NULL, 'vsluc_1', '0730276861', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('248', '255', '12', 'Nguyễn Trần Đức', '1995-04-27', '1913-09-01', '4/', '129', '29', '16', '1913-09-01', NULL, 'ntduc_1', '0607019552', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('249', '256', '12', 'Lê Minh Vượng', '1999-01-14', '1917-09-01', '3/', '129', '29', '16', '1917-09-01', NULL, 'lmvuong_1', '0440522933', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('250', '257', '12', 'Tạ Văn Hoàng', NULL, NULL, '4/', '129', '29', '16', '2025-09-03', NULL, 'tvhoang_1', '0259474395', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('251', '258', '12', 'Phạm Thị Phương', '1980-10-30', '1998-11-01', '1//CN', '130', '29', '16', '1998-11-01', NULL, 'ptphuong_1', '0862131569', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('252', '259', '12', 'Lê Thị Vân', '1975-06-02', '1901-02-01', '1//CN', '130', '29', '16', '1901-02-01', NULL, 'ltvan_1', '0334519771', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('253', '260', '12', 'Trần Xuân Trường', '1987-06-21', '1915-03-01', '1//CN', '131', '29', '16', '1915-03-01', NULL, 'txtruong_1', '0560832449', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('254', '261', '12', 'Nguyễn Đình Tuấn', '1986-11-19', '1906-02-01', '1//CN', '131', '29', '16', '1906-02-01', NULL, 'ndtuan_1', '0947484054', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('255', '262', '12', 'Trần Ngọc Dũng', '1987-12-08', '1906-09-01', '1//', '107', '30', '16', '1906-09-01', NULL, 'tndung_1', '0773793892', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('256', '263', '12', 'Nguyễn Anh Tuấn', '1974-02-10', '1992-02-01', '3//CN', '132', '30', '16', '1992-02-01', NULL, 'natuan_1', '0181396362', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `employees` VALUES ('257', '264', '12', 'Nguyễn Xuân Dũng', '1974-10-06', '1992-02-01', '1//CN', '133', '30', '16', '1992-02-01', NULL, 'nxdung_1', '0848660299', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('258', '265', '12', 'Ngô Viết  Toản', '1973-08-12', '1994-02-01', 'CNQP', '134', '30', '16', '1994-02-01', NULL, 'nvtoan_1', '0199797470', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('259', '266', '12', 'Hoàng Minh Ánh', '1973-12-22', '1993-02-01', 'CNQP', '134', '30', '16', '1993-02-01', NULL, 'hmanh_1', '0395910099', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('260', '267', '12', 'Nguyễn Văn Luỹ', '1984-10-25', '1902-09-01', '2//', '107', '31', '16', '1902-09-01', NULL, 'nvluy_1', '0808150189', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('261', '268', '12', 'Trần Bá Trường', '1991-12-17', '1910-09-01', '4/', '135', '31', '16', '1910-09-01', NULL, 'tbtruong_1', '0705733593', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('262', '269', '12', 'Bùi Văn Phong', '1985-10-04', '1903-10-01', '1//CN', '117', '31', '16', '1903-10-01', NULL, 'bvphong_1', '0872852650', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('263', '270', '12', 'Mai Văn Thuy', '1967-05-28', '1986-02-01', '3//CN', '136', '31', '16', '1986-02-01', NULL, 'mvthuy_1', '0282779057', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('264', '271', '12', 'Nguyễn Văn Cường', '1975-05-01', '1994-02-01', '2//CN', '136', '31', '16', '1994-02-01', NULL, 'nvcuong_1', '0813180221', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('265', '272', '12', 'Phan Thị Thu Hường', '1983-09-21', '1903-12-01', '2//CN', '117', '31', '16', '1903-12-01', NULL, 'ptthuong_2', '0350733848', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('266', '273', '12', 'Trịnh Thu Huyền', '1982-11-27', '1903-12-01', '1//CN', '136', '31', '16', '1903-12-01', NULL, 'tthuyen_1', '0915338822', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('267', '274', '12', 'Đặng Thị Huệ', '1993-05-08', '1915-03-01', '4/CN', '117', '31', '16', '1915-03-01', NULL, 'dthue_1', '0276273632', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('268', '275', '12', 'Đinh Tiến Dũng', '1976-07-13', '1997-03-01', '1//CN', '137', '31', '16', '1997-03-01', NULL, 'dtdung_1', '0736552285', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('269', '276', '12', 'Đoàn Thị Sự', '1971-12-12', '1999-03-01', '1//CN', '137', '31', '16', '1999-03-01', NULL, 'dtsu_1', '0235197069', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('270', '277', '12', 'Phạm Thị Thu  Hà', '1976-12-15', '1995-02-01', '1//CN', '137', '31', '16', '1995-02-01', NULL, 'pttha_1', '0607766355', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('271', '278', '12', 'Đinh Thị Tâm', '1979-05-05', '1903-12-01', '4/CN', '137', '31', '16', '1903-12-01', NULL, 'dttam_1', '0394662098', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `employees` VALUES ('272', '279', '12', 'Nguyễn Thị Hiền', '1992-08-02', '1920-12-01', '2/CN', '117', '31', '16', '1920-12-01', NULL, 'nthien_1', '0993670447', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('273', '280', '12', 'Đinh Quang Điềm', '1985-11-02', '1903-09-01', '2//', '107', '32', '16', '1903-09-01', NULL, 'dqdiem_1', '0523300647', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('274', '281', '12', 'Huỳnh Thái Tân', '1967-06-16', '1986-03-01', '3//CN', '138', '32', '16', '1986-03-01', NULL, 'httan_1', '0217769712', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('275', '282', '12', 'Mai Trường Giang', '1974-01-02', '1992-02-01', '3//CN', '139', '32', '16', '1992-02-01', NULL, 'mtgiang_1', '0852064307', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('276', '283', '12', 'Nguyễn Việt Dũng', '1976-06-26', '1995-02-01', '2//CN', '139', '32', '16', '1995-02-01', NULL, 'nvdung_1', '0854032458', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('277', '284', '12', 'Nguyễn Xuân Quý', '1977-02-12', '1996-03-01', '1//CN', '138', '32', '16', '1996-03-01', NULL, 'nxquy_1', '0430902538', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('278', '285', '12', 'Nguyễn Xuân Bách', '1975-05-31', '1994-02-01', '2//CN', '140', '32', '16', '1994-02-01', NULL, 'nxbach_1', '0432021487', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('279', '286', '12', 'Nguyễn Ngọc Quý', '1983-10-06', '1903-02-01', '1//CN', '141', '32', '16', '1903-02-01', NULL, 'nnquy_1', '0984035226', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('280', '287', '12', 'Thái Thị Hà', '1981-07-08', '1901-02-01', '2//CN', '142', '32', '16', '1901-02-01', NULL, 'ttha_1', '0844455188', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('281', '288', '12', 'Nguyễn Văn Bách', '1974-07-15', '1992-02-01', '1//CN', '143', '32', '16', '1992-02-01', NULL, 'nvbach_1', '0142468704', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('282', '289', '12', 'Nguyễn Văn Cường', '1979-07-17', '1998-02-01', '1//', '107', '33', '16', '1998-02-01', NULL, 'nvcuong_2', '0254599833', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('283', '290', '12', 'Nguyễn Văn Phú', '1988-08-14', '1907-03-01', '4/CN', '144', '33', '16', '1907-03-01', NULL, 'nvphu_1', '0375721881', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('284', '291', '12', 'Phạm Thị Kiều Ân', '1982-06-13', '1903-12-01', '1//CN', '145', '33', '16', '1903-12-01', NULL, 'ptkan_1', '0668336295', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('285', '292', '12', 'Nguyễn Thị Thuý', '1987-07-05', '1912-02-01', '1//CN', '144', '33', '16', '1912-02-01', NULL, 'ntthuy_1', '0567187645', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('286', '293', '12', 'Dương Thị Mơ', '1990-10-19', '1915-03-01', '1//CN', '144', '33', '16', '1915-03-01', NULL, 'dtmo_1', '0990608083', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `employees` VALUES ('287', '294', '12', 'Nguyễn Thị Hằng', '1995-06-24', '1916-02-01', '4/CN', '144', '33', '16', '1916-02-01', NULL, 'nthang_1', '0961056193', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('288', '295', '12', 'Phạm T Thu Hương', '1983-07-16', '1903-12-01', '1//CN', '145', '33', '16', '1903-12-01', NULL, 'ptthuong_3', '0250970195', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('289', '296', '12', 'Chử  Quang Anh', '1980-02-10', '1999-03-01', '2//', '107', '34', '16', '1999-03-01', NULL, 'cqanh_1', '0350793747', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('290', '297', '12', 'Đào Văn Tiến', '1973-08-31', '1991-09-01', '3//', '146', '34', '16', '1991-09-01', NULL, 'dvtien_1', '0759488507', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('291', '298', '12', 'Trần Đình Tám', '1979-07-30', '1999-03-01', '2//CN', '147', '34', '16', '1999-03-01', NULL, 'tdtam_1', '0251264032', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('292', '299', '12', 'Nguyễn Quỳnh Trang', '1981-04-02', '1901-02-01', '2//CN', '148', '34', '16', '1901-02-01', NULL, 'nqtrang_1', '0975152848', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('293', '300', '12', 'Lê Mạnh Hà', '1990-08-13', '1912-02-01', '4/CN', '149', '34', '16', '1912-02-01', NULL, 'lmha_1', '0843923653', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('294', '301', '12', 'Nguyễn Thị Anh', '1990-08-24', '1915-03-01', '2/CN', '150', '34', '16', '1915-03-01', NULL, 'ntanh_1', '0166297173', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('295', '302', '12', 'Đỗ Đức Toàn', '1984-10-21', '1913-03-01', '1//CN', '151', '34', '16', '1913-03-01', NULL, 'ddtoan_1', '0835937210', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('296', '303', '12', 'Triệu T Hoài Phương', '1987-11-13', '1916-09-01', '2/CN', '151', '34', '16', '1916-09-01', NULL, 'tthphuong_1', '0289573371', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('297', '304', '12', 'Trịnh Bá Thuận', '1966-08-16', NULL, '1//CN', '147', '34', '16', '2025-09-03', NULL, 'tbthuan_1', '0770004609', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('298', '305', '12', 'Đặng Quốc Sỹ', '1980-01-20', '1901-02-01', '4/CN', '147', '34', '16', '1901-02-01', NULL, 'dqsy_1', '0819595056', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('299', '306', '12', 'Phạm Lan Phương', '1994-05-14', '1916-09-01', '2/CN', '151', '34', '16', '1916-09-01', NULL, 'plphuong_1', '0488967404', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('300', '307', '12', 'Giang Chí Dũng', '1998-01-18', '1922-12-01', '2/CN', '147', '34', '16', '1922-12-01', NULL, 'gcdung_1', '0648055508', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('301', '308', '12', 'Nguyễn Thị Huyền', '1990-10-28', '1922-12-01', 'CNQP', '151', '34', '16', '1922-12-01', NULL, 'nthuyen_1', '0527826313', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('302', '309', '12', 'Nguyễn T Phương Chi', '1981-06-17', '1901-02-01', '1//CN', '152', '34', '16', '1901-02-01', NULL, 'ntpchi_1', '0782360762', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `employees` VALUES ('303', '310', '12', 'Phạm Thị Vân Anh', '1992-03-28', '1914-03-01', '3/CN', '152', '34', '16', '1914-03-01', NULL, 'ptvanh_1', '0998037568', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('304', '311', '12', 'Trần Thị Tuyến', '1989-06-20', '1914-03-01', '4/CN', '152', '34', '16', '1914-03-01', NULL, 'tttuyen_1', '0171778150', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('305', '312', '12', 'Bùi Đức Anh', '1993-10-31', '1915-03-01', '3/CN', '152', '34', '16', '1915-03-01', NULL, 'bdanh_1', '0674682168', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('306', '313', '12', 'Vũ Thị Kim Ngân', '1989-08-27', '1913-03-01', '2/CN
3/CN', '152', '34', '16', '1913-03-01', NULL, 'vtkngan_1', '0665529245', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('307', '314', '12', 'Nguyễn Thu Huyền', '1982-09-20', '1913-03-01', '3/CN', '153', '34', '16', '1913-03-01', NULL, 'nthuyen_2', '0995660647', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('308', '315', '12', 'Trần Trọng Đại', '1985-12-04', '1904-08-01', '1//', '154', '35', '16', '1904-08-01', NULL, 'ttdai_1', '0147019491', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('309', '316', '12', 'Lưu Hoàng Văn', '1992-05-10', '1909-09-01', '4/', '155', '35', '16', '1909-09-01', NULL, 'lhvan_1', '0352581696', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('310', '317', '12', 'Đồng Xuân Dũng', NULL, NULL, '3/', '135', '35', '16', '2025-09-03', NULL, 'dxdung_1', '0269156422', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('311', '318', '12', 'Trương Thanh Tú', NULL, NULL, '2/', '135', '35', '16', '2025-09-03', NULL, 'tttu_1', '0629455091', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('312', '319', '12', 'Dương T Phương Loan', '1977-08-29', '1903-12-01', '1//CN', '156', '35', '16', '1903-12-01', NULL, 'dtploan_1', '0714513071', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('313', '320', '12', 'Nguyễn  Hữu Thanh', '1983-09-02', '1902-10-01', '1//CN', '157', '35', '16', '1902-10-01', NULL, 'nhthanh_1', '0726829730', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('314', '321', '12', 'Nguyễn Thị Tuyền', '1983-02-13', '1912-02-01', '2/CN', '158', '35', '16', '1912-02-01', NULL, 'nttuyen_1', '0330755831', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('315', '322', '12', 'Lê Thị Thuý Hằng', '1985-03-24', '1912-02-01', '3/CN', '158', '35', '16', '1912-02-01', NULL, 'ltthang_1', '0642923840', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('316', '323', '12', 'Nguyễn T Thuý Bình', '1984-10-30', '1912-02-01', '4/CN', '159', '35', '16', '1912-02-01', NULL, 'nttbinh_1', '0196793097', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('317', '324', '12', 'Đặng Thị Kim Dung', '1981-06-05', '1916-09-01', '1/CN', '158', '35', '16', '1916-09-01', NULL, 'dtkdung_1', '0994859847', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `employees` VALUES ('318', '325', '12', 'Dương Thị Thân Thương', '1989-06-29', '1914-03-01', 'CNQP', '158', '35', '16', '1914-03-01', NULL, 'dttthuong_1', '0786523810', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('319', '326', '12', 'Phạm Thị Trang Nhung', '1979-09-27', '1912-02-01', 'CNQP', '158', '35', '16', '1912-02-01', NULL, 'pttnhung_1', '0919934828', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('320', '327', '12', 'Trần Thị Chuyên', '1990-10-20', '1914-03-01', '4/CN', '158', '35', '16', '1914-03-01', NULL, 'ttchuyen_1', '0819588517', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('321', '328', '12', 'Phạm Khắc Hùng', '1985-10-12', '1904-02-01', '1//CN', '160', '35', '16', '1904-02-01', NULL, 'pkhung_1', '0953364443', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('322', '329', '12', 'Nguyễn Mạnh Hùng', '1974-05-01', '1995-02-01', '2//CN', '161', '35', '16', '1995-02-01', NULL, 'nmhung_1', '0592416178', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('323', '330', '12', 'Vũ Mạnh Tú', '1985-06-26', '1904-02-01', '1//CN', '161', '35', '16', '1904-02-01', NULL, 'vmtu_1', '0113366628', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('324', '331', '12', 'Bùi Anh Tuấn', '1983-03-11', '1904-02-01', '1//CN', '161', '35', '16', '1904-02-01', NULL, 'batuan_1', '0577862020', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('325', '332', '12', 'Nguyễn Văn Thụ', '1988-11-03', '1912-02-01', '4/CN', '161', '35', '16', '1912-02-01', NULL, 'nvthu_1', '0275089629', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('326', '333', '12', 'Đặng Văn Phố', '1974-01-01', '1992-02-01', '2//CN', '161', '35', '16', '1992-02-01', NULL, 'dvpho_1', '0207262541', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('327', '334', '12', 'Nguyễn Xuân Trường', '1982-02-25', '1901-02-01', '1//CN', '161', '35', '16', '1901-02-01', NULL, 'nxtruong_1', '0951229831', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('328', '335', '12', 'Hà Thanh Trung', '1973-10-20', '1992-02-01', '3//CN', '162', '35', '16', '1992-02-01', NULL, 'httrung_1', '0447437094', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('329', '336', '12', 'Nguyễn Văn Huyên', '1982-08-20', '1902-03-01', '1//CN', '163', '35', '16', '1902-03-01', NULL, 'nvhuyen_1', '0755880893', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('330', '337', '12', 'Nguyễn Gia Mạnh', '1985-06-25', '1905-02-01', '1//CN', '163', '35', '16', '1905-02-01', NULL, 'ngmanh_1', '0363675519', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('331', '338', '12', 'Đỗ Hồng Sơn', '2001-12-27', '1920-02-01', '1/CN', '163', '35', '16', '1920-02-01', NULL, 'dhson_1', '0774831580', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('332', '339', '12', 'Nguyễn Tuấn Hiệp', '1974-06-04', '1995-10-01', '1//CN', '163', '35', '16', '1995-10-01', NULL, 'nthiep_1', '0229253855', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('333', '340', '12', 'Vũ Mạnh Cương', '1978-05-09', '1903-12-01', '4/CN', '164', '35', '16', '1903-12-01', NULL, 'vmcuong_1', '0781719874', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `employees` VALUES ('334', '341', '12', 'Lê Trọng Quỳnh', '1978-12-16', '1903-12-01', '1//CN', '165', '35', '16', '1903-12-01', NULL, 'ltquynh_1', '0696730469', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('335', '342', '12', 'Đặng Viết Công', '1983-09-12', '1903-12-01', '4/CN', '166', '35', '16', '1903-12-01', NULL, 'dvcong_1', '0465020201', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('336', '343', '12', 'Nguyễn Tiến Dũng', '1996-09-22', '1915-03-01', '2/CN', '166', '35', '16', '1915-03-01', NULL, 'ntdung_1', '0652860521', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('337', '344', '12', 'Nguyễn Hồng Anh', '1981-05-04', '1999-09-01', '2//', '154', '36', '16', '1999-09-01', NULL, 'nhanh_1', '0199032187', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('338', '345', '12', 'Trần Đức Tấn', '1987-07-11', '1905-09-01', '1//', '167', '36', '16', '1905-09-01', NULL, 'tdtan_1', '0720677487', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('339', '346', '12', 'Hoàng Anh Dũng', '2000-08-21', '1918-09-01', '2/', '135', '36', '16', '1918-09-01', NULL, 'hadung_1', '0472267865', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('340', '347', '12', 'Nguyễn Mai Hương', '1983-09-01', '1903-12-01', '1//CN', '156', '36', '16', '1903-12-01', NULL, 'nmhuong_1', '0316820398', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('341', '348', '12', 'Hoàng Văn Tiến', '1978-05-16', '1998-02-01', '1//CN', '168', '36', '16', '1998-02-01', NULL, 'hvtien_1', '0357064910', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('342', '349', '12', 'Nguyễn Xuân Thụ', '1989-03-23', '1907-10-01', '4/CN', '169', '36', '16', '1907-10-01', NULL, 'nxthu_1', '0243675579', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('343', '350', '12', 'Hà Nguyễn Tuấn Anh', '1998-12-02', '1924-08-01', 'CNQP', '169', '36', '16', '1924-08-01', NULL, 'hntanh_1', '0590852755', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('344', '351', '12', 'Đinh Viết Trường', '1992-08-28', '1910-09-01', '4/CN', '169', '36', '16', '1910-09-01', NULL, 'dvtruong_1', '0380649803', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('345', '352', '12', 'Phan Thanh Quang', '1981-05-23', '1900-02-01', '1//CN', '170', '36', '16', '1900-02-01', NULL, 'ptquang_1', '0803386398', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('346', '353', '12', 'Nguyễn Tiến Nam', '1981-10-09', '1900-02-01', '4/CN', '171', '36', '16', '1900-02-01', NULL, 'ntnam_1', '0245080189', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('347', '354', '12', 'Nguyễn Huy Thắng', NULL, '1904-02-01', '3/CN', '171', '36', '16', '1904-02-01', NULL, 'nhthang_1', '0839061095', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('348', '355', '12', 'Trần Hồng Công', '1989-10-21', '1916-09-01', '2/CN', '171', '36', '16', '1916-09-01', NULL, 'thcong_1', '0154690992', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('349', '356', '12', 'An Văn Trực', '1983-07-09', '1901-09-01', '3//', '154', '37', '16', '1901-09-01', NULL, 'avtruc_1', '0266696389', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('350', '357', '12', 'Phạm Quỳnh Trang', '1987-10-28', '1912-02-01', '3/CN', '172', '37', '16', '1912-02-01', NULL, 'pqtrang_1', '0155318729', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `employees` VALUES ('351', '358', '12', 'Ngô Thị Sơn', '1970-09-26', '1998-06-01', '2//CN', '156', '37', '16', '1998-06-01', NULL, 'ntson_1', '0966304046', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('352', '359', '12', 'Nguyễn Anh Tuấn', '1987-03-12', '1906-02-01', '1//CN', '173', '37', '16', '1906-02-01', NULL, 'natuan_2', '0681874793', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('353', '360', '12', 'Trần  Ngọc Phú', '1983-12-18', '1902-03-01', '1//CN', '174', '37', '16', '1902-03-01', NULL, 'tnphu_1', '0572235301', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('354', '361', '12', 'Nguyễn Tuấn Long', '1983-04-15', '1903-02-01', '4/CN', '175', '37', '16', '1903-02-01', NULL, 'ntlong_1', '0733435735', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('355', '362', '12', 'Nguyễn Đức Anh', '1993-06-08', '1922-12-01', '1/CN', '175', '37', '16', '1922-12-01', NULL, 'ndanh_1', '0129195379', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('356', '363', '12', 'Nguyễn Phú Hùng', '1995-01-06', '1923-12-01', '2/CN', '175', '37', '16', '1923-12-01', NULL, 'nphung_1', '0602150851', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('357', '364', '12', 'Nguyễn Anh Đạt', '1995-06-25', '1914-03-01', '3/CN', '175', '37', '16', '1914-03-01', NULL, 'nadat_1', '0740755072', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('358', '365', '12', 'Trịnh Trọng Cường', '1975-01-15', '1994-02-01', '1//CN', '176', '37', '16', '1994-02-01', NULL, 'ttcuong_1', '0918952686', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('359', '366', '12', 'Cấn Xuân Khánh', '1991-02-14', '1910-09-01', '4/', '154', '38', '16', '1910-09-01', NULL, 'cxkhanh_1', '0507215127', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('360', '367', '12', 'Vũ Thị Hiền', '1988-02-08', '1912-02-01', '4/CN', '156', '38', '16', '1912-02-01', NULL, 'vthien_1', '0283107764', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('361', '368', '12', 'Phan Văn Đăng', '1974-05-05', '1995-02-01', 'CNQP', '177', '38', '16', '1995-02-01', NULL, 'pvdang_1', '0992174156', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('362', '369', '12', 'Bùi Mạnh Hùng', '1982-10-30', '1916-02-01', '1//CN', '178', '38', '16', '1916-02-01', NULL, 'bmhung_1', '0203346191', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('363', '370', '12', 'Trần Văn Thành', '1974-08-16', '1994-02-01', '1//CN', '179', '38', '16', '1994-02-01', NULL, 'tvthanh_1', '0346794048', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('364', '371', '12', 'Vũ Trịnh Giang', '1992-09-02', '1916-02-01', '2/CN', '179', '38', '16', '1916-02-01', NULL, 'vtgiang_1', '0259476389', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('365', '372', '12', 'Nguyễn Tuấn Long', '1976-07-13', '1994-02-01', '1//CN', '180', '38', '16', '1994-02-01', NULL, 'ntlong_2', '0350557677', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('366', '373', '12', 'Vũ Huy Phương', '1986-09-25', '1914-03-01', '1//CN', '181', '38', '16', '1914-03-01', NULL, 'vhphuong_1', '0514641952', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `employees` VALUES ('367', '374', '12', 'Vũ Hải Dương', '1991-05-16', '1916-02-01', '4/CN', '181', '38', '16', '1916-02-01', NULL, 'vhduong_1', '0361164367', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('368', '375', '12', 'Trịnh Thành Chung', '1986-08-01', '1916-09-01', '2/CN', '181', '38', '16', '1916-09-01', NULL, 'ttchung_1', '0153771186', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('369', '376', '12', 'Nguyễn Diên Quang', '1981-11-20', '1902-03-01', '1//CN', '182', '38', '16', '1902-03-01', NULL, 'ndquang_1', '0739874240', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('370', '377', '12', 'Mai Thị Phượng', '1982-08-03', '1912-02-01', '2/CN', '183', '38', '16', '1912-02-01', NULL, 'mtphuong_1', '0933496823', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('371', '378', '12', 'Bùi Thị Hồng Thu', '1988-10-03', '1916-02-01', '2/CN', '183', '38', '16', '1916-02-01', NULL, 'bththu_1', '0282904527', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('372', '379', '12', 'Đặng Văn Tường', '1970-11-01', '1992-02-01', '1//CN', '184', '38', '16', '1992-02-01', NULL, 'dvtuong_1', '0276585101', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('373', '380', '12', 'Trần Hồng Tú', '1981-01-11', '1999-03-01', '4/CN', '185', '38', '16', '1999-03-01', NULL, 'thtu_1', '0734091542', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('374', '381', '12', 'Lê Trọng Quý', '1989-12-07', '1916-09-01', '1/CN', '186', '38', '16', '1916-09-01', NULL, 'ltquy_1', '0929728851', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('375', '382', '12', 'Đỗ Trung Kiên', '1994-01-19', '1923-12-01', '1/CN', '187', '38', '16', '1923-12-01', NULL, 'dtkien_1', '0876384256', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('376', '383', '12', 'Chu Lê Tuấn Anh', '1998-11-16', '1924-08-01', 'CNQP', '187', '38', '16', '1924-08-01', NULL, 'cltanh_1', '0322232065', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('377', '384', '12', 'Hoàng Văn Thắng', '1995-10-02', '1914-02-01', '3/CN', '187', '38', '16', '1914-02-01', NULL, 'hvthang_1', '0985411557', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('378', '385', '12', 'Nguyễn Thành Long', '1977-01-02', '1995-10-01', '2//', '154', '39', '16', '1995-10-01', NULL, 'ntlong_3', '0819071874', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('379', '386', '12', 'Bùi Trường Giang', '1987-04-23', '1905-09-01', '2//', '167', '39', '16', '1905-09-01', NULL, 'btgiang_1', '0125824982', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('380', '387', '12', 'Nguyễn Hải Sơn', '1990-08-10', '1908-09-01', '4/', '129', '39', '16', '1908-09-01', NULL, 'nhson_1', '0179093413', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('381', '388', '12', 'Nguyễn T Lan Anh', '1979-09-07', '1903-12-01', '1//CN', '156', '39', '16', '1903-12-01', NULL, 'ntlanh_1', '0207124562', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('382', '389', '12', 'Tống Cao Cường', '1986-11-20', '1904-10-01', '1//CN', '188', '39', '16', '1904-10-01', NULL, 'tccuong_1', '0796272523', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('383', '390', '12', 'Nguyễn Hữu Tâm', '1983-07-22', '1903-12-01', '4/CN', '189', '39', '16', '1903-12-01', NULL, 'nhtam_1', '0892586130', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `employees` VALUES ('384', '391', '12', 'Hồ Thị Hiền', '1986-06-05', '1912-02-01', 'CNQP', '189', '39', '16', '1912-02-01', NULL, 'hthien_1', '0248589887', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('385', '392', '12', 'Nguyễn T Phương Thảo', '1993-06-22', '1922-12-01', 'CNQP', '189', '39', '16', '1922-12-01', NULL, 'ntpthao_1', '0902772464', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('386', '393', '12', 'Bùi Văn Huy', '1983-10-15', '1903-02-01', '1//CN', '190', '39', '16', '1903-02-01', NULL, 'bvhuy_1', '0923392261', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('387', '394', '12', 'Phan Văn Sáng', '1978-12-21', '1903-12-01', '4/CN', '191', '39', '16', '1903-12-01', NULL, 'pvsang_1', '0516263223', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('388', '395', '12', 'Hữu Thị Thuý', '1981-05-17', '1903-12-01', '4/CN', '191', '39', '16', '1903-12-01', NULL, 'htthuy_2', '0953614147', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('389', '396', '12', 'Hà Minh Nho', '1974-08-20', '1997-03-01', '1//CN', '192', '39', '16', '1997-03-01', NULL, 'hmnho_1', '0452224717', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('390', '397', '12', 'Nguyễn Văn Đồng', '1983-09-20', '1902-03-01', '1//CN', '193', '39', '16', '1902-03-01', NULL, 'nvdong_1', '0867503215', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('391', '398', '12', 'Trần T Kim Oanh', '1982-09-12', '1903-12-01', '4/CN', '193', '39', '16', '1903-12-01', NULL, 'ttkoanh_1', '0242705724', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('392', '399', '12', 'Bùi Thị Huệ', '1991-10-22', '1916-02-01', '2/CN', '193', '39', '16', '1916-02-01', NULL, 'bthue_1', '0369050303', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('393', '400', '12', 'Bùi Đức Cảnh', '1991-12-24', '1909-09-01', '4/CN', '193', '39', '16', '1909-09-01', NULL, 'bdcanh_1', '0981009897', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('394', '401', '12', 'Trần Đức Minh', '1984-08-26', '1904-10-01', '1//CN', '194', '39', '16', '1904-10-01', NULL, 'tdminh_1', '0235416981', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('395', '402', '12', 'Vũ Đình Tùng', '1986-05-21', '1905-10-01', '1//CN', '195', '39', '16', '1905-10-01', NULL, 'vdtung_1', '0938507541', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('396', '403', '12', 'Trần Đình Tùng', '2005-12-30', '1923-12-01', '1/CN', '195', '39', '16', '1923-12-01', NULL, 'tdtung_1', '0865532942', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `employees` VALUES ('397', '404', '12', 'Đào Thị Thu Huyền', '1985-07-12', '1912-02-01', '2/CN', '195', '39', '16', '1912-02-01', NULL, 'dtthuyen_1', '0851188662', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('398', '405', '12', 'Nguyễn Văn Quyết', '1988-08-27', '1912-02-01', '2/CN', '196', '39', '16', '1912-02-01', NULL, 'nvquyet_1', '0479647317', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('399', '406', '12', 'Nguyễn Thị Thu', '1991-09-01', '1924-08-01', 'CNQP', '197', '39', '16', '1924-08-01', NULL, 'ntthu_1', '0466377681', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('400', '407', '12', 'Trần T Ngọc Anh', '1979-08-29', '1908-04-01', '3/CN', '197', '39', '16', '1908-04-01', NULL, 'ttnanh_1', '0504894870', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('401', '408', '12', 'Đỗ Văn Hưng', '1984-09-03', '1906-12-01', '2//', '154', '40', '16', '1906-12-01', NULL, 'dvhung_1', '0759356780', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('402', '409', '12', 'Nguyễn Thị Tân Miền', '1980-01-06', '1998-02-01', '2//CN', '156', '40', '16', '1998-02-01', NULL, 'nttmien_1', '0749402911', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('403', '410', '12', 'Nguyễn Ngọc Khánh', '1983-09-04', '1903-02-01', '1//CN', '198', '40', '16', '1903-02-01', NULL, 'nnkhanh_1', '0747111941', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('404', '411', '12', 'Nguyễn Dự Đáng', '1986-09-24', '1908-03-01', '4/CN', '199', '40', '16', '1908-03-01', NULL, 'nddang_1', '0528842552', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('405', '412', '12', 'Lê Văn Hội', '1992-03-21', '1916-09-01', '2/CN', '199', '40', '16', '1916-09-01', NULL, 'lvhoi_1', '0691119648', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('406', '413', '12', 'Nguyễn Kim Biển', '1984-01-29', '1903-02-01', '1//CN', '200', '40', '16', '1903-02-01', NULL, 'nkbien_1', '0666789753', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('407', '414', '12', 'Trần Mạnh Kiều', '1982-02-03', '1901-02-01', '1//CN', '201', '40', '16', '1901-02-01', NULL, 'tmkieu_1', '0567599585', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('408', '415', '12', 'Dương Bá Quyền', '1990-12-12', '1912-02-01', '1//CN', '202', '40', '16', '1912-02-01', NULL, 'dbquyen_1', '0160652051', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('409', '416', '12', 'Nguyễn Thị Tươi', '1988-07-21', '1913-03-01', '2/CN', '203', '40', '16', '1913-03-01', NULL, 'nttuoi_1', '0598612478', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('410', '417', '12', 'Bùi T Khánh Thuỳ', '1990-12-28', '1914-03-01', '2/CN', '203', '40', '16', '1914-03-01', NULL, 'btkthuy_1', '0143011185', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('411', '418', '12', 'Hà Chí Quang', '1973-07-20', '1993-02-01', '2//CN', '204', '40', '16', '1993-02-01', NULL, 'hcquang_1', '0593427613', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('412', '419', '12', 'Võ Văn Tới', '1985-11-09', '1907-03-01', '4/CN', '205', '40', '16', '1907-03-01', NULL, 'vvtoi_1', '0402324621', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `employees` VALUES ('413', '420', '12', 'Nguyễn Quang Hùng', '1998-08-16', '1924-08-01', 'CNQP', '205', '40', '16', '1924-08-01', NULL, 'nqhung_1', '0623492801', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('414', '421', '12', 'Nguyễn Quyết Tiến', '1994-06-09', '1916-09-01', '2/CN', '205', '40', '16', '1916-09-01', NULL, 'nqtien_1', '0584309319', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('415', '422', '12', 'Tạ Hồng Đăng', '1985-05-07', '1903-09-01', '2//', '154', '41', '16', '1903-09-01', NULL, 'thdang_1', '0169899494', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('416', '423', '12', 'Nguyễn Thị Hoàn', '1983-04-26', '1912-02-01', '4/CN', '156', '41', '16', '1912-02-01', NULL, 'nthoan_1', '0382964200', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('417', '424', '12', 'Nguyễn Sơn Đông', '1980-10-13', '1900-02-01', '1//CN', '206', '41', '16', '1900-02-01', NULL, 'nsdong_1', '0594966333', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('418', '425', '12', 'Nguyễn Hải Tiến', '1984-05-10', '1904-02-01', '1//CN', '207', '41', '16', '1904-02-01', NULL, 'nhtien_1', '0848739881', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('419', '426', '12', 'Trần Việt Trung', '1990-12-28', '1922-12-01', '3/CN', '207', '41', '16', '1922-12-01', NULL, 'tvtrung_1', '0796903337', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('420', '427', '12', 'Trần Thị Việt Hồng', '1982-08-08', '1903-12-01', '1//CN', '208', '41', '16', '1903-12-01', NULL, 'ttvhong_1', '0708846280', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('421', '428', '12', 'Vũ Ngọc Quỳnh', '1983-10-07', '1902-10-01', '1//CN', '172', '41', '16', '1902-10-01', NULL, 'vnquynh_1', '0942796252', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('422', '429', '12', 'Thái Thị Âu', '1987-05-29', '1912-02-01', '2/CN', '172', '41', '16', '1912-02-01', NULL, 'ttau_1', '0432349672', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('423', '430', '12', 'Nguyễn Thuỳ Linh', '1984-10-20', '1912-02-01', '1//CN', '172', '41', '16', '1912-02-01', NULL, 'ntlinh_1', '0809279913', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('424', '431', '12', 'Nguyễn Thị Mai', '1994-07-18', '1922-12-01', 'CNQP', '172', '41', '16', '1922-12-01', NULL, 'ntmai_1', '0830779297', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('425', '432', '12', 'Hoàng Văn Thành', '1983-06-08', '1901-09-01', '2//', '154', '42', '16', '1901-09-01', NULL, 'hvthanh_1', '0230072104', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('426', '433', '12', 'Vũ Thị Liên', '1982-12-15', '1905-04-01', '1//CN', '156', '42', '16', '1905-04-01', NULL, 'vtlien_1', '0302047146', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('427', '434', '12', 'Khuất Duy Mạnh', '1982-08-30', '1903-02-01', '1//CN', '209', '42', '16', '1903-02-01', NULL, 'kdmanh_1', '0169893401', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('428', '435', '12', 'Nguyễn Thị Duyên', '1992-02-16', '1923-12-01', '2/CN', '210', '42', '16', '1923-12-01', NULL, 'ntduyen_1', '0276938285', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `employees` VALUES ('429', '436', '12', 'Nông Thị Thuý', '1987-02-12', '1913-03-01', '2/CN', '210', '42', '16', '1913-03-01', NULL, 'ntthuy_2', '0289326535', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `employees` VALUES ('430', '437', '12', 'Đinh Thị Thành', '1988-01-15', '1915-03-01', '2/CN', '210', '42', '16', '1915-03-01', NULL, 'dtthanh_1', '0929373274', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `employees` VALUES ('431', '438', '12', 'Lương T Thanh Loan', '1986-11-13', '1924-08-01', 'CNQP', '210', '42', '16', '1924-08-01', NULL, 'lttloan_1', '0122932472', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `employees` VALUES ('432', '439', '12', 'Phan Thanh Trường', '1975-08-18', '1997-01-01', '1//CN', '211', '42', '16', '1997-01-01', NULL, 'pttruong_1', '0768382946', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `employees` VALUES ('433', '440', '12', 'Mai Hồng Sơn', '1971-01-02', '1992-02-01', '1//CN', '212', '42', '16', '1992-02-01', NULL, 'mhson_1', '0194362109', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `employees` VALUES ('434', '441', '12', 'Nguyễn Thái Bình', '1981-03-11', '1900-02-01', '4/CN', '213', '42', '16', '1900-02-01', NULL, 'ntbinh_1', '0282706762', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `employees` VALUES ('435', '442', '12', 'Nguyễn Thanh Bình', '1972-07-20', '1995-02-01', 'CNQP', '213', '42', '16', '1995-02-01', NULL, 'ntbinh_2', '0225902222', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `employees` VALUES ('436', '443', '12', 'Trần Ngọc Quang', '1983-09-09', '1902-03-01', '4/CN', '213', '42', '16', '1902-03-01', NULL, 'tnquang_1', '0274892898', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `employees` VALUES ('437', '444', '12', 'Phạm Trường Giang', '1976-03-08', '1994-10-01', '3//', '154', '43', '16', '1994-10-01', NULL, 'ptgiang_1', '0429922694', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `employees` VALUES ('438', '445', '12', 'Nguyễn Thị Thảo', '1975-10-17', '1993-02-01', '2//CN', '156', '43', '16', '1993-02-01', NULL, 'ntthao_1', '0891117108', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `employees` VALUES ('439', '446', '12', 'Bùi Văn Khởi', '1965-08-13', '1999-03-01', 'CNQP', '214', '43', '16', '1999-03-01', NULL, 'bvkhoi_1', '0231326199', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `employees` VALUES ('440', '447', '12', 'Cao Văn Tuyển', '1985-04-24', '1903-10-01', '1//CN', '214', '43', '16', '1903-10-01', NULL, 'cvtuyen_1', '0136937153', '1', 'Địa chỉ quân đội', '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);

-- Structure for table `failed_jobs`
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `fingerprints`
DROP TABLE IF EXISTS `fingerprints`;
CREATE TABLE `fingerprints` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint unsigned NOT NULL,
  `date` date NOT NULL,
  `log` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `check_in` time DEFAULT NULL,
  `check_out` time DEFAULT NULL,
  `is_checked` tinyint(1) NOT NULL DEFAULT '0',
  `excuse` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fingerprints_employee_id_foreign` (`employee_id`),
  CONSTRAINT `fingerprints_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `holidays`
DROP TABLE IF EXISTS `holidays`;
CREATE TABLE `holidays` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `note` longtext COLLATE utf8mb4_unicode_ci,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `imports`
DROP TABLE IF EXISTS `imports`;
CREATE TABLE `imports` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_ext` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `details` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `total` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `jobs`
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `progress` int unsigned NOT NULL DEFAULT '0',
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `leaves`
DROP TABLE IF EXISTS `leaves`;
CREATE TABLE `leaves` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_instantly` tinyint(1) NOT NULL,
  `is_accumulative` tinyint(1) NOT NULL,
  `discount_rate` int NOT NULL,
  `days_limit` int NOT NULL,
  `minutes_limit` int NOT NULL,
  `notes` longtext COLLATE utf8mb4_unicode_ci,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `leaves`
INSERT INTO `leaves` VALUES ('1', 'Nghỉ Ốm', '0', '0', '0', '30', '0', 'Nghỉ ốm theo quy định', 'System', 'System', NULL, '2025-09-03 12:58:46', '2025-09-03 12:58:46', NULL);
INSERT INTO `leaves` VALUES ('2', 'Nghỉ Việc cá nhân', '0', '0', '0', '15', '0', 'Nghỉ việc cá nhân theo quy định', 'System', 'System', NULL, '2025-09-03 12:58:46', '2025-09-03 12:58:46', NULL);

-- Structure for table `messages`
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint unsigned DEFAULT NULL,
  `text` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_sent` tinyint(1) NOT NULL DEFAULT '0',
  `error` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `messages_employee_id_foreign` (`employee_id`),
  CONSTRAINT `messages_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `migrations`
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `migrations`
INSERT INTO `migrations` VALUES ('64', '2013_11_01_131410_create_contracts_table', '1');
INSERT INTO `migrations` VALUES ('65', '2013_11_01_132154_create_employees_table', '1');
INSERT INTO `migrations` VALUES ('66', '2014_10_12_000000_create_users_table', '1');
INSERT INTO `migrations` VALUES ('67', '2014_10_12_100000_create_password_reset_tokens_table', '1');
INSERT INTO `migrations` VALUES ('68', '2014_10_12_100000_create_password_resets_table', '1');
INSERT INTO `migrations` VALUES ('69', '2014_10_12_200000_add_two_factor_columns_to_users_table', '1');
INSERT INTO `migrations` VALUES ('70', '2019_08_19_000000_create_failed_jobs_table', '1');
INSERT INTO `migrations` VALUES ('71', '2019_12_14_000001_create_personal_access_tokens_table', '1');
INSERT INTO `migrations` VALUES ('72', '2023_10_19_112718_create_sessions_table', '1');
INSERT INTO `migrations` VALUES ('73', '2023_11_02_105426_create_settings_table', '1');
INSERT INTO `migrations` VALUES ('74', '2023_11_02_114106_create_leaves_table', '1');
INSERT INTO `migrations` VALUES ('75', '2023_11_02_114945_create_positions_table', '1');
INSERT INTO `migrations` VALUES ('76', '2023_11_02_120331_create_holidays_table', '1');
INSERT INTO `migrations` VALUES ('77', '2023_11_02_121209_create_centers_table', '1');
INSERT INTO `migrations` VALUES ('78', '2023_11_02_122959_create_center_holiday_table', '1');
INSERT INTO `migrations` VALUES ('79', '2023_11_02_123831_create_fingerprints_table', '1');
INSERT INTO `migrations` VALUES ('80', '2023_11_02_124645_create_discounts_table', '1');
INSERT INTO `migrations` VALUES ('81', '2023_11_02_133032_create_departments_table', '1');
INSERT INTO `migrations` VALUES ('82', '2023_11_02_133459_create_employee_leave_table', '1');
INSERT INTO `migrations` VALUES ('83', '2023_11_02_140207_create_timelines_table', '1');
INSERT INTO `migrations` VALUES ('84', '2023_11_10_162228_create_messages_table', '1');
INSERT INTO `migrations` VALUES ('85', '2023_11_26_092207_create_notifications_table', '1');
INSERT INTO `migrations` VALUES ('86', '2023_12_01_195938_create_jobs_table', '1');
INSERT INTO `migrations` VALUES ('87', '2023_12_01_205218_create_imports_table', '1');
INSERT INTO `migrations` VALUES ('88', '2024_04_16_105426_create_changelogs_table', '1');
INSERT INTO `migrations` VALUES ('89', '2024_04_16_111956_create_permission_tables', '1');
INSERT INTO `migrations` VALUES ('90', '2024_04_30_115612_create_assets_table', '1');
INSERT INTO `migrations` VALUES ('91', '2024_05_05_134550_create_categories_table', '1');
INSERT INTO `migrations` VALUES ('92', '2024_05_05_134557_create_sub_categories_table', '1');
INSERT INTO `migrations` VALUES ('93', '2024_05_06_113204_create_category_sub_category_table', '1');
INSERT INTO `migrations` VALUES ('94', '2024_07_10_100000_create_transitions_table', '1');
INSERT INTO `migrations` VALUES ('95', '2025_05_20_092754_create_message_bulks_table', '1');
INSERT INTO `migrations` VALUES ('97', '2025_09_03_053455_add_is_sequent_to_timelines_table', '2');
INSERT INTO `migrations` VALUES ('98', '2025_09_03_054400_restructure_employees_table', '3');
INSERT INTO `migrations` VALUES ('99', '2025_09_03_120052_update_employee_leaves_table_for_approval_workflow', '4');
INSERT INTO `migrations` VALUES ('100', '2025_09_04_050454_add_signature_path_to_users_table', '5');
INSERT INTO `migrations` VALUES ('101', '2025_09_04_112514_add_cccd_birth_enlist_to_users_table', '6');
INSERT INTO `migrations` VALUES ('102', '2025_09_04_125256_add_leave_balance_to_employees_table', '7');
INSERT INTO `migrations` VALUES ('103', '2025_09_04_133132_add_leave_tracking_fields_to_employees_table', '8');
INSERT INTO `migrations` VALUES ('104', '2025_09_04_032652_rename_email_to_username_in_users_table', '9');
INSERT INTO `migrations` VALUES ('105', '2025_09_04_062951_create_vehicles_table', '9');
INSERT INTO `migrations` VALUES ('106', '2025_09_04_062953_create_vehicle_registrations_table', '9');
INSERT INTO `migrations` VALUES ('107', '2025_09_04_122957_change_employee_id_to_varchar_in_employee_leave_table', '9');

-- Structure for table `model_has_permissions`
DROP TABLE IF EXISTS `model_has_permissions`;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `model_has_roles`
DROP TABLE IF EXISTS `model_has_roles`;
CREATE TABLE `model_has_roles` (
  `role_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `model_has_roles`
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '197');
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '198');
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '199');
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '200');
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '201');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '202');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '203');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '204');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '205');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '206');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '207');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '208');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '209');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '210');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '211');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '212');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '213');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '214');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '215');
INSERT INTO `model_has_roles` VALUES ('17', 'App\\Models\\User', '215');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '216');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '217');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '218');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '219');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '220');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '221');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '222');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '223');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '224');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '225');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '226');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '227');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '228');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '229');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '230');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '231');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '232');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '233');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '234');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '235');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '236');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '237');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '238');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '239');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '240');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '241');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '242');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '243');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '244');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '245');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '246');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '247');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '248');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '249');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '250');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '251');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '252');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '253');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '254');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '255');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '256');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '257');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '258');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '259');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '260');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '261');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '262');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '263');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '264');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '265');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '266');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '267');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '268');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '269');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '270');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '271');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '272');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '273');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '274');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '275');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '276');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '277');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '278');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '279');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '280');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '281');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '282');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '283');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '284');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '285');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '286');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '287');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '288');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '289');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '290');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '291');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '292');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '293');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '294');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '295');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '296');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '297');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '298');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '299');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '300');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '301');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '302');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '303');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '304');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '305');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '306');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '307');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '308');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '309');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '310');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '311');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '312');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '313');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '314');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '315');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '316');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '317');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '318');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '319');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '320');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '321');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '322');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '323');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '324');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '325');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '326');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '327');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '328');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '329');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '330');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '331');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '332');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '333');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '334');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '335');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '336');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '337');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '338');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '339');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '340');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '341');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '342');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '343');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '344');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '345');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '346');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '347');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '348');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '349');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '350');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '351');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '352');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '353');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '354');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '355');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '356');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '357');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '358');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '359');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '360');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '361');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '362');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '363');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '364');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '365');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '366');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '367');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '368');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '369');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '370');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '371');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '372');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '373');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '374');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '375');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '376');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '377');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '378');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '379');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '380');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '381');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '382');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '383');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '384');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '385');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '386');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '387');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '388');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '389');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '390');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '391');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '392');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '393');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '394');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '395');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '396');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '397');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '398');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '399');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '400');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '401');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '402');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '403');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '404');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '405');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '406');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '407');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '408');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '409');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '410');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '411');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '412');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '413');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '414');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '415');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '416');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '417');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '418');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '419');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '420');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '421');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '422');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '423');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '424');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '425');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '426');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '427');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '428');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '429');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '430');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '431');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '432');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '433');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '434');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '435');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '436');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '437');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '438');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '439');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '440');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '441');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '442');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '443');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '444');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '445');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '446');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '447');
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '448');

-- Structure for table `notifications`
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` bigint unsigned NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `password_reset_tokens`
DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `password_resets`
DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `permissions`
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `personal_access_tokens`
DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `positions`
DROP TABLE IF EXISTS `positions`;
CREATE TABLE `positions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vacancies_count` int NOT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `positions`
INSERT INTO `positions` VALUES ('103', 'Giám đốc', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('104', 'Chính uỷ', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('105', 'P.Giám đốc', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('106', 'Chờ hưu từ 01/11/24', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('107', 'Trưởng phòng', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('108', 'P. Trưởng phòng', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('109', 'TL Quân sự', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('110', 'TL Quân lực', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('111', 'TL Kế hoạch', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('112', 'NV Văn thư, bảo mật', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('113', 'NV Thông tin', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('114', 'NV lao động tiền lương', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('115', 'NV điều độ SX', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('116', 'NV Quân lực', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('117', 'NV Thống kê', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('118', 'TT Tổ bảo vệ-PCCC', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('119', 'NV bảo vệ', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('120', 'Đội trưởng đội xe', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('121', 'Lái xe', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('122', 'Trưởng Ban', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('123', 'Phó Trưởng Ban', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('124', 'Trợ lý Chính trị', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('125', 'NV Chính trị', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('126', 'P Trưởng phòng', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('127', 'Trạm trưởng Spyder', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('128', 'P.Trạm trưởng Spyder', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('129', 'Trợ lý KT', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('130', 'NV thư viện KT', '1', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `positions` VALUES ('131', 'NV kỹ thuật', '1', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `positions` VALUES ('132', 'NV Cơ điện', '1', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `positions` VALUES ('133', 'Tổ trưởng', '1', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `positions` VALUES ('134', 'Thợ cơ điện', '1', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `positions` VALUES ('135', 'TL Kỹ thuật', '1', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `positions` VALUES ('136', 'NV Tiếp liệu', '1', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `positions` VALUES ('137', 'Thủ kho VTKT', '1', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `positions` VALUES ('138', 'NV KCS Bệ phóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('139', 'NV KCS Đài Điều khiển', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('140', 'NV KCS kíp đạn', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('141', 'NV KCS Xe máy-TNĐ', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('142', 'NV KCS', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('143', 'NV KCS Cơ khí', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('144', 'NV kế toán', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('145', 'NV thủ quỹ', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('146', 'Phó Trưởng phòng', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('147', 'NV Doanh trại', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('148', 'NV Quản lý', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('149', 'NV nấu ăn, tiếp phẩm', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('150', 'NV Nhà khách', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('151', 'NV nấu ăn', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('152', 'Y sỹ', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('153', 'Y tá, nấu ăn', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('154', 'Quản đốc', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('155', 'Phó Quản đốc', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('156', 'NV điều độ', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('157', 'TT Tổ lắp ráp, SC khối', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('158', 'Thợ lắp ráp, SC khối', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('159', 'Thợ lắp ráp,  SC khối', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('160', 'TT Tổ SC Đài ĐK S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('161', 'Thợ SC Đài ĐK S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('162', 'TT Tổ Đài điều khiển S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('163', 'Thợ Đài điều khiển S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('164', 'TT Tổ SC xe AKKOR', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('165', 'TT Tổ SC cơ khí an ten', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('166', 'Thợ SC cơ khí an ten', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('167', 'Phó QĐ', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('168', 'TT Tổ Thợ SC điện bệ phóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('169', 'Thợ SC điện bệ phóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('170', 'TT Tổ SC cơ khí bệ phóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('171', 'Thợ SC cơ khí bệ phóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('172', 'Thợ SC vôn kế, đồng hồ', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('173', 'TT Tổ SC xe khí nén', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('174', 'TT Tổ SC xe nạp chất \"O, G\"', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('175', 'Thợ xe nạp chất \"O, G\"', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('176', 'TT Tổ SC dây chuyền dKT', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('177', 'TT Tổ cơ khí nguội', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('178', 'TT Tổ cơ khí cắt gọt', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('179', 'Thợ cơ khí cắt gọt', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('180', 'TT Tổ SC gia công cơ khí', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('181', 'Thợ gia công cơ khí', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('182', 'TT Tổ ép nhựa, mạ', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('183', 'Thợ ép nhựa, mạ', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('184', 'Thợ mộc', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('185', 'TT Tổ mộc', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('186', 'TT Tổ SC gầm vỏ', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('187', 'Thợ gầm vỏ', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('188', 'TT Tổ SC Đạn TL S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('189', 'Thợ SC Đạn TL S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('190', 'TT Tổ SC Đạn TL S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('191', 'Thợ SC Đạn TL S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('192', 'TT Tổ SC kíp S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('193', 'Thợ SC kíp S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('194', 'TT Tổ SC kíp S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('195', 'Thợ SC kíp S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('196', 'TT Tổ sơn, bao gói', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('197', 'Thợ sơn bao gói', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('198', 'TT Tổ SC trạm nguồn', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('199', 'Thợ SC trạm ngồn', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('200', 'TT tổ SC động cơ', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('201', 'Thợ SC động cơ', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('202', 'TT Tổ SC điện xe máy', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('203', 'Thợ SC điện xe máy', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('204', 'TT Tổ SC ô tô', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('205', 'Thợ SC ô tô', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('206', 'TT Tổ vô tuyến hiện sóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `positions` VALUES ('207', 'Thợ vô tuyến hiện sóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `positions` VALUES ('208', 'TT Tổ SC vôn kế, đồng hồ', '1', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `positions` VALUES ('209', 'TT Tổ SC động cơ EMU, MI', '1', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `positions` VALUES ('210', 'Thợ SC động cơ EMU, MI', '1', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `positions` VALUES ('211', 'TT Tổ SC Biến thế, tẩm sấy', '1', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `positions` VALUES ('212', 'TT Tổ Sơn tổng hợp', '1', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `positions` VALUES ('213', 'Thợ sơn tổng hợp', '1', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `positions` VALUES ('214', 'Thợ hóa nghiệm
nhiên liệu \"O, G\"', '1', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);

-- Structure for table `role_has_permissions`
DROP TABLE IF EXISTS `role_has_permissions`;
CREATE TABLE `role_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `roles`
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `roles`
INSERT INTO `roles` VALUES ('13', 'Admin', 'web', '2025-09-03 04:47:33', '2025-09-03 04:47:33');
INSERT INTO `roles` VALUES ('14', 'HR', 'web', '2025-09-03 04:47:33', '2025-09-03 04:47:33');
INSERT INTO `roles` VALUES ('15', 'AM', 'web', '2025-09-03 04:47:33', '2025-09-03 04:47:33');
INSERT INTO `roles` VALUES ('16', 'CC', 'sanctum', '2025-09-04 10:45:10', '2025-09-04 10:45:10');
INSERT INTO `roles` VALUES ('17', 'CC', 'web', '2025-09-04 10:47:22', '2025-09-04 10:47:22');

-- Structure for table `sessions`
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `sessions`
INSERT INTO `sessions` VALUES ('TxtiEzn2HoYuAbYXCaCDjyAS64F7OAHX6UvTSKEC', '203', '172.19.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36 Edg/139.0.0.0', 'YTo2OntzOjY6Il90b2tlbiI7czo0MDoidmMzU0ZNdllLY0pGaXI1OXJwbmE0WjdTZENYZ25kdmNmR0c1Q01LYyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czozOiJ1cmwiO2E6MDp7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjI5OiJodHRwOi8vbG9jYWxob3N0L3VzZXIvcHJvZmlsZSI7fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjIwMztzOjIxOiJwYXNzd29yZF9oYXNoX3NhbmN0dW0iO3M6NjA6IiQyeSQxMCRqTGRsVGFOaHhINUF0MGYySDFXSWdlZE16Y1V3RzRhdkkwYjJIcFJYSE1JQ2NsWGJmdVRhRyI7fQ==', '1756973140');

-- Structure for table `settings`
DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sms_api_sender` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sms_api_username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sms_api_password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `sub_categories`
DROP TABLE IF EXISTS `sub_categories`;
CREATE TABLE `sub_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sub_categories_category_id_foreign` (`category_id`),
  CONSTRAINT `sub_categories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `timelines`
DROP TABLE IF EXISTS `timelines`;
CREATE TABLE `timelines` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `center_id` bigint unsigned NOT NULL,
  `department_id` bigint unsigned NOT NULL,
  `position_id` bigint unsigned NOT NULL,
  `employee_id` bigint unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `notes` longtext COLLATE utf8mb4_unicode_ci,
  `is_sequent` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `timelines_center_id_foreign` (`center_id`),
  KEY `timelines_department_id_foreign` (`department_id`),
  KEY `timelines_position_id_foreign` (`position_id`),
  KEY `timelines_employee_id_foreign` (`employee_id`),
  CONSTRAINT `timelines_center_id_foreign` FOREIGN KEY (`center_id`) REFERENCES `centers` (`id`),
  CONSTRAINT `timelines_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  CONSTRAINT `timelines_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  CONSTRAINT `timelines_position_id_foreign` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `transitions`
DROP TABLE IF EXISTS `transitions`;
CREATE TABLE `transitions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` bigint unsigned NOT NULL,
  `employee_id` bigint unsigned NOT NULL,
  `handed_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `center_document_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` longtext COLLATE utf8mb4_unicode_ci,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transitions_center_document_number_unique` (`center_document_number`),
  KEY `transitions_asset_id_foreign` (`asset_id`),
  KEY `transitions_employee_id_foreign` (`employee_id`),
  CONSTRAINT `transitions_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `transitions_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `users`
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cccd` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Số căn cước công dân',
  `date_of_birth` date DEFAULT NULL COMMENT 'Ngày sinh',
  `enlist_date` date DEFAULT NULL COMMENT 'Ngày nhập ngũ',
  `mobile_verified_at` timestamp NULL DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `two_factor_secret` text COLLATE utf8mb4_unicode_ci,
  `two_factor_recovery_codes` text COLLATE utf8mb4_unicode_ci,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_photo_path` varchar(2048) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signature_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_mobile_unique` (`mobile`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_employee_id_foreign` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=450 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `users`
INSERT INTO `users` VALUES ('197', 'Phạm Đức Giang', 'pdgiang', NULL, NULL, NULL, NULL, NULL, 'pdgiang', '2025-09-03 04:47:33', '$2y$10$7cddMrph/1QVObpcIE9kB.3SQ1JYexIF8ktBTA8nKkT1WhOpFl4QS', NULL, NULL, '0EdsCizUgcWGXohhGmAHB9aIsC0c2N2D4VggqhukxRviy1lUWJOolNPDcxvw', NULL, 'signatures/signature_197_1757003266.png', 'System', 'Phạm Đức Giang', NULL, '2025-09-03 04:47:33', '2025-09-04 19:27:46', NULL);
INSERT INTO `users` VALUES ('198', 'Hà Tiến Thụy', 'htthuy', NULL, NULL, NULL, NULL, NULL, 'htthuy', '2025-09-03 04:47:33', '$2y$10$qgS83/m7QQIwz2W5h/muNOUQ35KbaCy7ZGYD2HrqOWFa7xpZ8kH0u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `users` VALUES ('199', 'Cao Anh Hùng', 'cahung', NULL, NULL, NULL, NULL, NULL, 'cahung', '2025-09-03 04:47:33', '$2y$10$mMT.XMXg.zFGasI25L89Pe6B8YK44BVSIBkWELW1R0ocI/U4.T.oy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `users` VALUES ('200', 'Bùi Tân Chinh', 'btchinh', NULL, NULL, NULL, NULL, NULL, 'btchinh', '2025-09-03 04:47:33', '$2y$10$lGsbspWuRJeVyuHkj/vCquxduZ7K1xPLiiY7cskivxAfxjOxIyEWS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `users` VALUES ('201', 'Nguyễn Văn  Bảy', 'nvbay', NULL, NULL, NULL, NULL, NULL, 'nvbay', '2025-09-03 04:47:33', '$2y$10$6/tx/MPrN3q5cZ4EYiMIPOsVn6vdZsn29q6CHQf0c7h9nq1hD0DBm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `users` VALUES ('202', 'Phạm Ngọc Sơn', 'pnson', NULL, NULL, NULL, NULL, NULL, 'pnson', '2025-09-03 04:47:33', '$2y$10$Ir1YCThDr1NWZaAqjM2kpOLVDJeMzPyrGAZbJdGG0zTZ7b85fP5T.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `users` VALUES ('203', 'Nguyễn Đình Sự', 'ndsu', NULL, NULL, NULL, NULL, NULL, 'ndsu', '2025-09-03 04:47:33', '$2y$10$yiYg3Xz04Tum0PyDVS1ye.WJbUBvIOoTduR.zOao5VShscGR6.pjG', NULL, NULL, 'I3HR2soZ1MZ2ju1ul4sJ4HRFSbWmFziZ4zg1Y7ajQvurXuUt0UgoOy30yv89', 'profile-photos/avatar_203_1757001949.png', 'signatures/signature_203_1756973855.png', 'System', 'Nguyễn Đình Sự', NULL, '2025-09-03 04:47:33', '2025-09-04 19:05:49', NULL);
INSERT INTO `users` VALUES ('204', 'Phạm Tiến Long', 'ptlong', NULL, NULL, NULL, NULL, NULL, 'ptlong', '2025-09-03 04:47:34', '$2y$10$vYCzXs2j/Ysx6Omti4uEZufJ1S.k6nGTc0L74tQP9MnHYjQmh0Y5u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('205', 'Đặng Đình Quỳnh', 'ddquynh', NULL, NULL, NULL, NULL, NULL, 'ddquynh', '2025-09-03 04:47:34', '$2y$10$3vxEhjdD06nDG7MLt35u.OJVN9bkpWDcOMJm4prjwEu3tYcivvjVi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('206', 'Lục Viết Hợp', 'lvhop', NULL, NULL, NULL, NULL, NULL, 'lvhop', '2025-09-03 04:47:34', '$2y$10$erfIZ2YHp/Wm67vxLLPLAOuqPN5Ef1Kxw0J3nI0PFxSZuPNObgEte', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('207', 'Trần Đình Tài', 'tdtai', NULL, NULL, NULL, NULL, NULL, 'tdtai', '2025-09-03 04:47:34', '$2y$10$tg3RM13YSn6xDKmxOaAfkenUt77z0KYayPp1BEiuli9KrIfdVIeSi', NULL, NULL, 'JKWqxj5czVq1NlqWvtWJvKRMVD1MiWdZBUzZezik6x78Lbkn4f409MuC2mD0', NULL, NULL, 'System', 'Trần Đình Tài', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('208', 'Trịnh Thị Thuý Hà', 'tttha', NULL, NULL, NULL, NULL, NULL, 'tttha', '2025-09-03 04:47:34', '$2y$10$1.PiFXIVJxEJo27mlMGMYehPRGJ.tAsW9s.D1Q6XcYTYc.yEcINOy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('209', 'Trịnh Văn Cương', 'tvcuong', NULL, NULL, NULL, NULL, NULL, 'tvcuong', '2025-09-03 04:47:34', '$2y$10$QNhAv94GQOo7OGPP3ezFOemOSqS7xASeNdwJ0TlTRXf.jVvDRbai6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('210', 'Nguyễn T Thu Hà', 'nttha', NULL, NULL, NULL, NULL, NULL, 'nttha', '2025-09-03 04:47:34', '$2y$10$ZUOl/f3U5ZAIhax6nbaCuOZicy10m/2z4LdH2hYJmDzpnJN7ErbIO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('211', 'Vũ Thành Trung', 'vttrung', NULL, NULL, NULL, NULL, NULL, 'vttrung', '2025-09-03 04:47:34', '$2y$10$y.NZHDwMcFcjbA0npcoDqOphgBlbg9iuSjQJqvemkBSKFCLV1Y.Eq', NULL, NULL, 'zYUii9CZYLQkLYrWC3UzuQGBiqqK9V7x5echyXLixPD6VoYlD2CHA5pmgaYn', NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('212', 'Phạm Thị Thuý', 'ptthuy', NULL, NULL, NULL, NULL, NULL, 'ptthuy', '2025-09-03 04:47:34', '$2y$10$wPNKHLkhlA7mAUP.iANFBefGe1VI7BWtpjNtfvuJdfroAs52C7/Au', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('213', 'Phạm Thị Trà', 'pttra', NULL, NULL, NULL, NULL, NULL, 'pttra', '2025-09-03 04:47:34', '$2y$10$kxbrP/VVey9lu1296AYSRuToRG6H1I9AF7SZWV8TLwVADgaA2Dg0O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('214', 'Vũ Thanh Hà', 'vtha', NULL, NULL, NULL, NULL, NULL, 'vtha', '2025-09-03 04:47:34', '$2y$10$tgmg29ZXo7H0s.6hKOg9duUymaDFQHrDECCfjoB9.xC/iOYdYwW0G', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('215', 'Nguyễn Địch Linh', 'ndlinh', NULL, NULL, NULL, NULL, NULL, 'ndlinh', '2025-09-03 04:47:34', '$2y$10$AGcg9U.xakuK0BDncay1KOIwsRKdlMOczHCVYBvI.C4u7mEhe2mfS', NULL, NULL, 'y2LgwVkPzJ9HvADDZo5IWcuaIhFJVbw29s82uTY2J6JURqCV2j7u18JFRpu8', NULL, NULL, 'System', 'Nguyễn Địch Linh', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('216', 'Tạ Quốc Bảo', 'tqbao', NULL, NULL, NULL, NULL, NULL, 'tqbao', '2025-09-03 04:47:34', '$2y$10$L65kGU6fMcIH171kgUtDHuUnVQEGt5t55uhoh7LVmBtKrIScz8esS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('217', 'Trần Ngọc Liễu', 'tnlieu', NULL, NULL, NULL, NULL, NULL, 'tnlieu', '2025-09-03 04:47:34', '$2y$10$bL9wxBo.4e7PHmyjpwKl3elLUKCkzRdcKYp9UcEPW5KC8noMgVuFO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `users` VALUES ('218', 'Nguyễn T Thu Thanh', 'nttthanh', NULL, NULL, NULL, NULL, NULL, 'nttthanh', '2025-09-03 04:47:35', '$2y$10$V0HS/gAWo3TN6LG2Wprige//hvNFtMbgQf5Kfm1i6jGJ97Ncw0DqS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('219', 'Trần Hữu Ngọc', 'thngoc', NULL, NULL, NULL, NULL, NULL, 'thngoc', '2025-09-03 04:47:35', '$2y$10$79g6aVoJ49hFozG8tWwmeOBxI2ES2gCmy3M98zwb64WrVAedql.Wm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('220', 'Nguyễn Minh Thanh', 'nmthanh', NULL, NULL, NULL, NULL, NULL, 'nmthanh', '2025-09-03 04:47:35', '$2y$10$jyLH4Z9fPsphuae/r0CEC.HU2cnfqT0FeJzmZz3ZrMt5Y72g1RAQi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('221', 'Nông Tiến Tân', 'nttan', NULL, NULL, NULL, NULL, NULL, 'nttan', '2025-09-03 04:47:35', '$2y$10$J8Uxch12KxUKrhQ8hU9T7eqv6BpZ0m02JA0EI9r34dXQaCpGkBWLa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('222', 'Nguyễn Trọng Toàn', 'nttoan', NULL, NULL, NULL, NULL, NULL, 'nttoan', '2025-09-03 04:47:35', '$2y$10$QJq2gLDAV73IDNw//LPEPu3mmE55EiIqBcwvCauqy3s50NBV30KCK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('223', 'Phạm Văn Bảy', 'pvbay', NULL, NULL, NULL, NULL, NULL, 'pvbay', '2025-09-03 04:47:35', '$2y$10$66timw94PkmnQDQtDGlOTeZZaT2WhpNKEqlv5jLzO9Ai/ff9g/bzu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('224', 'Phạm Văn Tặng', 'pvtang', NULL, NULL, NULL, NULL, NULL, 'pvtang', '2025-09-03 04:47:35', '$2y$10$uZnawl7eR9oLkRUveyJBVuU0jC2OvYMJHb3.Fh2NEp4ELreJzzakq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('225', 'Bùi Thanh Quân', 'btquan', NULL, NULL, NULL, NULL, NULL, 'btquan', '2025-09-03 04:47:35', '$2y$10$ptDGjoi0eNxahiNEqR4bwuK5.Kja2.q7qruZT0Gb6hYb58ZcN4IPi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('226', 'Vũ Hữu Hải', 'vhhai', NULL, NULL, NULL, NULL, NULL, 'vhhai', '2025-09-03 04:47:35', '$2y$10$El6t6OE31qESQvYEUq9neu3QLKzm7ERZd5V6pXudGsoCnSkFWZBwG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('227', 'Lê Ngọc Duy', 'lnduy', NULL, NULL, NULL, NULL, NULL, 'lnduy', '2025-09-03 04:47:35', '$2y$10$4HJXyNrjewf0ybKD1p7P.eXuW0WykdDi/rlk262uTMQyGI2zqsft.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('228', 'Nguyễn Văn Thắng', 'nvthang', NULL, NULL, NULL, NULL, NULL, 'nvthang', '2025-09-03 04:47:35', '$2y$10$96LgbPMXZZDKmtj7HTLhb.Xr2y4PrsGgUcxBMjScxXf6FEuV6dApa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('229', 'Nguyễn Tiến Cường', 'ntcuong', NULL, NULL, NULL, NULL, NULL, 'ntcuong', '2025-09-03 04:47:35', '$2y$10$jznvLcu/JGEg/LwUVA60RuHsUmL3vBTIzUykHE/Vd37nRGYyFCFAO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('230', 'Hoàng Văn Tình', 'hvtinh', NULL, NULL, NULL, NULL, NULL, 'hvtinh', '2025-09-03 04:47:35', '$2y$10$zU0LFMSk.5Pqqf6EEY8pou5LqLv//h7tbgB4KRgWOi/mNF2sDByda', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('231', 'Hoàng Anh Đức', 'haduc', NULL, NULL, NULL, NULL, NULL, 'haduc', '2025-09-03 04:47:35', '$2y$10$I2JYJZvU9QSDsZSUI8RAQOmedVxD/h7tnD47dEL1WrRlyH1oO7OAO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('232', 'Hoàng Bảo Chung', 'hbchung', NULL, NULL, NULL, NULL, NULL, 'hbchung', '2025-09-03 04:47:35', '$2y$10$QS1RvbdiEoEm/2wp5Xupv.5x8/zA845Sw/VNN/eJ6zRd44yTMI1fu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('233', 'Phạm Thị Thu Hương', 'ptthuong', NULL, NULL, NULL, NULL, NULL, 'ptthuong', '2025-09-03 04:47:35', '$2y$10$W6.ixzQW7WpwUHklHQd8Gue2hg0a5ayV0R2cqLJkQVZ3KC3pWutrq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `users` VALUES ('234', 'Phan Minh Nghĩa', 'pmnghia', NULL, NULL, NULL, NULL, NULL, 'pmnghia', '2025-09-03 04:47:36', '$2y$10$FpUNUeSOBdPmaandM3yeJujdOluN4CPiX95V.zzAep.2U7ep5HR2q', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('235', 'Nguyễn Trung Kiên', 'ntkien', NULL, NULL, NULL, NULL, NULL, 'ntkien', '2025-09-03 04:47:36', '$2y$10$mJS0bJ1/UN8q6VKcSoxboeMwGGlcOZx118ZlZnene3.RHH8sb.dtm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('236', 'Nguyễn Văn Thắng', 'nvthang_1', NULL, NULL, NULL, NULL, NULL, 'nvthang_1', '2025-09-03 04:47:36', '$2y$10$zs5WKG8cCYLFwMxILmpove3B11FgmDL6LnvmqZ0pjwb5m1JKS2F7W', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('237', 'Đặng Trọng Chánh', 'dtchanh', NULL, NULL, NULL, NULL, NULL, 'dtchanh', '2025-09-03 04:47:36', '$2y$10$eW3kca2GwVWlQVmU43rrtupRA0AoJ6Y5A8nrpMccT8ZOCNG/hQXw2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('238', 'Nguyễn Minh Hiếu', 'nmhieu', NULL, NULL, NULL, NULL, NULL, 'nmhieu', '2025-09-03 04:47:36', '$2y$10$.hHMQuQPhX/gYe7gE/RBlesXM4hTba9J3oHPy/qX7ZHXcGeUkgdnu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('239', 'Bùi Thị Nhật Lệ', 'btnle', NULL, NULL, NULL, NULL, NULL, 'btnle', '2025-09-03 04:47:36', '$2y$10$SHjk2lPM1pI1cTo3waMVL.6hu2D8kL0HhUprw8hiYJcIedCEf6wuS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('240', 'Nguyễn Văn Ngà', 'nvnga', NULL, NULL, NULL, NULL, NULL, 'nvnga', '2025-09-03 04:47:36', '$2y$10$H/ELKV5hiIytGKBCPAC60.oEN/3f.TUnV5/lUCHoxbtpcfFOErztC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('241', 'Nguyễn Trung Kiên', 'ntkien_1', NULL, NULL, NULL, NULL, NULL, 'ntkien_1', '2025-09-03 04:47:36', '$2y$10$wPDWuydWzjj9mn2LOWXju.F3t4XWiG6UA1wQtG8FsPmglCPFjtkb6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('242', 'Phạm Duy Thái', 'pdthai', NULL, NULL, NULL, NULL, NULL, 'pdthai', '2025-09-03 04:47:36', '$2y$10$CC/.kdRzRFwYhtuubXbQbOtD00ONZyeDRwYwHMUDOtP7pu5RoD1Jq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('243', 'Lê Quý Vũ', 'lqvu', NULL, NULL, NULL, NULL, NULL, 'lqvu', '2025-09-03 04:47:36', '$2y$10$GY287ibkRj1.pkYkqlPADOayODRL5Gy.Vic0RMZ2B7F2gGNk/z6Zi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('244', 'Nguyên Hữu Ngọc', 'nhngoc', NULL, NULL, NULL, NULL, NULL, 'nhngoc', '2025-09-03 04:47:36', '$2y$10$WgKsdQAJCmhAz8ah4qGzbO3D.PY2uoB4plBxytSZ8omePgpbtXB9O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('245', 'Lại Hoàng Hà', 'lhha', NULL, NULL, NULL, NULL, NULL, 'lhha', '2025-09-03 04:47:36', '$2y$10$nZw3R2nC3d5uBcMzHSxQPeSfDr6NhTcmQZnqcfcw7tXNgryfAd9nW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('246', 'Dương Thế Vinh', 'dtvinh', NULL, NULL, NULL, NULL, NULL, 'dtvinh', '2025-09-03 04:47:36', '$2y$10$WnY6sTlbkrOAsboQqrziouGFIZHLSlMmzE6fJHrSCrpKOBfFu/MQC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('247', 'Đỗ Văn Quân', 'dvquan', NULL, NULL, NULL, NULL, NULL, 'dvquan', '2025-09-03 04:47:36', '$2y$10$r2HYIV86pUgaujluSwGZzeNXxCi4ONHcwV5aJByzcTHTQ2JtB6QsS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('248', 'Nguyễn Văn Bình', 'nvbinh', NULL, NULL, NULL, NULL, NULL, 'nvbinh', '2025-09-03 04:47:36', '$2y$10$GaIQojhKxgUvAPsw48u4iOeYqV8yy5L8XEruhW0HylExhsVJAPgyG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('249', 'Bùi Công Đoài', 'bcdoai', NULL, NULL, NULL, NULL, NULL, 'bcdoai', '2025-09-03 04:47:36', '$2y$10$YkSugmtipy9ubO1pq2XoCuYtnZsGEgB7K.wvlRmboI1xhCLeZSF/m', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `users` VALUES ('250', 'Đặng Hùng', 'dhung', NULL, NULL, NULL, NULL, NULL, 'dhung', '2025-09-03 04:47:37', '$2y$10$J0WZ4md5nPjDASvrhSM7IeK74XGayXjWxz33UnMrtKue6uCxOH4oy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('251', 'Ngô Văn Hiển', 'nvhien', NULL, NULL, NULL, NULL, NULL, 'nvhien', '2025-09-03 04:47:37', '$2y$10$wWiNoSvSQhYswPiIl4vagedf4y1HSCzhx7LcCegXy0dcbBOnWmeuG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('252', 'Đỗ Văn Linh', 'dvlinh', NULL, NULL, NULL, NULL, NULL, 'dvlinh', '2025-09-03 04:47:37', '$2y$10$xpm3pjXHPWMpXgsPaK4bt.7gTHhV9GLBFRzNwFu76NKY8AY7a6S0a', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('253', 'Hoàng Công Thành', 'hcthanh', NULL, NULL, NULL, NULL, NULL, 'hcthanh', '2025-09-03 04:47:37', '$2y$10$2aYYQydSVC6AU4YRMvRuLOVaR1BIzvLFK1nasj7T0D4KiUpeyX3.O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('254', 'Văn Sỹ Lực', 'vsluc', NULL, NULL, NULL, NULL, NULL, 'vsluc', '2025-09-03 04:47:37', '$2y$10$av8VYJUuQnyL0UREIYv6Pegg0zBZpGuCnT/QofSb8x8vbQzhamOoC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('255', 'Nguyễn Trần Đức', 'ntduc', NULL, NULL, NULL, NULL, NULL, 'ntduc', '2025-09-03 04:47:37', '$2y$10$N.2DjkNaKmHfeEUZPEBugepE3wKGTCHBr.StP4C6u61RBBQ0FF0dy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('256', 'Lê Minh Vượng', 'lmvuong', NULL, NULL, NULL, NULL, NULL, 'lmvuong', '2025-09-03 04:47:37', '$2y$10$mEvKp9Y8WJ2jjG2o5m9CRuWbLZN991UnZBH.jIEOB77WugwTD.7ye', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('257', 'Tạ Văn Hoàng', 'tvhoang', NULL, NULL, NULL, NULL, NULL, 'tvhoang', '2025-09-03 04:47:37', '$2y$10$vLjH5.zsHyBBJNqDCUb5LOzuiOJ8H.7RGt1CXnvttRiDiF9HRFyTq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('258', 'Phạm Thị Phương', 'ptphuong', NULL, NULL, NULL, NULL, NULL, 'ptphuong', '2025-09-03 04:47:37', '$2y$10$EuytjGubOjp1mAKYavasuOBz0FI.qy/tgIZy7Wzribw8GWpnhvOta', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('259', 'Lê Thị Vân', 'ltvan', NULL, NULL, NULL, NULL, NULL, 'ltvan', '2025-09-03 04:47:37', '$2y$10$BXSmgvwh3zOWJdGXp2N.5uD7jy9JmbRbSxl4T/LpPXROXFV/Q9wdm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('260', 'Trần Xuân Trường', 'txtruong', NULL, NULL, NULL, NULL, NULL, 'txtruong', '2025-09-03 04:47:37', '$2y$10$7Nd94wzpM5FSSZ8BulxXBe53S4MDHSJDSK4ZHQZTVpDguw0kNYww6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('261', 'Nguyễn Đình Tuấn', 'ndtuan', NULL, NULL, NULL, NULL, NULL, 'ndtuan', '2025-09-03 04:47:37', '$2y$10$M2x4bqPEEY7wO7Suz33rKeyVvCZ/9K4ahNadiwt6IWL8j7Mio4j4i', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('262', 'Trần Ngọc Dũng', 'tndung', NULL, NULL, NULL, NULL, NULL, 'tndung', '2025-09-03 04:47:37', '$2y$10$v4ZzgRDzgS88kOk7N0TJqOxJVHvnBg/cM8MZNXVtQjC6Ozm/dUwOC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('263', 'Nguyễn Anh Tuấn', 'natuan', NULL, NULL, NULL, NULL, NULL, 'natuan', '2025-09-03 04:47:37', '$2y$10$T/0WEQ9Tg4m8U/uJaOxYX.1mO5d7UbbUy9MNQtm2mSL911n65FWg2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `users` VALUES ('264', 'Nguyễn Xuân Dũng', 'nxdung', NULL, NULL, NULL, NULL, NULL, 'nxdung', '2025-09-03 04:47:38', '$2y$10$67kMghdQTEIxLn/h8HfuhuwAqckyKAXkMEzaTPfl.pFVfRWdB7jNS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('265', 'Ngô Viết  Toản', 'nvtoan', NULL, NULL, NULL, NULL, NULL, 'nvtoan', '2025-09-03 04:47:38', '$2y$10$pJm2FW71dd5L2Xf5vlKMBesu4VF5r6oRm7xgSwunKo7rtKIjvRO/C', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('266', 'Hoàng Minh Ánh', 'hmanh', NULL, NULL, NULL, NULL, NULL, 'hmanh', '2025-09-03 04:47:38', '$2y$10$TA0DdLZfrG1tqBu2YzxxYeKKMf0U.ZRZS.tpONh6nvmgeG6PXcjui', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('267', 'Nguyễn Văn Luỹ', 'nvluy', NULL, NULL, NULL, NULL, NULL, 'nvluy', '2025-09-03 04:47:38', '$2y$10$aOuKFAKV3LYeqqtPY.eGf.wJWKPKizcSUKs9OCSHSfC3b2oUgapM2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('268', 'Trần Bá Trường', 'tbtruong', NULL, NULL, NULL, NULL, NULL, 'tbtruong', '2025-09-03 04:47:38', '$2y$10$lNHK2wZwLMKU622L7D2fVua7iyXwl/7Y2yRtO3YMqLtfD18Wz2cgG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('269', 'Bùi Văn Phong', 'bvphong', NULL, NULL, NULL, NULL, NULL, 'bvphong', '2025-09-03 04:47:38', '$2y$10$fYylb8Ox2YEdORHR8GNivORF49fsNZiyhfn19BG3uffOYDjQFV7EO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('270', 'Mai Văn Thuy', 'mvthuy', NULL, NULL, NULL, NULL, NULL, 'mvthuy', '2025-09-03 04:47:38', '$2y$10$44BW.GKTC89M5RZCttmCxemQ./tDhj5QexiJv1uWJD3wSdARp9A.C', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('271', 'Nguyễn Văn Cường', 'nvcuong', NULL, NULL, NULL, NULL, NULL, 'nvcuong', '2025-09-03 04:47:38', '$2y$10$LbbPSduZVFn5Z5VamP59C.tIxnPf1g27GcJxljnTwOjgH4SyEl2aq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('272', 'Phan Thị Thu Hường', 'ptthuong_1', NULL, NULL, NULL, NULL, NULL, 'ptthuong_1', '2025-09-03 04:47:38', '$2y$10$RgFa8B6uzBZniVM4Jm4bTesleKtJvCDxyU7Q1MPkq18CoUK2GMtEO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('273', 'Trịnh Thu Huyền', 'tthuyen', NULL, NULL, NULL, NULL, NULL, 'tthuyen', '2025-09-03 04:47:38', '$2y$10$dHHqF4UNXO9Y3ErIemmcd.oUP/hvgrGQ6cHXV5INFike7lCyPUop2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('274', 'Đặng Thị Huệ', 'dthue', NULL, NULL, NULL, NULL, NULL, 'dthue', '2025-09-03 04:47:38', '$2y$10$lUJ0YjQekfB8IEPL7g8/v.ZGeTTEQNW.4P3200lcUoOm1kN0rO0..', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('275', 'Đinh Tiến Dũng', 'dtdung', NULL, NULL, NULL, NULL, NULL, 'dtdung', '2025-09-03 04:47:38', '$2y$10$4Xidb.2x2e7QD3zSZRsZZuiFkn6w6Tci6SuxFPp3/.3dGeWnyPFN2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('276', 'Đoàn Thị Sự', 'dtsu', NULL, NULL, NULL, NULL, NULL, 'dtsu', '2025-09-03 04:47:38', '$2y$10$hFipMa7zInqrO01LcPOnDOLbevK4AXbAZwE.oMR/EiJEywtZHXLpu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('277', 'Phạm Thị Thu  Hà', 'pttha', NULL, NULL, NULL, NULL, NULL, 'pttha', '2025-09-03 04:47:38', '$2y$10$8QVtvxmnDpMIjY/AklgKtOZf9NhZbbZu2GdahkljVCk5t4t7Oj1nW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('278', 'Đinh Thị Tâm', 'dttam', NULL, NULL, NULL, NULL, NULL, 'dttam', '2025-09-03 04:47:38', '$2y$10$Gu.tyHdoeTVJrelbyU1f0O5FnzbNkiZ5tJz3ZHlBt2c/k9dNM9aLS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `users` VALUES ('279', 'Nguyễn Thị Hiền', 'nthien', NULL, NULL, NULL, NULL, NULL, 'nthien', '2025-09-03 04:47:39', '$2y$10$qrY9Uxt12AthGtU9XxcABOSVZHP1r2QUga3oQct5oaiQ2n3h0TCTi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('280', 'Đinh Quang Điềm', 'dqdiem', NULL, NULL, NULL, NULL, NULL, 'dqdiem', '2025-09-03 04:47:39', '$2y$10$w.t/Sp7u7JspAI1Ao6e3S.4hOsf9vee5rAKuqknWYUTibKo3AlTJa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('281', 'Huỳnh Thái Tân', 'httan', NULL, NULL, NULL, NULL, NULL, 'httan', '2025-09-03 04:47:39', '$2y$10$ufYkWmV7qHMzFtp632dZmedwp3OH0/MPxUosS9yR1xpxdcQw0.VAu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('282', 'Mai Trường Giang', 'mtgiang', NULL, NULL, NULL, NULL, NULL, 'mtgiang', '2025-09-03 04:47:39', '$2y$10$x.oSFHjTvcBLTBxvVOIJK.skPno6n7wty56uqMHvhi/z9PqudymZi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('283', 'Nguyễn Việt Dũng', 'nvdung', NULL, NULL, NULL, NULL, NULL, 'nvdung', '2025-09-03 04:47:39', '$2y$10$9eVAWqjSwpm5JujnJH/6vuKUElq2td8me1kEVu7YrjCz.jEy2TQ/u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('284', 'Nguyễn Xuân Quý', 'nxquy', NULL, NULL, NULL, NULL, NULL, 'nxquy', '2025-09-03 04:47:39', '$2y$10$2YpJC3PQnBOi90Jb.cF0Su.WAwmTpTUyBwVKckqaeMim.0KPlfbtG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('285', 'Nguyễn Xuân Bách', 'nxbach', NULL, NULL, NULL, NULL, NULL, 'nxbach', '2025-09-03 04:47:39', '$2y$10$Adn6J63dyFy2ySQg5TmjYuTtcYv3LITWLbTsmxeY1qxg8Hevt327e', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('286', 'Nguyễn Ngọc Quý', 'nnquy', NULL, NULL, NULL, NULL, NULL, 'nnquy', '2025-09-03 04:47:39', '$2y$10$LF0JlYj3zu5w8VfsIAz8feSqX14GXse8FHw0Z/wm9eDz7lFWOuSeS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('287', 'Thái Thị Hà', 'ttha', NULL, NULL, NULL, NULL, NULL, 'ttha', '2025-09-03 04:47:39', '$2y$10$zQehr1xbcU00QmCaNJIyGe84.j.01LB0m5n1653eH7BkNs3mfTNMS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('288', 'Nguyễn Văn Bách', 'nvbach', NULL, NULL, NULL, NULL, NULL, 'nvbach', '2025-09-03 04:47:39', '$2y$10$79LrqoM8qM7ForjHxZrQheBkLG8G0ipT5NgjQpl8CHwXyJwMki5gy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('289', 'Nguyễn Văn Cường', 'nvcuong_1', NULL, NULL, NULL, NULL, NULL, 'nvcuong_1', '2025-09-03 04:47:39', '$2y$10$j.8IGqt2rRCpBrCq5FIMze66AdAPg47BxmorMDKV0GzSQLizORDQW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('290', 'Nguyễn Văn Phú', 'nvphu', NULL, NULL, NULL, NULL, NULL, 'nvphu', '2025-09-03 04:47:39', '$2y$10$PHjZWix5PBnbSch18GkuveQIgOAnqT2esy0U6iA2WY5VcHZ6eMJrC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('291', 'Phạm Thị Kiều Ân', 'ptkan', NULL, NULL, NULL, NULL, NULL, 'ptkan', '2025-09-03 04:47:39', '$2y$10$8yC0oCgWG8n.JvfeFRuW3.55oGxT15oyL6oJlReOQKtJyG8.QxXjO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('292', 'Nguyễn Thị Thuý', 'ntthuy', NULL, NULL, NULL, NULL, NULL, 'ntthuy', '2025-09-03 04:47:39', '$2y$10$shayWEiONNAIi/B8Pzvy5etB1i0Vt0ogbPZ78TNEKjtJURSLxjNAC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('293', 'Dương Thị Mơ', 'dtmo', NULL, NULL, NULL, NULL, NULL, 'dtmo', '2025-09-03 04:47:39', '$2y$10$118RR/fcnDpq0tcy9q2gTe18PxI05T5T8qhP6pu5nAZQwi0wTCpwW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `users` VALUES ('294', 'Nguyễn Thị Hằng', 'nthang', NULL, NULL, NULL, NULL, NULL, 'nthang', '2025-09-03 04:47:40', '$2y$10$7qcNT9Wqk21SVzyUqYgEr.ul.85bT6yK52R9AbG5BEcdyuzB7emzG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('295', 'Phạm T Thu Hương', 'ptthuong_2', NULL, NULL, NULL, NULL, NULL, 'ptthuong_2', '2025-09-03 04:47:40', '$2y$10$7toV8/ehL8ts2IquuvMfqusKqS/GHsyihUEguzmAhGO6WOKBZkROG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('296', 'Chử  Quang Anh', 'cqanh', NULL, NULL, NULL, NULL, NULL, 'cqanh', '2025-09-03 04:47:40', '$2y$10$WIeNYTMyegvAirvMuGPjRuKaxpIUrVQ8pBNLTH3JhIB7YylDkd/.O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('297', 'Đào Văn Tiến', 'dvtien', NULL, NULL, NULL, NULL, NULL, 'dvtien', '2025-09-03 04:47:40', '$2y$10$vNMJYHw2VLFC0HHyX7GP3O1eJJOhl81UxgdYvFAnjOAzrrbrB748a', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('298', 'Trần Đình Tám', 'tdtam', NULL, NULL, NULL, NULL, NULL, 'tdtam', '2025-09-03 04:47:40', '$2y$10$73//Lc3x4/JWbjjTOm/QSuctjN9gotLOWPey8n.PnrxOgjrXdbyvm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('299', 'Nguyễn Quỳnh Trang', 'nqtrang', NULL, NULL, NULL, NULL, NULL, 'nqtrang', '2025-09-03 04:47:40', '$2y$10$Gl88Znh0sKES82U.kT5wxe72gjUnDioKKiMrm.vUMnEZhlgNmdzjm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('300', 'Lê Mạnh Hà', 'lmha', NULL, NULL, NULL, NULL, NULL, 'lmha', '2025-09-03 04:47:40', '$2y$10$NwwRGHF2foVFFO/Gqk.oXOxIwj28k68BDpcl9lrLQajfSGwAWbBri', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('301', 'Nguyễn Thị Anh', 'ntanh', NULL, NULL, NULL, NULL, NULL, 'ntanh', '2025-09-03 04:47:40', '$2y$10$5R8yJ7LfQsd65vzxpMFgG.MjGwXOg/Y1rjp6cAgLBphg1UJllPnD2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('302', 'Đỗ Đức Toàn', 'ddtoan', NULL, NULL, NULL, NULL, NULL, 'ddtoan', '2025-09-03 04:47:40', '$2y$10$4TsdwkqQXi3xXlevzh4agek03IYFGmwfwt6b0Yaa9K0eAxBWJgDia', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('303', 'Triệu T Hoài Phương', 'tthphuong', NULL, NULL, NULL, NULL, NULL, 'tthphuong', '2025-09-03 04:47:40', '$2y$10$Ulc1sGIBVYLwM402C//mROIzbB/z0f8LF1RYqBLdfdVsjKu7DwO5O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('304', 'Trịnh Bá Thuận', 'tbthuan', NULL, NULL, NULL, NULL, NULL, 'tbthuan', '2025-09-03 04:47:40', '$2y$10$/F.HA0ldOa16Ma/e0TKXj.JftElFzObBoblazmtIYCJlRaly8xJEe', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('305', 'Đặng Quốc Sỹ', 'dqsy', NULL, NULL, NULL, NULL, NULL, 'dqsy', '2025-09-03 04:47:40', '$2y$10$V9RxADrg9y1Jk5ZabujAh.AAlNM8xDPCWvd9nK5Kg2y5XqgqaoiNe', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('306', 'Phạm Lan Phương', 'plphuong', NULL, NULL, NULL, NULL, NULL, 'plphuong', '2025-09-03 04:47:40', '$2y$10$ixXyriNOp/QgH3IoWZhhCeFZ.6AIT3BeviUNo7D9sAE0XPQkPqZPS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('307', 'Giang Chí Dũng', 'gcdung', NULL, NULL, NULL, NULL, NULL, 'gcdung', '2025-09-03 04:47:40', '$2y$10$.G7GJCzPY6TKB1zuna/IyOEpFrsFl5vRVgqzVUhy8uyaCDYbhLej2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('308', 'Nguyễn Thị Huyền', 'nthuyen', NULL, NULL, NULL, NULL, NULL, 'nthuyen', '2025-09-03 04:47:40', '$2y$10$Zow1s8D19uOKTk2c.OUmgeEXw4v6e5l1ALFQNfK7KB4GPG0.o6cjm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('309', 'Nguyễn T Phương Chi', 'ntpchi', NULL, NULL, NULL, NULL, NULL, 'ntpchi', '2025-09-03 04:47:40', '$2y$10$DNyWNv69PPMRupuZBxQaUeSs93Y/PoDYzavsCOospi08cb5tFN0xa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `users` VALUES ('310', 'Phạm Thị Vân Anh', 'ptvanh', NULL, NULL, NULL, NULL, NULL, 'ptvanh', '2025-09-03 04:47:41', '$2y$10$Y7fGZiuO/pyFU4w6SMiHlOOr1kSxNiGKWQ8hTQdxpbAQg2SJnwFlW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('311', 'Trần Thị Tuyến', 'tttuyen', NULL, NULL, NULL, NULL, NULL, 'tttuyen', '2025-09-03 04:47:41', '$2y$10$VDOgeoLuqkrv5qxKrRntDOnSNtq5QzjED1uXucqcmluGbPadiOpze', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('312', 'Bùi Đức Anh', 'bdanh', NULL, NULL, NULL, NULL, NULL, 'bdanh', '2025-09-03 04:47:41', '$2y$10$rdBU68De48C9iw9tIL9ICOPasdNmz4/i3hR5ln11l4cjVbeV9rNRa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('313', 'Vũ Thị Kim Ngân', 'vtkngan', NULL, NULL, NULL, NULL, NULL, 'vtkngan', '2025-09-03 04:47:41', '$2y$10$a.GEq.w/cdnQTZNMMe5vDOWDDMllTZgk.5QZs3YZKNJ6YqkcT4yVO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('314', 'Nguyễn Thu Huyền', 'nthuyen_1', NULL, NULL, NULL, NULL, NULL, 'nthuyen_1', '2025-09-03 04:47:41', '$2y$10$/QmB0Q91E6vaVhATojKtiOVU0IrGSNLG5n8i0jCRyUc6Yte6f677O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('315', 'Trần Trọng Đại', 'ttdai', NULL, NULL, NULL, NULL, NULL, 'ttdai', '2025-09-03 04:47:41', '$2y$10$OYCpGleDwyM0cR3.j5FEKOyshrrEFodxwM0NxUGb4SQxrNHRKFxBC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('316', 'Lưu Hoàng Văn', 'lhvan', NULL, NULL, NULL, NULL, NULL, 'lhvan', '2025-09-03 04:47:41', '$2y$10$ss8TNXGHc78o4M.EYdmzeOXZkbEVeJXOaRpp9iKihxR28EaebQlUK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('317', 'Đồng Xuân Dũng', 'dxdung', NULL, NULL, NULL, NULL, NULL, 'dxdung', '2025-09-03 04:47:41', '$2y$10$OtDwpIy6iFAFr6RDyqPrO.ec0V5OpmMUNRfDJ8ZDu52wp4kD.3n.e', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('318', 'Trương Thanh Tú', 'tttu', NULL, NULL, NULL, NULL, NULL, 'tttu', '2025-09-03 04:47:41', '$2y$10$x39sCdFKf5YCJ.iuECze..xc9SEotHo/Lm5zoZ9xlWxSMKy83YiGC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('319', 'Dương T Phương Loan', 'dtploan', NULL, NULL, NULL, NULL, NULL, 'dtploan', '2025-09-03 04:47:41', '$2y$10$y0nZ7XF2sK9QBoIyWv1m9.plUT91SWfA34Vk85/pYj9IZokd0HESO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('320', 'Nguyễn  Hữu Thanh', 'nhthanh', NULL, NULL, NULL, NULL, NULL, 'nhthanh', '2025-09-03 04:47:41', '$2y$10$yr/zQO63.5qmvYl6arWWNO0CTr17Kl2/352DvVhlzxw1kiBYILGw.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('321', 'Nguyễn Thị Tuyền', 'nttuyen', NULL, NULL, NULL, NULL, NULL, 'nttuyen', '2025-09-03 04:47:41', '$2y$10$V4fCfLtv7GYZ7iXvU5.0kO8nq1uNlbB9WZtteKQo6x97/Sl5KFJFm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('322', 'Lê Thị Thuý Hằng', 'ltthang', NULL, NULL, NULL, NULL, NULL, 'ltthang', '2025-09-03 04:47:41', '$2y$10$vbu7L11o6YVBz5A7JBThFe5ahgRILvS15xtLA//Bt.CkRc7SSLmae', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('323', 'Nguyễn T Thuý Bình', 'nttbinh', NULL, NULL, NULL, NULL, NULL, 'nttbinh', '2025-09-03 04:47:41', '$2y$10$gdWleQXYNNz6YqmYxpESo./9qG8izrotZlbEzQbLtn206ZiHPlQtm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('324', 'Đặng Thị Kim Dung', 'dtkdung', NULL, NULL, NULL, NULL, NULL, 'dtkdung', '2025-09-03 04:47:41', '$2y$10$PTfKtYqy8AxhVB4UtWZXdePuxLaCkARvLh3wo0qgo24wkD66uzOmW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `users` VALUES ('325', 'Dương Thị Thân Thương', 'dttthuong', NULL, NULL, NULL, NULL, NULL, 'dttthuong', '2025-09-03 04:47:42', '$2y$10$kmXeKiY0AXHqertXnUO6meqJ3tXQCO1d.j8KANXN.xbWU9qwKSOuC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('326', 'Phạm Thị Trang Nhung', 'pttnhung', NULL, NULL, NULL, NULL, NULL, 'pttnhung', '2025-09-03 04:47:42', '$2y$10$/Fc5ICvbx6EYx7GbfoNi8Ok9TDeMdnnvWaRUMbkw.eQyrCXnATIYW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('327', 'Trần Thị Chuyên', 'ttchuyen', NULL, NULL, NULL, NULL, NULL, 'ttchuyen', '2025-09-03 04:47:42', '$2y$10$6jqnQuoADHccTkWwOLK1f.Mw0zxjZh2hU0y/h1jyG3f5zjLgahFvG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('328', 'Phạm Khắc Hùng', 'pkhung', NULL, NULL, NULL, NULL, NULL, 'pkhung', '2025-09-03 04:47:42', '$2y$10$S40uCxXBlExiPrhVp1wWhulhltLX1T/WgemI.VtBGeJziwoKVql2y', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('329', 'Nguyễn Mạnh Hùng', 'nmhung', NULL, NULL, NULL, NULL, NULL, 'nmhung', '2025-09-03 04:47:42', '$2y$10$NCZ88bFROnBORDlc01HSku.n1TRgWlLOrlz/qN34KoihmGnZBMS5a', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('330', 'Vũ Mạnh Tú', 'vmtu', NULL, NULL, NULL, NULL, NULL, 'vmtu', '2025-09-03 04:47:42', '$2y$10$nF/gdm0mg1rCDIiB99tYROHC6gtMdlDrIPx3f1v5ECt6BNE0lxsg2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('331', 'Bùi Anh Tuấn', 'batuan', NULL, NULL, NULL, NULL, NULL, 'batuan', '2025-09-03 04:47:42', '$2y$10$nV7ucuBpaJJv/q40/USzKukjN4wfu/M/hU5/jPG5XJZbttM37Djze', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('332', 'Nguyễn Văn Thụ', 'nvthu', NULL, NULL, NULL, NULL, NULL, 'nvthu', '2025-09-03 04:47:42', '$2y$10$IR9.igPIy3Y4zoMszthyourzWA5Yq1s63Jp8m7mVw34bMof3z9VJy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('333', 'Đặng Văn Phố', 'dvpho', NULL, NULL, NULL, NULL, NULL, 'dvpho', '2025-09-03 04:47:42', '$2y$10$JnxkbdQzwsIo4Nj4vWdJF.9vJDoRNzz2IxxXWvAFyv85BVgB/okfS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('334', 'Nguyễn Xuân Trường', 'nxtruong', NULL, NULL, NULL, NULL, NULL, 'nxtruong', '2025-09-03 04:47:42', '$2y$10$euvyjs3VQ/rvZZ2nBu2IzuauVtSG.sVhDpyl5RGuWLJfgC1juk/s2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('335', 'Hà Thanh Trung', 'httrung', NULL, NULL, NULL, NULL, NULL, 'httrung', '2025-09-03 04:47:42', '$2y$10$zd8mgmUrAeao.lF8OQlGIuPc2S4wkDu9R7H4Jh0PVIJSIV66nFaV6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('336', 'Nguyễn Văn Huyên', 'nvhuyen', NULL, NULL, NULL, NULL, NULL, 'nvhuyen', '2025-09-03 04:47:42', '$2y$10$eb8TViKikRxphpmqWO2lhuMUzb79zfg2/sLq6OTObMj6oy7HhfY1m', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('337', 'Nguyễn Gia Mạnh', 'ngmanh', NULL, NULL, NULL, NULL, NULL, 'ngmanh', '2025-09-03 04:47:42', '$2y$10$6rcYAdKM5Xh..anDixRFLO5nFTzwSmQDHcDNlQDLwBLnFFsTkhzvu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('338', 'Đỗ Hồng Sơn', 'dhson', NULL, NULL, NULL, NULL, NULL, 'dhson', '2025-09-03 04:47:42', '$2y$10$Eho3g98ulCdj2RDO4Dqrw.cBkLQAqSumGPjloPEJxRHzdn5V73ihW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('339', 'Nguyễn Tuấn Hiệp', 'nthiep', NULL, NULL, NULL, NULL, NULL, 'nthiep', '2025-09-03 04:47:42', '$2y$10$0NfbSfAY4ZSyu7Vc4dWDdebNQ6EritxonYEUiqSn/sO8iS6NqSTh2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('340', 'Vũ Mạnh Cương', 'vmcuong', NULL, NULL, NULL, NULL, NULL, 'vmcuong', '2025-09-03 04:47:42', '$2y$10$v2F788apYQEvpsYkurRFX.rSyDIeHF8Nr4XdupmJ3/LA3VyYsrdx.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `users` VALUES ('341', 'Lê Trọng Quỳnh', 'ltquynh', NULL, NULL, NULL, NULL, NULL, 'ltquynh', '2025-09-03 04:47:43', '$2y$10$ypV1LRn6a50E5.iljcdko.L0IHIIuxrHv2attL5Iino8tBMwOGVoq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('342', 'Đặng Viết Công', 'dvcong', NULL, NULL, NULL, NULL, NULL, 'dvcong', '2025-09-03 04:47:43', '$2y$10$hHryQDoNs5MwbQHQg3qGb.nbgRe86HMDis1B1kw1Zy5r0HLF26k8y', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('343', 'Nguyễn Tiến Dũng', 'ntdung', NULL, NULL, NULL, NULL, NULL, 'ntdung', '2025-09-03 04:47:43', '$2y$10$bVUNnLItaUEGFvlPjJERIuSJPfUJAxzx5R/CJ6lCt4fBmGsOcTWYO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('344', 'Nguyễn Hồng Anh', 'nhanh', NULL, NULL, NULL, NULL, NULL, 'nhanh', '2025-09-03 04:47:43', '$2y$10$xAKSq.gWkoi/8BgnAdOmHemfATXbgIbo.g9E4UXHT3PB07emgR8ee', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('345', 'Trần Đức Tấn', 'tdtan', NULL, NULL, NULL, NULL, NULL, 'tdtan', '2025-09-03 04:47:43', '$2y$10$Zl2U9hf3p0bzFTph.wc1ZOsJVfmHXgsR0P5LQSm3Iamh/1YtMVTUe', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('346', 'Hoàng Anh Dũng', 'hadung', NULL, NULL, NULL, NULL, NULL, 'hadung', '2025-09-03 04:47:43', '$2y$10$OdXX8JYDm2RqYGIttbYGfuysgpuDkSv6reC1XQ1.SKYplz5RcOneK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('347', 'Nguyễn Mai Hương', 'nmhuong', NULL, NULL, NULL, NULL, NULL, 'nmhuong', '2025-09-03 04:47:43', '$2y$10$wOV/z6p9Cja1kxDm5MNo5.9KooD11uu6M27Up1K4ASt.jraPQQQZG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('348', 'Hoàng Văn Tiến', 'hvtien', NULL, NULL, NULL, NULL, NULL, 'hvtien', '2025-09-03 04:47:43', '$2y$10$2Sa0QH2fYCS9OcHHeNCjc.aPkb4MUZ43db7k97rVMm9r8sj2ga1xS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('349', 'Nguyễn Xuân Thụ', 'nxthu', NULL, NULL, NULL, NULL, NULL, 'nxthu', '2025-09-03 04:47:43', '$2y$10$N80n.Kafb2kWu0TjJx6sKOyVxc5McvJmTk8.WJKMxy4k7CLvYg42K', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('350', 'Hà Nguyễn Tuấn Anh', 'hntanh', NULL, NULL, NULL, NULL, NULL, 'hntanh', '2025-09-03 04:47:43', '$2y$10$etJ2Gx61.j8wyTWYidulYuVGQiTiDTEPX6YUUIJ43GyhoHC96LmAW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('351', 'Đinh Viết Trường', 'dvtruong', NULL, NULL, NULL, NULL, NULL, 'dvtruong', '2025-09-03 04:47:43', '$2y$10$rIBWlwn0VnCWxnvnxLYLm.GSrJD3jN6CUoCHfDfska8jAsD6kUKra', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('352', 'Phan Thanh Quang', 'ptquang', NULL, NULL, NULL, NULL, NULL, 'ptquang', '2025-09-03 04:47:43', '$2y$10$ttlhZ8WxIyR8wEgfPwssCuou4vDMDws8atcHN9cMxpHx6AaD46Fce', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('353', 'Nguyễn Tiến Nam', 'ntnam', NULL, NULL, NULL, NULL, NULL, 'ntnam', '2025-09-03 04:47:43', '$2y$10$pi9Ft/h6Zpdg1ZAh4zDaOuX1VcbSNzsSEX7xWGM/yXheJVH1iiCAq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('354', 'Nguyễn Huy Thắng', 'nhthang', NULL, NULL, NULL, NULL, NULL, 'nhthang', '2025-09-03 04:47:43', '$2y$10$jHSTrQZS5Q9X6PwCoyXlne1Gynrmzk69Su6PsPgKx5gAj6PyhsEMm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('355', 'Trần Hồng Công', 'thcong', NULL, NULL, NULL, NULL, NULL, 'thcong', '2025-09-03 04:47:43', '$2y$10$pVitDLYy2f6iIA4cZ4GBvearKmVLpZUG7QHMC6yX.qOxjKaw0cBM6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('356', 'An Văn Trực', 'avtruc', NULL, NULL, NULL, NULL, NULL, 'avtruc', '2025-09-03 04:47:43', '$2y$10$WB..DRbm5jmsoDePghJ9Eekpju74TAZihE7HOwhntaRV3xj.k8C9m', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('357', 'Phạm Quỳnh Trang', 'pqtrang', NULL, NULL, NULL, NULL, NULL, 'pqtrang', '2025-09-03 04:47:43', '$2y$10$49ue58DvEyf4JGH.ENT41OocOD9kY5MKa3L63YK.YV7L6mONTjRxa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `users` VALUES ('358', 'Ngô Thị Sơn', 'ntson', NULL, NULL, NULL, NULL, NULL, 'ntson', '2025-09-03 04:47:44', '$2y$10$q8.zKUnsa8u70KJGCUa8fO5ZNnCqvwrMFEh155nJh8QXT1rk2KqHy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('359', 'Nguyễn Anh Tuấn', 'natuan_1', NULL, NULL, NULL, NULL, NULL, 'natuan_1', '2025-09-03 04:47:44', '$2y$10$PGn0dskaUCxWw7Xzt22jd.nbZRcitjD2VbauxRooCrX/zh75RcMnO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('360', 'Trần  Ngọc Phú', 'tnphu', NULL, NULL, NULL, NULL, NULL, 'tnphu', '2025-09-03 04:47:44', '$2y$10$laL4lqCJ/T0bZp1CNR5gGeTrOEDW9uMSxag5UXMJEpbk1olo.qfZ2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('361', 'Nguyễn Tuấn Long', 'ntlong', NULL, NULL, NULL, NULL, NULL, 'ntlong', '2025-09-03 04:47:44', '$2y$10$W5VSU6f9.beqSCzki4o4PeKVvSqzroQXccn4r7a7VeyCij7VavZ0S', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('362', 'Nguyễn Đức Anh', 'ndanh', NULL, NULL, NULL, NULL, NULL, 'ndanh', '2025-09-03 04:47:44', '$2y$10$lvHOwAv0Etegm5y3QOLV.uQX1riONGjxD7j91LdYCBZTExBWvGXHm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('363', 'Nguyễn Phú Hùng', 'nphung', NULL, NULL, NULL, NULL, NULL, 'nphung', '2025-09-03 04:47:44', '$2y$10$6.v917lJbHusvTzY7yp43egTNM1oY1wUV5hcA4ORlKmxMv.rxCCDC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('364', 'Nguyễn Anh Đạt', 'nadat', NULL, NULL, NULL, NULL, NULL, 'nadat', '2025-09-03 04:47:44', '$2y$10$3iTZy2SaOa95Ul8mR6oAxur6I8FuwChs8xivkKW68H9.DX7T7EGxS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('365', 'Trịnh Trọng Cường', 'ttcuong', NULL, NULL, NULL, NULL, NULL, 'ttcuong', '2025-09-03 04:47:44', '$2y$10$x2L6X.dmhHZ5o1vEck3qyOyvoGr82KAYh/o8AYHtpJe..jsn2HU0u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('366', 'Cấn Xuân Khánh', 'cxkhanh', NULL, NULL, NULL, NULL, NULL, 'cxkhanh', '2025-09-03 04:47:44', '$2y$10$Dppo1.ef0YLXoPVISmZwbuCBjivcoXg65J6PLRKunmMCUuqrMm0Tu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('367', 'Vũ Thị Hiền', 'vthien', NULL, NULL, NULL, NULL, NULL, 'vthien', '2025-09-03 04:47:44', '$2y$10$K5/D44ENAdLE78ba1CK.7e4VBJx2sjw18KVXJRt/pHC9YJUBWbauO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('368', 'Phan Văn Đăng', 'pvdang', NULL, NULL, NULL, NULL, NULL, 'pvdang', '2025-09-03 04:47:44', '$2y$10$ltZ.ChnIja9G8luOT3CSFOOcUAQfp7VkSQrLtYfv2FmD8lo5aj7vK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('369', 'Bùi Mạnh Hùng', 'bmhung', NULL, NULL, NULL, NULL, NULL, 'bmhung', '2025-09-03 04:47:44', '$2y$10$H1oEpoozvnPZ9GrhNwd2y.T/x2OtD1e8CGh.LGjLyc0sYZfNbNqkq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('370', 'Trần Văn Thành', 'tvthanh', NULL, NULL, NULL, NULL, NULL, 'tvthanh', '2025-09-03 04:47:44', '$2y$10$5608A8b8zqAPUhxmvWJDGuZr5gnOL5EPD0YqrBFWS82/tu/EehING', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('371', 'Vũ Trịnh Giang', 'vtgiang', NULL, NULL, NULL, NULL, NULL, 'vtgiang', '2025-09-03 04:47:44', '$2y$10$T67NLw1.MyDj28y/Of5XY.IDrwsJsFIVVceOVsveaPWhdHEJfQqEi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('372', 'Nguyễn Tuấn Long', 'ntlong_1', NULL, NULL, NULL, NULL, NULL, 'ntlong_1', '2025-09-03 04:47:44', '$2y$10$QLnkS7zYWyXC6RYcT4M1gerMTY6qWN1KtqThBkE4ZI8JLc8Y9QzH6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('373', 'Vũ Huy Phương', 'vhphuong', NULL, NULL, NULL, NULL, NULL, 'vhphuong', '2025-09-03 04:47:44', '$2y$10$TMlk4NOWnUVf89uj7oledePH..v/Cylh6L8AiVCDXcg5J6.dGSslO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `users` VALUES ('374', 'Vũ Hải Dương', 'vhduong', NULL, NULL, NULL, NULL, NULL, 'vhduong', '2025-09-03 04:47:45', '$2y$10$4IORT9VpiWwhRrgRtkkvUO6t8ovdhIUFG7N6FgJIg2QfY0uhLouEm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('375', 'Trịnh Thành Chung', 'ttchung', NULL, NULL, NULL, NULL, NULL, 'ttchung', '2025-09-03 04:47:45', '$2y$10$SPAcr.9Nv.vtS0QEi.NdtuHkXh9wJmily7Bbw2zexikEp/Fjud6MS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('376', 'Nguyễn Diên Quang', 'ndquang', NULL, NULL, NULL, NULL, NULL, 'ndquang', '2025-09-03 04:47:45', '$2y$10$7855YZfMkJv.OHmmybUh4.GLtf708cL5rYgZfnJPnFiS5ZdeltriC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('377', 'Mai Thị Phượng', 'mtphuong', NULL, NULL, NULL, NULL, NULL, 'mtphuong', '2025-09-03 04:47:45', '$2y$10$KyoahAbY5CD97bOWGlOFoOEMMrjB.t9Sg9wlKb12HhIfEAwYYWrlW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('378', 'Bùi Thị Hồng Thu', 'bththu', NULL, NULL, NULL, NULL, NULL, 'bththu', '2025-09-03 04:47:45', '$2y$10$aQkmWHSzp/ejSdQ6w4A.oO3JU8MJkPx3TcB8ZCBOKMqaHUQiaM322', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('379', 'Đặng Văn Tường', 'dvtuong', NULL, NULL, NULL, NULL, NULL, 'dvtuong', '2025-09-03 04:47:45', '$2y$10$RTmqCmO7yNKJQGv6nomnWONzknqPbGGktublpwMZVw5yPz2o2z1Ue', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('380', 'Trần Hồng Tú', 'thtu', NULL, NULL, NULL, NULL, NULL, 'thtu', '2025-09-03 04:47:45', '$2y$10$UC8wbek.xA7kCORJaI0qYeWBT4e7JkcVAr5eqDNFEzPZWfgJfPb6i', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('381', 'Lê Trọng Quý', 'ltquy', NULL, NULL, NULL, NULL, NULL, 'ltquy', '2025-09-03 04:47:45', '$2y$10$7xKNcn3CXRFzyrqs2gWqNeKa6.UutxQKsE/aC02wPlw.7UNVK2XiG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('382', 'Đỗ Trung Kiên', 'dtkien', NULL, NULL, NULL, NULL, NULL, 'dtkien', '2025-09-03 04:47:45', '$2y$10$zAzWoN95/qBy9xAId.QF2OAdCSjBDgUuGxndJ39zHQsM7rYFYcQqO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('383', 'Chu Lê Tuấn Anh', 'cltanh', NULL, NULL, NULL, NULL, NULL, 'cltanh', '2025-09-03 04:47:45', '$2y$10$5Fmaae7GL41vY1QvmqXRiuzKYKXQ5zPEzL1BUzsQO34ZOrjC4z82.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('384', 'Hoàng Văn Thắng', 'hvthang', NULL, NULL, NULL, NULL, NULL, 'hvthang', '2025-09-03 04:47:45', '$2y$10$xlAVb/nFZ7R4e.KqepCiWO5we4/5CrzecKGapIU5cB6TY.0atDBOm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('385', 'Nguyễn Thành Long', 'ntlong_2', NULL, NULL, NULL, NULL, NULL, 'ntlong_2', '2025-09-03 04:47:45', '$2y$10$NFfKaNdIEf/q16FNdjqrNuKm7HtVBnWV2RtP3DGN.fa.BN7srbw0u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('386', 'Bùi Trường Giang', 'btgiang', NULL, NULL, NULL, NULL, NULL, 'btgiang', '2025-09-03 04:47:45', '$2y$10$QtO7pBaZWB3cw1kBAIRmA.8OKPd72tLk.F/qNF2ldS1HlUMse2pB6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('387', 'Nguyễn Hải Sơn', 'nhson', NULL, NULL, NULL, NULL, NULL, 'nhson', '2025-09-03 04:47:45', '$2y$10$Aa1MUwiUQvjlfMkHhzlICO0TSLNqw1YugduLkdKqI8331rtN..1Zu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('388', 'Nguyễn T Lan Anh', 'ntlanh', NULL, NULL, NULL, NULL, NULL, 'ntlanh', '2025-09-03 04:47:45', '$2y$10$gUc4Aka1KiHpjk0kzFv2LuHzfBL33VlHp1PFWWpKM9LcUyWG9pdJK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('389', 'Tống Cao Cường', 'tccuong', NULL, NULL, NULL, NULL, NULL, 'tccuong', '2025-09-03 04:47:45', '$2y$10$FZn3VsKlev6S3llnWlPEAeJfBQoOKcND0EfpWefORbkYFAnkAPX6q', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('390', 'Nguyễn Hữu Tâm', 'nhtam', NULL, NULL, NULL, NULL, NULL, 'nhtam', '2025-09-03 04:47:45', '$2y$10$PZGx2NTyRJkOQ1w9aTZJn.gmvEe/9TltSgJ1dblooQZqbn0SdO3ta', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `users` VALUES ('391', 'Hồ Thị Hiền', 'hthien', NULL, NULL, NULL, NULL, NULL, 'hthien', '2025-09-03 04:47:46', '$2y$10$Y5GIROmUDpRn02jg26GT9uUBgfLomMCbV3igmYBuJtB0B0LWGBL92', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('392', 'Nguyễn T Phương Thảo', 'ntpthao', NULL, NULL, NULL, NULL, NULL, 'ntpthao', '2025-09-03 04:47:46', '$2y$10$PvVQlDYz4S8bxNXh0I8vOeHZIh9OQIMZjy5eFaMQudBKbVPoTM2hS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('393', 'Bùi Văn Huy', 'bvhuy', NULL, NULL, NULL, NULL, NULL, 'bvhuy', '2025-09-03 04:47:46', '$2y$10$QahDR7wvHITTVfuoMzgyF.RvaqwcySKBqJoNv8hMWsmkXtQOrg2rK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('394', 'Phan Văn Sáng', 'pvsang', NULL, NULL, NULL, NULL, NULL, 'pvsang', '2025-09-03 04:47:46', '$2y$10$fUx9ChlHwWtZrrHJnRcJOO8LMa4ZuxDyiJdvClkORvH4ZTCg6AHUu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('395', 'Hữu Thị Thuý', 'htthuy_1', NULL, NULL, NULL, NULL, NULL, 'htthuy_1', '2025-09-03 04:47:46', '$2y$10$LogvddtQnXTVtBcgirdYXO0zX7oGBKNrzlG.1nRnLx7Jj7mTAe2pC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('396', 'Hà Minh Nho', 'hmnho', NULL, NULL, NULL, NULL, NULL, 'hmnho', '2025-09-03 04:47:46', '$2y$10$l2LolG.PH7VV61CSRbRqJOin1BxuDe0N5CRdIX64Ux2ZSp5o9kgU.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('397', 'Nguyễn Văn Đồng', 'nvdong', NULL, NULL, NULL, NULL, NULL, 'nvdong', '2025-09-03 04:47:46', '$2y$10$sy0rCePGzzQu0ZQHmFp7Z.fVENxG6YzwM4hPfCft7axP.qrsjiN9a', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('398', 'Trần T Kim Oanh', 'ttkoanh', NULL, NULL, NULL, NULL, NULL, 'ttkoanh', '2025-09-03 04:47:46', '$2y$10$mcpY5s0kVpOMlNs4l36NgexSXFhMDH1Sb.qt9FaR3CpWpPnS9kpdS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('399', 'Bùi Thị Huệ', 'bthue', NULL, NULL, NULL, NULL, NULL, 'bthue', '2025-09-03 04:47:46', '$2y$10$4V7o0YZg43WxoGguj.IFBeZzOnWZ5Dk/CcXLbradLTV.u7TVwjFDS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('400', 'Bùi Đức Cảnh', 'bdcanh', NULL, NULL, NULL, NULL, NULL, 'bdcanh', '2025-09-03 04:47:46', '$2y$10$7k548CDYVkgilF/8IZtL3OjjpADIhqRRF9kWMaG1JND2ppIOTGCM2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('401', 'Trần Đức Minh', 'tdminh', NULL, NULL, NULL, NULL, NULL, 'tdminh', '2025-09-03 04:47:46', '$2y$10$.2BZIE2XQjbgmiq7Xss79O.nmXnpBGO1Vpaw1VKMWq3D1nHzw80iu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('402', 'Vũ Đình Tùng', 'vdtung', NULL, NULL, NULL, NULL, NULL, 'vdtung', '2025-09-03 04:47:46', '$2y$10$KEfQIF/eK2/spmNJ4okW..jFLmWEOHY4NVqj49vMgeH882MB/rp4S', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('403', 'Trần Đình Tùng', 'tdtung', NULL, NULL, NULL, NULL, NULL, 'tdtung', '2025-09-03 04:47:46', '$2y$10$6/4t5dG7/oDXTfrslecAGOcpe453m9NEGtffDj8xPrLUnmEe3KCRm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `users` VALUES ('404', 'Đào Thị Thu Huyền', 'dtthuyen', NULL, NULL, NULL, NULL, NULL, 'dtthuyen', '2025-09-03 04:47:47', '$2y$10$UTj3Qn.5irhoj4NnUzrkD.KjslqddLgz3eee.waGM1ICjMgRw4Zuu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('405', 'Nguyễn Văn Quyết', 'nvquyet', NULL, NULL, NULL, NULL, NULL, 'nvquyet', '2025-09-03 04:47:47', '$2y$10$wdXFViXVEaor9YfhhSfcieNJDVfEWUsdurrumCPjfEaw6uKDSp36e', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('406', 'Nguyễn Thị Thu', 'ntthu', NULL, NULL, NULL, NULL, NULL, 'ntthu', '2025-09-03 04:47:47', '$2y$10$kcw0tFySyk7C9bbJTioWPOdcppXtlqBEaUFD8/7clQ1e.mx/dlRSe', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('407', 'Trần T Ngọc Anh', 'ttnanh', NULL, NULL, NULL, NULL, NULL, 'ttnanh', '2025-09-03 04:47:47', '$2y$10$7YN3MQVIM9RFzy85lIX/1.F8/zhh9SbstAV2KjTBPCzu1ZIIXykXy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('408', 'Đỗ Văn Hưng', 'dvhung', NULL, NULL, NULL, NULL, NULL, 'dvhung', '2025-09-03 04:47:47', '$2y$10$wqVt2P86l7Spr8WbfBcKeOHYHQ2/vu76MWoHTPGILKYic2pBObBqO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('409', 'Nguyễn Thị Tân Miền', 'nttmien', NULL, NULL, NULL, NULL, NULL, 'nttmien', '2025-09-03 04:47:47', '$2y$10$9cO4I61so9fkohG4mvCh6uQsM0GwDYgHaHew3GpLC6zAHvrR/NmB2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('410', 'Nguyễn Ngọc Khánh', 'nnkhanh', NULL, NULL, NULL, NULL, NULL, 'nnkhanh', '2025-09-03 04:47:47', '$2y$10$yKV9.2rW47FJUBX6oplMv.XlUdz1Sp8BezeRh/2L.saPPHS1Usp62', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('411', 'Nguyễn Dự Đáng', 'nddang', NULL, NULL, NULL, NULL, NULL, 'nddang', '2025-09-03 04:47:47', '$2y$10$aItX1wHBB6er5tnzMCJXAeGR7AWRXnqb9sysh3BN4YW1eFlI.HR9u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('412', 'Lê Văn Hội', 'lvhoi', NULL, NULL, NULL, NULL, NULL, 'lvhoi', '2025-09-03 04:47:47', '$2y$10$ud2VBOfKOvOUrOFG2ZLD0.EE8cPkT/ZwyGYDQAP0GDXyQ4VJSbXk6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('413', 'Nguyễn Kim Biển', 'nkbien', NULL, NULL, NULL, NULL, NULL, 'nkbien', '2025-09-03 04:47:47', '$2y$10$gypLtCMHrfrEPIQbV4WqKe/SLOdxbZXTLA6aYlb.wYwJzkKicHlDm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('414', 'Trần Mạnh Kiều', 'tmkieu', NULL, NULL, NULL, NULL, NULL, 'tmkieu', '2025-09-03 04:47:47', '$2y$10$JbHaJEky3VBFlffxQ0nJguEArDFa4FNgBO43Q6qOLqeB9dBDdQjru', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('415', 'Dương Bá Quyền', 'dbquyen', NULL, NULL, NULL, NULL, NULL, 'dbquyen', '2025-09-03 04:47:47', '$2y$10$Ppw6L2yoB4mvaxjGkD5pAOiRPlrJ.sGr9M3XvmCMnULNa5ZJU658.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('416', 'Nguyễn Thị Tươi', 'nttuoi', NULL, NULL, NULL, NULL, NULL, 'nttuoi', '2025-09-03 04:47:47', '$2y$10$bDyeSHfjJadhROHHyYD5d.6hYgqXSWrl5BHDYoVKywIKfeVhhO11.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('417', 'Bùi T Khánh Thuỳ', 'btkthuy', NULL, NULL, NULL, NULL, NULL, 'btkthuy', '2025-09-03 04:47:47', '$2y$10$XKWrqp4LGQ.zMBy8BfPLLOscrZ8ByC6VLfeTX5v05xSWod9lH2d7y', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('418', 'Hà Chí Quang', 'hcquang', NULL, NULL, NULL, NULL, NULL, 'hcquang', '2025-09-03 04:47:47', '$2y$10$QDXc.h27vH.QibwnieIB8OxSuZV86ei4BeMIbhqRADZYbkBjfXkwu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('419', 'Võ Văn Tới', 'vvtoi', NULL, NULL, NULL, NULL, NULL, 'vvtoi', '2025-09-03 04:47:47', '$2y$10$BR7zMVDrwUPguF3TbOZc4.9XBYn2G..kFXhWBdf76YGw4jzFYn.HC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `users` VALUES ('420', 'Nguyễn Quang Hùng', 'nqhung', NULL, NULL, NULL, NULL, NULL, 'nqhung', '2025-09-03 04:47:48', '$2y$10$kZnpGdu4wgd4AVEBH/PgOu4qJKonOMsj6WoEKxxAcRugxzL9a7Ld6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('421', 'Nguyễn Quyết Tiến', 'nqtien', NULL, NULL, NULL, NULL, NULL, 'nqtien', '2025-09-03 04:47:48', '$2y$10$85YJ6lGhRBk4v/TnQZdZaOPRUHY2m9gMA373PfZoOoT.uGzr3hTPC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('422', 'Tạ Hồng Đăng', 'thdang', NULL, NULL, NULL, NULL, NULL, 'thdang', '2025-09-03 04:47:48', '$2y$10$h9rzzgXhDpS9jD7k5QwJmOijgPY8MiQFWxAVc9g6xV5ekTaaAMDrS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('423', 'Nguyễn Thị Hoàn', 'nthoan', NULL, NULL, NULL, NULL, NULL, 'nthoan', '2025-09-03 04:47:48', '$2y$10$QsN.hfM8Z4TjpAmwNzTT2OlYuXehEs8rZVYRW0.1n899wAlZkRzXO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('424', 'Nguyễn Sơn Đông', 'nsdong', NULL, NULL, NULL, NULL, NULL, 'nsdong', '2025-09-03 04:47:48', '$2y$10$iKYYPT1Wc6nDZwfAetTJSOVCbl62a4ZKub.gaRuyEVNa59p178TM2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('425', 'Nguyễn Hải Tiến', 'nhtien', NULL, NULL, NULL, NULL, NULL, 'nhtien', '2025-09-03 04:47:48', '$2y$10$ATfJV8NHQJFlkD1Was9KN.7urBUMi.Ix1ahby8hC1KIyhqbhw4/yO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('426', 'Trần Việt Trung', 'tvtrung', NULL, NULL, NULL, NULL, NULL, 'tvtrung', '2025-09-03 04:47:48', '$2y$10$GFBAzI1.RECxy.tMZ8XfjOlXSatLIJsSDfKjSQrbToVK0LFOD0bha', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('427', 'Trần Thị Việt Hồng', 'ttvhong', NULL, NULL, NULL, NULL, NULL, 'ttvhong', '2025-09-03 04:47:48', '$2y$10$KkG2sOGy43xuA79pzW5ZIeoV5olAj3fYQA0kZS7cfNMSPbnNcusY2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('428', 'Vũ Ngọc Quỳnh', 'vnquynh', NULL, NULL, NULL, NULL, NULL, 'vnquynh', '2025-09-03 04:47:48', '$2y$10$BN4UdOvJCw/.eJ.g4Dmb1OhPZe15pDMFEWEA5zPQYk8Lg92ZS3Sr2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('429', 'Thái Thị Âu', 'ttau', NULL, NULL, NULL, NULL, NULL, 'ttau', '2025-09-03 04:47:48', '$2y$10$xAgdDbrWXQv4DtC4Gse/XuL6wXP2JU47pfIlzbxaPhJf/C6Hu9LJ2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('430', 'Nguyễn Thuỳ Linh', 'ntlinh', NULL, NULL, NULL, NULL, NULL, 'ntlinh', '2025-09-03 04:47:48', '$2y$10$EQ5zZIMbL/23zQWG9WyMIO4RUknLwC4VqzZ8yI.b96fc/.w9lhJ.K', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('431', 'Nguyễn Thị Mai', 'ntmai', NULL, NULL, NULL, NULL, NULL, 'ntmai', '2025-09-03 04:47:48', '$2y$10$WNsY/vu0zJxF9ryQeGK61uA0gUfLqpwmHCGStDYeW/Q8jcJYX7bF.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('432', 'Hoàng Văn Thành', 'hvthanh', NULL, NULL, NULL, NULL, NULL, 'hvthanh', '2025-09-03 04:47:48', '$2y$10$uzNgidv7voNfnqgmwP2NBOhN2LPtfFeLXNHIYvhJ5d8zo/TwdxBbG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('433', 'Vũ Thị Liên', 'vtlien', NULL, NULL, NULL, NULL, NULL, 'vtlien', '2025-09-03 04:47:48', '$2y$10$FD3Y2SHGu/5W9exlEDOSmugglssIHZ.lFf0Pnk5dY.y1Qub1MAF9i', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('434', 'Khuất Duy Mạnh', 'kdmanh', NULL, NULL, NULL, NULL, NULL, 'kdmanh', '2025-09-03 04:47:48', '$2y$10$H.Fnx3ZJUMZi2fA1KrV3uevTALA25HQ3GlHk0s/H2uxEN5uzUZcz2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('435', 'Nguyễn Thị Duyên', 'ntduyen', NULL, NULL, NULL, NULL, NULL, 'ntduyen', '2025-09-03 04:47:48', '$2y$10$hHSWfd7uHL7kurWgmVe5kOiBVLTeyVzZyA.rmlEMBmEich.XBkZuO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `users` VALUES ('436', 'Nông Thị Thuý', 'ntthuy_1', NULL, NULL, NULL, NULL, NULL, 'ntthuy_1', '2025-09-03 04:47:49', '$2y$10$IJA9y3AY5JOQLkjhO3g4KuxMwckkiPphGPTnBQWTu3w7Z5KzWV3Ke', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('437', 'Đinh Thị Thành', 'dtthanh', NULL, NULL, NULL, NULL, NULL, 'dtthanh', '2025-09-03 04:47:49', '$2y$10$z5gK22abk0kb1YSa63Uhx.E50HGYankHBs9oTH1C8HBnERKRLcN0W', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('438', 'Lương T Thanh Loan', 'lttloan', NULL, NULL, NULL, NULL, NULL, 'lttloan', '2025-09-03 04:47:49', '$2y$10$s/jd/ASdAmZkjHtrzVgG7u7dipB5dPrZOQqUIocZTYVEN95rdxA8q', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('439', 'Phan Thanh Trường', 'pttruong', NULL, NULL, NULL, NULL, NULL, 'pttruong', '2025-09-03 04:47:49', '$2y$10$QbFgprWtLwgNC8ISVLft/.eCHE8T5iUXGK541yrvNQEBK.fflhWBa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('440', 'Mai Hồng Sơn', 'mhson', NULL, NULL, NULL, NULL, NULL, 'mhson', '2025-09-03 04:47:49', '$2y$10$HWdBdn8pCzZeUPfNMymPo.mgH7Boiocv7D3nTSeVhNVGuJMK5erOq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('441', 'Nguyễn Thái Bình', 'ntbinh', NULL, NULL, NULL, NULL, NULL, 'ntbinh', '2025-09-03 04:47:49', '$2y$10$8BGSIPHUNCPf1NtrsKL4heuohx9IYw9aCAlbcVxeHBtKr3/CLLgji', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('442', 'Nguyễn Thanh Bình', 'ntbinh_1', NULL, NULL, NULL, NULL, NULL, 'ntbinh_1', '2025-09-03 04:47:49', '$2y$10$qArN4tgRNEi07GfMtYd3rucgvlgrjcnDq.GA0S2i1zJm8NYa90fn6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('443', 'Trần Ngọc Quang', 'tnquang', NULL, NULL, NULL, NULL, NULL, 'tnquang', '2025-09-03 04:47:49', '$2y$10$AdDZYNFfh218ud79e1I04u66mhZoLmPlZgwBXDteuBBTaL54CQjK6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('444', 'Phạm Trường Giang', 'ptgiang', NULL, NULL, NULL, NULL, NULL, 'ptgiang', '2025-09-03 04:47:49', '$2y$10$KDh.fVfWMTjF/BkH7EZuZeRq1QAUk2oTKW8.qXrFmtO.ClP6OyBsq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('445', 'Nguyễn Thị Thảo', 'ntthao', NULL, NULL, NULL, NULL, NULL, 'ntthao', '2025-09-03 04:47:49', '$2y$10$Zqeo0nfHrB5SBOm7GsyrBejiPJNv14St9wnkFd3/8EixjnS9F7Pi2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('446', 'Bùi Văn Khởi', 'bvkhoi', NULL, NULL, NULL, NULL, NULL, 'bvkhoi', '2025-09-03 04:47:49', '$2y$10$tNiDfryw3q45ZcrqXKU8CelyAIoDcXgJnH7qhq.007b.lnmgTLafW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('447', 'Cao Văn Tuyển', 'cvtuyen', NULL, NULL, NULL, NULL, NULL, 'cvtuyen', '2025-09-03 04:47:49', '$2y$10$3xquq0bxFUuFlQLa6AADB.a0rqMv0GPGp5wT9DGUlF13yxrghiT.y', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `users` VALUES ('448', 'Administrator', 'admin', NULL, NULL, NULL, NULL, NULL, 'admin', '2025-09-03 04:50:10', '$2y$10$nKKm3GZ4UqJDflksE78uTOUUeMpCYaKovPgAjEyJ6AjYnBTiXaquu', NULL, NULL, 'KhpmaPvg9DWIrK3VogI1WdwkeP5AFfENiOH7vWoAWJi2fcxyJXVbWaquFHil', NULL, NULL, 'System', 'Administrator', NULL, '2025-09-03 04:50:11', '2025-09-03 04:50:11', NULL);

-- Structure for table `vehicle_registrations`
DROP TABLE IF EXISTS `vehicle_registrations`;
CREATE TABLE `vehicle_registrations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `vehicle_id` bigint unsigned NOT NULL,
  `departure_date` date NOT NULL,
  `return_date` date NOT NULL,
  `departure_time` time NOT NULL,
  `return_time` time NOT NULL,
  `route` text NOT NULL,
  `purpose` text NOT NULL,
  `passenger_count` int DEFAULT '1',
  `driver_name` varchar(255) DEFAULT NULL,
  `driver_license` varchar(255) DEFAULT NULL,
  `status` enum('pending','dept_approved','approved','rejected') DEFAULT 'pending',
  `workflow_status` enum('submitted','dept_review','director_review','approved','rejected') DEFAULT 'submitted',
  `department_approved_by` bigint unsigned DEFAULT NULL,
  `department_approved_at` timestamp NULL DEFAULT NULL,
  `digital_signature_dept` text,
  `director_approved_by` bigint unsigned DEFAULT NULL,
  `director_approved_at` timestamp NULL DEFAULT NULL,
  `digital_signature_director` text,
  `rejection_reason` text,
  `rejection_level` enum('department','director') DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `deleted_by` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `vehicle_registrations`
INSERT INTO `vehicle_registrations` VALUES ('1', '215', '1', '2025-09-04', '2025-09-11', '08:00:00', '17:00:00', '123', '1234', '1', 'Phạm Văn Tặng', '', 'pending', 'dept_review', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Nguyễn Địch Linh', 'Nguyễn Địch Linh', NULL, '2025-09-04 11:57:37', '2025-09-04 11:57:37', NULL);
INSERT INTO `vehicle_registrations` VALUES ('2', '215', '1', '2025-09-11', '2025-09-12', '08:00:00', '17:00:00', 'fff', 'fff', '1', 'Phạm Văn Tặng', '', 'pending', 'approved', NULL, NULL, NULL, '197', '2025-09-04 19:28:08', '{\"approved_by\":\"Ph\\u1ea1m \\u0110\\u1ee9c Giang\",\"approved_at\":\"04\\/09\\/2025 19:28:08\",\"position\":\"Ban Gi\\u00e1m \\u0111\\u1ed1c\",\"signature_path\":\"signatures\\/signature_197_1757003266.png\"}', NULL, NULL, 'Nguyễn Địch Linh', 'Phạm Đức Giang', NULL, '2025-09-04 13:46:03', '2025-09-04 19:28:08', NULL);
INSERT INTO `vehicle_registrations` VALUES ('3', '215', '1', '2025-09-24', '2025-09-25', '08:00:00', '17:00:00', '123', '1234', '1', 'Bùi Thanh Quân', '', 'pending', 'submitted', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Nguyễn Địch Linh', 'Nguyễn Địch Linh', 'Nguyễn Địch Linh', '2025-09-04 13:48:52', '2025-09-04 14:01:36', '2025-09-04 14:01:36');
INSERT INTO `vehicle_registrations` VALUES ('4', '215', '2', '2025-09-24', '2025-09-25', '08:00:00', '17:00:00', 'gff', '123', '1', 'Vũ Hữu Hải', '', 'pending', 'submitted', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Nguyễn Địch Linh', 'Nguyễn Địch Linh', 'Nguyễn Địch Linh', '2025-09-04 13:50:29', '2025-09-04 13:58:00', '2025-09-04 13:58:00');
INSERT INTO `vehicle_registrations` VALUES ('5', '215', '1', '2025-09-04', '2025-09-05', '08:00:00', '17:00:00', '123', '1234', '1', 'Lê Ngọc Duy', '', 'pending', 'approved', '203', '2025-09-04 19:06:26', '{\"approved_by\":\"Nguy\\u1ec5n \\u0110\\u00ecnh S\\u1ef1\",\"approved_at\":\"04\\/09\\/2025 19:06:26\",\"position\":\"Tr\\u01b0\\u1edfng ph\\u00f2ng K\\u1ebf ho\\u1ea1ch\",\"signature_path\":\"signatures\\/signature_203_1756973855.png\"}', '197', '2025-09-04 19:07:03', '{\"approved_by\":\"Ph\\u1ea1m \\u0110\\u1ee9c Giang\",\"approved_at\":\"04\\/09\\/2025 19:07:03\",\"position\":\"Ban Gi\\u00e1m \\u0111\\u1ed1c\",\"signature_path\":null}', NULL, NULL, 'Nguyễn Địch Linh', 'Phạm Đức Giang', NULL, '2025-09-04 14:01:57', '2025-09-04 19:07:03', NULL);

-- Structure for table `vehicles`
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `license_plate` varchar(255) NOT NULL,
  `brand` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `year` int DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `fuel_type` varchar(255) DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `status` enum('available','in_use','maintenance','broken') DEFAULT 'available',
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `deleted_by` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `license_plate` (`license_plate`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `vehicles`
INSERT INTO `vehicles` VALUES ('1', 'Xe chỉ huy 2 cầu UAZ-31512', 'Xe chỉ huy 2 cầu', 'QA-14-73', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:19', NULL);
INSERT INTO `vehicles` VALUES ('2', 'Xe chỉ huy 1 cầu TOYOTA COROLLA 1.6', 'Xe chỉ huy 1 cầu', 'QA-14-91', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:19', NULL);
INSERT INTO `vehicles` VALUES ('3', 'Xe chỉ huy 1 cầu TOYOTA INNOVA', 'Xe chỉ huy 1 cầu', 'QA-59-79', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:19', NULL);
INSERT INTO `vehicles` VALUES ('4', 'Xe TOYOTA-FORTUNER', 'Xe chỉ huy 1 cầu', 'QA-76-66', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:19', NULL);
INSERT INTO `vehicles` VALUES ('5', 'Xe TOYOTA-FORTUNER', 'Xe chỉ huy 1 cầu', 'QA-79-89', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('6', 'Xe vận tải 1 cầu ZIL-130', 'Xe vận tải 1 cầu', 'QA-14-80', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('7', 'Xe vận tải 1 cầu ISUZU NQR-75K', 'Xe vận tải 1 cầu', 'QA-70-58', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('8', 'Xe vận tải 1 cầu KIA 2700', 'Xe vận tải 1 cầu', 'QA-68-99', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('9', 'Xe vận tải 2 cầu KRAZ-257', 'Xe vận tải 2 cầu', 'QA-14-88', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('10', 'Xe vận tải 3 cầu ZIL-131', 'Xe vận tải', 'QA-31-85', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('11', 'Xe ca PAZ-320547', 'Xe ca', 'QA-14-92', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('12', 'Xe ca FORD TRANSIT', 'Xe ca', 'QA-60-54', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('13', 'Xe ca 15 chỗ ngồi TOYOTA HIACE', 'Xe ca', 'QA-14-90', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('14', 'Xe ca 16 chỗ ngồi TOYOTA HIACE', 'Xe ca', 'QA-69-68', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('15', 'Xe ca ISUZU-NRF66R', 'Xe ca', 'QA-14-72', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('16', 'Xe ca SAMCO 34 C', 'Xe ca', 'QA-77-39', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('17', 'Xe ca HYUNDAI COUNTY', 'Xe ca', 'QA-70-59', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('18', 'Xe cứu thương UAZ-3962-016', 'Xe cứu thương', 'QA-46-05', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('19', 'Xe cứu thương HYUNDAI STAREX', 'Xe cứu thương', 'QA-61-82', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('20', 'Xe chữa cháy ZIL-157', 'Xe chữa cháy', 'QA-14-76', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('21', 'Xe chữa cháy DONGFENG', 'Xe chữa cháy', 'QA-58-16', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('22', 'Xe cần trục KC-327/ISUZU', 'Xe cần trục', 'QA-14-71', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('23', 'Xe cần trục XCMG/QY25', 'Xe cần trục', 'QA-62-95', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('24', 'Xe kiểm tra đạn tên lửa KIPS-5К-21/ZIL-131, Liên Xô', 'Xe chuyên dùng Tên lửa', 'QA-14-86', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('25', 'Xe kiểm tra đạn tên lửa KIPS-V2-75M/ZIL-131, Liên Xô', 'Xe chuyên dùng Tên lửa', 'QA-14-87', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:53:20', NULL);
INSERT INTO `vehicles` VALUES ('26', 'Rơ moóc', 'Moóc kéo', 'MTZ - 80', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:46:43', '2025-09-05 02:46:43', NULL);
INSERT INTO `vehicles` VALUES ('27', 'Xe nâng TCM-4,0 - FD40T9', 'Xe nâng hàng', 'QA-', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', 'System', '2025-09-05 02:52:48', '2025-09-05 02:53:51', '2025-09-05 02:53:51');
INSERT INTO `vehicles` VALUES ('29', 'Xe nâng TCM-4,0 - FD40T9', 'Xe nâng hàng', 'XN-001', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:53:03', '2025-09-05 02:53:03', NULL);
INSERT INTO `vehicles` VALUES ('30', 'Xe nâng TOYOTAF8F050N', 'Xe nâng hàng', 'XN-002', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:53:03', '2025-09-05 02:53:03', NULL);
INSERT INTO `vehicles` VALUES ('31', 'Xe nâng FB10-MQC2', 'Xe nâng hàng', 'XN-003', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:53:03', '2025-09-05 02:53:03', NULL);

-- Structure for table `webhook_calls`
DROP TABLE IF EXISTS `webhook_calls`;
CREATE TABLE `webhook_calls` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `headers` json DEFAULT NULL,
  `payload` json DEFAULT NULL,
  `exception` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
