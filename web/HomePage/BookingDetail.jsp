<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            --bg: #f5f7fb;
            --card-bg: #ffffff;
            --primary: #2563eb;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e2e8f0;
            --shadow: 0 25px 50px -20px rgba(15, 23, 42, 0.25);
        }
        * { box-sizing: border-box; }
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: var(--bg);
            margin: 0;
            color: var(--text-main);
        }
        .page {
            max-width: 900px;
            margin: 0 auto;
            padding: 48px 24px 64px;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 24px;
            padding: 10px 18px;
            background: rgba(37, 99, 235, 0.1);
            border-radius: 999px;
        }
        .card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 28px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            margin-bottom: 24px;
        }
        .card-title {
            font-size: 20px;
            font-weight: 700;
            margin: 0 0 20px;
            color: var(--text-main);
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .info-item {
            display: flex;
            flex-direction: column;
        }
        .info-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-muted);
            margin-bottom: 6px;
        }
        .info-value {
            font-size: 16px;
            font-weight: 600;
            color: var(--text-main);
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 999px;
            font-weight: 600;
            font-size: 13px;
        }
        .status-badge.confirmed {
            background: rgba(16, 185, 129, 0.15);
            color: #047857;
        }
        .feedback-section {
            margin-top: 32px;
        }
        .feedback-form {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-main);
        }
        .rating-input {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .rating-input input[type="radio"] {
            display: none;
        }
        .rating-input label {
            font-size: 28px;
            color: #d1d5db;
            cursor: pointer;
            transition: color 0.2s;
        }
        .rating-input input[type="radio"]:checked ~ label,
        .rating-input label:hover,
        .rating-input label:hover ~ label {
            color: #fbbf24;
        }
        .rating-input input[type="radio"]:checked ~ label {
            color: #f59e0b;
        }
        .form-group textarea {
            padding: 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-family: inherit;
            font-size: 14px;
            min-height: 120px;
            resize: vertical;
        }
        .btn-submit {
            background: var(--primary);
            color: #fff;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            font-size: 15px;
        }
        .btn-submit:hover {
            background: #1d4ed8;
        }
        .alert {
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success {
            background: #ecfdf5;
            color: #047857;
            border: 1px solid #a7f3d0;
        }
        .alert-error {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }
        .existing-review {
            background: #f8fafc;
            padding: 16px;
            border-radius: 8px;
            border: 1px solid var(--border);
        }
        .existing-review p {
            margin: 0;
            color: var(--text-muted);
        }
    </style>
</head>
<body>
<div class="page">
    <a href="${pageContext.request.contextPath}/user/bookings" class="back-link">
        <i class="fas fa-arrow-left"></i> Quay lại danh sách booking
    </a>

    <c:if test="${not empty error}">
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <span>${error}</span>
        </div>
    </c:if>

    <c:if test="${not empty feedbackSuccess}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>${feedbackSuccess}</span>
        </div>
    </c:if>

    <c:if test="${not empty feedbackError}">
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <span>${feedbackError}</span>
        </div>
    </c:if>

    <c:if test="${not empty booking}">
        <div class="card">
            <h2 class="card-title">Thông tin Booking</h2>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Mã Booking</div>
                    <div class="info-value">#${booking.bookingCode}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Trạng thái</div>
                    <span class="status-badge ${booking.statusBadgeClass}">
                        <i class="fas fa-circle"></i> ${booking.statusLabel}
                    </span>
                </div>
                <div class="info-item">
                    <div class="info-label">Cơ sở</div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${booking.business ne null}">${booking.business.name}</c:when>
                            <c:otherwise>Đang cập nhật</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Loại hình</div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${booking.business ne null}">${booking.business.type}</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Địa chỉ</div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${booking.business ne null}">${booking.business.address}</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Người đặt</div>
                    <div class="info-value">${booking.bookerName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Email</div>
                    <div class="info-value">${booking.bookerEmail}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Số điện thoại</div>
                    <div class="info-value">${booking.bookerPhone}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Số khách</div>
                    <div class="info-value">${booking.numGuests} người</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Tổng tiền</div>
                    <div class="info-value">
                        <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫" groupingUsed="true" maxFractionDigits="0"/>
                    </div>
                </div>
                <c:if test="${not empty booking.displayReservationStart}">
                    <div class="info-item">
                        <div class="info-label">Thời gian bắt đầu</div>
                        <div class="info-value">${booking.displayReservationStart}</div>
                    </div>
                </c:if>
                <c:if test="${not empty booking.displayReservationEnd}">
                    <div class="info-item">
                        <div class="info-label">Thời gian kết thúc</div>
                        <div class="info-value">${booking.displayReservationEnd}</div>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="card feedback-section">
            <h2 class="card-title">Đánh giá dịch vụ</h2>
            <c:choose>
                <c:when test="${not empty existingReview}">
                    <div class="existing-review">
                        <p><strong>Bạn đã gửi đánh giá:</strong></p>
                        <p>Đánh giá: ${existingReview.rating} sao</p>
                        <p>Nội dung: ${existingReview.comment}</p>
                        <p>Trạng thái: 
                            <c:choose>
                                <c:when test="${existingReview.status eq 'approved'}">Đã được duyệt</c:when>
                                <c:when test="${existingReview.status eq 'pending'}">Đang chờ duyệt</c:when>
                                <c:otherwise>Đang chờ duyệt</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:when test="${booking.status ne 'confirmed'}">
                    <div class="existing-review">
                        <p><strong>Chưa thể đánh giá</strong></p>
                        <p>Bạn chỉ có thể đánh giá khi booking đã được xác nhận thành công.</p>
                        <p>Trạng thái hiện tại: 
                            <c:choose>
                                <c:when test="${booking.status eq 'pending'}">Đang chờ xác nhận</c:when>
                                <c:when test="${booking.status eq 'cancelled_by_user' or booking.status eq 'cancelled_by_owner'}">Đã hủy</c:when>
                                <c:otherwise>${booking.status}</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/user/submit-feedback" method="post" class="feedback-form">
                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                        <div class="form-group">
                            <label>Đánh giá (1-5 sao)</label>
                            <div class="rating-input">
                                <input type="radio" id="star5" name="rating" value="5" required>
                                <label for="star5">★</label>
                                <input type="radio" id="star4" name="rating" value="4" required>
                                <label for="star4">★</label>
                                <input type="radio" id="star3" name="rating" value="3" required>
                                <label for="star3">★</label>
                                <input type="radio" id="star2" name="rating" value="2" required>
                                <label for="star2">★</label>
                                <input type="radio" id="star1" name="rating" value="1" required>
                                <label for="star1">★</label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="comment">Nội dung đánh giá</label>
                            <textarea id="comment" name="comment" placeholder="Chia sẻ trải nghiệm của bạn..." required></textarea>
                        </div>
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-paper-plane"></i> Gửi đánh giá
                        </button>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>
</div>
</body>
</html>

