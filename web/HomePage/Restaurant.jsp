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
                        <h1>Nhà hàng tại Cát Bà</h1>
                        <p>Khám phá ẩm thực đặc sắc và đặt bàn trực tuyến</p>
                    </div>

                    <!-- Search Form -->
                    <div class="search-forms">
                        <div class="search-form active" id="restaurant-search">
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

                            <div class="form-grid">
                                <div class="form-field">
                                    <label>Loại hình</label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-utensils"></i>
                                        <select class="form-select">
                                            <option>Chọn loại nhà hàng</option>
                                            <option>Nhà hàng hải sản</option>
                                            <option>Quán ăn địa phương</option>
                                            <option>Nướng BBQ</option>
                                            <option>Quán cà phê</option>
                                            <option>Bar/Pub</option>
                                            <option>Lẩu</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label>Ngày đặt bàn</label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-calendar"></i>
                                        <input type="date" class="form-input" 
                                               min="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <div class="time-guests">
                                        <div class="time-field">
                                            <label>Giờ</label>
                                            <div class="input-wrapper">
                                                <i class="fas fa-clock"></i>
                                                <select class="form-select">
                                                    <option>11:00</option>
                                                    <option>12:00</option>
                                                    <option>13:00</option>
                                                    <option>18:00</option>
                                                    <option>19:00</option>
                                                    <option>20:00</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="guests-field">
                                            <label>Số người</label>
                                            <div class="input-wrapper">
                                                <i class="fas fa-users"></i>
                                                <input type="number" class="form-input" min="1" value="2" placeholder="Nhập số người">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-field">
                                    <button class="search-btn">
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

                            <!-- Cuisine Type -->
                            <div class="filter-group">
                                <h4>Loại món ăn</h4>
                                <div class="filter-options">
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Hải sản</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Món Việt</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>BBQ/Nướng</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Cà phê</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Lẩu</span>
                                    </label>
                                </div>
                            </div>

                            <!-- Price Range -->
                            <div class="filter-group">
                                <h4>Khoảng giá</h4>
                                <div class="filter-options">
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Dưới 100k</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>100k - 200k</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>200k - 500k</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Trên 500k</span>
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

                            <!-- Location -->
                            <div class="filter-group">
                                <h4>Khu vực</h4>
                                <div class="filter-options">
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Trung tâm</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Bãi Cát Cò 1</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Bãi Cát Cò 2</span>
                                    </label>
                                    <label class="filter-option">
                                        <input type="checkbox">
                                        <span>Bến Bèo</span>
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
                                <h2>Nhà hàng tại Cát Bà</h2>
                                <p>Tìm thấy <span id="restaurant-count">18</span> nhà hàng</p>
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

                        <!-- Popular Filters -->
                        <div class="popular-filters">
                            <span class="filter-tag">Hải sản tươi</span>
                            <span class="filter-tag">Món Việt</span>
                            <span class="filter-tag">BBQ</span>
                            <span class="filter-tag">View đẹp</span>
                            <span class="filter-tag">Giá rẻ</span>
                        </div>

                        <!-- Restaurant Grid (tĩnh ví dụ) -->
                        <div class="restaurants-grid" id="restaurants-container">
                            <!-- Restaurant Card 1 -->
                            <div class="restaurant-card">
                                <div class="card-image">
                                    <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80" alt="Nhà hàng Hải Sản Cát Bà">
                                    <div class="badge cuisine">
                                        <i class="fas fa-utensils"></i>
                                        Hải sản
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
                                            <span class="reviews">(156)</span>
                                        </div>
                                        <span class="price-range">200k - 500k</span>
                                    </div>
                                    <h3>Nhà hàng Hải Sản Cát Bà</h3>
                                    <div class="location">
                                        <i class="fas fa-map-marker-alt"></i>
                                        Bãi Cát Cò 1, Cát Bà
                                    </div>
                                    <div class="hours">
                                        <i class="fas fa-clock"></i>
                                        11:00 - 22:00
                                    </div>
                                    <div class="specialties">
                                        <span class="specialty">Cua rang me</span>
                                        <span class="specialty">Tôm nướng</span>
                                        <span class="specialty">Cá hấp</span>
                                    </div>
                                    <div class="bottom-section">
                                        <div class="phone">
                                            <i class="fas fa-phone"></i>
                                            <span>0987 654 321</span>
                                        </div>
                                        <button class="book-btn">Đặt bàn</button>
                                    </div>
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

    </body>
</html>
