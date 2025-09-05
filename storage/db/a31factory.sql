-- HRMS Database Export
-- Generated on: 2025-09-05 10:51:52
-- Database: a31_factory

SET FOREIGN_KEY_CHECKS = 0;

-- Structure for table `assets`
DROP TABLE IF EXISTS `assets`;
CREATE TABLE `assets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `old_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serial_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `class` enum('Electronic','Furniture','Gear') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('Good','Fine','Bad','Damaged') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `in_service` tinyint(1) NOT NULL DEFAULT '1',
  `is_gpr` tinyint(1) NOT NULL DEFAULT '1',
  `real_price` int DEFAULT NULL,
  `expected_price` int DEFAULT NULL,
  `acquisition_date` date DEFAULT NULL,
  `acquisition_type` enum('Directed','Founded','Transferred') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `funded_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `bulk_messages`
DROP TABLE IF EXISTS `bulk_messages`;
CREATE TABLE `bulk_messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `numbers` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_sent` tinyint(1) NOT NULL DEFAULT '0',
  `error` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `categories`
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`category_id`,`sub_category_id`),
  KEY `category_sub_category_sub_category_id_foreign` (`sub_category_id`),
  CONSTRAINT `category_sub_category_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `category_sub_category_sub_category_id_foreign` FOREIGN KEY (`sub_category_id`) REFERENCES `sub_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `changelogs`
DROP TABLE IF EXISTS `changelogs`;
CREATE TABLE `changelogs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `departments`
DROP TABLE IF EXISTS `departments`;
CREATE TABLE `departments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `departments`
INSERT INTO `departments` VALUES ('1', 'BAN GIÁM ĐỐC', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `departments` VALUES ('2', 'Phòng Kế hoạch', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `departments` VALUES ('3', 'Ban Chính trị', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `departments` VALUES ('4', 'Phòng Kỹ thuật', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `departments` VALUES ('5', 'Phòng Cơ điện', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `departments` VALUES ('6', 'Phòng Vật tư', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `departments` VALUES ('7', 'Phòng kiểm tra chất lượng', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `departments` VALUES ('8', 'Phòng Tài chính', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `departments` VALUES ('9', 'Phòng Hành chính-Hậu cần', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `departments` VALUES ('10', 'PX1: Đài điều khiển', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `departments` VALUES ('11', 'PX2: BỆ PHÓNG', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `departments` VALUES ('12', 'PX3: SC XE ĐẶC CHỦNG', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `departments` VALUES ('13', 'PX4: CƠ KHÍ', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `departments` VALUES ('14', 'PX5: KÍP, ĐẠN TÊN LỬA', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `departments` VALUES ('15', 'PX6: XE MÁY-TNĐ', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `departments` VALUES ('16', 'PX7:  ĐO LƯỜNG', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `departments` VALUES ('17', 'PX8: ĐỘNG CƠ-BIẾN THẾ', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `departments` VALUES ('18', 'PX 9: HÓA NGHIỆM PHỤC HỒI \"O, G\"', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);

-- Structure for table `discounts`
DROP TABLE IF EXISTS `discounts`;
CREATE TABLE `discounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint unsigned NOT NULL,
  `rate` int NOT NULL,
  `date` date NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_auto` tinyint(1) NOT NULL DEFAULT '0',
  `is_sent` tinyint(1) NOT NULL DEFAULT '0',
  `batch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','approved','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `approved_by` bigint unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `digital_signature` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `signature_certificate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `workflow_status` enum('draft','submitted','under_review','approved','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `reviewer_id` bigint unsigned DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `is_authorized` tinyint(1) NOT NULL DEFAULT '0',
  `is_checked` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `enlist_date` date DEFAULT NULL,
  `rank_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position_id` bigint unsigned DEFAULT NULL,
  `department_id` bigint unsigned DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `quit_date` date DEFAULT NULL,
  `CCCD` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` tinyint(1) NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_leave_allowed` int NOT NULL DEFAULT '0',
  `annual_leave_balance` int NOT NULL DEFAULT '12' COMMENT 'Số ngày nghỉ phép còn lại trong năm',
  `annual_leave_total` int NOT NULL DEFAULT '12' COMMENT 'Tổng số ngày nghỉ phép trong năm',
  `annual_leave_used` int NOT NULL DEFAULT '0' COMMENT 'Số ngày nghỉ phép đã sử dụng',
  `delay_counter` time NOT NULL DEFAULT '00:00:00',
  `hourly_counter` time NOT NULL DEFAULT '00:00:00',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `profile_photo_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employees_mobile_number_unique` (`phone`),
  UNIQUE KEY `employees_national_number_unique` (`CCCD`),
  KEY `employees_user_id_foreign` (`user_id`),
  KEY `employees_position_id_foreign` (`position_id`),
  KEY `employees_department_id_foreign` (`department_id`),
  CONSTRAINT `employees_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_position_id_foreign` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `employees`
INSERT INTO `employees` VALUES ('1', '1', 'Phạm Đức Giang', '1973-09-05', '1991-09-01', '4//', '1', '1', '1991-09-01', NULL, NULL, '0813607408', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('2', '2', 'Hà Tiến Thụy', '1975-01-01', NULL, '4//', '2', '1', '2025-09-03', NULL, NULL, '0484231487', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 01:55:32', NULL);
INSERT INTO `employees` VALUES ('3', '3', 'Cao Anh Hùng', '1974-08-06', '1991-09-01', '4//', '3', '1', '1991-09-01', NULL, NULL, '0256921095', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('4', '4', 'Bùi Tân Chinh', '1979-12-04', '2003-09-01', '3//', '3', '1', '1903-09-01', NULL, NULL, '0595085624', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('5', '5', 'Nguyễn Văn  Bảy', '1972-09-20', '1991-03-01', '3//', '3', '1', '1991-03-01', NULL, NULL, '0865445790', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('6', '6', 'Phạm Ngọc Sơn', '1967-10-22', '1985-08-01', '4//', '4', '1', '1985-08-01', NULL, NULL, '0171566265', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('7', '7', 'Nguyễn Đình Sự', '1986-09-16', '2005-09-01', '2//', '5', '2', '1905-09-01', NULL, NULL, '0581680562', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('8', '8', 'Phạm Tiến Long', '1977-05-30', '1996-09-01', '3//', '6', '2', '1996-09-01', NULL, NULL, '0727924802', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('9', '9', 'Đặng Đình Quỳnh', '1983-09-18', '2004-09-01', '2//', '7', '2', '1904-09-01', NULL, NULL, '0909713395', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('10', '10', 'Lục Viết Hợp', '1983-01-01', NULL, '1//', '7', '2', '2025-09-03', NULL, NULL, '0982200405', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('11', '11', 'Trần Đình Tài', '1968-11-20', '1986-02-01', '3//CN', '8', '2', '1986-02-01', NULL, NULL, '0170600909', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('12', '12', 'Trịnh Thị Thuý Hà', '1982-09-03', '2005-07-01', '2//', '9', '2', '1905-07-01', NULL, NULL, '0216999815', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('13', '13', 'Trịnh Văn Cương', '1993-08-23', '2011-08-01', '4/', '9', '2', '1911-08-01', NULL, NULL, '0239429583', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('14', '14', 'Nguyễn T Thu Hà', '1995-08-29', '2024-07-01', '2/', '9', '2', '1924-07-01', NULL, NULL, '0871344116', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('15', '15', 'Vũ Thành Trung', '1980-02-24', '1998-02-01', '1//CN', '10', '2', '1998-02-01', NULL, NULL, '0970483478', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('16', '16', 'Phạm Thị Thuý', '1976-10-15', '2003-12-01', '1//CN', '11', '2', '1903-12-01', NULL, NULL, '0448462377', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('17', '17', 'Phạm Thị Trà', '1975-06-02', '1999-03-01', '1//CN', '12', '2', '1999-03-01', NULL, NULL, '0990778255', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('18', '18', 'Vũ Thanh Hà', '1987-08-12', '2006-02-01', '1//CN', '13', '2', '1906-02-01', NULL, NULL, '0808504069', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('19', '19', 'Nguyễn Địch Linh', '1990-07-18', '2008-09-01', '1//CN', '14', '2', '1908-09-01', NULL, NULL, '0861266287', '1', NULL, '0', '10', '12', '2', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('20', '20', 'Tạ Quốc Bảo', '1997-09-06', '2017-02-01', '2/CN', '15', '2', '1917-02-01', NULL, NULL, '0813718880', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('21', '21', 'Trần Ngọc Liễu', '1985-05-14', '2011-10-01', '1//CN', '10', '2', '1911-10-01', NULL, NULL, '0700456648', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('22', '22', 'Nguyễn T Thu Thanh', '1974-04-28', '1992-02-01', '2//CN', '13', '2', '1992-02-01', NULL, NULL, '0908926259', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('23', '23', 'Trần Hữu Ngọc', '1985-12-16', '2005-02-01', '1//CN', '16', '2', '1905-02-01', NULL, NULL, '0701776136', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('24', '24', 'Nguyễn Minh Thanh', '1973-07-10', '1992-02-01', '2//CN', '17', '2', '1992-02-01', NULL, NULL, '0956693140', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('25', '25', 'Nông Tiến Tân', '1993-09-22', '2011-09-01', '4/CN', '17', '2', '1911-09-01', NULL, NULL, '0198649828', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('26', '26', 'Nguyễn Trọng Toàn', '1975-10-01', '1994-02-01', '1//CN', '17', '2', '1994-02-01', NULL, NULL, '0395650715', '1', NULL, '0', '9', '12', '3', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('27', '27', 'Phạm Văn Bảy', '1974-05-05', '1993-03-01', '1//CN', '18', '2', '1993-03-01', NULL, NULL, '0994877811', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('28', '28', 'Phạm Văn Tặng', '1978-03-27', '1999-03-01', '1//CN', '19', '2', '1999-03-01', NULL, NULL, '0682543112', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('29', '29', 'Bùi Thanh Quân', '1979-01-15', '1999-03-01', '4/CN', '19', '2', '1999-03-01', NULL, NULL, '0497697513', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('30', '30', 'Vũ Hữu Hải', '1980-09-30', '2001-02-01', '4/CN', '19', '2', '1901-02-01', NULL, NULL, '0729289086', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('31', '31', 'Lê Ngọc Duy', '1990-01-31', '2009-02-01', '3/CN', '19', '2', '1909-02-01', NULL, NULL, '0101042101', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('32', '32', 'Nguyễn Văn Thắng', '1987-01-02', '2006-09-01', '1//CN', '121', '27', '1991-09-01', NULL, NULL, '0320889580', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:55:32', NULL);
INSERT INTO `employees` VALUES ('33', '33', 'Nguyễn Tiến Cường', '1986-07-04', '2013-03-01', '1//CN', '19', '2', '1913-03-01', NULL, NULL, '0334798263', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('34', '34', 'Hoàng Văn Tình', '1979-08-01', '1999-03-01', '1//CN', '19', '2', '1999-03-01', NULL, NULL, '0495730722', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('35', '35', 'Hoàng Anh Đức', '2004-10-31', '2023-02-01', '1/CN', '19', '2', '1923-02-01', NULL, NULL, '0785020284', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('36', '36', 'Hoàng Bảo Chung', '1995-11-23', '2014-09-01', '3/CN', '19', '2', '1914-09-01', NULL, NULL, '0854819970', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('37', '37', 'Phạm Thị Thu Hương', '1974-09-22', '1992-03-01', '3//', '122', '28', '1992-03-01', NULL, NULL, '0780781213', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:55:32', NULL);
INSERT INTO `employees` VALUES ('38', '38', 'Phan Minh Nghĩa', '1984-07-20', '2004-02-01', '1//', '21', '3', '1904-02-01', NULL, NULL, '0920903836', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('39', '39', 'Nguyễn Trung Kiên', '1985-10-16', '2003-09-01', '2//', '6', '4', '1996-11-01', NULL, NULL, '0558266144', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'Nguyễn Đình Sự', NULL, '2025-09-03 04:47:36', '2025-09-05 10:45:10', NULL);
INSERT INTO `employees` VALUES ('40', '32', 'Nguyễn Văn Thắng', '1987-01-02', '2006-09-01', '1//', '124', '28', '1906-09-01', NULL, NULL, '0374825969', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:55:32', NULL);
INSERT INTO `employees` VALUES ('41', '41', 'Đặng Trọng Chánh', '1994-01-01', NULL, '3/', '22', '3', '2025-09-03', NULL, NULL, '0170893421', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('42', '42', 'Nguyễn Minh Hiếu', '1999-10-17', '2017-09-01', '3/', '22', '3', '1917-09-01', NULL, NULL, '0727463273', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('43', '43', 'Bùi Thị Nhật Lệ', '1997-03-29', '2016-02-01', '1/', '23', '3', '1916-02-01', NULL, NULL, '0491873758', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('44', '44', 'Nguyễn Văn Ngà', '1983-09-05', '2002-09-01', '2//', '5', '4', '1902-09-01', NULL, NULL, '0377043208', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('45', '39', 'Nguyễn Trung Kiên', '1985-10-16', '2003-09-01', '2//', '126', '29', '1903-09-01', NULL, NULL, '0942201346', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:55:32', NULL);
INSERT INTO `employees` VALUES ('46', '46', 'Phạm Duy Thái', '1993-11-17', '2011-08-01', '4/', '24', '4', '1911-08-01', NULL, NULL, '0797918461', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('47', '47', 'Lê Quý Vũ', '1983-06-24', '2001-09-01', '2//', '25', '4', '1901-09-01', NULL, NULL, '0248603802', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('48', '48', 'Nguyên Hữu Ngọc', '1991-11-09', '2009-09-01', '1//', '26', '4', '1909-09-01', NULL, NULL, '0750761331', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('49', '49', 'Lại Hoàng Hà', '1988-09-12', '2006-09-01', '1//', '27', '4', '1906-09-01', NULL, NULL, '0454602011', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('50', '50', 'Dương Thế Vinh', '1993-07-22', '2011-08-01', '4/', '27', '4', '1911-08-01', NULL, NULL, '0342975142', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('51', '51', 'Đỗ Văn Quân', '1992-01-01', NULL, '4/', '27', '4', '2025-09-03', NULL, NULL, '0603485352', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('52', '52', 'Nguyễn Văn Bình', '1992-10-30', '2011-09-01', '4/', '27', '4', '1911-09-01', NULL, NULL, '0758046096', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('53', '53', 'Bùi Công Đoài', '1988-09-25', '2006-09-01', '1//', '27', '4', '1906-09-01', NULL, NULL, '0467053948', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('54', '54', 'Đặng Hùng', '1983-06-23', '2003-09-01', '1//', '27', '4', '1903-09-01', NULL, NULL, '0819551514', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('55', '55', 'Ngô Văn Hiển', '1986-12-10', '2004-09-01', '2//', '27', '4', '1904-09-01', NULL, NULL, '0501356527', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('56', '56', 'Đỗ Văn Linh', '1994-03-25', '2012-09-01', '4/', '27', '4', '1912-09-01', NULL, NULL, '0820823468', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('57', '57', 'Hoàng Công Thành', '1992-12-04', '2009-09-01', '4/', '27', '4', '1909-09-01', NULL, NULL, '0393908735', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('58', '58', 'Văn Sỹ Lực', '1997-05-07', '2015-09-01', '3/', '27', '4', '1915-09-01', NULL, NULL, '0730276861', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('59', '59', 'Nguyễn Trần Đức', '1995-04-27', '2013-09-01', '4/', '27', '4', '1913-09-01', NULL, NULL, '0607019552', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('60', '60', 'Lê Minh Vượng', '1999-01-14', '2017-09-01', '3/', '27', '4', '1917-09-01', NULL, NULL, '0440522933', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('61', '61', 'Tạ Văn Hoàng', '1993-01-01', NULL, '4/', '27', '4', '2025-09-03', NULL, NULL, '0259474395', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('62', '62', 'Phạm Thị Phương', '1980-10-30', '1998-11-01', '1//CN', '28', '4', '1998-11-01', NULL, NULL, '0862131569', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('63', '63', 'Lê Thị Vân', '1975-06-02', '2001-02-01', '1//CN', '28', '4', '1901-02-01', NULL, NULL, '0334519771', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('64', '64', 'Trần Xuân Trường', '1987-06-21', '2015-03-01', '1//CN', '29', '4', '1915-03-01', NULL, NULL, '0560832449', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('65', '65', 'Nguyễn Đình Tuấn', '1986-11-19', '2006-02-01', '1//CN', '29', '4', '1906-02-01', NULL, NULL, '0947484054', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('66', '66', 'Trần Ngọc Dũng', '1987-12-08', '2006-09-01', '1//', '5', '5', '1906-09-01', NULL, NULL, '0773793892', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('67', '67', 'Nguyễn Anh Tuấn', '1987-03-12', '2006-02-01', '3//CN', '132', '30', '1992-02-01', NULL, NULL, '0181396362', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:55:32', NULL);
INSERT INTO `employees` VALUES ('68', '68', 'Nguyễn Xuân Dũng', '1974-10-06', '1992-02-01', '1//CN', '31', '5', '1992-02-01', NULL, NULL, '0848660299', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('69', '69', 'Ngô Viết  Toản', '1973-08-12', '1994-02-01', 'CNQP', '32', '5', '1994-02-01', NULL, NULL, '0199797470', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('70', '70', 'Hoàng Minh Ánh', '1973-12-22', '1993-02-01', 'CNQP', '32', '5', '1993-02-01', NULL, NULL, '0395910099', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('71', '71', 'Nguyễn Văn Luỹ', '1984-10-25', '2002-09-01', '2//', '5', '6', '1902-09-01', NULL, NULL, '0808150189', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('72', '72', 'Trần Bá Trường', '1991-12-17', '2010-09-01', '4/', '33', '6', '1910-09-01', NULL, NULL, '0705733593', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('73', '73', 'Bùi Văn Phong', '1985-10-04', '2003-10-01', '1//CN', '15', '6', '1903-10-01', NULL, NULL, '0872852650', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('74', '74', 'Mai Văn Thuy', '1967-05-28', '1986-02-01', '3//CN', '34', '6', '1986-02-01', NULL, NULL, '0282779057', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('75', '75', 'Nguyễn Văn Cường', '1979-07-17', '1998-02-01', '2//CN', '136', '31', '1994-02-01', NULL, NULL, '0813180221', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:55:32', NULL);
INSERT INTO `employees` VALUES ('76', '76', 'Phan Thị Thu Hường', '1983-09-21', '2003-12-01', '2//CN', '117', '31', '1903-12-01', NULL, NULL, '0350733848', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:55:32', NULL);
INSERT INTO `employees` VALUES ('77', '77', 'Trịnh Thu Huyền', '1982-11-27', '2003-12-01', '1//CN', '34', '6', '1903-12-01', NULL, NULL, '0915338822', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('78', '78', 'Đặng Thị Huệ', '1993-05-08', '2015-03-01', '4/CN', '15', '6', '1915-03-01', NULL, NULL, '0276273632', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('79', '79', 'Đinh Tiến Dũng', '1976-07-13', '1997-03-01', '1//CN', '35', '6', '1997-03-01', NULL, NULL, '0736552285', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('80', '80', 'Đoàn Thị Sự', '1971-12-12', '1999-03-01', '1//CN', '35', '6', '1999-03-01', NULL, NULL, '0235197069', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('81', '81', 'Phạm Thị Thu  Hà', '1976-12-15', '1995-02-01', '1//CN', '35', '6', '1995-02-01', NULL, NULL, '0607766355', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('82', '82', 'Đinh Thị Tâm', '1979-05-05', '2003-12-01', '4/CN', '35', '6', '1903-12-01', NULL, NULL, '0394662098', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('83', '83', 'Nguyễn Thị Hiền', '1992-08-02', '2020-12-01', '2/CN', '15', '6', '1920-12-01', NULL, NULL, '0993670447', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('84', '84', 'Đinh Quang Điềm', '1985-11-02', '2003-09-01', '2//', '5', '7', '1903-09-01', NULL, NULL, '0523300647', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('85', '85', 'Huỳnh Thái Tân', '1967-06-16', '1986-03-01', '3//CN', '36', '7', '1986-03-01', NULL, NULL, '0217769712', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('86', '86', 'Mai Trường Giang', '1974-01-02', '1992-02-01', '3//CN', '37', '7', '1992-02-01', NULL, NULL, '0852064307', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('87', '87', 'Nguyễn Việt Dũng', '1976-06-26', '1995-02-01', '2//CN', '37', '7', '1995-02-01', NULL, NULL, '0854032458', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('88', '88', 'Nguyễn Xuân Quý', '1977-02-12', '1996-03-01', '1//CN', '36', '7', '1996-03-01', NULL, NULL, '0430902538', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('89', '89', 'Nguyễn Xuân Bách', '1975-05-31', '1994-02-01', '2//CN', '38', '7', '1994-02-01', NULL, NULL, '0432021487', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('90', '90', 'Nguyễn Ngọc Quý', '1983-10-06', '2003-02-01', '1//CN', '39', '7', '1903-02-01', NULL, NULL, '0984035226', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('91', '91', 'Thái Thị Hà', '1981-07-08', '2001-02-01', '2//CN', '40', '7', '1901-02-01', NULL, NULL, '0844455188', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('92', '92', 'Nguyễn Văn Bách', '1974-07-15', '1992-02-01', '1//CN', '41', '7', '1992-02-01', NULL, NULL, '0142468704', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('93', '75', 'Nguyễn Văn Cường', '1979-07-17', '1998-02-01', '1//', '107', '33', '1998-02-01', NULL, NULL, '0254599833', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:55:32', NULL);
INSERT INTO `employees` VALUES ('94', '94', 'Nguyễn Văn Phú', '1988-08-14', '2007-03-01', '4/CN', '42', '8', '1907-03-01', NULL, NULL, '0375721881', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('95', '95', 'Phạm Thị Kiều Ân', '1982-06-13', '2003-12-01', '1//CN', '43', '8', '1903-12-01', NULL, NULL, '0668336295', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('96', '96', 'Nguyễn Thị Thuý', '1991-09-01', '2024-08-01', '1//CN', '144', '33', '1912-02-01', NULL, NULL, '0567187645', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('97', '97', 'Dương Thị Mơ', '1990-10-19', '2015-03-01', '1//CN', '42', '8', '1915-03-01', NULL, NULL, '0990608083', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('98', '98', 'Nguyễn Thị Hằng', '1995-06-24', '2016-02-01', '4/CN', '42', '8', '1916-02-01', NULL, NULL, '0961056193', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('99', '99', 'Phạm T Thu Hương', '1983-07-16', '2003-12-01', '1//CN', '145', '33', '1903-12-01', NULL, NULL, '0250970195', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('100', '100', 'Chử  Quang Anh', '1980-02-10', '1999-03-01', '2//', '5', '9', '1999-03-01', NULL, NULL, '0350793747', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('101', '101', 'Đào Văn Tiến', '1973-08-31', '1991-09-01', '3//', '44', '9', '1991-09-01', NULL, NULL, '0759488507', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('102', '102', 'Trần Đình Tám', '1979-07-30', '1999-03-01', '2//CN', '45', '9', '1999-03-01', NULL, NULL, '0251264032', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('103', '103', 'Nguyễn Quỳnh Trang', '1981-04-02', '2001-02-01', '2//CN', '46', '9', '1901-02-01', NULL, NULL, '0975152848', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('104', '104', 'Lê Mạnh Hà', '1990-08-13', '2012-02-01', '4/CN', '47', '9', '1912-02-01', NULL, NULL, '0843923653', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('105', '105', 'Nguyễn Thị Anh', '1990-08-24', '2015-03-01', '2/CN', '48', '9', '1915-03-01', NULL, NULL, '0166297173', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('106', '106', 'Đỗ Đức Toàn', '1984-10-21', '2013-03-01', '1//CN', '49', '9', '1913-03-01', NULL, NULL, '0835937210', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('107', '107', 'Triệu T Hoài Phương', '1987-11-13', '2016-09-01', '2/CN', '49', '9', '1916-09-01', NULL, NULL, '0289573371', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('108', '108', 'Trịnh Bá Thuận', '1966-08-16', '1983-09-01', '1//CN', '45', '9', '2025-09-03', NULL, NULL, '0770004609', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('109', '109', 'Đặng Quốc Sỹ', '1980-01-20', '2001-02-01', '4/CN', '45', '9', '1901-02-01', NULL, NULL, '0819595056', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('110', '110', 'Phạm Lan Phương', '1994-05-14', '2016-09-01', '2/CN', '49', '9', '1916-09-01', NULL, NULL, '0488967404', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('111', '111', 'Giang Chí Dũng', '1998-01-18', '2022-12-01', '2/CN', '45', '9', '1922-12-01', NULL, NULL, '0648055508', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('112', '112', 'Nguyễn Thị Huyền', '1990-10-28', '2022-12-01', 'CNQP', '151', '34', '1922-12-01', NULL, NULL, '0527826313', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('113', '113', 'Nguyễn T Phương Chi', '1981-06-17', '2001-02-01', '1//CN', '50', '9', '1901-02-01', NULL, NULL, '0782360762', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('114', '114', 'Phạm Thị Vân Anh', '1992-03-28', '2014-03-01', '3/CN', '50', '9', '1914-03-01', NULL, NULL, '0998037568', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('115', '115', 'Trần Thị Tuyến', '1989-06-20', '2014-03-01', '4/CN', '50', '9', '1914-03-01', NULL, NULL, '0171778150', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('116', '116', 'Bùi Đức Anh', '1993-10-31', '2015-03-01', '3/CN', '50', '9', '1915-03-01', NULL, NULL, '0674682168', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('117', '117', 'Vũ Thị Kim Ngân', '1989-08-27', '2013-03-01', '2/CN
3/CN', '50', '9', '1913-03-01', NULL, NULL, '0665529245', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('118', '118', 'Nguyễn Thu Huyền', '1982-09-20', '2013-03-01', '3/CN', '153', '34', '1913-03-01', NULL, NULL, '0995660647', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('119', '119', 'Trần Trọng Đại', '1985-12-04', '2004-08-01', '1//', '52', '10', '1904-08-01', NULL, NULL, '0147019491', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('120', '120', 'Lưu Hoàng Văn', '1992-05-10', '2009-09-01', '4/', '53', '10', '1909-09-01', NULL, NULL, '0352581696', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('121', '121', 'Đồng Xuân Dũng', '1999-01-01', NULL, '3/', '33', '10', '2025-09-03', NULL, NULL, '0269156422', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('122', '122', 'Trương Thanh Tú', '2001-01-01', NULL, '2/', '33', '10', '2025-09-03', NULL, NULL, '0629455091', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('123', '123', 'Dương T Phương Loan', '1977-08-29', '2003-12-01', '1//CN', '54', '10', '1903-12-01', NULL, NULL, '0714513071', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('124', '124', 'Nguyễn  Hữu Thanh', '1983-09-02', '2002-10-01', '1//CN', '55', '10', '1902-10-01', NULL, NULL, '0726829730', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('125', '125', 'Nguyễn Thị Tuyền', '1983-02-13', '2012-02-01', '2/CN', '56', '10', '1912-02-01', NULL, NULL, '0330755831', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('126', '126', 'Lê Thị Thuý Hằng', '1985-03-24', '2012-02-01', '3/CN', '56', '10', '1912-02-01', NULL, NULL, '0642923840', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('127', '127', 'Nguyễn T Thuý Bình', '1984-10-30', '2012-02-01', '4/CN', '57', '10', '1912-02-01', NULL, NULL, '0196793097', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('128', '128', 'Đặng Thị Kim Dung', '1981-06-05', '2016-09-01', '1/CN', '56', '10', '1916-09-01', NULL, NULL, '0994859847', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('129', '129', 'Dương Thị Thân Thương', '1989-06-29', '2014-03-01', 'CNQP', '56', '10', '1914-03-01', NULL, NULL, '0786523810', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('130', '130', 'Phạm Thị Trang Nhung', '1979-09-27', '2012-02-01', 'CNQP', '56', '10', '1912-02-01', NULL, NULL, '0919934828', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('131', '131', 'Trần Thị Chuyên', '1990-10-20', '2014-03-01', '4/CN', '56', '10', '1914-03-01', NULL, NULL, '0819588517', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('132', '132', 'Phạm Khắc Hùng', '1985-10-12', '2004-02-01', '1//CN', '58', '10', '1904-02-01', NULL, NULL, '0953364443', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('133', '133', 'Nguyễn Mạnh Hùng', '1974-05-01', '1995-02-01', '2//CN', '59', '10', '1995-02-01', NULL, NULL, '0592416178', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('134', '134', 'Vũ Mạnh Tú', '1985-06-26', '2004-02-01', '1//CN', '59', '10', '1904-02-01', NULL, NULL, '0113366628', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('135', '135', 'Bùi Anh Tuấn', '1983-03-11', '2004-02-01', '1//CN', '59', '10', '1904-02-01', NULL, NULL, '0577862020', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('136', '136', 'Nguyễn Văn Thụ', '1988-11-03', '2012-02-01', '4/CN', '59', '10', '1912-02-01', NULL, NULL, '0275089629', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('137', '137', 'Đặng Văn Phố', '1974-01-01', '1992-02-01', '2//CN', '59', '10', '1992-02-01', NULL, NULL, '0207262541', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('138', '138', 'Nguyễn Xuân Trường', '1982-02-25', '2001-02-01', '1//CN', '59', '10', '1901-02-01', NULL, NULL, '0951229831', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('139', '139', 'Hà Thanh Trung', '1973-10-20', '1992-02-01', '3//CN', '60', '10', '1992-02-01', NULL, NULL, '0447437094', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('140', '140', 'Nguyễn Văn Huyên', '1982-08-20', '2002-03-01', '1//CN', '61', '10', '1902-03-01', NULL, NULL, '0755880893', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('141', '141', 'Nguyễn Gia Mạnh', '1985-06-25', '2005-02-01', '1//CN', '61', '10', '1905-02-01', NULL, NULL, '0363675519', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('142', '142', 'Đỗ Hồng Sơn', '2001-12-27', '2020-02-01', '1/CN', '61', '10', '1920-02-01', NULL, NULL, '0774831580', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('143', '143', 'Nguyễn Tuấn Hiệp', '1974-06-04', '1995-10-01', '1//CN', '61', '10', '1995-10-01', NULL, NULL, '0229253855', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('144', '144', 'Vũ Mạnh Cương', '1978-05-09', '2003-12-01', '4/CN', '62', '10', '1903-12-01', NULL, NULL, '0781719874', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('145', '145', 'Lê Trọng Quỳnh', '1989-12-07', '2016-09-01', '1//CN', '63', '10', '1903-12-01', NULL, NULL, '0696730469', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('146', '146', 'Đặng Viết Công', '1983-09-12', '2003-12-01', '4/CN', '64', '10', '1903-12-01', NULL, NULL, '0465020201', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('147', '147', 'Nguyễn Tiến Dũng', '1996-09-22', '2015-03-01', '2/CN', '64', '10', '1915-03-01', NULL, NULL, '0652860521', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('148', '148', 'Nguyễn Hồng Anh', '1981-05-04', '1999-09-01', '2//', '52', '11', '1999-09-01', NULL, NULL, '0199032187', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('149', '149', 'Trần Đức Tấn', '1987-07-11', '2005-09-01', '1//', '65', '11', '1905-09-01', NULL, NULL, '0720677487', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('150', '150', 'Hoàng Anh Dũng', '2000-08-21', '2018-09-01', '2/', '33', '11', '1918-09-01', NULL, NULL, '0472267865', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('151', '151', 'Nguyễn Mai Hương', '1983-09-01', '2003-12-01', '1//CN', '54', '11', '1903-12-01', NULL, NULL, '0316820398', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('152', '152', 'Hoàng Văn Tiến', '1978-05-16', '1998-02-01', '1//CN', '66', '11', '1998-02-01', NULL, NULL, '0357064910', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('153', '153', 'Nguyễn Xuân Thụ', '1989-03-23', '2007-10-01', '4/CN', '67', '11', '1907-10-01', NULL, NULL, '0243675579', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('154', '154', 'Hà Nguyễn Tuấn Anh', '1998-12-02', '2024-08-01', 'CNQP', '67', '11', '1924-08-01', NULL, NULL, '0590852755', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('155', '155', 'Đinh Viết Trường', '1992-08-28', '2010-09-01', '4/CN', '67', '11', '1910-09-01', NULL, NULL, '0380649803', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('156', '156', 'Phan Thanh Quang', '1981-05-23', '2000-02-01', '1//CN', '68', '11', '1900-02-01', NULL, NULL, '0803386398', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('157', '157', 'Nguyễn Tiến Nam', '1981-10-09', '2000-02-01', '4/CN', '69', '11', '1900-02-01', NULL, NULL, '0245080189', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('158', '158', 'Nguyễn Huy Thắng', '1983-01-01', '2004-02-01', '3/CN', '69', '11', '1904-02-01', NULL, NULL, '0839061095', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('159', '159', 'Trần Hồng Công', '1989-10-21', '2016-09-01', '2/CN', '69', '11', '1916-09-01', NULL, NULL, '0154690992', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('160', '160', 'An Văn Trực', '1983-07-09', '2001-09-01', '3//', '52', '12', '1901-09-01', NULL, NULL, '0266696389', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('161', '161', 'Phạm Quỳnh Trang', '1987-10-28', '2012-02-01', '3/CN', '70', '12', '1912-02-01', NULL, NULL, '0155318729', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 10:18:37', NULL);
INSERT INTO `employees` VALUES ('162', '162', 'Ngô Thị Sơn', '1970-09-26', '1998-06-01', '2//CN', '54', '12', '1998-06-01', NULL, NULL, '0966304046', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('163', '67', 'Nguyễn Anh Tuấn', '1987-03-12', '2006-02-01', '1//CN', '173', '37', '1906-02-01', NULL, NULL, '0681874793', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('164', '164', 'Trần  Ngọc Phú', '1983-12-18', '2002-03-01', '1//CN', '72', '12', '1902-03-01', NULL, NULL, '0572235301', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('165', '165', 'Nguyễn Tuấn Long', '1976-07-13', '1994-02-01', '4/CN', '175', '37', '1903-02-01', NULL, NULL, '0733435735', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('166', '166', 'Nguyễn Đức Anh', '1993-06-08', '2022-12-01', '1/CN', '73', '12', '1922-12-01', NULL, NULL, '0129195379', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('167', '167', 'Nguyễn Phú Hùng', '1995-01-06', '2023-12-01', '2/CN', '73', '12', '1923-12-01', NULL, NULL, '0602150851', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('168', '168', 'Nguyễn Anh Đạt', '1995-06-25', '2014-03-01', '3/CN', '73', '12', '1914-03-01', NULL, NULL, '0740755072', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('169', '169', 'Trịnh Trọng Cường', '1975-01-15', '1994-02-01', '1//CN', '74', '12', '1994-02-01', NULL, NULL, '0918952686', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('170', '170', 'Cấn Xuân Khánh', '1991-02-14', '2010-09-01', '4/', '52', '13', '1910-09-01', NULL, NULL, '0507215127', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('171', '171', 'Vũ Thị Hiền', '1988-02-08', '2012-02-01', '4/CN', '54', '13', '1912-02-01', NULL, NULL, '0283107764', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('172', '172', 'Phan Văn Đăng', '1974-05-05', '1995-02-01', 'CNQP', '75', '13', '1995-02-01', NULL, NULL, '0992174156', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('173', '173', 'Bùi Mạnh Hùng', '1982-10-30', '2016-02-01', '1//CN', '76', '13', '1916-02-01', NULL, NULL, '0203346191', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('174', '174', 'Trần Văn Thành', '1974-08-16', '1994-02-01', '1//CN', '77', '13', '1994-02-01', NULL, NULL, '0346794048', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('175', '175', 'Vũ Trịnh Giang', '1992-09-02', '2016-02-01', '2/CN', '77', '13', '1916-02-01', NULL, NULL, '0259476389', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('176', '165', 'Nguyễn Tuấn Long', '1976-07-13', '1994-02-01', '1//CN', '180', '38', '1994-02-01', NULL, NULL, '0350557677', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('177', '177', 'Vũ Huy Phương', '1986-09-25', '2014-03-01', '1//CN', '79', '13', '1914-03-01', NULL, NULL, '0514641952', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('178', '178', 'Vũ Hải Dương', '1991-05-16', '2016-02-01', '4/CN', '79', '13', '1916-02-01', NULL, NULL, '0361164367', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('179', '179', 'Trịnh Thành Chung', '1986-08-01', '2016-09-01', '2/CN', '79', '13', '1916-09-01', NULL, NULL, '0153771186', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('180', '180', 'Nguyễn Diên Quang', '1981-11-20', '2002-03-01', '1//CN', '80', '13', '1902-03-01', NULL, NULL, '0739874240', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('181', '181', 'Mai Thị Phượng', '1982-08-03', '2012-02-01', '2/CN', '81', '13', '1912-02-01', NULL, NULL, '0933496823', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('182', '182', 'Bùi Thị Hồng Thu', '1988-10-03', '2016-02-01', '2/CN', '81', '13', '1916-02-01', NULL, NULL, '0282904527', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('183', '183', 'Đặng Văn Tường', '1970-11-01', '1992-02-01', '1//CN', '82', '13', '1992-02-01', NULL, NULL, '0276585101', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('184', '184', 'Trần Hồng Tú', '1981-01-11', '1999-03-01', '4/CN', '83', '13', '1999-03-01', NULL, NULL, '0734091542', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('185', '185', 'Lê Trọng Quý', '1989-12-07', '2016-09-01', '1/CN', '84', '13', '1916-09-01', NULL, NULL, '0929728851', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('186', '186', 'Đỗ Trung Kiên', '1994-01-19', '2023-12-01', '1/CN', '85', '13', '1923-12-01', NULL, NULL, '0876384256', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('187', '187', 'Chu Lê Tuấn Anh', '1998-11-16', '2024-08-01', 'CNQP', '85', '13', '1924-08-01', NULL, NULL, '0322232065', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('188', '188', 'Hoàng Văn Thắng', '1995-10-02', '2014-02-01', '3/CN', '85', '13', '1914-02-01', NULL, NULL, '0985411557', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('189', '189', 'Nguyễn Thành Long', '1977-01-02', '1995-10-01', '2//', '154', '39', '1995-10-01', NULL, NULL, '0819071874', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('190', '190', 'Bùi Trường Giang', '1987-04-23', '2005-09-01', '2//', '65', '14', '1905-09-01', NULL, NULL, '0125824982', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('191', '191', 'Nguyễn Hải Sơn', '1990-08-10', '2008-09-01', '4/', '27', '14', '1908-09-01', NULL, NULL, '0179093413', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('192', '192', 'Nguyễn T Lan Anh', '1979-09-07', '2003-12-01', '1//CN', '54', '14', '1903-12-01', NULL, NULL, '0207124562', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('193', '193', 'Tống Cao Cường', '1986-11-20', '2004-10-01', '1//CN', '86', '14', '1904-10-01', NULL, NULL, '0796272523', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('194', '194', 'Nguyễn Hữu Tâm', '1983-07-22', '2003-12-01', '4/CN', '87', '14', '1903-12-01', NULL, NULL, '0892586130', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('195', '195', 'Hồ Thị Hiền', '1986-06-05', '2012-02-01', 'CNQP', '87', '14', '1912-02-01', NULL, NULL, '0248589887', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('196', '196', 'Nguyễn T Phương Thảo', '1993-06-22', '2022-12-01', 'CNQP', '87', '14', '1922-12-01', NULL, NULL, '0902772464', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('197', '197', 'Bùi Văn Huy', '1983-10-15', '2003-02-01', '1//CN', '88', '14', '1903-02-01', NULL, NULL, '0923392261', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('198', '198', 'Phan Văn Sáng', '1978-12-21', '2003-12-01', '4/CN', '89', '14', '1903-12-01', NULL, NULL, '0516263223', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('199', '199', 'Hữu Thị Thuý', '1981-05-17', '2003-12-01', '4/CN', '191', '39', '1903-12-01', NULL, NULL, '0953614147', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('200', '200', 'Hà Minh Nho', '1974-08-20', '1997-03-01', '1//CN', '90', '14', '1997-03-01', NULL, NULL, '0452224717', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('201', '201', 'Nguyễn Văn Đồng', '1983-09-20', '2002-03-01', '1//CN', '91', '14', '1902-03-01', NULL, NULL, '0867503215', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('202', '202', 'Trần T Kim Oanh', '1982-09-12', '2003-12-01', '4/CN', '91', '14', '1903-12-01', NULL, NULL, '0242705724', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('203', '203', 'Bùi Thị Huệ', '1991-10-22', '2016-02-01', '2/CN', '91', '14', '1916-02-01', NULL, NULL, '0369050303', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('204', '204', 'Bùi Đức Cảnh', '1991-12-24', '2009-09-01', '4/CN', '91', '14', '1909-09-01', NULL, NULL, '0981009897', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('205', '205', 'Trần Đức Minh', '1984-08-26', '2004-10-01', '1//CN', '92', '14', '1904-10-01', NULL, NULL, '0235416981', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('206', '206', 'Vũ Đình Tùng', '1986-05-21', '2005-10-01', '1//CN', '93', '14', '1905-10-01', NULL, NULL, '0938507541', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('207', '207', 'Trần Đình Tùng', '2005-12-30', '2023-12-01', '1/CN', '93', '14', '1923-12-01', NULL, NULL, '0865532942', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('208', '208', 'Đào Thị Thu Huyền', '1985-07-12', '2012-02-01', '2/CN', '93', '14', '1912-02-01', NULL, NULL, '0851188662', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('209', '209', 'Nguyễn Văn Quyết', '1988-08-27', '2012-02-01', '2/CN', '94', '14', '1912-02-01', NULL, NULL, '0479647317', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('210', '210', 'Nguyễn Thị Thu', '1991-09-01', '2024-08-01', 'CNQP', '95', '14', '1924-08-01', NULL, NULL, '0466377681', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('211', '211', 'Trần T Ngọc Anh', '1979-08-29', '2008-04-01', '3/CN', '95', '14', '1908-04-01', NULL, NULL, '0504894870', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('212', '212', 'Đỗ Văn Hưng', '1984-09-03', '2006-12-01', '2//', '52', '15', '1906-12-01', NULL, NULL, '0759356780', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('213', '213', 'Nguyễn Thị Tân Miền', '1980-01-06', '1998-02-01', '2//CN', '54', '15', '1998-02-01', NULL, NULL, '0749402911', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('214', '214', 'Nguyễn Ngọc Khánh', '1983-09-04', '2003-02-01', '1//CN', '96', '15', '1903-02-01', NULL, NULL, '0747111941', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('215', '215', 'Nguyễn Dự Đáng', '1986-09-24', '2008-03-01', '4/CN', '97', '15', '1908-03-01', NULL, NULL, '0528842552', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('216', '216', 'Lê Văn Hội', '1992-03-21', '2016-09-01', '2/CN', '97', '15', '1916-09-01', NULL, NULL, '0691119648', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('217', '217', 'Nguyễn Kim Biển', '1984-01-29', '2003-02-01', '1//CN', '98', '15', '1903-02-01', NULL, NULL, '0666789753', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('218', '218', 'Trần Mạnh Kiều', '1982-02-03', '2001-02-01', '1//CN', '99', '15', '1901-02-01', NULL, NULL, '0567599585', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('219', '219', 'Dương Bá Quyền', '1990-12-12', '2012-02-01', '1//CN', '100', '15', '1912-02-01', NULL, NULL, '0160652051', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('220', '220', 'Nguyễn Thị Tươi', '1988-07-21', '2013-03-01', '2/CN', '101', '15', '1913-03-01', NULL, NULL, '0598612478', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('221', '221', 'Bùi T Khánh Thuỳ', '1990-12-28', '2014-03-01', '2/CN', '101', '15', '1914-03-01', NULL, NULL, '0143011185', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('222', '222', 'Hà Chí Quang', '1973-07-20', '1993-02-01', '2//CN', '102', '15', '1993-02-01', NULL, NULL, '0593427613', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('223', '223', 'Võ Văn Tới', '1985-11-09', '2007-03-01', '4/CN', '103', '15', '1907-03-01', NULL, NULL, '0402324621', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('224', '224', 'Nguyễn Quang Hùng', '1998-08-16', '2024-08-01', 'CNQP', '103', '15', '1924-08-01', NULL, NULL, '0623492801', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('225', '225', 'Nguyễn Quyết Tiến', '1994-06-09', '2016-09-01', '2/CN', '103', '15', '1916-09-01', NULL, NULL, '0584309319', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('226', '226', 'Tạ Hồng Đăng', '1985-05-07', '2003-09-01', '2//', '52', '16', '1903-09-01', NULL, NULL, '0169899494', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('227', '227', 'Nguyễn Thị Hoàn', '1983-04-26', '2012-02-01', '4/CN', '54', '16', '1912-02-01', NULL, NULL, '0382964200', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('228', '228', 'Nguyễn Sơn Đông', '1980-10-13', '2000-02-01', '1//CN', '104', '16', '1900-02-01', NULL, NULL, '0594966333', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('229', '229', 'Nguyễn Hải Tiến', '1984-05-10', '2004-02-01', '1//CN', '105', '16', '1904-02-01', NULL, NULL, '0848739881', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('230', '230', 'Trần Việt Trung', '1990-12-28', '2022-12-01', '3/CN', '105', '16', '1922-12-01', NULL, NULL, '0796903337', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('231', '231', 'Trần Thị Việt Hồng', '1982-08-08', '2003-12-01', '1//CN', '106', '16', '1903-12-01', NULL, NULL, '0708846280', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('232', '232', 'Vũ Ngọc Quỳnh', '1983-10-07', '2002-10-01', '1//CN', '70', '16', '1902-10-01', NULL, NULL, '0942796252', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('233', '233', 'Thái Thị Âu', '1987-05-29', '2012-02-01', '2/CN', '70', '16', '1912-02-01', NULL, NULL, '0432349672', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('234', '234', 'Nguyễn Thuỳ Linh', '1984-10-20', '2012-02-01', '1//CN', '70', '16', '1912-02-01', NULL, NULL, '0809279913', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('235', '235', 'Nguyễn Thị Mai', '1994-07-18', '2022-12-01', 'CNQP', '70', '16', '1922-12-01', NULL, NULL, '0830779297', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('236', '236', 'Hoàng Văn Thành', '1983-06-08', '2001-09-01', '2//', '52', '17', '1901-09-01', NULL, NULL, '0230072104', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('237', '237', 'Vũ Thị Liên', '1982-12-15', '2005-04-01', '1//CN', '54', '17', '1905-04-01', NULL, NULL, '0302047146', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('238', '238', 'Khuất Duy Mạnh', '1982-08-30', '2003-02-01', '1//CN', '107', '17', '1903-02-01', NULL, NULL, '0169893401', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('239', '239', 'Nguyễn Thị Duyên', '1992-02-16', '2023-12-01', '2/CN', '108', '17', '1923-12-01', NULL, NULL, '0276938285', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('240', '240', 'Nông Thị Thuý', '1987-02-12', '2013-03-01', '2/CN', '210', '42', '1913-03-01', NULL, NULL, '0289326535', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('241', '241', 'Đinh Thị Thành', '1988-01-15', '2015-03-01', '2/CN', '108', '17', '1915-03-01', NULL, NULL, '0929373274', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('242', '242', 'Lương T Thanh Loan', '1986-11-13', '2024-08-01', 'CNQP', '108', '17', '1924-08-01', NULL, NULL, '0122932472', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('243', '243', 'Phan Thanh Trường', '1975-08-18', '1997-01-01', '1//CN', '109', '17', '1997-01-01', NULL, NULL, '0768382946', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('244', '244', 'Mai Hồng Sơn', '1971-01-02', '1992-02-01', '1//CN', '110', '17', '1992-02-01', NULL, NULL, '0194362109', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('245', '245', 'Nguyễn Thái Bình', '1981-03-11', '2000-02-01', '4/CN', '213', '42', '1900-02-01', NULL, NULL, '0282706762', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('246', '246', 'Nguyễn Thanh Bình', '1972-07-20', '1995-02-01', 'CNQP', '213', '42', '1995-02-01', NULL, NULL, '0225902222', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:55:33', NULL);
INSERT INTO `employees` VALUES ('247', '247', 'Trần Ngọc Quang', '1983-09-09', '2002-03-01', '4/CN', '111', '17', '1902-03-01', NULL, NULL, '0274892898', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('248', '248', 'Phạm Trường Giang', '1976-03-08', '1994-10-01', '3//', '52', '18', '1994-10-01', NULL, NULL, '0429922694', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('249', '249', 'Nguyễn Thị Thảo', '1975-10-17', '1993-02-01', '2//CN', '54', '18', '1993-02-01', NULL, NULL, '0891117108', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('250', '250', 'Bùi Văn Khởi', '1965-08-13', '1999-03-01', 'CNQP', '112', '18', '1999-03-01', NULL, NULL, '0231326199', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 10:18:38', NULL);
INSERT INTO `employees` VALUES ('251', '251', 'Cao Văn Tuyển', '1985-04-24', '2003-10-01', '1//CN', '112', '18', '1903-10-01', NULL, NULL, '0136937153', '1', NULL, '0', '12', '12', '0', '00:00:00', '00:00:00', '1', '', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 10:18:38', NULL);

-- Structure for table `failed_jobs`
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `log` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `check_in` time DEFAULT NULL,
  `check_out` time DEFAULT NULL,
  `is_checked` tinyint(1) NOT NULL DEFAULT '0',
  `excuse` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `note` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `imports`
DROP TABLE IF EXISTS `imports`;
CREATE TABLE `imports` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_ext` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `details` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `total` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `jobs`
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_instantly` tinyint(1) NOT NULL,
  `is_accumulative` tinyint(1) NOT NULL,
  `discount_rate` int NOT NULL,
  `days_limit` int NOT NULL,
  `minutes_limit` int NOT NULL,
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_sent` tinyint(1) NOT NULL DEFAULT '0',
  `error` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `model_has_roles`
