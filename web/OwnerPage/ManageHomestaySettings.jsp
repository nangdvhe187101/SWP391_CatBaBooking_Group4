<%-- 
    Document   : ManageHomestaySettings
    Created on : Nov 13, 2025
    Author     : jackd
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Thông tin Homestay</title>

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
                <span class="user">O ${currentUser.fullName}</span>
            </div>
        </header>
        
        <div class="main-content">
            <main class="content">
                <div class="container-fluid py-3">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h2 class="mb-0">Cài đặt thông tin Homestay</h2>
                        </div>
                    </div>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty message}">
                        <div class="alert alert-success" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ${message}
                        </div>
                    </c:if>

                    <fmt:formatNumber value="${business.pricePerNight}" pattern="#" var="dbPrice" />

                    <c:set var="vName"        value="${not empty param.name ? param.name : business.name}" />
                    <c:set var="vAddress"     value="${not empty param.address ? param.address : business.address}" />
                    <c:set var="vDescription" value="${not empty param.description ? param.description : business.description}" />
                    <c:set var="vImage"       value="${not empty param.image ? param.image : business.image}" />
                    <c:set var="vAreaId"      value="${not empty param.areaId ? param.areaId : (business.area != null ? business.area.areaId : '')}" />
                    
                    <c:set var="vCheckIn"     value="${not empty param.openingHour ? param.openingHour : business.openingHour}" />
                    <c:set var="vCheckOut"    value="${not empty param.closingHour ? param.closingHour : business.closingHour}" />

                    <%-- Logic giá tiền: Lấy param nếu có, không thì lấy dbPrice đã format --%>
                    <c:set var="vPrice"       value="${not empty param.pricePerNight ? param.pricePerNight : dbPrice}" />

                    <div class="card">
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/homestay-settings" method="post">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Tên Homestay *</label>
                                            <input class="form-control" type="text" name="name" value="${vName}" required />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Địa chỉ chi tiết *</label>
                                            <input class="form-control" type="text" name="address" value="${vAddress}" required />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Mô tả giới thiệu</label>
                                            <textarea class="form-control" name="description" rows="6">${vDescription}</textarea>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label fw-bold text-success">Giá trung bình / đêm</label>
                                            <div class="input-group">
                                                <input class="form-control" type="text" name="pricePerNight" value="${vPrice}" placeholder="Ví dụ: 500000" />
                                                <span class="input-group-text">VNĐ</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Ảnh đại diện (Link URL)</label>
                                            <input class="form-control" type="text" name="image" value="${vImage}" />
                                            <c:if test="${not empty vImage}">
                                                <div style="margin-top:10px;">
                                                    <img class="preview img-fluid rounded shadow-sm" src="${vImage}" alt="Preview" style="max-height: 200px; object-fit: cover; width: 100%;" />
                                                </div>
                                            </c:if>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Khu vực</label>
                                            <select class="form-select" name="areaId">
                                                <option value="">-- Chọn khu vực --</option>
                                                <c:forEach var="area" items="${allAreas}">
                                                    <option value="${area.areaId}" ${area.areaId == vAreaId ? 'selected' : ''}>
                                                        ${area.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label fw-bold">Giờ Nhận phòng (Check-in)</label>
                                                <input class="form-control" type="time" name="openingHour" value="${vCheckIn}" />
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label fw-bold">Giờ Trả phòng (Check-out)</label>
                                                <input class="form-control" type="time" name="closingHour" value="${vCheckOut}" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mt-4 text-end">
                                    <button class="btn btn-primary px-4 py-2" type="submit">
                                        <i class="bi bi-save me-2"></i>Lưu thay đổi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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