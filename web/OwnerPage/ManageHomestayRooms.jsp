<%-- 
    Document   : ManageHomestayRooms
    Created on : Nov 13, 2025, 12:19:45 AM
    Author     : jackd
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Owner - Quản lý Phòng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css" />
    </head>
    <body>

        <%@ include file="Sidebar.jsp" %>

        <div id="sidebar-overlay" class="hidden"></div>

        <header class="header">
            <button id="sidebar-toggle">☰</button>
            <h1>Quản lý Phòng</h1>
            <div class="header-actions">
                <span class="notification">🔔</span>
                <span class="user">O ${currentUser.fullName}</span>
            </div>
        </header>

        <div class="main-content">
            <main class="content">

                <div class="container-fluid py-3">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">${error}</div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="alert alert-success" role="alert">${message}</div>
                    </c:if>

                    <div class="card">
                        <div class="card-header">
                            <h6 class="mb-0">Danh sách phòng</h6>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
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
                                                <tr><td colspan="6" class="text-center text-muted">Chưa có phòng nào.</td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="room" items="${rooms}">
                                                    <tr>
                                                        <td>${room.roomId}</td>
                                                        <td>${room.name}</td>
                                                        <td>${room.capacity} người</td>
                                                        <td>
                                                            <fmt:formatNumber value="${room.pricePerNight}" type="currency" currencyCode="VND" />
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${room.isActive}"><span class="badge bg-success">Đang hoạt động</span></c:when>
                                                                <c:otherwise><span class="badge bg-secondary">Vô hiệu hóa</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-end">
                                                            <div class="d-flex justify-content-end gap-1">
                                                                <button class="btn btn-sm btn-outline-primary edit-btn" 
                                                                        data-bs-toggle="modal" data-bs-target="#editModal"
                                                                        data-id="${room.roomId}"
                                                                        data-name="${room.name}"
                                                                        data-capacity="${room.capacity}"
                                                                        data-price="${room.pricePerNight}"
                                                                        data-active="${room.isActive ? 'true' : 'false'}">
                                                                    <i class="bi bi-pencil-fill"></i> Sửa
                                                                </button>
                                                                
                                                                <form method="post" action="${pageContext.request.contextPath}/toggle-homestay-room-status" style="display: inline;">
                                                                    <input type="hidden" name="roomId" value="${room.roomId}" />
                                                                    <c:choose>
                                                                        <c:when test="${room.isActive}">
                                                                            <button type="submit" class="btn btn-sm btn-outline-warning"><i class="bi bi-eye-slash-fill"></i> Tắt</button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <button type="submit" class="btn btn-sm btn-outline-success"><i class="bi bi-eye-fill"></i> Bật</button>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </form>

                                                                <form method="post" action="${pageContext.request.contextPath}/delete-homestay-room" style="display: inline;">
                                                                    <input type="hidden" name="roomId" value="${room.roomId}" />
                                                                    <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có chắc chắn muốn XÓA VĨNH VIỄN phòng này? Mọi dữ liệu đặt phòng liên quan cũng sẽ bị mất.')">
                                                                        <i class="bi bi-trash-fill"></i> Xóa
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
                            <div class="card-footer">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center mb-0">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item"><a class="page-link" href="?page=${currentPage - 1}">Trước</a></li>
                                        </c:if>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item <c:if test='${i == currentPage}'>active</c:if>">
                                                <a class="page-link" href="?page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item"><a class="page-link" href="?page=${currentPage + 1}">Sau</a></li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </div>
                </div>
            </main>
        </div>

        <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editModalLabel">Sửa thông tin phòng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/update-homestay-room" id="editForm">
                        <div class="modal-body">
                            <input type="hidden" name="roomId" id="editRoomId" />
                            
                            <div class="mb-3">
                                <label class="form-label">Tên phòng</label>
                                <input name="name" type="text" class="form-control" id="editName" required />
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Sức chứa (người)</label>
                                <input name="capacity" type="number" min="1" class="form-control" id="editCapacity" required />
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Giá/đêm (VND)</label>
                                <input name="pricePerNight" type="number" min="1" step="1000" class="form-control" id="editPrice" required />
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="isActive" class="form-select" id="editIsActive">
                                    <option value="true">Đang hoạt động</option>
                                    <option value="false">Vô hiệu hóa</option>
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
            // JS này giống hệt file RestaurantManageTables.jsp
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

                // Cập nhật JS cho modal Sửa Phòng
                const editButtons = document.querySelectorAll('.edit-btn');
                editButtons.forEach(btn => {
                    btn.addEventListener('click', function() {
                        const id = this.getAttribute('data-id');
                        const name = this.getAttribute('data-name');
                        const capacity = this.getAttribute('data-capacity');
                        const price = this.getAttribute('data-price'); // Thêm data-price
                        const active = this.getAttribute('data-active');
                        
                        document.getElementById('editRoomId').value = id;
                        document.getElementById('editName').value = name;
                        document.getElementById('editCapacity').value = capacity;
                        document.getElementById('editPrice').value = price; // Set giá trị cho ô giá
                        document.getElementById('editIsActive').value = active;
                    });
                });
            });
        </script>
    </body>
</html>