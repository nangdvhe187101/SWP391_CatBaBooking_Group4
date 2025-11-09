<%-- 
    Document   : RestaurantManageTables
    Created on : Oct 22, 2025, 12:08:35 PM
    Author     : ADMIN
    Updated    : Align buttons in Thao tác column (text-end + d-flex justify-content-end)
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css" />
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
                    <c:if test="${not empty errors}">
                        <div class="alert alert-danger" role="alert">
                            <strong>Lỗi:</strong>
                            <ul class="mb-0">
                                <c:forEach var="err" items="${errors}">
                                    <li>${err}</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">${error}</div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="alert alert-success" role="alert">${message}</div>
                    </c:if>

                    <div class="border rounded p-3 mb-3">
                        <h3 class="mb-3"><i class="bi bi-plus-lg me-2"></i>Thêm bàn mới</h3>
                        <form method="post" action="${pageContext.request.contextPath}/restaurant-table-add" class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Tên bàn</label>
                                <input name="name" type="text" class="form-control" placeholder="e.g., Bàn 1" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Sức chứa</label>
                                <input name="capacity" type="number" min="1" class="form-control" required />
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Trạng thái</label>
                                <select name="isActive" class="form-select">
                                    <option value="true">activate</option>
                                    <option value="false">inactive</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2">Thêm</button>
                            </div>
                        </form>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h6 class="mb-0">Danh sách bàn</h6>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên</th>
                                            <th>Sức chứa</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end">Thao tác</th>  <!-- Right-align header -->
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty tables}">
                                                <tr><td colspan="5" class="text-center text-muted">Chưa có bàn nào.</td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="table" items="${tables}">
                                                    <tr>
                                                        <td>${table.tableId}</td>
                                                        <td>${table.name}</td>
                                                        <td>${table.capacity}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${table.active}"><span class="badge bg-success">activate</span></c:when>
                                                                <c:otherwise><span class="badge bg-secondary">inactive</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-end">  <!-- Right-align cell -->
                                                            <div class="d-flex justify-content-end gap-1">  <!-- Flex row for buttons, gap spacing -->
                                                                <button class="btn btn-sm btn-outline-primary edit-btn" 
                                                                        data-bs-toggle="modal" data-bs-target="#editModal"
                                                                        data-id="${table.tableId}"
                                                                        data-name="${table.name}"
                                                                        data-capacity="${table.capacity}"
                                                                        data-active="${table.active ? 'true' : 'false'}">
                                                                    Sửa
                                                                </button>
                                                                <form method="post" action="${pageContext.request.contextPath}/restaurant-table-delete" style="display: inline;">
                                                                    <input type="hidden" name="tableId" value="${table.tableId}" />
                                                                    <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa bàn này?')">Xóa</button>
                                                                </form>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Edit Modal -->
        <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editModalLabel">Sửa bàn</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/restaurant-table-update" id="editForm">
                        <div class="modal-body">
                            <input type="hidden" name="tableId" id="editTableId" />
                            <div class="mb-3">
                                <label class="form-label">Tên bàn</label>
                                <input name="name" type="text" class="form-control" id="editName" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Sức chứa</label>
                                <input name="capacity" type="number" min="1" class="form-control" id="editCapacity" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="isActive" class="form-select" id="editIsActive">
                                    <option value="true">activate</option>
                                    <option value="false">inactive</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Sidebar toggle
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

                // Populate modal on edit button click
                const editButtons = document.querySelectorAll('.edit-btn');
                editButtons.forEach(btn => {
                    btn.addEventListener('click', function() {
                        const id = this.getAttribute('data-id');
                        const name = this.getAttribute('data-name');
                        const capacity = this.getAttribute('data-capacity');
                        const active = this.getAttribute('data-active');
                        
                        document.getElementById('editTableId').value = id;
                        document.getElementById('editName').value = name;
                        document.getElementById('editCapacity').value = capacity;
                        document.getElementById('editIsActive').value = active;
                    });
                });
            });
        </script>
    </body>
</html>