# 🔧 Troubleshooting Edit Profile - Lỗi 404

## 🚨 Vấn đề: HTTP Status 404 – Not Found cho `/edit-profile`

### ✅ **Giải pháp 1: Kiểm tra Servlet Mapping**

1. **Kiểm tra file `web/WEB-INF/web.xml`:**
```xml
<servlet>
    <servlet-name>EditProfileController</servlet-name>
    <servlet-class>controller.auth.EditProfileController</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>EditProfileController</servlet-name>
    <url-pattern>/edit-profile</url-pattern>
</servlet-mapping>
```

2. **Kiểm tra file `src/java/Controller/auth/EditProfileController.java` có tồn tại**

### ✅ **Giải pháp 2: Build lại Project**

1. **Trong NetBeans/Eclipse:**
   - Right-click project → Clean and Build
   - Hoặc Build → Clean and Build Project

2. **Manual build:**
   - Xóa thư mục `build/`
   - Build lại project

### ✅ **Giải pháp 3: Restart Server**

1. **Stop Tomcat server**
2. **Start lại Tomcat server**
3. **Deploy lại project**

### ✅ **Giải pháp 4: Test trực tiếp**

1. **Truy cập:** `http://localhost:8080/CatBaBooking/edit-profile`
2. **Kiểm tra trang EditProfile có load không**

### ✅ **Giải pháp 5: Kiểm tra URL**

Thử URL sau:
- `http://localhost:8080/CatBaBooking/edit-profile`

### 🔍 **Debug Steps:**

1. **Kiểm tra servlet có được compile:**
   - File: `build/web/WEB-INF/classes/controller/auth/EditProfileController.class`

2. **Kiểm tra JSP có được copy:**
   - File: `build/web/EditProfile.jsp`

3. **Kiểm tra web.xml:**
   - File: `build/web/WEB-INF/web.xml`

### 🚀 **Quick Fix:**

Nếu vẫn lỗi 404, thử:

1. **Tạo servlet đơn giản:**
```java
@WebServlet("/test-edit")
public class TestEditServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.getWriter().println("Test servlet works!");
    }
}
```

2. **Truy cập:** `http://localhost:8080/CatBaBooking/test-edit`

### 📝 **Logs để kiểm tra:**

- Tomcat logs: `logs/catalina.out`
- Application logs: `logs/localhost.log`

### 🎯 **Expected Result:**

Khi servlet hoạt động, bạn sẽ thấy:
```
EditProfileController is working!
Request URI: /CatBaBooking/edit-profile
Context Path: /CatBaBooking
Servlet Path: /edit-profile
```

---

**Nếu vẫn lỗi, hãy:**
1. Kiểm tra Tomcat server đang chạy
2. Kiểm tra project đã được deploy
3. Kiểm tra URL đúng format
