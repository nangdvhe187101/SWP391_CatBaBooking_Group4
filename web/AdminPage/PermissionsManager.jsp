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
                padding: 10px 15px;
                border: 2px solid #e9ecef;
                border-radius: 6px;
                font-size: 14px;
                transition: border-color 0.3s;
            }
            .search-box input:focus {
                outline: none;
                border-color: #1890ff;
                box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
            }
            .btn-add, .btn-save {
                padding: 10px 20px;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: background-color 0.3s;
                white-space: nowrap;
            }
            .btn-add {
                background-color: #1890ff;
            }
            .btn-add:hover {
                background-color: #096dd9;
            }
            .btn-save {
                background-color: #52c41a;
            }
            .btn-save:hover {
                background-color: #389e0d;
            }
            .role-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            .role-table thead {
                background-color: #fafafa;
            }
            .role-table th, .role-table td {
                padding: 12px;
                text-align: center;
                border: 1px solid #e5e7eb;
                font-size: 14px;
            }
            .role-table th {
                font-weight: 600;
                color: #333;
            }
            .role-table tbody tr:hover {
                background-color: #f5f5f5;
            }
            .role-table th:first-child,
            .role-table td:first-child {
                width: 60px;
            }
            .role-table th:nth-child(2),
            .role-table td:nth-child(2) {
                text-align: left;
                width: 200px;
            }
            .role-table th:nth-child(3),
            .role-table td:nth-child(3) {
                text-align: left;
                width: 250px;
                font-family: 'Courier New', monospace;
                font-size: 13px;
                color: #666;
            }
            .permission-checkbox {
                width: 18px;
                height: 18px;
                cursor: pointer;
                accent-color: #1890ff;
            }
            .action-buttons {
                display: flex;
                gap: 8px;
                justify-content: center;
            }
            .btn-edit, .btn-delete {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 13px;
                transition: all 0.3s;
                color: white;
            }
            .btn-edit {
                background-color: #1890ff;
            }
            .btn-edit:hover {
                background-color: #096dd9;
            }
            .btn-delete {
                background-color: #ff4d4f;
            }
            .btn-delete:hover {
                background-color: #d9363e;
            }
            .message {
                padding: 12px 20px;
                border-radius: 6px;
                margin-bottom: 20px;
                font-size: 14px;
            }
            .success-message {
                background-color: #f6ffed;
                border: 1px solid #b7eb8f;
                color: #52c41a;
            }
            .info-message {
                background-color: #e6f7ff;
                border: 1px solid #91d5ff;
                color: #0050b3;
            }
            .error-message {
                background-color: #fff2f0;
                border: 1px solid #ffccc7;
                color: #ff4d4f;
            }
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
                box-sizing: border-box;
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
            /* --- Pagination Styles --- */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: 20px;
                gap: 5px;
            }
            .pagination a, .pagination span {
                padding: 8px 12px;
                border: 1px solid #e5e7eb;
                border-radius: 4px;
                text-decoration: none;
                color: #333;
                transition: all 0.3s;
            }
            .pagination a:hover {
                background-color: #1890ff;
                color: white;
                border-color: #1890ff;
            }
            .pagination .active {
                background-color: #1890ff;
                color: white;
                border-color: #1890ff;
            }
            .pagination .disabled {
                color: #999;
                cursor: not-allowed;
                pointer-events: none;
            }
            .pagination-info {
                text-align: center;
                margin-top: 10px;
                color: #666;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <%@ include file="Sidebar.jsp" %>
        <div class="main-content">
            <main>
                <h2>Quản Lý Phân Quyền</h2>

                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="message success-message">
                        ✓ ${sessionScope.successMessage}
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                </c:if>

                <c:if test="${not empty sessionScope.infoMessage}">
                    <div class="message info-message">
                        ℹ ${sessionScope.infoMessage}
                    </div>
                    <% session.removeAttribute("infoMessage"); %>
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="message error-message">
                        ✗ ${sessionScope.errorMessage}
                    </div>
                    <% session.removeAttribute("errorMessage"); %>
                </c:if>

                <!-- Action Bar -->
                <div class="action-bar">
                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên chức năng hoặc URL...">
                    </div>
                    <button type="button" class="btn-add" onclick="showAddModal()">➕ Thêm URL</button>
                    <button type="button" class="btn-save" onclick="document.getElementById('permissionsForm').submit()">💾 Lưu Thay Đổi</button>
                </div>

                <!-- Permissions Table with Form -->
                <form id="permissionsForm" method="post" action="${pageContext.request.contextPath}/update-permissions">
                    <input type="hidden" name="page" value="${currentPage}">
                    <table class="role-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên Chức Năng</th>
                                <th>Đường dẫn URL</th>
                                    <c:forEach var="role" items="${roles}">
                                    <th>${role.roleName}</th>
                                    </c:forEach>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="permissionsTableBody">
                            <c:forEach var="feature" items="${features}" varStatus="status">
                                <tr data-id="${feature.featureId}">
                                    <td>${status.index + 1}</td>
                                    <td>${feature.featureName}</td>
                                    <td>${feature.url}</td>
                                    <c:forEach var="role" items="${roles}">
                                        <td>
                                            <input type="checkbox" 
                                                   name="permission_${feature.featureId}_${role.roleId}" 
                                                   class="permission-checkbox"
                                                   <c:if test="${featuresDAO.hasPermission(role.roleId, feature.featureId)}">checked</c:if>>
                                            </td>
                                    </c:forEach>
                                    <td>
                                        <div class="action-buttons">
                                            <button type="button" class="btn-edit" 
                                                    onclick="editPermission(${feature.featureId}, '${feature.featureName}', '${feature.url}')">Sửa</button>
                                            <form method="post" action="${pageContext.request.contextPath}/delete-permission" 
                                                  style="display: inline;" 
                                                  onsubmit="return confirm('Bạn có chắc muốn xóa URL này?');">
                                                <input type="hidden" name="id" value="${feature.featureId}">
                                                <button type="submit" class="btn-delete">Xóa</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty features}">
                                <tr>
                                    <td colspan="${4 + roles.size()}" style="text-align: center; padding: 40px; color: #999;">
                                        Chưa có dữ liệu. Vui lòng thêm URL mới.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                    <!-- Pagination -->
                    <c:if test="${not empty features}">
                        <div class="pagination">
                            <!-- Previous button -->
                            <c:choose>
                                <c:when test="${currentPage == 1}">
                                    <span class="disabled">« Trước</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="?page=${currentPage - 1}">« Trước</a>
                                </c:otherwise>
                            </c:choose>

                            <!-- Page numbers -->
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="active">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="?page=${i}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <!-- Next button -->
                            <c:choose>
                                <c:when test="${currentPage == totalPages}">
                                    <span class="disabled">Sau »</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="?page=${currentPage + 1}">Sau »</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
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
                    <form id="permissionForm" method="post" action="${pageContext.request.contextPath}/save-permission">
                        <input type="hidden" id="mode" name="mode" value="add">
                        <input type="hidden" id="editId" name="id" value="">
                        <div class="form-group">
                            <label for="name">Tên Chức Năng: <span style="color: red;">*</span></label>
                            <input type="text" id="name" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="url">Đường dẫn URL: <span style="color: red;">*</span></label>
                            <input type="text" id="url" name="url" required placeholder="/example-url">
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
            // Modal variables and functions
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
            function editPermission(id, name, url) {
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
            window.onclick = function (event) {
                if (event.target === modal) {
                    closeModal();
                }
            };

            // Search functionality
            document.getElementById('searchInput').addEventListener('keyup', function () {
                const searchValue = this.value.toLowerCase();
                const rows = document.querySelectorAll('#permissionsTableBody tr');

                rows.forEach(function (row) {
                    const name = row.cells[1]?.textContent.toLowerCase() || '';
                    const url = row.cells[2]?.textContent.toLowerCase() || '';

                    if (name.includes(searchValue) || url.includes(searchValue)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        </script>
    </body>
</html>