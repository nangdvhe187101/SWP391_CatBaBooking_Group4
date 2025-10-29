<%-- 
    Document   : HomestayDetail
    Created on : Oct 29, 2025, 3:06:09 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Cat Ba Eco Garden Homestay | Chi tiết</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-homestaydetail.css" />
    </head>
    <body>

        <%@ include file="Sidebar.jsp" %>

        <div class="sticky-search-bar" id="stickySearchBar">
            <div class="sticky-inner container">
                <div class="sticky-block">
                    <div class="sticky-icon">
                        <i class="fa-solid fa-location-dot"></i>
                    </div>
                    <div class="sticky-text">
                        <div class="sticky-label">Chỗ ở</div>
                        <div class="sticky-value" id="stayName">
                            <%= request.getAttribute("businessName") != null ? request.getAttribute("businessName") : "Cat Ba Eco Garden Homestay" %>
                        </div>
                    </div>
                </div>
                <div class="sticky-block">
                    <div class="sticky-icon">
                        <i class="fa-regular fa-calendar"></i>
                    </div>
                    <div class="sticky-text">
                        <div class="sticky-label">Lịch ở</div>
                        <div class="sticky-value" id="stayDates">
                            <div class="date-input-group">
                                <input type="date" id="checkin" name="checkIn" class="sticky-input" 
                                       min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />" 
                                       value="${param.checkIn}">
                                <i class="fa-solid fa-arrow-right"></i>
                                <input type="date" id="checkout" name="checkOut" class="sticky-input" 
                                       min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />" 
                                       value="${param.checkOut}">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="sticky-block guests-block-simple">
                    <div class="sticky-icon">
                        <i class="fa-solid fa-user-group"></i>
                    </div>
                    <div class="sticky-text" style="width:100%;">
                        <div class="guest-room-inline">
                            <div class="mini-field">
                                <label class="mini-label">Số người</label>
                                <div class="mini-input-wrapper">
                                    <i class="fa-solid fa-users"></i>
                                    <input
                                        type="number"
                                        name="adults"
                                        class="mini-input"
                                        min="1"
                                        value="2"
                                        />
                                </div>
                            </div>
                            <div class="mini-field">
                                <label class="mini-label">Số phòng</label>
                                <div class="mini-input-wrapper">
                                    <i class="fa-solid fa-door-open"></i>
                                    <input
                                        type="number"
                                        name="rooms"
                                        class="mini-input"
                                        min="1"
                                        value="1"
                                        />
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
            <div class="sticky-nav container">
            </div>
        </div>
        <section class="detail-hero">
            <div class="container">
                <div class="gallery-layout">
                    <div class="main-photo">
                        <img src="https://sinhtour.vn/wp-content/uploads/2024/07/homestay-cat-ba-10.jpg" alt="Ảnh chính homestay" />
                    </div>
                    <div class="side-photos">
                        <div class="side-photo">
                            <img src="https://cf.bstatic.com/xdata/images/hotel/max1024x768/733132235.jpg?k=651e0dc21e3855a50d1bf760010c0653a300c01b0ce6c354df8a047da1c6537f&o=&hp=1" alt="Ảnh phụ 1" />
                        </div>
                        <div class="side-photo">
                            <img src="https://khudothixanhvn.com/wp-content/uploads/2023/03/homestay-ecopark-banner-01.jpg" alt="Ảnh phụ 2" />
                        </div>
                    </div>
                </div>
                <div class="stay-header">
                    <div class="stay-info">
                        <div class="stay-name">
                            <h1>
                                <%= request.getAttribute("businessName") != null ? request.getAttribute("businessName") : "Cat Ba Eco Garden Homestay" %>
                            </h1>
                            <span class="badge-type"><i class="fa-solid fa-leaf"></i> Homestay xanh</span>
                        </div>
                        <div class="rating-row">
                            <div class="rating-score">
                                <%= request.getAttribute("ratingScore") != null ? request.getAttribute("ratingScore") : "9.2" %>
                            </div>
                            <div class="rating-details">
                                <div class="stars">
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-regular fa-star"></i>
                                </div>
                                <span>Rất tốt</span>
                                <span>• <%= request.getAttribute("reviewCount") != null ? request.getAttribute("reviewCount") : "128" %> đánh giá</span>
                            </div>
                        </div>

                        <div class="stay-location">
                            <i class="fa-solid fa-location-dot"></i>
                            <span>
                                <%= request.getAttribute("businessAddress") != null ? request.getAttribute("businessAddress") : "Số 5 Núi Ngọc, Thị trấn Cát Bà, Hải Phòng" %>
                            </span>
                            <a href="#map" style="color:#059669; text-decoration:underline; font-size:.8rem;">Xem bản đồ</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section class="detail-content">
            <div class="detail-layout">
                <div class="left-col">
                    <div class="section-card" id="description">
                        <div class="section-title">
                            <i class="fa-solid fa-circle-info"></i>
                            <span>Mô tả chỗ nghỉ</span>
                        </div>
                        <div class="desc-text">
                            <%= request.getAttribute("businessDescription") != null
                                ? request.getAttribute("businessDescription")
                                : "Homestay thân thiện với môi trường, có vườn xanh, bếp chung, gần biển. Chỗ nghỉ yên tĩnh, phù hợp gia đình, nhóm bạn hoặc cặp đôi muốn chill cuối tuần. Chủ nhà thân thiện, có thể hỗ trợ thuê xe máy, tour vịnh Lan Hạ." %>
                        </div>
                    </div>
                    <div class="section-card" id="amenities">
                        <div class="section-title">
                            <i class="fa-solid fa-screwdriver-wrench"></i>
                            <span>Tiện nghi nổi bật</span>
                        </div>
                        <div class="amenities-list">
                            <div class="amenity-pill">
                                <i class="fa-solid fa-wifi"></i>
                                <span>WiFi miễn phí</span>
                            </div>
                            <div class="amenity-pill">
                                <i class="fa-solid fa-mug-hot"></i>
                                <span>Bữa sáng</span>
                            </div>
                            <div class="amenity-pill">
                                <i class="fa-solid fa-leaf"></i>
                                <span>Vườn riêng</span>
                            </div>
                            <div class="amenity-pill">
                                <i class="fa-solid fa-water-ladder"></i>
                                <span>Gần bãi biển</span>
                            </div>
                        </div>
                    </div>
                    <div class="section-card" id="rooms">
                        <div class="section-title">
                            <i class="fa-solid fa-bed"></i>
                            <span>Phòng còn trống</span>
                        </div>
                        <div class="room-card">
                            <div class="room-img">
                                <img src="https://ik.imagekit.io/tvlk/apr-asset/Ixf4aptF5N2Qdfmh4fGGYhTN274kJXuNMkUAzpL5HuD9jzSxIGG5kZNhhHY-p7nw/hotel/asset/20069497-e3072077bf4971aef62c6f6dd1c9cfa9.jpeg?_src=imagekit&tr=c-at_max,f-jpg,fo-auto,h-203,pr-true,q-80,w-300"
                                     alt="Phòng Đôi View Biển" />
                            </div>
                            <div class="room-body">
                                <div class="room-top">
                                    <div class="room-info">
                                        <h3>
                                            <%= request.getAttribute("roomName") != null ? request.getAttribute("roomName") : "Phòng Đôi View Biển" %>
                                        </h3>
                                        <div class="room-meta">
                                            <span><i class="fa-solid fa-user-group"></i>
                                                <%= request.getAttribute("roomCapacity") != null ? request.getAttribute("roomCapacity") : "2" %> khách
                                                <!-- TODO: rooms.capacity -->
                                            </span>
                                            <span><i class="fa-solid fa-bed"></i> 1 giường đôi</span>
                                            <span><i class="fa-solid fa-wifi"></i> WiFi</span>
                                        </div>
                                    </div>
                                    <div class="room-price">
                                        <div class="current-price">
                                            <%= request.getAttribute("roomPrice") != null ? request.getAttribute("roomPrice") : "850.000₫" %>
                                        </div>
                                        <div class="per-night">/ đêm</div>
                                    </div>
                                </div>
                                <div class="room-bottom">
                                    <div class="availability-tag">
                                        <i class="fa-solid fa-circle-check"></i>
                                        <span>Còn trống ngày bạn chọn</span>
                                    </div>
                                    <button class="book-btn">
                                        Đặt phòng này
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="section-card" id="policy">
                        <div class="section-title">
                            <i class="fa-solid fa-file-shield"></i>
                            <span>Chính sách lưu trú</span>
                        </div>
                        <div class="desc-text" style="font-size:.875rem;">
                            - Nhận phòng: sau 14:00<br/>
                            - Trả phòng: trước 12:00<br/>
                            - Hủy miễn phí trước 3 ngày<br/>
                            - Không hút thuốc trong phòng<br/>
                        </div>
                    </div>
                    <div class="section-card" id="reviews">
                        <div class="section-title">
                            <i class="fa-solid fa-comments"></i>
                            <span>Đánh giá từ khách</span>
                        </div>
                        <div class="review-summary">
                            <div class="review-score-box">
                                <div class="big">
                                    <%= request.getAttribute("ratingScore") != null ? request.getAttribute("ratingScore") : "9.2" %>
                                </div>
                                <div style="font-size:.75rem;">Tuyệt vời</div>
                            </div>
                            <div class="review-text">
                                “Không gian xanh mát, yên tĩnh. Chủ nhà nhiệt tình chỉ chỗ ăn hải sản ngon rẻ.
                                Phòng sạch, giường êm. Đi bộ ra trung tâm mất khoảng 5-7 phút.”
                                <br /><br />
                                – Minh, Việt Nam
                            </div>
                        </div>
                    </div>
                </div>
                <div class="right-col">
                    <div class="section-card map-card" id="map">
                        <div class="section-title">
                            <i class="fa-solid fa-map-location-dot"></i>
                            <span>Vị trí trên bản đồ</span>
                        </div>
                        <iframe
                            src="https://maps.google.com/maps?q=Cat%20Ba%20Eco%20Garden%20Homestay&t=&z=15&ie=UTF8&iwloc=&output=embed"
                            loading="lazy"
                            referrerpolicy="no-referrer-when-downgrade">
                        </iframe>
                        <p style="font-size:.8rem; color:#6b7280; margin-top:.5rem;">
                            Gần trung tâm Cát Bà • Thuận tiện thuê xe máy • Dễ đi ra bến tàu Lan Hạ
                        </p>
                    </div>
                    <div class="section-card host-card">
                        <div class="section-title">
                            <i class="fa-solid fa-user-tie"></i>
                            <span>Chủ nhà</span>
                        </div>
                        <div class="host-header">
                            <div class="host-avatar">
                                <%= request.getAttribute("ownerInitials") != null ? request.getAttribute("ownerInitials") : "HT" %>
                            </div>
                            <div class="host-name-role">
                                <span>
                                    <%= request.getAttribute("ownerName") != null ? request.getAttribute("ownerName") : "Nguyễn Trung Hiếu" %>
                                </span>
                                <span>Chủ homestay</span>
                            </div>
                        </div>
                        <div class="host-desc">
                            Mình sinh ra ở Cát Bà và rất vui được gợi ý lịch trình ăn chơi địa phương,
                            thuê thuyền ra vịnh Lan Hạ, hoặc chỗ ăn hải sản ngon.
                        </div>
                        <button class="contact-host-btn">
                            <i class="fa-solid fa-message"></i>
                            Nhắn cho chủ nhà
                        </button>
                    </div>
                </div>
            </div>
        </section>

        <%@ include file="Footer.jsp" %>

        <script>
            let currentGuests = {adults: 2, children: 0, rooms: 1};
            function toggleMobileMenu() {
                const navLinks = document.getElementById('mainNavLinks');
                navLinks.classList.toggle('mobile-open');
            }
            function scrollToTop() {
                window.scrollTo({top: 0, behavior: 'smooth'});
            }
            function toggleGuestDropdown() {
                const dropdown = document.getElementById('guestDropdown');
                dropdown.classList.toggle('show');
            }
            function updateCount(type, delta) {
                if (type === 'adults') {
                    currentGuests.adults = Math.max(1, currentGuests.adults + delta);
                    document.getElementById('adults-count').textContent = currentGuests.adults;
                } else if (type === 'children') {
                    currentGuests.children = Math.max(0, currentGuests.children + delta);
                    document.getElementById('children-count').textContent = currentGuests.children;
                } else if (type === 'rooms') {
                    currentGuests.rooms = Math.max(1, currentGuests.rooms + delta);
                    document.getElementById('rooms-count').textContent = currentGuests.rooms;
                }
                updateStickyBar();
            }
            document.addEventListener('click', function (event) {
                const dropdown = document.getElementById('guestDropdown');
                if (!event.target.closest('.sticky-block')) {
                    dropdown.classList.remove('show');
                }
            });
            function updateStickyBar() {
                const checkInInput = document.getElementById('checkin');
                const checkOutInput = document.getElementById('checkout');
                const checkIn = checkInInput.value || new Date(Date.now() + 86400000).toISOString().split('T')[0]; 
                const checkOut = checkOutInput.value || new Date(Date.now() + 3 * 86400000).toISOString().split('T')[0];
                if (!checkInInput.value)
                    checkInInput.value = checkIn;
                if (!checkOutInput.value)
                    checkOutInput.value = checkOut;
                const start = new Date(checkIn);
                const end = new Date(checkOut);
                const diffMs = end - start;
                const nights = diffMs > 0 ? Math.round(diffMs / (1000 * 60 * 60 * 24)) : 1;
                const startTxt = start.toLocaleDateString('vi-VN', {day: '2-digit', month: 'short'});
                const endTxt = end.toLocaleDateString('vi-VN', {day: '2-digit', month: 'short'});
                const childrenTxt = currentGuests.children > 0 ? `, ${currentGuests.children} trẻ em` : '';
                document.getElementById('stayGuests').textContent =
                        `${currentGuests.adults} người lớn${childrenTxt}, ${currentGuests.rooms} phòng`;
            }
            document.addEventListener('DOMContentLoaded', function () {
                const checkinEl = document.getElementById('checkin');
                const checkoutEl = document.getElementById('checkout');
                if (checkinEl)
                    checkinEl.addEventListener('change', updateStickyBar);
                if (checkoutEl)
                    checkoutEl.addEventListener('change', updateStickyBar);
                updateStickyBar();
            });
            function performSearch() {
                const formData = {
                    checkIn: document.getElementById('checkin').value,
                    checkOut: document.getElementById('checkout').value,
                    adults: currentGuests.adults,
                    children: currentGuests.children,
                    rooms: currentGuests.rooms
                };
                console.log('Tìm kiếm với:', formData);
                alert('Đang kiểm tra phòng trống...');
            }
        </script>
    </body>
</html>