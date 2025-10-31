<%-- 
    Document   : CheckoutRestaurant
    Created on : Oct 30, 2025, 2:00:00 AM
    Author     : ADMIN
    Purpose    : Trang xác thực thông tin và thanh toán cho nhà hàng (CÓ THÊM NGÀY/GIỜ).
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Xác nhận Thanh toán - Nhà Hàng Secret Garden</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-restaurantdetail.css" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/a2e0e6ad4e.js" crossorigin="anonymous"></script>

        <style>
            .checkout-page {
                padding: 2rem 0;
                background-color: #f9fafb;
                min-height: 80vh;
            }
            .checkout-layout {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 2rem;
            }
            .form-card {
                background: white;
                border: 1px solid #e5e7eb;
                border-radius: 0.5rem;
                padding: 2rem;
                box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            }
            .form-card h2 {
                font-size: 1.5rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 1.5rem;
                border-bottom: 1px solid #e5e7eb;
                padding-bottom: 1rem;
            }
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1.25rem;
            }
            .form-group {
                margin-bottom: 1.25rem;
            }
            .form-group.full-width {
                grid-column: 1 / -1;
            }
            .form-label {
                display: block;
                font-size: 0.875rem;
                font-weight: 500;
                color: #374151;
                margin-bottom: 0.5rem;
            }
            .form-input {
                width: 100%;
                padding: 0.75rem 1rem;
                font-size: 0.9rem;
                border: 1px solid #d1d5db;
                border-radius: 0.375rem;
                box-shadow: 0 1px 2px 0 rgba(0,0,0,0.05);
            }
            .form-input:focus {
                outline: 2px solid transparent;
                outline-offset: 2px;
                border-color: #059669;
                box-shadow: 0 0 0 2px rgba(5, 150, 105, 0.3);
            }
            textarea.form-input {
                min-height: 100px;
                resize: vertical;
            }
            .summary-card {
                background: white;
                border: 1px solid #e5e7eb;
                border-radius: 0.5rem;
                box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
                position: sticky;
                top: 1rem;
                max-height: calc(100vh - 4rem);
            }
            .summary-card h3 {
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
                padding: 1.5rem;
                border-bottom: 1px solid #e5e7eb;
            }
            .summary-card h4 {
                font-size: 1rem;
                font-weight: 500;
                color: #111827;
                padding: 0 1.5rem;
                margin-top: 1rem;
                margin-bottom: 0.5rem;
            }
            .summary-item-list {
                padding: 1rem 1.5rem;
                max-height: 300px;
                overflow-y: auto;
                border-bottom: 1px solid #e5e7eb;
            }
            .summary-item {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                padding: 0.75rem 0;
                border-bottom: 1px dashed #e5e7eb;
            }
            .summary-item:last-child {
                border-bottom: none;
            }
            .summary-item-name {
                font-size: 0.9rem;
                font-weight: 500;
                color: #374151;
            }
            .summary-item-meta {
                font-size: 0.8rem;
                color: #6b7280;
            }
            .summary-item-price {
                font-size: 0.9rem;
                font-weight: 500;
                color: #111827;
                white-space: nowrap;
            }
            .summary-details {
                padding: 1rem 1.5rem;
                border-bottom: 1px solid #e5e7eb;
            }
            .detail-row {
                display: flex;
                justify-content: space-between;
                font-size: 0.875rem;
                color: #374151;
                margin-bottom: 0.5rem;
            }
            .detail-row .label {
                color: #6b7280;
            }
            .summary-total {
                padding: 1.5rem;
                background-color: #f9fafb;
                border-top: 1px solid #e5e7eb;
            }
            .total-row {
                display: flex;
                justify-content: space-between;
                align-items: baseline;
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 0.5rem;
            }
            .total-row .label {
                font-size: 1rem;
                font-weight: 500;
            }
            .confirm-btn {
                width: 100%;
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 0.5rem;
                background: #059669;
                color: white;
                border: none;
                border-radius: 0 0 0.5rem 0.5rem;
                font-size: 1rem;
                font-weight: 600;
                padding: 1rem;
                cursor: pointer;
                transition: background-color 0.2s;
            }
            .confirm-btn:hover {
                background: #047857;
            }
            @media (max-width: 992px) {
                .checkout-layout {
                    grid-template-columns: 1fr;
                }
                .summary-card {
                    position: static;
                    grid-row: 1;
                }
                .form-card {
                    margin-top: 2rem;
                }
            }
            @media (max-width: 768px) {
                .form-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>

        <%@ include file="Sidebar.jsp" %>

        <main class="checkout-page">
            <div class="container checkout-layout">

                <section class="form-card">
                    <h2>Thông tin liên hệ & Đặt bàn</h2>
                    <p style="font-size: 0.9rem; color: #6b7280; margin-bottom: 1.5rem;">
                        Vui lòng cung cấp thông tin để nhà hàng xác nhận đơn hàng của bạn.
                    </p>

                    <form action="ProcessRestaurantPaymentServlet" method="POST" id="checkoutForm">
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="fullName" class="form-label">Họ và tên *</label>
                                <input type="text" id="fullName" name="fullName" class="form-input" required placeholder="Nguyễn Văn A">
                            </div>
                            <div class="form-group">
                                <label for="phone" class="form-label">Số điện thoại *</label>
                                <input type="tel" id="phone" name="phone" class="form-input" required placeholder="09xxxxxxxx">
                            </div>
                            <div class="form-group">
                                <label for="arrivalDate" class="form-label">Ngày đến *</label>
                                <input type="date" id="arrivalDate" name="arrivalDate" class="form-input" required value="2025-10-31">
                            </div>
                            <div class="form-group">
                                <label for="arrivalTime" class="form-label">Giờ đến *</label>
                                <input type="time" id="arrivalTime" name="arrivalTime" class="form-input" required value="18:30">
                            </div>

                        </div>

                        <div class="form-group full-width">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" id="email" name="email" class="form-input" placeholder="nguyenvana@example.com">
                        </div>
                        <div class="form-group full-width">
                            <label for="notes" class="form-label">Ghi chú cho nhà hàng</label>
                            <textarea id="notes" name="notes" class="form-input" placeholder="Ví dụ: Cho tôi thêm 2 bộ đũa muỗng, không lấy ớt..."></textarea>
                        </div>

                        <input type="hidden" name="item_201" value="1"> 
                        <input type="hidden" name="item_202" value="1"> 
                        <input type="hidden" name="totalAmount" value="434000">

                    </form>
                </section>

                <aside class="summary-card">
                    <h3>Đơn hàng của bạn</h3>
                    <h4>Nhà Hàng Secret Garden Restaurant</h4>
                    <div class="summary-item-list">
                        <div class="summary-item">
                            <div>
                                <div class="summary-item-name">Số Lượng Khách</div>
                            </div>
                            <div class="summary-item-price">4 người</div>
                        </div>
                    </div>

                    <h4>Chi tiết món ăn</h4>
                    <div class="summary-item-list">
                        <div class="summary-item">
                            <div>
                                <div class="summary-item-name">Sườn Nướng Mật Ong</div>
                                <div class="summary-item-meta">SL: 1 x 185.000 ₫</div>
                            </div>
                            <div class="summary-item-price">185.000 ₫</div>
                        </div>
                        <div class="summary-item">
                            <div>
                                <div class="summary-item-name">Tôm Sú Sốt Me</div>
                                <div class="summary-item-meta">SL: 1 x 249.000 ₫</div>
                            </div>
                            <div class="summary-item-price">249.000 ₫</div>
                        </div>
                    </div>

                    <div class="summary-total">
                        <div class="total-row">
                            <span class="label">Tổng cộng</span>
                            <span>434.000 ₫</span>
                        </div>
                    </div>

                    <button type="submit" form="checkoutForm" class="confirm-btn">
                        <i class="fas fa-lock"></i>
                        Xác nhận thanh toán
                    </button>
                </aside>

            </div>
        </main>
        <%@ include file="Footer.jsp" %>
    </body>
</html>