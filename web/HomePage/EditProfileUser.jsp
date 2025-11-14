<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy" var="currentYear"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cài đặt tài khoản</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            --bg: #f5f7fb;
            --card-bg: #ffffff;
            --primary: #22c55e;
            --primary-soft: rgba(34, 197, 94, 0.12);
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e2e8f0;
            --shadow: 0 30px 60px -35px rgba(15, 23, 42, 0.45);
            --radius-lg: 24px;
            --radius-md: 16px;
            --transition: all 0.25s ease;
        }
        * { box-sizing: border-box; }
        body {
            background: var(--bg);
            font-family: "Segoe UI", Arial, sans-serif;
            margin: 0;
            color: var(--text-main);
        }
        a { text-decoration: none; }
        .page {
            max-width: 960px;
            margin: 0 auto;
            padding: 48px 24px 64px;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: var(--primary);
            background: var(--primary-soft);
            padding: 10px 18px;
            border-radius: 999px;
            transition: var(--transition);
        }
        .back-link:hover { transform: translateX(-2px); }
        .settings-card {
            margin-top: 24px;
            background: var(--card-bg);
            border-radius: var(--radius-lg);
            padding: 32px 36px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
        }
        .settings-card__header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }
        .settings-card__header p {
            margin: 8px 0 0;
            color: var(--text-muted);
        }
        .settings-tabs {
            margin-top: 28px;
            padding-bottom: 6px;
            border-bottom: 1px solid var(--border);
            display: flex;
            gap: 24px;
        }
        .settings-tab {
            position: relative;
            padding: 12px 0;
            font-weight: 600;
            color: var(--text-muted);
        }
        .settings-tab.is-active {
            color: var(--text-main);
        }
        .settings-tab.is-active::after {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            bottom: -6px;
            height: 3px;
            border-radius: 999px;
            background: var(--primary);
        }
        .alert {
            margin-top: 24px;
            padding: 16px 18px;
            border-radius: var(--radius-md);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success {
            background: rgba(34, 197, 94, 0.18);
            border: 1px solid rgba(34, 197, 94, 0.35);
            color: #047857;
        }
        .alert-error {
            background: rgba(248, 113, 113, 0.18);
            border: 1px solid rgba(248, 113, 113, 0.35);
            color: #b91c1c;
        }
        .tab-panel {
            display: none;
            margin-top: 32px;
        }
        .tab-panel.is-active { display: block; }
        .field-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px 24px;
        }
        .field label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-muted);
            margin-bottom: 6px;
        }
        .field input,
        .field select {
            width: 100%;
            border-radius: 12px;
            border: 1px solid var(--border);
            padding: 12px 14px;
            font-size: 15px;
            transition: var(--transition);
            background: #fff;
        }
        .field input:focus,
        .field select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.18);
            outline: none;
        }
        .field-note {
            margin-top: 6px;
            font-size: 12px;
            color: var(--text-muted);
        }
        .form-actions {
            margin-top: 28px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }
        .btn {
            border-radius: 999px;
            padding: 12px 24px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: var(--transition);
        }
        .btn--ghost {
            background: #fff;
            border: 1px solid var(--border);
            color: var(--text-main);
        }
        .btn--ghost:hover {
            border-color: var(--text-muted);
        }
        .btn--primary {
            background: var(--primary);
            color: #fff;
            box-shadow: 0 18px 34px -18px rgba(34, 197, 94, 0.65);
        }
        .btn--primary:hover {
            transform: translateY(-2px);
        }
        @media (max-width: 640px) {
            .settings-card { padding: 28px 22px; }
            .settings-tabs { gap: 16px; }
        }
    </style>
