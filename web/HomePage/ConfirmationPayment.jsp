<%-- 
    Document   : ConfirmationPayment
    Created on : Nov 5, 2025, 7:47:48 AM
    Author     : ADMIN - FIXED: Expiry + Redirect ngay sau OK
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Xác Nhận Thanh Toán - ${restaurant.name}</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-restaurantdetail.css" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <style>
            .confirmation-container {
                display: flex;
                min-height: 80vh;
                background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            }
            .main-content {
                flex: 1;
                padding: 2rem;
                max-width: 800px;
                margin: 0 auto;
                background: white;
                border-radius: 16px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }
            .confirmation-header {
                text-align: center;
                margin-bottom: 2rem;
                color: #1e293b;
            }
            .confirmation-header h2 {
                font-size: 2rem;
                margin-bottom: 0.5rem;
                background: linear-gradient(135deg, #059669, #10b981);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }
            .info-card {
                background: #f8fafc;
                padding: 1.5rem;
                border-radius: 12px;
                border: 1px solid #e2e8f0;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            }
            .info-card p {
                margin: 0.5rem 0;
                font-size: 1rem;
                color: #475569;
            }
            .info-card strong {
                color: #1e293b;
            }
            .qr-section {
                text-align: center;
                margin: 2rem auto;
                padding: 2rem;
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                max-width: 400px;
            }
            .qr-image {
                max-width: 280px;
                width: 100%;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                margin: 0 auto 1rem auto;
                display: block;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }
            .btn-checkout {
                display: inline-block;
                padding: 12px 24px;
                background: linear-gradient(135deg, #059669, #10b981);
                color: #fff;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: 0 4px 12px rgba(5, 150, 105, 0.3);
            }
            .btn-checkout:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(5, 150, 105, 0.4);
            }
            .status-alert {
                padding: 1.5rem;
                border-radius: 12px;
                margin: 1rem 0;
                text-align: center;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
                font-size: 1.1rem;
            }
            .status-pending {
                background: linear-gradient(135deg, #fef3c7, #fde68a);
                color: #92400e;
                border: 1px solid #fbbf24;
            }
            .status-paid {
                background: linear-gradient(135deg, #d1fae5, #a7f3d0);
                color: #065f46;
                border: 1px solid #34d399;
            }
            .status-cancelled {
                background: linear-gradient(135deg, #fee2e2, #fecaca);
                color: #991b1b;
                border: 1px solid #fca5a5;
            }
            .countdown {
                font-size: 2.5rem;
                color: #dc3545;
                font-weight: bold;
                text-align: center;
                margin: 1.5rem 0;
                background: linear-gradient(135deg, #fee2e2, #fecaca);
                padding: 1rem;
                border-radius: 12px;
                border: 2px solid #fca5a5;
                font-family: 'Courier New', monospace;
                letter-spacing: 2px;
            }
            footer {
                background: #f8f9fa;
                padding: 1rem;
                text-align: center;
                border-top: 1px solid #dee2e6;
            }
            @media (max-width: 768px) {
                .main-content {
                    padding: 1rem;
                    margin: 1rem;
                    border-radius: 8px;
                }
                .confirmation-header h2 {
                    font-size: 1.5rem;
                }
                .countdown {
                    font-size: 2rem;
                }
                .qr-section {
                    padding: 1rem;
                    max-width: none;
                }
                .qr-image {
                    max-width: 250px;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="Sidebar.jsp" %>  

        <div class="confirmation-container">
            <main class="main-content">
                <div class="confirmation-header">
                    <h2><i class="fas fa-receipt"></i> Xác Nhận Thanh Toán</h2>
                    <p>Hoàn tất thanh toán để xác nhận đặt bàn tại ${restaurant.name}</p>
                </div>

                <div class="info-card">
                    <p><i class="fas fa-hashtag"></i> <strong>Mã đặt bàn:</strong> ${booking.bookingCode}</p>
                    <p><i class="fas fa-store"></i> <strong>Nhà hàng:</strong> ${restaurant.name}</p>
                    <p><i class="fas fa-calendar-day"></i> <strong>Ngày đặt:</strong> <fmt:formatDate value="${resDateForJsp}" pattern="dd/MM/yyyy"/> lúc <fmt:formatDate value="${resTimeForJsp}" pattern="HH:mm"/> </p>
                    <p><i class="fas fa-users"></i> <strong>Số khách:</strong> ${booking.numGuests}</p>
                    <p><i class="fas fa-money-bill-wave"></i> <strong>Số tiền:</strong> <fmt:formatNumber value="${amount}" type="number" maxFractionDigits="0"/> ₫</p>
                </div>

                <div id="statusAlert" class="status-alert status-pending">
                    <i class="fas fa-clock"></i> Đang chờ thanh toán... Vui lòng quét QR trong 5 phút.
                </div>

                <div class="qr-section" id="qrSection">
                    <h3 style="margin-bottom: 1rem; color: #1e293b;"><i class="fas fa-qrcode"></i> Quét mã QR để thanh toán</h3>
                    <img src="${qrImage}" alt="QR Thanh Toán" class="qr-image" />
                    <p style="font-size: 0.9rem; color: #6b7280; margin-top: 1rem;"><small><strong>Nội dung chuyển khoản:</strong> <b>TKPDVN ${bookingCode}</b></small></p>
                </div>

                <div class="countdown" id="countdown">05:00</div>

            </main>
        </div>

        <%@ include file="Footer.jsp" %>  

        <script>
            const bookingCode = '${booking.bookingCode}';
            const restaurantUrl = '${pageContext.request.contextPath}/restaurants';
            const baseUrl = '${pageContext.request.contextPath}/confirmation-payment?bookingCode=' + encodeURIComponent(bookingCode);
            const expiryTime = ${expiryTime};
            let pollInterval;
            let countdownInterval;
            let isPaid = false;
            let isExpired = false;

            console.log('=== Confirmation Payment Loaded ===');
            console.log('Booking:', bookingCode);
            console.log('Expiry Time:', new Date(expiryTime).toISOString());
            console.log('Time until expiry:', Math.floor((expiryTime - Date.now()) / 1000), 'seconds');

            // Đồng hồ đếm ngược
            function updateCountdown() {
                const now = Date.now();
                const distance = expiryTime - now;

                if (distance < 0 && !isExpired) {
                    isExpired = true;
                    handleExpiry();
                    return;
                }

                const minutes = Math.floor(distance / 60000);
                const seconds = Math.floor((distance % 60000) / 1000);
                document.getElementById('countdown').innerHTML = minutes + ':' + seconds.toString().padStart(2, '0');

                // Đổi màu khi còn dưới 1 phút
                if (distance < 60000 && distance > 0) {
                    document.getElementById('countdown').style.background = 'linear-gradient(135deg, #fecaca, #fee2e2)';
                    document.getElementById('countdown').style.animation = 'pulse 1s infinite';
                }
            }

            // Xử lý khi hết hạn
            function handleExpiry() {
                console.log('[Expiry] Booking expired!');

                // Dừng tất cả intervals
                clearInterval(pollInterval);
                clearInterval(countdownInterval);

                // Gọi API backend để cancel
                fetch('${pageContext.request.contextPath}/cancel-expired-booking', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'bookingCode=' + encodeURIComponent(bookingCode)
                })
                        .then(response => response.json())
                        .then(data => {
                            console.log('[Expiry] Backend response:', data);
                        })
                        .catch(err => {
                            console.error('[Expiry] Failed to notify backend:', err);
                        });

                // Cập nhật UI
                document.getElementById('countdown').innerHTML = '<i class="fas fa-exclamation-triangle"></i> HẾT HẠN';
                document.getElementById('countdown').style.color = '#991b1b';
                document.getElementById('countdown').style.animation = 'none';
                document.getElementById('statusAlert').className = 'status-alert status-cancelled';
                document.getElementById('statusAlert').innerHTML = '<i class="fas fa-times-circle"></i> Đơn hàng đã tự động hủy do quá 5 phút không thanh toán. Đang chuyển hướng...';
                document.getElementById('qrSection').style.display = 'none';

                // Tự động redirect sau 3 giây
                setTimeout(() => {
                    window.location.href = restaurantUrl;
                }, 3000);
            }

            // Khởi động countdown
            countdownInterval = setInterval(updateCountdown, 1000);
            updateCountdown();

            // Poll status mỗi 5s
            pollInterval = setInterval(() => {
                if (isExpired || isPaid) {
                    clearInterval(pollInterval);
                    return;
                }

                console.log('[Poll] Checking payment status...');

                fetch('${pageContext.request.contextPath}/payment-status?booking=' + encodeURIComponent(bookingCode), {
                    method: 'GET',
                    headers: {
                        'Accept': 'application/json'
                    }
                })
                        .then(response => response.json())
                        .then(data => {
                            console.log('[Poll] Status:', data);

                            if (data.status === 'paid' && !isPaid) {
                                isPaid = true;
                                clearInterval(pollInterval);
                                clearInterval(countdownInterval);

                                document.getElementById('statusAlert').className = 'status-alert status-paid';
                                document.getElementById('statusAlert').innerHTML = '<i class="fas fa-check-circle"></i> Thanh toán thành công! Đặt bàn của bạn đã được xác nhận.';
                                document.getElementById('countdown').style.display = 'none';

                                window.history.pushState({status: 'paid'}, '', baseUrl + '&status=paid');

                            } else if (data.status === 'expired' || data.status === 'cancelled' || data.status === 'failed') {
                                isExpired = true;
                                handleExpiry();
                            }
                        })
                        .catch(error => {
                            console.error('[Poll] Error:', error);
                        });
            }, 5000);

            // CSS animation cho countdown
            const style = document.createElement('style');
            style.textContent = `
             @keyframes pulse {
                0%, 100% { opacity: 1; transform: scale(1); }
                50% { opacity: 0.8; transform: scale(1.05); }
            }`;
            document.head.appendChild(style);
        </script>
    </body>
</html>