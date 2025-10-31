<%-- 
    Document   : RestaurantManageTables
    Created on : Oct 22, 2025, 12:08:35 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Owner - Bàn</title>
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
                            <h2 class="mb-0">Bàn</h2>
                            <small class="text-muted">Quản lý sơ đồ & thông tin bàn (restaurant_tables)</small>
                        </div>
                    </div>

                    <div class="border rounded p-3 mb-3">
                        <h6 class="mb-3"><i class="bi bi-grid-3x3-gap me-2"></i>Thêm/Sửa bàn</h6>
                        <form method="post" action="RestaurantManageTables.jsp?action=save" class="row g-3">
                            <input type="hidden" name="table_id" value=""/>
                            <div class="col-md-3">
                                <label class="form-label">Số bàn</label>
                                <input name="table_number" type="number" min="1" class="form-control" value="" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Sức chứa</label>
                                <input name="capacity" type="number" min="1" class="form-control" value="" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Khu vực</label>
                                <input name="area" class="form-control" value="" placeholder="Trong nhà / Sân vườn..." />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-select">
                                    <option value="active">active</option>
                                    <option value="inactive">inactive</option>
                                </select>
                            </div>
                            <div class="col-12 d-flex justify-content-end gap-2">
                                <a href="RestaurantManageTables.jsp" class="btn btn-outline-secondary">Làm mới</a>
                                <button class="btn btn-primary" type="submit">Lưu bàn</button>
                            </div>
                        </form>
                    </div>

                    <div class="card">
                        <div class="card-header">Danh sách bàn</div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Số bàn</th>
                                        <th>Khu vực</th>
                                        <th>Sức chứa</th>
                                        <th>Trạng thái</th>
                                        <th class="text-end">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>B01</td>
                                        <td>Bàn 3</td>
                                        <td>Trong nhà</td>
                                        <td>2</td>
                                        <td><span class="badge bg-secondary">Trống</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>B07</td>
                                        <td>Bàn 4</td>
                                        <td>Trong nhà</td>
                                        <td>4</td>
                                        <td><span class="badge bg-success">có khách</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>VIP-1</td>
                                        <td>Bàn 5</td>
                                        <td>Trong nhà</td>
                                        <td>8</td>
                                        <td><span class="badge bg-secondary">Trống</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>O12</td>
                                        <td>Bàn 6</td>
                                        <td>Sân Vườn</td>
                                        <td>4</td>
                                        <td><span class="badge bg-secondary">Trống</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <!-- HARD-CODED SAMPLE DATA END -->

                                    <tr>
                                        <td>1</td>
                                        <td>Bàn 1</td>
                                        <td>Trong nhà</td>
                                        <td>4</td>
                                        <td><span class="badge bg-success">Có Khách</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2</td>
                                        <td>Bàn 2</td>
                                        <td>Trong nhà</td>
                                        <td>4</td>
                                        <td><span class="badge bg-success">Có khách</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>3</td>
                                        <td>Bàn 5</td>
                                        <td>Sân vườn</td>
                                        <td>8</td>
                                        <td><span class="badge bg-secondary">Trống</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
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