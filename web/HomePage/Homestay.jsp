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

            /* Container chính cho lưới homestay */
            .homestay-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 24px;
                margin-top: 20px;
            }

            /* Thẻ thông tin của mỗi homestay */
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

            /* Phần hình ảnh */
            .homestay-card .card-image {
                position: relative;
                height: 200px;
            }

            .homestay-card .card-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            /* Phần nội dung text bên dưới ảnh */
            .homestay-card .card-content {
                padding: 16px;
                display: flex;
                flex-direction: column;
                flex-grow: 1;
            }

            /* Container cho rating và giá tiền */
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

            /* Tên homestay */
            .homestay-card h3 {
                font-size: 1.2rem;
                margin: 8px 0;
                color: #343a40;
            }

            /* Vị trí */
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

            /* Thông báo lỗi hoặc không tìm thấy */
            .alert {
                background-color: #f8d7da;
                color: #721c24;
                padding: 12px;
                border-radius: 4px;
                margin-bottom: 20px;
                text-align: center;
            }

            /* Responsive cho màn hình nhỏ hơn */
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

                            <form action="homestays" method="GET">
                                <div class="form-grid">
                                    <div class="form-field">
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

                                    <div class="form-field">
                                        <label for="checkIn">Ngày nhận</label>
                                        <div class="input-wrapper">
                                            <i class="fas fa-calendar"></i>
                                            <input type="date" id="checkin" name="checkIn" class="form-input" 
                       min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />" 
                       value="${param.checkIn}">
                                        </div>
                                    </div>

                                    <div class="form-field">
                                        <label for="checkOut">Ngày trả</label>
                                        <div class="input-wrapper">
                                            <i class="fas fa-calendar"></i>
                                            <input type="date" id="checkout" name="checkOut" class="form-input" 
                       min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />" 
                       value="${param.checkOut}">
                                        </div>
                                    </div>

                                    <div class="form-field">
                                        <label for="guests">Số người</label>
                                        <div class="input-wrapper">
                                            <i class="fas fa-users"></i>
                                            <input type="number" id="guests" name="guests" class="form-input" min="1" value="${empty param.guests ? '1' : param.guests}" placeholder="Nhập số người">
                                        </div>
                                    </div>

                                    <div class="form-field">
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

                        <!-- Danh sách Homestay -->
                        <c:choose>
                            <c:when test="${empty homestays}">
                                <div class="alert">
                                    Không tìm thấy homestay nào phù hợp với tiêu chí của bạn.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="homestay-grid">
                                    <c:forEach var="homestay" items="${homestays}">
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

                                            <a class="btn btn-outline-primary btn-sm detail-btn"
                                               href="homestay-detail?id=${homestay.businessId}">
                                                Chi tiết
                                            </a>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Pagination -->
                        <div class="pagination">
                            <button class="page-btn" disabled>Trước</button>
                            <button class="page-btn active">1</button>
                            <button class="page-btn">2</button>
                            <button class="page-btn">3</button>
                            <button class="page-btn">Sau</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <%@ include file="Footer.jsp" %>
    </body>
</html>