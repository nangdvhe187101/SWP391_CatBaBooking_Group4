<%-- 
    Document   : VerifyOTP
    Created on : Oct 6, 2025, 9:05:40 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác Thực OTP - Cát Bà Booking</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Authentication/style-ath.css">
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>Xác Thực OTP</h2>
                <p>Nhập mã OTP đã gửi đến email của bạn</p>
            </div>
            <% if (request.getAttribute("error") != null) { %>
                <p style="color: red;"><%= request.getAttribute("error") %></p>
            <% } %>
            <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                <input type="hidden" name="action" value="verify-otp">
                <input type="hidden" name="email" value="<%= request.getAttribute("email") %>">
                <div class="form-group">
                    <label for="otp">Mã OTP</label>
                    <div class="input-wrapper">
                        <i class="fas fa-key"></i>
                        <input type="text" id="otp" name="otp" placeholder="Nhập mã OTP (6 chữ số)" required maxlength="6">
                    </div>
                </div>
                <button type="submit" class="submit-btn">Xác Thực</button>
            </form>
            <div class="link">
                Quay lại <a href="${pageContext.request.contextPath}/forgot-password">Gửi lại OTP</a>
            </div>
        </div>
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    </body>
</html>