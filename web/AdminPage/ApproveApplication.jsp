<%-- 
    Document   : ApproveApplication
    Created on : Oct 6, 2025, 9:09:31 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Duyệt Yêu Cầu Đăng Ký</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/AdminPage/admin-style.css">
    <style>
        /* --- General Styles --- */
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            margin: 0;
            background-color: #f0f2f5;
            color: #333;
            display: flex;
        }

        /* --- Main Content --- */
        .main-content {
            margin-left: 250px;
            flex-grow: 1;
            padding: 20px;
        }

        main {
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

        /* --- List View --- */
        .list-view {
            display: block;
        }

        .list-view table {
            width: 100%;
            border-collapse: collapse;
        }

        .list-view th, .list-view td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }

        .list-view th {
            background-color: #f0f2f5;
            font-weight: bold;
        }

        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-approve {
            background-color: #52c41a;
            color: white;
        }

        .btn-reject {
            background-color: #ff4d4f;
            color: white;
        }

        .btn-back {
            background-color: #d9d9d9;
            color: #333;
        }

        /* --- Detail View --- */
        .detail-view {
            display: none;
        }

        .detail-content {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .detail-column {
            flex: 1;
        }

        .detail-item {
            margin-bottom: 10px;
        }

        .actions {
            text-align: center;
        }

        .actions form {
            display: inline;
        }

        .actions textarea {
            width: 100%;
            margin: 10px 0;
        }
    </style>
</head>
<body>

    <%@ include file="Sidebar.jsp" %>

    <div class="main-content">
        <main>
            <c:choose>
                <c:when test="${not empty user}">
                    <div id="detailView" class="detail-view">
                        <div class="detail-content">
                            <div class="detail-column">
                                <h3>THÔNG TIN CÁ NHÂN</h3>
                                <div class="detail-item"><strong>Họ và tên:</strong> ${user.fullName}</div>
                                <div class="detail-item"><strong>Số điện thoại:</strong> ${user.phone}</div>
                                <div class="detail-item"><strong>Số CCCD:</strong> ${user.citizenId}</div>
                                <div class="detail-item"><strong>Địa chỉ cá nhân:</strong> ${user.personalAddress}</div>
                            </div>
                            <div class="detail-column">
                                <h3>THÔNG TIN CƠ SỞ KINH DOANH</h3>
                                <div class="detail-item"><strong>Tên cơ sở:</strong> ${business.name}</div>
                                <div class="detail-item"><strong>Loại hình:</strong> ${business.type}</div>
                                <div class="detail-item"><strong>Địa chỉ kinh doanh:</strong> ${business.address}</div>
                                <div class="detail-item"><strong>Mô tả chi tiết:</strong> ${business.description}</div>
                            </div>
                        </div>
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/approve-application" class="btn btn-back">↩️ Quay lại danh sách</a>
                            <form action="${pageContext.request.contextPath}/approve-application" method="post" id="rejectForm" style="display: inline;">
                                <input type="hidden" name="action" value="reject">
                                <input type="hidden" name="userId" value="${user.userId}">
                                <textarea name="reason" placeholder="Lý do từ chối" required style="display: none;" id="reasonText"></textarea>
                                <button type="button" class="btn btn-reject" onclick="document.getElementById('reasonText').style.display='block'; this.style.display='none'; document.getElementById('confirmReject').style.display='inline';">❌ Từ chối</button>
                                <button type="submit" style="display: none;" id="confirmReject">Xác nhận từ chối</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/approve-application" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="userId" value="${user.userId}">
                                <button type="submit" class="btn btn-approve">✅ Phê duyệt</button>
                            </form>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div id="listView" class="list-view">
                        <table>
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Họ Tên</th>
                                    <th>Email</th>
                                    <th>Tên Cơ Sở</th>
                                    <th>Loại Hình</th>
                                    <th>Trạng Thái</th>
                                    <th>Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${pendingOwners}" varStatus="loop">
                                    <tr>
                                        <td>${loop.count}</td>
                                        <td>${user.fullName}</td>
                                        <td>${user.email}</td>
                                        <td>${user.business.name}</td>  <!-- Dùng user.business từ JOIN -->
                                        <td>${user.business.type}</td>  <!-- Dùng user.business từ JOIN -->
                                        <td>${user.status}</td>
                                        <td><a href="${pageContext.request.contextPath}/approve-application?action=detail&userId=${user.userId}" class="btn btn-approve">Xem chi tiết</a></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Hiển thị thông báo thành công hoặc lỗi nếu có -->
            <c:if test="${not empty success}">
                <div style="color: green; margin-top: 10px;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="color: red; margin-top: 10px;">${error}</div>
            </c:if>
        </main>
    </div>

    <script>
        // Toggle view functions (giữ nếu cần, nhưng back button giờ reload)
        const listView = document.getElementById('listView');
        const detailView = document.getElementById('detailView');

        function showDetailView() {
            if (listView) listView.style.display = 'none';
            if (detailView) detailView.style.display = 'block';
        }

        function showListView() {
            if (detailView) detailView.style.display = 'none';
            if (listView) listView.style.display = 'block';
        }

        // Tự động show detail view nếu có user (action=detail)
        <c:if test="${not empty user}">
            showDetailView();
        </c:if>
    </script>
</body>
</html>