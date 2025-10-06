<%-- 
    Document   : Feedback
    Created on : Oct 6, 2025, 9:12:11 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phản hồi & Đánh giá - Cát Bà Booking</title>
    <link rel="stylesheet" href="owner-styles.css">
</head>
<body>
    <!-- Sidebar (active Phản hồi & Đánh giá) -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2>🐚 Cát Bà Booking</h2>
            <h3>Owner Dashboard</h3>
        </div>
        <nav class="sidebar-nav">
            <ul>
                <li><a href="Dashboard.jsp" class="nav-link">🏠 Tổng quan</a></li>
                <li><a href="AddHomestay.jsp" class="nav-link">👤 Hồ sơ</a></li>
                <li><a href="ManageHomestay.jsp" class="nav-link">🏠 Quản lý Homestay</a></li>
                <li><a href="Feedback.jsp" class="nav-link active">💬 Phản hồi & Đánh giá</a></li>
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
                    <h2>Phản hồi & Đánh giá</h2>
                    <p>Quản lý và trả lời đánh giá từ khách hàng</p>
                </div>
            </div>

            <!-- Stats -->
            <div class="metrics-grid">
                <div class="card">
                    <h3>5 đánh giá</h3>
                    <p class="metric">Tổng số</p>
                </div>
                <div class="card">
                    <h3>4.4 ★</h3>
                    <p class="metric">Điểm trung bình</p>
                </div>
                <div class="card">
                    <h3>3 chừa</h3>
                    <p class="metric">Chưa trả lời</p>
                </div>
            </div>

            <!-- Filter -->
            <div class="card">
                <select style="padding: 0.5rem; border: 1px solid var(--border); border-radius: var(--radius);">
                    <option>Tất cả đánh giá</option>
                    <option>5 sao</option>
                    <option>4 sao</option>
                </select>
            </div>

            <!-- Reviews List -->
            <div class="card">
                <h3>Đánh giá gần đây</h3>
                <div style="margin-top: 1rem;">
                    <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
                        <img src="https://source.unsplash.com/40x40/?avatar" alt="User" style="border-radius: 50%;">
                        <div style="flex: 1;">
                            <h4>Nguyễn Văn A ★★★★★</h4>
                            <p>02/09/2025</p>
                        </div>
                        <span class="stars">★★★★★</span>
                    </div>
                    <p>Homestay rất đẹp, view biển tuyệt vời! Nhân viên thân thiện, sạch sẽ.</p>
                    <button class="btn-primary" style="margin-top: 1rem;">Trả lời</button>
                </div>
                <div style="border-top: 1px solid var(--border); padding-top: 1rem;">
                    <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
                        <img src="https://source.unsplash.com/40x40/?woman" alt="User" style="border-radius: 50%;">
                        <div style="flex: 1;">
                            <h4>Trần Thị B ★★★☆☆</h4>
                            <p>25/08/2025</p>
                        </div>
                        <span class="stars">★★★☆☆</span>
                    </div>
                    <p>Phòng sạch nhưng WiFi yếu. Cải thiện thêm nhé!</p>
                    <button class="btn-primary" style="margin-top: 1rem;">Trả lời</button>
                </div>
            </div>
        </main>
    </div>

    <!-- JS -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.btn-primary').forEach(btn => {
                btn.addEventListener('click', () => alert('Mở form trả lời!'));
            });
        });
    </script>
</body>
</html>
