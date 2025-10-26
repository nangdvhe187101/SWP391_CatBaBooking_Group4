<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%-- THÊM 2 THƯ VIỆN JSTL NÀY (BẮT BUỘC) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cập nhật Homestay</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/OwnerPage/owner-styles.css">
    
    <style>
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 5px; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="owner-container">
        <jsp:include page="Sidebar.jsp" />

        <div class="main-content">
            <div class="header">
                <h2>Cập nhật thông tin Homestay</h2>
            </div>
            
            <div class="content-body">
                <div class="form-container">
                    
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-error">${error}</div>
                    </c:if>

                    <%-- Form trỏ đến servlet "update-homestay" (map trong web.xml) --%>
                    <form action="update-homestay" method="POST">
                        
                        <%-- Gửi ID đi (Rất quan trọng) --%>
                        <input type="hidden" name="id" value="${b.getBusinessId()}">

                        <div class="input-group">
                            <label for="name">Tên homestay *</label>
                            <%-- Đọc giá trị từ biến "b" (thay vì "homestay") --%>
                            <input type="text" id="name" name="name" 
                                   value="${b.getName()}" placeholder="Nhập tên homestay" required>
                        </div>
                        <div class="input-group">
                            <label for="address">Địa chỉ *</label>
                            <input type="text" id="address" name="address" 
                                   value="${b.getAddress()}" placeholder="Nhập địa chỉ homestay" required>
                        </div>
                        <div class="input-group">
                            <label for="description">Mô tả</label>
                            <textarea id="description" name="description" rows="4" 
                                      placeholder="Mô tả chi tiết về homestay...">${b.getDescription()}</textarea>
                        </div>

                        <div class="input-row">
                            <div class="input-group">
                                <label for="pricePerNight">Giá mỗi đêm (VNĐ) *</label>
                                <input type="number" id="pricePerNight" name="pricePerNight" 
                                       value="${b.getPricePerNight()}" placeholder="500000" min="0" required>
                            </div>
                            <div class="input-group">
                                <label for="area_id">Khu vực *</label>
                                <select id="area_id" name="area_id" required>
                                    <option value="">-- Chọn khu vực --</option>
                                    <%-- Dùng JSTL để lặp qua "listA" --%>
                                    <c:forEach var="a" items="${listA}">
                                        <option value="${a.getAreaId()}" 
                                                ${a.getAreaId() == b.getArea().getAreaId() ? 'selected' : ''}>
                                            <c:out value="${a.getName()}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="input-row">
                            <div class="input-group">
                                <label for="capacity">Sức chứa (người)</label>
                                <input type="number" id="capacity" name="capacity" 
                                       value="${b.getCapacity()}" placeholder="4" min="1">
                            </div>
                            <div class="input-group">
                                <label for="numBedrooms">Số phòng ngủ</label>
                                <input type="number" id="numBedrooms" name="numBedrooms" 
                                       value="${b.getNumBedrooms()}" placeholder="2" min="0">
                            </div>
                        </div>
                        
                        <div class="button-group">
                            <button type="submit" class="btn btn-primary">Cập nhật Homestay</button>
                            <a href="manage-homestay" class="btn btn-secondary">Hủy</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>