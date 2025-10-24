<%-- 
    Document   : RestaurantTableAvailability
    Created on : Oct 22, 2025, 12:10:02 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Owner - Lịch bàn</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
        <link rel="stylesheet" href="owner-styles.css" />
    </head>
    <body>

        <%@ include file="Sidebar.jsp" %>

        <div id="sidebar-overlay" class="hidden"></div>

        <header class="header">
            <button id="sidebar-toggle">☰</button>
            <h1>Xin chào, Owner!</h1>
            <div class="header-actions">
                <span class="notification">🔔</span>
                <span class="user">O Owner Name</span>
            </div>
        </header>

        <div class="main-content">
            <main class="content">

                <div class="container-fluid py-3">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h2 class="mb-0">Lịch bàn</h2>
                            <small class="text-muted">Đặt lịch/ chặn giờ (table_availability)</small>
                        </div>
                    </div>

                    <div class="border rounded p-3 mb-3">
                        <form method="post" action="RestaurantTableAvailability.jsp?action=add" class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Ngày</label>
                                <input name="date" type="date" class="form-control" value="" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Bắt đầu</label>
                                <input name="start_time" type="time" class="form-control" value="18:00" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Kết thúc</label>
                                <input name="end_time" type="time" class="form-control" value="20:00" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Bàn</label>
                                <select name="table_id" class="form-select" required>
                                    <option value="1">Bàn 1 (4)</option>
                                    <option value="2">Bàn 2 (4)</option>
                                    <option value="3">Bàn 5 (8)</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-select">
                                    <option value="available">available</option>
                                    <option value="booked">booked</option>
                                    <option value="blocked">blocked</option>
                                </select>
                            </div>
                            <div class="col-md-9 d-flex align-items-end justify-content-end gap-2">
                                <a href="RestaurantTableAvailability.jsp" class="btn btn-outline-secondary">Làm mới</a>
                                <button class="btn btn-primary" type="submit">Thêm lịch</button>
                            </div>
                        </form>
                    </div>

                    <div class="card">
                        <div class="card-header">Các slot</div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Ngày</th>
                                        <th>Khung giờ</th>
                                        <th>Bàn</th>
                                        <th>Trạng thái</th>
                                        <th class="text-end">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- HARD-CODED SAMPLE DATA START (Table Availability) -->
                                    <tr>
                                        <td>2025-10-22</td>
                                        <td>11:30 - 12:30</td>
                                        <td>Bàn 6</td>
                                        <td>Trống</td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2025-10-22</td>
                                        <td>19:00 - 20:30</td>
                                        <td>Bàn 4</td>
                                        <td>Đang dùng</td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        
                                        <td>2025-10-23</td>
                                        <td>12:00 - 14:00</td>
                                        <td>Bàn 5</td>
                                        <td>Đặt trước</td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        
                                        <td>2025-10-24</td>
                                        <td>18:00 - 19:30</td>
                                        <td>Bàn 2</td>
                                        <td>Trống</td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <!-- HARD-CODED SAMPLE DATA END -->

                                    <tr>
                                        <td>2024-10-28</td>
                                        <td>18:00 - 20:00</td>
                                        <td>Bàn 1</td>
                                        <td>booked</td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2024-10-28</td>
                                        <td>18:00 - 20:00</td>
                                        <td>Bàn 2</td>
                                        <td>available</td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2024-10-28</td>
                                        <td>20:00 - 22:00</td>
                                        <td>Bàn 1</td>
                                        <td>blocked</td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
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
            });
        </script>
    </body>
</html>
