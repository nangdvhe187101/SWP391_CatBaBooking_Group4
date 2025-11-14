<%-- 
    Document   : ManageHomestayRooms
    Created on : Nov 13, 2025
    Author     : jackd
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Owner - Quản lý Phòng</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css" />
        
        <style>
            .table-actions { display: flex; gap: 5px; justify-content: flex-end; }
            .badge-active { background-color: #198754; color: white; }
            .badge-inactive { background-color: #6c757d; color: white; }
        </style>
    </head>
    <body>

        <%@ include file="Sidebar.jsp" %>

        <div id="sidebar-overlay" class="hidden"></div>

        <header class="header">
            <button id="sidebar-toggle">☰</button>
            <h1>Quản lý Phòng - ${business.name}</h1>
            <div class="header-actions">
                <span class="notification">🔔</span>
                <span class="user">O ${currentUser.fullName}</span>
            </div>
        </header>

        <div class="main-content">
            <main class="content">
                <div class="container-fluid py-3">
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="card shadow-sm">
                        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                            <h6 class="mb-0 fw-bold text-primary"><i class="bi bi-list-ul me-2"></i>Danh sách phòng hiện có</h6>
                            </div>
                        
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0 align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên phòng</th>
                                            <th>Sức chứa</th>
                                            <th>Giá/đêm</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty rooms}">
                                                <tr><td colspan="6" class="text-center text-muted py-5">Chưa có phòng nào.</td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="room" items="${rooms}">
                                                    
                                                    <%-- Tạo biến giá "sạch" (số nguyên) để đưa vào data-attribute cho Modal sửa --%>
                                                    <fmt:formatNumber value="${room.pricePerNight}" pattern="#" var="cleanPrice" />
                                                    
                                                    <tr>
                                                        <td>#${room.roomId}</td>
                                                        <td class="fw-500">${room.name}</td>
                                                        <td><i class="bi bi-person"></i> ${room.capacity}</td>
                                                        <td class="fw-bold text-success">
                                                            <fmt:formatNumber value="${room.pricePerNight}" type="currency" currencyCode="VND" />
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${room.isActive}">
                                                                    <span class="badge badge-active">Hoạt động</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-inactive">Đang ẩn</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-end">
                                                            <div class="table-actions">
                                                                <form method="post" action="${pageContext.request.contextPath}/toggle-homestay-room-status" style="display:inline;">
                                                                    <input type="hidden" name="roomId" value="${room.roomId}" />
                                                                    <c:choose>
                                                                        <c:when test="${room.isActive}">
                                                                            <button type="submit" class="btn btn-sm btn-outline-secondary" title="Tắt phòng này">
                                                                                <i class="bi bi-eye-slash"></i>
                                                                            </button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <button type="submit" class="btn btn-sm btn-outline-success" title="Bật phòng này">
                                                                                <i class="bi bi-eye"></i>
                                                                            </button>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </form>

                                                                <button class="btn btn-sm btn-outline-primary edit-btn" 
                                                                        data-bs-toggle="modal" data-bs-target="#editModal"
                                                                        data-id="${room.roomId}"
                                                                        data-name="${room.name}"
                                                                        data-capacity="${room.capacity}"
                                                                        data-price="${cleanPrice}" <%-- Giá sạch không có .00 --%>
                                                                        data-active="${room.isActive}">
                                                                    <i class="bi bi-pencil-square"></i>
                                                                </button>

                                                                <form method="post" action="${pageContext.request.contextPath}/delete-homestay-room" style="display:inline;">
                                                                    <input type="hidden" name="roomId" value="${room.roomId}" />
                                                                    <button type="submit" class="btn btn-sm btn-outline-danger" 
                                                                            onclick="return confirm('CẢNH BÁO: Bạn có chắc chắn muốn xóa phòng này không?\nMọi lịch sử đặt phòng liên quan sẽ bị xóa vĩnh viễn!')"
                                                                            title="Xóa vĩnh viễn">
                                                                        <i class="bi bi-trash"></i>
                                                                    </button>
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

                        <c:if test="${totalPages > 1}">
                            <div class="card-footer bg-white py-3">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center mb-0">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage - 1}">Trước</a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage + 1}">Sau</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </div>
                </div>
            </main>
        </div>

        <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Cập nhật thông tin phòng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/update-homestay-room">
                        <div class="modal-body">
                            <input type="hidden" name="roomId" id="editRoomId" />
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Tên phòng</label>
                                <input name="name" type="text" class="form-control" id="editName" required />
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Sức chứa (người)</label>
                                    <input name="capacity" type="number" min="1" class="form-control" id="editCapacity" required />
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Giá/đêm (VNĐ)</label>
                                    <input name="pricePerNight" type="text" class="form-control" id="editPrice" required placeholder="Ví dụ: 500000" />
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Trạng thái</label>
                                <select name="isActive" class="form-select" id="editIsActive">
                                    <option value="true">Hoạt động (Khách có thể đặt)</option>
                                    <option value="false">Ẩn / Bảo trì (Khách không thấy)</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Sidebar Toggle
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

                // Xử lý dữ liệu Modal Sửa
                const editModal = document.getElementById('editModal');
                if (editModal) {
                    editModal.addEventListener('show.bs.modal', event => {
                        // Button trigger modal
                        const button = event.relatedTarget;
                        
                        // Lấy data attributes
                        const id = button.getAttribute('data-id');
                        const name = button.getAttribute('data-name');
                        const capacity = button.getAttribute('data-capacity');
                        const price = button.getAttribute('data-price');
                        const active = button.getAttribute('data-active'); // "true" or "false"

                        // Điền vào form
                        document.getElementById('editRoomId').value = id;
                        document.getElementById('editName').value = name;
                        document.getElementById('editCapacity').value = capacity;
                        document.getElementById('editPrice').value = price;
                        document.getElementById('editIsActive').value = active;
                    });
                }
            });
        </script>
    </body>
</html>