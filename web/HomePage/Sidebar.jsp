<%-- 
    Document   : Sidebar
    Created on : Oct 6, 2025, 9:08:22 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

                    <%-- Sử dụng JSTL <c:if> để kiểm tra session thay cho scriptlet --%>
                    
                    <c:if test="${sessionScope.loggedInUser != null}">
                        <div class="user-logged-in">
                            <div class="user-dropdown" id="userDropdown">
                                <div class="user-info">
                                    <img src="https://via.placeholder.com/40" alt="Avatar" class="avatar">
                                    <div>
                                        <%-- Sử dụng Expression Language (EL) để hiển thị tên, an toàn và sạch sẽ hơn --%>
                                        <strong>${sessionScope.loggedInUser.fullName}</strong>
                                    </div>
                                </div>
                                <i class="fas fa-chevron-down"></i>
                            </div>
                            <div class="dropdown-menu" id="dropdownMenu">
                                <ul class="dropdown-list">
                                    <li><a href="#"><i class="fas fa-user-edit"></i> Tài khoản của tôi</a></li>
                                    <li><a href="#"><i class="fas fa-history"></i> Lịch sử đặt chỗ</a></li>
                                    <li><a href="#"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${sessionScope.loggedInUser == null}">
                        <div class="user-buttons">
                            <a href="Authentication/Login.jsp" class="user-btn login-btn">Đăng nhập</a>
                            <a href="Authentication/RegisterCustomer.jsp" class="user-btn register-btn">Đăng ký</a>
                        </div>
                    </c:if>

                </div>
            </div>
        </div>
    </div>

    <div class="main-nav">
        <div class="container">
            <div class="nav-content">
                <div class="logo">
                    <a href="Home.jsp">
                        <span class="logo-main">Cát Bà</span>
                        <span class="logo-sub">Booking</span>
                    </a>
                </div>
                <nav class="nav-links">
                    <a href="Home.jsp" class="nav-link">Trang chủ</a>
                    <a href="Homestay.jsp" class="nav-link">Homestay</a>
                    <a href="Restaurant.jsp" class="nav-link">Nhà hàng</a>
                    <a href="#" class="nav-link">Tour du lịch</a>
                    <a href="#" class="nav-link">Blog</a>
                    <a href="#" class="nav-link">Về chúng tôi</a>
                </nav>
                <a href="#" class="host-btn">Trở thành chủ nhà</a>
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
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}
</style>

<script>
// JS cho dropdown user (đã login) - cải tiến với animation slide-down từ trên xuống
document.addEventListener('DOMContentLoaded', function() {
    // Dropdown user (đã login)
    const userDropdown = document.getElementById('userDropdown');
    const dropdownMenu = document.getElementById('dropdownMenu');
    if (userDropdown) {
        userDropdown.addEventListener('click', function(e) {
            e.stopPropagation();
            const isShow = dropdownMenu.classList.contains('show');
            dropdownMenu.classList.toggle('show');
            userDropdown.classList.toggle('active', !isShow);
        });
        
        // Close on outside click
        document.addEventListener('click', function(e) {
            if (!userDropdown.contains(e.target)) {
                dropdownMenu.classList.remove('show');
                userDropdown.classList.remove('active');
            }
        });
        
        // Close on escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && dropdownMenu.classList.contains('show')) {
                dropdownMenu.classList.remove('show');
                userDropdown.classList.remove('active');
            }
        });
    }
});
</script>