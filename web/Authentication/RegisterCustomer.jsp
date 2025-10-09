<%-- 
    Document   : RegisterCustomer
    Created on : Oct 6, 2025, 9:04:16 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Ký - Cát Bà Booking</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Authentication/style-ath.css">
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>Đăng Ký</h2>
                <p>Tạo tài khoản để nhận ưu đãi đặc biệt</p>
            </div>
            <% if (request.getAttribute("error") != null) { %>
                <p style="color: red;"><%= request.getAttribute("error") %></p>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <p style="color: green;"><%= request.getAttribute("success") %></p>
            <% } %>
            <form action="${pageContext.request.contextPath}/register-customer" method="post">
                <div class="form-group">
                    <label for="name">Họ và Tên</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user"></i>
                        <input type="text" id="name" name="name" placeholder="Nhập họ và tên" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <div class="input-wrapper">
                        <i class="fas fa-envelope"></i>
                        <input type="email" id="email" name="email" placeholder="Nhập email của bạn" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="password">Mật Khẩu</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="confirm-password">Xác Nhận Mật Khẩu</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="confirm-password" name="confirm-password" placeholder="Xác nhận mật khẩu" required>
                    </div>
                </div>
                <button type="submit" class="submit-btn">Đăng Ký</button>
            </form>
            <div class="link">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/Login">Đăng Nhập</a>
            </div>
        </div>
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    </body>
</html>