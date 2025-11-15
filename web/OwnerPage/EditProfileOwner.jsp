<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy" var="currentYear"/>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật thông tin cá nhân - Cát Bà Booking</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            .settings-card {
                background: var(--card);
                border-radius: var(--radius);
                padding: 2rem;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .settings-card__header h1 {
                margin: 0 0 0.5rem;
                font-size: 1.75rem;
                color: var(--foreground);
            }
            .settings-card__header p {
                margin: 0;
                color: var(--muted-foreground);
                font-size: 0.9rem;
            }
            .settings-tabs {
                margin-top: 1.5rem;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid var(--border);
                display: flex;
                gap: 1.5rem;
            }
            .settings-tab {
                position: relative;
                padding: 0.75rem 0;
                font-weight: 600;
                color: var(--muted-foreground);
                text-decoration: none;
                transition: color 0.2s;
            }
            .settings-tab:hover {
                color: var(--foreground);
            }
            .settings-tab.is-active {
                color: var(--primary);
            }
            .settings-tab.is-active::after {
                content: "";
                position: absolute;
                left: 0;
                right: 0;
                bottom: -0.5rem;
                height: 2px;
                background: var(--primary);
            }
            .alert {
                margin-top: 1.5rem;
                padding: 1rem;
                border-radius: var(--radius);
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }
            .alert-success {
                background: #ecfdf5;
                border: 1px solid #a7f3d0;
                color: #047857;
            }
            .alert-error {
                background: #fef2f2;
                border: 1px solid #fecaca;
                color: #b91c1c;
            }
            .alert-warning {
                background: #fffbeb;
                border: 1px solid #fcd34d;
                color: #92400e;
            }
            .tab-panel {
                display: none;
                margin-top: 2rem;
            }
            .tab-panel.is-active {
                display: block;
            }
            .field-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.25rem 1.5rem;
            }
            .field {
                display: flex;
                flex-direction: column;
            }
            .field label {
                font-size: 0.875rem;
                font-weight: 600;
                color: var(--muted-foreground);
                margin-bottom: 0.5rem;
            }
            .field input,
            .field select,
            .field textarea {
                width: 100%;
                border-radius: var(--radius);
                border: 1px solid var(--border);
                padding: 0.75rem;
                font-size: 0.9375rem;
                transition: all 0.2s;
                background: #fff;
                font-family: inherit;
            }
            .field textarea {
                min-height: 120px;
                resize: vertical;
            }
            .field input:focus,
            .field select:focus,
            .field textarea:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.1);
                outline: none;
            }
            .field-note {
                margin-top: 0.375rem;
                font-size: 0.75rem;
                color: var(--muted-foreground);
            }
            .section-title {
                margin: 2rem 0 1rem;
                font-size: 1.125rem;
                font-weight: 600;
                color: var(--foreground);
            }
            .section-title:first-of-type {
                margin-top: 0;
            }
            .form-actions {
                margin-top: 2rem;
                display: flex;
                justify-content: flex-end;
                gap: 0.75rem;
            }
            .btn {
                border-radius: 999px;
                padding: 0.75rem 1.5rem;
                font-weight: 600;
                border: none;
                cursor: pointer;
                transition: all 0.2s;
                font-size: 0.9375rem;
            }
            .btn--ghost {
                background: #fff;
                border: 1px solid var(--border);
                color: var(--foreground);
            }
            .btn--ghost:hover {
                border-color: var(--muted-foreground);
                background: var(--muted);
            }
            .btn--primary {
                background: var(--primary);
                color: var(--primary-foreground);
            }
            .btn--primary:hover {
                background: var(--secondary);
            }
        </style>
    </head>
    <body>
        <%@ include file="Sidebar.jsp" %>

        <!-- Overlay -->
        <div id="sidebar-overlay" class="hidden"></div>

        <!-- Header -->
        <header class="header">
            <button id="sidebar-toggle">☰</button>
            <h1>Cập nhật thông tin cá nhân</h1>
            <div class="header-actions">
                <span class="notification">🔔</span>
                <c:if test="${not empty user}">
                    <span class="user">${user.fullName}</span>
                </c:if>
            </div>
        </header>

        <!-- Main Content -->
        <div class="main-content">
            <main class="content">
                <c:set var="activeTab" value="${empty activeTab ? 'account' : activeTab}" />

                <div class="settings-card">
                    <div class="settings-tabs">
                        <a class="settings-tab ${activeTab eq 'account' ? 'is-active' : ''}"
                           href="${pageContext.request.contextPath}/owner/profile?tab=account">Thông tin tài khoản</a>
                        <a class="settings-tab ${activeTab eq 'security' ? 'is-active' : ''}"
                           href="${pageContext.request.contextPath}/owner/profile?tab=security">Mật khẩu &amp; Bảo mật</a>
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
                    <c:if test="${activeTab eq 'account' && not empty profileWarning}">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle"></i> ${profileWarning}
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
                        <form action="${pageContext.request.contextPath}/owner/profile" method="post">
                            <input type="hidden" name="tab" value="account">

                            <h3 class="section-title">Thông tin cá nhân</h3>
                            <div class="field-grid">
                                <div class="field">
                                    <label for="fullName">Họ và tên</label>
                                    <input type="text" id="fullName" name="fullName" value="${user.fullName}" required>
                                </div>
                                <div class="field">
                                    <label for="citizenId">Căn cước công dân</label>
                                    <input type="text" id="citizenId" name="citizenId" value="${user.citizenId}" placeholder="Nhập số căn cước công dân">
                                </div>
                                <div class="field">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" value="${user.email}" required>
                                </div>
                                <div class="field">
                                    <label for="phone">Số điện thoại</label>
                                    <input type="text" id="phone" name="phone" value="${user.phone}" placeholder="Nhập số điện thoại">
                                </div>
                                <div class="field" style="grid-column: 1 / -1;">
                                    <label for="personalAddress">Địa chỉ cá nhân</label>
                                    <input type="text" id="personalAddress" name="personalAddress" value="${user.personalAddress}" placeholder="Nhập địa chỉ cá nhân">
                                </div>                               
                                <div class="form-actions">
                                    <a href="${pageContext.request.contextPath}/owner/profile?tab=account" class="btn btn--ghost">Hủy</a>
                                    <button type="submit" class="btn btn--primary">Lưu</button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="tab-panel ${activeTab eq 'security' ? 'is-active' : ''}">
                        <form action="${pageContext.request.contextPath}/owner/change-password" method="post">
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
                                <a href="${pageContext.request.contextPath}/owner/profile?tab=security" class="btn btn--ghost">Hủy</a>
                                <button type="submit" class="btn btn--primary">Đổi mật khẩu</button>
                            </div>
                        </form>
                    </div>
            </main>
        </div>

        <script>
            // Sidebar toggle functionality
            const sidebar = document.querySelector('.sidebar');
            const toggle = document.getElementById('sidebar-toggle');
            const overlay = document.getElementById('sidebar-overlay');
            if (toggle) {
                toggle.addEventListener('click', () => {
                    sidebar.style.transform = 'translateX(0)';
                    overlay.classList.remove('hidden');
                });
            }
            if (overlay) {
                overlay.addEventListener('click', () => {
                    sidebar.style.transform = 'translateX(-100%)';
                    overlay.classList.add('hidden');
                });
            }
        </script>
    </body>
</html>
