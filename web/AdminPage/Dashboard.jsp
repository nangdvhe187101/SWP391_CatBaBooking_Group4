<%-- 
    Document   : Dashboard
    Created on : Oct 6, 2025, 9:09:49 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/AdminPage/admin-style.css">
    <style>
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; }
        .page-header h1 { font-size:28px; color:#0f172a; margin:0; }
        .page-subtitle { color:#64748b; margin-top:6px; }
        .stats-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(250px,1fr)); gap:20px; }
        .stat-card { background:#fff; border-radius:12px; padding:20px; border:1px solid #e2e8f0; box-shadow:0 8px 24px rgba(15,23,42,0.08); transition:transform 0.2s, box-shadow 0.2s; }
        .stat-card:hover { transform:translateY(-4px); box-shadow:0 12px 32px rgba(15,23,42,0.12); }
        .stat-label { font-size:12px; color:#64748b; margin-bottom:8px; text-transform:uppercase; letter-spacing:.04em; font-weight:600; }
        .stat-value { font-size:32px; font-weight:700; color:#0f172a; margin-bottom:6px; }
        .stat-caption { font-size:13px; color:#94a3b8; }
        .activity-card { margin-top:32px; background:#fff; border-radius:12px; border:1px solid #e2e8f0; box-shadow:0 8px 24px rgba(15,23,42,0.06); overflow:hidden; }
        .activity-card header { padding:20px 24px; border-bottom:1px solid #e2e8f0; background:#f8fafc; }
        .activity-card h2 { margin:0; font-size:20px; color:#0f172a; font-weight:700; }
        .activity-header-action { display:flex; justify-content:space-between; align-items:center; }
        .activity-header-action a { color:#0f172a; text-decoration:none; font-size:14px; font-weight:500; }
        .activity-header-action a:hover { color:#475569; }
        .activity-card table { width:100%; border-collapse:collapse; }
        .activity-card thead { background:#f8fafc; }
        .activity-card th, .activity-card td { padding:14px 24px; text-align:left; font-size:14px; color:#334155; border-bottom:1px solid #e2e8f0; }
        .activity-card tbody tr:hover { background:#f8fafc; }
        .activity-card tbody tr:last-child td { border-bottom:none; }
        .status-badge { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:999px; font-size:12px; font-weight:600; text-transform:uppercase; }
        .status-badge.pending { background:#fef3c7; color:#b45309; }
        .status-badge.confirmed { background:#dcfce7; color:#166534; }
        .status-badge.cancelled { background:#fee2e2; color:#b91c1c; }
        .status-badge.rejected { background:#fee2e2; color:#b91c1c; }
        .status-badge.active { background:#dcfce7; color:#166534; }
        .empty-state { padding:36px 0; text-align:center; color:#94a3b8; font-size:14px; }
        .quick-links { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:16px; margin-top:32px; }
        .quick-link { background:#fff; border-radius:12px; padding:16px; border:1px solid #e2e8f0; text-align:center; cursor:pointer; transition:all 0.2s; text-decoration:none; color:#0f172a; }
        .quick-link:hover { border-color:#0f172a; box-shadow:0 4px 16px rgba(15,23,42,0.1); }
        .quick-link-icon { font-size:24px; margin-bottom:8px; }
        .quick-link-text { font-weight:600; font-size:14px; }
    </style>
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <div class="main-content">
        <div class="page-header">
            <div>
                <h1>Dashboard</h1>
                <p class="page-subtitle">Theo dõi hoạt động hệ thống và các yêu cầu gần đây.</p>
            </div>
        </div>
        <main>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Tổng số người dùng</div>
                    <div class="stat-value"><c:out value="${totalUsers}" default="0"/></div>
                    <div class="stat-caption">Số lượng tài khoản đã đăng ký</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Cơ sở đang hoạt động</div>
                    <div class="stat-value"><c:out value="${activeBusinesses}" default="0"/></div>
                    <div class="stat-caption">Homestay & Nhà hàng hoạt động</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Doanh thu tháng</div>
                    <div class="stat-value">
                        <fmt:formatNumber value="${monthlyRevenue}" type="currency" currencySymbol="₫" groupingUsed="true" maxFractionDigits="0"/>
                    </div>
                    <div class="stat-caption">Tổng doanh thu tháng này</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Yêu cầu đang chờ</div>
                    <div class="stat-value"><c:out value="${pendingApplications}" default="0"/></div>
                    <div class="stat-caption">Yêu cầu duyệt cơ sở mới</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Tổng Booking</div>
                    <div class="stat-value"><c:out value="${totalBookings}" default="0"/></div>
                    <div class="stat-caption">Tất cả booking trong hệ thống</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Thanh toán chờ</div>
                    <div class="stat-value"><c:out value="${pendingPayments}" default="0"/></div>
                    <div class="stat-caption">Booking chưa thanh toán</div>
                </div>
            </div>

            <div class="activity-card">
                <header>
                    <div class="activity-header-action">
                        <h2>Lịch sử Booking gần đây</h2>
                        <a href="${pageContext.request.contextPath}/admin/booking-history">Xem tất cả →</a>
                    </div>
                </header>
                <c:choose>
                    <c:when test="${not empty recentBookings}">
                        <table>
                            <thead>
                            <tr>
                                <th>Mã Booking</th>
                                <th>Khách hàng</th>
                                <th>Cơ sở</th>
                                <th>Loại hình</th>
                                <th>Số khách</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="booking" items="${recentBookings}">
                                <tr>
                                    <td><strong>#${booking.bookingCode}</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.user ne null}">${booking.user.fullName}</c:when>
                                            <c:otherwise>${booking.bookerName}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.business ne null}">${booking.business.name}</c:when>
                                            <c:otherwise>Đang cập nhật</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.business ne null}">
                                                <c:choose>
                                                    <c:when test="${booking.business.type eq 'homestay'}">Homestay</c:when>
                                                    <c:when test="${booking.business.type eq 'restaurant'}">Nhà hàng</c:when>
                                                    <c:otherwise>${booking.business.type}</c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${booking.numGuests} người</td>
                                    <td>
                                        <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫" groupingUsed="true" maxFractionDigits="0"/>
                                    </td>
                                    <td>
                                        <span class="status-badge ${booking.statusBadgeClass}">
                                            <c:choose>
                                                <c:when test="${booking.status eq 'confirmed'}">Đã xác nhận</c:when>
                                                <c:when test="${booking.status eq 'cancelled_by_user' or booking.status eq 'cancelled_by_owner' or booking.status eq 'rejected'}">Đã hủy</c:when>
                                                <c:otherwise>Đang chờ</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">Chưa có booking nào.</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="quick-links">
                <a href="${pageContext.request.contextPath}/approve-application" class="quick-link">
                    <div class="quick-link-icon">📋</div>
                    <div class="quick-link-text">Duyệt yêu cầu</div>
                    <c:if test="${pendingApplications > 0}">
                        <div style="font-size:12px; color:#e74c3c; margin-top:4px;">${pendingApplications} chờ duyệt</div>
                    </c:if>
                </a>
                <a href="${pageContext.request.contextPath}/user-management" class="quick-link">
                    <div class="quick-link-icon">👥</div>
                    <div class="quick-link-text">Quản lý người dùng</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/booking-history" class="quick-link">
                    <div class="quick-link-icon">🏠</div>
                    <div class="quick-link-text">Booking & Đặt phòng</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/feedbacks" class="quick-link">
                    <div class="quick-link-icon">⭐</div>
                    <div class="quick-link-text">Quản lý phản hồi</div>
                </a>
            </div>
        </main>
    </div>
</body>
</html>