<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cài đặt Hồ sơ</title>
    <style>
        /* Định nghĩa biến CSS cho màu sắc dễ quản lý */
        :root {
            --primary-color: #007bff;       
            --success-color: #1abc9c;       
            --text-color: #333;
            --secondary-text-color: #6c757d;
            --border-color: #dee2e6;
            --bg-light: #f8f9fa;
        }

        /* ------------------- CẤU TRÚC CHUNG ------------------- */
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; 
            background-color: var(--bg-light); 
            margin: 0; 
            padding: 0; 
        }
        .container { 
            max-width: 900px; 
            margin: 30px auto; 
            background: white; 
            border-radius: 10px; 
            box-shadow: 0 8px 25px rgba(0,0,0,0.1); 
        }
        .header-top { 
            padding: 25px 40px 10px; 
            border-bottom: 1px solid var(--border-color); 
        }
        
        /* Thay đổi: Nút Quay lại trang chủ thành dạng Button */
        .btn-back-square {
            display: inline-flex;
            align-items: center;
            padding: 8px 15px;
            background-color: white; 
            border: 1px solid var(--border-color);
            border-radius: 4px;
            color: var(--primary-color);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-bottom: 15px;
        }
        .btn-back-square:hover {
            background-color: #f0f0f0;
        }
        
        .page-title { 
            text-align: center; 
            margin: 0; 
            font-size: 28px; 
            font-weight: 700; 
            color: var(--text-color);
        }

        /* ------------------- THANH TAB ------------------- */
        .tabs-wrapper { 
            display: flex; 
            border-bottom: 2px solid var(--border-color); 
            margin: 0 40px; 
        }
        .tabs { 
            display: flex; 
        }
        .tab-link { 
            padding: 15px 25px; 
            cursor: pointer; 
            border: none; 
            background: none; 
            font-size: 16px; 
            font-weight: 600; 
            color: var(--secondary-text-color);
            transition: color 0.2s, border-bottom 0.2s;
        }
        .tab-link.active { 
            color: var(--primary-color); 
            border-bottom: 3px solid var(--primary-color); 
        }
        
        /* ------------------- NỘI DUNG FORM ------------------- */
        .tab-content { 
            padding: 30px 40px; /* Thêm padding cho nội dung */
        }
        .tab-pane { 
            display: none; 
        }
        .tab-pane.active { 
            display: block; 
        }
        
        .form-section-title { 
            font-size: 20px; 
            font-weight: 600; 
            margin-bottom: 25px; 
            color: var(--text-color);
        }
        .form-group { 
            margin-bottom: 25px; 
        }
        .form-group label { 
            display: block; 
            font-weight: 600; 
            margin-bottom: 8px; 
            font-size: 14px; 
            color: var(--text-color);
        }
        
        .form-control { 
            width: 100%; 
            padding: 10px 12px; 
            border: 1px solid #ccc; 
            border-radius: 6px; 
            box-sizing: border-box; 
            font-size: 16px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25); 
            outline: none;
        }
        .form-control[readonly] { 
            background-color: var(--bg-light); 
            cursor: not-allowed; 
        }
        
        .form-row { 
            display: flex; 
            gap: 30px; 
        }
        .form-column { 
            flex: 1; 
        }
        .dob-group { 
            display: flex; 
            gap: 10px; 
        }

        /* ------------------- NÚT ACTIONS (Sửa đổi: Đẩy nút vào trong) ------------------- */
        .form-actions { 
            padding: 20px 40px; /* Cung cấp padding ngang để đẩy nút vào */
            text-align: right; 
            border-top: 1px solid var(--border-color); 
            /* Xóa margin âm để padding có tác dụng */
        }
        .btn { 
            padding: 10px 20px; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            font-weight: 600; 
            margin-left: 10px; 
            font-size: 15px;
            transition: background-color 0.2s;
        }
        .btn-secondary { 
            background-color: #e9ecef; 
            color: var(--secondary-text-color); 
        }
        .btn-secondary:hover { 
            background-color: #dee2e6; 
        }
        .btn-primary { 
            background-color: var(--success-color); 
            color: white; 
        }
        .btn-primary:hover { 
            background-color: #17a98e; 
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="header-top">
             <a href="HomePage/Home.jsp" class="btn-back-square">← Quay lại trang chủ</a>
             <h2 class="page-title">Cài đặt</h2>
        </div>

        <div class="tabs-wrapper">
            <div class="tabs">
                <button class="tab-link active" onclick="openTab(event, 'personal')">Thông tin tài khoản</button>
                <button class="tab-link" onclick="openTab(event, 'security')">Mật khẩu & Bảo mật</button>
            </div>
        </div>

        <div class="tab-content">
            
            <div id="personal" class="tab-pane active">
                <h3 class="form-section-title">Dữ liệu cá nhân</h3>
                <form action="EditProfileController" method="POST">
                    
                    <div class="form-group">
                        <label for="fullName">Tên đầy đủ</label>
                        <input type="text" id="fullName" name="fullName" value="${user.fullName}" class="form-control">
                        <p style="font-size: 12px; color: #999; margin: 5px 0 0;">Tên trong hồ sơ được rút ngắn từ họ tên của bạn.</p>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-column">
                            <label for="gender">Giới tính</label>
                            <select id="gender" name="gender" class="form-control">
                                <option value="">Chọn giới tính</option>
                                <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                            </select>
                        </div>
                        <div class="form-column">
                            <label>Ngày sinh</label>
                            <div class="dob-group">
                                <select name="birthDay" class="form-control"><option value="">Ngày</option></select>
                                <select name="birthMonth" class="form-control"><option value="">Tháng</option></select>
                                <select name="birthYear" class="form-control"><option value="">Năm</option></select>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="city">Thành phố cư trú</label>
                        <input type="text" id="city" name="city" value="${user.city}" class="form-control" placeholder="Thành phố cư trú">
                    </div>
                    
                    <div class="form-row">
                        <div class="form-column">
                            <label for="phone">Số điện thoại</label>
                            <input type="text" id="phone" name="phone" value="${user.phone}" class="form-control">
                        </div>
                        <div class="form-column">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${user.email}" class="form-control" readonly>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="personalAddress">Địa chỉ</label>
                        <input type="text" id="personalAddress" name="personalAddress" value="${user.personalAddress}" class="form-control">
                    </div>
                    
                </form>
            </div>

            <div id="security" class="tab-pane">
                <h3 class="form-section-title">Đổi mật khẩu</h3>
                <p style="margin-bottom: 25px; font-size: 14px; color: var(--secondary-text-color);">Bạn có thể thay đổi mật khẩu tài khoản của mình bất cứ lúc nào.</p>
                
                <form action="ChangePasswordController" method="POST">
                    
                    <div class="form-group">
                        <label for="currentPasswordSimple">Mật khẩu hiện tại</label>
                        <input type="password" id="currentPasswordSimple" name="currentPassword" required class="form-control">
                    </div>

                    <div class="form-group">
                        <label for="newPasswordSimple">Mật khẩu mới</label>
                        <input type="password" id="newPasswordSimple" name="newPassword" required class="form-control">
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPasswordSimple">Xác nhận mật khẩu mới</label>
                        <input type="password" id="confirmPasswordSimple" name="confirmPassword" required class="form-control">
                    </div>
                </form>
            </div>
        </div>

        <div class="form-actions">
            <button type="button" class="btn btn-secondary">Hủy</button>
            <button type="button" class="btn btn-primary" onclick="submitActiveForm()">Lưu</button> 
        </div>
    </div>
    
    <script>
        // Chức năng chuyển đổi Tab
        function openTab(evt, tabName) {
            var i, tabcontent, tablinks;
            
            tabcontent = document.getElementsByClassName("tab-pane");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].classList.remove("active");
                tabcontent[i].style.display = "none";
            }
            
            tablinks = document.getElementsByClassName("tab-link");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].classList.remove("active");
            }
            
            document.getElementById(tabName).classList.add("active");
            document.getElementById(tabName).style.display = "block";
            evt.currentTarget.classList.add("active");

            // Cập nhật text nút Lưu theo tab
            const saveButton = document.querySelector('.form-actions .btn-primary');
            if (tabName === 'personal') {
                saveButton.textContent = 'Lưu';
            } else if (tabName === 'security') {
                saveButton.textContent = 'Đổi mật khẩu';
            }
        }

        // Chức năng Submit form đang active
        function submitActiveForm() {
            var activePane = document.querySelector('.tab-pane.active');
            if (activePane) {
                var form = activePane.querySelector('form');
                if (form) {
                    form.submit();
                }
            }
        }

        // Mở tab mặc định khi tải trang
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('personal').classList.add('active');
            document.getElementById('personal').style.display = 'block';
            document.querySelector('.tab-link').classList.add('active');
            document.querySelector('.form-actions .btn-primary').textContent = 'Lưu';
        });
    </script>
</body>
</html>