<%-- 
    Document   : RestaurantDetail
    Created on : Oct 29, 2025, 11:31:47 PM
    Author     : ADMIN
    MODIFIED   : Hard-coded version (Theme: High-end BBQ/Seafood)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Đã loại bỏ các taglib của JSTL (c, fmt) vì không còn sử dụng --%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Nhà Hàng The Signature - Tiệc & BBQ</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-restaurantdetail.css" />

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/a2e0e6ad4e.js" crossorigin="anonymous"></script>
    </head>
    <body>

        <%@ include file="Sidebar.jsp" %>

        <main class="restaurant-detail-page">
            <div class="container detail-layout">

                <section class="left-side">

                    <div class="restaurant-header-card">
                        <div class="restaurant-cover">
                            <img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/6a/01/c3/cultural-exchange-festival.jpg?w=900&h=500&s=1"
                                 alt="Nhà Hàng Secret Garden Restaurant" />
                        </div>
                        <div class="restaurant-main-info">
                            <div class="restaurant-top-row">
                                <div class="restaurant-name-rating">
                                    <h1>Nhà Hàng Secret Garden Restaurant</h1>
                                    <div class="rating-line">
                                        <span class="score">
                                            4.7/5
                                        </span>
                                        <div class="stars">
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star-half-alt"></i> </div>
                                        <span class="reviews-count">
                                            (310 đánh giá)
                                        </span>
                                    </div>
                                </div>
                                <div class="restaurant-meta">
                                    <div class="restaurant-meta-row">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <span>Cát Bà, Hải Phòng</span>
                                    </div>
                                    <div class="restaurant-meta-row">
                                        <i class="fas fa-users"></i>
                                        <span>
                                            Sức chứa:
                                            150 khách
                                        </span>
                                    </div>
                                    <div class="restaurant-meta-row">
                                        <i class="far fa-clock"></i>
                                        <span>Giờ mở cửa: 17:00 - 23:00</span>
                                    </div>
                                    <div class="restaurant-meta-row">
                                        <i class="fas fa-phone"></i>
                                        <span>
                                            028 3456 7899
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="restaurant-desc">
                                Trải nghiệm ẩm thực BBQ, hải sản cao cấp và các món ăn địa phương
                                tinh tế trong một không gian sang trọng với tầm nhìn toàn cảnh Biển Cát Bà.
                                Secret Garden Restaurant là điểm đến lý tưởng cho các buổi tiệc và sự kiện quan trọng.
                            </div>
                            <div class="restaurant-tags">
                                <span class="tag-pill">BBQ Cao Cấp</span>
                                <span class="tag-pill">Hải Sản Tươi Sống</span>
                                <span class="tag-pill">Món Ăn Địa Phương</span>
                                <span class="tag-pill">Tiệc & Sự Kiện</span>
                                <span class="tag-pill">View Đẹp</span>
                            </div>
                        </div>
                    </div>
                    <section class="menu-section">
                        <div class="menu-header">
                            <div class="menu-header-left">
                                <h2>Thực đơn A La Carte</h2>
                                <p>Chọn món bạn 
                                    muốn gọi. Nhấn "Thêm" để bỏ vào hóa đơn.</p>
                            </div>
                            <div class="menu-category-tabs">
                                <button class="category-tab-btn active" data-category-id="1">
                                    BBQ & Nướng
                                </button>
                                <button class="category-tab-btn" data-category-id="2">
                                    Hải Sản
                                </button>
                                <button class="category-tab-btn" data-category-id="3">
                                    Món Địa Phương
                                </button>
                                <button class="category-tab-btn" data-category-id="4">
                                    Đồ Uống
                                </button>
                            </div>
                        </div>
                        <div class="menu-list">
                            <div class="dish-card"
                                 data-dish-id="201"
                                 data-price="450000"
                                 data-name="Sườn Nướng Mật Ong">
                                <div class="dish-image">
                                    <img src="https://storage.quannhautudo.com/data/thumb_400/Data/images/product/2023/06/202306061148549949.webp"
                                         alt="Sườn Nướng Mật Ong" />
                                </div>
                                <div class="dish-content">
                                    <div class="dish-top-row">
                                        <div class="dish-name">Sườn Nướng Mật Ong</div>
                                        <div class="dish-price">
                                            185.000 ₫
                                        </div>
                                    </div>
                                    <div class="dish-desc">
                                        Sườn được chặt miếng vừa ăn, tẩm ướp gia vị theo công thức riêng của nhà hàng, sau đó nướng trực tiếp trên bếp than, khi nướng phết thêm mật ong để tạo hương vị đặc trưng.
                                    </div>
                                    <div class="dish-actions">
                                        <div class="availability">
                                            <i class="fas fa-check-circle"></i>
                                            <span>
                                                Còn món
                                            </span>
                                        </div>
                                        <button class="add-btn">
                                            + Thêm
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="dish-card"
                                 data-dish-id="202"
                                 data-price="1200000"
                                 data-name="Tôm Sú Sốt Me">
                                <div class="dish-image">
                                    <img src="https://storage.quannhautudo.com/data/thumb_400/Data/images/product/2024/04/202404231505291384.webp"
                                         alt="Tôm Sú Sốt Me" />
                                </div>
                                <div class="dish-content">
                                    <div class="dish-top-row">
                                        <div class="dish-name">Tôm Sú Sốt Me</div>
                                        <div class="dish-price">
                                            249.000 ₫
                                        </div>
                                    </div>
                                    <div class="dish-desc">
                                        Tôm sú tươi to cho thịt giòn ngọt, săn chắc p cùng vị chua ngọt tự nhiên của sốt me kích thích vị giác.
                                    </div>
                                    <div class="dish-actions">
                                        <div class="availability">
                                            <i class="fas fa-check-circle"></i>
                                            <span>
                                                Còn món
                                            </span>
                                        </div>
                                        <button class="add-btn">
                                            + Thêm
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="dish-card"
                                 data-dish-id="203"
                                 data-price="220000"
                                 data-name="Gỏi Sứa Sốt Thái Cải Cay">
                                <div class="dish-image">
                                    <img src="https://storage.quannhautudo.com/data/thumb_400/Data/images/product/2025/06/202506271714066553.webp"
                                         alt="Gỏi Sứa Sốt Thái Cải Cay" />
                                </div>
                                <div class="dish-content">
                                    <div class="dish-top-row">
                                        <div class="dish-name">Gỏi Sứa Sốt Thái Cải Cay</div>
                                        <div class="dish-price">
                                            109.000 ₫
                                        </div>
                                    </div>
                                    <div class="dish-desc">
                                        Sứa giòn mát kết hợp cùng xoài xanh, rau thơm và nước sốt Thái cay chua ngọt dậy vị, làm nên món khai vị cực kỳ “gắt” cho dân nhậu.
                                    </div>
                                    <div class="dish-actions">
                                        <div class="availability unavailable">
                                            <i class="fas fa-check-circle"></i>
                                            <span>
                                                Hết món
                                            </span>
                                        </div>
                                        <button class="add-btn" disabled>
                                            + Thêm
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="dish-card"
                                 data-dish-id="204"
                                 data-price="380000"
                                 data-name="Cá Chẽm Hấp Chanh">
                                <div class="dish-image">
                                    <img src="https://storage.quannhautudo.com/data/thumb_400/Data/images/product/2024/04/202404240931460066.webp"
                                         alt="Cá Chẽm Hấp Chanh" />
                                </div>
                                <div class="dish-content">
                                    <div class="dish-top-row">
                                        <div class="dish-name">Cá Chẽm Hấp Chanh</div>
                                        <div class="dish-price">
                                            259.000 ₫
                                        </div>
                                    </div>
                                    <div class="dish-desc">
                                        Thịt cá mềm ngọt, thơm nức mùi sả và lá chanh, ăn cùng với nước sốt tỏi ớt chua cay đậm đà, khiến thực khách không thể ngừng gắp.
                                    </div>
                                    <div class="dish-actions">
                                        <div class="availability">
                                            <i class="fas fa-check-circle"></i>
                                            <span>
                                                Còn món
                                            </span>
                                        </div>
                                        <button class="add-btn">
                                            + Thêm
                                        </button>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </section>
                </section>
                <aside class="order-summary-wrapper">
                    <div class="order-summary-card">
                        <div class="order-header">
                            <div class="order-header-title">
                                <h3>Đơn gọi món</h3>
                                <div class="guest-control">
                                    <div class="guest-control-label">Số khách</div>
                                    <div class="guest-qty-control">
                                        <button class="qty-btn btn-guest-minus">-</button>
                                        <div class="qty-display guest-count">2</div>
                                        <button class="qty-btn btn-guest-plus">+</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="order-items" id="orderItems">
                            <div class="order-item">
                                <div class="order-item-left">
                                    <div class="item-name">Sườn Nướng Mật Ong</div>
                                    <div class="item-note">
                                        Nướng kỹ một chút
                                    </div>
                                    <div class="item-qty-control">
                                        <button class="btn-item-minus" data-dish-id="201">-</button>
                                        <span class="item-qty">1</span>
                                        <button class="btn-item-plus" data-dish-id="201">+</button>
                                    </div>
                                </div>
                                <div class="order-item-right">
                                    <div class="item-price">
                                        185.000 ₫
                                    </div>
                                    <div class="item-subtotal">
                                        Tạm tính: 185.000 ₫
                                    </div>
                                </div>
                            </div>
                            <div class="order-item">
                                <div class="order-item-left">
                                    <div class="item-name">Tôm Sú Sốt Me</div>
                                    <div class="item-note">
                                        -
                                    </div>
                                    <div class="item-qty-control">
                                        <button class="btn-item-minus" data-dish-id="202">-</button>
                                        <span class="item-qty">1</span>
                                        <button class="btn-item-plus" data-dish-id="202">+</button>
                                    </div>
                                </div>
                                <div class="order-item-right">
                                    <div class="item-price">
                                        249.000 ₫
                                    </div>
                                    <div class="item-subtotal">
                                        Tạm tính: 249.000 ₫
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="order-footer">
                            <div class="total-row">
                                <span>Tổng cộng</span>
                                <span class="total-amount">
                                    434.000 ₫
                                </span>
                            </div>
                            <form action="CheckoutServlet" method="post">
                                <input type="hidden" name="businessId" value="res_456_xyz" />
                                <button type="submit" class="checkout-btn">
                                    <i class="fas fa-credit-card"></i>
                                    <span>Thanh toán</span>
                                </button>
                            </form>
                        </div>
                    </div>
                </aside>
            </div>
        </main>

        <%@ include file="Footer.jsp" %>
        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const guestControl = document.querySelector('.guest-qty-control');
                if (guestControl) {
                    const minusBtn = guestControl.querySelector('.btn-guest-minus');
                    const plusBtn = guestControl.querySelector('.btn-guest-plus');
                    const display = guestControl.querySelector('.guest-count');
                    plusBtn.addEventListener('click', () => {
                        let count = parseInt(display.textContent);
                        count++; 
                        display.textContent = count; 
                    });
                    minusBtn.addEventListener('click', () => {
                        let count = parseInt(display.textContent);
                        if (count > 1) { 
                            count--; 
                            display.textContent = count;
                        }
                    });
                }
                const orderItemsContainer = document.getElementById('orderItems');
                if (orderItemsContainer) {
                    orderItemsContainer.addEventListener('click', (e) => {
                        const target = e.target; 
                        if (target.classList.contains('btn-item-plus')) {
                            const control = target.closest('.item-qty-control');
                            const display = control.querySelector('.item-qty');
                            let quantity = parseInt(display.textContent);
                            quantity++; 
                            display.textContent = quantity; 
                        }
                        if (target.classList.contains('btn-item-minus')) {
                            const control = target.closest('.item-qty-control');
                            const display = control.querySelector('.item-qty');
                            let quantity = parseInt(display.textContent);
                            if (quantity > 1) { 
                                quantity--; 
                                display.textContent = quantity; 
                            }
                        }
                    });
                }

            });
        </script>
    </body>
</html>