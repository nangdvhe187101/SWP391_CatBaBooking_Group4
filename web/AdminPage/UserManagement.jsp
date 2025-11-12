<%-- 
    Document   : UserManagement
    Created on : Oct 6, 2025, 9:10:16 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin - Quản Lý Người Dùng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/AdminPage/admin-style.css">
        <script src="${pageContext.request.contextPath}/JS/pagger.js" type="text/javascript"></script>
        <style>
            .btn-back {
                background-color: #d9d9d9;
                color: #333;
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
            }

            .btn-back:hover {
                background-color: #bfbfbf;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/AdminPage/Sidebar.jsp" /> 
        <div class="main-content">
            <main>
                <c:if test="${param.success == 'toggled' || param.success == 'updated'}">
                    <div class="success-msg">Cập nhật trạng thái thành công!</div>
                </c:if>
                <c:if test="${param.success == 'error'}">
                    <div class="error-msg">Có lỗi xảy ra khi cập nhật!</div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty user}">
                        <div id="detailView" class="detail-view" style="display: block;">
                            <h3>THÔNG TIN CHI TIẾT NGƯỜI DÙNG</h3>
                            <div class="detail-content">
                                <div class="detail-column">
                                    <h4>THÔNG TIN CÁ NHÂN</h4>
                                    <div class="detail-item"><strong>Họ và tên:</strong> ${user.fullName}</div>
                                    <div class="detail-item"><strong>Email:</strong> ${user.email}</div>
                                    <div class="detail-item"><strong>Số điện thoại:</strong> ${user.phone}</div>
                                    <div class="detail-item"><strong>Số CCCD:</strong> ${user.citizenId}</div>
                                    <div class="detail-item"><strong>Địa chỉ cá nhân:</strong> ${user.personalAddress}</div>
                                    <div class="detail-item"><strong>Quyền:</strong> ${user.role.roleName}</div>
                                    <div class="detail-item"><strong>Trạng thái:</strong> 
                                        <c:choose>
                                            <c:when test="${user.status == 'active'}"><span class="status-active">Hoạt động</span></c:when>
                                            <c:when test="${user.status == 'pending'}"><span class="status-pending">Chờ duyệt</span></c:when>
                                            <c:otherwise><span class="status-rejected">Không hoạt động</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <c:if test="${(user.role.roleId == 2 || user.role.roleId == 4) && not empty user.business}">
                                    <div class="detail-column">
                                        <h4>THÔNG TIN CƠ SỞ KINH DOANH</h4>
                                        <div class="detail-item"><strong>Tên cơ sở:</strong> ${user.business.name}</div>
                                        <div class="detail-item"><strong>Loại hình:</strong> ${user.business.type}</div>
                                        <div class="detail-item"><strong>Địa chỉ kinh doanh:</strong> ${user.business.address}</div>
                                        <div class="detail-item"><strong>Mô tả:</strong> ${user.business.description}</div>
                                        <div class="detail-item"><strong>Thời gian:</strong> ${user.business.openingHour} - ${user.business.closingHour}</div>
                                        <div class="detail-item"><strong>Trạng thái kinh doanh:</strong> ${user.business.status}</div>
                                    </div>
                                </c:if>
                            </div>
                            <div style="text-align: center;">
                                <a href="${pageContext.request.contextPath}/user-management" class="btn-back">↩️ Quay lại danh sách</a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div id="listView" class="list-view" style="display: block;">
                            <div class="search-container">
                                <form method="get" action="${pageContext.request.contextPath}/user-management">
                                    <input type="text" name="keyword" placeholder="Tìm kiếm" value="${keywordFilter}">
                                    <select name="role">
                                        <option value="">Tất cả quyền</option>
                                        <option value="1" ${roleFilter == '1' ? 'selected' : ''}>Customer</option>
                                        <option value="2" ${roleFilter == '2' ? 'selected' : ''}>Owner Homestay</option>
                                        <option value="4" ${roleFilter == '4' ? 'selected' : ''}>Owner Restaurant</option>
                                    </select>
                                    <select name="status">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Hoạt động</option>
                                        <option value="rejected" ${statusFilter == 'rejected' ? 'selected' : ''}>Không hoạt động</option>
                                    </select>
                                    <button type="submit">Tìm kiếm</button>
                                </form>
                            </div>

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
                                    <c:forEach var="user" items="${users}" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td>
                                            <td>${user.fullName}</td>
                                            <td>${user.email}</td>
                                            <td>${user.role.roleName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.status == 'active'}"><span class="status-active">Hoạt động</span></c:when>
                                                    <c:when test="${user.status == 'pending'}"><span class="status-pending">Chờ duyệt</span></c:when>
                                                    <c:otherwise><span class="status-rejected">Không hoạt động</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <c:url var="detailUrl" value="/user-management/${user.userId}">
                                                        <c:param name="role" value="${roleFilter}"/>
                                                        <c:param name="status" value="${statusFilter}"/>
                                                        <c:param name="keyword" value="${keywordFilter}"/>
                                                    </c:url>
                                                    <a class="btn btn-view" href="${detailUrl}">Chi tiết</a>
                                                    <form class="action-form" method="post" action="${pageContext.request.contextPath}/user-management" style="display: inline;">
                                                        <input type="hidden" name="action" value="toggleStatus">
                                                        <input type="hidden" name="userId" value="${user.userId}">
                                                        <input type="hidden" name="role" value="${roleFilter}">
                                                        <input type="hidden" name="status" value="${statusFilter}">
                                                        <input type="hidden" name="keyword" value="${keywordFilter}">
                                                        <input type="hidden" name="page" value="${pageIndex}"> 
                                                        <div class="toggle-switch">
                                                            <c:set var="isActive" value="${user.status == 'active' ? true : false}" />
                                                            <input type="checkbox" id="toggle${user.userId}" ${isActive ? 'checked' : ''} onchange="toggleConfirm(this);">
                                                            <label for="toggle${user.userId}"></label>
                                                        </div>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty users}">
                                        <tr>
                                            <td colspan="6" style="text-align: center; padding: 20px;">Không tìm thấy người dùng nào.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                            <div id="botpagger" class="pagger"></div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
        <script>
            function toggleConfirm(checkbox) {
                var newStatus = checkbox.checked ? 'active' : 'rejected';
                if (confirm('Xác nhận thay đổi trạng thái sang ' + newStatus + '?')) {
                    checkbox.form.submit();
                } else {
                    checkbox.checked = !checkbox.checked;
                }
            }
            (function () {
                const roleFilter = '${roleFilter}';
                const statusFilter = '${statusFilter}';
                const keywordFilter = '${keywordFilter}';
                let baseUrl = 'user-management?';
                if (roleFilter)
                    baseUrl += 'role=' + encodeURIComponent(roleFilter) + '&';
                if (statusFilter)
                    baseUrl += 'status=' + encodeURIComponent(statusFilter) + '&';
                if (keywordFilter)
                    baseUrl += 'keyword=' + encodeURIComponent(keywordFilter) + '&';
                const pageIndex = '${pageIndex}';
                const totalPage = '${totalPage}';
                pagger('toppagger', pageIndex, totalPage, 2, baseUrl);
                pagger('botpagger', pageIndex, totalPage, 2, baseUrl);
            })();
        </script>
    </body>
</html>