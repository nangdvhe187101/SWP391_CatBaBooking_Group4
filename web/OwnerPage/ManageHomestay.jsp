<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Homestay - Cát Bà Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css">
    <style>
        /* CSS cho thông báo và nút (giữ nguyên hoặc tùy chỉnh) */
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 5px; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .btn { padding: 8px 15px; border-radius: 4px; text-decoration: none; cursor: pointer; border: none; font-size: 14px; margin: 2px; display: inline-block; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-warning { background-color: #ffc107; color: #333; }
        .btn-danger { background-color: #dc3545; color: white; }
        .homestay-details { margin-bottom: 30px; padding: 20px; background-color: #f8f9fa; border-radius: 5px; border: 1px solid #dee2e6; }
        .homestay-details h3 { margin-top: 0; border-bottom: 1px solid #ccc; padding-bottom: 10px; margin-bottom: 15px; }
        .homestay-details p { margin: 5px 0; }
        .room-management h3 { margin-top: 0; border-bottom: 1px solid #ccc; padding-bottom: 10px; margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center;}
        .table-container { margin-top: 15px;}
        /* Thêm style cho trạng thái phòng (nếu cần) */
         .status-active { color: green; font-weight: bold;}
         .status-inactive { color: red;}
    </style>
</head>
<body>
    <div class="owner-container">
        <jsp:include page="Sidebar.jsp" />

        <div class="main-content">
             <%-- Header cũ của bạn --%>
            <header class="header">
                 <button id="sidebar-toggle">☰</button>
                 <h1>Xin chào, ${sessionScope.currentUser.getFullName()}!</h1> <%-- Lấy tên từ session --%>
                 <div class="header-actions">
                     <span class="notification">🔔</span>
                     <span class="user">${fn:substring(sessionScope.currentUser.getFullName(), 0, 1)} ${sessionScope.currentUser.getFullName()}</span>
                 </div>
             </header>

            <main class="content">
                 <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>

                <%-- Phần 1: Hiển thị thông tin chi tiết Homestay --%>
                <c:choose>
                    <c:when test="${not empty homestayDetail}">
                        <div class="homestay-details card">
                            <h3>Thông tin Homestay
                                <%-- Link đến trang cập nhật thông tin chung (restaurant-settings) --%>
                                <a href="${pageContext.request.contextPath}/restaurant-settings?id=${homestayDetail.getBusinessId()}" class="btn btn-secondary" style="font-size: 0.9em;">Chỉnh sửa thông tin chung</a>
                            </h3>
                            <p><strong>Tên:</strong> <c:out value="${homestayDetail.getName()}"/></p>
                            <p><strong>Địa chỉ:</strong> <c:out value="${homestayDetail.getAddress()}"/></p>
                            <p><strong>Khu vực:</strong> <c:out value="${homestayDetail.getArea().getName()}"/></p>
                            <p><strong>Mô tả:</strong> <c:out value="${homestayDetail.getDescription()}"/></p>
                            <p><strong>Giá cơ bản/đêm:</strong> <fmt:formatNumber value="${homestayDetail.getPricePerNight()}" type="currency" currencyCode="VND" minFractionDigits="0" /></p>
                            <p><strong>Trạng thái:</strong> ${homestayDetail.getStatus()}</p>
                            <%-- Thêm các thông tin khác nếu cần --%>
                        </div>

                        <%-- Phần 2: Quản lý danh sách phòng --%>
                        <div class="room-management card">
                             <h3>Quản lý phòng
                                 <%-- Nút Thêm Phòng Mới --%>
                                 <a href="${pageContext.request.contextPath}/..." class="btn btn-primary">+ Thêm Phòng Mới</a>
                             </h3>
                            <div class="table-container">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Tên Phòng</th>
                                            <th>Sức chứa</th>
                                            <th>Giá (VND/đêm)</th>
                                            <th>Trạng thái</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="room" items="${roomList}" varStatus="loop">
                                            <tr>
                                                <td>${loop.count}</td>
                                                <td><c:out value="${room.getName()}"/></td>
                                                <td>${room.getCapacity()} người</td>
                                                <td>
                                                    <fmt:formatNumber value="${room.getPricePerNight()}" type="currency" currencyCode="VND" minFractionDigits="0" />
                                                </td>
                                                 <td>
                                                     <span class="${room.isActive ? 'status-active' : 'status-inactive'}">
                                                        ${room.isActive ? 'Đang hoạt động' : 'Ngừng hoạt động'}
                                                    </span>
                                                 </td>
                                                <td>
                                                    <%-- Nút Sửa phòng --%>
                                                    <a href="${pageContext.request.contextPath}/update-homestay?roomId=${room.getRoomId()}" class="btn btn-warning" style="font-size: 0.8em;">Sửa</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty roomList}">
                                            <tr>
                                                <td colspan="6" style="text-align: center;">Chưa có phòng nào được thêm cho homestay này.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%-- Hiển thị nếu owner chưa có homestay nào --%>
                        <c:if test="${empty error}"> <%-- Chỉ hiển thị nếu không có lỗi nào khác --%>
                            <div class="alert alert-info">Bạn hiện chưa quản lý homestay nào. Vui lòng liên hệ Admin để đăng ký.</div>
                             <%-- Có thể thêm nút liên hệ hoặc hướng dẫn --%>
                        </c:if>
                    </c:otherwise>
                </c:choose>

            </main>
        </div>
    </div>
    
    <%-- Giữ lại script JS cho sidebar toggle --%>
    <script>
       document.addEventListener('DOMContentLoaded', function() {
           const sidebar = document.querySelector('.sidebar');
           const toggle = document.getElementById('sidebar-toggle');
           const overlay = document.getElementById('sidebar-overlay');
           if (toggle && sidebar && overlay) {
               toggle.addEventListener('click', () => {
                   sidebar.style.transform = 'translateX(0)';
                   overlay.classList.remove('hidden');
               });
               overlay.addEventListener('click', () => {
                   sidebar.style.transform = 'translateX(-100%)';
                   overlay.classList.add('hidden');
               });
           }
       });
   </script>
</body>
</html>