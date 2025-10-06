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
        <link rel="stylesheet" href="style-home.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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

                            <div class="form-grid">
                                <div class="form-field">
                                    <label>Khu vực tại Cát Bà</label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <select class="form-select">
                                            <option>Chọn khu vực</option>
                                            <option>Trung tâm thị trấn</option>
                                            <option>Bãi Cát Cò 1</option>
                                            <option>Bãi Cát Cò 2</option>
                                            <option>Bãi Cát Cò 3</option>
                                            <option>Bến Bèo</option>
                                            <option>Pháo đài Cát Bà</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label>Ngày nhận</label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-calendar"></i>
                                        <input type="date" class="form-input" 
                                               min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label>Ngày trả</label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-calendar"></i>
                                        <input type="date" class="form-input" 
                                               min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label>Số người</label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-users"></i>
                                        <input type="number" class="form-input" min="1" value="1" placeholder="Nhập số khách">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <button class="search-btn">
                                        <i class="fas fa-search"></i>
                                        Tìm homestay
                                    </button>
                                </div>
                            </div>
                        </div>
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

                        <!-- Amenities -->
                        <div class="filter-group">
                            <h4>Tiện nghi</h4>
                            <div class="filter-options">
                                <label class="filter-option">
                                    <input type="checkbox">
                                    <i class="fas fa-wifi"></i>
                                    <span>WiFi miễn phí</span>
                                </label>
                                <label class="filter-option">
                                    <input type="checkbox">
                                    <i class="fas fa-car"></i>
                                    <span>Chỗ đậu xe</span>
                                </label>
                                <label class="filter-option">
                                    <input type="checkbox">
                                    <i class="fas fa-coffee"></i>
                                    <span>Bữa sáng</span>
                                </label>
                                <label class="filter-option">
                                    <input type="checkbox">
                                    <i class="fas fa-water"></i>
                                    <span>View biển</span>
                                </label>
                            </div>
                        </div>

                        <button class="apply-filter-btn">Áp dụng bộ lọc</button>
                    </div>
                </div>

                <!-- Results -->
                <div class="results-section">
                    <!-- Results Header -->
                    <div class="results-header">
                        <div class="results-info">
                            <h2>Homestay tại Cát Bà</h2>
                            <p>Tìm thấy <span id="homestay-count">24</span> homestay</p>
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

                    <!-- Homestay Grid (tĩnh ví dụ) -->
                    <div class="homestays-grid" id="homestays-container">
                        <!-- Homestay Card 1 -->
                        <div class="homestay-card">
                            <div class="card-image">
                                <img src="https://images.unsplash.com/photo-1710702418104-6bf5419ab03d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx2aWV0bmFtZXNlJTIwaG9tZXN0YXl8ZW58MXx8fHwxNzU3Njg2OTkyfDA&ixlib=rb-4.1.0&q=80&w=1080" alt="Homestay Ví dụ">
                                <div class="badge type">
                                    <i class="fas fa-home"></i>
                                    Homestay
                                </div>
                            </div>
                            <div class="card-content">
                                <div class="rating-price">
                                    <div class="rating">
                                        <div class="stars">
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="far fa-star"></i>
                                        </div>
                                        <span class="reviews">(120)</span>
                                    </div>
                                    <span class="price-range">500k/đêm</span>
                                </div>
                                <h3>Homestay View Biển</h3>
                                <div class="location">
                                    <i class="fas fa-map-marker-alt"></i>
                                    Bãi Cát Cò 1
                                </div>
                                <!-- Thêm chi tiết khác nếu cần -->
                            </div>
                        </div>
                        <!-- Thêm các card khác tương tự nếu cần -->
                    </div>

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
</html>
