<%-- 
    Document   : Sidebar
    Created on : Oct 22, 2025, 11:07:45 AM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <h2>🐚 Cát Bà Booking</h2>
        <h3>Owner Dashboard</h3>
    </div>
    <nav class="sidebar-nav">
        <ul>
            <li><a href="Dashboard.jsp" class="nav-link">🏠 Tổng quan</a></li>
            <li><a href="AddHomestay.jsp" class="nav-link">🏠 Thông tin Homestay</a></li>
            <li><a href="ManageHomestay.jsp" class="nav-link">🏠 Quản lý Homestay</a></li>
            <li><a href="RestaurantManageDishes.jsp" class="nav-link">🍽️ Quản lý Món ăn</a></li>
            <li><a href="RestaurantBookings.jsp" class="nav-link">📅 Đặt bàn</a></li>
            <li><a href="RestaurantManageTables.jsp" class="nav-link">🍽️ Quản lý Bàn</a></li>
            <li><a href="RestaurantTableAvailability.jsp" class="nav-link">🪑 Tình trạng bàn</a></li>
            <li><a href="${pageContext.request.contextPath}/restaurant-settings" class="nav-link">⚙ Thông tin nhà hàng</a></li>
            <li><a href="Feedback.jsp" class="nav-link">💬 Phản hồi & Đánh giá</a></li>
            <li><a href="Reports.jsp" class="nav-link">📊 Báo cáo Doanh thu</a></li>
            <li>
            <form action="${pageContext.request.contextPath}/Logout" method="POST" style="margin: 0;">
                <button type="submit" class="nav-link" style="background: none; border: none; width: 100%; text-align: left;">
                   ➡️ Đăng xuất
                </button>
            </form>
        </li>
        </ul>
    </nav>
</aside>