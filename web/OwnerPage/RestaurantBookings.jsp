<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Owner - Đặt bàn</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css" />
        <style>
            body {
                background: #f8f9fa;
            }
            .main-content {
                display: flex;
            }
            .content {
                flex: 1;
                padding: 1rem;
                max-width: 1200px;
                margin: 0 auto;
            }
            .chip {
                display: inline-flex;
                align-items: center;
                gap: .25rem;
                padding: .125rem .5rem;
                border-radius: 999px;
                background: #f1f3f5;
                font-size: .825rem;
            }
            .table-sticky thead th {
                position: sticky;
                top: 0;
                z-index: 1;
                background: #f8f9fa;
            }
            #sidebar-overlay.hidden {
                display: none;
            }
            #sidebar-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,.35);
                z-index: 1020;
            }
            .text-mono {
                font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
            }
            .modal-title .badge {
                vertical-align: middle;
            }
            .kv {
                display: grid;
                grid-template-columns: 160px 1fr;
                gap: .25rem 1rem;
            }
            .kv .k {
                color: #6c757d;
                font-size: .9rem;
            }
            .kv .v {
                font-weight: 500;
            }
            .section-title {
                font-weight: 600;
                font-size: .95rem;
                color: #6c757d;
                text-transform: uppercase;
                letter-spacing: .03em;
            }
            .soft-card {
                border: 1px solid #e9ecef;
                border-radius: .75rem;
                background: #fff;
            }
            .dl-2col {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: .5rem 1rem;
            }

            /* PHÂN TRANG - GIỐNG HOMESTAY */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                margin: 20px 0;
                flex-wrap: wrap;
            }

            .page-btn {
                min-width: 40px;
                height: 40px;
                padding: 0 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                background: #fff;
                color: #6c757d;
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s ease;
                cursor: pointer;
            }

            .page-btn:hover:not(.active):not([disabled]) {
                border-color: #aaa;
                color: #333;
            }

            .page-btn.active {
                background-color: #0d6efd;
                color: white;
                border-color: #0d6efd;
                font-weight: 600;
            }

            .page-btn[disabled] {
                color: #aaa;
                background-color: #f8f9fa;
                cursor: not-allowed;
                border-color: #eee;
            }

            @media (max-width: 768px) {
                .kv {
                    grid-template-columns: 120px 1fr;
                }
                .dl-2col {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="Sidebar.jsp" %>
        <div id="sidebar-overlay" class="hidden"></div>
        <header class="header">
            <button id="sidebar-toggle">☰</button>
            <h1 class="h5 mb-0">Xin chào, Owner!</h1>
            <div class="header-actions d-flex align-items-center gap-3">
                <span class="notification">🔔</span>
                <span class="user">O Owner Name</span>
            </div>
        </header>
        <div class="main-content">
            <main class="content">
                <!-- Hiển thị thông báo nếu có -->
                <c:if test="${not empty message}">
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <!-- Form lọc -->
                <form class="row g-3 bg-white p-3 rounded-3 border mb-3" method="post" action="${pageContext.request.contextPath}/owner-booking">
                    <div class="col-md-3">
                        <label class="form-label">Ngày</label>
                        <input type="date" class="form-control" name="reservationDate" value="${param.reservationDate}"/>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Giờ</label>
                        <input type="time" class="form-control" name="reservationTime" value="${param.reservationTime}"/>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Số khách</label>
                        <input type="number" class="form-control" name="numGuests" min="1" value="${param.numGuests}"/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" name="status">
                            <option value="">Tất cả</option>
                            <option value="confirmed" ${param.status == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-dark w-100">Lọc</button>
                    </div>
                </form>

                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">Danh sách booking</span>
                        <div class="d-flex gap-2">
                            <!-- Form tìm kiếm -->
                            <form method="post" action="${pageContext.request.contextPath}/owner-booking" class="d-flex gap-2">
                                <input type="search" class="form-control form-control-sm" name="searchCode" placeholder="Tìm theo mã" value="${param.searchCode}"/>
                                <button type="submit" class="btn btn-sm btn-dark">Tìm</button>
                                <!-- Giữ các giá trị lọc hiện tại -->
                                <input type="hidden" name="reservationDate" value="${param.reservationDate}"/>
                                <input type="hidden" name="reservationTime" value="${param.reservationTime}"/>
                                <input type="hidden" name="numGuests" value="${param.numGuests}"/>
                                <input type="hidden" name="status" value="${param.status}"/>
                            </form>
                        </div>
                    </div>

                    <!-- LOGIC PHÂN TRANG GIỐNG HOMESTAY -->
                    <c:set var="page" value="${param.page != null && param.page > 0 ? param.page : 1}" />
                    <c:set var="itemsPerPage" value="8" />
                    <c:set var="totalItems" value="${bookings.size()}" />
                    <c:set var="totalPages" value="${(totalItems + itemsPerPage - 1) / itemsPerPage}" />
                    <c:set var="start" value="${(page - 1) * itemsPerPage}" />
                    <c:set var="end" value="${start + itemsPerPage - 1}" />

                    <div class="table-responsive table-sticky" style="max-height:60vh;">
                        <table class="table table-hover table-sm align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Mã</th>
                                    <th>Khách đặt</th>
                                    <th>Liên hệ</th>
                                    <th>Bàn</th>
                                    <th>Giờ</th>
                                    <th>Khách</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${bookings}" begin="${start}" end="${end}">
                                    <tr>
                                        <td class="text-mono small">${booking.bookingCode}</td>
                                        <td>
                                            <div class="fw-semibold">${booking.bookerName}</div>
                                            <div class="small text-muted">${booking.bookerEmail}</div>
                                        </td>
                                        <td class="small"><span class="chip">${booking.bookerPhone}</span></td>
                                        <td><span class="badge text-bg-light border">${booking.tableName}</span></td>
                                        <td class="small">
                                            <div class="fw-semibold">
                                                ${booking.reservationDate}
                                            </div>
                                            <div class="text-muted">${booking.reservationTime}</div>
                                        </td>
                                        <td>${booking.numGuests}</td>
                                        <td class="fw-semibold">
                                            <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${booking.paymentStatus == 'fully_paid'}">
                                                    <span class="badge text-bg-success">Đã xác nhận</span>
                                                </c:when>
                                                <c:when test="${booking.paymentStatus == 'refunded'}">
                                                    <span class="badge text-bg-danger">Đã hủy</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#detail-${booking.bookingCode}">Chi tiết</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="card-footer">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div class="small text-muted">
                                Tổng: ${totalItems} booking | Trang ${page}
                            </div>
                        </div>

                        <!-- PHÂN TRANG GIỐNG HOMESTAY -->
                        <div class="pagination">
                            <c:if test="${page > 1}">
                                <a href="?reservationDate=${param.reservationDate}&reservationTime=${param.reservationTime}&numGuests=${param.numGuests}&status=${param.status}&searchCode=${param.searchCode}&page=${page - 1}" class="page-btn">Trước</a>
                            </c:if>
                            <c:if test="${page <= 1}">
                                <button class="page-btn" disabled>Trước</button>
                            </c:if>

                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <a href="?reservationDate=${param.reservationDate}&reservationTime=${param.reservationTime}&numGuests=${param.numGuests}&status=${param.status}&searchCode=${param.searchCode}&page=${i}"
                                   class="page-btn ${i == page ? 'active' : ''}">${i}</a>
                            </c:forEach>

                            <c:if test="${page < totalPages}">
                                <a href="?reservationDate=${param.reservationDate}&reservationTime=${param.reservationTime}&numGuests=${param.numGuests}&status=${param.status}&searchCode=${param.searchCode}&page=${page + 1}" class="page-btn">Sau</a>
                            </c:if>
                            <c:if test="${page >= totalPages}">
                                <button class="page-btn" disabled>Sau</button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Modal chi tiết -->
<c:forEach var="booking" items="${bookings}">
    <div class="modal fade" id="detail-${booking.bookingCode}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header border-0 pb-0">
                    <div class="w-100">
                        <div class="d-flex justify-content-between align-items-start">
                            <h5 class="modal-title">
                                Đơn <span class="text-mono">${booking.bookingCode}</span>
                                <c:choose>
                                    <c:when test="${booking.paymentStatus == 'fully_paid'}">
                                        <span class="badge text-bg-success ms-2">Đã xác nhận</span>
                                    </c:when>
                                    <c:when test="${booking.paymentStatus == 'refunded'}">
                                        <span class="badge text-bg-danger ms-2">Đã hủy</span>
                                    </c:when>
                                </c:choose>
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="text-muted small mt-1">
                            Tạo ngày ${booking.reservationDate} • Cập nhật ${booking.reservationDate}
                        </div>
                    </div>
                </div>
                <div class="modal-body pt-3">
                    <div class="row g-3">
                        <div class="col-lg-5">
                            <div class="soft-card p-3">
                                <div class="section-title mb-2">Tổng quan</div>
                                <div class="kv">
                                    <div class="k">Trạng thái</div>
                                    <div class="v">
                                        <c:choose>
                                            <c:when test="${booking.paymentStatus == 'fully_paid'}">Đã xác nhận</c:when>
                                            <c:when test="${booking.paymentStatus == 'refunded'}">Đã hủy</c:when>
                                        </c:choose>
                                    </div>
                                    <div class="k">Số khách</div><div class="v">${booking.numGuests}</div>
                                    <div class="k">Bàn</div><div class="v"><span class="badge text-bg-light border">${booking.tableName}</span></div>
                                    <div class="k">Ngày Giờ</div><div class="v">${booking.reservationDate} ${booking.reservationTime}</div>
                                </div>
                            </div>
                            <div class="soft-card p-3 mt-3">
                                <div class="section-title mb-2">Thanh toán</div>
                                <div class="dl-2col">
                                    <div class="text-muted small">Tổng tiền</div>
                                    <div class="fw-semibold"><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/></div>
                                    <div class="text-muted small">Trạng thái</div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${booking.paymentStatus == 'fully_paid'}">
                                                <span class="badge text-bg-success">Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${booking.paymentStatus == 'refunded'}">
                                                <span class="badge text-bg-secondary">Đã hoàn tiền</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <div class="soft-card p-3">
                                <div class="section-title mb-2">Khách đặt</div>
                                <div class="kv">
                                    <div class="k">Họ tên</div><div class="v">${booking.bookerName}</div>
                                    <div class="k">Email</div><div class="v">${booking.bookerEmail}</div>
                                    <div class="k">Điện thoại</div><div class="v"><span class="chip">${booking.bookerPhone}</span></div>
                                </div>
                            </div>
                            
                            <!-- Phần Món đặt trước -->
                            <div class="soft-card p-3 mt-3">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div class="section-title mb-0">Món đặt trước</div>
                                    <div class="small text-muted">Giá tại thời điểm đặt</div>
                                </div>
                                
                                <c:choose>
                                    <c:when test="${empty booking.bookedDishes}">
                                        <div class="text-center text-muted py-3">
                                            <i class="bi bi-inbox"></i>
                                            <p class="mb-0 small">Không có món đặt trước</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-sm table-hover mb-0">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Món</th>
                                                        <th class="text-center" style="width: 60px;">SL</th>
                                                        <th class="text-end" style="width: 120px;">Đơn giá</th>
                                                        <th style="width: 150px;">Ghi chú</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="dish" items="${booking.bookedDishes}">
                                                        <tr>
                                                            <td>${dish.dishName}</td>
                                                            <td class="text-center">${dish.quantity}</td>
                                                            <td class="text-end">
                                                                <fmt:formatNumber value="${dish.priceAtBooking}" 
                                                                    type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                            </td>
                                                            <td class="small text-muted">
                                                                <c:choose>
                                                                    <c:when test="${empty dish.notes or dish.notes == ''}">
                                                                        -
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${dish.notes}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                                <tfoot class="table-light">
                                                    <tr>
                                                        <th colspan="2">Tổng cộng</th>
                                                        <th class="text-end">
                                                            <fmt:formatNumber value="${booking.totalPrice}" 
                                                                type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                        </th>
                                                        <th></th>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-dark" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>