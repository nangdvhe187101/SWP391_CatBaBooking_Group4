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
            .page-header { margin-bottom:20px; }
            .page-header h1 { margin:0; font-size:26px; color:#0f172a; }
            .page-header p { margin-top:6px; color:#64748b; }
            .card { background:#fff; border-radius:12px; border:1px solid #e2e8f0; box-shadow:0 8px 24px rgba(15,23,42,0.06); padding:24px; }
            .table { width:100%; border-collapse:collapse; }
            .table thead { background:#f8fafc; }
            .table th, .table td { padding:14px 20px; border-bottom:1px solid #e2e8f0; text-align:left; font-size:14px; color:#334155; }
            .table tbody tr:last-child td { border-bottom:none; }
            .detail-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(260px,1fr)); gap:20px; margin-bottom:24px; }
            .detail-section { background:#f8fafc; border-radius:10px; padding:18px; border:1px solid #e2e8f0; }
            .detail-section h3 { margin:0 0 12px; color:#0f172a; font-size:16px; text-transform:uppercase; letter-spacing:.05em; }
            .detail-item { margin-bottom:10px; color:#475569; font-size:14px; }
            .detail-item strong { color:#0f172a; }
            .actions { display:flex; gap:10px; flex-wrap:wrap; }
            .btn { border:none; padding:10px 18px; border-radius:6px; font-size:14px; cursor:pointer; font-weight:600; }
            .btn-back { background:#e2e8f0; color:#1f2937; }
            .btn-approve { background:#22c55e; color:#fff; }
            .btn-reject { background:#ef4444; color:#fff; }
            .reject-card { margin-top:20px; border:1px solid #fecaca; background:#fef2f2; border-radius:10px; padding:20px; }
            .reject-card label { font-weight:600; color:#b91c1c; display:block; margin-bottom:8px; }
            .reject-card textarea { width:100%; min-height:120px; padding:12px; border:1px solid #fca5a5; border-radius:8px; font-family:inherit; resize:vertical; }
            .empty-row { text-align:center; padding:32px 0; color:#94a3b8; font-size:14px; }
        </style>
    </head>
    <body>
        <jsp:include page="Sidebar.jsp" />
        <div class="main-content">
            <div class="page-header">
                <h1>Duyệt yêu cầu đăng ký</h1>
                <p>Quản lý và xử lý các yêu cầu đăng ký chủ cơ sở mới.</p>
            </div>
            <main>
                <c:choose>
                    <c:when test="${not empty user}">
                        <div class="card">
                            <div class="detail-grid">
                                <div class="detail-section">
                                    <h3>Thông tin cá nhân</h3>
                                    <div class="detail-item"><strong>Họ và tên:</strong> ${user.fullName}</div>
                                    <div class="detail-item"><strong>Email:</strong> ${user.email}</div>
                                    <div class="detail-item"><strong>Số điện thoại:</strong> ${user.phone}</div>
                                    <div class="detail-item"><strong>Số CCCD:</strong> ${user.citizenId}</div>
                                    <div class="detail-item"><strong>Địa chỉ:</strong> ${user.personalAddress}</div>
                                </div>
                                <div class="detail-section">
                                    <h3>Thông tin cơ sở</h3>
                                    <div class="detail-item"><strong>Tên cơ sở:</strong> ${business.name}</div>
                                    <div class="detail-item"><strong>Loại hình:</strong> ${business.type}</div>
                                    <div class="detail-item"><strong>Địa chỉ:</strong> ${business.address}</div>
                                    <div class="detail-item"><strong>Mô tả:</strong> ${business.description}</div>
                                </div>
                            </div>
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/approve-application" class="btn btn-back">Quay lại danh sách</a>
                                <form action="${pageContext.request.contextPath}/approve-application" method="post">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                    <button type="submit" class="btn btn-approve">Phê duyệt</button>
                                </form>
                                <button type="button" class="btn btn-reject" id="rejectBtn">Từ chối</button>
                            </div>
                            <div class="reject-card" id="rejectSection" style="display:none;">
                                <label for="reasonText">Lý do từ chối (bắt buộc)</label>
                                <form action="${pageContext.request.contextPath}/approve-application" method="post" id="rejectForm">
                                    <input type="hidden" name="action" value="reject">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                    <textarea id="reasonText" name="reason" placeholder="Nhập lý do từ chối chi tiết..." required></textarea>
                                    <div class="actions" style="margin-top:16px;">
                                        <button type="button" class="btn btn-back" id="backBtnReject">Hủy</button>
                                        <button type="submit" class="btn btn-reject">Xác nhận từ chối</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>STT</th>
                                        <th>Họ tên</th>
                                        <th>Email</th>
                                        <th>Tên cơ sở</th>
                                        <th>Loại hình</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${pendingOwners}" varStatus="loop">
                                        <tr>
                                            <td>${loop.count}</td>
                                            <td>${item.fullName}</td>
                                            <td>${item.email}</td>
                                            <td>${item.business != null ? item.business.name : 'Chưa có'}</td>
                                            <td>${item.business != null ? item.business.type : 'Chưa có'}</td>
                                            <td>${item.status}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/approve-application?action=detail&userId=${item.userId}" class="btn btn-back">Xem chi tiết</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty pendingOwners}">
                                        <tr>
                                            <td colspan="7" class="empty-row">Không có yêu cầu đang chờ.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:if test="${not empty success}">
                    <div style="color: #16a34a; margin-top: 16px; font-weight:600;">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div style="color: #dc2626; margin-top: 16px; font-weight:600;">${error}</div>
                </c:if>
            </main>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const rejectBtn = document.getElementById('rejectBtn');
                const rejectSection = document.getElementById('rejectSection');
                const backBtnReject = document.getElementById('backBtnReject');
                const reasonText = document.getElementById('reasonText');

                if (rejectBtn) {
                    rejectBtn.addEventListener('click', function () {
                        rejectSection.style.display = 'block';
                        rejectBtn.style.display = 'none';
                        if (reasonText) {
                            reasonText.focus();
                        }
                    });
                }

                if (backBtnReject) {
                    backBtnReject.addEventListener('click', function () {
                        rejectSection.style.display = 'none';
                        if (rejectBtn) {
                            rejectBtn.style.display = 'inline-flex';
                        }
                        if (reasonText) {
                            reasonText.value = '';
                        }
                    });
                }
            });
        </script>
    </body>
</html>