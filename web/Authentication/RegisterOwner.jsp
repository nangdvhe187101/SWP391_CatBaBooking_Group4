<%-- 
    Document   : RegisterOwner
    Created on : Oct 6, 2025, 9:04:41 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Ký Chủ Homestay/Nhà Hàng - Cát Bà Booking</title>
        <link rel="stylesheet" href="style-ath.css">
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>Đăng Ký Tài Khoản Chủ Homestay/Nhà Hàng</h2>
                <p>Cung cấp thông tin để đăng ký và quản lý cơ sở của bạn</p>
            </div>

            <form action="#" method="post">
                <div class="form-section">
                    <h3>Thông Tin Cá Nhân</h3>
                    <div class="form-group">
                        <label for="full-name">Họ và Tên</label>
                        <div class="input-wrapper">
                            <i class="fas fa-user"></i>
                            <input type="text" id="full-name" name="full-name" placeholder="Nhập họ và tên" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="citizen-id">Căn Cước Công Dân</label>
                        <div class="input-wrapper">
                            <i class="fas fa-id-card"></i>
                            <input type="text" id="citizen-id" name="citizen-id" placeholder="Nhập số căn cước công dân" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <div class="input-wrapper">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" placeholder="Nhập email" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="phone">Số Điện Thoại</label>
                        <div class="input-wrapper">
                            <i class="fas fa-phone"></i>
                            <input type="tel" id="phone" name="phone" placeholder="Nhập số điện thoại" required>
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
                </div>
                <div class="form-section">
                    <h3>Thông Tin Địa Chỉ Cá Nhân</h3>
                    <div class="form-group">
                        <label for="personal-address">Địa Chỉ</label>
                        <div class="input-wrapper">
                            <i class="fas fa-map-marker-alt"></i>
                            <input type="text" id="personal-address" name="personal-address" placeholder="Nhập địa chỉ cá nhân" required>
                        </div>
                    </div>
                </div>
                <div class="form-section">
                    <h3>Thông Tin Homestay/Nhà Hàng</h3>
                    <div class="form-group">
                        <label for="business-name">Tên Homestay/Nhà Hàng</label>
                        <div class="input-wrapper">
                            <i class="fas fa-building"></i>
                            <input type="text" id="business-name" name="business-name" placeholder="Nhập tên cơ sở" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="business-type">Loại Cơ Sở</label>
                        <div class="input-wrapper">
                            <i class="fas fa-tag"></i>
                            <select id="business-type" name="business-type" required>
                                <option value="">Chọn loại</option>
                                <option value="homestay">Homestay</option>
                                <option value="restaurant">Nhà Hàng</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="business-address">Địa Chỉ Cơ Sở</label>
                        <div class="input-wrapper">
                            <i class="fas fa-map-marker-alt"></i>
                            <input type="text" id="business-address" name="business-address" placeholder="Nhập địa chỉ cơ sở" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="description">Mô Tả</label>
                        <div class="input-wrapper">
                            <i class="fas fa-info-circle"></i>
                            <textarea id="description" name="description" placeholder="Mô tả về homestay/nhà hàng của bạn" required></textarea>
                        </div>
                    </div>
                </div>
                <button type="submit" class="submit-btn">Đăng Ký</button>
            </form>
            <div class="link">
                Đã có tài khoản? <a href="Login.jsp">Đăng nhập ngay</a>
            </div>
        </div>
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    </body>
</html>
