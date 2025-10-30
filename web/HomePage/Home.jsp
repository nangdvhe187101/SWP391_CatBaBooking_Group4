<%-- 
    Document   : Home
    Created on : Oct 6, 2025, 9:06:37 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="model.Users"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cát Bà Booking - Đặt phòng homestay và nhà hàng tại Cát Bà</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

        <style>
            /* Nút Chi tiết - giống hệt Homestay.jsp */
            .detail-btn {
                text-decoration: none;
                position: absolute;
                bottom: 16px;
                right: 16px;
                background-color: #28a745;
                color: #ffffff;
                border: 1px solid #28a745;
                padding: 6px 12px;
                border-radius: 4px;
                font-size: 0.9rem;
                transition: all 0.3s ease;
                z-index: 10;
            }

            .detail-btn:hover {
                background-color: #218838;
                border-color: #1e7e34;
                color: #ffffff;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            /* Đảm bảo card-content có position relative */
            .homestay-card {
                position: relative;
                display: flex;
                flex-direction: column;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <%@ include file="Sidebar.jsp" %>

        <!-- Hero Section -->
        <section class="hero">
            <div class="hero-overlay"></div>
            <div class="hero-bg"></div>

            <div class="container">
                <div class="hero-content">
                    <div class="hero-text">
                        <h1>Khám phá vẻ đẹp Cát Bà</h1>
                        <p>Trải nghiệm homestay đích thực và ẩm thực địa phương</p>
                    </div>

                    <!-- Service Tabs -->
                    <div class="service-tabs">
                        <div class="tabs-container">
                            <button class="tab-btn active" data-tab="homestay">
                                <i class="fas fa-home"></i>
                                <span>Homestay</span>
                            </button>
                            <button class="tab-btn" data-tab="restaurant">
                                <i class="fas fa-utensils"></i>
                                <span>Nhà hàng</span>
                            </button>
                        </div>
                    </div>

                    <!-- Search Forms -->
                    <div class="search-forms">
                        <!-- Homestay Search Form -->
                        <div class="search-form active" id="homestay-form">
                            <div class="form-tabs">
                                <button class="form-tab active">
                                    <i class="fas fa-home"></i>
                                    <span>Homestay</span>
                                </button>
                                <button class="form-tab">
                                    <span>Villa</span>
                                </button>
                                <button class="form-tab">
                                    <span>Phòng đôi</span>
                                </button>
                            </div>

                            <form action="homestays-list" method="GET">
                                <div class="form-grid" style="display: flex;
                                     flex-wrap: wrap; gap: 15px; align-items: end;">
                                    <div class="form-field" style="flex: 0 0 200px;">
                                        <label for="area">Khu vực</label>

                                        <div class="input-wrapper">
                                            <i class="fas fa-map-marker-alt"></i>

                                            <select id="area" name="areaId" class="form-select">
                                                <option value="0">Tất cả khu vực</option>

                                                <c:forEach var="area" items="${areaList}">
                                                    <option value="${area.areaId}" ${param.areaId == area.areaId ? 'selected' : ''}>

                                                        ${area.name}
                                                    </option>

                                                </c:forEach>
                                            </select>

                                        </div>
                                    </div>
                                    <div class="form-field" style="flex: 0
                                         0 220px;">
                                        <label for="checkIn">Ngày nhận</label>
                                        <div class="input-wrapper">

                                            <i class="fas fa-calendar"></i>
                                            <input type="date" id="checkin" name="checkIn" class="form-input" 

                                                   min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />" 
                                                   value="${param.checkIn}">

                                        </div>
                                    </div>

                                    <div class="form-field" style="flex: 0 0 220px;">
                                        <label for="checkOut">Ngày trả</label>
                                        <div class="input-wrapper">

                                            <i class="fas fa-calendar"></i>
                                            <input type="date" id="checkout" name="checkOut" class="form-input" 

                                                   min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />" 
                                                   value="${param.checkOut}">

                                        </div>
                                    </div>

                                    <div class="form-field-group" style="flex: 0 0 220px; display: flex;
                                         gap: 10px;">
                                        <div class="form-field" style="flex: 1;">
                                            <label>Số người</label>

                                            <div class="input-wrapper">
                                                <i class="fas fa-users"></i>

                                                <input id="numGuests" name="guests" type="number" class="form-input" min="1" value="${empty param.guests ?'1' : param.guests}" placeholder="Nhập số khách">
                                            </div>
                                        </div>

                                        <div class="form-field" style="flex: 1;">
                                            <label>Số phòng</label>

                                            <div class="input-wrapper">
                                                <i class="fas fa-door-open"></i>

                                                <input id="numRooms" name="numRooms" type="number" class="form-input" min="1" value="${empty param.numRooms ?'1' : param.numRooms}" placeholder="Nhập số phòng">
                                            </div>
                                        </div>

                                    </div>
                                    <div class="form-field" style="flex: 0 0 200px;">

                                        <button type="submit" class="search-btn">
                                            <i class="fas fa-search"></i>
                                            Tìm homestay

                                        </button>
                                    </div>

                                </div>
                            </form>
                        </div>

                        <!-- Restaurant Search Form -->
                        <form action="${pageContext.request.contextPath}/restaurants" method="GET">
                        <div class="search-form" id="restaurant-form">
                            <div class="form-tabs">
                                <button class="form-tab active">
                                    <i class="fas fa-utensils"></i>
                                    <span>Tất cả</span>
                                </button>
                                <button class="form-tab">
                                    <span>Hải sản</span>
                                </button>
                                <button class="form-tab">
                                    <span>Món Việt</span>
                                </button>
                                <button class="form-tab">
                                    <span>BBQ</span>
                                </button>
                            </div>

                            <div class="form-grid" style="display: flex;
                                     flex-wrap: wrap; gap: 15px; align-items: end;">
                                    <div class="form-field" style="flex: 0 0 200px;">
                                        <label>Loại hình</label>
                                        <div class="input-wrapper">
                                            <i class="fas fa-utensils"></i>
                                            <select name="restaurantType" class="form-select">
                                                <option value="">Loại nhà hàng</option>
                                                <c:forEach var="type" items="${restaurantTypes}">
                                                    <option value="${type.typeId}" ${param.restaurantType == type.typeId ? 'selected' : ''}>
                                                        ${type.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-field" style="flex: 0 0 220px;">
                                        <label>Khu vực tại Cát Bà</label>
                                        <div class="input-wrapper">
                                            <i class="fas fa-map-marker-alt"></i>
                                            <select name="areaId" class="form-select">
                                                <option value="0">Chọn khu vực</option>
                                                <c:forEach var="area" items="${areaList}">
                                                    <option value="${area.areaId}" ${param.areaId == area.areaId ? 'selected' : ''}>
                                                        ${area.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-field" style="flex: 0
                                         0 180px;">
                                        <label>Ngày đặt bàn</label>
                                        <div class="input-wrapper">
                                            <i class="fas fa-calendar"></i>
                                            <input type="date" name="date" class="form-input" 
                                                   min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />"
                                                   value="${param.date}">
                                        </div>
                                    </div>

                                    <div class="form-field" style="flex: 0 0 150px;">
                                        <label>Giờ</label>
                                        <div class="input-wrapper">
                                            <i class="fas fa-clock"></i>
                                            <input type="time" name="time" class="form-input" value="${param.time}">
                                        </div>
                                    </div>

                                    <div class="form-field" style="flex: 0 0 100px;">
                                        <label>Số người</label>
                                        <div class="input-wrapper">
                                            <i class="fas fa-users"></i>
                                            <input type="number" name="numGuests" class="form-input" min="1" 
                                                   value="${empty param.numGuests ? '' : param.numGuests}" >
                                        </div>
                                    </div>

                                    <div class="form-field" style="flex: 0 0 150px;display: flex; gap: 10px">
                                        <button type="submit" class="search-btn">
                                            <i class="fas fa-search"></i>
                                            Tìm nhà hàng
                                        </button>
                                    </div>
                                </div>
                        </div></form>

                        <!-- Cruise Search Form -->
                        <div class="search-form" id="cruise-form">
                            <div class="form-tabs">
                                <button class="form-tab active">
                                    <i class="fas fa-ship"></i>
                                    <span>Du thuyền</span>
                                </button>
                            </div>

                            <div class="form-grid">
                                <div class="form-field">
                                    <label>Loại tour</label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-ship"></i>
                                        <select class="form-select">
                                            <option>Chọn loại tour</option>
                                            <option>Tour 1 ngày</option>
                                            <option>Tour 2 ngày 1 đêm</option>
                                            <option>Tour 3 ngày 2 đêm</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label>Ngày khởi hành</label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-calendar"></i>
                                        <input type="text" placeholder="Chọn ngày" class="form-input">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label>Số khách</label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-users"></i>
                                        <select class="form-select">
                                            <option>Chọn số khách</option>
                                            <option>1-2 khách</option>
                                            <option>3-5 khách</option>
                                            <option>6-10 khách</option>
                                            <option>10+ khách</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-field">
                                    <button class="search-btn">
                                        <i class="fas fa-search"></i>
                                        Tìm du thuyền
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Features -->
                    <div class="hero-features">
                        <div class="features-container">
                            <p class="features-title">Tại sao chọn chúng tôi?</p>
                            <div class="features-list">
                                <span>🏡 Homestay chính chủ</span>
                                <span>🍜 Đặc sản địa phương</span>
                                <span>🌊 View đẹp nhất</span>
                                <span>💰 Giá tốt nhất</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Featured Homestays Section -->
        <section class="featured-homestays">
            <div class="container">
                <div class="section-header">
                    <div>
                        <h2>Homestay nổi bật</h2>
                        <p>Những homestay được yêu thích nhất tại Cát Bà</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/homestay-list" class="view-all-btn">
                        <span>Xem tất cả</span>
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </div>

                <div class="homestays-grid">
                    <c:forEach var="homestay" items="${topHomestays}">
                        <div class="homestay-card">
                            <div class="card-image">
                                <img src="${homestay.image != null && !homestay.image.isEmpty() ? homestay.image : 'https://via.placeholder.com/400x300/4a6cf7/ffffff?text=No+Image'}"
                                     alt="${homestay.name}">
                                <div class="badge type">
                                    <i class="fas fa-home"></i>
                                    Homestay
                                </div>
                            </div>
                            <div class="card-content">
                                <div class="rating">
                                    <div class="stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${homestay.avgRating >= i}">
                                                    <i class="fas fa-star"></i>
                                                </c:when>
                                                <c:when test="${homestay.avgRating >= i - 0.5}">
                                                    <i class="fas fa-star-half-alt"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="far fa-star"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                    <span class="reviews">(${homestay.reviewCount})</span>
                                </div>
                                <h3>
                                    <a href="${pageContext.request.contextPath}/homestay-detail?id=${homestay.businessId}"
                                       style="color: inherit; text-decoration: none;">
                                        ${homestay.name}
                                    </a>
                                </h3>
                                <div class="location">
                                    <i class="fas fa-map-marker-alt"></i>
                                    ${homestay.area.name}, Cát Bà
                                </div>
                                <a class="detail-btn" href="${pageContext.request.contextPath}/homestay-detail?id=${homestay.businessId}">
                                    Chi tiết
                                </a>
                                <div class="price-section">
                                    <div class="price">
                                        <span class="current-price">
                                            <fmt:formatNumber value="${homestay.pricePerNight}" type="number" maxFractionDigits="0"/>₫
                                        </span>
                                        <div class="per-night">mỗi đêm</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Nếu không có dữ liệu -->
                    <c:if test="${empty topHomestays}">
                        <p style="grid-column: 1 / -1; text-align: center; color: #666; font-style: italic; padding: 40px 0;">
                            Chưa có homestay nào được đánh giá. Hãy quay lại sau!
                        </p>
                    </c:if>
                </div>
            </div>
        </section>

        <!-- Promo Section -->
        <section class="promo-section">
            <div class="container">
                <div class="promo-grid">
                    <div class="promo-card emerald">
                        <div class="promo-image">
                            <img src="https://images.unsplash.com/photo-1710702418104-6bf5419ab03d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx2aWV0bmFtZXNlJTIwaG9tZXN0YXl8ZW58MXx8fHwxNzU3Njg2OTkyfDA&ixlib=rb-4.1.0&q=80&w=1080"
                                 alt="Ưu đãi cuối tuần">
                        </div>
                        <div class="promo-content">
                            <h3>Ưu đãi cuối tuần</h3>
                            <p>Giảm 30% cho đặt phòng homestay cuối tuần</p>
                            <button class="promo-btn">Đặt ngay</button>
                        </div>
                    </div>

                    <div class="promo-card orange">
                        <div class="promo-image">
                            <img src="https://images.unsplash.com/photo-1619900950180-4a099c7aaeb1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx2aWV0bmFtZXNlJTIwcmVzdGF1cmFudCUyMGZvb2R8ZW58MXx8fHwxNzU3NjU1NjcwfDA&ixlib=rb-4.1.0&q=80&w=1080"
                                 alt="Combo ăn uống">
                        </div>
                        <div class="promo-content">
                            <h3>Combo ăn uống</h3>
                            <p>Đặt bàn + homestay nhận ngay voucher 100k</p>
                            <button class="promo-btn">Khám phá</button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Featured Restaurants Section -->
        <section class="featured-restaurants">
            <div class="container">
                <div class="section-header">
                    <div>
                        <h2>Nhà hàng đặc sắc</h2>
                        <p>Thưởng thức hải sản tươi ngon và đặc sản địa phương</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/restaurant" class="view-all-btn">
                        <span>Xem tất cả</span>
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </div>

                <div class="restaurants-grid">
                    <c:forEach var="res" items="${topRestaurants}">
                        <div class="restaurant-card">
                            <div class="card-image">
                                <img src="${res.image != null && !res.image.isEmpty() ? res.image : 'https://via.placeholder.com/400x300?text=No+Image'}"
                                     alt="${res.name}">
                                <div class="badge cuisine">
                                    <i class="fas fa-utensils"></i>
                                    Nhà hàng
                                </div>
                            </div>
                            <div class="card-content">
                                <div class="rating-price">
                                    <div class="rating">
                                        <div class="stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${res.avgRating >= i}"><i class="fas fa-star"></i></c:when>
                                                    <c:when test="${res.avgRating >= i - 0.5}"><i class="fas fa-star-half-alt"></i></c:when>
                                                    <c:otherwise><i class="far fa-star"></i></c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                        <span class="reviews">(${res.reviewCount})</span>
                                    </div>

                                </div>
                                <h3>
                                    <a href="${pageContext.request.contextPath}/restaurant-detail?id=${res.businessId}"
                                       style="color: inherit; text-decoration: none;">
                                        ${res.name}
                                    </a>
                                </h3>
                                <div class="location">
                                    <i class="fas fa-map-marker-alt"></i>
                                    ${res.area.name}, Cát Bà
                                </div>
                                <div class="hours">
                                    <i class="fas fa-clock"></i>
                                    ${res.openingHour} - ${res.closingHour}
                                </div>
                                <div class="bottom-section">
                                    <div class="phone">
                                        <i class="fas fa-phone"></i>
                                        <span>0${res.owner.userId}123456</span> <!-- Có thể thêm cột phone sau -->
                                    </div>
                                    <button class="book-btn">Đặt bàn</button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Nếu không có dữ liệu -->
                    <c:if test="${empty topRestaurants}">
                        <p style="grid-column: 1 / -1; text-align: center; color: #666; font-style: italic; padding: 40px 0;">
                            Chưa có nhà hàng nào được đánh giá. Hãy quay lại sau!
                        </p>
                    </c:if>
                </div>
            </div>
        </section>



        <!-- Footer -->
        <%@ include file="Footer.jsp" %>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const tabBtns = document.querySelectorAll('.tab-btn');
                const searchForms = document.querySelectorAll('.search-form');
                const heroBg = document.querySelector('.hero-bg');

                const homestayBg = 'ur[](https://example.com/homestay-bg.jpg)';
                const restaurantBg = 'ur[](https://example.com/restaurant-bg.jpg)';
                tabBtns.forEach(btn => {
                    btn.addEventListener('click', function () {
                        const targetTab = this.getAttribute('data-tab');
                        tabBtns.forEach(b => b.classList.remove('active'));
                        this.classList.add('active');

                        searchForms.forEach(form => {
                            form.classList.remove('active');
                            if (form.id === targetTab + '-form') {
                                form.classList.add('active');
                            }
                        });

                        if (targetTab === 'homestay') {
                            heroBg.style.backgroundImage = homestayBg;
                        } else if (targetTab === 'restaurant') {
                            heroBg.style.backgroundImage = restaurantBg;
                        }
                    });
                });
            });
        </script>
    </body>
</html>