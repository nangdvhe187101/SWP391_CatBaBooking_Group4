<%-- 
    Document   : CheckoutRestaurant
    Created on : Nov 06, 2025
    Author     : FIXED VERSION - Server-side cart with error handling
    Purpose    : Checkout page with form data persistence on errors
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Xác nhận Thanh toán - ${restaurant != null ? restaurant.name : 'Nhà Hàng'}</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-restaurantdetail.css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        .checkout-page {
            padding: 2rem 0;
            background-color: #f9fafb;
            min-height: 80vh;
        }
        .checkout-layout {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
        }
        .form-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            padding: 2rem;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }
        .form-card h2 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            padding-bottom: 1rem;
        }
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.25rem;
        }
        .form-group {
            margin-bottom: 1.25rem;
        }
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        .form-label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: #374151;
            margin-bottom: 0.5rem;
        }
        .form-label .required {
            color: #dc2626;
        }
        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            font-size: 1rem;
            transition: border-color 0.15s ease-in-out;
            box-sizing: border-box;
        }
        .form-input:focus {
            outline: none;
            border-color: #0d6efd;
            box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
        }
        .btn-primary {
            background: #059669;
            color: #fff;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.375rem;
            font-size: 1rem;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.15s ease-in-out;
            font-weight: 600;
        }
        .btn-primary:hover {
            background: #047857;
        }
        .btn-primary:disabled {
            background: #9ca3af;
            cursor: not-allowed;
        }
        .summary-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            padding: 2rem;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            align-self: start;
            position: sticky;
            top: 2rem;
        }
        .summary-card h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 1rem;
        }
        .summary-item {
            display: flex;
            align-items: flex-start;
            padding: 0.75rem 0;
            border-bottom: 1px solid #e5e7eb;
            gap: 0.75rem;
        }
        .summary-item:last-child {
            border-bottom: none;
        }
        .summary-item-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 0.375rem;
            flex-shrink: 0;
        }
        .summary-item-content {
            flex: 1;
            min-width: 0;
        }
        .summary-item-name {
            font-weight: 500;
            margin-bottom: 0.25rem;
            color: #111827;
        }
        .summary-item-meta {
            font-size: 0.875rem;
            color: #6b7280;
            margin-bottom: 0.125rem;
        }
        .summary-item-notes {
            font-size: 0.8rem;
            color: #9ca3af;
            font-style: italic;
            margin-top: 0.25rem;
        }
        .summary-item-price {
            font-weight: 600;
            color: #059669;
            text-align: right;
            white-space: nowrap;
        }
        .total-row {
            border-top: 2px solid #e5e7eb;
            padding-top: 1rem;
            margin-top: 1rem;
            font-size: 1.25rem;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            color: #111827;
        }
        .total-row .total-amount {
            color: #059669;
        }
        .error-message {
            background: #fee2e2;
            color: #dc2626;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            border: 1px solid #fecaca;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .error-message i {
            flex-shrink: 0;
        }
        .table-info {
            background: #dbeafe;
            padding: 1rem;
            border-radius: 0.5rem;
            margin: 1rem 0;
            font-size: 0.875rem;
            color: #1e40af;
            border: 1px solid #bfdbfe;
        }
        .table-info strong {
            color: #1e3a8a;
        }
        .restaurant-info {
            background: #f3f4f6;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }
        .restaurant-info h4 {
            font-size: 1.125rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 0.5rem;
        }
        .restaurant-info p {
            font-size: 0.875rem;
            color: #6b7280;
            margin: 0.25rem 0;
        }
        .empty-cart-warning {
            background: #fef3c7;
            color: #92400e;
            padding: 1.5rem;
            border-radius: 0.5rem;
            text-align: center;
            border: 1px solid #fde68a;
        }
        .empty-cart-warning i {
            font-size: 3rem;
            display: block;
            margin-bottom: 1rem;
            opacity: 0.6;
        }
        @media (max-width: 768px) {
            .checkout-layout {
                grid-template-columns: 1fr;
            }
            .summary-card {
                position: relative;
                top: 0;
            }
        }
    </style>
</head>
<body>
    <%@ include file="Sidebar.jsp" %>

    <div class="checkout-page">
        <div class="checkout-layout">
            <!-- Form Section -->
            <div class="form-card">
                <h2>Thông tin đặt bàn</h2>
                
                <!-- ERROR MESSAGE FROM REQUEST ATTRIBUTE (from doPost via doGet) -->
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>${errorMessage}</span>
                    </div>
                </c:if>
                
                <!-- ERROR MESSAGE FROM URL PARAMETER (from redirect) -->
                <c:if test="${not empty param.error}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        <c:choose>
                            <c:when test="${param.error == 'customer_invalid'}">Thông tin khách hàng không hợp lệ.</c:when>
                            <c:when test="${param.error == 'reservation_invalid'}">Ngày/giờ đặt bàn không hợp lệ.</c:when>
                            <c:when test="${param.error == 'amount_invalid'}">Số tiền không hợp lệ.</c:when>
                            <c:when test="${param.error == 'empty_cart'}">Giỏ hàng trống. Vui lòng thêm món ăn.</c:when>
                            <c:when test="${param.error == 'booking_failed'}">Lỗi tạo đặt bàn. Vui lòng thử lại.</c:when>
                            <c:when test="${param.error == 'dishes_failed'}">Lỗi lưu món ăn.</c:when>
                            <c:when test="${param.error == 'payment_failed'}">Lỗi tạo thanh toán.</c:when>
                            <c:when test="${param.error == 'no_table'}">Không có bàn phù hợp. Vui lòng chọn lại.</c:when>
                            <c:when test="${param.error == 'table_assign_failed'}">Không thể gán bàn.</c:when>
                            <c:when test="${param.error == 'missing_params'}">Thiếu thông tin bắt buộc.</c:when>
                            <c:when test="${param.error == 'invalid_datetime'}">Ngày giờ không hợp lệ.</c:when>
                            <c:otherwise>Lỗi hệ thống. Vui lòng thử lại sau.</c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${empty orderItems}">
                        <div class="empty-cart-warning">
                            <i class="fas fa-shopping-cart"></i>
                            <h3>Giỏ hàng trống</h3>
                            <p>Bạn chưa có món ăn nào trong giỏ hàng.</p>
                            <p style="margin-top: 1rem;">
                                <a href="${pageContext.request.contextPath}/restaurant-detail?id=${restaurantId}" 
                                   style="color: #059669; font-weight: 600;">
                                    ← Quay lại chọn món
                                </a>
                            </p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="restaurant-info">
                            <h4><i class="fas fa-utensils"></i> ${restaurant.name}</h4>
                            <p><i class="fas fa-map-marker-alt"></i> ${restaurant.area.name}, Hải Phòng</p>
                            <p><i class="fas fa-clock"></i> ${restaurant.openingHour} - ${restaurant.closingHour}</p>
                        </div>

                        <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout-restaurant" method="post">
                            <input type="hidden" name="restaurantId" value="${restaurantId}" />
                            
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">
                                        Tên khách hàng <span class="required">*</span>
                                    </label>
                                    <input type="text" 
                                           name="bookerName" 
                                           class="form-input" 
                                           placeholder="Họ và tên đầy đủ" 
                                           value="${not empty bookerName ? bookerName : (currentUser != null ? currentUser.fullName : '')}"
                                           required />
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label">
                                        Số điện thoại <span class="required">*</span>
                                    </label>
                                    <input type="tel" 
                                           name="bookerPhone" 
                                           class="form-input" 
                                           placeholder="0123456789" 
                                           pattern="[0-9]{10,11}"
                                           value="${not empty bookerPhone ? bookerPhone : (currentUser != null ? currentUser.phone : '')}"
                                           required />
                                </div>
                                
                                <div class="form-group full-width">
                                    <label class="form-label">
                                        Email <span class="required">*</span>
                                    </label>
                                    <input type="email" 
                                           name="bookerEmail" 
                                           class="form-input" 
                                           placeholder="email@example.com" 
                                           value="${not empty bookerEmail ? bookerEmail : (currentUser != null ? currentUser.email : '')}"
                                           required />
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label">
                                        Ngày đặt bàn <span class="required">*</span>
                                    </label>
                                    <input type="date" 
                                           name="reservationDate" 
                                           id="reservationDate"
                                           class="form-input" 
                                           min="${currentDate}"
                                           value="${not empty reservationDate ? reservationDate : ''}"
                                           required />
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label">
                                        Giờ đặt bàn <span class="required">*</span>
                                    </label>
                                    <input type="time" 
                                           name="reservationTime" 
                                           id="reservationTime"
                                           class="form-input" 
                                           value="${not empty reservationTime ? reservationTime : ''}"
                                           required />
                                </div>
                                
                                <div class="form-group full-width">
                                    <label class="form-label">
                                        Số lượng khách <span class="required">*</span>
                                    </label>
                                    <input type="number" 
                                           name="numGuests" 
                                           id="numGuests" 
                                           class="form-input" 
                                           min="1" 
                                           max="20" 
                                           value="${not empty numGuests ? numGuests : 2}" 
                                           required />
                                    <small style="color: #6b7280; font-size: 0.875rem;">
                                        Số khách từ 1-20 người
                                    </small>
                                </div>
                            </div>

                            <div id="tableInfo" class="table-info" style="display: none;">
                                <strong><i class="fas fa-chair"></i> Bàn được gợi ý:</strong> 
                                <span id="assignedTable"></span>
                            </div>

                            <button type="submit" id="submitBtn" class="btn-primary">
                                <i class="fas fa-check-circle"></i> Xác nhận đặt bàn
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Summary Section -->
            <div class="summary-card">
                <h3><i class="fas fa-receipt"></i> Chi tiết đơn hàng</h3>
                
                <c:choose>
                    <c:when test="${not empty orderItems}">
                        <div id="orderSummary">
                            <c:set var="grandTotal" value="0" />
                            <c:forEach var="item" items="${orderItems}">
                                <c:set var="subtotal" value="${item.priceAtBooking * item.quantity}" />
                                <c:set var="grandTotal" value="${grandTotal + subtotal}" />
                                
                                <div class="summary-item">
                                    <img src="${item.dishImage}" 
                                         alt="${item.dishName}" 
                                         class="summary-item-image" 
                                         onerror="this.src='https://via.placeholder.com/60x60/28a745/ffffff?text=Món'" />
                                    
                                    <div class="summary-item-content">
                                        <div class="summary-item-name">${item.dishName}</div>
                                        <div class="summary-item-meta">
                                            SL: ${item.quantity} × 
                                            <fmt:formatNumber value="${item.priceAtBooking}" pattern="#,###"/> ₫
                                        </div>
                                        <c:if test="${not empty item.notes}">
                                            <div class="summary-item-notes">
                                                <i class="fas fa-comment-dots"></i> ${item.notes}
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <div class="summary-item-price">
                                        <fmt:formatNumber value="${subtotal}" pattern="#,###"/> ₫
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="total-row">
                            <span>Tổng cộng:</span>
                            <span class="total-amount">
                                <fmt:formatNumber value="${grandTotal}" pattern="#,###"/> ₫
                            </span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align: center; color: #9ca3af; padding: 2rem 0;">
                            <i class="fas fa-shopping-cart" style="font-size: 3rem; display: block; margin-bottom: 1rem; opacity: 0.3;"></i>
                            Chưa có món ăn
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <%@ include file="Footer.jsp" %>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('reservationDate');
            const timeInput = document.getElementById('reservationTime');
            const numGuestsInput = document.getElementById('numGuests');
            
            // Set default date to today if not already set
            if (dateInput && !dateInput.value) {
                const today = new Date().toISOString().split('T')[0];
                dateInput.value = today;
            }
            
            // Set default time to 2 hours from now if not already set
            if (timeInput && !timeInput.value) {
                const now = new Date();
                now.setHours(now.getHours() + 2);
                const hours = String(now.getHours()).padStart(2, '0');
                const minutes = String(now.getMinutes()).padStart(2, '0');
                timeInput.value = hours + ':' + minutes;
            }
            
            // Validate number of guests
            if (numGuestsInput) {
                numGuestsInput.addEventListener('change', function() {
                    const num = parseInt(this.value);
                    if (num < 1) {
                        this.value = 1;
                        alert('Số khách tối thiểu là 1 người.');
                    } else if (num > 20) {
                        this.value = 20;
                        alert('Số khách tối đa là 20 người.');
                    }
                });
            }
            
            // Form submission handling
            const checkoutForm = document.getElementById('checkoutForm');
            if (checkoutForm) {
                checkoutForm.addEventListener('submit', function(e) {
                    const submitBtn = document.getElementById('submitBtn');
                    
                    // Validate date is not in the past
                    const selectedDate = new Date(dateInput.value);
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    
                    if (selectedDate < today) {
                        e.preventDefault();
                        alert('Ngày đặt bàn không thể là ngày trong quá khứ!');
                        return false;
                    }
                    
                    // Disable submit button to prevent double submission
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                    
                    console.log('Submitting checkout form:', {
                        restaurantId: document.querySelector('[name="restaurantId"]').value,
                        bookerName: document.querySelector('[name="bookerName"]').value,
                        bookerPhone: document.querySelector('[name="bookerPhone"]').value,
                        bookerEmail: document.querySelector('[name="bookerEmail"]').value,
                        reservationDate: dateInput.value,
                        reservationTime: timeInput.value,
                        numGuests: numGuestsInput.value
                    });

                    return true;
                });
            }

            // Optional: Check table availability preview (can be implemented later)
            const checkTableAvailability = () => {
                const restaurantId = '${restaurantId}';
                const numGuests = numGuestsInput ? numGuestsInput.value : 2;
                const date = dateInput ? dateInput.value : '';
                const time = timeInput ? timeInput.value : '';

                if (date && time && numGuests && restaurantId) {
                    console.log('Checking table for:', {restaurantId, numGuests, date, time});
                    // TODO: Implement AJAX call to check-available-table endpoint
                }
            };

            // Attach listeners for real-time table checking (optional)
            if (numGuestsInput) numGuestsInput.addEventListener('change', checkTableAvailability);
            if (dateInput) dateInput.addEventListener('change', checkTableAvailability);
            if (timeInput) timeInput.addEventListener('change', checkTableAvailability);
        });
    </script>
</body>
</html>