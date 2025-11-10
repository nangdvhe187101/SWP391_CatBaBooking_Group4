<%-- 
    Document   : RestaurantDetail
    Created on : Nov 06, 2025
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>${restaurant.name} - Chi tiết nhà hàng</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-restaurantdetail.css" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

        <style>
            .menu-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap; /* Để xuống dòng trên di động */
            }
            .menu-search {
                position: relative;
                margin-top: 10px; /* Thêm khoảng cách khi xuống dòng */
            }
            .menu-search input[type="text"] {
                padding: 8px 12px 8px 35px; /* Thêm padding bên trái cho icon */
                border: 1px solid #ccc;
                border-radius: 20px; /* Bo tròn */
                width: 250px;
                font-size: 14px;
            }
            .menu-search .fa-search {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: #888;
                font-size: 14px;
            }
            /* Tin nhắn khi không tìm thấy kết quả */
            #noResultsMessage {
                display: none; /* Ẩn mặc định */
                text-align: center;
                width: 100%;
                padding: 20px;
            }
            /* Pagination styles from Homestay.jsp */
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


        <jsp:include page="Sidebar.jsp" />


        <main class="restaurant-detail-page">
            <div class="container detail-layout">

                <section class="left-side">


                    <div class="restaurant-header-card">
                        <div class="restaurant-cover">
                            <img src="${restaurant.image != null ? restaurant.image : 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/6a/01/c3/cultural-exchange-festival.jpg?w=900&h=500&s=1'}"
                                 alt="Nhà Hàng ${restaurant.name}" />
                        </div>
                        <div class="restaurant-main-info">

                            <div class="restaurant-top-row">
                                <div class="restaurant-name-rating">
                                    <h1>${restaurant.name}</h1>

                                    <div class="rating-line">
                                        <span class="score">
                                            <fmt:formatNumber value="${restaurant.avgRating}" pattern="0.0"/> /5
                                        </span>
                                        <div class="stars">

                                            <c:set var="fullStars" value="${restaurant.avgRating.intValue()}"/>
                                            <c:set var="halfStar" value="${restaurant.avgRating > fullStars ? 1 : 0}"/>
                                            <c:forEach begin="1" end="${fullStars}" var="i">
                                                <i class="fas fa-star"></i>

                                            </c:forEach>
                                            <c:if test="${halfStar == 1}">

                                                <i class="fas fa-star-half-alt"></i>
                                            </c:if>

                                            <c:forEach begin="${fullStars + halfStar + 1}" end="5" var="i">
                                                <i class="far fa-star"></i>

                                            </c:forEach>
                                        </div>

                                        <span class="reviews-count">
                                            (<c:out value="${restaurant.reviewCount}"/> đánh giá)
                                        </span>

                                    </div>
                                </div>
                                <div class="restaurant-meta">

                                    <div class="restaurant-meta-row">
                                        <i class="fas fa-map-marker-alt"></i>

                                        <span>${restaurant.area.name}, Hải Phòng</span>
                                    </div>
                                    <div class="restaurant-meta-row">

                                        <i class="fas fa-users"></i>
                                        <span>Sức chứa: 150 khách</span>

                                    </div>
                                    <div class="restaurant-meta-row">
                                        <i class="far fa-clock"></i>

                                        <span>Giờ mở cửa: <c:out value="${restaurant.openingHour}"/> - <c:out value="${restaurant.closingHour}"/></span>
                                    </div>

                                    <div class="restaurant-meta-row">
                                        <i class="fas fa-phone"></i>
                                        <span><c:out value="${restaurant.owner.phone != null ? restaurant.owner.phone : '028 3456 7899'}"/></span>
                                    </div>
                                </div>

                            </div>
                            <div class="restaurant-desc">
                                <c:out value="${restaurant.description != null ? restaurant.description : 'Trải nghiệm ẩm thực cao cấp tại nhà hàng của chúng tôi.'}"/>
                            </div>
                            <div class="restaurant-tags">

                                <c:choose>
                                    <c:when test="${not empty restaurant.cuisines}">
                                        <c:forEach var="cuisine" items="${restaurant.cuisines}">

                                            <span class="tag-pill">${cuisine}</span>
                                        </c:forEach>

                                    </c:when>
                                </c:choose>
                            </div>
                        </div>

                    </div>

                    <section class="menu-section">
                        <div class="menu-header">
                            <div class="menu-header-left">
                                <h2>Thực đơn ${restaurant.name}</h2>
                                <p>Chọn món bạn muốn gọi. Nhấn "Thêm" để bỏ vào hóa đơn.</p>
                            </div>
                            <div class="menu-search">
                                <i class="fas fa-search"></i>
                                <form id="searchForm" action="${pageContext.request.contextPath}/restaurant-detail" method="get">
                                    <input type="hidden" name="restaurantId" value="${restaurant.businessId}" />
                                    <input type="text" id="dishSearchInput" name="searchTerm" placeholder="Tìm món trong thực đơn..." value="${param.searchTerm}">
                                </form>
                            </div>
                        </div>
                        <c:set var="page" value="${param.dishPage != null && param.dishPage > 0 ? param.dishPage : 1}" />
                        <c:set var="itemsPerPage" value="2" />
                        <c:set var="totalItems" value="${fn:length(dishes)}" />
                        <c:set var="totalPages" value="${(totalItems + itemsPerPage - 1) / itemsPerPage}" />
                        <c:set var="start" value="${(page - 1) * itemsPerPage}" />
                        <c:set var="end" value="${start + itemsPerPage - 1}" />
                        <div class="menu-list">
                            <c:choose>
                                <c:when test="${not empty dishes}">
                                    <c:forEach var="dish" items="${dishes}" begin="${start}" end="${end}">
                                        <c:set var="cardCategoryId" value="${dish.category != null ? dish.category.categoryId : 1}"/>
                                        <c:set var="dishImage" value="${not empty dish.imageUrl ? dish.imageUrl : 'https://via.placeholder.com/300x200/28a745/ffffff?text=M%C3%B3n+%C4%82n'}"/>
                                        <c:set var="dishCategoryName" value="${dish.category != null ? dish.category.name : 'Chưa phân loại'}"/>
                                        <c:set var="availabilityText" value="${dish.isAvailable ? 'Đang bán' : 'Hết món'}"/>
                                        <c:set var="availabilityClass" value="${dish.isAvailable ? 'text-success' : 'text-danger'}"/>
                                        <div class="dish-card" 
                                             data-bs-toggle="modal" 
                                             data-bs-target="#viewDishModal"
                                             data-dish-name="${dish.name}"
                                             data-dish-image="${dishImage}"
                                             data-dish-description="${not empty dish.description ? dish.description : 'Không có mô tả chi tiết.'}"
                                             data-dish-price="${dish.price}"
                                             data-dish-category="${dishCategoryName}"
                                             data-dish-availability="${availabilityText}"
                                             data-category-id="${cardCategoryId}" 
                                             data-dish-id="${dish.dishId}"
                                             data-is-available="${dish.isAvailable}">
                                            <div class="dish-image">
                                                <img src="${dishImage}" alt="${dish.name}" />
                                            </div>
                                            <div class="dish-content">
                                                <div class="dish-top-row">
                                                    <div class="dish-name">${dish.name}</div>
                                                    <div class="dish-price">
                                                        <fmt:formatNumber value="${dish.price}" pattern="#,###"/> ₫
                                                    </div>
                                                </div>
                                                <div class="dish-actions">
                                                    <div class="availability ${availabilityClass}">
                                                        <i class="fas ${dish.isAvailable ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                                                        <span>${availabilityText}</span>
                                                    </div>
                                                    <c:if test="${dish.isAvailable}">
                                                        <button class="add-btn" type="button">+ Thêm</button>
                                                    </c:if>
                                                    <c:if test="${!dish.isAvailable}">
                                                        <button class="add-btn" disabled>+ Thêm</button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-dishes-message">
                                        <p>Nhà hàng chưa cập nhật thực đơn. Vui lòng quay lại sau!</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div id="noResultsMessage" class="no-dishes-message">
                                <p>Không tìm thấy món ăn nào phù hợp.</p>
                            </div>
                        </div>
                        <c:if test="${totalPages > 1}">
                            <div class="pagination">
                                <c:if test="${page > 1}">
                                    <a href="?id=${restaurant.businessId}&searchTerm=${param.searchTerm}&dishPage=${page - 1}" class="page-btn">Trước</a>
                                </c:if>
                                <c:if test="${page <= 1}">
                                    <button class="page-btn" disabled>Trước</button>
                                </c:if>
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <a href="?id=${restaurant.businessId}&searchTerm=${param.searchTerm}&dishPage=${i}"
                                       class="page-btn ${i == page ? 'active' : ''}">${i}</a>
                                </c:forEach>
                                <c:if test="${page < totalPages}">
                                    <a href="?id=${restaurant.businessId}&searchTerm=${param.searchTerm}&dishPage=${page + 1}" class="page-btn">Sau</a>
                                </c:if>
                                <c:if test="${page >= totalPages}">
                                    <button class="page-btn" disabled>Sau</button>
                                </c:if>
                            </div>
                        </c:if>
                    </section>                               
                </section>

                <aside class="order-summary-wrapper">
                    <div class="order-summary-card">
                        <div class="order-header">
                            <div class="order-header-title">
                                <h3>Đơn gọi món</h3>
                            </div>
                        </div>
                        <div class="order-items" id="orderItems">
                            <c:choose>
                                <c:when test="${not empty orderItems}">
                                    <c:forEach var="item" items="${orderItems}">
                                        <div class="order-item" data-dish-id="${item.dishId}">
                                            <div class="order-item-left">
                                                <img class="item-image" src="${item.dishImage}" alt="${item.dishName}" />
                                                <div class="item-name">${item.dishName}</div>
                                                <form action="${pageContext.request.contextPath}/update-cart-notes" method="post" class="notes-form">
                                                    <input type="hidden" name="dishId" value="${item.dishId}" />
                                                    <input type="hidden" name="restaurantId" value="${restaurant.businessId}" />
                                                    <textarea name="notes" class="item-note" placeholder="Ghi chú (tùy chọn)">${item.notes}</textarea>
                                                </form>
                                            </div>
                                            <div class="order-item-right">
                                                <button type="button" class="btn-remove-item" data-dish-id="${item.dishId}">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </button>
                                                <div class="item-price">
                                                    <fmt:formatNumber value="${item.priceAtBooking}" pattern="#,###"/> ₫
                                                </div>
                                                <div class="item-subtotal">
                                                    Tạm tính: 
                                                    <span class="subtotal-price">
                                                        <fmt:formatNumber value="${item.priceAtBooking * item.quantity}" pattern="#,###"/> ₫
                                                    </span>
                                                </div>
                                                <div class="item-qty-control">
                                                    <form action="${pageContext.request.contextPath}/update-cart-quantity" method="post" style="display: inline;">
                                                        <input type="hidden" name="dishId" value="${item.dishId}" />
                                                        <input type="hidden" name="restaurantId" value="${restaurant.businessId}" />
                                                        <input type="hidden" name="delta" value="-1" />
                                                        <button class="btn-item-minus" type="submit">-</button>
                                                    </form>
                                                    <span class="item-qty">${item.quantity}</span>
                                                    <form action="${pageContext.request.contextPath}/update-cart-quantity" method="post" style="display: inline;">
                                                        <input type="hidden" name="dishId" value="${item.dishId}" />
                                                        <input type="hidden" name="restaurantId" value="${restaurant.businessId}" />
                                                        <input type="hidden" name="delta" value="1" />
                                                        <button class="btn-item-plus" type="submit">+</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-cart-message">
                                        <i class="fas fa-shopping-cart"></i>
                                        <p>Giỏ hàng trống<br/>Hãy chọn món yêu thích!</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="order-footer">
                            <div class="total-row">
                                <span>Tổng cộng</span>
                                <span class="total-amount">
                                    <c:set var="totalPrice" value="0" />
                                    <c:forEach var="item" items="${orderItems}">
                                        <c:set var="totalPrice" value="${totalPrice + (item.priceAtBooking * item.quantity)}" />
                                    </c:forEach>
                                    <fmt:formatNumber value="${totalPrice}" pattern="#,###"/> ₫
                                </span>
                            </div>
                            <button type="button" id="checkoutBtn" class="checkout-btn" 
                                    ${empty orderItems ? 'disabled' : ''}>
                                <i class="fas fa-lock"></i>
                                Xác nhận đặt bàn
                            </button>
                        </div>
                    </div>
                </aside>
            </div>
        </main>

        <div id="viewDishModal" class="custom-modal-overlay">
            <div class="custom-modal-content">
                <div class="custom-modal-header">
                    <h5 class="custom-modal-title" id="viewDishModalLabel">Chi tiết món ăn</h5>
                    <button type="button" class="custom-modal-close" id="customModalCloseBtn">&times;</button>
                </div>
                <div class="custom-modal-body">
                    <div class="modal-body-layout">
                        <div class="modal-body-left">
                            <img id="viewDishImage" src="" alt="" class="modal-dish-image">
                        </div>
                        <div class="modal-body-right">
                            <label class="form-label-bold">Thông tin</label>
                            <div id="viewDishInfo">
                                <p><strong>Tên món:</strong> <span id="modalDishName"></span></p>
                                <p><strong>Danh mục:</strong> <span id="modalDishCategory"></span></p>
                                <p><strong>Giá:</strong> <span id="modalDishPrice"></span></p>
                                <p><strong>Trạng thái:</strong> 
                                    <span id="modalDishAvailabilityBadge" class="badge"></span>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="modal-body-full-width">
                        <label class="form-label-bold">Mô tả</label>
                        <div id="viewDishDescription" class="modal-dish-description"></div>
                    </div>
                </div>
                <div class="custom-modal-footer">
                    <button type="button" class="custom-modal-footer-close" id="customModalCloseFooterBtn">Đóng</button>
                </div>
            </div>
        </div>

        <form id="addToCartForm" action="${pageContext.request.contextPath}/add-to-cart" method="post" style="display: none;">
            <input type="hidden" name="dishId" id="addDishId" />
            <input type="hidden" name="restaurantId" value="${restaurant.businessId}" />
            <input type="hidden" name="quantity" value="1" />
            <input type="hidden" name="notes" value="" />
        </form>

        <jsp:include page="Footer.jsp" flush="true" />


        <script>
            document.addEventListener('DOMContentLoaded', () => {

                const RESTAURANT_ID = ${restaurant.businessId};

                // View Dish Modal
                const viewModal = document.getElementById('viewDishModal');
                const modalTriggers = document.querySelectorAll('.dish-card');
                const closeBtnHeader = document.getElementById('customModalCloseBtn');
                const closeBtnFooter = document.getElementById('customModalCloseFooterBtn');

                if (viewModal && modalTriggers.length > 0) {
                    const openModal = (triggerCard) => {
                        const name = triggerCard.dataset.dishName;
                        const image = triggerCard.dataset.dishImage;
                        const description = triggerCard.dataset.dishDescription;
                        const price = parseInt(triggerCard.dataset.dishPrice).toLocaleString('vi-VN') + ' ₫';
                        const category = triggerCard.dataset.dishCategory;
                        const availability = triggerCard.dataset.dishAvailability;

                        document.getElementById('viewDishImage').src = image;
                        document.getElementById('viewDishImage').alt = name;
                        document.getElementById('viewDishDescription').textContent = description;
                        document.getElementById('modalDishName').textContent = name;
                        document.getElementById('modalDishCategory').textContent = category;
                        document.getElementById('modalDishPrice').textContent = price;

                        const badge = document.getElementById('modalDishAvailabilityBadge');
                        badge.textContent = availability;
                        badge.classList.remove('bg-success', 'bg-danger');
                        if (availability === 'Đang bán') {
                            badge.classList.add('bg-success');
                        } else {
                            badge.classList.add('bg-danger');
                        }

                        viewModal.classList.add('active');
                    };

                    const closeModal = () => {
                        viewModal.classList.remove('active');
                    };

                    modalTriggers.forEach(card => {
                        card.addEventListener('click', (e) => {
                            if (!e.target.closest('.add-btn')) {
                                openModal(card);

                            }
                        });
                    });

                    if (closeBtnHeader) {
                        closeBtnHeader.addEventListener('click', closeModal);
                    }
                    if (closeBtnFooter) {
                        closeBtnFooter.addEventListener('click', closeModal);
                    }

                    viewModal.addEventListener('click', (e) => {
                        if (e.target === viewModal) {
                            closeModal();

                        }
                    });
                }

                const addToCartForm = document.getElementById('addToCartForm');
                document.addEventListener('click', (e) => {
                    if (e.target.classList.contains('add-btn') && !e.target.disabled) {
                        e.stopPropagation();
                        const dishCard = e.target.closest('.dish-card');

                        if (dishCard && dishCard.dataset.isAvailable === 'true') {
                            const dishId = dishCard.dataset.dishId;

                            document.getElementById('addDishId').value = dishId;
                            addToCartForm.submit();
                        }
                    }
                });
//search
                const searchInput = document.getElementById('dishSearchInput');
                const noResultsMsg = document.getElementById('noResultsMessage');

                const hasDishes = ${not empty dishes};

                if (searchInput) {
                    searchInput.addEventListener('input', function () {
                        const searchTerm = this.value.toLowerCase().trim();
                        const dishCards = document.querySelectorAll('.dish-card');
                        let visibleCount = 0;

                        dishCards.forEach(card => {

                            const dishName = card.dataset.dishName.toLowerCase();

                            if (dishName.includes(searchTerm)) {
                                card.style.display = '';
                                visibleCount++;
                            } else {
                                card.style.display = 'none';
                            }
                        });


                        if (visibleCount === 0 && searchTerm.length > 0 && hasDishes) {
                            noResultsMsg.style.display = 'block';
                        } else {
                            noResultsMsg.style.display = 'none';
                        }
                    });
                }
                // Remove from cart
                document.querySelectorAll('.btn-remove-item').forEach(btn => {
                    btn.addEventListener('click', function () {
                        const dishId = this.dataset.dishId;
                        if (confirm('Bạn có chắc muốn xóa món này khỏi giỏ hàng?')) {
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '${pageContext.request.contextPath}/remove-from-cart';


                            const dishIdInput = document.createElement('input');
                            dishIdInput.type = 'hidden';
                            dishIdInput.name = 'dishId';

                            dishIdInput.value = dishId;

                            const restaurantIdInput = document.createElement('input');
                            restaurantIdInput.type = 'hidden';

                            restaurantIdInput.name = 'restaurantId';
                            restaurantIdInput.value = RESTAURANT_ID;

                            form.appendChild(dishIdInput);
                            form.appendChild(restaurantIdInput);
                            document.body.appendChild(form);
                            form.submit();
                        }
                    });
                });

                // Auto-submit notes after delay
                let notesTimeout;
                document.querySelectorAll('.item-note').forEach(noteField => {
                    noteField.addEventListener('input', function () {
                        clearTimeout(notesTimeout);
                        const form = this.closest('.notes-form');

                        notesTimeout = setTimeout(() => {
                            form.submit();
                        }, 1000);
                    });
                });

                // Checkout button
                const checkoutBtn = document.getElementById('checkoutBtn');
                if (checkoutBtn) {
                    checkoutBtn.addEventListener('click', () => {
                        window.location.href = '${pageContext.request.contextPath}/checkout-restaurant?restaurantId=' + RESTAURANT_ID;
                    });
                }

                // Show success message if cart was updated
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('cartUpdated') === 'true') {
                    // Could show a toast notification here
                    console.log('Cart updated successfully');
                }
            });
        </script>
    </body>
</html>