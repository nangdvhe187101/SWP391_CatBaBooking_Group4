<%-- 
    Document   : ForgotPassword
    Created on : Oct 6, 2025, 9:05:03 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên Mật Khẩu - Cát Bà Booking</title>
        <link rel="stylesheet" href="style-ath.css">
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>Quên Mật Khẩu</h2>
                <p>Nhập email đăng ký để nhận mã OTP</p>
            </div>

            <form action="#" method="post">
                <input type="hidden" name="action" value="send-otp">
                <div class="form-group">
                    <label for="email">Email</label>
                    <div class="input-wrapper">
                        <i class="fas fa-envelope"></i>
                        <input type="email" id="email" name="email" placeholder="Nhập email của bạn" required>
                    </div>
                </div>
                <button type="submit" class="submit-btn">Gửi Mã OTP</button>
            </form>
            <div class="link">
                Quay lại <a href="${pageContext.request.contextPath}/Login">Đăng Nhập</a>
             </div>
        </div>
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    </body>
</html>
