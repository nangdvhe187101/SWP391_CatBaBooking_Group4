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
        <link rel="stylesheet" href="style-home.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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

                        <!-- Restaurant Search Form -->
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
                                                    <option>Giờ</option>
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
                    <button class="view-all-btn">
                        <span>Xem tất cả</span>
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>

                <div class="homestays-grid">
                    <!-- Homestay Card 1 -->
                    <div class="homestay-card">
                        <div class="card-image">
                            <!-- Ảnh Homestay 1 -->
                            <img src="https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80"
                                 alt="Homestay view biển Cát Bà">
                            <div class="badge promotion">Giá rẻ</div>
                            <div class="badge discount">18% OFF</div>
                            <div class="badge type">
                                <i class="fas fa-home"></i>
                                Homestay
                            </div>
                        </div>
                        <div class="card-content">
                            <div class="rating">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                                <span class="reviews">(127)</span>
                            </div>
                            <h3>Homestay Cát Cò View Biển</h3>
                            <div class="location">
                                <i class="fas fa-map-marker-alt"></i>
                                Bãi Cát Cò 1, Cát Bà
                            </div>
                            <div class="host">
                                Chủ nhà: <span>Chị Lan</span>
                            </div>
                            <div class="features">
                                <i class="fas fa-wifi"></i>
                                <i class="fas fa-car"></i>
                                <i class="fas fa-coffee"></i>
                                <i class="fas fa-water"></i>
                            </div>
                            <div class="price-section">
                                <div class="price">
                                    <span class="current-price">450.000₫</span>
                                    <span class="original-price">550.000₫</span>
                                    <div class="per-night">mỗi đêm</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Homestay Card 2 -->
                    <div class="homestay-card">
                        <div class="card-image">
                            <!-- Ảnh Homestay 2 -->
                            <img src="https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=80"
                                 alt="Phòng nghỉ Homestay Cát Bà">
                            <div class="badge discount">20% OFF</div>
                            <div class="badge type">
                                <i class="fas fa-home"></i>
                                Villa
                            </div>
                        </div>
                        <div class="card-content">
                            <div class="rating">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                                <span class="reviews">(89)</span>
                            </div>
                            <h3>Villa Sunset Cát Bà</h3>
                            <div class="location">
                                <i class="fas fa-map-marker-alt"></i>
                                Bãi Cát Cò 3, Cát Bà
                            </div>
                            <div class="host">
                                Chủ nhà: <span>Anh Minh</span>
                            </div>
                            <div class="features">
                                <i class="fas fa-wifi"></i>
                                <i class="fas fa-car"></i>
                                <i class="fas fa-coffee"></i>
                                <i class="fas fa-water"></i>
                            </div>
                            <div class="price-section">
                                <div class="price">
                                    <span class="current-price">1.200.000₫</span>
                                    <span class="original-price">1.500.000₫</span>
                                    <div class="per-night">mỗi đêm</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Homestay Card 3 -->
                    <div class="homestay-card">
                        <div class="card-image">
                            <img src="https://images.unsplash.com/photo-1507089947368-19c1da9775ae?auto=format&fit=crop&w=800&q=80"
                                 alt="Nhà Gỗ Truyền Thống">
                            <div class="badge type">
                                <i class="fas fa-home"></i>
                                Homestay
                            </div>
                        </div>
                        <div class="card-content">
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
                            <h3>Nhà Gỗ Truyền Thống</h3>
                            <div class="location">
                                <i class="fas fa-map-marker-alt"></i>
                                Trung tâm, Cát Bà
                            </div>
                            <div class="host">
                                Chủ nhà: <span>Bác Hùng</span>
                            </div>
                            <div class="features">
                                <i class="fas fa-wifi"></i>
                                <i class="fas fa-car"></i>
                                <i class="fas fa-coffee"></i>
                            </div>
                            <div class="price-section">
                                <div class="price">
                                    <span class="current-price">350.000₫</span>
                                    <div class="per-night">mỗi đêm</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Homestay Card 4 -->
                    <div class="homestay-card">
                        <div class="card-image">
                            <img src="https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=800&q=80"
                                 alt="Homestay Gia Đình Bến Bèo">
                            <div class="badge promotion">Ưu đãi</div>
                            <div class="badge discount">13% OFF</div>
                            <div class="badge type">
                                <i class="fas fa-home"></i>
                                Homestay
                            </div>
                        </div>
                        <div class="card-content">
                            <div class="rating">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="far fa-star"></i>
                                </div>
                                <span class="reviews">(203)</span>
                            </div>
                            <h3>Homestay Gia Đình Bến Bèo</h3>
                            <div class="location">
                                <i class="fas fa-map-marker-alt"></i>
                                Bến Bèo, Cát Bà
                            </div>
                            <div class="host">
                                Chủ nhà: <span>Cô Hoa</span>
                            </div>
                            <div class="features">
                                <i class="fas fa-wifi"></i>
                                <i class="fas fa-car"></i>
                                <i class="fas fa-coffee"></i>
                                <i class="fas fa-water"></i>
                            </div>
                            <div class="price-section">
                                <div class="price">
                                    <span class="current-price">280.000₫</span>
                                    <span class="original-price">320.000₫</span>
                                    <div class="per-night">mỗi đêm</div>
                                </div>
                            </div>
                        </div>
                    </div>
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
                    <button class="view-all-btn">
                        <span>Xem tất cả</span>
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>

                <div class="restaurants-grid">
                    <!-- Restaurant Card 1 -->
                    <div class="restaurant-card">
                        <div class="card-image">
                            <!-- Ảnh Nhà hàng 1 -->
                            <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80"
                                 alt="Nhà hàng hải sản Cát Bà">
                            <div class="badge promotion">Giảm 20%</div>
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
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <span class="reviews">(234)</span>
                                </div>
                                <span class="price-range">200k - 500k</span>
                            </div>
                            <h3>Nhà Hàng Hải Sản Cát Cò</h3>
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

                    <!-- Restaurant Card 2 -->
                    <div class="restaurant-card">
                        <div class="card-image">
                            <!-- Ảnh Nhà hàng 2 -->
                            <img src="https://images.unsplash.com/photo-1528605248644-14dd04022da1?auto=format&fit=crop&w=800&q=80"
                                 alt="Không gian nhà hàng Cát Bà">
                            <div class="badge cuisine">
                                <i class="fas fa-utensils"></i>
                                Món Việt
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
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <span class="reviews">(189)</span>
                                </div>
                                <span class="price-range">50k - 150k</span>
                            </div>
                            <h3>Quán Ăn Bà Tám</h3>
                            <div class="location">
                                <i class="fas fa-map-marker-alt"></i>
                                Trung tâm, Cát Bà
                            </div>
                            <div class="hours">
                                <i class="fas fa-clock"></i>
                                06:00 - 21:00
                            </div>
                            <div class="specialties">
                                <span class="specialty">Bún cá</span>
                                <span class="specialty">Chả cá</span>
                                <span class="specialty">Bánh mì</span>
                            </div>
                            <div class="bottom-section">
                                <div class="phone">
                                    <i class="fas fa-phone"></i>
                                    <span>0912 345 678</span>
                                </div>
                                <button class="book-btn">Đặt bàn</button>
                            </div>
                        </div>
                    </div>

                    <!-- Restaurant Card 3 -->
                    <div class="restaurant-card">
                        <div class="card-image">
                            <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80"
                                 alt="BBQ Sunset Cát Bà">
                            <div class="badge cuisine">
                                <i class="fas fa-utensils"></i>
                                BBQ
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
                                    <span class="reviews">(145)</span>
                                </div>
                                <span class="price-range">150k - 300k</span>
                            </div>
                            <h3>BBQ Sunset Cát Bà</h3>
                            <div class="location">
                                <i class="fas fa-map-marker-alt"></i>
                                Bãi Cát Cò 2, Cát Bà
                            </div>
                            <div class="hours">
                                <i class="fas fa-clock"></i>
                                17:00 - 23:00
                            </div>
                            <div class="specialties">
                                <span class="specialty">Thịt nướng</span>
                                <span class="specialty">Hải sản nướng</span>
                                <span class="specialty">Bia tươi</span>
                            </div>
                            <div class="bottom-section">
                                <div class="phone">
                                    <i class="fas fa-phone"></i>
                                    <span>0934 567 890</span>
                                </div>
                                <button class="book-btn">Đặt bàn</button>
                            </div>
                        </div>
                    </div>

                    <!-- Restaurant Card 4 -->
                    <div class="restaurant-card">
                        <div class="card-image">
                            <img src="https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80"
                                 alt="Café View Đảo">
                            <div class="badge cuisine">
                                <i class="fas fa-coffee"></i>
                                Cà phê
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
                                    <span class="reviews">(98)</span>
                                </div>
                                <span class="price-range">30k - 80k</span>
                            </div>
                            <h3>Café View Đảo</h3>
                            <div class="location">
                                <i class="fas fa-map-marker-alt"></i>
                                Pháo đài, Cát Bà
                            </div>
                            <div class="hours">
                                <i class="fas fa-clock"></i>
                                07:00 - 20:00
                            </div>
                            <div class="specialties">
                                <span class="specialty">Cà phê phin</span>
                                <span class="specialty">Sinh tố</span>
                                <span class="specialty">Bánh ngọt</span>
                            </div>
                            <div class="bottom-section">
                                <div class="phone">
                                    <i class="fas fa-phone"></i>
                                    <span>0956 789 012</span>
                                </div>
                                <button class="book-btn">Đặt bàn</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Destinations Section -->
        <section class="destinations">
            <div class="container">
                <div class="section-header">
                    <h2>Điểm đến nổi bật</h2>
                    <button class="view-all-btn">
                        <span>Xem tất cả</span>
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>

                <div class="destinations-grid">
                    <div class="destination-card">
                        <div class="destination-image">
                            <img src="https://images.unsplash.com/photo-1571232167868-ba3d3667cd77?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjYXQlMjBiYSUyMGlzbGFuZCUyMHZpZXRuYW18ZW58MXx8fHwxNzU3Njg2OTg5fDA&ixlib=rb-4.1.0&q=80&w=1080"
                                 alt="Bãi Cát Cò 1">
                        </div>
                        <div class="destination-content">
                            <h3>Bãi Cát Cò 1</h3>
                            <p>Bãi biển đẹp nhất</p>
                        </div>
                    </div>

                    <div class="destination-card">
                        <div class="destination-image">
                            <img src="https://images.unsplash.com/photo-1710702418104-6bf5419ab03d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx2aWV0bmFtZXNlJTIwaG9tZXN0YXl8ZW58MXx8fHwxNzU3Njg2OTkyfDA&ixlib=rb-4.1.0&q=80&w=1080"
                                 alt="Pháo đài Cát Bà">
                        </div>
                        <div class="destination-content">
                            <h3>Pháo đài Cát Bà</h3>
                            <p>Di tích lịch sử</p>
                        </div>
                    </div>

                    <div class="destination-card">
                        <div class="destination-image">
                            <img src="https://images.unsplash.com/photo-1571232167868-ba3d3667cd77?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjYXQlMjBiYSUyMGlzbGFuZCUyMHZpZXRuYW18ZW58MXx8fHwxNzU3Njg2OTg5fDA&ixlib=rb-4.1.0&q=80&w=1080"
                                 alt="Vườn Quốc gia">
                        </div>
                        <div class="destination-content">
                            <h3>Vườn Quốc gia</h3>
                            <p>Thiên nhiên hoang dã</p>
                        </div>
                    </div>

                    <div class="destination-card">
                        <div class="destination-image">
                            <img src="https://images.unsplash.com/photo-1710702418104-6bf5419ab03d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx2aWV0bmFtZXNlJTIwaG9tZXN0YXl8ZW58MXx8fHwxNzU3Njg2OTkyfDA&ixlib=rb-4.1.0&q=80&w=1080"
                                 alt="Bến Bèo">
                        </div>
                        <div class="destination-content">
                            <h3>Bến Bèo</h3>
                            <p>Cảng du thuyền</p>
                        </div>
                    </div>
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