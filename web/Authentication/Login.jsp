<%-- 
    Document   : Login
    Created on : Oct 6, 2025, 9:03:39 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập - Cát Bà Booking</title>
        <link rel="stylesheet" href="style-ath.css">
    </head>
    <body>
        <div class="container">
             <div class="header">
                <h2>Đăng Nhập</h2>
                <p>Truy cập tài khoản để đặt homestay và nhà hàng</p>
            </div>
            
            <form action="#" method="post">
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
                <button type="submit" class="submit-btn">Đăng Nhập</button>
                <div class="forgot-password">
                    <a href="ForgotPassword.jsp">Quên mật khẩu?</a>
                </div>
            </form>
            <div class="register-section">
                <p>Chưa có tài khoản? Đăng ký theo loại tài khoản:</p>
                <div class="register-buttons">
                    <a href="RegisterCustomer.jsp" class="register-btn">Đăng ký tài khoản Khách Hàng</a>
                    <a href="RegisterOwner.jsp" class="register-btn">Đăng ký tài khoản Chủ Homestay/Nhà Hàng</a>
                </div>
             </div>
        </div>
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    </body>
</html>
