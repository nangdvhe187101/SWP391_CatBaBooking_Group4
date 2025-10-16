-- Script để thêm các cột mới vào bảng users cho tính năng edit profile
-- Chạy script này để cập nhật database

-- Thêm các cột mới vào bảng users
ALTER TABLE users 
ADD COLUMN gender VARCHAR(10) NULL,
ADD COLUMN birth_day INT NULL,
ADD COLUMN birth_month INT NULL,
ADD COLUMN birth_year INT NULL,
ADD COLUMN city VARCHAR(100) NULL;

-- Thêm comment cho các cột mới
ALTER TABLE users 
MODIFY COLUMN gender VARCHAR(10) COMMENT 'Giới tính: Male, Female, Other',
MODIFY COLUMN birth_day INT COMMENT 'Ngày sinh (1-31)',
MODIFY COLUMN birth_month INT COMMENT 'Tháng sinh (1-12)',
MODIFY COLUMN birth_year INT COMMENT 'Năm sinh',
MODIFY COLUMN city VARCHAR(100) COMMENT 'Thành phố cư trú';

-- Tạo index cho các cột mới để tối ưu performance
CREATE INDEX idx_users_gender ON users(gender);
CREATE INDEX idx_users_birth_year ON users(birth_year);
CREATE INDEX idx_users_city ON users(city);
