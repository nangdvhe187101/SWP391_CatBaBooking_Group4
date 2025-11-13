<%-- 
    Document   : RestaurantBookings (Hardcoded, Pretty Details, Low-JS)
    Updated    : Oct 22, 2025
    Notes      : Bootstrap 5 + Sidebar.jsp. No create. Each row has its own static "Chi tiết" modal (no JS needed).
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
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
                background:#f8f9fa;
            }
            .main-content {
                display:flex;
            }
            .content {
                flex:1;
                padding:1rem;
                max-width:1200px;
                margin:0 auto;
            }
            .chip {
                display:inline-flex;
                align-items:center;
                gap:.25rem;
                padding:.125rem .5rem;
                border-radius:999px;
                background:#f1f3f5;
                font-size:.825rem
            }
            .table-sticky thead th {
                position: sticky;
                top: 0;
                z-index: 1;
                background: #f8f9fa;
            }
            #sidebar-overlay.hidden {
                display:none;
            }
            #sidebar-overlay {
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.35);
                z-index:1020;
            }
            .text-mono {
                font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
            }
            /* Pretty details modal */
            .modal-title .badge {
                vertical-align: middle;
            }
            .kv {
                display:grid;
                grid-template-columns: 160px 1fr;
                gap:.25rem 1rem;
            }
            .kv .k {
                color:#6c757d;
                font-size:.9rem;
            }
            .kv .v {
                font-weight:500;
            }
            .section-title {
                font-weight:600;
                font-size:.95rem;
                color:#6c757d;
                text-transform:uppercase;
                letter-spacing:.03em;
            }
            .soft-card {
                border:1px solid #e9ecef;
                border-radius:.75rem;
                background:#fff;
            }
            .dl-2col {
                display:grid;
                grid-template-columns: 1fr 1fr;
                gap: .5rem 1rem;
            }
            @media (max-width: 768px){
                .kv{
                    grid-template-columns:120px 1fr
                }
                .dl-2col{
                    grid-template-columns:1fr
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

                <!-- Filters -->
                <form class="row g-3 bg-white p-3 rounded-3 border mb-3">
                    <div class="col-md-3">
                        <label class="form-label">Ngày</label>
                        <input type="date" class="form-control" value="2025-10-22"/>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Giờ</label>
                        <input type="time" class="form-control" value="19:00"/>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Số khách</label>
                        <input type="number" class="form-control" min="1" value="2"/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select">
                            <option value="">Tất cả</option>
                            <option value="pending">Chờ xác nhận</option>
                            <option value="confirmed" selected>Đã xác nhận</option>
                            <option value="cancelled_by_user">Hủy bởi KH</option>
                            <option value="cancelled_by_owner">Hủy bởi nhà hàng</option>
                            <option value="completed">Hoàn tất</option>
                            <option value="no_show">Không đến</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="button" class="btn btn-dark w-100">Lọc</button>
                    </div>
                </form>

                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">Danh sách booking</span>
                        <div class="d-flex gap-2">
                            <input type="search" class="form-control form-control-sm" placeholder="Tìm tên/điện thoại..." />
                        </div>
                    </div>
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
                                    <th>Thanh toán</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="text-mono small">BK-24001</td>
                                    <td><div class="fw-semibold">Nguyễn Văn A</div><div class="small text-muted">a.nguyen@example.com</div></td>
                                    <td class="small"><span class="chip">0901 234 567</span></td>
                                    <td><span class="badge text-bg-light border">B07 · 4 chỗ</span></td>
                                    <td class="small"><div class="fw-semibold">2025-10-22</div><div class="text-muted">19:00-20:30</div></td>
                                    <td>4</td>
                                    <td class="fw-semibold">1.250.000₫</td>
                                    <td class="small"><div>500.000₫</div><div class="text-muted">partially_paid</div></td>
                                    <td><span class="badge text-bg-success">Đã xác nhận</span></td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#detail-BK-24001">Chi tiết</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="text-mono small">BK-24002</td>
                                    <td><div class="fw-semibold">Trần Thị B</div><div class="small text-muted">b.tran@example.com</div></td>
                                    <td class="small"><span class="chip">0987 654 321</span></td>
                                    <td><span class="badge text-bg-light border">VIP-1 · 8 chỗ</span></td>
                                    <td class="small"><div class="fw-semibold">2025-10-23</div><div class="text-muted">12:30-14:00</div></td>
                                    <td>6</td>
                                    <td class="fw-semibold">2.650.000₫</td>
                                    <td class="small"><div>0₫</div><div class="text-muted">unpaid</div></td>
                                    <td><span class="badge text-bg-warning">Chờ xác nhận</span></td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#detail-BK-24002">Chi tiết</button>
                                    </td>
                                </tr>
                                <!-- BK-24003 -->
                                <tr>
                                    <td class="text-mono small">BK-24003</td>
                                    <td><div class="fw-semibold">Lê Minh C</div><div class="small text-muted">c.le@example.com</div></td>
                                    <td class="small"><span class="chip">0912 888 999</span></td>
                                    <td><span class="badge text-bg-light border">O12 · 4 chỗ</span></td>
                                    <td class="small"><div class="fw-semibold">2025-10-24</div><div class="text-muted">18:15-19:30</div></td>
                                    <td>2</td>
                                    <td class="fw-semibold">0₫</td>
                                    <td class="small"><div>0₫</div><div class="text-muted">unpaid</div></td>
                                    <td><span class="badge text-bg-danger">Đã hủy</span></td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#detail-BK-24003">Chi tiết</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <div class="small text-muted">Tổng: 3 | Trang 1/1</div>
                        <div class="btn-group btn-group-sm">
                            <a class="btn btn-outline-secondary disabled" href="#">Trước</a>
                            <a class="btn btn-outline-secondary disabled" href="#">Sau</a>
                        </div>
                    </div>
                </div>

            </main>
        </div>

        <!-- Detail Modal: BK-24001 -->
        <div class="modal fade" id="detail-BK-24001" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header border-0 pb-0">
                        <div class="w-100">
                            <div class="d-flex justify-content-between align-items-start">
                                <h5 class="modal-title">
                                    Đơn <span class="text-mono">BK-24001</span>
                                    <span class="badge text-bg-success ms-2">Đã xác nhận</span>
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="text-muted small mt-1">Tạo ngày 22/10/2025 • Cập nhật 22/10/2025 18:30</div>
                        </div>
                    </div>
                    <div class="modal-body pt-3">
                        <div class="row g-3">
                            <!-- Left column: Overview -->
                            <div class="col-lg-5">
                                <div class="soft-card p-3">
                                    <div class="section-title mb-2">Tổng quan</div>
                                    <div class="kv">
                                        <div class="k">Trạng thái</div><div class="v">Đã xác nhận</div>
                                        <div class="k">Số khách</div><div class="v">4</div>
                                        <div class="k">Bàn</div><div class="v"><span class="badge text-bg-light border">B07 · 4 chỗ</span></div>
                                        <div class="k">Ngày Giờ</div><div class="v">2025-10-22 19:00-20:30</div>
                                    </div>
                                </div>

                                <div class="soft-card p-3 mt-3">
                                    <div class="section-title mb-2">Thanh toán</div>
                                    <div class="dl-2col">
                                        <div class="text-muted small">Tổng tiền</div><div class="fw-semibold">1.250.000₫</div>
                                        <div class="text-muted small">Đã thanh toán</div><div class="">500.000₫</div>
                                        <div class="text-muted small">Trạng thái</div><div class="text-muted">partially_paid</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right column: Customer + Dishes -->
                            <div class="col-lg-7">
                                <div class="soft-card p-3">
                                    <div class="section-title mb-2">Khách đặt</div>
                                    <div class="kv">
                                        <div class="k">Họ tên</div><div class="v">Nguyễn Văn A</div>
                                        <div class="k">Email</div><div class="v">a.nguyen@example.com</div>
                                        <div class="k">Điện thoại</div><div class="v"><span class="chip">0901 234 567</span></div>
                                        <div class="k">Ghi chú</div><div class="v">Sinh nhật - bàn gần cửa sổ</div>
                                    </div>
                                </div>

                                <div class="soft-card p-3 mt-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="section-title mb-0">Món đặt trước</div>
                                        <div class="small text-muted">Giá tại thời điểm đặt</div>
                                    </div>
                                    <div class="table-responsive mt-2">
                                        <table class="table table-sm mb-0">
                                            <thead><tr class="small"><th>Món</th><th>SL</th><th>Đơn giá</th><th>Ghi chú</th></tr></thead>
                                            <tbody>
                                                <tr><td>Phở Bò</td><td>2</td><td>75.000₫</td><td>Ít hành</td></tr>
                                                <tr><td>Cà phê sữa đá</td><td>2</td><td>28.000₫</td><td></td></tr>
                                            </tbody>
                                        </table>
                                    </div>
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

        <!-- Detail Modal: BK-24002 -->
        <div class="modal fade" id="detail-BK-24002" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header border-0 pb-0">
                        <div class="w-100 d-flex justify-content-between align-items-start">
                            <h5 class="modal-title">
                                Đơn <span class="text-mono">BK-24002</span>
                                <span class="badge text-bg-warning ms-2">Chờ xác nhận</span>
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="text-muted small mt-1">Tạo ngày 23/10/2025 • Cập nhật 23/10/2025 10:05</div>
                    </div>
                    <div class="modal-body pt-3">
                        <div class="row g-3">
                            <div class="col-lg-5">
                                <div class="soft-card p-3">
                                    <div class="section-title mb-2">Tổng quan</div>
                                    <div class="kv">
                                        <div class="k">Trạng thái</div><div class="v">Chờ xác nhận</div>
                                        <div class="k">Số khách</div><div class="v">6</div>
                                        <div class="k">Bàn</div><div class="v"><span class="badge text-bg-light border">VIP-1 · 8 chỗ</span></div>
                                        <div class="k">Ngày Giờ</div><div class="v">2025-10-23 12:30-14:00</div>
                                    </div>
                                </div>

                                <div class="soft-card p-3 mt-3">
                                    <div class="section-title mb-2">Thanh toán</div>
                                    <div class="dl-2col">
                                        <div class="text-muted small">Tổng tiền</div><div class="fw-semibold">2.650.000₫</div>
                                        <div class="text-muted small">Đã thanh toán</div><div class="">0₫</div>
                                        <div class="text-muted small">Trạng thái</div><div class="text-muted">unpaid</div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-7">
                                <div class="soft-card p-3">
                                    <div class="section-title mb-2">Khách đặt</div>
                                    <div class="kv">
                                        <div class="k">Họ tên</div><div class="v">Trần Thị B</div>
                                        <div class="k">Email</div><div class="v">b.tran@example.com</div>
                                        <div class="k">Điện thoại</div><div class="v"><span class="chip">0987 654 321</span></div>
                                        <div class="k">Ghi chú</div><div class="v">Yêu cầu set menu</div>
                                    </div>
                                </div>

                                <div class="soft-card p-3 mt-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="section-title mb-0">Món đặt trước</div>
                                        <div class="small text-muted">Giá tại thời điểm đặt</div>
                                    </div>
                                    <div class="table-responsive mt-2">
                                        <table class="table table-sm mb-0">
                                            <thead><tr class="small"><th>Món</th><th>SL</th><th>Đơn giá</th><th>Ghi chú</th></tr></thead>
                                            <tbody>
                                                <tr><td>Bún chả</td><td>4</td><td>65.000₫</td><td>Thêm rau sống</td></tr>
                                                <tr><td>Gỏi cuốn</td><td>6</td><td>35.000₫</td><td>Nước chấm riêng</td></tr>
                                            </tbody>
                                        </table>
                                    </div>
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

        <!-- Detail Modal: BK-24003 -->
        <div class="modal fade" id="detail-BK-24003" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header border-0 pb-0">
                        <div class="w-100 d-flex justify-content-between align-items-start">
                            <h5 class="modal-title">
                                Đơn <span class="text-mono">BK-24003</span>
                                <span class="badge text-bg-danger ms-2">Đã hủy</span>
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="text-muted small mt-1">Tạo ngày 24/10/2025 • Cập nhật 24/10/2025 17:45</div>
                    </div>
                    <div class="modal-body pt-3">
                        <div class="row g-3">
                            <div class="col-lg-5">
                                <div class="soft-card p-3">
                                    <div class="section-title mb-2">Tổng quan</div>
                                    <div class="kv">
                                        <div class="k">Trạng thái</div><div class="v">Đã hủy</div>
                                        <div class="k">Số khách</div><div class="v">2</div>
                                        <div class="k">Bàn</div><div class="v"><span class="badge text-bg-light border">O12 · 4 chỗ</span></div>
                                        <div class="k">Ngày Giờ</div><div class="v">2025-10-24 18:15-19:30</div>
                                    </div>
                                </div>

                                <div class="soft-card p-3 mt-3">
                                    <div class="section-title mb-2">Thanh toán</div>
                                    <div class="dl-2col">
                                        <div class="text-muted small">Tổng tiền</div><div class="fw-semibold">0₫</div>
                                        <div class="text-muted small">Đã thanh toán</div><div class="">0₫</div>
                                        <div class="text-muted small">Trạng thái</div><div class="text-muted">unpaid</div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-7">
                                <div class="soft-card p-3">
                                    <div class="section-title mb-2">Khách đặt</div>
                                    <div class="kv">
                                        <div class="k">Họ tên</div><div class="v">Lê Minh C</div>
                                        <div class="k">Email</div><div class="v">c.le@example.com</div>
                                        <div class="k">Điện thoại</div><div class="v"><span class="chip">0912 888 999</span></div>
                                        <div class="k">Ghi chú</div><div class="v">Mưa lớn</div>
                                    </div>
                                </div>

                                <div class="soft-card p-3 mt-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="section-title mb-0">Món đặt trước</div>
                                        <div class="small text-muted">Giá tại thời điểm đặt</div>
                                    </div>
                                    <div class="table-responsive mt-2">
                                        <table class="table table-sm mb-0">
                                            <thead><tr class="small"><th>Món</th><th>SL</th><th>Đơn giá</th><th>Ghi chú</th></tr></thead>
                                            <tbody>
                                                <tr><td>(trống)</td><td>-</td><td>-</td><td>-</td></tr>
                                            </tbody>
                                        </table>
                                    </div>
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>