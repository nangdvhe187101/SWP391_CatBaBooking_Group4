    <%-- 
    Document   : HomestayBookings
    Created on : Nov 13, 2025, 1:01:29 AM
    Author     : jackd
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>

<%-- THÊM IMPORT NÀY VÀO ĐẦU TRANG --%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.Bookings" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Owner - Lịch sử Đặt phòng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css" />
    </head>
    <body>

        <%@ include file="Sidebar.jsp" %>

        <div id="sidebar-overlay" class="hidden"></div>

        <header class="header">
            <button id="sidebar-toggle">☰</button>
            <h1>Lịch sử Đặt phòng</h1>
            <div class="header-actions">
                <span class="notification">🔔</span>
                <span class="user">O ${currentUser.fullName}</span>
            </div>
        </header>

        <div class="main-content">
            <main class="content">
                <div class="container-fluid py-3">

                    <ul class="nav nav-tabs mb-3">
                        <li class="nav-item">
                            <a class="nav-link ${currentStatus == 'all' ? 'active' : ''}" href="?status=all">Tất cả</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentStatus == 'pending' ? 'active' : ''}" href="?status=pending">Chờ xác nhận</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentStatus == 'confirmed' ? 'active' : ''}" href="?status=confirmed">Đã xác nhận</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentStatus == 'completed' ? 'active' : ''}" href="?status=completed">Đã hoàn thành</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentStatus.startsWith('cancelled') ? 'active' : ''}" href="?status=cancelled_by_user">Đã hủy</a>
                        </li>
                    </ul>

                    <div class="card">
                        <div class="card-header">
                            <h6 class="mb-0">Danh sách đơn đặt phòng</h6>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Mã Đơn</th>
                                            <th>Tên khách</th>
                                            <th>SĐT</th>
                                            <th>Số khách</th>
                                            <th>Nhận phòng</th>
                                            <th>Trả phòng</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end">Chi tiết</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty bookingList}">
                                                <tr><td colspan="9" class="text-center text-muted">Không có đơn đặt phòng nào.</td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <%-- Định nghĩa formatter một lần bên ngoài vòng lặp --%>
                                                <%! DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd-MM-yyyy"); %>
                                                
                                                <c:forEach var="booking" items="${bookingList}">
                                                    <%-- Lấy đối tượng booking (để truy cập kiểu LocalDateTime) --%>
                                                    <% Bookings currentBooking = (Bookings) pageContext.getAttribute("booking"); %>
                                                    <tr>
                                                        <td>${booking.bookingCode}</td>
                                                        <td>${booking.bookerName}</td>
                                                        <td>${booking.bookerPhone}</td>
                                                        <td>${booking.numGuests}</td>
                                                        
                                                        <%-- THAY THẾ DÒNG BỊ LỖI (Dòng 91) --%>
                                                        <td>
                                                            <%
                                                                // Kiểm tra null và định dạng
                                                                if (currentBooking.getReservationStartTime() != null) {
                                                                    out.print(currentBooking.getReservationStartTime().format(dtf));
                                                                } else {
                                                                    out.print("N/A");
                                                                }
                                                            %>
                                                        </td>
                                                        
                                                        <%-- THAY THẾ DÒNG BỊ LỖI (Dòng 92) --%>
                                                        <td>
                                                            <%
                                                                // Kiểm tra null và định dạng
                                                                if (currentBooking.getReservationEndTime() != null) {
                                                                    out.print(currentBooking.getReservationEndTime().format(dtf));
                                                                } else {
                                                                    out.print("N/A");
                                                                }
                                                            %>
                                                        </td>
                                                        
                                                        <td><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencyCode="VND" /></td>
                                                        <td>
                                                            <%-- Logic hiển thị trạng thái (giữ nguyên) --%>
                                                            <c:choose>
                                                                <c:when test="${booking.status == 'pending'}"><span class="badge bg-warning">Chờ XN</span></c:when>
                                                                <c:when test="${booking.status == 'confirmed'}"><span class="badge bg-success">Đã XN</span></c:when>
                                                                <c:when test="${booking.status == 'completed'}"><span class="badge bg-info">Hoàn thành</span></c:when>
                                                                <c:when test="${booking.status == 'cancelled_by_user' || booking.status == 'cancelled_by_owner'}"><span class="badge bg-danger">Đã hủy</span></c:when>
                                                                <c:otherwise><span class="badge bg-secondary">${booking.status}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-end">
                                                            <button class="btn btn-sm btn-outline-primary detail-btn"
                                                                    data-bs-toggle="modal" 
                                                                    data-bs-target="#bookingDetailModal"
                                                                    data-id="${booking.bookingId}"
                                                                    data-code="${booking.bookingCode}">
                                                                <i class="bi bi-eye-fill"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <c:if test="${totalPages > 1}">
                            <div class="card-footer">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center mb-0">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item"><a class="page-link" href="?status=${currentStatus}&page=${currentPage - 1}">Trước</a></li>
                                        </c:if>
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item <c:if test='${i == currentPage}'>active</c:if>">
                                                <a class="page-link" href="?status=${currentStatus}&page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item"><a class="page-link" href="?status=${currentStatus}&page=${currentPage + 1}">Sau</a></li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </div>
                </div>
            </main>
        </div>

        <div class="modal fade" id="bookingDetailModal" tabindex="-1" aria-labelledby="bookingDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="bookingDetailModalLabel">Chi tiết Đơn hàng: <span></span></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p><strong>Các phòng đã đặt:</strong></p>
                        <table class="table table-sm table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>Tên phòng</th>
                                    <th>Giá lúc đặt</th>
                                </tr>
                            </thead>
                            <tbody id="room-details-body">
                                </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        
        <%-- Toàn bộ JavaScript (Sidebar + Modal AJAX) giữ nguyên như lượt 27 --%>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Sidebar toggle (giữ nguyên)
                const sidebar = document.querySelector('.sidebar');
                const toggle = document.getElementById('sidebar-toggle');
                const overlay = document.getElementById('sidebar-overlay');
                if (toggle) {
                    toggle.addEventListener('click', () => {
                        sidebar.style.transform = 'translateX(0)';
                        overlay.classList.remove('hidden');
                    });
                }
                if (overlay) {
                    overlay.addEventListener('click', () => {
                        sidebar.style.transform = 'translateX(-100%)';
                        overlay.classList.add('hidden');
                    });
                }

                // === LOGIC MODAL CHI TIẾT (Giữ nguyên) ===
                
                // Hàm helper định dạng tiền tệ
                function formatCurrency(value) {
                    if (!value) return '0 VND';
                    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                }

                // Bắt sự kiện click nút "Chi tiết"
                $('.detail-btn').on('click', function () {
                    var bookingId = $(this).data('id');
                    var bookingCode = $(this).data('code');
                    
                    $('#bookingDetailModalLabel span').text(bookingCode); // Cập nhật mã đơn
                    var detailsBody = $('#room-details-body');
                    detailsBody.empty().html('<tr><td colspan="2" class="text-center">Đang tải...</td></tr>');

                    // Gọi AJAX đến servlet
                    $.ajax({
                        url: '${pageContext.request.contextPath}/get-homestay-booking-details',
                        type: 'GET',
                        data: { bookingId: bookingId },
                        dataType: 'json',
                        success: function (data) {
                            detailsBody.empty(); // Xóa "Đang tải..."
                            if (data && data.length > 0) {
                                data.forEach(function (room) {
                                    var row = '<tr>' +
                                                '<td>' + (room.roomName || 'N/A') + '</td>' +
                                                '<td>' + formatCurrency(room.priceAtBooking) + '</td>' +
                                              '</tr>';
                                    detailsBody.append(row);
                                });
                            } else if (data.error) {
                                // Xử lý lỗi từ server (nếu có)
                                detailsBody.html('<tr><td colspan="2" class="text-danger">' + data.error + '</td></tr>');
                            } else {
                                detailsBody.html('<tr><td colspan="2" class="text-muted">Không tìm thấy chi tiết phòng.</td></tr>');
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("Lỗi AJAX:", status, error);
                            var errorMsg = "Lỗi khi tải chi tiết. Vui lòng thử lại.";
                            if(xhr.responseJSON && xhr.responseJSON.error) {
                                errorMsg = xhr.responseJSON.error;
                            }
                            detailsBody.empty().html('<tr><td colspan="2" class="text-danger">' + errorMsg + '</td></tr>');
                        }
                    });
                });
            });
        </script>
    </body>
</html>
