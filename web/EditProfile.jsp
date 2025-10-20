<%-- 
    Document   : EditProfile
    Created on : Dec 20, 2024, 10:00:00 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cài đặt - Cát Bà Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #f5f5f5;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
            position: relative;
        }

        .header-actions {
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            background: #f8f9fa;
            color: #6c757d;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            border: 1px solid #dee2e6;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            background: #e9ecef;
            color: #495057;
            text-decoration: none;
        }

        .btn-back i {
            font-size: 12px;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }

        .tabs {
            display: flex;
            background: white;
            border-radius: 8px;
            padding: 4px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .tab {
            flex: 1;
            padding: 12px 20px;
            text-align: center;
            cursor: pointer;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-weight: 500;
            color: #666;
        }

        .tab.active {
            background: #007bff;
            color: white;
        }

        .content {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-row .form-group {
            flex: 1;
            margin-bottom: 0;
        }

        .form-label {
            display: block;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #007bff;
        }

        .form-select {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            background: white;
            cursor: pointer;
        }

        .form-select:focus {
            outline: none;
            border-color: #007bff;
        }

        .date-group {
            display: flex;
            gap: 10px;
        }

        .date-group .form-select {
            flex: 1;
        }

        .form-description {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }

        .button-group {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            min-width: 100px;
        }

        .btn-cancel {
            background: #f8f9fa;
            color: #6c757d;
            border: 1px solid #dee2e6;
        }

        .btn-cancel:hover {
            background: #e9ecef;
        }

        .btn-save {
            background: #007bff;
            color: white;
        }

        .btn-save:hover {
            background: #0056b3;
        }

        .btn-back-home {
            background: #28a745;
            color: white;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-back-home:hover {
            background: #218838;
            color: white;
            text-decoration: none;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @media (max-width: 768px) {
            .header-actions {
                position: static;
                transform: none;
                margin-bottom: 15px;
            }

            .btn-back {
                font-size: 13px;
                padding: 8px 12px;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .date-group {
                flex-direction: column;
            }
            
            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/HomePage/Home.jsp" class="btn-back">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại trang chủ
                </a>
            </div>
            <h1>Cài đặt</h1>
        </div>

        <div class="tabs">
            <div class="tab active" onclick="showTab('account')">
                Thông tin tài khoản
            </div>
            <div class="tab" onclick="showTab('security')">
                Mật khẩu & Bảo mật
            </div>
        </div>

        <div class="content">
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/edit-profile" method="post" id="accountForm">
                <div id="accountTab" class="tab-content">
                    <div class="section-title">Dữ liệu cá nhân</div>
                    
                    <div class="form-group">
                        <label for="fullName" class="form-label">Tên đầy đủ</label>
                        <input type="text" id="fullName" name="fullName" class="form-input" 
                               value="${user.fullName}" required>
                        <div class="form-description">
                            Tên trong hồ sơ được rút ngắn từ họ tên của bạn.
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="gender" class="form-label">Giới tính</label>
                            <select id="gender" name="gender" class="form-select">
                                <option value="">Chọn giới tính</option>
                                <option value="Male">Nam</option>
                                <option value="Female">Nữ</option>
                                <option value="Other">Khác</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Ngày sinh</label>
                            <div class="date-group">
                                <select name="birthDay" class="form-select">
                                    <option value="">Ngày</option>
                                    <c:forEach var="day" begin="1" end="31">
                                        <option value="${day}">${day}</option>
                                    </c:forEach>
                                </select>
                                <select name="birthMonth" class="form-select">
                                    <option value="">Tháng</option>
                                    <option value="1">Tháng Một</option>
                                    <option value="2">Tháng Hai</option>
                                    <option value="3">Tháng Ba</option>
                                    <option value="4">Tháng Tư</option>
                                    <option value="5">Tháng Năm</option>
                                    <option value="6">Tháng Sáu</option>
                                    <option value="7">Tháng Bảy</option>
                                    <option value="8">Tháng Tám</option>
                                    <option value="9">Tháng Chín</option>
                                    <option value="10">Tháng Mười</option>
                                    <option value="11">Tháng Mười Một</option>
                                    <option value="12">Tháng Mười Hai</option>
                                </select>
                                <select name="birthYear" class="form-select">
                                    <option value="">Năm</option>
                                    <c:forEach var="year" begin="1950" end="2010">
                                        <option value="${year}">${year}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="city" class="form-label">Thành phố cư trú</label>
                        <input type="text" id="city" name="city" class="form-input" 
                               placeholder="Thành phố cư trú">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="tel" id="phone" name="phone" class="form-input" 
                                   value="${user.phone}" placeholder="Nhập số điện thoại">
                        </div>

                        <div class="form-group">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" id="email" name="email" class="form-input" 
                                   value="${user.email}" placeholder="Nhập email" required>
                        </div>
                    </div>

                    <div class="button-group">
                        <a href="${pageContext.request.contextPath}/HomePage/Home.jsp" class="btn btn-back-home">
                            <i class="fas fa-home"></i>
                            Về trang chủ
                        </a>
                        <button type="button" class="btn btn-cancel" onclick="window.history.back()">
                            Hủy
                        </button>
                        <button type="submit" class="btn btn-save">
                            Lưu
                        </button>
                    </div>
                </div>
            </form>

            <div id="securityTab" class="tab-content" style="display: none;">
                <div class="section-title">Thay đổi mật khẩu</div>
                <p class="form-description">
                    Để bảo mật tài khoản, hãy sử dụng mật khẩu mạnh và không chia sẻ với ai khác.
                </p>
            </div>
        </div>
    </div>

    <script>
        function showTab(tabName) {
            // Ẩn tất cả tab content
            const tabContents = document.querySelectorAll('.tab-content');
            tabContents.forEach(content => {
                content.style.display = 'none';
            });

            // Bỏ active class khỏi tất cả tab buttons
            const tabs = document.querySelectorAll('.tab');
            tabs.forEach(tab => {
                tab.classList.remove('active');
            });

            // Hiển thị tab được chọn
            if (tabName === 'account') {
                document.getElementById('accountTab').style.display = 'block';
                document.querySelector('.tab[onclick="showTab(\'account\')"]').classList.add('active');
            } else if (tabName === 'security') {
                document.getElementById('securityTab').style.display = 'block';
                document.querySelector('.tab[onclick="showTab(\'security\')"]').classList.add('active');
            }
        }

        // Form validation
        document.getElementById('accountForm').addEventListener('submit', function(e) {
            const fullName = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            
            if (!fullName) {
                e.preventDefault();
                alert('Vui lòng nhập tên đầy đủ');
                return;
            }
            
            if (!email) {
                e.preventDefault();
                alert('Vui lòng nhập email');
                return;
            }
            
            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('Vui lòng nhập email hợp lệ');
                return;
            }
        });
    </script>
</body>
</html>
