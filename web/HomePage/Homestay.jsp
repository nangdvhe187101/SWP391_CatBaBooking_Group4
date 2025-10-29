<%-- 
    Document   : Homestay
    Created on : Oct 6, 2025, 9:06:50 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Homestay tại Cát Bà - Cát Bà Booking</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

        <style>
            /* ================= HOMESTAY GRID LAYOUT ================= */
            .homestay-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 24px;
                margin-top: 20px;
            }

            .homestay-card {
                background-color: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                overflow: hidden;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                display: flex;
                flex-direction: column;
                position: relative;
            }

            .homestay-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
            }

            .homestay-card .card-image {
                position: relative;
                height: 200px;
            }

            .homestay-card .card-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .homestay-card .card-content {
                padding: 16px;
                display: flex;
                flex-direction: column;
                flex-grow: 1;
            }

            .homestay-card .rating-price {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 8px;
            }

            .homestay-card .rating .stars {
                color: #ffc107;
            }

            .homestay-card .reviews {
                font-size: 0.85rem;
                color: #6c757d;
                margin-left: 4px;
            }

            .homestay-card .price-range {
                font-weight: 700;
                color: #007bff;
                font-size: 1.1rem;
            }

            .homestay-card h3 {
                font-size: 1.2rem;
                margin: 8px 0;
                color: #343a40;
            }

            .homestay-card .location {
                font-size: 0.9rem;
                color: #6c757d;
                margin-top: auto;
            }

            .homestay-card .location i {
                margin-right: 6px;
            }

            .detail-btn {
                text-decoration: none;
                position: absolute;
                bottom: 16px;
                right: 16px;
                background-color: #28a745;
                color: #ffffff;
                border-color: #28a745;
                padding: 6px 12px;
                border-radius: 4px;
            }

            .detail-btn:hover {
                background-color: #218838;
                border-color: #1e7e34;
                color: #ffffff;
            }

            .alert {
                background-color: #f8d7da;
                color: #721c24;
                padding: 12px;
                border-radius: 4px;
                margin-bottom: 20px;
                text-align: center;
            }

            @media (max-width: 992px) {
                .homestay-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            @media (max-width: 768px) {
                .homestay-grid {
                    grid-template-columns: 1fr;
                }
            }

            /* ================= PHÂN TRANG - GIỐNG HÌNH BẠN GỬI ================= */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                margin: 30px 0;
                flex-wrap: wrap;
            }

            .page-btn {
                min-width: 40px;
                height: 40px;
                padding: 0 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                background: #fff;
                color: #6c757d;
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s ease;
                cursor: pointer;
            }

            .page-btn:hover:not(.active):not([disabled]) {
                border-color: #aaa;
                color: #333;
            }

            .page-btn.active {
                background-color: #28a745;
                color: white;
                border-color: #28a745;
                font-weight: 600;
            }

            .page-btn[disabled] {
                color: #aaa;
                background-color: #f8f9fa;
                cursor: not-allowed;
                border-color: #eee;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <%@ include file="Sidebar.jsp" %>

        <!-- Hero Section with Search -->
        <section class="hero">
            <div class="hero-overlay"></div>
            <div class="hero-bg"></div>

            <div class="container">
                <div class="hero-content">
                    <div class="hero-text">
                        <h1>Homestay tại Cát Bà</h1>
                        <p>Tìm và đặt homestay phù hợp với nhu cầu của bạn</p>
                    </div>

                    <!-- Search Form -->
                    <div class="search-forms">
                        <div class="search-form active" id="homestay-search">
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
                                <div class="form-grid" style="display: flex; flex-wrap: wrap; gap: 15px; align-items: end;">
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
                                    <div class="form-field" style="flex: 0 0 220px;">
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
                                    <div class="form-field-group" style="flex: 0 0 220px; display: flex; gap: 10px;">
                                        <div class="form-field" style="flex: 1;">
                                            <label>Số người</label>
                                            <div class="input-wrapper">
                                                <i class="fas fa-users"></i>
                                                <input id="numGuests" name="guests" type="number" class="form-input" min="1" value="${empty param.guests ? '1' : param.guests}" placeholder="Nhập số khách">
                                            </div>
                                        </div>
                                        <div class="form-field" style="flex: 1;">
                                            <label>Số phòng</label>
                                            <div class="input-wrapper">
                                                <i class="fas fa-door-open"></i>
                                                <input id="numRooms" name="numRooms" type="number" class="form-input" min="1" value="${empty param.numRooms ? '1' : param.numRooms}" placeholder="Nhập số phòng">
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
                    </div>
                </div>
            </div>
        </section>

        <!-- Main Content -->
        <div class="container">
            <div class="main-content">
                <div class="content-layout">
                    <!-- Sidebar Filters -->
                    <div class="sidebar">
                        <div class="filter-section">
                            <div class="filter-header">
                                <i class="fas fa-sliders-h"></i>
                                <h3>Bộ lọc</h3>
                            </div>

                            <!-- Price Range -->
                            <div class="filter-group">
                                <h4>Khoảng giá (VND)</h4>
                                <div class="filter-options">
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Dưới 200.000</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>200.000 - 500.000</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>500.000 - 1.000.000</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Trên 1.000.000</span>
                                    </label>
                                </div>
                            </div>

                            <!-- Rating -->
                            <div class="filter-group">
                                <h4>Đánh giá</h4>
                                <div class="filter-options">
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <div class="rating-option">
                                            <div class="stars">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                            <span>5 sao</span>
                                        </div>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <div class="rating-option">
                                            <div class="stars">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="far fa-star"></i>
                                            </div>
                                            <span>4+ sao</span>
                                        </div>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <div class="rating-option">
                                            <div class="stars">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="far fa-star"></i>
                                                <i class="far fa-star"></i>
                                            </div>
                                            <span>3+ sao</span>
                                        </div>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <div class="rating-option">
                                            <div class="stars">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="far fa-star"></i>
                                                <i class="far fa-star"></i>
                                                <i class="far fa-star"></i>
                                            </div>
                                            <span>2+ sao</span>
                                        </div>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <div class="rating-option">
                                            <div class="stars">
                                                <i class="fas fa-star"></i>
                                                <i class="far fa-star"></i>
                                                <i class="far fa-star"></i>
                                                <i class="far fa-star"></i>
                                                <i class="far fa-star"></i>
                                            </div>
                                            <span>1+ sao</span>
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <div class="filter-group">
                                <h4>Tiện ích</h4>
                                <div class="filter-options">
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>View biển</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>WiFi miễn phí</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Chỗ đậu xe</span>
                                    </label>
                                </div>
                            </div>

                            <button class="apply-filter-btn">Áp dụng bộ lọc</button>
                        </div>
                    </div>

                    <!-- Results -->
                    <div class="results-section">
                        <!-- Hiển thị thông báo lỗi nếu có -->
                        <c:if test="${not empty error}">
                            <div class="alert">
                                ${error}
                            </div>
                        </c:if>

                        <!-- Results Header -->
                        <div class="results-header">
                            <div class="results-info">
                                <h2>Homestay tại Cát Bà</h2>
                                <p>Tìm thấy <span id="homestay-count">${homestays.size()}</span> homestay</p>
                            </div>
                            <div class="results-controls">
                                <div class="sort-control">
                                    <label>Sắp xếp:</label>
                                    <select class="sort-select">
                                        <option>Phù hợp nhất</option>
                                        <option>Giá thấp đến cao</option>
                                        <option>Giá cao đến thấp</option>
                                        <option>Đánh giá cao nhất</option>
                                        <option>Nhiều đánh giá nhất</option>
                                    </select>
                                </div>
                                <div class="view-controls">
                                    <button class="view-btn active" data-view="grid">
                                        <i class="fas fa-th"></i>
                                    </button>
                                    <button class="view-btn" data-view="list">
                                        <i class="fas fa-list"></i>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Popular Filters -->
                        <div class="popular-filters">
                            <span class="filter-tag">View biển</span>
                            <span class="filter-tag">WiFi miễn phí</span>
                            <span class="filter-tag">Bữa sáng</span>
                            <span class="filter-tag">Chỗ đậu xe</span>
                            <span class="filter-tag">Giá rẻ</span>
                        </div>


                        <c:choose>
                            <c:when test="${empty homestays}">
                                <div class="alert">
                                    Không tìm thấy homestay nào phù hợp với tiêu chí của bạn.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- phân trang -->
                                <c:set var="page" value="${param.page != null && param.page > 0 ? param.page : 1}" />
                                <c:set var="itemsPerPage" value="2" />
                                <c:set var="totalItems" value="${homestays.size()}" />
                                <c:set var="totalPages" value="${(totalItems + itemsPerPage - 1) / itemsPerPage}" />
                                <c:set var="start" value="${(page - 1) * itemsPerPage}" />
                                <c:set var="end" value="${start + itemsPerPage - 1}" />

                                <div class="homestay-grid">
                                    <c:forEach var="homestay" items="${homestays}" begin="${start}" end="${end}">
                                        <div class="homestay-card">
                                            <div class="card-image">
                                                <img src="${homestay.image}" alt="${homestay.name}">
                                                <div class="badge type">
                                                    <i class="fas fa-home"></i>
                                                    Homestay
                                                </div>
                                            </div>
                                            <div class="card-content">
                                                <div class="rating-price">
                                                    <div class="rating">
                                                        <div class="stars">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <i class="${i <= homestay.avgRating.intValue() ? 'fas' : 'far'} fa-star"></i>
                                                            </c:forEach>
                                                        </div>
                                                        <span class="reviews">(${homestay.reviewCount})</span>
                                                    </div>
                                                    <span class="price-range">
                                                        <fmt:formatNumber value="${homestay.pricePerNight}" pattern="#,###"/> VND
                                                    </span>
                                                </div>
                                                <h3>${homestay.name}</h3>
                                                <div class="location">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                    ${homestay.area.name}
                                                </div>
                                            </div>
                                            <a class="detail-btn" href="homestay-detail?id=${homestay.businessId}">
                                                Chi tiết
                                            </a>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!--PHÂN TRANG-->
                                <div class="pagination">
                                    <!-- Trước -->
                                    <c:if test="${page > 1}">
                                        <a href="?areaId=${param.areaId}&checkIn=${param.checkIn}&checkOut=${param.checkOut}&guests=${param.guests}&numRooms=${param.numRooms}&page=${page - 1}" class="page-btn">Trước</a>
                                    </c:if>
                                    <c:if test="${page <= 1}">
                                        <button class="page-btn" disabled>Trước</button>
                                    </c:if>

                                    <!-- Các trang -->
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <a href="?areaId=${param.areaId}&checkIn=${param.checkIn}&checkOut=${param.checkOut}&guests=${param.guests}&numRooms=${param.numRooms}&page=${i}"
                                           class="page-btn ${i == page ? 'active' : ''}">${i}</a>
                                    </c:forEach>

                                    <!-- Sau -->
                                    <c:if test="${page < totalPages}">
                                        <a href="?areaId=${param.areaId}&checkIn=${param.checkIn}&checkOut=${param.checkOut}&guests=${param.guests}&numRooms=${param.numRooms}&page=${page + 1}" class="page-btn">Sau</a>
                                    </c:if>
                                    <c:if test="${page >= totalPages}">
                                        <button class="page-btn" disabled>Sau</button>
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript Validate Số phòng ≤ Số khách -->
        <script>
            const guestsInput = document.getElementById('numGuests');
            const roomsInput = document.getElementById('numRooms');

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
        </script>

        <!-- Footer -->
        <%@ include file="Footer.jsp" %>
    </body>
</html>