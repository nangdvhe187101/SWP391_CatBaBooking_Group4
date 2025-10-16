# Hướng dẫn sử dụng tính năng Edit Profile

## 🚀 Cách chạy tính năng Edit Profile

### Bước 1: Cập nhật Database (Tùy chọn)
Nếu bạn muốn sử dụng đầy đủ tính năng (giới tính, ngày sinh, thành phố), chạy script SQL:
```sql
-- Chạy file database_update.sql trong database của bạn
ALTER TABLE users 
ADD COLUMN gender VARCHAR(10) NULL,
ADD COLUMN birth_day INT NULL,
ADD COLUMN birth_month INT NULL,
ADD COLUMN birth_year INT NULL,
ADD COLUMN city VARCHAR(100) NULL;
```

### Bước 2: Test tính năng cơ bản
Hiện tại tính năng đã hoạt động với các trường cơ bản:
- ✅ Tên đầy đủ
- ✅ Email  
- ✅ Số điện thoại
- ✅ Nút "Hủy" thay vì "Có lẽ để sau"

### Bước 3: Truy cập trang Edit Profile
1. Đăng nhập vào hệ thống
2. Click vào avatar/username ở góc phải
3. Click "Edit Profile" trong dropdown menu
4. Chỉnh sửa thông tin và click "Lưu"

## 🔧 Các file đã được tạo/cập nhật:

### 1. **EditProfileController.java**
- Xử lý GET/POST requests
- Validation dữ liệu
- Cập nhật session

### 2. **EditProfile.jsp** 
- Form chỉnh sửa thông tin
- Giao diện đẹp, responsive
- Validation JavaScript

### 3. **UserDAO.java**
- Method `updateUserProfile()` - cập nhật thông tin
- Method `getUserProfileById()` - lấy thông tin đầy đủ

### 4. **Users.java**
- Thêm các trường: gender, birthDay, birthMonth, birthYear, city
- Getter/setter methods

### 5. **Sidebar.jsp**
- Link "Edit Profile" trỏ đến `/edit-profile`

## 🎯 Tính năng hiện tại:

### ✅ Đã hoạt động:
- Chỉnh sửa tên, email, số điện thoại
- Validation form
- Cập nhật session
- Giao diện đẹp
- Nút "Hủy"

### 🔄 Sẽ hoạt động sau khi chạy database script:
- Chỉnh sửa giới tính
- Chỉnh sửa ngày sinh
- Chỉnh sửa thành phố cư trú

## 🐛 Troubleshooting:

### Lỗi "ClassNotFoundException":
- Đảm bảo file `EditProfileController.java` nằm trong `src/java/Controller/auth/`
- Package phải là `controller.auth` (chữ thường)

### Lỗi database:
- Nếu gặp lỗi với các trường mới, chỉ cần comment các trường đó trong form
- Tính năng cơ bản (tên, email, phone) sẽ hoạt động bình thường

## 📱 Giao diện:
- Responsive design
- Modern UI với gradient background
- Form validation
- Success/Error messages
- Tab navigation (Account/Security)

Tính năng đã sẵn sàng sử dụng! 🎉
