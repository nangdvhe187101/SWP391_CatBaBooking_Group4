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
        <title>Thêm Phòng Mới - Cát Bà Booking</title>
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
                    <h2>Thêm Phòng Mới</h2>
                    <p>Điền thông tin phòng mới</p>
                </div>

                <div class="card">
                    <form id="homestay-form" action="${pageContext.request.contextPath}/OwnerPage/AddHomestay" method="post">

                        <!-- Business ID (ẩn) -->
                        <input type="hidden" name="businessId" value="${sessionScope.loggedBusiness.businessId}">

                        <!-- Tên phòng -->
                        <div class="input-group">
                            <label for="room-name">Tên phòng</label>
                            <input type="text" id="room-name" name="name" placeholder="Tên phòng" required>
                        </div>                   

                        <!-- Giá/đêm -->
                        <div class="input-group">
                            <label for="room-price">Giá/đêm (VNĐ)</label>
                            <input type="number" id="room-price" name="pricePerNight" placeholder="500000" required>
                        </div>

                        <!-- Số lượng người -->
                        <div class="input-group">
                            <label for="room-capacity">Số lượng người</label>
                            <input type="number" id="room-capacity" name="capacity" placeholder="2" required>
                        </div>

                        <!-- Nhập link ảnh -->
                        <div class="input-group">
                            <label for="room-image-url">Link ảnh (URL)</label>
                            <input type="url" id="room-image-url" name="image" placeholder="https://example.com/room.jpg" required>
                        </div>

                        <!-- Ảnh xem trước -->
                        <div class="input-group">
                            <img id="preview-image" src="" alt="Xem trước ảnh phòng" style="max-width: 300px; display: none; border-radius: 8px; margin-top: 8px;">
                        </div>

                        <!-- Tiện nghi -->
                        <div class="input-group">
                            <label>Tiện nghi</label>
                            <div class="checkbox-group">
                                <div class="checkbox-item">
                                    <input type="checkbox" name="amenities" value="wifi" id="wifi">
                                    <label for="wifi">WiFi miễn phí</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" name="amenities" value="tv" id="tv">
                                    <label for="tv">TV</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" name="amenities" value="pool" id="pool">
                                    <label for="pool">Hồ bơi</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" name="amenities" value="parking" id="parking">
                                    <label for="parking">Chỗ đậu xe</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" name="amenities" value="steam" id="steam">
                                    <label for="steam">Phòng xông hơi</label>
                                </div>
                            </div>
                        </div>

                        <!-- Trạng thái -->
                        <div class="input-group">
                            <label for="isActive">Trạng thái</label>
                            <select id="isActive" name="isActive">
                                <option value="true" selected>Hoạt động</option>
                                <option value="false">Tạm ngưng</option>
                            </select>
                        </div>

                        <!-- Nút submit -->
                        <div class="input-group">
                            <button type="submit">Lưu phòng</button>
                        </div>
                    </form>
                </div>

                <!-- Script hiển thị ảnh xem trước -->
                <script>
                    const imageInput = document.getElementById('room-image-url');
                    const previewImg = document.getElementById('preview-image');

                    imageInput.addEventListener('input', () => {
                        const url = imageInput.value.trim();
                        if (url) {
                            previewImg.src = url;
                            previewImg.style.display = 'block';
                        } else {
                            previewImg.style.display = 'none';
                        }
                    });
                </script>


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

                // Form submit - Gửi bình thường đến servlet
                const form = document.getElementById('homestay-form');
                if (form) {
                form.addEventListener('submit', function () {
                alert('Đang gửi dữ liệu, vui lòng chờ...');
                });
                }
                });
 </script>
                </body>
                </html>
