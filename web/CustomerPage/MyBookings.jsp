<%-- 
    Document   : MyBookings
    Created on : Nov 10, 2025, 6:02:57 PM
    Author     : jackd
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử Đặt chỗ - Cát Bà Booking</title>
    <%-- Sử dụng chung CSS của trang chủ --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/HomePage/style-home.css">
    
    <%-- CSS riêng cho trang này --%>
    <style>
        .booking-history-container {
            max-width: 900px;
            margin: 2rem auto;
            padding: 1rem;
            min-height: 60vh; /* Giúp đẩy footer xuống */
        }
        .booking-card {
            display: flex;
            border: 1px solid #eee;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            background: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        .booking-card-image {
            width: 200px;
            height: 150px;
            object-fit: cover;
            flex-shrink: 0;
        }
        .booking-card-details {
            padding: 1rem 1.5rem;
            flex-grow: 1;
        }
        .booking-card-details h3 {
            margin-top: 0;
            margin-bottom: 0.5rem;
            color: #007bff; /* Màu chủ đạo (ví dụ) */
        }
        .booking-card-details p {
            margin: 0.25rem 0;
            color: #555;
        }
        .booking-status {
            font-weight: bold;
            padding: 3px 8px;
            border-radius: 4px;
            color: white;
            font-size: 0.9em;
            text-transform: uppercase;
        }
        .status-PENDING { background-color: #ffc107; color: #333;}
        .status-APPROVED { background-color: #28a745; }
        .status-REJECTED { background-color: #dc3545; }
        .status-COMPLETED { background-color: #6c757d; }
        
        /* Nút (copy từ style-home.css nếu có) */
        .btn-action {
            display: inline-block;
            padding: 6px 12px;
            margin-top: 10px;
            margin-right: 5px;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            font-size: 0.9em;
        }
        .btn-danger { background-color: #dc3545; }
        .btn-primary { background-color: #007bff; }
        
    </style>
</head>
<body>

    <%-- 1. Nhúng Sidebar/Header (Đường dẫn có thể cần sửa) --%>
    <jsp:include page="/HomePage/Sidebar.jsp" />

    <div class="booking-history-container">
        <h1>Lịch sử Đặt chỗ của tôi</h1>

        <%-- 2. Hiển thị thông báo lỗi (nếu có) --%>
        <c:if test="${not empty error}">
            <div style="color: red; margin-bottom: 1rem;">${error}</div>
        </c:if>

        <%-- 3. Kiểm tra danh sách rỗng --%>
        <c:if test="${empty bookingList}">
            <p>Bạn chưa thực hiện đặt chỗ nào.</p>
        </c:if>

        <%-- 4. Lặp qua danh sách booking --%>
        <c:forEach var="booking" items="${bookingList}">
            <div class="booking-card">
                <img class="booking-card-image" src="${booking.businessImage != null ? booking.businessImage : 'default-image-path.jpg'}" alt="${booking.businessName}">
                
                <div class="booking-card-details">
                    <h3>${booking.businessName}</h3>
                    
                    <%-- Hiển thị thông tin tùy theo loại hình --%>
                    <c:if test="${booking.businessType == 'HOMESTAY'}">
                        <p><strong>Loại:</strong> Homestay</p>
                        <p><strong>Ngày nhận phòng:</strong> <fmt:formatDate value="${booking.checkInDate}" pattern="dd/MM/yyyy"/></p>
                        <p><strong>Ngày trả phòng:</strong> <fmt:formatDate value="${booking.checkOutDate}" pattern="dd/MM/yyyy"/></p>
                    </c:if>
                    <c:if test="${booking.businessType == 'RESTAURANT'}">
                        <p><strong>Loại:</strong> Nhà hàng</p>
                        <p><strong>Ngày đặt bàn:</strong> <fmt:formatDate value="${booking.reservationDate}" pattern="dd/MM/yyyy"/></p>
                        <p><strong>Giờ đặt:</strong> ${booking.reservationTime}</p>
                    </c:if>
                    
                    <p><strong>Tổng tiền:</strong> 
                        <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencyCode="VND" minFractionDigits="0" />
                    </p>
                    <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm" /></p>
                    <p><strong>Trạng thái:</strong> 
                        <span class="booking-status status-${booking.status}">${booking.status}</span>
                    </p>
                    
                    <%-- Thêm các nút hành động (nâng cao) --%>
                    <div>
                        <c:if test="${booking.status == 'PENDING' || booking.status == 'APPROVED'}">
                            <%-- Cần tạo Servlet /cancel-booking --%>
                            <a href="cancel-booking?id=${booking.bookingId}" class="btn-action btn-danger" onclick="return confirm('Bạn có chắc muốn hủy đơn này?');">Hủy đơn</a>
                        </c:if>
                         <c:if test="${booking.status == 'COMPLETED'}">
                             <%-- Cần tạo Servlet /write-review --%>
                            <a href="write-review?id=${booking.bookingId}" class="btn-action btn-primary">Viết đánh giá</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <%-- 5. Nhúng Footer (Đường dẫn có thể cần sửa) --%>
    <jsp:include page="/HomePage/Footer.jsp" />

</body>
</html> 