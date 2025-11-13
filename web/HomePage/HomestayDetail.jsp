<%-- 
    Document   : HomestayDetail
    Created on : Oct 29, 2025
    Author     : ADMIN - ĐÃ SỬA HOÀN CHỈNH 07/11/2025
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>${homestay.name} | Chi tiết Homestay - Cát Bà Booking</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-homestaydetail.css" />
        <style>
            .sticky-search-bar {
                position: sticky;
                top: 0;
                background: white;
                z-index: 1000;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 12px 0;
                border-bottom: 1px solid #eee;
            }
            .date-input-group {
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .mini-input-wrapper {
                position: relative;
            }
            .mini-input-wrapper i {
                position: absolute;
                left: 10px;
                top: 50%;
                transform: translateY(-50%);
                color: #666;
                font-size: 0.9rem;
            }
            .mini-input {
                padding-left: 32px !important;
                height: 38px;
                font-size: 0.9rem;
            }
            .sticky-search-btn {
                background: #28a745;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .sticky-search-btn:hover {
                background: #218838;
            }
            .alert {
                background: #f8d7da;
                color: #721c24;
                padding: 15px;
                border-radius: 8px;
                margin: 15px 0;
            }
        </style>
    </head>
    <body>

        <%@ include file="Sidebar.jsp" %>

        <!-- Sticky Search Bar -->
        <div class="sticky-search-bar" id="stickySearchBar">
            <div class="sticky-inner container">
                <div class="sticky-block">
                    <div class="sticky-icon"><i class="fa-solid fa-location-dot"></i></div>
                    <div class="sticky-text">
                        <div class="sticky-label">Chỗ ở</div>
                        <div class="sticky-value" id="stayName">${homestay.name}</div>
                    </div>
                </div>

                <div class="sticky-block">
                    <div class="sticky-icon"><i class="fa-regular fa-calendar"></i></div>
                    <div class="sticky-text">
                        <div class="sticky-label">Lịch ở</div>
                        <div class="sticky-value" id="stayDates">
                            <div class="date-input-group">
                                <input type="date" id="checkin" name="checkIn" class="sticky-input" 
                                       min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />" 
                                       value="${not empty checkIn ? checkIn : ''}">
                                <i class="fa-solid fa-arrow-right"></i>
                                <input type="date" id="checkout" name="checkOut" class="sticky-input" 
                                       min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />" 
                                       value="${not empty checkOut ? checkOut : ''}">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="sticky-block guests-block-simple">
                    <div class="sticky-icon"><i class="fa-solid fa-user-group"></i></div>
                    <div class="sticky-text">
                        <div class="guest-room-inline">
                            <div class="mini-field">
                                <label class="mini-label">Số người</label>
                                <div class="mini-input-wrapper">
                                    <i class="fa-solid fa-users"></i>
                                    <input type="number" name="guests" id="guestsInput" class="mini-input" min="1" 
                                           value="${not empty guests ? guests : '2'}" />
                                </div>
                            </div>
                            <div class="mini-field">
                                <label class="mini-label">Số phòng</label>
                                <div class="mini-input-wrapper">
                                    <i class="fa-solid fa-door-open"></i>
                                    <input type="number" name="rooms" id="roomsInput" class="mini-input" min="1" 
                                           value="${not empty numRooms ? numRooms : '1'}" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <button class="sticky-search-btn" onclick="performSearch()">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <span>Kiểm tra phòng trống</span>
                </button>
            </div>
        </div>

        <section class="detail-hero">
            <div class="container">
                <div class="gallery-layout">
                    <div class="main-photo">
                        <img src="${homestay.image}" alt="Ảnh chính của ${homestay.name}" />
                    </div>
                    <div class="side-photos">
                        <div class="side-photo">
                            <img src="https://khudothixanhvn.com/wp-content/uploads/2023/03/homestay-ecopark-banner-01.jpg" alt="Ảnh phụ 1" />
                        </div>
                        <div class="side-photo">
                            <img src="https://khudothixanhvn.com/wp-content/uploads/2023/03/homestay-ecopark-banner-01.jpg" alt="Ảnh phụ 2" />
                        </div>
                    </div>
                </div>

                <div class="stay-header">
                    <div class="stay-info">
                        <div class="stay-name">
                            <h1>${homestay.name}</h1>
                            <span class="badge-type"><i class="fa-solid fa-leaf"></i> Homestay</span>
                        </div>
                        <div class="rating-row">
                            <div class="rating-score">${homestay.avgRating}</div>
                            <div class="rating-details">
                                <div class="stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="${i <= homestay.avgRating.intValue() ? 'fa-solid' : 'fa-regular'} fa-star"></i>
                                    </c:forEach>
                                </div>
                                <span>
                                    ${homestay.avgRating >= 4.5 ? 'Tuyệt vời' : 
                                      homestay.avgRating >= 4 ? 'Rất tốt' : 
                                      homestay.avgRating >= 3 ? 'Tốt' : 'Trung bình'}
                                </span>
                                <span>• ${homestay.reviewCount} đánh giá</span>
                            </div>
                        </div>
                        <div class="stay-location">
                            <i class="fa-solid fa-location-dot"></i>
                            <span>${homestay.address}</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="detail-content">
            <div class="detail-layout">
                <div class="left-col">
                    <!-- Mô tả -->
                    <div class="section-card" id="description">
                        <div class="section-title">
                            <i class="fa-solid fa-circle-info"></i> <span>Mô tả chỗ nghỉ</span>
                        </div>
                        <div class="desc-text">${homestay.description}</div>
                    </div>

                    <!-- Tiện nghi -->
                    <div class="section-card" id="amenities">
                        <div class="section-title">
                            <i class="fa-solid fa-screwdriver-wrench"></i> <span>Tiện nghi nổi bật</span>
                        </div>
                        <div class="amenities-list">
                            <c:forEach var="amenity" items="${homestay.amenities}">
                                <div class="amenity-pill">
                                    <i class="fa-solid ${amenity.name == 'WiFi miễn phí' ? 'fa-wifi' : amenity.name == 'Bữa sáng' ? 'fa-mug-hot' : amenity.name == 'Bãi đỗ xe miễn phí' ? 'fa-car' : 'fa-leaf'}"></i>
                                    <span>${amenity.name}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Phòng còn trống -->
                    <div class="section-card" id="rooms">
                        <div class="section-title">
                            <i class="fa-solid fa-bed"></i> <span>Phòng còn trống</span>
                        </div>

                        <c:if test="${not empty roomMessage}">
                            <div class="alert">
                                <i class="fa-solid fa-exclamation-triangle"></i> ${roomMessage}
                            </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${empty availableRooms}">
                                <div class="alert">
                                    <i class="fa-solid fa-ban"></i>
                                    Không có phòng nào còn trống phù hợp với yêu cầu của bạn. Vui lòng thử:
                                    <ul style="margin-top: 10px; margin-left: 20px;">
                                        <li>Chọn ngày khác</li>
                                        <li>Giảm số phòng hoặc số người</li>
                                        <li>Liên hệ chủ homestay để được tư vấn</li>
                                    </ul>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="room" items="${availableRooms}">
                                    <div class="room-card">
                                        <div class="room-img">
                                            <c:choose>
                                                <c:when test="${not empty room.images}">
                                                    <img src="${room.images[0]}" alt="${room.name}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://ik.imagekit.io/tvlk/apr-asset/Ixf4aptF5N2Qdfmh4fGGYhTN274kJXuNMkUAzpL5HuD9jzSxIGG5kZNhhHY-p7nw/hotel/asset/20069497-e3072077bf4971aef62c6f6dd1c9cfa9.jpeg" alt="${room.name}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="room-body">
                                            <div class="room-top">
                                                <div class="room-info">
                                                    <h3>${room.name}</h3>
                                                    <div class="room-meta">
                                                        <span><i class="fa-solid fa-user-group"></i> ${room.capacity} khách</span>
                                                        <span><i class="fa-solid fa-bed"></i> 1 giường đôi</span>
                                                        <span><i class="fa-solid fa-wifi"></i> WiFi</span>
                                                    </div>
                                                </div>
                                                <div class="room-price">
                                                    <div class="current-price">
                                                        <fmt:formatNumber value="${room.price}" pattern="#,###"/>đ
                                                    </div>

                                                </div>
                                            </div>
                                            <div class="room-bottom">
                                                <div class="availability-tag">
                                                    <i class="fa-solid fa-circle-check"></i> <span>Còn trống</span>
                                                </div>
                                                <button class="book-btn" onclick="bookRoom(${room.roomId})">
                                                    Đặt phòng này
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Chính sách -->
                    <div class="section-card" id="policy">
                        <div class="section-title">
                            <i class="fa-solid fa-file-shield"></i> <span>Chính sách lưu trú</span>
                        </div>
                        <div class="desc-text" style="font-size:.875rem;">
                            - Nhận phòng: sau 14:00<br/>
                            - Trả phòng: trước 12:00<br/>
                            - Hủy miễn phí trước 3 ngày<br/>
                            - Không hút thuốc trong phòng<br/>
                        </div>
                    </div>

                    <!-- Đánh giá -->
                    <div class="section-card" id="reviews">
                        <div class="section-title">
                            <i class="fa-solid fa-comments"></i> <span>Đánh giá từ khách</span>
                        </div>
                        <div class="review-summary">
                            <div class="review-score-box">
                                <div class="big">${homestay.avgRating}</div>
                                <div style="font-size:.75rem;">
                                    ${homestay.avgRating >= 4.5 ? 'Tuyệt vời' : 
                                      homestay.avgRating >= 4 ? 'Rất tốt' : 
                                      homestay.avgRating >= 3 ? 'Tốt' : 'Trung bình'}
                                </div>
                            </div>
                            <div class="review-text">
                                <c:forEach var="review" items="${reviews}" begin="0" end="2">
                                    <p>
                                        "${review.comment}"<br/><br/>
                                        — ${review.user.fullName}, 
                                        ${review.createdAt.toLocalDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))}
                                    </p>
                                </c:forEach>
                                <c:if test="${empty reviews}">
                                    <p>Chưa có đánh giá nào cho homestay này.</p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bên phải: Bản đồ & Chủ nhà -->
                <div class="right-col">
                    <div class="section-card map-card" id="map">
                        <div class="section-title">
                            <i class="fa-solid fa-map-location-dot"></i> <span>Vị trí trên bản đồ</span>
                        </div>
                        <iframe
                            src="https://maps.google.com/maps?q=${homestay.name}&t=&z=15&ie=UTF8&iwloc=&output=embed"
                            loading="lazy"
                            referrerpolicy="no-referrer-when-downgrade">
                        </iframe>
                        <p style="font-size:.8rem; color:#6b7280; margin-top:.5rem;">
                            Gần trung tâm Cát Bà • Thuận tiện thuê xe máy • Dễ đi ra bến tàu Lan Hạ
                        </p>
                    </div>

                    <div class="section-card host-card">
                        <div class="section-title">
                            <i class="fa-solid fa-user-tie"></i> <span>Chủ nhà</span>
                        </div>
                        <div class="host-header">
                            <div class="host-avatar">
                                ${homestay.owner.fullName != null ? homestay.owner.fullName.substring(0, 2).toUpperCase() : 'NN'}
                            </div>
                            <div class="host-name-role">
                                <span>${homestay.owner.fullName}</span>
                                <span>Chủ homestay</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <%@ include file="Footer.jsp" %>

        <script>
        const businessId = ${homestay.businessId};

        // Lấy references đến các input
        const guestsInput = document.getElementById('guestsInput');
        const roomsInput = document.getElementById('roomsInput');

        // Validation số phòng <= số khách
        function validateRoomGuest() {
            const guests = parseInt(guestsInput.value) || 1;
            const rooms = parseInt(roomsInput.value) || 1;
            if (rooms > guests) {
                alert('Số lượng phòng không được nhiều hơn số lượng khách!');
                roomsInput.value = guests;
            }
        }

        guestsInput.addEventListener('input', validateRoomGuest);
        roomsInput.addEventListener('input', validateRoomGuest);

        // Tìm kiếm phòng
        function performSearch() {
            validateRoomGuest();

            const checkIn = document.getElementById('checkin').value;
            const checkOut = document.getElementById('checkout').value;
            const guests = guestsInput.value || 2;
            const numRooms = roomsInput.value || 1;

            console.log('Check-in:', checkIn);
            console.log('Check-out:', checkOut);
            console.log('Guests:', guests);
            console.log('Rooms:', numRooms);

            if (!checkIn || !checkOut) {
                alert('Vui lòng chọn ngày nhận phòng và trả phòng!');
                return;
            }
            if (new Date(checkIn) >= new Date(checkOut)) {
                alert('Ngày trả phòng phải sau ngày nhận phòng!');
                return;
            }

            // Tạo URL với tất cả parameters
            const url = new URL(window.location.origin + '${pageContext.request.contextPath}/homestay-detail');
            url.searchParams.append('id', businessId);
            url.searchParams.append('checkIn', checkIn);
            url.searchParams.append('checkOut', checkOut);
            url.searchParams.append('guests', guests);
            url.searchParams.append('numRooms', numRooms);

            console.log('Redirecting to:', url.toString());
            window.location.href = url.toString();
        }

        // Đặt phòng (mở rộng sau)
        function bookRoom(roomId) {
            const checkIn = document.getElementById('checkin').value;
            const checkOut = document.getElementById('checkout').value;
            const guests = document.getElementById('guestsInput').value;

            if (!checkIn || !checkOut) {
                alert('Vui lòng chọn ngày nhận phòng và trả phòng trước khi đặt!');
                return;
            }

            // [QUAN TRỌNG] Sửa URL thành checkout-homestay
            window.location.href = '${pageContext.request.contextPath}/checkout-homestay?roomId=' + roomId + '&checkIn=' + checkIn + '&checkOut=' + checkOut + '&guests=' + guests;
        }
        </script>
    </body>
</html>