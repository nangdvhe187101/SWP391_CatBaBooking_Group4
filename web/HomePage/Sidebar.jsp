<%-- 
    Document   : Sidebar
    Created on : Oct 6, 2025, 9:08:22 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<header class="header">
    <div class="top-bar">
        <div class="container">
            <div class="top-bar-content">
                <div class="top-bar-left">
                    <div class="currency-lang">
                        <span class="flag">🇻🇳</span>
                        <span>VND</span>
                        <span class="separator">|</span>
                        <span>Tiếng Việt</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="offers">
                        <i class="fas fa-star"></i>
                        <span>Ưu đãi</span>
                    </div>
                    <span>Hỗ trợ</span>
                    <span>Đối tác</span>
                    <span>Đã lưu</span>
                    <span>Đặt chỗ</span>
                </div>
                <div class="top-bar-right">
                    <%
                        Users user = (Users) session.getAttribute("currentUser");
                        if (user != null) {
                            String fullName = user.getFullName(); 
                            String priority = "Bronze Priority"; 
                            int points = 0; 
                    %>
                    <div class="user-logged-in">
                        <div class="user-dropdown" id="userDropdown">
                            <i class="fas fa-user-circle"></i>
                            <span><%= fullName %></span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <div class="user-info">
                                <img src="https://via.placeholder.com/40" alt="Avatar" class="avatar">
                                <div>
                                    <strong><%= fullName %></strong>
                                </div>
                            </div>
                            <ul class="dropdown-list">
                                <li>
                                    <a href="${pageContext.request.contextPath}/user/profile">
                                        <i class="fas fa-user-edit"></i> Edit Profile
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/user/bookings">
                                        <i class="fas fa-calendar-check"></i> My Booking
                                    </a>
                                </li>
                                <li class="logout-item">
                                    <form action="${pageContext.request.contextPath}/Logout" method="post" style="margin: 0; width: 100%;">
                                        <input type="submit" class="logout-submit" value="Logout" 
                                               onclick="return confirm('Bạn có chắc chắn muốn đăng xuất?')" />
                                    </form>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <%
                        } else {
                    %>
                    <div class="user-buttons">
                        <a href="${pageContext.request.contextPath}/Login" class="user-btn login-btn">
                            <i class="fas fa-user"></i>
                            <span>Log In</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/register-customer" class="user-btn register-btn">
                            <span>Register</span>
                        </a>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>

    <!-- Main navigation (giống ảnh 1, nhưng giữ link hiện tại) -->
    <div class="main-nav">
        <div class="container">
            <div class="nav-content">
                <a href="${pageContext.request.contextPath}/Home" class="logo">
                    <span class="logo-main">Cát Bà</span>
                    <span class="logo-sub">Booking</span>
                </a>

                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/homestay-list" class="nav-link">
                        <i class="fas fa-home"></i>
                        <span>Homestay</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/restaurant" class="nav-link">
                        <i class="fas fa-utensils"></i>
                        <span>Nhà hàng</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/Home" class="nav-link">
                        <i class="fas fa-home"></i>
                        <span>Trang chủ</span>
                    </a>
                </nav>

                <button class="mobile-menu-btn">
                    <i class="fas fa-bars"></i>
                </button>
            </div>
        </div>
    </div>
</header>

<style>
    /* Kiểu khác: Sử dụng absolute positioning với backdrop và animation slide-down mượt mà hơn, đè lên nội dung bên dưới */
    .user-dropdown {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        background: rgba(255, 255, 255, 0.1);
        padding: 0.5rem 0.75rem;
        border-radius: 9999px;
        cursor: pointer;
        transition: all 0.3s ease;
        color: white;
        position: relative;
        z-index: 1002;
    }

    .user-dropdown:hover {
        background: rgba(255, 255, 255, 0.2);
    }

    .user-dropdown i.fa-chevron-down {
        transition: transform 0.3s ease;
    }

    .user-dropdown.active i.fa-chevron-down {
        transform: rotate(180deg);
    }

    .dropdown-menu {
        display: none;
        position: absolute;
        top: 100%; /* Ngay dưới trigger mà không có gap */
        right: 0;
        background: white;
        border-radius: 1rem;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        min-width: 320px;
        z-index: 1001; /* Cao hơn header để đè lên nội dung bên dưới */
        overflow: hidden;
        transform: scaleY(0);
        transform-origin: top;
        transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); /* Animation bounce nhẹ */
    }

    .dropdown-menu.show {
        display: block;
        transform: scaleY(1);
    }

    /* Đảm bảo top-bar-right là relative để positioning đúng */
    .top-bar-right {
        position: relative;
    }

    .user-info {
        padding: 1.5rem;
        display: flex;
        align-items: center;
        gap: 1rem;
        background: linear-gradient(135deg, #f8fafc, #f1f5f9);
        border-bottom: 1px solid #e2e8f0;
    }

    .avatar {
        width: 48px;
        height: 48px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid #e2e8f0;
        transition: all 0.2s ease;
    }

    .user-info:hover .avatar {
        border-color: #059669;
        transform: scale(1.05);
    }

    .user-info strong {
        font-size: 1rem;
        color: #1e293b;
        display: block;
        font-weight: 600;
    }

    .priority {
        font-size: 0.85rem;
        color: #92400e;
        font-weight: 500;
        background: linear-gradient(135deg, #fef3c7, #fde68a);
        padding: 0.25rem 0.75rem;
        border-radius: 9999px;
        display: inline-block;
        margin-top: 0.25rem;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .points {
        padding: 1.25rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        background: linear-gradient(135deg, #fef3c7, #fde68a);
        color: #92400e;
        font-weight: 600;
        border-bottom: 1px solid #e2e8f0;
        position: relative;
    }

    .points::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 1px;
        background: linear-gradient(to right, transparent, #fbbf24, transparent);
    }

    .points i {
        font-size: 1.25rem;
        color: #d97706;
    }

    .dropdown-list {
        list-style: none;
        margin: 0;
        padding: 0;
    }

    .dropdown-list li {
        padding: 1rem 1.5rem;
        display: flex;
        align-items: center;
        gap: 1rem;
        color: #475569;
        font-size: 0.95rem;
        transition: all 0.3s ease;
        border-bottom: 1px solid #f1f5f9;
        cursor: pointer;
        position: relative;
        overflow: hidden;
    }

    .dropdown-list li::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 4px;
        background: transparent;
        transition: width 0.3s ease;
    }

    .dropdown-list li:hover {
        background: linear-gradient(to right, #ecfdf5 0%, #f0fdf4 100%);
        color: #059669;
        transform: translateX(5px);
    }

    .dropdown-list li:hover::before {
        width: 4px;
        background: #059669;
    }

    .dropdown-list li:last-child {
        border-bottom: none;
    }

    .dropdown-list a {
        color: inherit;
        text-decoration: none;
        width: 100%;
    }

    .dropdown-list i {
        width: 20px;
        text-align: center;
        font-size: 1rem;
        opacity: 0.6;
        transition: all 0.2s ease;
    }

    .dropdown-list li:hover i {
        opacity: 1;
        color: #059669;
    }

    .new-badge {
        background: linear-gradient(135deg, #f59e0b, #d97706);
        color: white;
        padding: 0.25rem 0.75rem;
        border-radius: 9999px;
        font-size: 0.75rem;
        font-weight: bold;
        margin-left: auto;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        animation: pulse 2s infinite;
    }

    @keyframes pulse {
        0%, 100% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.05);
        }
    }
</style>

<script>
// JS cho dropdown user (đã login) - cải tiến với animation slide-down từ trên xuống
    document.addEventListener('DOMContentLoaded', function () {
        // Dropdown user (đã login)
        const userDropdown = document.getElementById('userDropdown');
        const dropdownMenu = document.getElementById('dropdownMenu');
        if (userDropdown) {
            userDropdown.addEventListener('click', function (e) {
                e.stopPropagation();
                const isShow = dropdownMenu.classList.contains('show');
                dropdownMenu.classList.toggle('show');
                userDropdown.classList.toggle('active', !isShow);
            });

            // Close on outside click
            document.addEventListener('click', function (e) {
                if (!userDropdown.contains(e.target)) {
                    dropdownMenu.classList.remove('show');
                    userDropdown.classList.remove('active');
                }
            });

            // Close on escape key
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape' && dropdownMenu.classList.contains('show')) {
                    dropdownMenu.classList.remove('show');
                    userDropdown.classList.remove('active');
                }
            });
        }
    });
</script>