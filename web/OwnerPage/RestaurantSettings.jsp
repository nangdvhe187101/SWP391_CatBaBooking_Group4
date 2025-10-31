<%-- 
    Document   : RestaurantSettings
    Created on : Oct 22, 2025, 12:12:27 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Thông tin nhà hàng</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css" />
    </head>
    <body>
        <%@ include file="Sidebar.jsp" %>
        <div id="sidebar-overlay" class="hidden"></div>
        <header class="header">
            <button id="sidebar-toggle">☰</button>
            <h1>Xin chào, Owner!</h1>
            <div class="header-actions">
                <span class="notification">🔔</span>
                <span class="user">O Owner Name</span>
            </div>
        </header>
        <div class="main-content">
            <main class="content">
                <div class="container-fluid py-3">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h2 class="mb-0">Thông tin nhà hàng</h2>
                        </div>
                    </div>
                    <c:if test="${not empty errors}">
                        <div class="alert alert-danger" role="alert">
                            <strong>Đã xảy ra lỗi:</strong>
                            <ul class="mb-0">
                                <c:forEach var="err" items="${errors}">
                                    <li>${err}</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <p class="alert alert-success">${message}</p>
                    </c:if>
                    <c:set var="vName"        value="${empty param.name ? business.name : param.name}" />
                    <c:set var="vAddress"     value="${empty param.address ? business.address : param.address}" />
                    <c:set var="vDescription" value="${empty param.description ? business.description : param.description}" />
                    <c:set var="vImage"       value="${empty param.image ? business.image : param.image}" />
                    <c:set var="vAreaId"      value="${empty param.areaId ? (business.area != null ? business.area.areaId : '') : param.areaId}" />

                    <div class="card">
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/restaurant-settings" method="post">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Tên nhà hàng *</label>
                                            <input class="form-control" type="text" name="name" value="${vName}" required />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Địa chỉ *</label>
                                            <input class="form-control" type="text" name="address" value="${vAddress}" required />
                                        </div>
                                        <div class="mb-3">
                                            <label 
                                                class="form-label">Mô tả</label>
                                            <textarea class="form-control" name="description" rows="6">${vDescription}</textarea>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Ảnh đại diện (URL)</label>
                                            <input class="form-control" type="text" name="image" value="${vImage}" />
                                            <c:if test="${not empty vImage}">
                                                <div style="margin-top:10px;">

                                                    <img class="preview img-fluid rounded" src="${vImage}" alt="Preview" style="max-height: 150px;" />
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Khu vực địa điểm gần Nhà Hàng</label>
                                            <select class="form-select" name="areaId">
                                                <option value="">-- Chọn khu vực --</option>
                                                <c:forEach var="area" items="${allAreas}">
                                                    <option value="${area.areaId}" ${area.areaId == vAreaId ? 'selected' : ''}>
                                                        ${area.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="mt-3">
                                    <button class="btn btn-primary" type="submit">Lưu thay đổi</button>
                                </div>
                            </form>
                        </div>

                    </div>

                </div>
            </main>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
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
            });
        </script>
    </body>
</html>