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
        /* CSS cho thông báo, nút, trạng thái (giữ nguyên hoặc tùy chỉnh) */
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 5px; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .btn { padding: 8px 15px; border-radius: 4px; text-decoration: none; cursor: pointer; border: none; font-size: 14px; margin: 2px; display: inline-block; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-warning { background-color: #ffc107; color: #333; }
        .btn-danger { background-color: #dc3545; color: white; }
        .homestay-details { margin-bottom: 30px; padding: 20px; background-color: #f8f9fa; border-radius: 5px; border: 1px solid #dee2e6; }
        .homestay-details h3 { margin-top: 0; border-bottom: 1px solid #ccc; padding-bottom: 10px; margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center; }
        .homestay-details p { margin: 5px 0; }
        .room-management h3 { margin-top: 0; border-bottom: 1px solid #ccc; padding-bottom: 10px; margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center;}
        .table-container { margin-top: 15px;}
        .status-active { color: green; font-weight: bold;}
        .status-inactive { color: red;}

        /* --- CSS CHO MODAL --- */
        .modal {
            /* display: none; */ /* Thay đổi display thành visibility và opacity */
            visibility: hidden; /* Ẩn ban đầu */
            opacity: 0; /* Trong suốt ban đầu */
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.5); /* Tăng độ mờ nền */
            padding-top: 60px;
            /* Thêm hiệu ứng chuyển động */
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }
        /* Class để hiện modal */
        .modal.is-visible {
            visibility: visible;
            opacity: 1;
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 30px; /* Tăng padding */
            border: 1px solid #888;
            width: 90%; /* Responsive hơn */
            max-width: 550px; /* Giảm max-width chút */
            border-radius: 8px;
            position: relative;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2); /* Thêm đổ bóng */
            /* Thêm hiệu ứng trượt nhẹ từ trên xuống (tùy chọn) */
            transform: translateY(-20px);
            transition: transform 0.3s ease-out;
        }
        .modal.is-visible .modal-content {
            transform: translateY(0); /* Vị trí cuối khi hiện */
        }

        .close-button {
            color: #aaa;
            position: absolute;
            top: 10px;
            right: 15px; /* Giảm right padding */
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            line-height: 1; /* Căn giữa dấu X */
        }
        .close-button:hover,
        .close-button:focus {
            color: black;
        }
        .modal-content h2 { margin-top: 0; margin-bottom: 25px; text-align: center; }
        .modal-content .input-group { margin-bottom: 18px; }
        .modal-content label { display: block; margin-bottom: 6px; font-weight: bold; font-size: 0.95em; color: #333;}
        .modal-content input[type="text"],
        .modal-content input[type="number"],
        .modal-content select,
        .modal-content textarea {
            width: 100%;
            padding: 12px; /* Tăng padding input */
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 1rem; /* Kích thước chữ dễ đọc hơn */
        }
        /* --- CSS CHECKBOX --- */
        .modal-content .checkbox-group {
            display: flex; /* Sử dụng flexbox */
            align-items: center; /* Căn giữa theo chiều dọc */
            margin-top: 10px; /* Thêm khoảng cách trên */
            margin-bottom: 20px; /* Thêm khoảng cách dưới */
        }
        .modal-content .checkbox-group input[type="checkbox"] {
            margin-right: 8px; /* Khoảng cách giữa checkbox và label */
            width: auto; /* Reset width */
            /* Phóng to checkbox một chút (tùy chọn) */
            transform: scale(1.1);
        }
        .modal-content .checkbox-group label {
            margin-bottom: 0; /* Reset margin bottom của label */
            font-weight: normal; /* Chữ thường */
            color: #555; /* Màu chữ nhạt hơn */
            cursor: pointer; /* Cho biết có thể click */
        }
        .modal-content .button-group { text-align: right; margin-top: 25px; border-top: 1px solid #eee; padding-top: 20px;}
    </style>
</head>
<body>
    <div class="owner-container">
        <jsp:include page="Sidebar.jsp" />

        <div class="main-content">
            <header class="header">
                <button id="sidebar-toggle">☰</button>
                <h1>Xin chào, ${sessionScope.currentUser.getFullName()}!</h1>
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

                <c:choose>
                    <c:when test="${not empty homestayDetail}">
                        <div class="homestay-details card">
                            <h3>Thông tin Homestay
                                <a href="${pageContext.request.contextPath}/restaurant-settings?id=${homestayDetail.getBusinessId()}" class="btn btn-secondary" style="font-size: 0.9em;">Chỉnh sửa thông tin chung</a>
                            </h3>
                            <p><strong>Tên:</strong> <c:out value="${homestayDetail.getName()}"/></p>
                            <p><strong>Địa chỉ:</strong> <c:out value="${homestayDetail.getAddress()}"/></p>
                            <p><strong>Khu vực:</strong> <c:out value="${homestayDetail.getArea().getName()}"/></p>
                        </div>

                        <div class="room-management card">
                            <h3>Quản lý phòng
                                <a href="${pageContext.request.contextPath}/add-room?businessId=${homestayDetail.getBusinessId()}" class="btn btn-primary">+ Thêm Phòng Mới</a>
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
                                                    <button type="button" class="btn btn-warning open-update-modal-btn"
                                                            style="font-size: 0.8em;"
                                                            data-room-id="${room.getRoomId()}"
                                                            data-business-id="${homestayDetail.getBusinessId()}"
                                                            data-room-name="<c:out value='${room.getName()}'/>"
                                                            data-room-capacity="${room.getCapacity()}"
                                                            data-room-price="${room.getPricePerNight()}"
                                                            data-room-is-active="${room.isActive}">
                                                        Sửa
                                                    </button>  
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
                        <c:if test="${empty error}">
                            <div class="alert alert-info">Bạn hiện chưa quản lý homestay nào. Vui lòng liên hệ Admin để đăng ký.</div>
                        </c:if>
                    </c:otherwise>
                </c:choose>

            </main>
        </div>
    </div>

    <div id="updateRoomModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="closeModal()">&times;</span>
            <h2>Cập nhật thông tin phòng</h2>
            <form id="updateRoomForm" action="update-homestay" method="POST">
                <input type="hidden" id="roomId_modal" name="roomId_modal">
                <input type="hidden" id="businessId_modal" name="businessId_modal">

                <div class="input-group">
                    <label for="roomName_modal">Tên phòng *</label>
                    <input type="text" id="roomName_modal" name="roomName_modal" required>
                </div>

                <div class="input-row">
                   <div class="input-group">
                       <label for="roomCapacity_modal">Sức chứa *</label>
                       <input type="number" id="roomCapacity_modal" name="roomCapacity_modal" min="1" required>
                   </div>
                    <div class="input-group">
                       <label for="roomPrice_modal">Giá/đêm (VNĐ) *</label>
                        <%-- Thêm step="any" để cho phép số thập phân nếu cần --%>
                       <input type="number" id="roomPrice_modal" name="roomPrice_modal" min="0" step="1000" required>
                   </div>
                </div>

                <div class="input-group checkbox-group">
                   <label for="roomIsActive_modal">Trạng thái</label>
                   <input type="checkbox" id="roomIsActive_modal" name="roomIsActive_modal">
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Hủy</button>
                </div>
            </form>
        </div>
    </div>


    <script>
       // --- JavaScript cho Sidebar ---
       document.addEventListener('DOMContentLoaded', function() {
           const sidebar = document.querySelector('.sidebar');
           const toggle = document.getElementById('sidebar-toggle');
           const overlay = document.getElementById('sidebar-overlay');
           // ... (code sidebar toggle) ...

           // --- JavaScript CHO MODAL ---
           const modal = document.getElementById('updateRoomModal');
           const openModalButtons = document.querySelectorAll('.open-update-modal-btn');
           const closeModalButton = modal.querySelector('.close-button'); // Lấy nút X

           // Lấy các element trong form modal
           const modalForm = document.getElementById('updateRoomForm');
           const roomIdInput = document.getElementById('roomId_modal');
           const businessIdInput = document.getElementById('businessId_modal');
           const roomNameInput = document.getElementById('roomName_modal');
           const roomCapacityInput = document.getElementById('roomCapacity_modal');
           const roomPriceInput = document.getElementById('roomPrice_modal');
           const roomIsActiveCheckbox = document.getElementById('roomIsActive_modal');

           // Hàm mở modal
           function openModal(button) {
               const roomId = button.dataset.roomId;
               const businessId = button.dataset.businessId;
               const roomName = button.dataset.roomName;
               const roomCapacity = button.dataset.roomCapacity;
               const roomPrice = button.dataset.roomPrice;
               const roomIsActive = button.dataset.roomIsActive === 'true';

               console.log("Opening modal for roomId:", roomId, "Data:", button.dataset);

               // Điền dữ liệu
               roomIdInput.value = roomId;
               businessIdInput.value = businessId;
               roomNameInput.value = roomName;
               roomCapacityInput.value = roomCapacity;
               // Cần format lại giá nếu nó có dấu phẩy từ fmt:formatNumber
               roomPriceInput.value = parseFloat(roomPrice) || 0; // Chuyển thành số
               roomIsActiveCheckbox.checked = roomIsActive;

               // Hiển thị modal với class is-visible để kích hoạt transition
               modal.classList.add('is-visible');
           }

           // Hàm đóng modal
           window.closeModal = function() { // Gán vào global scope để onclick dùng được
                modal.classList.remove('is-visible');
                // Tùy chọn: Reset form khi đóng
                // modalForm.reset();
           }

           // Thêm sự kiện click cho các nút "Sửa"
           openModalButtons.forEach(button => {
               button.addEventListener('click', function() {
                   openModal(this);
               });
           });

           // Đóng modal khi click nút X
            if (closeModalButton) {
                closeModalButton.addEventListener('click', closeModal);
            }

           // Đóng modal khi click ra ngoài vùng modal-content
           modal.addEventListener('click', function(event) {
               // Chỉ đóng nếu click vào nền mờ (modal), không phải content bên trong
               if (event.target === modal) {
                   closeModal();
               }
           });

            // Đóng modal khi nhấn phím Esc
             document.addEventListener('keydown', function(event) {
                if (event.key === "Escape" && modal.classList.contains('is-visible')) {
                    closeModal();
                }
            });

       }); // Kết thúc DOMContentLoaded

   </script>
</body>
</html>