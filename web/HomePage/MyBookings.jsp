<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Booking Của Tôi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            --bg: #f5f7fb;
            --card-bg: #ffffff;
            --primary: #2563eb;
            --primary-soft: rgba(37, 99, 235, 0.1);
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e2e8f0;
            --shadow: 0 25px 50px -20px rgba(15, 23, 42, 0.25);
            --radius-lg: 24px;
            --radius-md: 16px;
            --transition: all 0.25s ease;
        }
        * { box-sizing: border-box; }
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: var(--bg);
            margin: 0;
            color: var(--text-main);
        }
        a { text-decoration: none; }
        .page {
            max-width: 1120px;
            margin: 0 auto;
            padding: 48px 24px 64px;
        }
        .page__header {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .page__header-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: var(--primary);
            background: var(--primary-soft);
            padding: 10px 18px;
            border-radius: 999px;
            transition: var(--transition);
        }
        .back-link:hover { background: rgba(37, 99, 235, 0.18); }
        .page__title {
            font-size: 32px;
            font-weight: 700;
            margin: 0;
        }
        .page__subtitle {
            margin: 0;
            color: var(--text-muted);
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 18px;
            margin-top: 28px;
        }
        .stat-card {
            background: var(--card-bg);
            border-radius: var(--radius-md);
            padding: 20px 24px;
            border: 1px solid var(--border);
            box-shadow: 0 8px 24px -18px rgba(15, 23, 42, 0.35);
        }
        .stat-card__label {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-muted);
        }
        .stat-card__value {
            margin: 12px 0 6px;
            font-size: 30px;
            font-weight: 700;
        }
        .stat-card__caption {
            font-size: 13px;
            color: var(--text-muted);
        }
        .filters {
            margin-top: 32px;
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .filter-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            border-radius: 999px;
            border: 1px solid var(--border);
            background: #fff;
            color: var(--text-main);
            font-weight: 600;
            transition: var(--transition);
        }
        .filter-chip:hover {
            border-color: var(--primary);
            color: var(--primary);
        }
        .filter-chip.is-active {
            background: var(--primary);
            border-color: var(--primary);
            color: #fff;
            box-shadow: 0 14px 32px -18px rgba(37, 99, 235, 0.65);
        }
        .bookings-list {
            margin-top: 36px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .booking-card {
            background: var(--card-bg);
            border-radius: var(--radius-lg);
            padding: 26px 28px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            transition: var(--transition);
        }
        .booking-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 22px 45px -20px rgba(15, 23, 42, 0.28);
        }
        .booking-card__header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }
        .booking-code {
            font-size: 18px;
            font-weight: 700;
        }
        .status-badge {
            padding: 8px 16px;
            border-radius: 999px;
            font-weight: 600;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .status-badge.confirmed {
            background: rgba(16, 185, 129, 0.15);
            color: #047857;
        }
        .status-badge.pending {
            background: rgba(251, 191, 36, 0.16);
            color: #b45309;
        }
        .status-badge.cancelled {
            background: rgba(248, 113, 113, 0.16);
            color: #b91c1c;
        }
        .booking-card__body {
            margin-top: 22px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 18px 32px;
        }
        .booking-info__label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-muted);
            margin-bottom: 6px;
        }
        .booking-info__value {
            font-size: 16px;
            font-weight: 600;
            color: var(--text-main);
        }
        .booking-info__sub {
            color: var(--text-muted);
            font-size: 14px;
            margin-top: 4px;
        }
        .booking-card__footer {
            margin-top: 24px;
            display: flex;
            justify-content: flex-end;
        }
        .booking-card__action {
            color: var(--primary);
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .empty-state {
            background: var(--card-bg);
            border-radius: var(--radius-lg);
            border: 1px dashed var(--border);
            padding: 60px 30px;
            text-align: center;
            color: var(--text-muted);
            box-shadow: var(--shadow);
        }
        .empty-state i {
            font-size: 42px;
            color: #94a3b8;
            margin-bottom: 20px;
        }
        .empty-state a {
            margin-top: 22px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 22px;
            border-radius: 999px;
            background: var(--primary);
            color: #fff;
            font-weight: 600;
            box-shadow: 0 18px 34px -18px rgba(37, 99, 235, 0.65);
        }
        .alert {
            margin-top: 24px;
            padding: 16px 20px;
            border-radius: var(--radius-md);
            border: 1px solid #fecaca;
            background: #fef2f2;
            color: #b91c1c;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }
        @media (max-width: 720px) {
            .page { padding: 32px 18px 48px; }
            .booking-card { padding: 24px 20px; }
            .booking-card__body { grid-template-columns: 1fr; }
            .page__title { font-size: 26px; }
        }
    </style>
</head>
<body>
<div class="page">
    <div class="page__header">
        <div class="page__header-top">
            <a class="back-link" href="${pageContext.request.contextPath}/Home">
                <i class="fas fa-arrow-left"></i> Quay lại trang chủ
            </a>
        </div>
        <div>
            <h1 class="page__title">Booking Của Tôi</h1>
            <p class="page__subtitle">Theo dõi các chuyến đi và trải nghiệm đã đặt tại Cát Bà.</p>
        </div>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-card__label">Tổng Booking</div>
            <div class="stat-card__value">${totalCount}</div>
            <div class="stat-card__caption">Tất cả trạng thái</div>
        </div>
        <div class="stat-card">
            <div class="stat-card__label">Đã xác nhận</div>
            <div class="stat-card__value">${confirmedCount}</div>
            <div class="stat-card__caption">Booking được duyệt</div>
        </div>
        <div class="stat-card">
            <div class="stat-card__label">Đang chờ</div>
            <div class="stat-card__value">${pendingCount}</div>
            <div class="stat-card__caption">Chờ duyệt / thanh toán</div>
        </div>
        <div class="stat-card">
            <div class="stat-card__label">Đã hủy</div>
            <div class="stat-card__value">${cancelledCount}</div>
            <div class="stat-card__caption">Bị hủy do khách hoặc hệ thống</div>
        </div>
    </div>

    <div class="filters">
        <a class="filter-chip ${activeStatus eq 'all' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/user/bookings?status=all">Tất cả</a>
        <a class="filter-chip ${activeStatus eq 'confirmed' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/user/bookings?status=confirmed">Đã xác nhận</a>
        <a class="filter-chip ${activeStatus eq 'pending' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/user/bookings?status=pending">Đang chờ</a>
        <a class="filter-chip ${activeStatus eq 'cancelled' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/user/bookings?status=cancelled">Đã hủy</a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert">
            <i class="fas fa-exclamation-circle"></i>
            <span>${error}</span>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty bookings}">
            <div class="empty-state">
                <i class="fas fa-calendar-times"></i>
                <h3>Bạn chưa có đặt chỗ nào</h3>
                <p>Khám phá homestay và nhà hàng để bắt đầu hành trình của bạn.</p>
                <a href="${pageContext.request.contextPath}/homestay-list">
                    <i class="fas fa-compass"></i> Khám phá ngay
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="bookings-list">
                <c:forEach var="booking" items="${bookings}">
                    <div class="booking-card">
                        <div class="booking-card__header">
                            <div>
                                <div class="booking-code">#${booking.bookingCode}</div>
                                <div class="booking-info__sub">${booking.bookerEmail}</div>
                            </div>
                            <span class="status-badge ${booking.statusBadgeClass}">
                                <i class="fas fa-circle"></i> ${booking.statusLabel}
                            </span>
                        </div>
                        <div class="booking-card__body">
                            <div class="booking-info">
                                <div class="booking-info__label">Địa điểm</div>
                                <div class="booking-info__value">
                                    <c:choose>
                                        <c:when test="${booking.business ne null}">${booking.business.name}</c:when>
                                        <c:otherwise>Đang cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                                <c:if test="${booking.business ne null}">
                                    <div class="booking-info__sub">${booking.business.address}</div>
                                </c:if>
                            </div>
                            <div class="booking-info">
                                <div class="booking-info__label">Bắt đầu</div>
                                <div class="booking-info__value">
                                    <c:choose>
                                        <c:when test="${not empty booking.displayReservationStart}">${booking.displayReservationStart}</c:when>
                                        <c:otherwise><em>Chưa cập nhật</em></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="booking-info">
                                <div class="booking-info__label">Kết thúc</div>
                                <div class="booking-info__value">
                                    <c:choose>
                                        <c:when test="${not empty booking.displayReservationEnd}">${booking.displayReservationEnd}</c:when>
                                        <c:otherwise><em>Chưa cập nhật</em></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="booking-info">
                                <div class="booking-info__label">Số khách</div>
                                <div class="booking-info__value">${booking.numGuests} người</div>
                            </div>
                            <div class="booking-info">
                                <div class="booking-info__label">Tổng tiền</div>
                                <div class="booking-info__value">
                                    <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫" groupingUsed="true" maxFractionDigits="0"/>
                                </div>
                            </div>
                        </div>
                        <div class="booking-card__footer">
                            <a href="${pageContext.request.contextPath}/user/booking-detail?id=${booking.bookingId}" class="booking-card__action">
                                Xem chi tiết <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>

