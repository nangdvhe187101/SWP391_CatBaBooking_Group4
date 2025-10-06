<%-- 
    Document   : ApproveApplication
    Created on : Oct 6, 2025, 9:09:31 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Duyệt Yêu Cầu Đăng Ký</title>
    <link rel="stylesheet" href="admin-style.css">
</head>
<body>

    <%@ include file="Sidebar.jsp" %>

    <div class="main-content">
        <header>
            <h1>Duyệt Yêu Cầu Đăng Ký</h1>
        </header>
        <main>
            <div id="listView">
                <table>
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Họ Tên</th>
                            <th>Tên Cơ Sở</th>
                            <th>Loại Cơ Sở</th>
                            <th>Trạng Thái</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td>Nguyễn Văn An</td>
                            <td>An's Homestay</td>
                            <td>Homestay</td>
                            <td><span class="status-pending">Chờ duyệt</span></td>
                            <td><a href="#" class="btn btn-view">Xem chi tiết</a></td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td>Trần Thị Bích</td>
                            <td>Nhà hàng Bích Phương</td>
                            <td>Nhà hàng</td>
                            <td><span class="status-pending">Chờ duyệt</span></td>
                            <td><a href="#" class="btn btn-view">Xem chi tiết</a></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>