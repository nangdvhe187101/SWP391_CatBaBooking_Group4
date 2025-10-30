<%-- 
    Document   : EditProfile
    Purpose    : Simple, clean "Edit Profile" page for end users
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - Cát Bà Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* ===== Root Variables ===== */
        :root { 
            --bg:#f7fafc; 
            --card:#ffffff; 
            --text:#1f2937; 
            --muted:#64748b; 
            --primary:#059669; 
            --border:#e5e7eb; 
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial;
            background: var(--bg);
            color: var(--text);
        }

        /* ===== Layout ===== */
        .container { 
            max-width: 700px;
            margin: 40px auto;
            padding: 0 16px;
        }

        .card { 
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,.04);
        }

        .card-header { 
            padding: 20px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }

        .title { font-size: 20px; font-weight: 700; margin: 0; }
        .header-actions {
            position: absolute;
            left: 24px;
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

        /* ===== Form ===== */
        form {
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        label {
            display: block;
            font-weight: 600;
            color: var(--text);
            margin-bottom: 6px;
        }

        input[type="text"], 
        input[type="email"], 
        input[type="password"], 
        input[type="tel"] {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        input:focus {
            border-color: var(--primary);
            outline: none;
        }

        .btn {
            padding: 10px 14px;
            border: 1px solid var(--border);
            background: #fff;
            color: var(--text);
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn.primary {
            background: var(--primary);
            color: #fff;
            border-color: var(--primary);
        }

        .btn.primary:hover {
            opacity: 0.9;
        }

        /* ===== Responsive ===== */
        @media (max-width: 640px) {
            .container { padding: 0 12px; }
            .card { border-radius: 10px; }
            form { padding: 20px; }
        }
    </style>
</head>

<body>
<div class="container">
    <div class="header" style="text-align:center; margin-bottom: 16px; position: relative;">
        <div class="header-actions">
            <a class="btn-back" href="${pageContext.request.contextPath}/HomePage/Home.jsp">
                <i class="fas fa-arrow-left"></i> Quay lại trang chủ
            </a>
        </div>
        <h1 style="margin:0; font-size: 24px; font-weight: 700; color:#1f2937;">Chỉnh sửa hồ sơ</h1>
    </div>

    <div class="card">
        <div class="card-header">
            <h2 class="title">Thông tin cá nhân</h2>
        </div>

        <form action="EditProfileServlet" method="post">
            <div>
                <label for="fullname">Họ và tên</label>
                <input type="text" id="fullname" name="fullname" value="${user.fullname}" required>
            </div>

            <div>
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${user.email}" readonly>
            </div>

            <div>
                <label for="phone">Số điện thoại</label>
                <input type="tel" id="phone" name="phone" value="${user.phone}" pattern="[0-9]{10}" required>
            </div>

            <div>
                <label for="address">Địa chỉ</label>
                <input type="text" id="address" name="address" value="${user.address}">
            </div>

            <div>
                <label for="password">Mật khẩu mới (tuỳ chọn)</label>
                <input type="password" id="password" name="password" placeholder="Để trống nếu không đổi">
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top: 10px;">
                <button type="reset" class="btn">Hủy</button>
                <button type="submit" class="btn primary">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
