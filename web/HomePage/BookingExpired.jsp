<%-- 
    Document   : BookingExpired
    Created on : Nov 10, 2025, 10:22:03 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Đã Hết Hạn - CatBa Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .expired-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        .expired-card {
            max-width: 600px;
            width: 100%;
            padding: 3rem;
            text-align: center;
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        }
        .expired-icon {
            font-size: 5rem;
            color: #dc2626;
            margin-bottom: 1.5rem;
            animation: shake 0.5s;
        }
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px) rotate(-5deg); }
            75% { transform: translateX(10px) rotate(5deg); }
        }
        .expired-title {
            font-size: 2rem;
            color: #991b1b;
            margin-bottom: 1rem;
            font-weight: 700;
        }
        .expired-message {
            font-size: 1.1rem;
            color: #6b7280;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        .btn-back {
            display: inline-block;
            padding: 14px 36px;
            background: linear-gradient(135deg, #dc2626, #ef4444);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s;
            box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
        }
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(220, 38, 38, 0.4);
        }
        .redirect-info {
            margin-top: 2rem;
            font-size: 0.9rem;
            color: #9ca3af;
        }
        .countdown-redirect {
            font-weight: 700;
            color: #dc2626;
        }
    </style>
</head>
<body>
    <%@ include file="Sidebar.jsp" %>
    
    <div class="expired-container">
        <div class="expired-card">
            <i class="fas fa-clock expired-icon"></i>
            <h1 class="expired-title">Booking Đã Hết Hạn</h1>
            <p class="expired-message">
                ${errorMessage != null ? errorMessage : 'Booking của bạn đã hết hạn do quá 5 phút không thanh toán. Vui lòng đặt bàn lại để tiếp tục.'}
            </p>
            <a href="${pageContext.request.contextPath}/restaurants" class="btn-back">
                <i class="fas fa-arrow-left"></i> Quay lại đặt bàn
            </a>
            <p class="redirect-info">
                Tự động chuyển hướng sau <span class="countdown-redirect" id="countdown">5</span> giây...
            </p>
        </div>
    </div>
    
    <%@ include file="Footer.jsp" %>
    
    <script>
        // Countdown redirect
        let seconds = 5;
        const countdownEl = document.getElementById('countdown');
        
        const interval = setInterval(() => {
            seconds--;
            countdownEl.textContent = seconds;
            
            if (seconds <= 0) {
                clearInterval(interval);
                window.location.href = '${pageContext.request.contextPath}/restaurants';
            }
        }, 1000);
    </script>
</body>
</html>
