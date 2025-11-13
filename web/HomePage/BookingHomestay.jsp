<%-- 
    Document   : BookingHomestay
    Created on : Nov 13, 2025, 4:12:12 PM
    Author     : jackd
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt phòng Homestay | Cát Bà Booking</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css">
    <style>
        body { background-color: #f8f9fa; }
        .booking-container { max-width: 1100px; margin: 40px auto; }
        .room-card { 
            border: none; 
            border-radius: 12px; 
            padding: 25px; 
            background: #fff; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .room-img { 
            width: 100%; 
            height: 220px; 
            object-fit: cover; 
            border-radius: 8px; 
            margin-bottom: 15px;
        }
        .price-summary { font-size: 1.1rem; border-top: 2px dashed #eee; padding-top: 15px; margin-top: 15px; }
        .total-price { color: #198754; font-size: 1.6rem; font-weight: 800; }
        .section-title { font-weight: 700; color: #333; margin-bottom: 20px; }
    </style>
</head>
<body>
    <jsp:include page="Sidebar.jsp" />

    <div class="container booking-container">
        <div class="mb-4">
            <a href="javascript:history.back()" class="text-decoration-none text-secondary"><i class="bi bi-arrow-left"></i> Quay lại</a>
            <h2 class="mt-2 fw-bold text-primary">Xác nhận đặt phòng</h2>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger border-0 shadow-sm mb-4"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div>
        </c:if>

        <form action="booking-homestay" method="POST" id="bookingForm">
            <input type="hidden" name="roomId" value="${room.roomId}">
            <input type="hidden" name="minDate" value="${minDate}">
            <input type="hidden" name="maxDate" value="${maxDate}">
            <input type="hidden" id="pricePerNight" value="${room.pricePerNight}">

            <div class="row">
                <div class="col-md-7">
                    <div class="room-card mb-4">
                        <h5 class="section-title"><i class="bi bi-person-lines-fill text-primary me-2"></i>Thông tin liên hệ</h5>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control py-2" name="fullName" value="${userFullName}" placeholder="Nhập họ tên người nhận phòng" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="tel" class="form-control py-2" name="phone" value="${userPhone}" placeholder="0912xxxxxx" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control py-2" name="email" value="${userEmail}" placeholder="example@email.com" required>
                            </div>
                        </div>
                        <div class="mb-0">
                            <label class="form-label fw-bold">Ghi chú</label>
                            <textarea class="form-control" name="notes" rows="2" placeholder="Lời nhắn cho chủ nhà (giờ đến, yêu cầu đặc biệt...)"></textarea>
                        </div>
                    </div>

                    <div class="room-card">
                        <h5 class="section-title"><i class="bi bi-calendar-check text-primary me-2"></i>Chi tiết chuyến đi</h5>
                        <div class="alert alert-info bg-light border-0 small mb-3">
                            <i class="bi bi-info-circle-fill"></i> Bạn có thể điều chỉnh ngày trong khoảng thời gian đã tìm kiếm: <strong>${minDate}</strong> đến <strong>${maxDate}</strong>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Nhận phòng</label>
                                <input type="date" class="form-control py-2 bg-white" name="checkIn" id="checkIn" 
                                       value="${checkIn}" min="${minDate}" max="${maxDate}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Trả phòng</label>
                                <input type="date" class="form-control py-2 bg-white" name="checkOut" id="checkOut" 
                                       value="${checkOut}" min="${minDate}" max="${maxDate}" required>
                            </div>
                        </div>
                        <div class="mb-0">
                            <label class="form-label fw-bold">Số khách</label>
                            <input type="number" class="form-control py-2" name="guests" value="${guests}" min="1" max="${room.capacity}" required>
                            <small class="text-muted">Phòng này tối đa ${room.capacity} người.</small>
                        </div>
                    </div>
                </div>

                <div class="col-md-5">
                    <div class="room-card sticky-top" style="top: 20px;">
                        <h5 class="section-title border-bottom pb-3 mb-3">Tóm tắt đơn phòng</h5>
                        
                        <c:if test="${not empty room.business.image}">
                            <img src="${room.business.image}" class="room-img shadow-sm" alt="Homestay Image">
                        </c:if>
                        
                        <div class="mb-2">
                            <small class="text-uppercase text-muted fw-bold">Homestay</small>
                            <h5 class="mb-1 text-primary fw-bold">${room.business.name}</h5>
                            <p class="small text-muted mb-0"><i class="bi bi-geo-alt-fill"></i> ${room.business.address}</p>
                        </div>
                        <hr class="my-3">
                        <div class="mb-3">
                            <small class="text-uppercase text-muted fw-bold">Loại phòng</small>
                            <div class="fs-5 fw-bold text-dark">${room.name}</div>
                        </div>
                        
                        <div class="d-flex justify-content-between mb-2">
                            <span>Giá phòng:</span>
                            <span class="fw-bold"><fmt:formatNumber value="${room.pricePerNight}" type="currency" currencyCode="VND"/> / đêm</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Thời gian:</span>
                            <span class="fw-bold"><span id="displayNights">${nights}</span> đêm</span>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center price-summary">
                            <span class="fw-bold text-dark">Tổng cộng:</span>
                            <span class="total-price" id="displayTotal">
                                <fmt:formatNumber value="${totalPrice}" type="currency" currencyCode="VND"/>
                            </span>
                        </div>
                        
                        <button type="submit" class="btn btn-success w-100 mt-4 py-3 fw-bold text-uppercase shadow-sm">
                            Thanh toán ngay <i class="bi bi-chevron-right small"></i>
                        </button>
                        <p class="text-center mt-3 mb-0 small text-muted">
                            <i class="bi bi-shield-check text-success"></i> Thanh toán an toàn qua SePay
                        </p>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script>
        // Tự động tính toán giá khi đổi ngày
        document.addEventListener('DOMContentLoaded', function() {
            const checkInInput = document.getElementById('checkIn');
            const checkOutInput = document.getElementById('checkOut');
            const displayNights = document.getElementById('displayNights');
            const displayTotal = document.getElementById('displayTotal');
            const pricePerNight = parseFloat(document.getElementById('pricePerNight').value);

            function updateTotal() {
                const d1 = new Date(checkInInput.value);
                const d2 = new Date(checkOutInput.value);
                
                if (d1 && d2 && d2 > d1) {
                    const diffTime = Math.abs(d2 - d1);
                    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                    displayNights.textContent = diffDays;
                    const total = diffDays * pricePerNight;
                    displayTotal.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(total);
                } else {
                    displayNights.textContent = "0";
                    displayTotal.textContent = "---";
                }
            }

            checkInInput.addEventListener('change', updateTotal);
            checkOutInput.addEventListener('change', updateTotal);
        });
    </script>
</body>
</html>
