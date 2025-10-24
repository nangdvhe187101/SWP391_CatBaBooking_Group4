<%-- 
    Document   : dashboard
    Created on : Oct 6, 2025, 9:12:32 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan - Cát Bà Booking</title>
    <link rel="stylesheet" href="owner-styles.css">
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2>🐚 Cát Bà Booking</h2>
            <h3>Owner Dashboard</h3>
        </div>
        <nav class="sidebar-nav">
            <ul>
                <li><a href="Dashboard.jsp" class="nav-link active">🏠 Tổng quan</a></li>
                <li><a href="AddHomestay.jsp" class="nav-link">👤 Hồ sơ</a></li>
                <li><a href="${pageContext.request.contextPath}/ManageHomestay.jsp" class="nav-link">🏠 Quản lý Homestay</a></li>
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
                    <h2>Tổng quan Dashboard</h2>
                    <p>Theo dõi hoạt động kinh doanh của bạn</p>
                </div>
                <button class="btn-primary">+ Thêm Homestay Mới</button>
            </div>

            <!-- Metrics -->
            <div class="metrics-grid">
                <div class="card">
                    <h3>Tổng doanh thu</h3>
                    <p class="metric">45.890.000 ₫</p>
                    <span class="trend up">+12% so với tháng trước</span>
                </div>
                <div class="card">
                    <h3>Đặt phòng đang hoạt động</h3>
                    <p class="metric">24</p>
                    <span class="trend up">+3 so với tháng trước</span>
                </div>
                <div class="card">
                    <h3>Đánh giá mới</h3>
                    <p class="metric">18</p>
                    <span class="trend up">+5 so với tháng trước</span>
                </div>
                <div class="card">
                    <h3>Homestay đang hoạt động</h3>
                    <p class="metric">12</p>
                    <span class="trend">0 so với tháng trước</span>
                </div>
            </div>

            <!-- Table Hoạt động gần đây -->
            <div class="card">
                <h3>Hoạt động gần đây</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Ngày</th>
                            <th>Khách hàng</th>
                            <th>Loại</th>
                            <th>Trạng thái</th>
                            <th>Giá trị</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>02/10/2025</td>
                            <td>Nguyễn Văn A</td>
                            <td>Đặt phòng</td>
                            <td class="status active">Đang hoạt động</td>
                            <td>1.200.000 ₫</td>
                        </tr>
                        <tr>
                            <td>01/10/2025</td>
                            <td>Trần Thị B</td>
                            <td>Đánh giá</td>
                            <td class="status mid">Mới</td>
                            <td>5 sao</td>
                        </tr>
                        <tr>
                            <td>01/10/2025</td>
                            <td>Lê Văn C</td>
                            <td>Đặt phòng</td>
                            <td class="status high">Hủy</td>
                            <td>2.400.000 ₫</td>
                        </tr>
                        <tr>
                            <td>30/09/2025</td>
                            <td>Phạm Thị D</td>
                            <td>Đặt phòng</td>
                            <td class="status low">Hoàn thành</td>
                            <td>1.800.000 ₫</td>
                        </tr>
                        <tr>
                            <td>29/09/2025</td>
                            <td>Hoàng Văn E</td>
                            <td>Đánh giá</td>
                            <td class="status low">Thấp</td>
                            <td>4 sao</td>
                        </tr>
                    </tbody>
                </table>
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
            // Logout mock
            document.querySelector('.logout').addEventListener('click', e => {
                e.preventDefault();
                if (confirm('Đăng xuất?')) alert('Đăng xuất thành công!');
            });
        });
    </script>
</body>
</html>
