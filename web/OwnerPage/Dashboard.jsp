<%-- 
    Document   : Dashboard
    Created on : Oct 6, 2025
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tổng quan - Cát Bà Booking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css" />
    <style>
        .stat-card {
            border: none; border-radius: 12px; padding: 20px; color: white;
            height: 100%; box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .bg-gradient-success { background: linear-gradient(45deg, #1cc88a, #13855c); }
        .bg-gradient-primary { background: linear-gradient(45deg, #4e73df, #224abe); }
        .bg-gradient-warning { background: linear-gradient(45deg, #f6c23e, #dda20a); }
        .bg-gradient-info    { background: linear-gradient(45deg, #36b9cc, #258391); }
        
        .stat-title { font-size: 0.85rem; text-transform: uppercase; font-weight: 700; opacity: 0.8; margin-bottom: 5px; }
        .stat-value { font-size: 1.8rem; font-weight: 800; }
        .stat-icon { font-size: 2.5rem; opacity: 0.3; }
    </style>
</head>
<body>
     <%@ include file="Sidebar.jsp" %>
    <div id="sidebar-overlay" class="hidden"></div>

    <header class="header">
        <button id="sidebar-toggle">☰</button>
        <h1>Tổng quan</h1>
        <div class="header-actions"><span class="user">O ${currentUser.fullName}</span></div>
    </header>

    <div class="main-content">
        <main class="content">
            <div class="container-fluid py-3">
                
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="text-primary fw-bold mb-1">Xin chào, ${business.name}</h4>
                        <p class="text-muted small mb-0">Loại hình: <span class="badge bg-secondary text-uppercase">${business.type}</span></p>
                    </div>
                    <div>
                        <c:if test="${business.type == 'homestay'}">
                            <a href="${pageContext.request.contextPath}/homestay-bookings" class="btn btn-success btn-sm shadow-sm"><i class="bi bi-calendar-check"></i> Quản lý đặt phòng</a>
                        </c:if>
                        <c:if test="${business.type == 'restaurant'}">
                            <a href="${pageContext.request.contextPath}/owner-bookings" class="btn btn-primary btn-sm shadow-sm"><i class="bi bi-calendar-check"></i> Quản lý đặt bàn</a>
                        </c:if>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card bg-gradient-success">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-title">Tổng Doanh thu</div>
                                    <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" type="currency" currencyCode="VND" maxFractionDigits="0"/></div>
                                </div>
                                <div class="stat-icon"><i class="bi bi-currency-dollar"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card bg-gradient-primary">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-title">Tổng Đơn hàng</div>
                                    <div class="stat-value">${totalBookings}</div>
                                </div>
                                <div class="stat-icon"><i class="bi bi-receipt"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card bg-gradient-warning">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-title">Đơn Chờ Xử Lý</div>
                                    <div class="stat-value">${pendingBookings}</div>
                                </div>
                                <div class="stat-icon"><i class="bi bi-hourglass-split"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card bg-gradient-info">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-title">Điểm Đánh giá</div>
                                    <div class="stat-value">${avgRating} <small class="fs-6">/ 5</small></div>
                                    <div class="small">(${reviewCount} lượt)</div>
                                </div>
                                <div class="stat-icon"><i class="bi bi-star-fill"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white py-3"><h6 class="m-0 fw-bold text-primary">Đơn đặt gần đây</h6></div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0 align-middle">
                                <thead class="table-light">
                                    <tr><th>Mã đơn</th><th>Khách hàng</th><th>Tổng tiền</th><th>Trạng thái</th></tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty recentList}">
                                            <tr><td colspan="4" class="text-center py-3 text-muted">Chưa có đơn hàng nào.</td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="b" items="${recentList}">
                                                <tr>
                                                    <td class="fw-bold text-primary">#${b.bookingCode}</td>
                                                    <td>${b.bookerName}</td>
                                                    <td class="fw-bold"><fmt:formatNumber value="${b.totalPrice}" type="currency" currencyCode="VND"/></td>
                                                    <td>
                                                        <span class="badge ${b.status == 'pending' ? 'bg-warning text-dark' : b.status == 'confirmed' ? 'bg-success' : 'bg-secondary'}">
                                                            ${b.status}
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const sidebar = document.querySelector('.sidebar');
            const toggle = document.getElementById('sidebar-toggle');
            const overlay = document.getElementById('sidebar-overlay');
            if(toggle) toggle.addEventListener('click', () => { sidebar.style.transform = 'translateX(0)'; overlay.classList.remove('hidden'); });
            if(overlay) overlay.addEventListener('click', () => { sidebar.style.transform = 'translateX(-100%)'; overlay.classList.add('hidden'); });
        });
    </script>
</body>
</html>