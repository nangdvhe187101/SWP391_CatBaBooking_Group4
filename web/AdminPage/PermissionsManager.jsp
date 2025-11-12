<%-- 
    Document   : PermissionsManager
    Created on : Nov 12, 2025, 5:34:35 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin - Quản Lý Phân Quyền</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/AdminPage/admin-style.css">
        <style>
            /* --- Main Content --- */
            .main-content {
                margin-left: 250px;
                flex-grow: 1;
                padding: 20px;
            }
            main {
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                margin-top: 20px;
            }
            h2 {
                color: #001529;
                margin-bottom: 20px;
                font-size: 24px;
                border-bottom: 2px solid #1890ff;
                padding-bottom: 10px;
            }
            /* --- Search & Actions Bar --- */
            .action-bar {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
                align-items: center;
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
            }
            .search-box {
                flex: 1;
                position: relative;
                display: flex;
                align-items: center;
            }
            .search-box input {
                flex: 1;
                padding: 10px 40px 10px 15px;
                border: 2px solid #e9ecef;
                border-radius: 6px 0 0 6px;
                font-size: 14px;
                transition: border-color 0.3s;
            }
            .search-box input:focus {
                outline: none;
                border-color: #1890ff;
                box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
            }
            .btn-search {
                padding: 10px 15px;
                background-color: #1890ff;
                color: white;
                border: none;
                border-radius: 0 6px 6px 0;
                cursor: pointer;
                font-size: 14px;
                transition: background-color 0.3s;
            }
            .btn-search:hover {
                background-color: #096dd9;
            }
            .btn-add {
                padding: 10px 20px;
                background-color: #1890ff;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: background-color 0.3s;
                white-space: nowrap;
            }
            .btn-add:hover {
                background-color: #096dd9;
            }
            .btn-save {
                padding: 10px 20px;
                background-color: #52c41a;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: background-color 0.3s;
                white-space: nowrap;
            }
            .btn-save:hover {
                background-color: #389e0d;
            }
            /* --- Table Styles --- */
            .role-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            .role-table thead {
                background-color: #fafafa;
            }
            .role-table th {
                padding: 12px;
                text-align: center;
                border: 1px solid #e5e7eb;
                font-weight: 600;
                color: #333;
                font-size: 14px;
            }
            .role-table td {
                padding: 12px;
                text-align: center;
                border: 1px solid #e5e7eb;
                font-size: 14px;
            }
            .role-table tbody tr:hover {
                background-color: #f5f5f5;
            }
            /* STT column */
            .role-table th:first-child,
            .role-table td:first-child {
                width: 60px;
            }
            /* Tên Chức Năng column */
            .role-table th:nth-child(2),
            .role-table td:nth-child(2) {
                text-align: left;
                width: 200px;
            }
            /* Đường dẫn URL column */
            .role-table th:nth-child(3),
            .role-table td:nth-child(3) {
                text-align: left;
                width: 250px;
                font-family: 'Courier New', monospace;
                font-size: 13px;
                color: #666;
            }
            /* Role columns */
            .role-table th:nth-child(4),
            .role-table th:nth-child(5),
            .role-table th:nth-child(6),
            .role-table th:nth-child(7) {
                width: 120px;
            }
            /* Thao tác column */
            .role-table th:last-child,
            .role-table td:last-child {
                width: 150px;
            }
            /* --- Checkbox Styling --- */
            .permission-checkbox {
                width: 18px;
                height: 18px;
                cursor: pointer;
                accent-color: #1890ff;
            }
            /* --- Action Buttons --- */
            .action-buttons {
                display: flex;
                gap: 8px;
                justify-content: center;
            }
            .btn-edit {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 13px;
                transition: all 0.3s;
                background-color: #1890ff;
                color: white;
            }
            .btn-edit:hover {
                background-color: #096dd9;
            }
            .btn-delete {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 13px;
                transition: all 0.3s;
                background-color: #ff4d4f;
                color: white;
            }
            .btn-delete:hover {
                background-color: #d9363e;
            }
            /* --- Empty State --- */
            .empty-state {
                text-align: center;
                padding: 40px;
                color: #999;
            }
            /* --- Success/Error Messages --- */
            .message {
                padding: 12px 20px;
                border-radius: 6px;
                margin-bottom: 20px;
                font-size: 14px;
            }
            .success-msg {
                background-color: #f6ffed;
                border: 1px solid #b7eb8f;
                color: #52c41a;
            }
            .error-msg {
                background-color: #fff2f0;
                border: 1px solid #ffccc7;
                color: #ff4d4f;
            }
            /* --- Modal Styles --- */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
            }
            .modal-content {
                background-color: #fff;
                margin: 15% auto;
                padding: 0;
                border-radius: 8px;
                width: 80%;
                max-width: 500px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .modal-header {
                padding: 15px;
                border-bottom: 1px solid #eee;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .modal-header h3 {
                margin: 0;
                color: #001529;
            }
            .close {
                color: #aaa;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
            }
            .close:hover {
                color: #000;
            }
            .modal-body {
                padding: 20px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
                color: #333;
            }
            .form-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }
            .form-group input:focus {
                outline: none;
                border-color: #1890ff;
                box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
            }
            .modal-footer {
                padding: 15px;
                border-top: 1px solid #eee;
                text-align: right;
            }
            .modal-footer button {
                padding: 8px 16px;
                margin-left: 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                transition: background-color 0.3s;
            }
            #cancelBtn {
                background-color: #f0f0f0;
                color: #333;
            }
            #cancelBtn:hover {
                background-color: #e0e0e0;
            }
            #saveBtn {
                background-color: #1890ff;
                color: white;
            }
            #saveBtn:hover {
                background-color: #096dd9;
            }
            /* --- Delete Form Styling --- */
            .delete-form {
                display: inline;
            }
            /* --- Permissions Form --- */
            .permissions-form {
                display: inline;
            }
            /* --- Responsive --- */
            @media (max-width: 1200px) {
                .role-table {
                    font-size: 12px;
                }
                .role-table th,
                .role-table td {
                    padding: 8px;
                }
            }
            @media (max-width: 768px) {
                .action-bar {
                    flex-direction: column;
                }
                .search-box {
                    width: 100%;
                }
                .search-box input {
                    border-radius: 6px;
                }
                .btn-search {
                    border-radius: 0;
                    margin-top: 10px;
                }
                .modal-content {
                    width: 95%;
                    margin: 10% auto;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="Sidebar.jsp" %>
        <div class="main-content">
            <main>
                <h2>Quản Lý Phân Quyền</h2>
                <!-- Success/Error Messages -->
                <c:if test="${param.success == 'saved'}">
                    <div class="message success-msg">Đã lưu thay đổi thành công!</div>
                </c:if>
                <c:if test="${param.error == 'failed'}">
                    <div class="message error-msg">Có lỗi xảy ra khi lưu!</div>
                </c:if>
                <!-- Action Bar -->
                <div class="action-bar">
                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên chức năng hoặc URL...">
                        <button type="button" class="btn-search">🔍</button>
                    </div>
                    <button type="button" class="btn-add" onclick="showAddModal()">➕ Thêm URL</button>
                    <form class="permissions-form" method="post" action="/savePermissions">
                        <button type="submit" class="btn-save">💾 Lưu Thay Đổi</button>
                    </form>
                </div>
                <!-- Permissions Table with Form -->
                <form class="permissions-form" method="post" action="/savePermissions">
                    <table class="role-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên Chức Năng</th>
                                <th>Đường dẫn URL</th>
                                <th>Customer</th>
                                <th>Owner Homestay</th>
                                <th>Owner Restaurant</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="permissionsTableBody">
                            <!-- Hard-coded Sample Data -->
                            <tr data-id="1">
                                <td>1</td>
                                <td>Trang chủ</td>
                                <td>/home</td>
                                <td><input type="checkbox" name="permissions[1][customer]" class="permission-checkbox" checked value="true"></td>
                                <td><input type="checkbox" name="permissions[1][ownerHomestay]" class="permission-checkbox" checked value="true"></td>
                                <td><input type="checkbox" name="permissions[1][ownerRestaurant]" class="permission-checkbox" checked value="true"></td>
                                <td>
                                    <div class="action-buttons">
                                        <button type="button" class="btn-edit" onclick="editPermission(1)">Sửa</button>
                                        <form class="delete-form" method="post" action="/deletePermission" style="display: inline;">
                                            <input type="hidden" name="id" value="1">
                                            <button type="submit" class="btn-delete">Xóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <tr data-id="2">
                                <td>2</td>
                                <td>Quản lý đặt phòng</td>
                                <td>/booking-management</td>
                                <td><input type="checkbox" name="permissions[2][customer]" class="permission-checkbox" value="true"></td>
                                <td><input type="checkbox" name="permissions[2][ownerHomestay]" class="permission-checkbox" checked value="true"></td>
                                <td><input type="checkbox" name="permissions[2][ownerRestaurant]" class="permission-checkbox" value="true"></td>
                                <td>
                                    <div class="action-buttons">
                                        <button type="button" class="btn-edit" onclick="editPermission(2)">Sửa</button>
                                        <form class="delete-form" method="post" action="/deletePermission" style="display: inline;">
                                            <input type="hidden" name="id" value="2">
                                            <button type="submit" class="btn-delete">Xóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <tr data-id="3">
                                <td>3</td>
                                <td>Quản lý nhà hàng</td>
                                <td>/restaurant-management</td>
                                <td><input type="checkbox" name="permissions[3][customer]" class="permission-checkbox" value="true"></td>
                                <td><input type="checkbox" name="permissions[3][ownerHomestay]" class="permission-checkbox" value="true"></td>
                                <td><input type="checkbox" name="permissions[3][ownerRestaurant]" class="permission-checkbox" checked value="true"></td>
                                <td>
                                    <div class="action-buttons">
                                        <button type="button" class="btn-edit" onclick="editPermission(3)">Sửa</button>
                                        <form class="delete-form" method="post" action="/deletePermission" style="display: inline;">
                                            <input type="hidden" name="id" value="3">
                                            <button type="submit" class="btn-delete">Xóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <tr data-id="4">
                                <td>4</td>
                                <td>Xem hồ sơ cá nhân</td>
                                <td>/profile</td>
                                <td><input type="checkbox" name="permissions[4][customer]" class="permission-checkbox" checked value="true"></td>
                                <td><input type="checkbox" name="permissions[4][ownerHomestay]" class="permission-checkbox" checked value="true"></td>
                                <td><input type="checkbox" name="permissions[4][ownerRestaurant]" class="permission-checkbox" checked value="true"></td>
                                <td>
                                    <div class="action-buttons">
                                        <button type="button" class="btn-edit" onclick="editPermission(4)">Sửa</button>
                                        <form class="delete-form" method="post" action="/deletePermission" style="display: inline;">
                                            <input type="hidden" name="id" value="4">
                                            <button type="submit" class="btn-delete">Xóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <tr data-id="5">
                                <td>5</td>
                                <td>Đặt phòng</td>
                                <td>/booking</td>
                                <td><input type="checkbox" name="permissions[5][customer]" class="permission-checkbox" checked value="true"></td>
                                <td><input type="checkbox" name="permissions[5][ownerHomestay]" class="permission-checkbox" value="true"></td>
                                <td><input type="checkbox" name="permissions[5][ownerRestaurant]" class="permission-checkbox" value="true"></td>
                                <td>
                                    <div class="action-buttons">
                                        <button type="button" class="btn-edit" onclick="editPermission(5)">Sửa</button>
                                        <form class="delete-form" method="post" action="/deletePermission" style="display: inline;">
                                            <input type="hidden" name="id" value="5">
                                            <button type="submit" class="btn-delete">Xóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <tr data-id="6">
                                <td>6</td>
                                <td>Thanh toán</td>
                                <td>/payment</td>
                                <td><input type="checkbox" name="permissions[6][customer]" class="permission-checkbox" checked value="true"></td>
                                <td><input type="checkbox" name="permissions[6][ownerHomestay]" class="permission-checkbox" checked value="true"></td>
                                <td><input type="checkbox" name="permissions[6][ownerRestaurant]" class="permission-checkbox" checked value="true"></td>
                                <td>
                                    <div class="action-buttons">
                                        <button type="button" class="btn-edit" onclick="editPermission(6)">Sửa</button>
                                        <form class="delete-form" method="post" action="/deletePermission" style="display: inline;">
                                            <input type="hidden" name="id" value="6">
                                            <button type="submit" class="btn-delete">Xóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </main>
        </div>

        <!-- Modal -->
        <div id="permissionModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modalTitle">Thêm URL Mới</h3>
                    <span class="close">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="permissionForm" method="post" action="/savePermission">
                        <input type="hidden" id="mode" name="mode" value="add">
                        <input type="hidden" id="editId" name="id" value="">
                        <div class="form-group">
                            <label for="name">Tên Chức Năng:</label>
                            <input type="text" id="name" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="url">Đường dẫn URL:</label>
                            <input type="text" id="url" name="url" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" id="cancelBtn">Hủy</button>
                    <button type="submit" form="permissionForm" id="saveBtn">Lưu</button>
                </div>
            </div>
        </div>

        <script>
            // Modal-related variables and functions only
            const modal = document.getElementById('permissionModal');
            const closeBtn = document.querySelector('.close');
            const cancelBtn = document.getElementById('cancelBtn');
            const title = document.getElementById('modalTitle');
            const modeInput = document.getElementById('mode');
            const editIdInput = document.getElementById('editId');
            const nameInput = document.getElementById('name');
            const urlInput = document.getElementById('url');

            // Open modal for add
            function showAddModal() {
                modeInput.value = 'add';
                editIdInput.value = '';
                nameInput.value = '';
                urlInput.value = '';
                title.textContent = 'Thêm URL Mới';
                modal.style.display = 'block';
            }

            // Open modal for edit
            function editPermission(id) {
                const row = document.querySelector(`tr[data-id="${id}"]`);
                const name = row.cells[1].textContent;
                const url = row.cells[2].textContent;
                modeInput.value = 'edit';
                editIdInput.value = id;
                nameInput.value = name;
                urlInput.value = url;
                title.textContent = 'Sửa URL';
                modal.style.display = 'block';
            }

            // Close modal
            function closeModal() {
                modal.style.display = 'none';
            }

            // Event listeners for modal
            closeBtn.onclick = closeModal;
            cancelBtn.onclick = closeModal;
            window.onclick = function(event) {
                if (event.target === modal) {
                    closeModal();
                }
            };
        </script>
    </body>
</html>