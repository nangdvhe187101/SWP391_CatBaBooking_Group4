<%-- 
    Document   : UserManagement
    Created on : Oct 6, 2025, 9:10:16 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Quản Lý Người Dùng</title>
    <link rel="stylesheet" href="admin-style.css">
</head>
<body>

    <%@ include file="Sidebar.jsp" %>

    <div class="main-content">
        <header>
            <h1>Quản Lý Người Dùng</h1>
        </header>
        <main>
            <table>
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Họ Tên</th>
                        <th>Email</th>
                        <th>Quyền</th>
                        <th>Trạng Thái</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td>Lê Thị Cẩm</td>
                        <td>le.cam@email.com</td>
                        <td>Customer</td>
                        <td><span class="status-active">Hoạt động</span></td>
                        <td>
                            <a href="#" class="btn btn-view">Xem</a>
                            <a href="#" class="btn btn-delete">Xóa</a>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>Phạm Văn Dũng</td>
                        <td>pham.dung@email.com</td>
                        <td>Owner</td>
                        <td><span class="status-active">Hoạt động</span></td>
                        <td>
                            <a href="#" class="btn btn-view">Xem</a>
                            <a href="#" class="btn btn-delete">Xóa</a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </main>
    </div>
</body>
</html>
