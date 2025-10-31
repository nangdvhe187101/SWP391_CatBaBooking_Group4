<%-- 
    Document   : RestaurantManageDishes
    Created on : Oct 22, 2025, 11:04:08 AM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Owner - Món ăn</title>     
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
        <link rel="stylesheet" href="owner-styles.css">
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
                            <h2 class="mb-0">Món ăn</h2>
                            <small class="text-muted">Quản lý thực đơn (dishes / categories)</small>
                        </div>
                    </div>

                    <div class="border rounded p-3 mb-3">
                        <h6 class="mb-3"><i class="bi bi-plus-lg me-2"></i>Thêm/Sửa món</h6>
                        <form method="post" action="RestaurantManageDishes.jsp?action=save">
                            <input type="hidden" name="dish_id" value=""/>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Tên món</label>
                                    <input name="name" value="" class="form-control" required />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Giá (đ)</label>
                                    <input name="price" type="number" min="0" step="1000" value="" class="form-control" required />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Danh mục</label>
                                    <select name="category_id" class="form-select" required>
                                        <option value="1">Khai vị</option>
                                        <option value="2">Món chính</option>
                                        <option value="3">Tráng miệng</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Mô tả</label>
                                    <textarea name="description" class="form-control" rows="2"></textarea>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Trạng thái</label>
                                    <select name="active" class="form-select">
                                        <option value="true">Đang bán</option>
                                        <option value="false">Ngừng bán</option>
                                    </select>
                                </div>
                                <div class="col-md-9 d-flex align-items-end justify-content-end gap-2">
                                    <a href="RestaurantManageDishes.jsp" class="btn btn-outline-secondary">Làm mới</a>
                                    <button class="btn btn-primary" type="submit">Lưu món</button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="card mb-3">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <span>Danh sách món</span>
                            <form method="get" action="RestaurantManageDishes.jsp" class="d-flex gap-2">
                                <input name="q" value='' class="form-control form-control-sm" placeholder="Tìm tên món..." />
                                <select name="cat" class="form-select form-select-sm" style="max-width:180px">
                                    <option value="">Tất cả danh mục</option>
                                    <option value="1">Khai vị</option>
                                    <option value="2">Món chính</option>
                                    <option value="3">Tráng miệng</option>
                                </select>
                                <select name="st" class="form-select form-select-sm" style="max-width:160px">
                                    <option value="">Tất cả</option>
                                    <option value="active">Đang bán</option>
                                    <option value="inactive">Ngừng bán</option>
                                </select>
                                <button class="btn btn-sm btn-outline-secondary">Lọc</button>
                            </form>
                        </div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Tên món</th>
                                        <th>Danh mục</th>
                                        <th>Giá (đ)</th>
                                        <th>Trạng thái</th>
                                        <th class="text-end">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>1</td>
                                        <td>Phở Bò</td>
                                        <td>Món Chính</td>
                                        <td>75,000₫</td>
                                        <td><span class="badge bg-success">Đang bán</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2</td>
                                        <td>Bún Chả</td>
                                        <td>Món Chính</td>
                                        <td>65,000₫</td>
                                        <td><span class="badge bg-success">Đang bán</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>3</td>
                                        <td>Gỏi Cuốn</td>
                                        <td>Khai Vị</td>
                                        <td>35,000₫</td>
                                        <td><span class="badge bg-secondary">Ngừng bán</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>4</td>
                                        <td>Cà Phê Sữa Đá</td>
                                        <td>Đồ Uống</td>
                                        <td>28,000₫</td>
                                        <td><span class="badge bg-success">Đang bán</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <!-- HARD-CODED SAMPLE DATA END -->

                                    <tr>
                                        <td>1</td>
                                        <td>Gỏi cuốn tôm thịt</td>
                                        <td>Khai vị</td>
                                        <td>60,000</td>
                                        <td><span class="badge bg-success">Đang bán</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2</td>
                                        <td>Phở bò tái chín</td>
                                        <td>Món chính</td>
                                        <td>50,000</td>
                                        <td><span class="badge bg-success">Đang bán</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>3</td>
                                        <td>Cá hồi áp chảo (Hết)</td>
                                        <td>Món chính</td>
                                        <td>150,000</td>
                                        <td><span class="badge bg-secondary">Ngừng bán</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="#">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="#">Xoá</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <span>Danh mục</span>
                            <form method="post" action="RestaurantManageDishes.jsp?action=addCategory" class="d-flex gap-2">
                                <input name="name" class="form-control form-control-sm" placeholder="Thêm danh mục..." required />
                                <button class="btn btn-sm btn-outline-primary" type="submit">Thêm</button>
                            </form>
                        </div>
                        <div class="card-body">
                            <span class="badge rounded-pill bg-light text-dark border me-1">Khai vị</span>
                            <span class="badge rounded-pill bg-light text-dark border me-1">Món chính</span>
                            <span class="badge rounded-pill bg-light text-dark border me-1">Tráng miệng</span>
                            <span class="badge rounded-pill bg-light text-dark border me-1">Đồ uống</span>
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
