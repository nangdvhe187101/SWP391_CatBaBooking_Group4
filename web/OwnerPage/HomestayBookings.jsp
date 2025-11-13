    <%-- 
    Document   : HomestayBookings
    Created on : Nov 13, 2025, 1:01:29 AM
    Author     : jackd
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.Bookings" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Quản lý Đặt phòng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css" />
        <style>
            /* === THEME MÀU XANH LÁ === */
            .nav-tabs .nav-link {
                color: #000000 !important; 
                font-weight: 600;
                background-color: #f8f9fa;
                border: 1px solid #dee2e6;
                margin-right: 4px;
            }
            .nav-tabs .nav-link:hover {
                background-color: #e2e6ea;
                color: #157347 !important;
            }
            .nav-tabs .nav-link.active {
                color: #198754 !important;
                background-color: #ffffff !important;
                border-bottom-color: transparent;
                border-top: 3px solid #198754;
            }
            .detail-section-title {
                font-size: 0.95rem; font-weight: 700; color: #198754;
                text-transform: uppercase; border-bottom: 2px solid #e9ecef;
                padding-bottom: 5px; margin-bottom: 10px;
            }
            .detail-row { margin-bottom: 5px; font-size: 0.9rem; }
            .detail-label { font-weight: 600; color: #555; min-width: 110px; display: inline-block; }
            .text-theme { color: #198754 !important; }
        </style>
    </head>
    <body>

        <%@ include file="Sidebar.jsp" %>
        <div id="sidebar-overlay" class="hidden"></div>

        <header class="header">
            <button id="sidebar-toggle">☰</button>
            <h1>Lịch sử Đặt phòng</h1>
            <div class="header-actions"><span class="user">O ${currentUser.fullName}</span></div>
        </header>

        <div class="main-content">
            <main class="content">
                <div class="container-fluid py-3">

                    <div class="card mb-3 border-success border-opacity-25">
                        <div class="card-body py-3 bg-white shadow-sm rounded">
                            <form action="homestay-bookings" method="get" class="row g-3 align-items-end">
                                <input type="hidden" name="status" value="${currentStatus}">
                                
                                <div class="col-md-4">
                                    <label class="form-label small fw-bold text-secondary">Từ khóa (Tên/SĐT)</label>
                                    <input type="text" name="search" class="form-control form-control-sm" 
                                           value="${search}" placeholder="Nhập tên khách hoặc SĐT...">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label small fw-bold text-secondary">Từ ngày</label>
                                    <input type="date" name="fromDate" class="form-control form-control-sm" value="${fromDate}">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label small fw-bold text-secondary">Đến ngày</label>
                                    <input type="date" name="toDate" class="form-control form-control-sm" value="${toDate}">
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-success btn-sm w-100 fw-bold">
                                        Lọc
                                    </button>
                                </div>
                                <div class="col-md-2">
                                    <a href="homestay-bookings" class="btn btn-outline-secondary btn-sm w-100">Đặt lại</a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <c:set var="baseLink" value="?search=${search}&fromDate=${fromDate}&toDate=${toDate}" />
                    <ul class="nav nav-tabs mb-3 border-bottom-0">
                        <li class="nav-item">
                            <a class="nav-link ${currentStatus == 'all' ? 'active' : ''}" href="${baseLink}&status=all">Tất cả</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentStatus == 'pending' ? 'active' : ''}" href="${baseLink}&status=pending">Chờ xác nhận</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentStatus == 'confirmed' ? 'active' : ''}" href="${baseLink}&status=confirmed">Đã xác nhận</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentStatus == 'completed' ? 'active' : ''}" href="${baseLink}&status=completed">Đã hoàn thành</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${currentStatus == 'cancelled_by_user' || currentStatus == 'cancelled_by_owner' ? 'active' : ''}" href="${baseLink}&status=cancelled_by_user">Đã hủy</a>
                        </li>
                    </ul>

                    <div class="card shadow-sm border-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0 align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-success">Mã Đơn</th>
                                        <th>Khách hàng</th>
                                        <th>Liên hệ</th>
                                        <th class="text-center">Khách</th>
                                        <th>Lưu trú</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th class="text-end">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty bookingList}">
                                            <tr><td colspan="8" class="text-center text-muted py-5">
                                                <i class="bi bi-inbox fs-1 d-block mb-2 text-success"></i>
                                                Không tìm thấy đơn đặt phòng nào.
                                            </td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <%! DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"); %>
                                            <c:forEach var="booking" items="${bookingList}">
                                                <% Bookings b = (Bookings) pageContext.getAttribute("booking"); %>
                                                <tr>
                                                    <td class="fw-bold text-theme">#${booking.bookingCode}</td>
                                                    <td>${booking.bookerName}</td>
                                                    <td><small>${booking.bookerPhone}</small></td>
                                                    <td class="text-center">${booking.numGuests}</td>
                                                    <td>
                                                        <div class="small">
                                                            <span class="text-success fw-bold">In:</span> 
                                                            <% out.print(b.getReservationStartTime() != null ? b.getReservationStartTime().format(dtf) : "--"); %><br>
                                                            <span class="text-danger fw-bold">Out:</span> 
                                                            <% out.print(b.getReservationEndTime() != null ? b.getReservationEndTime().format(dtf) : "--"); %>
                                                        </div>
                                                    </td>
                                                    <td class="fw-bold text-dark">
                                                        <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencyCode="VND"/>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${booking.status == 'pending'}"><span class="badge bg-warning text-dark">Chờ XN</span></c:when>
                                                            <c:when test="${booking.status == 'confirmed'}"><span class="badge bg-success">Đã XN</span></c:when>
                                                            <c:when test="${booking.status == 'completed'}"><span class="badge bg-info text-dark">Hoàn thành</span></c:when>
                                                            <c:otherwise><span class="badge bg-secondary">Đã hủy</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end">
                                                        <button class="btn btn-sm btn-outline-success detail-btn" 
                                                                data-id="${booking.bookingId}" data-code="${booking.bookingCode}">
                                                            <i class="bi bi-eye"></i> Chi tiết
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <c:if test="${totalPages > 1}">
                            <div class="card-footer bg-white py-3">
                                <nav>
                                    <ul class="pagination pagination-sm justify-content-center mb-0">
                                        <c:set var="pgLink" value="?status=${currentStatus}&search=${search}&fromDate=${fromDate}&toDate=${toDate}" />
                                        
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link text-success" href="${pgLink}&page=${currentPage - 1}">Trước</a>
                                        </li>
                                        
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                <a class="page-link ${i == currentPage ? 'bg-success border-success text-white' : 'text-success'}" 
                                                   href="${pgLink}&page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link text-success" href="${pgLink}&page=${currentPage + 1}">Sau</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </div>
                </div>
            </main>
        </div>

        <div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-light py-2">
                        <h5 class="modal-title"><i class="bi bi-receipt text-success"></i> Chi tiết đơn đặt phòng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="modalLoader" class="text-center py-4"><div class="spinner-border text-success"></div></div>
                        
                        <div id="modalContent" style="display:none;">
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <div class="detail-section-title">Tổng quan</div>
                                    <div class="detail-row"><span class="detail-label">Mã đơn:</span> <span id="d-code" class="fw-bold text-success"></span></div>
                                    <div class="detail-row"><span class="detail-label">Ngày tạo:</span> <span id="d-created"></span></div>
                                    <div class="detail-row"><span class="detail-label">Check-in:</span> <span id="d-checkin"></span></div>
                                    <div class="detail-row"><span class="detail-label">Check-out:</span> <span id="d-checkout"></span></div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <div class="detail-section-title">Khách đặt</div>
                                    <div class="detail-row"><span class="detail-label">Họ tên:</span> <span id="d-name"></span></div>
                                    <div class="detail-row"><span class="detail-label">SĐT:</span> <span id="d-phone"></span></div>
                                    <div class="detail-row"><span class="detail-label">Email:</span> <span id="d-email" class="text-break small"></span></div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <div class="detail-section-title">Thanh toán</div>
                                    <div class="detail-row"><span class="detail-label">Tổng tiền:</span> <span id="d-total" class="fw-bold text-danger"></span></div>
                                    <div class="detail-row"><span class="detail-label">Đã trả:</span> <span id="d-paid"></span></div>
                                    <div class="detail-row"><span class="detail-label">TT Booking:</span> <span id="d-status"></span></div>
                                    <div class="detail-row"><span class="detail-label">TT Thanh toán:</span> <span id="d-pay-status"></span></div>
                                </div>
                            </div>

                            <div class="detail-section-title mt-2">Danh sách phòng đã đặt</div>
                            <div class="table-responsive">
                                <table class="table table-bordered table-sm bg-white">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Tên phòng</th>
                                            <th class="text-end">Giá lúc đặt</th>
                                        </tr>
                                    </thead>
                                    <tbody id="d-room-list"></tbody>
                                </table>
                            </div>
                            
                            <div class="alert alert-light border mt-3 p-2 small">
                                <strong><i class="bi bi-sticky text-success"></i> Ghi chú:</strong> <span id="d-notes">--</span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer py-1">
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const sidebar = document.querySelector('.sidebar');
                const toggle = document.getElementById('sidebar-toggle');
                const overlay = document.getElementById('sidebar-overlay');
                if(toggle) toggle.addEventListener('click', () => { sidebar.style.transform = 'translateX(0)'; overlay.classList.remove('hidden'); });
                if(overlay) overlay.addEventListener('click', () => { sidebar.style.transform = 'translateX(-100%)'; overlay.classList.add('hidden'); });

                const fmtMoney = (v) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(v || 0);
                const fmtDate = (isoStr) => isoStr ? isoStr.replace('T', ' ').substring(0, 16) : '--';

                $('.detail-btn').on('click', function() {
                    let id = $(this).data('id');
                    let code = $(this).data('code');
                    $('#modalBookingCode').text(code);
                    $('#detailModal').modal('show');
                    $('#modalLoader').show();
                    $('#modalContent').hide();

                    $.ajax({
                        url: 'get-homestay-booking-details',
                        data: { bookingId: id },
                        dataType: 'json',
                        success: function(res) {
                            let b = res.booking;
                            let rooms = res.rooms;

                            $('#d-created').text(fmtDate(b.createdAt || b.created_at)); 
                            $('#d-checkin').text(fmtDate(b.reservationStartTime));
                            $('#d-checkout').text(fmtDate(b.reservationEndTime));
                            $('#d-name').text(b.bookerName);
                            $('#d-phone').text(b.bookerPhone);
                            $('#d-email').text(b.bookerEmail);
                            $('#d-total').text(fmtMoney(b.totalPrice));
                            $('#d-paid').text(fmtMoney(b.paidAmount));
                            
                            let stMap = { 'pending':'Chờ XN', 'confirmed':'Đã XN', 'completed':'Hoàn thành', 'cancelled_by_user':'Hủy bởi khách', 'cancelled_by_owner':'Hủy bởi chủ' };
                            $('#d-status').html(`<span class="badge bg-secondary">${stMap[b.status] || b.status}</span>`);
                            
                            let payMap = { 'unpaid':'Chưa tt', 'partially_paid':'Đã cọc', 'fully_paid':'Đã tt', 'refunded':'Hoàn tiền' };
                            $('#d-pay-status').html(`<span class="badge bg-info text-dark">${payMap[b.paymentStatus] || b.paymentStatus}</span>`);

                            $('#d-notes').text(b.notes || 'Không có');

                            let html = '';
                            if(rooms && rooms.length > 0) {
                                rooms.forEach(r => {
                                    let rName = r.roomName || r.room_name || 'Chưa có tên';
                                    let rPrice = r.priceAtBooking || r.price_at_booking || 0;
                                    html += `<tr>
                                        <td>${rName}</td>
                                        <td class="text-end">${rPrice}</td>
                                    </tr>`;
                                });
                            } else {
                                html = '<tr><td colspan="2" class="text-center text-muted">Danh sách phòng trống</td></tr>';
                            }
                            $('#d-room-list').html(html);

                            $('#modalLoader').hide();
                            $('#modalContent').fadeIn();
                        },
                        error: function(xhr) {
                            console.error(xhr);
                            alert("Lỗi tải chi tiết!");
                            $('#detailModal').modal('hide');
                        }
                    });
                });
            });
        </script>
    </body>
</html>