DROP TABLE IF EXISTS `model_has_roles`;
CREATE TABLE `model_has_roles` (
  `role_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `model_has_roles`
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '1');
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '2');
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '3');
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '4');
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '5');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '6');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '7');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '8');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '9');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '10');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '11');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '12');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '13');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '14');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '15');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '16');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '17');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '18');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '19');
INSERT INTO `model_has_roles` VALUES ('17', 'App\\Models\\User', '19');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '20');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '21');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '22');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '23');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '24');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '25');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '26');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '27');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '28');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '29');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '30');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '31');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '32');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '33');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '34');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '35');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '36');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '37');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '38');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '39');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '40');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '41');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '42');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '43');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '44');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '45');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '46');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '47');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '48');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '49');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '50');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '51');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '52');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '53');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '54');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '55');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '56');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '57');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '58');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '59');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '60');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '61');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '62');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '63');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '64');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '65');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '66');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '67');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '68');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '69');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '70');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '71');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '72');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '73');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '74');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '75');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '76');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '77');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '78');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '79');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '80');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '81');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '82');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '83');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '84');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '85');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '86');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '87');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '88');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '89');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '90');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '91');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '92');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '93');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '94');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '95');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '96');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '97');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '98');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '99');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '100');
INSERT INTO `model_has_roles` VALUES ('14', 'App\\Models\\User', '101');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '102');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '103');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '104');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '105');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '106');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '107');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '108');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '109');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '110');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '111');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '112');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '113');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '114');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '115');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '116');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '117');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '118');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '119');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '120');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '121');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '122');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '123');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '124');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '125');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '126');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '127');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '128');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '129');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '130');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '131');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '132');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '133');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '134');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '135');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '136');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '137');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '138');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '139');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '140');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '141');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '142');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '143');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '144');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '145');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '146');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '147');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '148');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '149');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '150');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '151');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '152');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '153');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '154');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '155');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '156');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '157');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '158');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '159');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '160');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '161');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '162');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '163');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '164');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '165');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '166');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '167');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '168');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '169');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '170');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '171');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '172');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '173');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '174');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '175');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '176');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '177');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '178');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '179');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '180');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '181');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '182');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '183');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '184');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '185');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '186');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '187');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '188');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '189');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '190');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '191');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '192');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '193');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '194');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '195');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '196');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '197');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '198');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '199');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '200');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '201');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '202');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '203');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '204');
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
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '216');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '217');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '218');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '219');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '220');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '221');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '222');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '223');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '224');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '225');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '226');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '227');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '228');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '229');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '230');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '231');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '232');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '233');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '234');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '235');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '236');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '237');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '238');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '239');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '240');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '241');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '242');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '243');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '244');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '245');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '246');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '247');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '248');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '249');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '250');
INSERT INTO `model_has_roles` VALUES ('15', 'App\\Models\\User', '251');
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '252');
INSERT INTO `model_has_roles` VALUES ('13', 'App\\Models\\User', '450');

-- Structure for table `notifications`
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` bigint unsigned NOT NULL,
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `password_reset_tokens`
DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `password_resets`
DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE `password_resets` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `permissions`
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure for table `personal_access_tokens`
DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vacancies_count` int NOT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `positions`
INSERT INTO `positions` VALUES ('1', 'Giám đốc', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('2', 'Chính uỷ', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('3', 'P.Giám đốc', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('4', 'Chờ hưu từ 01/11/24', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('5', 'Trưởng phòng', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('6', 'P. Trưởng phòng', '1', 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-03 04:47:33', NULL);
INSERT INTO `positions` VALUES ('7', 'TL Quân sự', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('8', 'TL Quân lực', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('9', 'TL Kế hoạch', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('10', 'NV Văn thư, bảo mật', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('11', 'NV Thông tin', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('12', 'NV lao động tiền lương', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('13', 'NV điều độ SX', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('14', 'NV Quân lực', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('15', 'NV Thống kê', '1', 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-03 04:47:34', NULL);
INSERT INTO `positions` VALUES ('16', 'TT Tổ bảo vệ-PCCC', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('17', 'NV bảo vệ', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('18', 'Đội trưởng đội xe', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('19', 'Lái xe', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('20', 'Trưởng Ban', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('21', 'Phó Trưởng Ban', '1', 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-03 04:47:35', NULL);
INSERT INTO `positions` VALUES ('22', 'Trợ lý Chính trị', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('23', 'NV Chính trị', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('24', 'P Trưởng phòng', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('25', 'Trạm trưởng Spyder', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('26', 'P.Trạm trưởng Spyder', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('27', 'Trợ lý KT', '1', 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-03 04:47:36', NULL);
INSERT INTO `positions` VALUES ('28', 'NV thư viện KT', '1', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `positions` VALUES ('29', 'NV kỹ thuật', '1', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `positions` VALUES ('30', 'NV Cơ điện', '1', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `positions` VALUES ('31', 'Tổ trưởng', '1', 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-03 04:47:37', NULL);
INSERT INTO `positions` VALUES ('32', 'Thợ cơ điện', '1', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `positions` VALUES ('33', 'TL Kỹ thuật', '1', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `positions` VALUES ('34', 'NV Tiếp liệu', '1', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `positions` VALUES ('35', 'Thủ kho VTKT', '1', 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-03 04:47:38', NULL);
INSERT INTO `positions` VALUES ('36', 'NV KCS Bệ phóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('37', 'NV KCS Đài Điều khiển', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('38', 'NV KCS kíp đạn', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('39', 'NV KCS Xe máy-TNĐ', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('40', 'NV KCS', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('41', 'NV KCS Cơ khí', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('42', 'NV kế toán', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('43', 'NV thủ quỹ', '1', 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-03 04:47:39', NULL);
INSERT INTO `positions` VALUES ('44', 'Phó Trưởng phòng', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('45', 'NV Doanh trại', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('46', 'NV Quản lý', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('47', 'NV nấu ăn, tiếp phẩm', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('48', 'NV Nhà khách', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('49', 'NV nấu ăn', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('50', 'Y sỹ', '1', 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-03 04:47:40', NULL);
INSERT INTO `positions` VALUES ('51', 'Y tá, nấu ăn', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('52', 'Quản đốc', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('53', 'Phó Quản đốc', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('54', 'NV điều độ', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('55', 'TT Tổ lắp ráp, SC khối', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('56', 'Thợ lắp ráp, SC khối', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('57', 'Thợ lắp ráp,  SC khối', '1', 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-03 04:47:41', NULL);
INSERT INTO `positions` VALUES ('58', 'TT Tổ SC Đài ĐK S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('59', 'Thợ SC Đài ĐK S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('60', 'TT Tổ Đài điều khiển S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('61', 'Thợ Đài điều khiển S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('62', 'TT Tổ SC xe AKKOR', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('63', 'TT Tổ SC cơ khí an ten', '1', 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-03 04:47:42', NULL);
INSERT INTO `positions` VALUES ('64', 'Thợ SC cơ khí an ten', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('65', 'Phó QĐ', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('66', 'TT Tổ Thợ SC điện bệ phóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('67', 'Thợ SC điện bệ phóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('68', 'TT Tổ SC cơ khí bệ phóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('69', 'Thợ SC cơ khí bệ phóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('70', 'Thợ SC vôn kế, đồng hồ', '1', 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-03 04:47:43', NULL);
INSERT INTO `positions` VALUES ('71', 'TT Tổ SC xe khí nén', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('72', 'TT Tổ SC xe nạp chất \"O, G\"', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('73', 'Thợ xe nạp chất \"O, G\"', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('74', 'TT Tổ SC dây chuyền dKT', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('75', 'TT Tổ cơ khí nguội', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('76', 'TT Tổ cơ khí cắt gọt', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('77', 'Thợ cơ khí cắt gọt', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('78', 'TT Tổ SC gia công cơ khí', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('79', 'Thợ gia công cơ khí', '1', 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-03 04:47:44', NULL);
INSERT INTO `positions` VALUES ('80', 'TT Tổ ép nhựa, mạ', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('81', 'Thợ ép nhựa, mạ', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('82', 'Thợ mộc', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('83', 'TT Tổ mộc', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('84', 'TT Tổ SC gầm vỏ', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('85', 'Thợ gầm vỏ', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('86', 'TT Tổ SC Đạn TL S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('87', 'Thợ SC Đạn TL S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-03 04:47:45', NULL);
INSERT INTO `positions` VALUES ('88', 'TT Tổ SC Đạn TL S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('89', 'Thợ SC Đạn TL S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('90', 'TT Tổ SC kíp S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('91', 'Thợ SC kíp S-75M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('92', 'TT Tổ SC kíp S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('93', 'Thợ SC kíp S-125M', '1', 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-03 04:47:46', NULL);
INSERT INTO `positions` VALUES ('94', 'TT Tổ sơn, bao gói', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('95', 'Thợ sơn bao gói', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('96', 'TT Tổ SC trạm nguồn', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('97', 'Thợ SC trạm ngồn', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('98', 'TT tổ SC động cơ', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('99', 'Thợ SC động cơ', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('100', 'TT Tổ SC điện xe máy', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('101', 'Thợ SC điện xe máy', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('102', 'TT Tổ SC ô tô', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('103', 'Thợ SC ô tô', '1', 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-03 04:47:47', NULL);
INSERT INTO `positions` VALUES ('104', 'TT Tổ vô tuyến hiện sóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `positions` VALUES ('105', 'Thợ vô tuyến hiện sóng', '1', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `positions` VALUES ('106', 'TT Tổ SC vôn kế, đồng hồ', '1', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `positions` VALUES ('107', 'TT Tổ SC động cơ EMU, MI', '1', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `positions` VALUES ('108', 'Thợ SC động cơ EMU, MI', '1', 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-03 04:47:48', NULL);
INSERT INTO `positions` VALUES ('109', 'TT Tổ SC Biến thế, tẩm sấy', '1', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `positions` VALUES ('110', 'TT Tổ Sơn tổng hợp', '1', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `positions` VALUES ('111', 'Thợ sơn tổng hợp', '1', 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-03 04:47:49', NULL);
INSERT INTO `positions` VALUES ('112', 'Thợ hóa nghiệm
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `sms_api_sender` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sms_api_username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sms_api_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_sequent` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `center_document_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cccd` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Số căn cước công dân',
  `date_of_birth` date DEFAULT NULL COMMENT 'Ngày sinh',
  `enlist_date` date DEFAULT NULL COMMENT 'Ngày nhập ngũ',
  `mobile_verified_at` timestamp NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `two_factor_secret` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `two_factor_recovery_codes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_photo_path` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signature_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_mobile_unique` (`mobile`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_employee_id_foreign` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `users`
INSERT INTO `users` VALUES ('1', 'Phạm Đức Giang', 'pdgiang', NULL, NULL, '1973-09-05', '1991-09-01', NULL, 'pdgiang', '2025-09-03 04:47:33', '$2y$10$7cddMrph/1QVObpcIE9kB.3SQ1JYexIF8ktBTA8nKkT1WhOpFl4QS', NULL, NULL, '0EdsCizUgcWGXohhGmAHB9aIsC0c2N2D4VggqhukxRviy1lUWJOolNPDcxvw', NULL, 'signatures/signature_197_1757003266.png', 'System', 'Phạm Đức Giang', NULL, '2025-09-03 04:47:33', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('2', 'Hà Tiến Thụy', 'htthuy75', NULL, NULL, '1975-01-01', NULL, NULL, 'htthuy', '2025-09-03 04:47:33', '$2y$10$qgS83/m7QQIwz2W5h/muNOUQ35KbaCy7ZGYD2HrqOWFa7xpZ8kH0u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 01:48:06', NULL);
INSERT INTO `users` VALUES ('3', 'Cao Anh Hùng', 'cahung', NULL, NULL, '1974-08-06', '1991-09-01', NULL, 'cahung', '2025-09-03 04:47:33', '$2y$10$mMT.XMXg.zFGasI25L89Pe6B8YK44BVSIBkWELW1R0ocI/U4.T.oy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('4', 'Bùi Tân Chinh', 'btchinh', NULL, NULL, '1979-12-04', '2003-09-01', NULL, 'btchinh', '2025-09-03 04:47:33', '$2y$10$lGsbspWuRJeVyuHkj/vCquxduZ7K1xPLiiY7cskivxAfxjOxIyEWS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('5', 'Nguyễn Văn  Bảy', 'nvbay', NULL, NULL, '1972-09-20', '1991-03-01', NULL, 'nvbay', '2025-09-03 04:47:33', '$2y$10$6/tx/MPrN3q5cZ4EYiMIPOsVn6vdZsn29q6CHQf0c7h9nq1hD0DBm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('6', 'Phạm Ngọc Sơn', 'pnson', NULL, NULL, '1967-10-22', '1985-08-01', NULL, 'pnson', '2025-09-03 04:47:33', '$2y$10$Ir1YCThDr1NWZaAqjM2kpOLVDJeMzPyrGAZbJdGG0zTZ7b85fP5T.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:33', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('7', 'Nguyễn Đình Sự', 'ndsu', NULL, NULL, '1986-09-16', '2005-09-01', NULL, 'ndsu', '2025-09-03 04:47:33', '$2y$10$yiYg3Xz04Tum0PyDVS1ye.WJbUBvIOoTduR.zOao5VShscGR6.pjG', NULL, NULL, 'I3HR2soZ1MZ2ju1ul4sJ4HRFSbWmFziZ4zg1Y7ajQvurXuUt0UgoOy30yv89', 'profile-photos/avatar_203_1757001949.png', 'signatures/signature_203_1756973855.png', 'System', 'Nguyễn Đình Sự', NULL, '2025-09-03 04:47:33', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('8', 'Phạm Tiến Long', 'ptlong', NULL, NULL, '1977-05-30', '1996-09-01', NULL, 'ptlong', '2025-09-03 04:47:34', '$2y$10$vYCzXs2j/Ysx6Omti4uEZufJ1S.k6nGTc0L74tQP9MnHYjQmh0Y5u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('9', 'Đặng Đình Quỳnh', 'ddquynh', NULL, NULL, '1983-09-18', '2004-09-01', NULL, 'ddquynh', '2025-09-03 04:47:34', '$2y$10$3vxEhjdD06nDG7MLt35u.OJVN9bkpWDcOMJm4prjwEu3tYcivvjVi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('10', 'Lục Viết Hợp', 'lvhop', NULL, NULL, '1983-01-01', NULL, NULL, 'lvhop', '2025-09-03 04:47:34', '$2y$10$erfIZ2YHp/Wm67vxLLPLAOuqPN5Ef1Kxw0J3nI0PFxSZuPNObgEte', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('11', 'Trần Đình Tài', 'tdtai', NULL, NULL, '1968-11-20', '1986-02-01', NULL, 'tdtai', '2025-09-03 04:47:34', '$2y$10$tg3RM13YSn6xDKmxOaAfkenUt77z0KYayPp1BEiuli9KrIfdVIeSi', NULL, NULL, 'JKWqxj5czVq1NlqWvtWJvKRMVD1MiWdZBUzZezik6x78Lbkn4f409MuC2mD0', NULL, NULL, 'System', 'Trần Đình Tài', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('12', 'Trịnh Thị Thuý Hà', 'tttha', NULL, NULL, '1982-09-03', '2005-07-01', NULL, 'tttha', '2025-09-03 04:47:34', '$2y$10$1.PiFXIVJxEJo27mlMGMYehPRGJ.tAsW9s.D1Q6XcYTYc.yEcINOy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('13', 'Trịnh Văn Cương', 'tvcuong', NULL, NULL, '1993-08-23', '2011-08-01', NULL, 'tvcuong', '2025-09-03 04:47:34', '$2y$10$QNhAv94GQOo7OGPP3ezFOemOSqS7xASeNdwJ0TlTRXf.jVvDRbai6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('14', 'Nguyễn T Thu Hà', 'nttha', NULL, NULL, '1995-08-29', '2024-07-01', NULL, 'nttha', '2025-09-03 04:47:34', '$2y$10$ZUOl/f3U5ZAIhax6nbaCuOZicy10m/2z4LdH2hYJmDzpnJN7ErbIO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('15', 'Vũ Thành Trung', 'vttrung', NULL, NULL, '1980-02-24', '1998-02-01', NULL, 'vttrung', '2025-09-03 04:47:34', '$2y$10$y.NZHDwMcFcjbA0npcoDqOphgBlbg9iuSjQJqvemkBSKFCLV1Y.Eq', NULL, NULL, 'zYUii9CZYLQkLYrWC3UzuQGBiqqK9V7x5echyXLixPD6VoYlD2CHA5pmgaYn', NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('16', 'Phạm Thị Thuý', 'ptthuy', NULL, NULL, '1976-10-15', '2003-12-01', NULL, 'ptthuy', '2025-09-03 04:47:34', '$2y$10$wPNKHLkhlA7mAUP.iANFBefGe1VI7BWtpjNtfvuJdfroAs52C7/Au', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('17', 'Phạm Thị Trà', 'pttra', NULL, NULL, '1975-06-02', '1999-03-01', NULL, 'pttra', '2025-09-03 04:47:34', '$2y$10$kxbrP/VVey9lu1296AYSRuToRG6H1I9AF7SZWV8TLwVADgaA2Dg0O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('18', 'Vũ Thanh Hà', 'vtha', NULL, NULL, '1987-08-12', '2006-02-01', NULL, 'vtha', '2025-09-03 04:47:34', '$2y$10$tgmg29ZXo7H0s.6hKOg9duUymaDFQHrDECCfjoB9.xC/iOYdYwW0G', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('19', 'Nguyễn Địch Linh', 'ndlinh', NULL, NULL, '1990-07-18', '2008-09-01', NULL, 'ndlinh', '2025-09-03 04:47:34', '$2y$10$AGcg9U.xakuK0BDncay1KOIwsRKdlMOczHCVYBvI.C4u7mEhe2mfS', NULL, NULL, 'y2LgwVkPzJ9HvADDZo5IWcuaIhFJVbw29s82uTY2J6JURqCV2j7u18JFRpu8', NULL, NULL, 'System', 'Nguyễn Địch Linh', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('20', 'Tạ Quốc Bảo', 'tqbao', NULL, NULL, '1997-09-06', '2017-02-01', NULL, 'tqbao', '2025-09-03 04:47:34', '$2y$10$L65kGU6fMcIH171kgUtDHuUnVQEGt5t55uhoh7LVmBtKrIScz8esS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('21', 'Trần Ngọc Liễu', 'tnlieu', NULL, NULL, '1985-05-14', '2011-10-01', NULL, 'tnlieu', '2025-09-03 04:47:34', '$2y$10$bL9wxBo.4e7PHmyjpwKl3elLUKCkzRdcKYp9UcEPW5KC8noMgVuFO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:34', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('22', 'Nguyễn T Thu Thanh', 'nttthanh', NULL, NULL, '1974-04-28', '1992-02-01', NULL, 'nttthanh', '2025-09-03 04:47:35', '$2y$10$V0HS/gAWo3TN6LG2Wprige//hvNFtMbgQf5Kfm1i6jGJ97Ncw0DqS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('23', 'Trần Hữu Ngọc', 'thngoc', NULL, NULL, '1985-12-16', '2005-02-01', NULL, 'thngoc', '2025-09-03 04:47:35', '$2y$10$79g6aVoJ49hFozG8tWwmeOBxI2ES2gCmy3M98zwb64WrVAedql.Wm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('24', 'Nguyễn Minh Thanh', 'nmthanh', NULL, NULL, '1973-07-10', '1992-02-01', NULL, 'nmthanh', '2025-09-03 04:47:35', '$2y$10$jyLH4Z9fPsphuae/r0CEC.HU2cnfqT0FeJzmZz3ZrMt5Y72g1RAQi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('25', 'Nông Tiến Tân', 'nttan', NULL, NULL, '1993-09-22', '2011-09-01', NULL, 'nttan', '2025-09-03 04:47:35', '$2y$10$J8Uxch12KxUKrhQ8hU9T7eqv6BpZ0m02JA0EI9r34dXQaCpGkBWLa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('26', 'Nguyễn Trọng Toàn', 'nttoan', NULL, NULL, '1975-10-01', '1994-02-01', NULL, 'nttoan', '2025-09-03 04:47:35', '$2y$10$QJq2gLDAV73IDNw//LPEPu3mmE55EiIqBcwvCauqy3s50NBV30KCK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('27', 'Phạm Văn Bảy', 'pvbay', NULL, NULL, '1974-05-05', '1993-03-01', NULL, 'pvbay', '2025-09-03 04:47:35', '$2y$10$66timw94PkmnQDQtDGlOTeZZaT2WhpNKEqlv5jLzO9Ai/ff9g/bzu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('28', 'Phạm Văn Tặng', 'pvtang', NULL, NULL, '1978-03-27', '1999-03-01', NULL, 'pvtang', '2025-09-03 04:47:35', '$2y$10$uZnawl7eR9oLkRUveyJBVuU0jC2OvYMJHb3.Fh2NEp4ELreJzzakq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('29', 'Bùi Thanh Quân', 'btquan', NULL, NULL, '1979-01-15', '1999-03-01', NULL, 'btquan', '2025-09-03 04:47:35', '$2y$10$ptDGjoi0eNxahiNEqR4bwuK5.Kja2.q7qruZT0Gb6hYb58ZcN4IPi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('30', 'Vũ Hữu Hải', 'vhhai', NULL, NULL, '1980-09-30', '2001-02-01', NULL, 'vhhai', '2025-09-03 04:47:35', '$2y$10$El6t6OE31qESQvYEUq9neu3QLKzm7ERZd5V6pXudGsoCnSkFWZBwG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('31', 'Lê Ngọc Duy', 'lnduy', NULL, NULL, '1990-01-31', '2009-02-01', NULL, 'lnduy', '2025-09-03 04:47:35', '$2y$10$4HJXyNrjewf0ybKD1p7P.eXuW0WykdDi/rlk262uTMQyGI2zqsft.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('32', 'Nguyễn Văn Thắng', 'nvthang87', NULL, NULL, '1973-08-01', '1991-09-01', NULL, 'nvthang', '2025-09-03 04:47:35', '$2y$10$96LgbPMXZZDKmtj7HTLhb.Xr2y4PrsGgUcxBMjScxXf6FEuV6dApa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('33', 'Nguyễn Tiến Cường', 'ntcuong', NULL, NULL, '1986-07-04', '2013-03-01', NULL, 'ntcuong', '2025-09-03 04:47:35', '$2y$10$jznvLcu/JGEg/LwUVA60RuHsUmL3vBTIzUykHE/Vd37nRGYyFCFAO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('34', 'Hoàng Văn Tình', 'hvtinh', NULL, NULL, '1979-08-01', '1999-03-01', NULL, 'hvtinh', '2025-09-03 04:47:35', '$2y$10$zU0LFMSk.5Pqqf6EEY8pou5LqLv//h7tbgB4KRgWOi/mNF2sDByda', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('35', 'Hoàng Anh Đức', 'haduc', NULL, NULL, '2004-10-31', '2023-02-01', NULL, 'haduc', '2025-09-03 04:47:35', '$2y$10$I2JYJZvU9QSDsZSUI8RAQOmedVxD/h7tnD47dEL1WrRlyH1oO7OAO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('36', 'Hoàng Bảo Chung', 'hbchung', NULL, NULL, '1995-11-23', '2014-09-01', NULL, 'hbchung', '2025-09-03 04:47:35', '$2y$10$QS1RvbdiEoEm/2wp5Xupv.5x8/zA845Sw/VNN/eJ6zRd44yTMI1fu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('37', 'Phạm Thị Thu Hương', 'ptthuong74', NULL, NULL, '1974-09-22', '1992-03-01', NULL, 'ptthuong', '2025-09-03 04:47:35', '$2y$10$W6.ixzQW7WpwUHklHQd8Gue2hg0a5ayV0R2cqLJkQVZ3KC3pWutrq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:35', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('38', 'Phan Minh Nghĩa', 'pmnghia', NULL, NULL, '1984-07-20', '2004-02-01', NULL, 'pmnghia', '2025-09-03 04:47:36', '$2y$10$FpUNUeSOBdPmaandM3yeJujdOluN4CPiX95V.zzAep.2U7ep5HR2q', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('39', 'Nguyễn Trung Kiên', 'ntkien2', NULL, NULL, '1978-01-01', '1996-11-01', NULL, 'ntkien', '2025-09-03 04:47:36', '$2y$10$mJS0bJ1/UN8q6VKcSoxboeMwGGlcOZx118ZlZnene3.RHH8sb.dtm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('40', 'Nguyễn Văn Thắng', 'nvthang872', NULL, NULL, NULL, NULL, NULL, 'nvthang_1', '2025-09-03 04:47:36', '$2y$10$zs5WKG8cCYLFwMxILmpove3B11FgmDL6LnvmqZ0pjwb5m1JKS2F7W', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:48:35', NULL);
INSERT INTO `users` VALUES ('41', 'Đặng Trọng Chánh', 'dtchanh', NULL, NULL, '1994-01-01', NULL, NULL, 'dtchanh', '2025-09-03 04:47:36', '$2y$10$eW3kca2GwVWlQVmU43rrtupRA0AoJ6Y5A8nrpMccT8ZOCNG/hQXw2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('42', 'Nguyễn Minh Hiếu', 'nmhieu', NULL, NULL, '1999-10-17', '2017-09-01', NULL, 'nmhieu', '2025-09-03 04:47:36', '$2y$10$.hHMQuQPhX/gYe7gE/RBlesXM4hTba9J3oHPy/qX7ZHXcGeUkgdnu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('43', 'Bùi Thị Nhật Lệ', 'btnle', NULL, NULL, '1997-03-29', '2016-02-01', NULL, 'btnle', '2025-09-03 04:47:36', '$2y$10$SHjk2lPM1pI1cTo3waMVL.6hu2D8kL0HhUprw8hiYJcIedCEf6wuS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('44', 'Nguyễn Văn Ngà', 'nvnga', NULL, NULL, '1983-09-05', '2002-09-01', NULL, 'nvnga', '2025-09-03 04:47:36', '$2y$10$H/ELKV5hiIytGKBCPAC60.oEN/3f.TUnV5/lUCHoxbtpcfFOErztC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('45', 'Nguyễn Trung Kiên', 'ntkien22', NULL, NULL, NULL, NULL, NULL, 'ntkien_1', '2025-09-03 04:47:36', '$2y$10$wPDWuydWzjj9mn2LOWXju.F3t4XWiG6UA1wQtG8FsPmglCPFjtkb6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:48:35', NULL);
INSERT INTO `users` VALUES ('46', 'Phạm Duy Thái', 'pdthai', NULL, NULL, '1993-11-17', '2011-08-01', NULL, 'pdthai', '2025-09-03 04:47:36', '$2y$10$CC/.kdRzRFwYhtuubXbQbOtD00ONZyeDRwYwHMUDOtP7pu5RoD1Jq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('47', 'Lê Quý Vũ', 'lqvu', NULL, NULL, '1983-06-24', '2001-09-01', NULL, 'lqvu', '2025-09-03 04:47:36', '$2y$10$GY287ibkRj1.pkYkqlPADOayODRL5Gy.Vic0RMZ2B7F2gGNk/z6Zi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('48', 'Nguyên Hữu Ngọc', 'nhngoc', NULL, NULL, '1991-11-09', '2009-09-01', NULL, 'nhngoc', '2025-09-03 04:47:36', '$2y$10$WgKsdQAJCmhAz8ah4qGzbO3D.PY2uoB4plBxytSZ8omePgpbtXB9O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('49', 'Lại Hoàng Hà', 'lhha', NULL, NULL, '1988-09-12', '2006-09-01', NULL, 'lhha', '2025-09-03 04:47:36', '$2y$10$nZw3R2nC3d5uBcMzHSxQPeSfDr6NhTcmQZnqcfcw7tXNgryfAd9nW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('50', 'Dương Thế Vinh', 'dtvinh', NULL, NULL, '1993-07-22', '2011-08-01', NULL, 'dtvinh', '2025-09-03 04:47:36', '$2y$10$WnY6sTlbkrOAsboQqrziouGFIZHLSlMmzE6fJHrSCrpKOBfFu/MQC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('51', 'Đỗ Văn Quân', 'dvquan', NULL, NULL, '1992-01-01', NULL, NULL, 'dvquan', '2025-09-03 04:47:36', '$2y$10$r2HYIV86pUgaujluSwGZzeNXxCi4ONHcwV5aJByzcTHTQ2JtB6QsS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('52', 'Nguyễn Văn Bình', 'nvbinh', NULL, NULL, '1992-10-30', '2011-09-01', NULL, 'nvbinh', '2025-09-03 04:47:36', '$2y$10$GaIQojhKxgUvAPsw48u4iOeYqV8yy5L8XEruhW0HylExhsVJAPgyG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('53', 'Bùi Công Đoài', 'bcdoai', NULL, NULL, '1988-09-25', '2006-09-01', NULL, 'bcdoai', '2025-09-03 04:47:36', '$2y$10$YkSugmtipy9ubO1pq2XoCuYtnZsGEgB7K.wvlRmboI1xhCLeZSF/m', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:36', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('54', 'Đặng Hùng', 'dhung', NULL, NULL, '1983-06-23', '2003-09-01', NULL, 'dhung', '2025-09-03 04:47:37', '$2y$10$J0WZ4md5nPjDASvrhSM7IeK74XGayXjWxz33UnMrtKue6uCxOH4oy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('55', 'Ngô Văn Hiển', 'nvhien', NULL, NULL, '1986-12-10', '2004-09-01', NULL, 'nvhien', '2025-09-03 04:47:37', '$2y$10$wWiNoSvSQhYswPiIl4vagedf4y1HSCzhx7LcCegXy0dcbBOnWmeuG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('56', 'Đỗ Văn Linh', 'dvlinh', NULL, NULL, '1994-03-25', '2012-09-01', NULL, 'dvlinh', '2025-09-03 04:47:37', '$2y$10$xpm3pjXHPWMpXgsPaK4bt.7gTHhV9GLBFRzNwFu76NKY8AY7a6S0a', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('57', 'Hoàng Công Thành', 'hcthanh', NULL, NULL, '1992-12-04', '2009-09-01', NULL, 'hcthanh', '2025-09-03 04:47:37', '$2y$10$2aYYQydSVC6AU4YRMvRuLOVaR1BIzvLFK1nasj7T0D4KiUpeyX3.O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('58', 'Văn Sỹ Lực', 'vsluc', NULL, NULL, '1997-05-07', '2015-09-01', NULL, 'vsluc', '2025-09-03 04:47:37', '$2y$10$av8VYJUuQnyL0UREIYv6Pegg0zBZpGuCnT/QofSb8x8vbQzhamOoC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('59', 'Nguyễn Trần Đức', 'ntduc', NULL, NULL, '1995-04-27', '2013-09-01', NULL, 'ntduc', '2025-09-03 04:47:37', '$2y$10$N.2DjkNaKmHfeEUZPEBugepE3wKGTCHBr.StP4C6u61RBBQ0FF0dy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('60', 'Lê Minh Vượng', 'lmvuong', NULL, NULL, '1999-01-14', '2017-09-01', NULL, 'lmvuong', '2025-09-03 04:47:37', '$2y$10$mEvKp9Y8WJ2jjG2o5m9CRuWbLZN991UnZBH.jIEOB77WugwTD.7ye', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('61', 'Tạ Văn Hoàng', 'tvhoang', NULL, NULL, '1993-01-01', NULL, NULL, 'tvhoang', '2025-09-03 04:47:37', '$2y$10$vLjH5.zsHyBBJNqDCUb5LOzuiOJ8H.7RGt1CXnvttRiDiF9HRFyTq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('62', 'Phạm Thị Phương', 'ptphuong', NULL, NULL, '1980-10-30', '1998-11-01', NULL, 'ptphuong', '2025-09-03 04:47:37', '$2y$10$EuytjGubOjp1mAKYavasuOBz0FI.qy/tgIZy7Wzribw8GWpnhvOta', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('63', 'Lê Thị Vân', 'ltvan', NULL, NULL, '1975-06-02', '2001-02-01', NULL, 'ltvan', '2025-09-03 04:47:37', '$2y$10$BXSmgvwh3zOWJdGXp2N.5uD7jy9JmbRbSxl4T/LpPXROXFV/Q9wdm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('64', 'Trần Xuân Trường', 'txtruong', NULL, NULL, '1987-06-21', '2015-03-01', NULL, 'txtruong', '2025-09-03 04:47:37', '$2y$10$7Nd94wzpM5FSSZ8BulxXBe53S4MDHSJDSK4ZHQZTVpDguw0kNYww6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('65', 'Nguyễn Đình Tuấn', 'ndtuan', NULL, NULL, '1986-11-19', '2006-02-01', NULL, 'ndtuan', '2025-09-03 04:47:37', '$2y$10$M2x4bqPEEY7wO7Suz33rKeyVvCZ/9K4ahNadiwt6IWL8j7Mio4j4i', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('66', 'Trần Ngọc Dũng', 'tndung', NULL, NULL, '1987-12-08', '2006-09-01', NULL, 'tndung', '2025-09-03 04:47:37', '$2y$10$v4ZzgRDzgS88kOk7N0TJqOxJVHvnBg/cM8MZNXVtQjC6Ozm/dUwOC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('67', 'Nguyễn Anh Tuấn', 'natuan87', NULL, NULL, '1974-02-10', '1992-02-01', NULL, 'natuan', '2025-09-03 04:47:37', '$2y$10$T/0WEQ9Tg4m8U/uJaOxYX.1mO5d7UbbUy9MNQtm2mSL911n65FWg2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:37', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('68', 'Nguyễn Xuân Dũng', 'nxdung', NULL, NULL, '1974-10-06', '1992-02-01', NULL, 'nxdung', '2025-09-03 04:47:38', '$2y$10$67kMghdQTEIxLn/h8HfuhuwAqckyKAXkMEzaTPfl.pFVfRWdB7jNS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('69', 'Ngô Viết  Toản', 'nvtoan', NULL, NULL, '1973-08-12', '1994-02-01', NULL, 'nvtoan', '2025-09-03 04:47:38', '$2y$10$pJm2FW71dd5L2Xf5vlKMBesu4VF5r6oRm7xgSwunKo7rtKIjvRO/C', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('70', 'Hoàng Minh Ánh', 'hmanh', NULL, NULL, '1973-12-22', '1993-02-01', NULL, 'hmanh', '2025-09-03 04:47:38', '$2y$10$TA0DdLZfrG1tqBu2YzxxYeKKMf0U.ZRZS.tpONh6nvmgeG6PXcjui', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('71', 'Nguyễn Văn Luỹ', 'nvluy', NULL, NULL, '1984-10-25', '2002-09-01', NULL, 'nvluy', '2025-09-03 04:47:38', '$2y$10$aOuKFAKV3LYeqqtPY.eGf.wJWKPKizcSUKs9OCSHSfC3b2oUgapM2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('72', 'Trần Bá Trường', 'tbtruong', NULL, NULL, '1991-12-17', '2010-09-01', NULL, 'tbtruong', '2025-09-03 04:47:38', '$2y$10$lNHK2wZwLMKU622L7D2fVua7iyXwl/7Y2yRtO3YMqLtfD18Wz2cgG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('73', 'Bùi Văn Phong', 'bvphong', NULL, NULL, '1985-10-04', '2003-10-01', NULL, 'bvphong', '2025-09-03 04:47:38', '$2y$10$fYylb8Ox2YEdORHR8GNivORF49fsNZiyhfn19BG3uffOYDjQFV7EO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('74', 'Mai Văn Thuy', 'mvthuy', NULL, NULL, '1967-05-28', '1986-02-01', NULL, 'mvthuy', '2025-09-03 04:47:38', '$2y$10$44BW.GKTC89M5RZCttmCxemQ./tDhj5QexiJv1uWJD3wSdARp9A.C', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('75', 'Nguyễn Văn Cường', 'nvcuong79', NULL, NULL, '1975-05-01', '1994-02-01', NULL, 'nvcuong', '2025-09-03 04:47:38', '$2y$10$LbbPSduZVFn5Z5VamP59C.tIxnPf1g27GcJxljnTwOjgH4SyEl2aq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('76', 'Phan Thị Thu Hường', 'ptthuong83', NULL, NULL, NULL, NULL, NULL, 'ptthuong_1', '2025-09-03 04:47:38', '$2y$10$RgFa8B6uzBZniVM4Jm4bTesleKtJvCDxyU7Q1MPkq18CoUK2GMtEO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('77', 'Trịnh Thu Huyền', 'tthuyen', NULL, NULL, '1982-11-27', '2003-12-01', NULL, 'tthuyen', '2025-09-03 04:47:38', '$2y$10$dHHqF4UNXO9Y3ErIemmcd.oUP/hvgrGQ6cHXV5INFike7lCyPUop2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('78', 'Đặng Thị Huệ', 'dthue', NULL, NULL, '1993-05-08', '2015-03-01', NULL, 'dthue', '2025-09-03 04:47:38', '$2y$10$lUJ0YjQekfB8IEPL7g8/v.ZGeTTEQNW.4P3200lcUoOm1kN0rO0..', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('79', 'Đinh Tiến Dũng', 'dtdung', NULL, NULL, '1976-07-13', '1997-03-01', NULL, 'dtdung', '2025-09-03 04:47:38', '$2y$10$4Xidb.2x2e7QD3zSZRsZZuiFkn6w6Tci6SuxFPp3/.3dGeWnyPFN2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('80', 'Đoàn Thị Sự', 'dtsu', NULL, NULL, '1971-12-12', '1999-03-01', NULL, 'dtsu', '2025-09-03 04:47:38', '$2y$10$hFipMa7zInqrO01LcPOnDOLbevK4AXbAZwE.oMR/EiJEywtZHXLpu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('81', 'Phạm Thị Thu  Hà', 'pttha', NULL, NULL, '1976-12-15', '1995-02-01', NULL, 'pttha', '2025-09-03 04:47:38', '$2y$10$8QVtvxmnDpMIjY/AklgKtOZf9NhZbbZu2GdahkljVCk5t4t7Oj1nW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('82', 'Đinh Thị Tâm', 'dttam', NULL, NULL, '1979-05-05', '2003-12-01', NULL, 'dttam', '2025-09-03 04:47:38', '$2y$10$Gu.tyHdoeTVJrelbyU1f0O5FnzbNkiZ5tJz3ZHlBt2c/k9dNM9aLS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:38', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('83', 'Nguyễn Thị Hiền', 'nthien', NULL, NULL, '1992-08-02', '2020-12-01', NULL, 'nthien', '2025-09-03 04:47:39', '$2y$10$qrY9Uxt12AthGtU9XxcABOSVZHP1r2QUga3oQct5oaiQ2n3h0TCTi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('84', 'Đinh Quang Điềm', 'dqdiem', NULL, NULL, '1985-11-02', '2003-09-01', NULL, 'dqdiem', '2025-09-03 04:47:39', '$2y$10$w.t/Sp7u7JspAI1Ao6e3S.4hOsf9vee5rAKuqknWYUTibKo3AlTJa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('85', 'Huỳnh Thái Tân', 'httan', NULL, NULL, '1967-06-16', '1986-03-01', NULL, 'httan', '2025-09-03 04:47:39', '$2y$10$ufYkWmV7qHMzFtp632dZmedwp3OH0/MPxUosS9yR1xpxdcQw0.VAu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('86', 'Mai Trường Giang', 'mtgiang', NULL, NULL, '1974-01-02', '1992-02-01', NULL, 'mtgiang', '2025-09-03 04:47:39', '$2y$10$x.oSFHjTvcBLTBxvVOIJK.skPno6n7wty56uqMHvhi/z9PqudymZi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('87', 'Nguyễn Việt Dũng', 'nvdung', NULL, NULL, '1976-06-26', '1995-02-01', NULL, 'nvdung', '2025-09-03 04:47:39', '$2y$10$9eVAWqjSwpm5JujnJH/6vuKUElq2td8me1kEVu7YrjCz.jEy2TQ/u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('88', 'Nguyễn Xuân Quý', 'nxquy', NULL, NULL, '1977-02-12', '1996-03-01', NULL, 'nxquy', '2025-09-03 04:47:39', '$2y$10$2YpJC3PQnBOi90Jb.cF0Su.WAwmTpTUyBwVKckqaeMim.0KPlfbtG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('89', 'Nguyễn Xuân Bách', 'nxbach', NULL, NULL, '1975-05-31', '1994-02-01', NULL, 'nxbach', '2025-09-03 04:47:39', '$2y$10$Adn6J63dyFy2ySQg5TmjYuTtcYv3LITWLbTsmxeY1qxg8Hevt327e', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('90', 'Nguyễn Ngọc Quý', 'nnquy', NULL, NULL, '1983-10-06', '2003-02-01', NULL, 'nnquy', '2025-09-03 04:47:39', '$2y$10$LF0JlYj3zu5w8VfsIAz8feSqX14GXse8FHw0Z/wm9eDz7lFWOuSeS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('91', 'Thái Thị Hà', 'ttha', NULL, NULL, '1981-07-08', '2001-02-01', NULL, 'ttha', '2025-09-03 04:47:39', '$2y$10$zQehr1xbcU00QmCaNJIyGe84.j.01LB0m5n1653eH7BkNs3mfTNMS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('92', 'Nguyễn Văn Bách', 'nvbach', NULL, NULL, '1974-07-15', '1992-02-01', NULL, 'nvbach', '2025-09-03 04:47:39', '$2y$10$79LrqoM8qM7ForjHxZrQheBkLG8G0ipT5NgjQpl8CHwXyJwMki5gy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('93', 'Nguyễn Văn Cường', 'nvcuong792', NULL, NULL, NULL, NULL, NULL, 'nvcuong_1', '2025-09-03 04:47:39', '$2y$10$j.8IGqt2rRCpBrCq5FIMze66AdAPg47BxmorMDKV0GzSQLizORDQW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:48:35', NULL);
INSERT INTO `users` VALUES ('94', 'Nguyễn Văn Phú', 'nvphu', NULL, NULL, '1988-08-14', '2007-03-01', NULL, 'nvphu', '2025-09-03 04:47:39', '$2y$10$PHjZWix5PBnbSch18GkuveQIgOAnqT2esy0U6iA2WY5VcHZ6eMJrC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('95', 'Phạm Thị Kiều Ân', 'ptkan', NULL, NULL, '1982-06-13', '2003-12-01', NULL, 'ptkan', '2025-09-03 04:47:39', '$2y$10$8yC0oCgWG8n.JvfeFRuW3.55oGxT15oyL6oJlReOQKtJyG8.QxXjO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('96', 'Nguyễn Thị Thuý', 'ntthuy87', NULL, NULL, '1987-07-05', '2012-02-01', NULL, 'ntthuy', '2025-09-03 04:47:39', '$2y$10$shayWEiONNAIi/B8Pzvy5etB1i0Vt0ogbPZ78TNEKjtJURSLxjNAC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('97', 'Dương Thị Mơ', 'dtmo', NULL, NULL, '1990-10-19', '2015-03-01', NULL, 'dtmo', '2025-09-03 04:47:39', '$2y$10$118RR/fcnDpq0tcy9q2gTe18PxI05T5T8qhP6pu5nAZQwi0wTCpwW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:39', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('98', 'Nguyễn Thị Hằng', 'nthang', NULL, NULL, '1995-06-24', '2016-02-01', NULL, 'nthang', '2025-09-03 04:47:40', '$2y$10$7qcNT9Wqk21SVzyUqYgEr.ul.85bT6yK52R9AbG5BEcdyuzB7emzG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('99', 'Phạm T Thu Hương', 'ptthuong832', NULL, NULL, NULL, NULL, NULL, 'ptthuong_2', '2025-09-03 04:47:40', '$2y$10$7toV8/ehL8ts2IquuvMfqusKqS/GHsyihUEguzmAhGO6WOKBZkROG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:48:35', NULL);
INSERT INTO `users` VALUES ('100', 'Chử  Quang Anh', 'cqanh', NULL, NULL, '1980-02-10', '1999-03-01', NULL, 'cqanh', '2025-09-03 04:47:40', '$2y$10$WIeNYTMyegvAirvMuGPjRuKaxpIUrVQ8pBNLTH3JhIB7YylDkd/.O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('101', 'Đào Văn Tiến', 'dvtien', NULL, NULL, '1973-08-31', '1991-09-01', NULL, 'dvtien', '2025-09-03 04:47:40', '$2y$10$vNMJYHw2VLFC0HHyX7GP3O1eJJOhl81UxgdYvFAnjOAzrrbrB748a', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('102', 'Trần Đình Tám', 'tdtam', NULL, NULL, '1979-07-30', '1999-03-01', NULL, 'tdtam', '2025-09-03 04:47:40', '$2y$10$73//Lc3x4/JWbjjTOm/QSuctjN9gotLOWPey8n.PnrxOgjrXdbyvm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('103', 'Nguyễn Quỳnh Trang', 'nqtrang', NULL, NULL, '1981-04-02', '2001-02-01', NULL, 'nqtrang', '2025-09-03 04:47:40', '$2y$10$Gl88Znh0sKES82U.kT5wxe72gjUnDioKKiMrm.vUMnEZhlgNmdzjm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('104', 'Lê Mạnh Hà', 'lmha', NULL, NULL, '1990-08-13', '2012-02-01', NULL, 'lmha', '2025-09-03 04:47:40', '$2y$10$NwwRGHF2foVFFO/Gqk.oXOxIwj28k68BDpcl9lrLQajfSGwAWbBri', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('105', 'Nguyễn Thị Anh', 'ntanh', NULL, NULL, '1990-08-24', '2015-03-01', NULL, 'ntanh', '2025-09-03 04:47:40', '$2y$10$5R8yJ7LfQsd65vzxpMFgG.MjGwXOg/Y1rjp6cAgLBphg1UJllPnD2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('106', 'Đỗ Đức Toàn', 'ddtoan', NULL, NULL, '1984-10-21', '2013-03-01', NULL, 'ddtoan', '2025-09-03 04:47:40', '$2y$10$4TsdwkqQXi3xXlevzh4agek03IYFGmwfwt6b0Yaa9K0eAxBWJgDia', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('107', 'Triệu T Hoài Phương', 'tthphuong', NULL, NULL, '1987-11-13', '2016-09-01', NULL, 'tthphuong', '2025-09-03 04:47:40', '$2y$10$Ulc1sGIBVYLwM402C//mROIzbB/z0f8LF1RYqBLdfdVsjKu7DwO5O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('108', 'Trịnh Bá Thuận', 'tbthuan', NULL, NULL, '1966-08-16', '1983-09-01', NULL, 'tbthuan', '2025-09-03 04:47:40', '$2y$10$/F.HA0ldOa16Ma/e0TKXj.JftElFzObBoblazmtIYCJlRaly8xJEe', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('109', 'Đặng Quốc Sỹ', 'dqsy', NULL, NULL, '1980-01-20', '2001-02-01', NULL, 'dqsy', '2025-09-03 04:47:40', '$2y$10$V9RxADrg9y1Jk5ZabujAh.AAlNM8xDPCWvd9nK5Kg2y5XqgqaoiNe', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('110', 'Phạm Lan Phương', 'plphuong', NULL, NULL, '1994-05-14', '2016-09-01', NULL, 'plphuong', '2025-09-03 04:47:40', '$2y$10$ixXyriNOp/QgH3IoWZhhCeFZ.6AIT3BeviUNo7D9sAE0XPQkPqZPS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('111', 'Giang Chí Dũng', 'gcdung', NULL, NULL, '1998-01-18', '2022-12-01', NULL, 'gcdung', '2025-09-03 04:47:40', '$2y$10$.G7GJCzPY6TKB1zuna/IyOEpFrsFl5vRVgqzVUhy8uyaCDYbhLej2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('112', 'Nguyễn Thị Huyền', 'nthuyen90', NULL, NULL, '1990-10-28', '2022-12-01', NULL, 'nthuyen', '2025-09-03 04:47:40', '$2y$10$Zow1s8D19uOKTk2c.OUmgeEXw4v6e5l1ALFQNfK7KB4GPG0.o6cjm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('113', 'Nguyễn T Phương Chi', 'ntpchi', NULL, NULL, '1981-06-17', '2001-02-01', NULL, 'ntpchi', '2025-09-03 04:47:40', '$2y$10$DNyWNv69PPMRupuZBxQaUeSs93Y/PoDYzavsCOospi08cb5tFN0xa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:40', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('114', 'Phạm Thị Vân Anh', 'ptvanh', NULL, NULL, '1992-03-28', '2014-03-01', NULL, 'ptvanh', '2025-09-03 04:47:41', '$2y$10$Y7fGZiuO/pyFU4w6SMiHlOOr1kSxNiGKWQ8hTQdxpbAQg2SJnwFlW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('115', 'Trần Thị Tuyến', 'tttuyen', NULL, NULL, '1989-06-20', '2014-03-01', NULL, 'tttuyen', '2025-09-03 04:47:41', '$2y$10$VDOgeoLuqkrv5qxKrRntDOnSNtq5QzjED1uXucqcmluGbPadiOpze', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('116', 'Bùi Đức Anh', 'bdanh', NULL, NULL, '1993-10-31', '2015-03-01', NULL, 'bdanh', '2025-09-03 04:47:41', '$2y$10$rdBU68De48C9iw9tIL9ICOPasdNmz4/i3hR5ln11l4cjVbeV9rNRa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('117', 'Vũ Thị Kim Ngân', 'vtkngan', NULL, NULL, '1989-08-27', '2013-03-01', NULL, 'vtkngan', '2025-09-03 04:47:41', '$2y$10$a.GEq.w/cdnQTZNMMe5vDOWDDMllTZgk.5QZs3YZKNJ6YqkcT4yVO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('118', 'Nguyễn Thu Huyền', 'nthuyen82', NULL, NULL, NULL, NULL, NULL, 'nthuyen_1', '2025-09-03 04:47:41', '$2y$10$/QmB0Q91E6vaVhATojKtiOVU0IrGSNLG5n8i0jCRyUc6Yte6f677O', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('119', 'Trần Trọng Đại', 'ttdai', NULL, NULL, '1985-12-04', '2004-08-01', NULL, 'ttdai', '2025-09-03 04:47:41', '$2y$10$OYCpGleDwyM0cR3.j5FEKOyshrrEFodxwM0NxUGb4SQxrNHRKFxBC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('120', 'Lưu Hoàng Văn', 'lhvan', NULL, NULL, '1992-05-10', '2009-09-01', NULL, 'lhvan', '2025-09-03 04:47:41', '$2y$10$ss8TNXGHc78o4M.EYdmzeOXZkbEVeJXOaRpp9iKihxR28EaebQlUK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('121', 'Đồng Xuân Dũng', 'dxdung', NULL, NULL, '1999-01-01', NULL, NULL, 'dxdung', '2025-09-03 04:47:41', '$2y$10$OtDwpIy6iFAFr6RDyqPrO.ec0V5OpmMUNRfDJ8ZDu52wp4kD.3n.e', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('122', 'Trương Thanh Tú', 'tttu', NULL, NULL, '2001-01-01', NULL, NULL, 'tttu', '2025-09-03 04:47:41', '$2y$10$x39sCdFKf5YCJ.iuECze..xc9SEotHo/Lm5zoZ9xlWxSMKy83YiGC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('123', 'Dương T Phương Loan', 'dtploan', NULL, NULL, '1977-08-29', '2003-12-01', NULL, 'dtploan', '2025-09-03 04:47:41', '$2y$10$y0nZ7XF2sK9QBoIyWv1m9.plUT91SWfA34Vk85/pYj9IZokd0HESO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('124', 'Nguyễn  Hữu Thanh', 'nhthanh', NULL, NULL, '1983-09-02', '2002-10-01', NULL, 'nhthanh', '2025-09-03 04:47:41', '$2y$10$yr/zQO63.5qmvYl6arWWNO0CTr17Kl2/352DvVhlzxw1kiBYILGw.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('125', 'Nguyễn Thị Tuyền', 'nttuyen', NULL, NULL, '1983-02-13', '2012-02-01', NULL, 'nttuyen', '2025-09-03 04:47:41', '$2y$10$V4fCfLtv7GYZ7iXvU5.0kO8nq1uNlbB9WZtteKQo6x97/Sl5KFJFm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('126', 'Lê Thị Thuý Hằng', 'ltthang', NULL, NULL, '1985-03-24', '2012-02-01', NULL, 'ltthang', '2025-09-03 04:47:41', '$2y$10$vbu7L11o6YVBz5A7JBThFe5ahgRILvS15xtLA//Bt.CkRc7SSLmae', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('127', 'Nguyễn T Thuý Bình', 'nttbinh', NULL, NULL, '1984-10-30', '2012-02-01', NULL, 'nttbinh', '2025-09-03 04:47:41', '$2y$10$gdWleQXYNNz6YqmYxpESo./9qG8izrotZlbEzQbLtn206ZiHPlQtm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('128', 'Đặng Thị Kim Dung', 'dtkdung', NULL, NULL, '1981-06-05', '2016-09-01', NULL, 'dtkdung', '2025-09-03 04:47:41', '$2y$10$PTfKtYqy8AxhVB4UtWZXdePuxLaCkARvLh3wo0qgo24wkD66uzOmW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:41', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('129', 'Dương Thị Thân Thương', 'dttthuong', NULL, NULL, '1989-06-29', '2014-03-01', NULL, 'dttthuong', '2025-09-03 04:47:42', '$2y$10$kmXeKiY0AXHqertXnUO6meqJ3tXQCO1d.j8KANXN.xbWU9qwKSOuC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('130', 'Phạm Thị Trang Nhung', 'pttnhung', NULL, NULL, '1979-09-27', '2012-02-01', NULL, 'pttnhung', '2025-09-03 04:47:42', '$2y$10$/Fc5ICvbx6EYx7GbfoNi8Ok9TDeMdnnvWaRUMbkw.eQyrCXnATIYW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('131', 'Trần Thị Chuyên', 'ttchuyen', NULL, NULL, '1990-10-20', '2014-03-01', NULL, 'ttchuyen', '2025-09-03 04:47:42', '$2y$10$6jqnQuoADHccTkWwOLK1f.Mw0zxjZh2hU0y/h1jyG3f5zjLgahFvG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('132', 'Phạm Khắc Hùng', 'pkhung', NULL, NULL, '1985-10-12', '2004-02-01', NULL, 'pkhung', '2025-09-03 04:47:42', '$2y$10$S40uCxXBlExiPrhVp1wWhulhltLX1T/WgemI.VtBGeJziwoKVql2y', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('133', 'Nguyễn Mạnh Hùng', 'nmhung', NULL, NULL, '1974-05-01', '1995-02-01', NULL, 'nmhung', '2025-09-03 04:47:42', '$2y$10$NCZ88bFROnBORDlc01HSku.n1TRgWlLOrlz/qN34KoihmGnZBMS5a', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('134', 'Vũ Mạnh Tú', 'vmtu', NULL, NULL, '1985-06-26', '2004-02-01', NULL, 'vmtu', '2025-09-03 04:47:42', '$2y$10$nF/gdm0mg1rCDIiB99tYROHC6gtMdlDrIPx3f1v5ECt6BNE0lxsg2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('135', 'Bùi Anh Tuấn', 'batuan', NULL, NULL, '1983-03-11', '2004-02-01', NULL, 'batuan', '2025-09-03 04:47:42', '$2y$10$nV7ucuBpaJJv/q40/USzKukjN4wfu/M/hU5/jPG5XJZbttM37Djze', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('136', 'Nguyễn Văn Thụ', 'nvthu', NULL, NULL, '1988-11-03', '2012-02-01', NULL, 'nvthu', '2025-09-03 04:47:42', '$2y$10$IR9.igPIy3Y4zoMszthyourzWA5Yq1s63Jp8m7mVw34bMof3z9VJy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('137', 'Đặng Văn Phố', 'dvpho', NULL, NULL, '1974-01-01', '1992-02-01', NULL, 'dvpho', '2025-09-03 04:47:42', '$2y$10$JnxkbdQzwsIo4Nj4vWdJF.9vJDoRNzz2IxxXWvAFyv85BVgB/okfS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('138', 'Nguyễn Xuân Trường', 'nxtruong', NULL, NULL, '1982-02-25', '2001-02-01', NULL, 'nxtruong', '2025-09-03 04:47:42', '$2y$10$euvyjs3VQ/rvZZ2nBu2IzuauVtSG.sVhDpyl5RGuWLJfgC1juk/s2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('139', 'Hà Thanh Trung', 'httrung', NULL, NULL, '1973-10-20', '1992-02-01', NULL, 'httrung', '2025-09-03 04:47:42', '$2y$10$zd8mgmUrAeao.lF8OQlGIuPc2S4wkDu9R7H4Jh0PVIJSIV66nFaV6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('140', 'Nguyễn Văn Huyên', 'nvhuyen', NULL, NULL, '1982-08-20', '2002-03-01', NULL, 'nvhuyen', '2025-09-03 04:47:42', '$2y$10$eb8TViKikRxphpmqWO2lhuMUzb79zfg2/sLq6OTObMj6oy7HhfY1m', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('141', 'Nguyễn Gia Mạnh', 'ngmanh', NULL, NULL, '1985-06-25', '2005-02-01', NULL, 'ngmanh', '2025-09-03 04:47:42', '$2y$10$6rcYAdKM5Xh..anDixRFLO5nFTzwSmQDHcDNlQDLwBLnFFsTkhzvu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('142', 'Đỗ Hồng Sơn', 'dhson', NULL, NULL, '2001-12-27', '2020-02-01', NULL, 'dhson', '2025-09-03 04:47:42', '$2y$10$Eho3g98ulCdj2RDO4Dqrw.cBkLQAqSumGPjloPEJxRHzdn5V73ihW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('143', 'Nguyễn Tuấn Hiệp', 'nthiep', NULL, NULL, '1974-06-04', '1995-10-01', NULL, 'nthiep', '2025-09-03 04:47:42', '$2y$10$0NfbSfAY4ZSyu7Vc4dWDdebNQ6EritxonYEUiqSn/sO8iS6NqSTh2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('144', 'Vũ Mạnh Cương', 'vmcuong', NULL, NULL, '1978-05-09', '2003-12-01', NULL, 'vmcuong', '2025-09-03 04:47:42', '$2y$10$v2F788apYQEvpsYkurRFX.rSyDIeHF8Nr4XdupmJ3/LA3VyYsrdx.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:42', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('145', 'Lê Trọng Quỳnh', 'ltquynh', NULL, NULL, '1978-12-16', '2003-12-01', NULL, 'ltquynh', '2025-09-03 04:47:43', '$2y$10$ypV1LRn6a50E5.iljcdko.L0IHIIuxrHv2attL5Iino8tBMwOGVoq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('146', 'Đặng Viết Công', 'dvcong', NULL, NULL, '1983-09-12', '2003-12-01', NULL, 'dvcong', '2025-09-03 04:47:43', '$2y$10$hHryQDoNs5MwbQHQg3qGb.nbgRe86HMDis1B1kw1Zy5r0HLF26k8y', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('147', 'Nguyễn Tiến Dũng', 'ntdung', NULL, NULL, '1996-09-22', '2015-03-01', NULL, 'ntdung', '2025-09-03 04:47:43', '$2y$10$bVUNnLItaUEGFvlPjJERIuSJPfUJAxzx5R/CJ6lCt4fBmGsOcTWYO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('148', 'Nguyễn Hồng Anh', 'nhanh', NULL, NULL, '1981-05-04', '1999-09-01', NULL, 'nhanh', '2025-09-03 04:47:43', '$2y$10$xAKSq.gWkoi/8BgnAdOmHemfATXbgIbo.g9E4UXHT3PB07emgR8ee', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('149', 'Trần Đức Tấn', 'tdtan', NULL, NULL, '1987-07-11', '2005-09-01', NULL, 'tdtan', '2025-09-03 04:47:43', '$2y$10$Zl2U9hf3p0bzFTph.wc1ZOsJVfmHXgsR0P5LQSm3Iamh/1YtMVTUe', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('150', 'Hoàng Anh Dũng', 'hadung', NULL, NULL, '2000-08-21', '2018-09-01', NULL, 'hadung', '2025-09-03 04:47:43', '$2y$10$OdXX8JYDm2RqYGIttbYGfuysgpuDkSv6reC1XQ1.SKYplz5RcOneK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('151', 'Nguyễn Mai Hương', 'nmhuong', NULL, NULL, '1983-09-01', '2003-12-01', NULL, 'nmhuong', '2025-09-03 04:47:43', '$2y$10$wOV/z6p9Cja1kxDm5MNo5.9KooD11uu6M27Up1K4ASt.jraPQQQZG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('152', 'Hoàng Văn Tiến', 'hvtien', NULL, NULL, '1978-05-16', '1998-02-01', NULL, 'hvtien', '2025-09-03 04:47:43', '$2y$10$2Sa0QH2fYCS9OcHHeNCjc.aPkb4MUZ43db7k97rVMm9r8sj2ga1xS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('153', 'Nguyễn Xuân Thụ', 'nxthu', NULL, NULL, '1989-03-23', '2007-10-01', NULL, 'nxthu', '2025-09-03 04:47:43', '$2y$10$N80n.Kafb2kWu0TjJx6sKOyVxc5McvJmTk8.WJKMxy4k7CLvYg42K', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('154', 'Hà Nguyễn Tuấn Anh', 'hntanh', NULL, NULL, '1998-12-02', '2024-08-01', NULL, 'hntanh', '2025-09-03 04:47:43', '$2y$10$etJ2Gx61.j8wyTWYidulYuVGQiTiDTEPX6YUUIJ43GyhoHC96LmAW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('155', 'Đinh Viết Trường', 'dvtruong', NULL, NULL, '1992-08-28', '2010-09-01', NULL, 'dvtruong', '2025-09-03 04:47:43', '$2y$10$rIBWlwn0VnCWxnvnxLYLm.GSrJD3jN6CUoCHfDfska8jAsD6kUKra', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('156', 'Phan Thanh Quang', 'ptquang', NULL, NULL, '1981-05-23', '2000-02-01', NULL, 'ptquang', '2025-09-03 04:47:43', '$2y$10$ttlhZ8WxIyR8wEgfPwssCuou4vDMDws8atcHN9cMxpHx6AaD46Fce', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('157', 'Nguyễn Tiến Nam', 'ntnam', NULL, NULL, '1981-10-09', '2000-02-01', NULL, 'ntnam', '2025-09-03 04:47:43', '$2y$10$pi9Ft/h6Zpdg1ZAh4zDaOuX1VcbSNzsSEX7xWGM/yXheJVH1iiCAq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('158', 'Nguyễn Huy Thắng', 'nhthang', NULL, NULL, '1983-01-01', '2004-02-01', NULL, 'nhthang', '2025-09-03 04:47:43', '$2y$10$jHSTrQZS5Q9X6PwCoyXlne1Gynrmzk69Su6PsPgKx5gAj6PyhsEMm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('159', 'Trần Hồng Công', 'thcong', NULL, NULL, '1989-10-21', '2016-09-01', NULL, 'thcong', '2025-09-03 04:47:43', '$2y$10$pVitDLYy2f6iIA4cZ4GBvearKmVLpZUG7QHMC6yX.qOxjKaw0cBM6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('160', 'An Văn Trực', 'avtruc', NULL, NULL, '1983-07-09', '2001-09-01', NULL, 'avtruc', '2025-09-03 04:47:43', '$2y$10$WB..DRbm5jmsoDePghJ9Eekpju74TAZihE7HOwhntaRV3xj.k8C9m', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('161', 'Phạm Quỳnh Trang', 'pqtrang', NULL, NULL, '1987-10-28', '2012-02-01', NULL, 'pqtrang', '2025-09-03 04:47:43', '$2y$10$49ue58DvEyf4JGH.ENT41OocOD9kY5MKa3L63YK.YV7L6mONTjRxa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:43', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('162', 'Ngô Thị Sơn', 'ntson', NULL, NULL, '1970-09-26', '1998-06-01', NULL, 'ntson', '2025-09-03 04:47:44', '$2y$10$q8.zKUnsa8u70KJGCUa8fO5ZNnCqvwrMFEh155nJh8QXT1rk2KqHy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('163', 'Nguyễn Anh Tuấn', 'natuan872', NULL, NULL, NULL, NULL, NULL, 'natuan_1', '2025-09-03 04:47:44', '$2y$10$PGn0dskaUCxWw7Xzt22jd.nbZRcitjD2VbauxRooCrX/zh75RcMnO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:48:35', NULL);
INSERT INTO `users` VALUES ('164', 'Trần  Ngọc Phú', 'tnphu', NULL, NULL, '1983-12-18', '2002-03-01', NULL, 'tnphu', '2025-09-03 04:47:44', '$2y$10$laL4lqCJ/T0bZp1CNR5gGeTrOEDW9uMSxag5UXMJEpbk1olo.qfZ2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('165', 'Nguyễn Tuấn Long', 'ntlong76', NULL, NULL, '1983-04-15', '2003-02-01', NULL, 'ntlong', '2025-09-03 04:47:44', '$2y$10$W5VSU6f9.beqSCzki4o4PeKVvSqzroQXccn4r7a7VeyCij7VavZ0S', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('166', 'Nguyễn Đức Anh', 'ndanh', NULL, NULL, '1993-06-08', '2022-12-01', NULL, 'ndanh', '2025-09-03 04:47:44', '$2y$10$lvHOwAv0Etegm5y3QOLV.uQX1riONGjxD7j91LdYCBZTExBWvGXHm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('167', 'Nguyễn Phú Hùng', 'nphung', NULL, NULL, '1995-01-06', '2023-12-01', NULL, 'nphung', '2025-09-03 04:47:44', '$2y$10$6.v917lJbHusvTzY7yp43egTNM1oY1wUV5hcA4ORlKmxMv.rxCCDC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('168', 'Nguyễn Anh Đạt', 'nadat', NULL, NULL, '1995-06-25', '2014-03-01', NULL, 'nadat', '2025-09-03 04:47:44', '$2y$10$3iTZy2SaOa95Ul8mR6oAxur6I8FuwChs8xivkKW68H9.DX7T7EGxS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('169', 'Trịnh Trọng Cường', 'ttcuong', NULL, NULL, '1975-01-15', '1994-02-01', NULL, 'ttcuong', '2025-09-03 04:47:44', '$2y$10$x2L6X.dmhHZ5o1vEck3qyOyvoGr82KAYh/o8AYHtpJe..jsn2HU0u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('170', 'Cấn Xuân Khánh', 'cxkhanh', NULL, NULL, '1991-02-14', '2010-09-01', NULL, 'cxkhanh', '2025-09-03 04:47:44', '$2y$10$Dppo1.ef0YLXoPVISmZwbuCBjivcoXg65J6PLRKunmMCUuqrMm0Tu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('171', 'Vũ Thị Hiền', 'vthien', NULL, NULL, '1988-02-08', '2012-02-01', NULL, 'vthien', '2025-09-03 04:47:44', '$2y$10$K5/D44ENAdLE78ba1CK.7e4VBJx2sjw18KVXJRt/pHC9YJUBWbauO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('172', 'Phan Văn Đăng', 'pvdang', NULL, NULL, '1974-05-05', '1995-02-01', NULL, 'pvdang', '2025-09-03 04:47:44', '$2y$10$ltZ.ChnIja9G8luOT3CSFOOcUAQfp7VkSQrLtYfv2FmD8lo5aj7vK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('173', 'Bùi Mạnh Hùng', 'bmhung', NULL, NULL, '1982-10-30', '2016-02-01', NULL, 'bmhung', '2025-09-03 04:47:44', '$2y$10$H1oEpoozvnPZ9GrhNwd2y.T/x2OtD1e8CGh.LGjLyc0sYZfNbNqkq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('174', 'Trần Văn Thành', 'tvthanh', NULL, NULL, '1974-08-16', '1994-02-01', NULL, 'tvthanh', '2025-09-03 04:47:44', '$2y$10$5608A8b8zqAPUhxmvWJDGuZr5gnOL5EPD0YqrBFWS82/tu/EehING', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('175', 'Vũ Trịnh Giang', 'vtgiang', NULL, NULL, '1992-09-02', '2016-02-01', NULL, 'vtgiang', '2025-09-03 04:47:44', '$2y$10$T67NLw1.MyDj28y/Of5XY.IDrwsJsFIVVceOVsveaPWhdHEJfQqEi', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('176', 'Nguyễn Tuấn Long', 'ntlong762', NULL, NULL, NULL, NULL, NULL, 'ntlong_1', '2025-09-03 04:47:44', '$2y$10$QLnkS7zYWyXC6RYcT4M1gerMTY6qWN1KtqThBkE4ZI8JLc8Y9QzH6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:48:35', NULL);
INSERT INTO `users` VALUES ('177', 'Vũ Huy Phương', 'vhphuong', NULL, NULL, '1986-09-25', '2014-03-01', NULL, 'vhphuong', '2025-09-03 04:47:44', '$2y$10$TMlk4NOWnUVf89uj7oledePH..v/Cylh6L8AiVCDXcg5J6.dGSslO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:44', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('178', 'Vũ Hải Dương', 'vhduong', NULL, NULL, '1991-05-16', '2016-02-01', NULL, 'vhduong', '2025-09-03 04:47:45', '$2y$10$4IORT9VpiWwhRrgRtkkvUO6t8ovdhIUFG7N6FgJIg2QfY0uhLouEm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('179', 'Trịnh Thành Chung', 'ttchung', NULL, NULL, '1986-08-01', '2016-09-01', NULL, 'ttchung', '2025-09-03 04:47:45', '$2y$10$SPAcr.9Nv.vtS0QEi.NdtuHkXh9wJmily7Bbw2zexikEp/Fjud6MS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('180', 'Nguyễn Diên Quang', 'ndquang', NULL, NULL, '1981-11-20', '2002-03-01', NULL, 'ndquang', '2025-09-03 04:47:45', '$2y$10$7855YZfMkJv.OHmmybUh4.GLtf708cL5rYgZfnJPnFiS5ZdeltriC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('181', 'Mai Thị Phượng', 'mtphuong', NULL, NULL, '1982-08-03', '2012-02-01', NULL, 'mtphuong', '2025-09-03 04:47:45', '$2y$10$KyoahAbY5CD97bOWGlOFoOEMMrjB.t9Sg9wlKb12HhIfEAwYYWrlW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('182', 'Bùi Thị Hồng Thu', 'bththu', NULL, NULL, '1988-10-03', '2016-02-01', NULL, 'bththu', '2025-09-03 04:47:45', '$2y$10$aQkmWHSzp/ejSdQ6w4A.oO3JU8MJkPx3TcB8ZCBOKMqaHUQiaM322', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('183', 'Đặng Văn Tường', 'dvtuong', NULL, NULL, '1970-11-01', '1992-02-01', NULL, 'dvtuong', '2025-09-03 04:47:45', '$2y$10$RTmqCmO7yNKJQGv6nomnWONzknqPbGGktublpwMZVw5yPz2o2z1Ue', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('184', 'Trần Hồng Tú', 'thtu', NULL, NULL, '1981-01-11', '1999-03-01', NULL, 'thtu', '2025-09-03 04:47:45', '$2y$10$UC8wbek.xA7kCORJaI0qYeWBT4e7JkcVAr5eqDNFEzPZWfgJfPb6i', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('185', 'Lê Trọng Quý', 'ltquy', NULL, NULL, '1989-12-07', '2016-09-01', NULL, 'ltquy', '2025-09-03 04:47:45', '$2y$10$7xKNcn3CXRFzyrqs2gWqNeKa6.UutxQKsE/aC02wPlw.7UNVK2XiG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('186', 'Đỗ Trung Kiên', 'dtkien', NULL, NULL, '1994-01-19', '2023-12-01', NULL, 'dtkien', '2025-09-03 04:47:45', '$2y$10$zAzWoN95/qBy9xAId.QF2OAdCSjBDgUuGxndJ39zHQsM7rYFYcQqO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('187', 'Chu Lê Tuấn Anh', 'cltanh', NULL, NULL, '1998-11-16', '2024-08-01', NULL, 'cltanh', '2025-09-03 04:47:45', '$2y$10$5Fmaae7GL41vY1QvmqXRiuzKYKXQ5zPEzL1BUzsQO34ZOrjC4z82.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('188', 'Hoàng Văn Thắng', 'hvthang', NULL, NULL, '1995-10-02', '2014-02-01', NULL, 'hvthang', '2025-09-03 04:47:45', '$2y$10$xlAVb/nFZ7R4e.KqepCiWO5we4/5CrzecKGapIU5cB6TY.0atDBOm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('189', 'Nguyễn Thành Long', 'ntlong77', NULL, NULL, NULL, NULL, NULL, 'ntlong_2', '2025-09-03 04:47:45', '$2y$10$NFfKaNdIEf/q16FNdjqrNuKm7HtVBnWV2RtP3DGN.fa.BN7srbw0u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('190', 'Bùi Trường Giang', 'btgiang', NULL, NULL, '1987-04-23', '2005-09-01', NULL, 'btgiang', '2025-09-03 04:47:45', '$2y$10$QtO7pBaZWB3cw1kBAIRmA.8OKPd72tLk.F/qNF2ldS1HlUMse2pB6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('191', 'Nguyễn Hải Sơn', 'nhson', NULL, NULL, '1990-08-10', '2008-09-01', NULL, 'nhson', '2025-09-03 04:47:45', '$2y$10$Aa1MUwiUQvjlfMkHhzlICO0TSLNqw1YugduLkdKqI8331rtN..1Zu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('192', 'Nguyễn T Lan Anh', 'ntlanh', NULL, NULL, '1979-09-07', '2003-12-01', NULL, 'ntlanh', '2025-09-03 04:47:45', '$2y$10$gUc4Aka1KiHpjk0kzFv2LuHzfBL33VlHp1PFWWpKM9LcUyWG9pdJK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('193', 'Tống Cao Cường', 'tccuong', NULL, NULL, '1986-11-20', '2004-10-01', NULL, 'tccuong', '2025-09-03 04:47:45', '$2y$10$FZn3VsKlev6S3llnWlPEAeJfBQoOKcND0EfpWefORbkYFAnkAPX6q', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('194', 'Nguyễn Hữu Tâm', 'nhtam', NULL, NULL, '1983-07-22', '2003-12-01', NULL, 'nhtam', '2025-09-03 04:47:45', '$2y$10$PZGx2NTyRJkOQ1w9aTZJn.gmvEe/9TltSgJ1dblooQZqbn0SdO3ta', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:45', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('195', 'Hồ Thị Hiền', 'hthien', NULL, NULL, '1986-06-05', '2012-02-01', NULL, 'hthien', '2025-09-03 04:47:46', '$2y$10$Y5GIROmUDpRn02jg26GT9uUBgfLomMCbV3igmYBuJtB0B0LWGBL92', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('196', 'Nguyễn T Phương Thảo', 'ntpthao', NULL, NULL, '1993-06-22', '2022-12-01', NULL, 'ntpthao', '2025-09-03 04:47:46', '$2y$10$PvVQlDYz4S8bxNXh0I8vOeHZIh9OQIMZjy5eFaMQudBKbVPoTM2hS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('197', 'Bùi Văn Huy', 'bvhuy', NULL, NULL, '1983-10-15', '2003-02-01', NULL, 'bvhuy', '2025-09-03 04:47:46', '$2y$10$QahDR7wvHITTVfuoMzgyF.RvaqwcySKBqJoNv8hMWsmkXtQOrg2rK', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('198', 'Phan Văn Sáng', 'pvsang', NULL, NULL, '1978-12-21', '2003-12-01', NULL, 'pvsang', '2025-09-03 04:47:46', '$2y$10$fUx9ChlHwWtZrrHJnRcJOO8LMa4ZuxDyiJdvClkORvH4ZTCg6AHUu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('199', 'Hữu Thị Thuý', 'htthuy81', NULL, NULL, NULL, NULL, NULL, 'htthuy_1', '2025-09-03 04:47:46', '$2y$10$LogvddtQnXTVtBcgirdYXO0zX7oGBKNrzlG.1nRnLx7Jj7mTAe2pC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('200', 'Hà Minh Nho', 'hmnho', NULL, NULL, '1974-08-20', '1997-03-01', NULL, 'hmnho', '2025-09-03 04:47:46', '$2y$10$l2LolG.PH7VV61CSRbRqJOin1BxuDe0N5CRdIX64Ux2ZSp5o9kgU.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('201', 'Nguyễn Văn Đồng', 'nvdong', NULL, NULL, '1983-09-20', '2002-03-01', NULL, 'nvdong', '2025-09-03 04:47:46', '$2y$10$sy0rCePGzzQu0ZQHmFp7Z.fVENxG6YzwM4hPfCft7axP.qrsjiN9a', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('202', 'Trần T Kim Oanh', 'ttkoanh', NULL, NULL, '1982-09-12', '2003-12-01', NULL, 'ttkoanh', '2025-09-03 04:47:46', '$2y$10$mcpY5s0kVpOMlNs4l36NgexSXFhMDH1Sb.qt9FaR3CpWpPnS9kpdS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('203', 'Bùi Thị Huệ', 'bthue', NULL, NULL, '1991-10-22', '2016-02-01', NULL, 'bthue', '2025-09-03 04:47:46', '$2y$10$4V7o0YZg43WxoGguj.IFBeZzOnWZ5Dk/CcXLbradLTV.u7TVwjFDS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('204', 'Bùi Đức Cảnh', 'bdcanh', NULL, NULL, '1991-12-24', '2009-09-01', NULL, 'bdcanh', '2025-09-03 04:47:46', '$2y$10$7k548CDYVkgilF/8IZtL3OjjpADIhqRRF9kWMaG1JND2ppIOTGCM2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('205', 'Trần Đức Minh', 'tdminh', NULL, NULL, '1984-08-26', '2004-10-01', NULL, 'tdminh', '2025-09-03 04:47:46', '$2y$10$.2BZIE2XQjbgmiq7Xss79O.nmXnpBGO1Vpaw1VKMWq3D1nHzw80iu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('206', 'Vũ Đình Tùng', 'vdtung', NULL, NULL, '1986-05-21', '2005-10-01', NULL, 'vdtung', '2025-09-03 04:47:46', '$2y$10$KEfQIF/eK2/spmNJ4okW..jFLmWEOHY4NVqj49vMgeH882MB/rp4S', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('207', 'Trần Đình Tùng', 'tdtung', NULL, NULL, '2005-12-30', '2023-12-01', NULL, 'tdtung', '2025-09-03 04:47:46', '$2y$10$6/4t5dG7/oDXTfrslecAGOcpe453m9NEGtffDj8xPrLUnmEe3KCRm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:46', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('208', 'Đào Thị Thu Huyền', 'dtthuyen', NULL, NULL, '1985-07-12', '2012-02-01', NULL, 'dtthuyen', '2025-09-03 04:47:47', '$2y$10$UTj3Qn.5irhoj4NnUzrkD.KjslqddLgz3eee.waGM1ICjMgRw4Zuu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('209', 'Nguyễn Văn Quyết', 'nvquyet', NULL, NULL, '1988-08-27', '2012-02-01', NULL, 'nvquyet', '2025-09-03 04:47:47', '$2y$10$wdXFViXVEaor9YfhhSfcieNJDVfEWUsdurrumCPjfEaw6uKDSp36e', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('210', 'Nguyễn Thị Thu', 'ntthu', NULL, NULL, '1991-09-01', '2024-08-01', NULL, 'ntthu', '2025-09-03 04:47:47', '$2y$10$kcw0tFySyk7C9bbJTioWPOdcppXtlqBEaUFD8/7clQ1e.mx/dlRSe', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('211', 'Trần T Ngọc Anh', 'ttnanh', NULL, NULL, '1979-08-29', '2008-04-01', NULL, 'ttnanh', '2025-09-03 04:47:47', '$2y$10$7YN3MQVIM9RFzy85lIX/1.F8/zhh9SbstAV2KjTBPCzu1ZIIXykXy', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('212', 'Đỗ Văn Hưng', 'dvhung', NULL, NULL, '1984-09-03', '2006-12-01', NULL, 'dvhung', '2025-09-03 04:47:47', '$2y$10$wqVt2P86l7Spr8WbfBcKeOHYHQ2/vu76MWoHTPGILKYic2pBObBqO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('213', 'Nguyễn Thị Tân Miền', 'nttmien', NULL, NULL, '1980-01-06', '1998-02-01', NULL, 'nttmien', '2025-09-03 04:47:47', '$2y$10$9cO4I61so9fkohG4mvCh6uQsM0GwDYgHaHew3GpLC6zAHvrR/NmB2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('214', 'Nguyễn Ngọc Khánh', 'nnkhanh', NULL, NULL, '1983-09-04', '2003-02-01', NULL, 'nnkhanh', '2025-09-03 04:47:47', '$2y$10$yKV9.2rW47FJUBX6oplMv.XlUdz1Sp8BezeRh/2L.saPPHS1Usp62', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('215', 'Nguyễn Dự Đáng', 'nddang', NULL, NULL, '1986-09-24', '2008-03-01', NULL, 'nddang', '2025-09-03 04:47:47', '$2y$10$aItX1wHBB6er5tnzMCJXAeGR7AWRXnqb9sysh3BN4YW1eFlI.HR9u', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('216', 'Lê Văn Hội', 'lvhoi', NULL, NULL, '1992-03-21', '2016-09-01', NULL, 'lvhoi', '2025-09-03 04:47:47', '$2y$10$ud2VBOfKOvOUrOFG2ZLD0.EE8cPkT/ZwyGYDQAP0GDXyQ4VJSbXk6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('217', 'Nguyễn Kim Biển', 'nkbien', NULL, NULL, '1984-01-29', '2003-02-01', NULL, 'nkbien', '2025-09-03 04:47:47', '$2y$10$gypLtCMHrfrEPIQbV4WqKe/SLOdxbZXTLA6aYlb.wYwJzkKicHlDm', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('218', 'Trần Mạnh Kiều', 'tmkieu', NULL, NULL, '1982-02-03', '2001-02-01', NULL, 'tmkieu', '2025-09-03 04:47:47', '$2y$10$JbHaJEky3VBFlffxQ0nJguEArDFa4FNgBO43Q6qOLqeB9dBDdQjru', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('219', 'Dương Bá Quyền', 'dbquyen', NULL, NULL, '1990-12-12', '2012-02-01', NULL, 'dbquyen', '2025-09-03 04:47:47', '$2y$10$Ppw6L2yoB4mvaxjGkD5pAOiRPlrJ.sGr9M3XvmCMnULNa5ZJU658.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('220', 'Nguyễn Thị Tươi', 'nttuoi', NULL, NULL, '1988-07-21', '2013-03-01', NULL, 'nttuoi', '2025-09-03 04:47:47', '$2y$10$bDyeSHfjJadhROHHyYD5d.6hYgqXSWrl5BHDYoVKywIKfeVhhO11.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('221', 'Bùi T Khánh Thuỳ', 'btkthuy', NULL, NULL, '1990-12-28', '2014-03-01', NULL, 'btkthuy', '2025-09-03 04:47:47', '$2y$10$XKWrqp4LGQ.zMBy8BfPLLOscrZ8ByC6VLfeTX5v05xSWod9lH2d7y', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('222', 'Hà Chí Quang', 'hcquang', NULL, NULL, '1973-07-20', '1993-02-01', NULL, 'hcquang', '2025-09-03 04:47:47', '$2y$10$QDXc.h27vH.QibwnieIB8OxSuZV86ei4BeMIbhqRADZYbkBjfXkwu', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('223', 'Võ Văn Tới', 'vvtoi', NULL, NULL, '1985-11-09', '2007-03-01', NULL, 'vvtoi', '2025-09-03 04:47:47', '$2y$10$BR7zMVDrwUPguF3TbOZc4.9XBYn2G..kFXhWBdf76YGw4jzFYn.HC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:47', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('224', 'Nguyễn Quang Hùng', 'nqhung', NULL, NULL, '1998-08-16', '2024-08-01', NULL, 'nqhung', '2025-09-03 04:47:48', '$2y$10$kZnpGdu4wgd4AVEBH/PgOu4qJKonOMsj6WoEKxxAcRugxzL9a7Ld6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('225', 'Nguyễn Quyết Tiến', 'nqtien', NULL, NULL, '1994-06-09', '2016-09-01', NULL, 'nqtien', '2025-09-03 04:47:48', '$2y$10$85YJ6lGhRBk4v/TnQZdZaOPRUHY2m9gMA373PfZoOoT.uGzr3hTPC', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('226', 'Tạ Hồng Đăng', 'thdang', NULL, NULL, '1985-05-07', '2003-09-01', NULL, 'thdang', '2025-09-03 04:47:48', '$2y$10$h9rzzgXhDpS9jD7k5QwJmOijgPY8MiQFWxAVc9g6xV5ekTaaAMDrS', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('227', 'Nguyễn Thị Hoàn', 'nthoan', NULL, NULL, '1983-04-26', '2012-02-01', NULL, 'nthoan', '2025-09-03 04:47:48', '$2y$10$QsN.hfM8Z4TjpAmwNzTT2OlYuXehEs8rZVYRW0.1n899wAlZkRzXO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('228', 'Nguyễn Sơn Đông', 'nsdong', NULL, NULL, '1980-10-13', '2000-02-01', NULL, 'nsdong', '2025-09-03 04:47:48', '$2y$10$iKYYPT1Wc6nDZwfAetTJSOVCbl62a4ZKub.gaRuyEVNa59p178TM2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('229', 'Nguyễn Hải Tiến', 'nhtien', NULL, NULL, '1984-05-10', '2004-02-01', NULL, 'nhtien', '2025-09-03 04:47:48', '$2y$10$ATfJV8NHQJFlkD1Was9KN.7urBUMi.Ix1ahby8hC1KIyhqbhw4/yO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('230', 'Trần Việt Trung', 'tvtrung', NULL, NULL, '1990-12-28', '2022-12-01', NULL, 'tvtrung', '2025-09-03 04:47:48', '$2y$10$GFBAzI1.RECxy.tMZ8XfjOlXSatLIJsSDfKjSQrbToVK0LFOD0bha', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('231', 'Trần Thị Việt Hồng', 'ttvhong', NULL, NULL, '1982-08-08', '2003-12-01', NULL, 'ttvhong', '2025-09-03 04:47:48', '$2y$10$KkG2sOGy43xuA79pzW5ZIeoV5olAj3fYQA0kZS7cfNMSPbnNcusY2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('232', 'Vũ Ngọc Quỳnh', 'vnquynh', NULL, NULL, '1983-10-07', '2002-10-01', NULL, 'vnquynh', '2025-09-03 04:47:48', '$2y$10$BN4UdOvJCw/.eJ.g4Dmb1OhPZe15pDMFEWEA5zPQYk8Lg92ZS3Sr2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('233', 'Thái Thị Âu', 'ttau', NULL, NULL, '1987-05-29', '2012-02-01', NULL, 'ttau', '2025-09-03 04:47:48', '$2y$10$xAgdDbrWXQv4DtC4Gse/XuL6wXP2JU47pfIlzbxaPhJf/C6Hu9LJ2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('234', 'Nguyễn Thuỳ Linh', 'ntlinh', NULL, NULL, '1984-10-20', '2012-02-01', NULL, 'ntlinh', '2025-09-03 04:47:48', '$2y$10$EQ5zZIMbL/23zQWG9WyMIO4RUknLwC4VqzZ8yI.b96fc/.w9lhJ.K', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('235', 'Nguyễn Thị Mai', 'ntmai', NULL, NULL, '1994-07-18', '2022-12-01', NULL, 'ntmai', '2025-09-03 04:47:48', '$2y$10$WNsY/vu0zJxF9ryQeGK61uA0gUfLqpwmHCGStDYeW/Q8jcJYX7bF.', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('236', 'Hoàng Văn Thành', 'hvthanh', NULL, NULL, '1983-06-08', '2001-09-01', NULL, 'hvthanh', '2025-09-03 04:47:48', '$2y$10$uzNgidv7voNfnqgmwP2NBOhN2LPtfFeLXNHIYvhJ5d8zo/TwdxBbG', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('237', 'Vũ Thị Liên', 'vtlien', NULL, NULL, '1982-12-15', '2005-04-01', NULL, 'vtlien', '2025-09-03 04:47:48', '$2y$10$FD3Y2SHGu/5W9exlEDOSmugglssIHZ.lFf0Pnk5dY.y1Qub1MAF9i', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('238', 'Khuất Duy Mạnh', 'kdmanh', NULL, NULL, '1982-08-30', '2003-02-01', NULL, 'kdmanh', '2025-09-03 04:47:48', '$2y$10$H.Fnx3ZJUMZi2fA1KrV3uevTALA25HQ3GlHk0s/H2uxEN5uzUZcz2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('239', 'Nguyễn Thị Duyên', 'ntduyen', NULL, NULL, '1992-02-16', '2023-12-01', NULL, 'ntduyen', '2025-09-03 04:47:48', '$2y$10$hHSWfd7uHL7kurWgmVe5kOiBVLTeyVzZyA.rmlEMBmEich.XBkZuO', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:48', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('240', 'Nông Thị Thuý', 'ntthuy872', NULL, NULL, NULL, NULL, NULL, 'ntthuy_1', '2025-09-03 04:47:49', '$2y$10$IJA9y3AY5JOQLkjhO3g4KuxMwckkiPphGPTnBQWTu3w7Z5KzWV3Ke', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:48:35', NULL);
INSERT INTO `users` VALUES ('241', 'Đinh Thị Thành', 'dtthanh', NULL, NULL, '1988-01-15', '2015-03-01', NULL, 'dtthanh', '2025-09-03 04:47:49', '$2y$10$z5gK22abk0kb1YSa63Uhx.E50HGYankHBs9oTH1C8HBnERKRLcN0W', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('242', 'Lương T Thanh Loan', 'lttloan', NULL, NULL, '1986-11-13', '2024-08-01', NULL, 'lttloan', '2025-09-03 04:47:49', '$2y$10$s/jd/ASdAmZkjHtrzVgG7u7dipB5dPrZOQqUIocZTYVEN95rdxA8q', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('243', 'Phan Thanh Trường', 'pttruong', NULL, NULL, '1975-08-18', '1997-01-01', NULL, 'pttruong', '2025-09-03 04:47:49', '$2y$10$QbFgprWtLwgNC8ISVLft/.eCHE8T5iUXGK541yrvNQEBK.fflhWBa', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('244', 'Mai Hồng Sơn', 'mhson', NULL, NULL, '1971-01-02', '1992-02-01', NULL, 'mhson', '2025-09-03 04:47:49', '$2y$10$HWdBdn8pCzZeUPfNMymPo.mgH7Boiocv7D3nTSeVhNVGuJMK5erOq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('245', 'Nguyễn Thái Bình', 'ntbinh81', NULL, NULL, '1981-03-11', '2000-02-01', NULL, 'ntbinh', '2025-09-03 04:47:49', '$2y$10$8BGSIPHUNCPf1NtrsKL4heuohx9IYw9aCAlbcVxeHBtKr3/CLLgji', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('246', 'Nguyễn Thanh Bình', 'ntbinh72', NULL, NULL, NULL, NULL, NULL, 'ntbinh_1', '2025-09-03 04:47:49', '$2y$10$qArN4tgRNEi07GfMtYd3rucgvlgrjcnDq.GA0S2i1zJm8NYa90fn6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:48:07', NULL);
INSERT INTO `users` VALUES ('247', 'Trần Ngọc Quang', 'tnquang', NULL, NULL, '1983-09-09', '2002-03-01', NULL, 'tnquang', '2025-09-03 04:47:49', '$2y$10$AdDZYNFfh218ud79e1I04u66mhZoLmPlZgwBXDteuBBTaL54CQjK6', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('248', 'Phạm Trường Giang', 'ptgiang', NULL, NULL, '1976-03-08', '1994-10-01', NULL, 'ptgiang', '2025-09-03 04:47:49', '$2y$10$KDh.fVfWMTjF/BkH7EZuZeRq1QAUk2oTKW8.qXrFmtO.ClP6OyBsq', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('249', 'Nguyễn Thị Thảo', 'ntthao', NULL, NULL, '1975-10-17', '1993-02-01', NULL, 'ntthao', '2025-09-03 04:47:49', '$2y$10$Zqeo0nfHrB5SBOm7GsyrBejiPJNv14St9wnkFd3/8EixjnS9F7Pi2', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('250', 'Bùi Văn Khởi', 'bvkhoi', NULL, NULL, '1965-08-13', '1999-03-01', NULL, 'bvkhoi', '2025-09-03 04:47:49', '$2y$10$tNiDfryw3q45ZcrqXKU8CelyAIoDcXgJnH7qhq.007b.lnmgTLafW', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('251', 'Cao Văn Tuyển', 'cvtuyen', NULL, NULL, '1985-04-24', '2003-10-01', NULL, 'cvtuyen', '2025-09-03 04:47:49', '$2y$10$3xquq0bxFUuFlQLa6AADB.a0rqMv0GPGp5wT9DGUlF13yxrghiT.y', NULL, NULL, NULL, NULL, NULL, 'System', 'System', NULL, '2025-09-03 04:47:49', '2025-09-05 01:46:49', NULL);
INSERT INTO `users` VALUES ('252', 'Administrator', 'admin', NULL, NULL, NULL, NULL, NULL, 'admin', '2025-09-03 04:50:10', '$2y$10$nKKm3GZ4UqJDflksE78uTOUUeMpCYaKovPgAjEyJ6AjYnBTiXaquu', NULL, NULL, 'KhpmaPvg9DWIrK3VogI1WdwkeP5AFfENiOH7vWoAWJi2fcxyJXVbWaquFHil', NULL, NULL, 'System', 'System', 'System', '2025-09-03 04:50:11', '2025-09-05 07:50:02', '2025-09-05 07:50:02');
INSERT INTO `users` VALUES ('253', 'Administrator A31', 'admin2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '$2y$10$1fji9prQloUtslkYkLRU4OakRlY2ydhft03IL8OuGuUI5HV0cfg4i', NULL, NULL, 'J2I0AV1nHrlD3SOkratb9tRRreBXDv8dyeHgtwHMKcthAtARn86GL8lBjGib', 'profile-photos/.default-photo.jpg', NULL, 'System', 'Administrator A31', NULL, '2025-09-05 07:50:02', '2025-09-05 01:48:35', NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
INSERT INTO `vehicles` VALUES ('28', 'Xe nâng TCM-4,0 - FD40T9', 'Xe nâng hàng', 'XN-001', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:53:03', '2025-09-05 02:53:03', NULL);
INSERT INTO `vehicles` VALUES ('29', 'Xe nâng TOYOTAF8F050N', 'Xe nâng hàng', 'XN-002', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:53:03', '2025-09-05 02:53:03', NULL);
INSERT INTO `vehicles` VALUES ('30', 'Xe nâng FB10-MQC2', 'Xe nâng hàng', 'XN-003', NULL, NULL, NULL, NULL, NULL, NULL, 'available', NULL, '1', 'System', 'System', NULL, '2025-09-05 02:53:03', '2025-09-05 02:53:03', NULL);

-- Structure for table `webhook_calls`
DROP TABLE IF EXISTS `webhook_calls`;
CREATE TABLE `webhook_calls` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `headers` json DEFAULT NULL,
  `payload` json DEFAULT NULL,
  `exception` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
