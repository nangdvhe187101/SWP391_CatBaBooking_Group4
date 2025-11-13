<%-- 
    Document   : Reports
    Created on : Oct 6, 2025, 9:11:53 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo Doanh thu - Cát Bà Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css">
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
            
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <main class="content">
            <div class="page-header">
                <div>
                    <h2>Báo cáo Doanh thu</h2>
                    <p>Tổng kết doanh thu theo tháng</p>
                </div>
                <div style="display: flex; gap: 1rem;">
                    <input type="date" value="2025-01-01" style="padding: 0.5rem;">
                    <input type="date" value="2025-10-03" style="padding: 0.5rem;">
                    <button class="btn-primary">Lọc</button>
                </div>
            </div>

            <!-- Metrics -->
            <div class="metrics-grid">
                <div class="card">
                    <h3>Tổng doanh thu</h3>
                    <p class="metric">45.800.000 ₫</p>
                </div>
                <div class="card">
                    <h3>Doanh thu tháng</h3>
                    <p class="metric">43.200.000 ₫</p>
                </div>
                <div class="card">
                    <h3>Doanh thu ngày</h3>
                    <p class="metric">1.600.000 ₫</p>
                </div>
                <div class="card">
                    <h3>Tổng doanh thu năm</h3>
                    <p class="metric">41.600.000 ₫</p>
                </div>
            </div>

            <!-- Charts -->
            <div class="card" style="display: flex; gap: 2rem;">
                <div style="flex: 1;">
                    <h3>Doanh thu tháng</h3>
                    <canvas id="line-chart" class="chart-container"></canvas>
                </div>
                <div style="flex: 1;">
                    <h3>Thống kê loại</h3>
                    <canvas id="bar-chart" class="chart-container"></canvas>
                </div>
            </div>

            <!-- Table -->
            <div class="card">
                <h3>Chi tiết doanh thu</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Mã GD</th>
                            <th>Ngày</th>
                            <th>Khách hàng</th>
                            <th>Homestay</th>
                            <th>Số tiền (₫)</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>GD001</td>
                            <td>03/10/2025</td>
                            <td>Nguyễn Văn A</td>
                            <td>Homestay Biển Xanh</td>
                            <td>500.000</td>
                            <td class="status active">Hoàn thành</td>
                        </tr>
                        <!-- Thêm rows -->
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <!-- JS -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Sidebar toggle (giống trên)
            // ... (copy)

            // Line chart mock (canvas)
            const lineCtx = document.getElementById('line-chart').getContext('2d');
            new Chart(lineCtx, {
                type: 'line',
                data: {
                    labels: ['Th1', 'Th2', 'Th3', 'Th4', 'Th5', 'Th6', 'Th7', 'Th8', 'Th9', 'Th10'],
                    datasets: [{ label: 'Doanh thu', data: [12000000, 19000000, 3000000, 5000000, 2000000, 3000000, 10000000, 25000000, 35000000, 45800000], borderColor: var(--primary) }]
                }
            });

            // Bar chart mock
            const barCtx = document.getElementById('bar-chart').getContext('2d');
            new Chart(barCtx, {
                type: 'bar',
                data: {
                    labels: ['Hoàn thành', 'Hủy', 'Đang xử lý'],
                    datasets: [{ label: 'Số lượng', data: [60, 15, 25], backgroundColor: var(--primary) }]
                }
            });
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</body>
</html>