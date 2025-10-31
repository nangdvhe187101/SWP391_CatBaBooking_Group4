<%-- 
    Document   : RestaurantManageDishes.jsp
    Created on : Oct 22, 2025, 11:04:08 AM
    Author     : ADMIN
    MODIFIED   : Tối giản - Bỏ hoàn toàn xem trước ảnh, chỉ giữ upload.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Owner - Quản lý Món ăn</title>     

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />

        <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css" />

        <style>
            .dish-thumbnail {
                width: 50px;
                height: 50px;
                object-fit: cover;
                border-radius: 8px;
                margin-right: 10px;
                vertical-align: middle;
            }
        </style>
    </head>
    <body>

        <%@ include file="Sidebar.jsp" %>
        <div class="main-content">
            <h2 class="mb-3">Quản lý Món ăn</h2>

            <div class="card shadow-sm mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Thêm món ăn mới</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="manage-dish-servlet?action=add" enctype="multipart/form-data">
                        <div class="row g-3">

                            <div class="col-md-6">
                                <label class="form-label">Tên món</label>
                                <input name="name" class="form-control" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Giá (đ)</label>
                                <input name="price" type="number" min="0" step="1000" class="form-control" required />
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Danh mục</label>
                                <select name="category_id" class="form-select" required>
                                    <option value="1">Khai vị</option>
                                    <option value="2">Món chính</option>
                                    <option value="3">Tráng miệng</option>
                                    <option value="4">Đồ uống</option>
                                </select>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Mô tả</label>
                                <textarea name="description" class="form-control" rows="2"></textarea>
                            </div>

                            <div class="col-md-9">
                                <label class="form-label">Ảnh minh họa</label>
                                <input name="dish_image_file" type="file" class="form-control" accept="image/*" />
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="is_active" class="form-select">
                                    <option value="true">Đang bán</option>
                                    <option value="false">Ngừng bán</option>
                                </select>
                            </div>

                            <div class="col-md-12 d-flex justify-content-end gap-2">
                                <button class="btn btn-primary" type="submit">Lưu món</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách món ăn</h5>
                </div>
                <div class="card-body">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Món ăn</th>
                                <th scope="col">Giá</th>
                                <th scope="col">Danh mục</th>
                                <th scope="col">Trạng thái</th>
                                <th scope="col" class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>

                            <tr>
                                <td>101</td>
                                <td>
                                    <img src="https://i.imgur.com/LNUj1m6.jpeg" alt="Phở Bò" class="dish-thumbnail">
                                    <strong>Phở Bò Hà Nội</strong>
                                </td>
                                <td><fmt:formatNumber value="50000" type="currency" currencySymbol="₫" /></td>
                                <td>Món chính</td>
                                <td><span class="badge bg-success">Đang bán</span></td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-warning btn-sm me-1 edit-btn"
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editDishModal"
                                            data-id="101"
                                            data-name="Phở Bò Hà Nội"
                                            data-price="50000"
                                            data-category-id="2" 
                                            data-description="Phở bò tái chín đặc biệt, nước dùng thanh ngọt."
                                            data-image-url="https://i.imgur.com/LNUj1m6.jpeg"
                                            data-active="true">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </button>
                                </td>
                            </tr>

                            <tr>
                                <td>102</td>
                                <td>
                                    <img src="https://i.imgur.com/sYnQYQW.jpeg" alt="Nem Rán" class="dish-thumbnail">
                                    <strong>Nem Rán Truyền Thống</strong>
                                </td>
                                <td><fmt:formatNumber value="35000" type="currency" currencySymbol="₫" /></td>
                                <td>Khai vị</td>
                                <td><span class="badge bg-secondary">Ngừng bán</span></td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-warning btn-sm me-1 edit-btn"
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editDishModal"
                                            data-id="102"
                                            data-name="Nem Rán Truyền Thống"
                                            data-price="35000"
                                            data-category-id="1" 
                                            data-description="Nem rán giòn rụm, nhân đầy đặn, chấm nước mắm chua ngọt."
                                            data-image-url="https://i.imgur.com/sYnQYQW.jpeg"
                                            data-active="false">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </button>
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
        <div class="modal fade" id="editDishModal" tabindex="-1" aria-labelledby="editDishModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">

                    <form method="post" action="manage-dish-servlet?action=update" enctype="multipart/form-data">

                        <div class="modal-header">
                            <h5 class="modal-title" id="editDishModalLabel">Chỉnh sửa món ăn</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">

                            <input type="hidden" name="dish_id" id="editDishId">

                            <input type="hidden" name="existing_image_url" id="editExistingImageUrl">

                            <div class="row g-3">
                                <div class="col-md-8">
                                    <label for="editName" class="form-label">Tên món</label>
                                    <input type="text" class="form-control" id="editName" name="name" required>
                                </div>
                                <div class="col-md-4">
                                    <label for="editPrice" class="form-label">Giá (đ)</label>
                                    <input type="number" class="form-control" id="editPrice" name="price" min="0" step="1000" required>
                                </div>

                                <div class="col-12">
                                    <label for="editDescription" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="editDescription" name="description" rows="2"></textarea>
                                </div>

                                <div class="col-12">
                                    <label for="editDishImageFile" class="form-label">Tải lên ảnh mới (Bỏ trống nếu không muốn đổi)</label>
                                    <input type="file" class="form-control" id="editDishImageFile" name="dish_image_file" accept="image/*">
                                </div>

                                <div class="col-md-6">
                                    <label for="editCategoryId" class="form-label">Danh mục</label>
                                    <select id="editCategoryId" name="category_id" class="form-select" required>
                                        <option value="1">Khai vị</option>
                                        <option value="2">Món chính</option>
                                        <option value="3">Tráng miệng</option>
                                        <option value="4">Đồ uống</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label for="editIsActive" class="form-label">Trạng thái</label>
                                    <select id="editIsActive" name="is_active" class="form-select" required>
                                        <option value="true">Đang bán</option>
                                        <option value="false">Ngừng bán</option>
                                    </select>
                                </div>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>               
            </div>           
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {

                // === PHẦN 1: LOGIC CHO SIDEBAR (Từ file gốc của bạn) ===
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

                // === PHẦN 2: LOGIC ĐIỀN DỮ LIỆU VÀO MODAL SỬA (Tối giản) ===
                const editButtons = document.querySelectorAll('.edit-btn');

                editButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        // 1. Lấy dữ liệu từ các thuộc tính data-* của nút
                        const id = this.getAttribute('data-id');
                        const name = this.getAttribute('data-name');
                        const price = this.getAttribute('data-price');
                        const categoryId = this.getAttribute('data-category-id');
                        const description = this.getAttribute('data-description');
                        const imageUrl = this.getAttribute('data-image-url');
                        const active = this.getAttribute('data-active');

                        // 2. Điền dữ liệu vào các trường trong modal
                        document.getElementById('editDishId').value = id;
                        document.getElementById('editName').value = name;
                        document.getElementById('editPrice').value = price;
                        document.getElementById('editCategoryId').value = categoryId;
                        document.getElementById('editDescription').value = description;
                        document.getElementById('editIsActive').value = active;

                        // 3. Xử lý phần ảnh (chỉ lưu link cũ và reset ô file)
                        document.getElementById('editExistingImageUrl').value = imageUrl;
                        document.getElementById('editDishImageFile').value = ""; // Reset ô chọn file
                    });
                });

            });
        </script>

    </body>
</html>