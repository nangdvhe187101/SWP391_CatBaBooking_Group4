<%-- 
    Document   : AddHomestay
    Created on : Oct 6, 2025, 9:11:14 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Homestay Mới - Cát Bà Booking</title>
    <link rel="stylesheet" href="owner-styles.css">
</head>
<body>
     <%@ include file="Sidebar.jsp" %>

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
                <h2>Thêm Homestay Mới</h2>
                <p>Điền thông tin homestay mới</p>
            </div>

            <div class="card">
                <form id="homestay-form">
                    <div class="input-group">
                        <label>Tên homestay *</label>
                        <input type="text" id="homestay-name" placeholder="Tên homestay" required>
                    </div>
                    <div class="input-group">
                        <label>Địa chỉ</label>
                        <input type="text" id="homestay-address" placeholder="Địa chỉ homestay">
                    </div>
                    <div class="input-group">
                        <label>Giá/đêm (VNĐ)</label>
                        <input type="number" id="homestay-price" placeholder="500000" required>
                    </div>
                    <div class="input-group">
                        <label>Mô tả</label>
                        <textarea id="homestay-description" rows="4" placeholder="Mô tả chi tiết homestay..."></textarea>
                    </div>
                    <div class="input-group">
                        <label>Upload ảnh</label>
                        <input type="file" id="homestay-images" multiple accept="image/*">
                    </div>
                    <div class="input-group">
                        <label>Tiện nghi</label>
                        <div class="checkbox-group">
                            <div class="checkbox-item">
                                <input type="checkbox" id="wifi">
                                <label for="wifi">WiFi miễn phí</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="tv">
                                <label for="tv">TV</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="pool">
                                <label for="pool">Hồ bơi</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="parking">
                                <label for="parking">Chỗ đậu xe</label>
                            </div>
                        </div>
                    </div>
                    <div style="display: flex; gap: 1rem;">
                        <button type="submit" class="btn-primary">Lưu</button>
                        <button type="button" class="btn-secondary" onclick="history.back()">Hủy</button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <!-- JS -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Sidebar toggle (giống trên)
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
            // Form submit
            document.getElementById('homestay-form').addEventListener('submit', function(e) {
                e.preventDefault();
                const formData = new FormData(this);
                console.log('Form data:', Object.fromEntries(formData));
                alert('Đã thêm homestay thành công!');
                window.location.href = 'ManageHomestay.jsp';
            });
        });
    </script>
</body>
</html>
