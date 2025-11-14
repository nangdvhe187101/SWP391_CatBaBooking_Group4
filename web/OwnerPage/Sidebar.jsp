<%-- 
    Document   : Sidebar
    Created on : Oct 22, 2025, 11:07:45 AM
    Author     : ADMIN
    Note: This file is included in other JSPs, so it should not have contentType directive.
    The parent JSP file should have: <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    This file must be saved with UTF-8 encoding.
--%>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <h2>🐚 Cát Bà Booking</h2>
        <h3>Owner Dashboard</h3>
    </div>
    <nav class="sidebar-nav">
        <ul>
            <li><a href="<c:url value='/owner/dashboard'/>" class="nav-link">🏠 Tổng quan</a></li>
            <li><a href="<c:url value='/owner/add-homestay'/>" class="nav-link">🏠 Thông tin Homestay</a></li>
            <li><a href="<c:url value='/owner/manage-homestay'/>" class="nav-link">🏠 Quản lý Homestay</a></li>
            <li><a href="<c:url value='/manage-homestay-rooms'/>" class="nav-link">🛏️ Quản lý Phòng</a></li>
            <li><a href="<c:url value='/homestay-bookings'/>" class="nav-link">📅 Lịch sử Đặt phòng</a></li>
            <li><a href="<c:url value='/list-dish'/>" class="nav-link">🍽️ Quản lý Món ăn</a></li>
            <li><a href="<c:url value='/owner/restaurant-bookings'/>" class="nav-link">📅 Đặt bàn</a></li>
            <li><a href="<c:url value='/restaurant-manage-tables'/>" class="nav-link">🍽️ Quản lý Bàn</a></li>
            <li><a href="<c:url value='/owner/restaurant-table-availability'/>" class="nav-link">🪑 Tình trạng bàn</a></li>
            <li><a href="<c:url value='/restaurant-settings'/>" class="nav-link">Thông tin cơ sở kinh doanh</a></li>
            <li><a href="<c:url value='/owner/profile'/>" class="nav-link">⚙️ Cập nhật thông tin cá nhân</a></li>
            <li><a href="<c:url value='/owner/feedback'/>" class="nav-link">💬 Phản hồi & Đánh giá</a></li>
            <li><a href="<c:url value='/owner/reports'/>" class="nav-link">📊 Báo cáo Doanh thu</a></li>
            <li>
            <form action="<c:url value='/Logout'/>" method="POST" style="margin: 0;">
                <button type="submit" class="nav-link" style="background: none; border: none; width: 100%; text-align: left; cursor: pointer;">
                   ➡️ Đăng xuất
                </button>
            </form>
        </li>
        </ul>
    </nav>
</aside>
