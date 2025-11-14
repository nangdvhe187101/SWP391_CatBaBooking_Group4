<%-- 
    Document   : Sidebar
    Created on : Oct 6, 2025, 9:10:42 PM
    Author     : ADMIN
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="sidebar">
    <div class="sidebar-header">Admin Panel</div>
    <div class="user-info">
        <div class="user-avatar">A</div>
        <span class="user-name">Admin</span>
    </div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/booking-history">Lịch sử Booking</a></li>
        <li><a href="${pageContext.request.contextPath}/approve-application">Duyệt Yêu Cầu</a></li>
        <li><a href="${pageContext.request.contextPath}/user-management">Quản Lý Người Dùng</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/feedbacks">Quản Lý Phản Hồi</a></li>
        <li><a href="#">Cài Đặt</a></li>
    </ul>
    <div class="sidebar-footer">
        <form action="${pageContext.request.contextPath}/Logout" method="post">
            <button type="submit" class="logout-btn">Đăng xuất</button>
        </form>
    </div>
</div>
