<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Của Tôi</title>
    <style>
        :root {
            --primary-color: #007bff;       
            --success-color: #1abc9c;       
            --text-color: #333;
            --secondary-text-color: #6c757d;
            --border-color: #dee2e6;
            --bg-light: #f8f9fa;
        }

        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; 
            background-color: var(--bg-light); 
            margin: 0; 
            padding: 0; 
        }
        
        /* Cấu trúc Container và Header */
        .container { 
            max-width: 1000px; /* Rộng hơn trang Settings để chứa table */
            margin: 30px auto; 
            background: white; 
            border-radius: 10px; 
            box-shadow: 0 8px 25px rgba(0,0,0,0.1); 
        }
        .header-top { 
            padding: 25px 40px; 
            border-bottom: 1px solid var(--border-color); 
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        /* Nút Quay lại (Dạng Button như yêu cầu) */
        .btn-back-square {
            display: inline-flex;
            align-items: center;
            padding: 8px 15px;
            background-color: white; 
            border: 1px solid var(--border-color);
            border-radius: 4px;
            color: var(--primary-color);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .btn-back-square:hover {
            background-color: #f0f0f0;
        }
        
        .page-title { 
            text-align: center; 
            margin: 0; 
            font-size: 28px; 
            font-weight: 700; 
            color: var(--text-color);
            flex-grow: 1; /* Đẩy tiêu đề vào giữa */
        }
        
        /* CSS cho phần Nội dung (Bảng Booking) */
        .content-area { 
            padding: 30px 40px; 
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th, td {
            border: 1px solid var(--border-color);
            padding: 12px 15px;
            text-align: left;
            font-size: 14px;
        }
        
        th {
            background-color: var(--bg-light);
            font-weight: 600;
        }
        
        tr:nth-child(even) {
            background-color: #fdfdfd;
        }
        
        /* CSS cho Status (Trạng thái) */
        .status {
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: 600;
            font-size: 12px;
        }
        .status-pending { background-color: #fff8e1; color: #f57f17; }
        .status-confirmed { background-color: #e8f5e9; color: #2e7d32; }
        .status-cancelled { background-color: #ffebee; color: #c62828; }
        
        .action-link {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }
        .action-link:hover {
            text-decoration: underline;
        }
        
        .no-booking {
            text-align: center;
            font-size: 18px;
            color: var(--secondary-text-color);
            padding: 50px 0;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="header-top">
             <a href="${pageContext.request.contextPath}/HomePage/Home.jsp.jsp" class="btn-back-square">← Quay lại trang chủ</a>
             <h2 class="page-title">Booking Của Tôi</h2>
             <div style="width: 150px;"></div> </div>

        <div class="content-area">
            
            <c:if test="${empty bookingList}">
                <div class="no-booking">
                    <p>Bạn chưa có booking nào.</p>
                </div>
            </c:if>

            <c:if test="${not empty bookingList}">
                <table>
                    <thead>
                        <tr>
                            <th>Mã Booking</th>
                            <th>Tên địa điểm</th>
                            <th>Bắt đầu</th>
                            <th>Kết thúc</th>
                            <th>Số khách</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${bookingList}">
                            <tr>
                                <td><strong>${booking.bookingCode}</strong></td>
                                <td>${booking.business.name}</td>
                                <td>
                                    <fmt:formatDate value="${booking.reservationStartTime}" pattern="HH:mm, dd/MM/yyyy"/>
                                </td>
                                <td>
                                    <fmt:formatDate value="${booking.reservationEndTime}" pattern="HH:mm, dd/MM/yyyy"/>
                                </td>
                                <td>${booking.numGuests}</td>
                                <td>
                                    <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                </td>
                                <td>
                                    <span class="status status-${booking.status.toLowerCase()}">
                                        ${booking.status}
                                    </span>
                                </td>
                                <td>
                                    <a href="#" class="action-link">Xem chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            
        </div>
    </div>
</body>
</html>