</head>
<body>
<c:set var="activeTab" value="${empty activeTab ? 'account' : activeTab}" />
<div class="page">
    <a class="back-link" href="${pageContext.request.contextPath}/Home">
        <i class="fas fa-arrow-left"></i> Quay lại trang chủ
    </a>

    <div class="settings-card">
        <div class="settings-card__header">
            <h1>Cài đặt</h1>
            <p>Quản lý thông tin cá nhân và bảo mật tài khoản của bạn.</p>
        </div>

        <div class="settings-tabs">
            <a class="settings-tab ${activeTab eq 'account' ? 'is-active' : ''}"
               href="${pageContext.request.contextPath}/user/profile?tab=account">Thông tin tài khoản</a>
            <a class="settings-tab ${activeTab eq 'security' ? 'is-active' : ''}"
               href="${pageContext.request.contextPath}/user/profile?tab=security">Mật khẩu &amp; Bảo mật</a>
        </div>

        <c:if test="${activeTab eq 'account' && not empty profileSuccess}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${profileSuccess}
            </div>
        </c:if>
        <c:if test="${activeTab eq 'account' && not empty profileError}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${profileError}
            </div>
        </c:if>
        <c:if test="${activeTab eq 'security' && not empty passwordSuccess}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${passwordSuccess}
            </div>
        </c:if>
        <c:if test="${activeTab eq 'security' && not empty passwordError}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${passwordError}
            </div>
        </c:if>

        <div class="tab-panel ${activeTab eq 'account' ? 'is-active' : ''}">
            <form action="${pageContext.request.contextPath}/user/profile" method="post">
                <div class="field-grid">
                    <div class="field">
                        <label for="fullName">Tên đầy đủ</label>
                        <input type="text" id="fullName" name="fullName" value="${user.fullName}" required>
                        <div class="field-note">Tên hiển thị trong hồ sơ và booking.</div>
                    </div>
                    <div class="field">
                        <label for="gender">Giới tính</label>
                        <select id="gender" name="gender">
                            <option value="" ${empty user.gender ? "selected" : ""}>Chọn giới tính</option>
                            <option value="Male" ${user.gender == 'Male' ? "selected" : ""}>Nam</option>
                            <option value="Female" ${user.gender == 'Female' ? "selected" : ""}>Nữ</option>
                            <option value="Other" ${user.gender == 'Other' ? "selected" : ""}>Khác</option>
                        </select>
                    </div>
                    <div class="field">
                        <label for="birthDay">Ngày sinh</label>
                        <select id="birthDay" name="birthDay">
                            <option value="">Ngày</option>
                            <c:forEach begin="1" end="31" var="day">
                                <option value="${day}" ${user.birthDay != null && user.birthDay == day ? "selected" : ""}>
                                    <fmt:formatNumber value="${day}" pattern="00"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="field">
                        <label for="birthMonth">Tháng sinh</label>
                        <select id="birthMonth" name="birthMonth">
                            <option value="">Tháng</option>
                            <c:forEach begin="1" end="12" var="month">
                                <option value="${month}" ${user.birthMonth != null && user.birthMonth == month ? "selected" : ""}>
                                    <fmt:formatNumber value="${month}" pattern="00"/> - Tháng
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="field">
                        <label for="birthYear">Năm sinh</label>
                        <select id="birthYear" name="birthYear">
                            <option value="">Năm</option>
                            <c:forEach begin="1940" end="${currentYear}" var="year">
                                <option value="${year}" ${user.birthYear != null && user.birthYear == year ? "selected" : ""}>
                                    ${year}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="field">
                        <label for="city">Thành phố cư trú</label>
                        <input type="text" id="city" name="city" value="${user.city}">
                    </div>
                    <div class="field">
                        <label for="phone">Số điện thoại</label>
                        <input type="text" id="phone" name="phone" value="${user.phone}" required>
                    </div>
                    <div class="field">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="${user.email}" required>
                    </div>
                    <div class="field" style="grid-column: 1 / -1;">
                        <label for="personalAddress">Địa chỉ</label>
                        <input type="text" id="personalAddress" name="personalAddress" value="${user.personalAddress}">
                    </div>
                </div>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/user/profile?tab=account" class="btn btn--ghost">Hủy</a>
                    <button type="submit" class="btn btn--primary">Lưu</button>
                </div>
            </form>
        </div>

        <div class="tab-panel ${activeTab eq 'security' ? 'is-active' : ''}">
            <form action="${pageContext.request.contextPath}/user/change-password" method="post">
                <div class="field-grid">
                    <div class="field" style="grid-column: 1 / -1;">
                        <label for="currentPassword">Mật khẩu hiện tại</label>
                        <input type="password" id="currentPassword" name="currentPassword" required>
                    </div>
                    <div class="field" style="grid-column: 1 / -1;">
                        <label for="newPassword">Mật khẩu mới</label>
                        <input type="password" id="newPassword" name="newPassword" required>
                        <div class="field-note">Tối thiểu 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.</div>
                    </div>
                    <div class="field" style="grid-column: 1 / -1;">
                        <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                </div>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/user/profile?tab=security" class="btn btn--ghost">Hủy</a>
                    <button type="submit" class="btn btn--primary">Đổi mật khẩu</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>

