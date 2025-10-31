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
                font-size: 14px;
                transition: background-color 0.2s;
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

            .btn-confirm-reject {
                background-color: #ff4d4f;
                color: white;
            }
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

            .reject-section {
                display: none;
                text-align: center;
                margin-top: 20px;
                padding: 20px;
                background-color: #fff5f5;
                border: 1px solid #ffccc7;
                border-radius: 4px;
            }

            .reject-section label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #ff4d4f;
            }

            .reject-section textarea {
                width: 100%;
                max-width: 400px;
                min-height: 80px;
                padding: 8px;
                margin-bottom: 16px;
                border: 1px solid #d9d9d9;
                border-radius: 4px;
                font-family: inherit;
                resize: vertical;
            }

            .reject-section textarea:focus {
                border-color: #ff4d4f;
                outline: none;
            }

            .btn-group {
                display: flex;
                justify-content: center;
                gap: 8px;
                align-items: center;
                flex-wrap: wrap;
            }

            @media (max-width: 480px) {
                .btn-group {
                    flex-direction: column;
                    width: 100%;
                }

                .btn-group .btn {
                    width: 100%;
                    max-width: 200px;
                }
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
                            <div class="actions" id="defaultActions">
                                <div class="btn-group">
                                    <a href="${pageContext.request.contextPath}/approve-application" class="btn btn-back">↩️ Quay lại danh sách</a>
                                    <form action="${pageContext.request.contextPath}/approve-application" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="userId" value="${user.userId}">
                                        <button type="submit" class="btn btn-approve">✅ Phê duyệt</button>
                                    </form>
                                    <button type="button" class="btn btn-reject" id="rejectBtn">❌ Từ chối</button>
                                </div>
                            </div>
                            <div class="reject-section" id="rejectSection">
                                <label for="reasonText">Lý do từ chối (bắt buộc):</label>
                                <form action="${pageContext.request.contextPath}/approve-application" method="post" id="rejectForm">
                                    <input type="hidden" name="action" value="reject">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                    <textarea name="reason" id="reasonText" placeholder="Vui lòng nhập lý do từ chối chi tiết..." required></textarea>
                                    <div class="btn-group">
                                        <a href="javascript:void(0)" class="btn btn-back" id="backBtnReject">↩️ Quay lại</a>
                                        <button type="submit" class="btn btn-confirm-reject">Xác nhận từ chối</button>
                                    </div>
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
                                            <td>${user.business != null ? user.business.name : 'Chưa có'}</td>
                                            <td>${user.business != null ? user.business.type : 'Chưa có'}</td>  
                                            <td>${user.status}</td>
                                            <td><a href="${pageContext.request.contextPath}/approve-application?action=detail&userId=${user.userId}" class="btn btn-approve">Xem chi tiết</a></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty pendingOwners}">
                                        <tr>
                                            <td colspan="7" style="text-align: center; padding: 20px;">Không tìm thấy người dùng nào.</td>
                                        </tr>
                                    </c:if>  
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
                if (listView)
                    listView.style.display = 'none';
                if (detailView)
                    detailView.style.display = 'block';
            }

            function showListView() {
                if (detailView)
                    detailView.style.display = 'none';
                if (listView)
                    listView.style.display = 'block';
            }

            // Tự động show detail view nếu có user (action=detail)
            <c:if test="${not empty user}">
            showDetailView();
            </c:if>
            // Xử lý nút từ chối
            document.addEventListener('DOMContentLoaded', function () {
                const rejectBtn = document.getElementById('rejectBtn');
                const defaultActions = document.getElementById('defaultActions');
                const rejectSection = document.getElementById('rejectSection');
                const reasonText = document.getElementById('reasonText');
                const backBtnReject = document.getElementById('backBtnReject');

                if (rejectBtn) {
                    rejectBtn.addEventListener('click', function () {
                        // Ẩn phần phê duyệt và từ chối
                        defaultActions.style.display = 'none';
                        // Hiển thị phần từ chối
                        rejectSection.style.display = 'block';
                        // Focus vào textarea
                        if (reasonText)
                            reasonText.focus();
                    });
                }

                if (backBtnReject) {
                    backBtnReject.addEventListener('click', function (e) {
                        e.preventDefault();
                        rejectSection.style.display = 'none';
                        defaultActions.style.display = 'block';
                        if (reasonText)
                            reasonText.value = '';
                    });
                }
            });
        </script>
    </body>
</html>