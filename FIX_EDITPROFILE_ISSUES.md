# 🔧 Khắc phục lỗi EditProfile sau khi di chuyển file

## 🚨 **Vấn đề thường gặp khi di chuyển JSP:**

### 1. **Cache không đồng bộ**
- IDE cache file cũ
- Build directory không được cập nhật
- Tomcat cache servlet cũ

### 2. **Path mapping bị lỗi**
- Servlet mapping không đúng
- JSP path không tìm thấy
- Class path bị thay đổi

## ✅ **Giải pháp từng bước:**

### **Bước 1: Clean Project**
```bash
# Trong IDE (NetBeans/Eclipse):
1. Right-click project → Clean and Build
2. Hoặc Build → Clean and Build Project
```

### **Bước 2: Xóa cache thủ công**
```bash
# Xóa thư mục build
rmdir /s /q build
rmdir /s /q dist

# Tạo lại thư mục
mkdir build
mkdir build\web
mkdir build\web\WEB-INF
mkdir build\web\WEB-INF\classes
```

### **Bước 3: Copy file đúng cách**
```bash
# Copy toàn bộ web content
xcopy /E /I web build\web

# Copy compiled classes
xcopy /E /I "src\java\**\*.class" "build\web\WEB-INF\classes\"
```

### **Bước 4: Kiểm tra web.xml**
Đảm bảo file `build/web/WEB-INF/web.xml` có nội dung:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="6.0" xmlns="https://jakarta.ee/xml/ns/jakartaee">
    <servlet>
        <servlet-name>EditProfileController</servlet-name>
        <servlet-class>controller.auth.EditProfileController</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>EditProfileController</servlet-name>
        <url-pattern>/edit-profile</url-pattern>
    </servlet-mapping>
</web-app>
```

### **Bước 5: Restart Server**
1. **Stop Tomcat server**
2. **Start lại Tomcat server**
3. **Deploy lại project**

## 🚀 **Script tự động (Windows):**

Chạy file `fix-editprofile.bat` để tự động sửa:

```bash
# Trong thư mục project
fix-editprofile.bat
```

## 🔍 **Kiểm tra sau khi sửa:**

### **1. Kiểm tra file tồn tại:**
- ✅ `build/web/EditProfile.jsp`
- ✅ `build/web/WEB-INF/classes/controller/auth/EditProfileController.class`
- ✅ `build/web/WEB-INF/web.xml`

### **2. Test URLs:**
- ✅ `http://localhost:8080/CatBaBooking/edit-profile`

### **3. Kiểm tra logs:**
- Tomcat logs: `logs/catalina.out`
- Application logs: `logs/localhost.log`

## 🐛 **Lỗi thường gặp và cách sửa:**

### **Lỗi 404:**
```
HTTP Status 404 – Not Found
```
**Nguyên nhân:** Servlet không được tìm thấy
**Giải pháp:** Kiểm tra web.xml và class path

### **Lỗi 500:**
```
HTTP Status 500 – Internal Server Error
```
**Nguyên nhân:** ClassNotFoundException
**Giải pháp:** Rebuild project và restart server

### **Lỗi JSP không load:**
```
JSP file not found
```
**Nguyên nhân:** JSP path không đúng
**Giải pháp:** Kiểm tra file có trong build/web/

## 📝 **Checklist hoàn thành:**

- [ ] Clean project trong IDE
- [ ] Xóa thư mục build cũ
- [ ] Rebuild project
- [ ] Copy file JSP vào build/web/
- [ ] Copy servlet class vào build/web/WEB-INF/classes/
- [ ] Cập nhật web.xml
- [ ] Restart Tomcat server
- [ ] Test URL /edit-profile
- [ ] Kiểm tra logs nếu vẫn lỗi

## 🎯 **Kết quả mong đợi:**

Sau khi sửa, bạn sẽ thấy:
- ✅ Trang EditProfile load thành công
- ✅ Form hiển thị đầy đủ các trường
- ✅ Nút "Quay lại trang chủ" hoạt động
- ✅ Form validation hoạt động
- ✅ Có thể submit form thành công

---

**Nếu vẫn lỗi, hãy:**
1. Kiểm tra Tomcat server đang chạy
2. Kiểm tra project đã được deploy
3. Kiểm tra URL đúng format
4. Xem logs để tìm lỗi cụ thể
