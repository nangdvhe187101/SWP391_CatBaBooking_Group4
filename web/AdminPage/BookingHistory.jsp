<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Lịch sử Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/AdminPage/admin-style.css">
    <style>
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-header h1 { font-size: 28px; color: #0f172a; margin: 0; }
        .filters-section { background: #fff; border-radius: 12px; padding: 20px; margin-bottom: 24px; border: 1px solid #e2e8f0; }
        .filters-form { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; align-items: end; }
        .filter-group { display: flex; flex-direction: column; }
        .filter-group label { font-size: 13px; color: #64748b; margin-bottom: 6px; font-weight: 500; }
        .filter-group select, .filter-group input { padding: 10px 12px; border: 1px solid #e2e8f0; border-radius: 6px; font-size: 14px; }
        .filter-group input:focus, .filter-group select:focus { outline: none; border-color: #3b82f6; }
        .btn-filter { padding: 10px 20px; background: #3b82f6; color: #fff; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: 500; }
        .btn-filter:hover { background: #2563eb; }
        .bookings-table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; border: 1px solid #e2e8f0; }
        .bookings-table thead { background: #f8fafc; }
        .bookings-table th { padding: 14px 16px; text-align: left; font-size: 12px; color: #475569; text-transform: uppercase; font-weight: 600; border-bottom: 2px solid #e2e8f0; }
        .bookings-table td { padding: 14px 16px; font-size: 14px; color: #334155; border-bottom: 1px solid #e2e8f0; }
        .bookings-table tbody tr:hover { background: #f8fafc; }
        .bookings-table tbody tr:last-child td { border-bottom: none; }
        .status-badge { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; text-transform: uppercase; }
        .status-badge.pending { background: #fef3c7; color: #b45309; }
        .status-badge.confirmed { background: #dcfce7; color: #166534; }
        .status-badge.cancelled { background: #fee2e2; color: #b91c1c; }
        .pagination { display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 24px; }
        .pagination a, .pagination span { padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; text-decoration: none; color: #334155; font-size: 14px; }
        .pagination a:hover { background: #f8fafc; }
        .pagination .current { background: #3b82f6; color: #fff; border-color: #3b82f6; }
        .empty-state { text-align: center; padding: 48px 0; color: #94a3b8; font-size: 14px; }
        .info-badge { display: inline-block; padding: 4px 8px; background: #e0e7ff; color: #3730a3; border-radius: 4px; font-size: 12px; font-weight: 500; }
    </style>
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <div class="main-content">
        <div class="page-header">
            <div>
                <h1>Lịch sử Booking</h1>
                <p style="color: #64748b; margin-top: 6px; font-size: 14px;">Quản lý tất cả đơn đặt phòng và đặt bàn trong hệ thống</p>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div style="background: #fef2f2; border: 1px solid #fecaca; color: #b91c1c; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px;">
                ${error}
            </div>
        </c:if>

        <div class="filters-section">
            <form method="get" action="${pageContext.request.contextPath}/admin/booking-history" class="filters-form">
                <div class="filter-group">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="all" ${statusFilter eq 'all' ? 'selected' : ''}>Tất cả</option>
                        <option value="confirmed" ${statusFilter eq 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                        <option value="cancelled_by_user" ${statusFilter eq 'cancelled_by_user' ? 'selected' : ''}>Đã hủy (User)</option>
                        <option value="cancelled_by_owner" ${statusFilter eq 'cancelled_by_owner' ? 'selected' : ''}>Đã hủy (Owner)</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>Loại hình</label>
                    <select name="type">
                        <option value="all" ${businessTypeFilter eq 'all' ? 'selected' : ''}>Tất cả</option>
                        <option value="homestay" ${businessTypeFilter eq 'homestay' ? 'selected' : ''}>Homestay</option>
                        <option value="restaurant" ${businessTypeFilter eq 'restaurant' ? 'selected' : ''}>Nhà hàng</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>Tìm kiếm</label>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Mã booking, tên, email, SĐT...">
                </div>
                <div class="filter-group">
                    <button type="submit" class="btn-filter">Lọc</button>
                </div>
            </form>
        </div>

        <div style="background: #fff; border-radius: 12px; border: 1px solid #e2e8f0; overflow: hidden;">
            <c:choose>
                <c:when test="${not empty bookings}">
                    <table class="bookings-table">
                        <thead>
                            <tr>
                                <th>Mã Booking</th>
                                <th>Khách hàng</th>
                                <th>Cơ sở</th>
                                <th>Loại hình</th>
                                <th>Số khách</th>
                                <th>Tổng tiền</th>
                                <th>Thanh toán</th>
                                <th>Trạng thái</th>
                                <th>Ngày đặt</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${bookings}">
                                <tr>
                                    <td><strong>#${booking.bookingCode}</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.user ne null}">
                                                ${booking.user.fullName}
                                                <c:if test="${not empty booking.user.email}">
                                                    <br><small style="color: #94a3b8;">${booking.user.email}</small>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                ${booking.bookerName}
                                                <c:if test="${not empty booking.bookerEmail}">
                                                    <br><small style="color: #94a3b8;">${booking.bookerEmail}</small>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.business ne null}">
                                                ${booking.business.name}
                                                <c:if test="${not empty booking.business.address}">
                                                    <br><small style="color: #94a3b8;">${booking.business.address}</small>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>Đang cập nhật</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.business ne null}">
                                                <span class="info-badge">
                                                    <c:choose>
                                                        <c:when test="${booking.business.type eq 'homestay'}">Homestay</c:when>
                                                        <c:when test="${booking.business.type eq 'restaurant'}">Nhà hàng</c:when>
                                                        <c:otherwise>${booking.business.type}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${booking.numGuests} người</td>
                                    <td>
                                        <strong>
                                            <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫" groupingUsed="true" maxFractionDigits="0"/>
                                        </strong>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.paymentStatus eq 'fully_paid'}">
                                                <span style="color: #166534; font-weight: 500;">Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${booking.paymentStatus eq 'partially_paid'}">
                                                <span style="color: #b45309; font-weight: 500;">Thanh toán một phần</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #b91c1c; font-weight: 500;">Chưa thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
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
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty booking.displayReservationStart}">
                                                ${booking.displayReservationStart}
                                            </c:when>
                                            <c:when test="${not empty booking.displayReservationDateTime}">
                                                ${booking.displayReservationDateTime}
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <c:url var="prevUrl" value="/admin/booking-history">
                                    <c:param name="page" value="${currentPage - 1}"/>
                                    <c:param name="status" value="${statusFilter}"/>
                                    <c:param name="type" value="${businessTypeFilter}"/>
                                    <c:param name="keyword" value="${keyword}"/>
                                </c:url>
                                <a href="${prevUrl}">« Trước</a>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i eq currentPage}">
                                        <span class="current">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="pageUrl" value="/admin/booking-history">
                                            <c:param name="page" value="${i}"/>
                                            <c:param name="status" value="${statusFilter}"/>
                                            <c:param name="type" value="${businessTypeFilter}"/>
                                            <c:param name="keyword" value="${keyword}"/>
                                        </c:url>
                                        <a href="${pageUrl}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <c:url var="nextUrl" value="/admin/booking-history">
                                    <c:param name="page" value="${currentPage + 1}"/>
                                    <c:param name="status" value="${statusFilter}"/>
                                    <c:param name="type" value="${businessTypeFilter}"/>
                                    <c:param name="keyword" value="${keyword}"/>
                                </c:url>
                                <a href="${nextUrl}">Sau »</a>
                            </c:if>
                        </div>
                    </c:if>

                    <div style="padding: 16px; background: #f8fafc; border-top: 1px solid #e2e8f0; color: #64748b; font-size: 14px;">
                        Tổng số: <strong>${totalBookings}</strong> booking
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>Chưa có booking nào.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>

