<%-- 
    Document   : ManageHomestay
    Created on : Oct 6, 2025, 9:12:04 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Homestay - Cát Bà Booking</title>
    <link rel="stylesheet" href="owner-styles.css">
    <style>
        .btn-small {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: var(--radius);
            font-size: 0.875rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .btn-small:hover {
            background-color: var(--primary-dark);
        }
    </style>
</head>
<body>
    <div class="owner-container">
        <jsp:include page="Sidebar.jsp" />

    <!-- Overlay -->
    <div id="sidebar-overlay" class="hidden"></div>

    <!-- Header -->
    <header class="header">
        <button id="sidebar-toggle">☰</button>
        <h1>Xin chào, nang14dz!</h1>
        <div class="header-actions">
            <span class="notification">🔔</span>
            <span class="user">N nang14dz</span>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <main class="content">
            <div class="page-header">
                <div>
                    <h2>Quản lý Homestay</h2>
                    <p>Quản lý danh sách homestay của bạn</p>
                </div>
                <button class="btn-primary" onclick="window.location.href='AddHomestay.jsp'">+ Thêm Homestay Mới</button>
            </div>

            <!-- Search -->
            <div class="card">
                <input type="text" placeholder="Tìm kiếm tên homestay..." style="width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: var(--radius);">
                <select style="margin-top: 1rem; padding: 0.5rem; border: 1px solid var(--border); border-radius: var(--radius);">
                    <option>Tất cả trạng thái</option>
                    <option>Hoạt động</option>
                    <option>Tạm ngưng</option>
                </select>
            </div>
            
            <div class="content-body">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên Homestay</th>
                                <th>Địa chỉ</th>
                                <th>Khu vực</th>
                                <th>Giá (VND/đêm)</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- 2. Dùng JSTL <c:forEach> để lặp qua danh sách "listH" --%>
                            <c:forEach var="h" items="${listH}" varStatus="loop">
                                <tr>
                                    <td>${loop.count}</td>
                                    <td><c:out value="${h.getName()}"/></td>
                                    <td><c:out value="${h.getAddress()}"/></td>
                                    <%-- Lấy tên khu vực (đã được set ở Bước 1) --%>
                                    <td><c:out value="${h.getArea().getName()}"/></td>
                                    <td>
                                        <fmt:formatNumber value="${h.getPricePerNight()}" type="currency" currencyCode="VND" minFractionDigits="0" />
                                    </td>
                                    <td>
                                        <span class="status status-${fn:toLowerCase(h.getStatus())}">
                                            ${h.getStatus()}
                                        </span>
                                    </td>
                                    <td>
                                        <%-- 3. NÚT CẬP NHẬT --%>
                                        <%-- Trỏ đến "update-homestay" (servlet UpdateHomestayController của bạn) --%>
                                        <a href="update-homestay?id=${h.getBusinessId()}" class="btn-action btn-update">Cập nhật</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <%-- 4. Hiển thị thông báo nếu danh sách rỗng --%>
                            <c:if test="${empty listH}">
                                <tr>
                                    <td colspan="7" style="text-align: center;">Bạn chưa có homestay nào. Vui lòng "Thêm Homestay" từ menu.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Homestay Grid -->
<!--            <div class="homestay-grid">
                <div class="homestay-card">
                    <img src="https://source.unsplash.com/300x200/?homestay,beach" alt="Homestay Biển Xanh" class="homestay-image">
                    <div class="homestay-status">Hoạt động</div>
                    <div class="homestay-info">
                        <h3>Homestay Biển Xanh</h3>
                        <p>@Cát Bà</p>
                        <p>₫500.000/đêm</p>
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span>24 lượt xem</span>
                            <div style="display: flex; gap: 0.5rem; align-items: center;">
                                <button class="btn-small" onclick="window.location.href='UpdateHomestay.jsp'">Cập nhật</button>
                                <label class="switch">
                                    <input type="checkbox" checked>
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                 Thêm 3 card tương tự với ảnh khác 
                <div class="homestay-card">
                    <img src="https://source.unsplash.com/300x200/?villa,sunset" alt="Villa Sunset Cát Bà" class="homestay-image">
                    <div class="homestay-status">Hoạt động</div>
                    <div class="homestay-info">
                        <h3>Villa Sunset Cát Bà</h3>
                        <p>@Cát Bà</p>
                        <p>₫1.200.000/đêm</p>
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span>18 lượt xem</span>
                            <div style="display: flex; gap: 0.5rem; align-items: center;">
                                <button class="btn-small" onclick="updateHomestay(2)">Cập nhật</button>
                                <label class="switch">
                                    <input type="checkbox" checked>
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="homestay-card">
                    <img src="https://source.unsplash.com/300x200/?house,sea" alt="Nhà ven Biển" class="homestay-image">
                    <div class="homestay-status">Tạm ngưng</div>
                    <div class="homestay-info">
                        <h3>Nhà ven Biển</h3>
                        <p>@Cát Bà</p>
                        <p>₫350.000/đêm</p>
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span>0 lượt xem</span>
                            <div style="display: flex; gap: 0.5rem; align-items: center;">
                                <button class="btn-small" onclick="updateHomestay(3)">Cập nhật</button>
                                <label class="switch">
                                    <input type="checkbox">
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="homestay-card">
                    <img src="https://source.unsplash.com/300x200/?pool,villa" alt="Villa Hồ Bơi" class="homestay-image">
                    <div class="homestay-status">Hoạt động</div>
                    <div class="homestay-info">
                        <h3>Villa Hồ Bơi</h3>
                        <p>@Cát Bà</p>
                        <p>₫800.000/đêm</p>
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span>12 lượt xem</span>
                            <div style="display: flex; gap: 0.5rem; align-items: center;">
                                <button class="btn-small" onclick="updateHomestay(4)">Cập nhật</button>
                                <label class="switch">
                                    <input type="checkbox" checked>
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>-->
        </main>
    </div>

<!--     JS 
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Sidebar toggle (giống Dashboard)
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
            // Switch toggle mock
            document.querySelectorAll('.switch input').forEach(input => {
                input.addEventListener('change', () => alert('Cập nhật trạng thái!'));
            });
        });
        
        // Function to redirect to update homestay page
        function updateHomestay(businessId) {
            window.location.href = 'update-homestay';
        }
    </script>-->
</body>
</html>
