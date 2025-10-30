<%-- 
    Document   : Restaurant
    Created on : Oct 6, 2025, 9:07:03 PM
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
    <title>Nhà hàng tại Cát Bà - Cát Bà Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* ================= RESTAURANT GRID LAYOUT ================= */
        .restaurants-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            margin-top: 20px;
        }

        .restaurant-card {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .restaurant-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }

        .restaurant-card .card-image {
            position: relative;
            height: 200px;
        }

        .restaurant-card .card-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .restaurant-card .card-content {
            padding: 16px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }

        .restaurant-card .rating-price {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }

        .restaurant-card .rating .stars {
            color: #ffc107;
        }

        .restaurant-card .reviews {
            font-size: 0.85rem;
            color: #6c757d;
            margin-left: 4px;
        }

        .restaurant-card .price-range {
            font-weight: 700;
            color: #007bff;
            font-size: 1.1rem;
        }

        .restaurant-card h3 {
            font-size: 1.2rem;
            margin: 8px 0;
            color: #343a40;
        }

        .restaurant-card .location {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: auto;
        }

        .restaurant-card .location i {
            margin-right: 6px;
        }

        .restaurant-card .cuisines {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 8px;
        }

        .restaurant-card .detail-btn {
            text-decoration: none;
            position: absolute;
            bottom: 16px;
            right: 16px;
            background-color: #28a745;
            color: #ffffff;
            border-color: #28a745;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.9rem;
        }
        .restaurant-card .detail-btn:hover {
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
            .restaurants-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .restaurants-grid {
                grid-template-columns: 1fr;
            }
        }

        .apply-filter-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.95rem;
            margin-top: 16px;
            width: 100%;
        }
        .apply-filter-btn:hover {
            background-color: #0056b3;
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

    <%@ include file="Sidebar.jsp" %>

    <form action="${pageContext.request.contextPath}/restaurants" method="GET" id="restaurant-search-form">

        <section class="hero">
            <div class="hero-overlay"></div>
            <div class="hero-bg"></div>

            <div class="container">
                <div class="hero-content">
                    <div class="hero-text">
                        <h1>Nhà hàng tại Cát Bà</h1>
                        <p>Khám phá ẩm thực đặc sắc và đặt bàn trực tuyến</p>
                    </div>

                    <div class="search-forms">
                        <div class="search-form active" id="restaurant-search">
                            <div class="form-tabs">
                                <button type="button" class="form-tab active">
                                    <i class="fas fa-utensils"></i>
                                    <span>Tất cả</span>
                                </button>
                                <button type="button" class="form-tab">
                                    <span>Hải sản</span>
                                </button>
                                <button type="button" class="form-tab">
                                    <span>Món Việt</span>
                                </button>
                                <button type="button" class="form-tab">
                                    <span>BBQ</span>
                                </button>
                            </div>

                            <div class="form-grid">
                                <div class="form-field">
                                    <label>Loại hình</label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-utensils"></i>
                                        <select name="restaurantType" class="form-select">
                                            <option value="">Chọn loại nhà hàng</option>
                                            <c:forEach var="type" items="${restaurantTypes}">
                                                <option value="${type.typeId}" ${param.restaurantType == type.typeId ? 'selected' : ''}>
                                                    ${type.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-field">
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

                                <div class="form-field">
                                    <label>Ngày đặt bàn</label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-calendar"></i>
                                        <input type="date" name="date" class="form-input" 
                                               min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />"
                                               value="${param.date}">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <div class="time-guests">
                                        <div class="time-field">
                                            <label>Giờ</label>
                                            <div class="input-wrapper">
                                                <i class="fas fa-clock"></i>
                                                <input type="time" name="time" class="form-input" value="${param.time}">
                                            </div>
                                        </div>
                                        <div class="guests-field">
                                            <label>Số người</label>
                                            <div class="input-wrapper">
                                                <i class="fas fa-users"></i>
                                                <input type="number" name="numGuests" class="form-input" min="1" 
                                                       value="${empty param.numGuests ? '' : param.numGuests}" placeholder="Nhập số người">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-field">
                                    <button type="submit" class="search-btn">
                                        <i class="fas fa-search"></i>
                                        Tìm nhà hàng
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <div class="container">
            <div class="main-content">
                <div class="content-layout">

                    <div class="sidebar">
                        <div class="filter-section">
                            <div class="filter-header">
                                <i class="fas fa-sliders-h"></i>
                                <h3>Bộ lọc</h3>
                            </div>

                            <div class="filter-group">
                                <h4>Đánh giá</h4>
                                <div class="filter-options">
                                    <label class="filter-option">
                                        <input type="checkbox" name="minRating" value="5" ${param.minRating == '5' ? 'checked' : ''}>
                                        <div class="rating-option">
                                            <div class="stars">
                                                <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                                            </div>
                                            <span>5 sao</span>
                                        </div>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox" name="minRating" value="4" ${param.minRating == '4' ? 'checked' : ''}>
                                        <div class="rating-option">
                                            <div class="stars">
                                                <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i>
                                            </div>
                                            <span>4+ sao</span>
                                        </div>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox" name="minRating" value="3" ${param.minRating == '3' ? 'checked' : ''}>
                                        <div class="rating-option">
                                            <div class="stars">
                                                <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i>
                                            </div>
                                            <span>3+ sao</span>
                                        </div>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox" name="minRating" value="2" ${param.minRating == '2' ? 'checked' : ''}>
                                        <div class="rating-option">
                                            <div class="stars">
                                                <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i>
                                            </div>
                                            <span>2+ sao</span>
                                        </div>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox" name="minRating" value="1" ${param.minRating == '1' ? 'checked' : ''}>
                                        <div class="rating-option">
                                            <div class="stars">
                                                <i class="fas fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i>
                                            </div>
                                            <span>1+ sao</span>
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <button type="submit" class="apply-filter-btn">Áp dụng bộ lọc</button>
                        </div>
                    </div>

                    <div class="results-section">
                        <c:if test="${not empty error}">
                            <div class="alert">
                                ${error}
                            </div>
                        </c:if>

                        <div class="results-header">
                            <div class="results-info">
                                <h2>Nhà hàng tại Cát Bà</h2>
                                <p>Tìm thấy <span id="restaurant-count">${restaurants.size()}</span> nhà hàng</p>
                            </div>
                            <div class="results-controls">
                                <div class="sort-control">
                                    <label>Sắp xếp:</label>
                                    <select class="sort-select">
                                        <option>Phù hợp nhất</option>
                                        <option>Đánh giá cao nhất</option>
                                        <option>Nhiều đánh giá nhất</option>
                                        <option>Giá thấp đến cao</option>
                                        <option>Giá cao đến thấp</option>
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

                        <div class="popular-filters">
                            <span class="filter-tag">Hải sản tươi</span>
                            <span class="filter-tag">Món Việt</span>
                            <span class="filter-tag">BBQ</span>
                            <span class="filter-tag">View đẹp</span>
                            <span class="filter-tag">Giá rẻ</span>
                        </div>

                        <!-- Danh sách nhà hàng - 6/trang -->
                        <c:choose>
                            <c:when test="${empty restaurants}">
                                <div class="alert">
                                    Không tìm thấy nhà hàng nào phù hợp với tiêu chí của bạn.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Tính toán phân trang -->
                                <c:set var="page" value="${param.page != null && param.page > 0 ? param.page : 1}" />
                                <c:set var="itemsPerPage" value="2" />
                                <c:set var="totalItems" value="${restaurants.size()}" />
                                <c:set var="totalPages" value="${(totalItems + itemsPerPage - 1) / itemsPerPage}" />
                                <c:set var="start" value="${(page - 1) * itemsPerPage}" />
                                <c:set var="end" value="${start + itemsPerPage - 1}" />

                                <div class="restaurants-grid" id="restaurants-container">
                                    <c:forEach var="restaurant" items="${restaurants}" begin="${start}" end="${end}">
                                        <div class="restaurant-card">
                                            <div class="card-image">
                                                <img src="${restaurant.image}" alt="${restaurant.name}">
                                                <div class="badge cuisine">
                                                    <i class="fas fa-utensils"></i>
                                                    Restaurant
                                                </div>
                                            </div>
                                            <div class="card-content">
                                                <div class="rating-price">
                                                    <div class="rating">
                                                        <div class="stars">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <i class="${i <= restaurant.avgRating.intValue() ? 'fas' : 'far'} fa-star"></i>
                                                            </c:forEach>
                                                        </div>
                                                        <span class="reviews">(${restaurant.reviewCount})</span>
                                                    </div>
                                                </div>
                                                <h3>${restaurant.name}</h3>
                                                <div class="cuisines">
                                                    <c:forEach var="cuisine" items="${restaurant.cuisines}">
                                                        <span class="specialty">${cuisine}</span>
                                                    </c:forEach>
                                                </div>
                                                <div class="location">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                    ${restaurant.area.name}
                                                </div>
                                                <a class="detail-btn" href="restaurant-detail?id=${restaurant.businessId}">
                                                    Chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- PHÂN TRANG -->
                                <div class="pagination">
                                    <!-- Trước -->
                                    <c:if test="${page > 1}">
                                        <a href="?restaurantType=${param.restaurantType}&areaId=${param.areaId}&date=${param.date}&time=${param.time}&numGuests=${param.numGuests}&minRating=${param.minRating}&page=${page - 1}" class="page-btn">Trước</a>
                                    </c:if>
                                    <c:if test="${page <= 1}">
                                        <button class="page-btn" disabled>Trước</button>
                                    </c:if>

                                    <!-- Các trang -->
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <a href="?restaurantType=${param.restaurantType}&areaId=${param.areaId}&date=${param.date}&time=${param.time}&numGuests=${param.numGuests}&minRating=${param.minRating}&page=${i}"
                                           class="page-btn ${i == page ? 'active' : ''}">${i}</a>
                                    </c:forEach>

                                    <!-- Sau -->
                                    <c:if test="${page < totalPages}">
                                        <a href="?restaurantType=${param.restaurantType}&areaId=${param.areaId}&date=${param.date}&time=${param.time}&numGuests=${param.numGuests}&minRating=${param.minRating}&page=${page + 1}" class="page-btn">Sau</a>
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
    </form>

    <%@ include file="Footer.jsp" %>

</body>
</html>