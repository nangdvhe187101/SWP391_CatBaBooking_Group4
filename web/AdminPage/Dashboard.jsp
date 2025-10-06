<%-- 
    Document   : Dashboard
    Created on : Oct 6, 2025, 9:09:49 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Dashboard</title>
    <link rel="stylesheet" href="admin-style.css">
</head>
<body>
    
    <%@ include file="Sidebar.jsp" %>

    <div class="main-content">
        <header>
            <h1>Dashboard</h1>
        </header>
        <main>
            <div class="dashboard-grid">
                <div class="dashboard-card">
                    <h3>Tổng số người dùng</h3>
                    <p></p>
                </div>
                <div class="dashboard-card">
                    <h3>Homestay đang hoạt động</h3>
                    <p></p>
                </div>
                <div class="dashboard-card">
                    <h3>Yêu cầu chờ duyệt</h3>
                    <p></p>
                </div>
                <div class="dashboard-card">
                    <h3>Doanh thu tháng</h3>
                    <p></p>
                </div>
            </div>
        </main>
    </div>
</body>
</html>