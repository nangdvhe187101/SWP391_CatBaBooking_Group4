<%-- 
    Document   : CheckoutHomestay
    Created on : Oct 30, 2025, 2:15:00 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Xác nhận Đặt phòng - Cat Ba Eco Garden Homestay</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-homestaydetail.css" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
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
                    <h2>Thông tin người đặt</h2>
                    <p style="font-size: 0.9rem; color: #6b7280; margin-bottom: 1.5rem;">
                        Vui lòng cung cấp thông tin của bạn để hoàn tất đặt phòng.
                    </p>

                    <form action="ProcessHomestayBookingServlet" method="POST" id="checkoutForm">
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="fullName" class="form-label">Họ và tên *</label>
                                <input type="text" id="fullName" name="fullName" class="form-input" required placeholder="Nguyễn Văn A">
                            </div>
                            <div class="form-group">
                                <label for="phone" class="form-label">Số điện thoại *</label>
                                <input type="tel" id="phone" name="phone" class="form-input" required placeholder="09xxxxxxxx">
                            </div>
                        </div>
                        <div class="form-group full-width">
                            <label for="email" class="form-label">Email *</label>
                            <input type="email" id="email" name="email" class="form-input" required placeholder="nguyenvana@example.com">
                        </div>
                        <div class="form-group full-width">
                            <label for="notes" class="form-label">Yêu cầu đặc biệt (Nếu có)</label>
                            <textarea id="notes" name="notes" class="form-input" placeholder="Ví dụ: Tôi muốn nhận phòng sớm, vui lòng sắp xếp phòng ở tầng cao..."></textarea>
                        </div>
                        
                        <input type="hidden" name="roomId" value="R_123">
                        <input type="hidden" name="checkIn" value="2025-10-31">
                        <input type="hidden" name="checkOut" value="2025-11-02">
                        <input type="hidden" name="adults" value="2">
                        <input type="hidden" name="children" value="1">
                        <input type="hidden" name="totalAmount" value="1700000">

                    </form>
                </section>

                <aside class="summary-card">
                    <h3>Chi tiết đặt phòng</h3>
                    <h4>Cat Ba Eco Garden Homestay</h4>

                    <div class="summary-item-list">
                        <div class="summary-item">
                            <div>
                                <div class="summary-item-name">Phòng Đôi View Biển</div>
                                <div class="summary-item-meta">1 giường đôi</div>
                            </div>
                            <div class="summary-item-price">850.000 ₫/đêm</div>
                        </div>
                        <div class="summary-item">
                            <div>
                                <div class="summary-item-name">Nhận Phòng(Ngày đến)</div>
                                <div class="summary-item-meta">Từ 14:00</div>
                            </div>
                            <div class="summary-item-price">31/10/2025</div>
                        </div>
                         <div class="summary-item">
                            <div>
                                <div class="summary-item-name">Trả Phòng(Ngày đi)</div>
                                <div class="summary-item-meta">Từ 12:00</div>
                            </div>
                            <div class="summary-item-price">02/11/2025</div>
                        </div>
                    </div>

                    <div class="summary-details">                       
                        <div class="detail-row">
                            <span class="label">Số đêm</span>
                            <span>2 đêm</span>
                        </div>
                        <div class="detail-row">
                            <span class="label">Số khách</span>
                            <span>2 người</span>
                        </div>
                    </div>

                    <div class="summary-total">
                        <div class="total-row">
                            <span class="label">Tổng cộng</span>
                            <span>1.700.000 ₫</span>
                        </div>
                    </div>

                    <button type="submit" form="checkoutForm" class="confirm-btn">
                        <i class="fas fa-check-circle"></i>
                        Xác nhận và đặt phòng
                    </button>
                </aside>

            </div>
        </main>

        <%@ include file="Footer.jsp" %>

    </body>
</html>