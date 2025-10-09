<%-- 
    Document   : ResetPassword
    Created on : Oct 6, 2025, 9:05:53 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đổi Mật Khẩu - Cát Bà Booking</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Authentication/style-ath.css">
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>Đổi Mật Khẩu</h2>
                <p>Nhập mật khẩu mới</p>
            </div>
            <% if (request.getAttribute("error") != null) { %>
                <p style="color: red;"><%= request.getAttribute("error") %></p>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <p style="color: green;"><%= request.getAttribute("success") %></p>
            <% } %>
            <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                <input type="hidden" name="action" value="reset-password">
                <input type="hidden" name="email" value="<%= request.getAttribute("email") %>">
                <div class="form-group">
                    <label for="password">Mật Khẩu Mới</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu mới" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="confirm-password">Xác Nhận Mật Khẩu</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="confirm-password" name="confirm-password" placeholder="Xác nhận mật khẩu" required>
                    </div>
                </div>
                <button type="submit" class="submit-btn">Đổi Mật Khẩu</button>
            </form>
            <div class="link">
                Quay lại <a href="${pageContext.request.contextPath}/Login">Đăng Nhập</a>
            </div>
        </div>
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    </body>
</html>