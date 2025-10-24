<%-- 
    Document   : UpdateHomestay
    Created on : Oct 6, 2025, 9:15:00 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Businesses" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật Homestay - Cát Bà Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/owner-styles.css">
    <style>
        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        .form-row.full {
            grid-template-columns: 1fr;
        }
        .input-group {
            margin-bottom: 1rem;
        }
        .input-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-primary);
        }
        .input-group input,
        .input-group textarea,
        .input-group select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        .input-group input:focus,
        .input-group textarea:focus,
        .input-group select:focus {
            outline: none;
            border-color: var(--primary);
        }
        .checkbox-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 0.5rem;
            margin-top: 0.5rem;
        }
        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .checkbox-item input[type="checkbox"] {
            width: auto;
            margin: 0;
        }
        .alert {
            padding: 1rem;
            border-radius: var(--radius);
            margin-bottom: 1rem;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .btn-group {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
        }
    </style>
</head>
<body>
    <!-- Sidebar (active Quản lý Homestay) -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2>🐚 Cát Bà Booking</h2>
            <h3>Owner Dashboard</h3>
        </div>
        <nav class="sidebar-nav">
            <ul>
                <li><a href="Dashboard.jsp" class="nav-link">🏠 Tổng quan</a></li>
                <li><a href="AddHomestay.jsp" class="nav-link">👤 Hồ sơ</a></li>
                <li><a href="ManageHomestay.jsp" class="nav-link active">🏠 Quản lý Homestay</a></li>
                <li><a href="Feedback.jsp" class="nav-link">💬 Phản hồi & Đánh giá</a></li>
                <li><a href="Reports.jsp" class="nav-link">📊 Báo cáo Doanh thu</a></li>
                <li><a href="#" class="nav-link logout">➡️ Đăng xuất</a></li>
            </ul>
        </nav>
    </aside>

    <!-- Overlay -->
    <div id="sidebar-overlay" class="hidden"></div>

    <!-- Header -->
    <header class="header">
        <button id="sidebar-toggle">☰</button>
        <h1>Cập nhật Homestay</h1>
        <div class="header-actions">
            <span class="notification">🔔</span>
            <span class="user">N nang14dz</span>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <main class="content">
            <div class="page-header">
                <h2>Cập nhật thông tin Homestay</h2>
                <p>Chỉnh sửa thông tin chi tiết của homestay</p>
            </div>

            <!-- Alert Messages -->
            <% if (success != null) { %>
                <div class="alert alert-success">
                    <%= success %>
                </div>
            <% } %>
            
            <% if (error != null) { %>
                <div class="alert alert-error">
                    <%= error %>
                </div>
            <% } %>

            <div class="card form-container">
                <form id="update-homestay-form" method="POST" action="${pageContext.request.contextPath}/update-homestay">
                    <!-- Field 1: Tên homestay (Input) -->
                    <div class="input-group">
                        <label for="name">Tên homestay *</label>
                        <input type="text" id="name" name="name" 
                               value="<%= homestay != null ? homestay.getName() : "" %>" 
                               placeholder="Nhập tên homestay" required>
                    </div>

                    <!-- Field 2: Địa chỉ (Input) -->
                    <div class="input-group">
                        <label for="address">Địa chỉ *</label>
                        <input type="text" id="address" name="address" 
                               value="<%= homestay != null ? homestay.getAddress() : "" %>" 
                               placeholder="Nhập địa chỉ homestay" required>
                    </div>

                    <!-- Field 3: Mô tả (Textarea) -->
                    <div class="input-group">
                        <label for="description">Mô tả</label>
                        <textarea id="description" name="description" rows="4" 
                                  placeholder="Mô tả chi tiết về homestay..."><%= homestay != null ? homestay.getDescription() : "" %></textarea>
                    </div>

                    <!-- Field 4: Giá mỗi đêm (Input - Number) -->
                    <div class="form-row">
                        <div class="input-group">
                            <label for="pricePerNight">Giá mỗi đêm (VNĐ) *</label>
                            <input type="number" id="pricePerNight" name="pricePerNight" 
                                   value="<%= homestay != null && homestay.getPricePerNight() != null ? homestay.getPricePerNight().intValue() : "" %>" 
                                   placeholder="500000" min="0" required>
                        </div>

                        <!-- Field 5: Sức chứa (Input - Number) -->
                        <div class="input-group">
                            <label for="capacity">Sức chứa (người)</label>
                            <input type="number" id="capacity" name="capacity" 
                                   value="<%= homestay != null && homestay.getCapacity() != null ? homestay.getCapacity() : "" %>" 
                                   placeholder="4" min="1">
                        </div>
                    </div>

                    <!-- Field 6: Số phòng ngủ (Input - Number) -->
                    <div class="input-group">
                        <label for="numBedrooms">Số phòng ngủ</label>
                        <input type="number" id="numBedrooms" name="numBedrooms" 
                               value="<%= homestay != null && homestay.getNumBedrooms() != null ? homestay.getNumBedrooms() : "" %>" 
                               placeholder="2" min="0">
                    </div>

                    <!-- Field 7: Upload ảnh (File Input) -->
                    <div class="input-group">
                        <label for="image">Ảnh homestay</label>
                        <input type="file" id="image" name="image" accept="image/*" multiple>
                        <% if (homestay != null && homestay.getImage() != null && !homestay.getImage().isEmpty()) { %>
                            <p style="margin-top: 0.5rem; color: var(--text-secondary);">
                                Ảnh hiện tại: <%= homestay.getImage() %>
                            </p>
                        <% } %>
                    </div>

                    <!-- Checkbox: Trạng thái hoạt động -->
                    <div class="input-group">
                        <label>Trạng thái</label>
                        <div class="checkbox-group">
                            <div class="checkbox-item">
                                <input type="checkbox" id="isActive" name="isActive" 
                                       <%= homestay != null && "active".equals(homestay.getStatus()) ? "checked" : "" %>>
                                <label for="isActive">Homestay đang hoạt động</label>
                            </div>
                        </div>
                    </div>

                    <!-- Button: Cập nhật -->
                    <div class="btn-group">
                        <button type="button" class="btn-secondary" onclick="history.back()">Hủy</button>
                        <button type="submit" class="btn-primary">Cập nhật Homestay</button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <!-- JS -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
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
            
            // Form validation
            document.getElementById('update-homestay-form').addEventListener('submit', function(e) {
                const name = document.getElementById('name').value.trim();
                const address = document.getElementById('address').value.trim();
                const pricePerNight = document.getElementById('pricePerNight').value;
                
                if (!name) {
                    e.preventDefault();
                    alert('Vui lòng nhập tên homestay');
                    return;
                }
                
                if (!address) {
                    e.preventDefault();
                    alert('Vui lòng nhập địa chỉ homestay');
                    return;
                }
                
                if (!pricePerNight || parseFloat(pricePerNight) <= 0) {
                    e.preventDefault();
                    alert('Vui lòng nhập giá mỗi đêm hợp lệ');
                    return;
                }
            });
            
            // Auto-hide alerts after 5 seconds
            setTimeout(() => {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 300);
                });
            }, 5000);
        });
    </script>
</body>
</html>
