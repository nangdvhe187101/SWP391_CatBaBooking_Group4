<%-- 
    Document   : Sidebar
    Created on : Oct 22, 2025, 11:07:45 AM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <h2>🐚 Cát Bà Booking</h2>
        <h3>Owner Dashboard</h3>
    </div>
    <nav class="sidebar-nav">
        <ul>            <li><a href="${pageContext.request.contextPath}/owner-dashboard" class="nav-link">🏠 Tổng quan</a></li>
            <li><a href="AddHomestay.jsp" class="nav-link">🏠 Thông tin Homestay</a></li>
            <li><a href="ManageHomestay.jsp" class="nav-link">🏠 Quản lý Homestay</a></li>
            <li><a href="${pageContext.request.contextPath}/manage-homestay-rooms" class="nav-link">🛏️ Quản lý Phòng</a></li>
            <li><a href="${pageContext.request.contextPath}/homestay-bookings" class="nav-link">📅 Lịch sử Đặt phòng</a></li>
            <li><a href="${pageContext.request.contextPath}/list-dish" class="nav-link">🍽️ Quản lý Món ăn</a></li>
            <li><a href="${pageContext.request.contextPath}/owner-bookings" class="nav-link">📅 Đặt bàn</a></li>
            <li><a href="${pageContext.request.contextPath}/restaurant-manage-tables" class="nav-link">🍽️ Quản lý Bàn</a></li>
            <li><a href="RestaurantTableAvailability.jsp" class="nav-link">🪑 Tình trạng bàn</a></li>
            <li><a href="${pageContext.request.contextPath}/homestay-settings" class="nav-link">🏠 Thông tin Homestay</a></li>
            <li><a href="${pageContext.request.contextPath}/restaurant-settings" class="nav-link">Thông tin cơ sở kinh doanh</a></li>
            <li><a href="Feedback.jsp" class="nav-link">💬 Phản hồi & Đánh giá</a></li>
            <li><a href="Reports.jsp" class="nav-link">📊 Báo cáo Doanh thu</a></li>
            <c:choose>
                <c:when test="${empty sessionScope.permittedFeatures}">
                    <li><a href="Dashboard.jsp" class="nav-link">🏠 Tổng quan</a></li>
                    <li><a href="AddHomestay.jsp" class="nav-link">🏠 Thông tin Homestay</a></li>
                    <li><a href="ManageHomestay.jsp" class="nav-link">🏠 Quản lý Homestay</a></li>
                    <li><a href="${pageContext.request.contextPath}/manage-homestay-rooms" class="nav-link">🛏️ Quản lý Phòng</a></li>
                    <li><a href="${pageContext.request.contextPath}/homestay-bookings" class="nav-link">📅 Lịch sử Đặt phòng</a></li>
                    <li><a href="${pageContext.request.contextPath}/list-dish" class="nav-link">🍽️ Quản lý Món ăn</a></li>
                    <li><a href="RestaurantBookings.jsp" class="nav-link">📅 Đặt bàn</a></li>
                    <li><a href="${pageContext.request.contextPath}/restaurant-manage-tables" class="nav-link">🍽️ Quản lý Bàn</a></li>
                    <li><a href="RestaurantTableAvailability.jsp" class="nav-link">🪑 Tình trạng bàn</a></li>
                    <li><a href="${pageContext.request.contextPath}//restaurant-profile" class="nav-link">Thông tin cơ sở kinh doanh</a></li>
                    <li><a href="Feedback.jsp" class="nav-link">💬 Phản hồi & Đánh giá</a></li>
                    <li><a href="Reports.jsp" class="nav-link">📊 Báo cáo Doanh thu</a></li>
                </c:when>
                <c:otherwise>
                    <c:forEach var="feature" items="${sessionScope.permittedFeatures}">
                        <c:if test="${empty dashboardRendered && feature.url == 'Dashboard.jsp'}">
                            <c:set var="dashboardRendered" value="true" />
                            <li><a href="Dashboard.jsp" class="nav-link">🏠 Tổng quan</a></li>
                        </c:if>
                        
                        <c:if test="${empty addHomestayRendered && feature.url == 'AddHomestay.jsp'}">
                            <c:set var="addHomestayRendered" value="true" />
                            <li><a href="AddHomestay.jsp" class="nav-link">🏠 Thông tin Homestay</a></li>
                        </c:if>
                        <c:if test="${empty manageHomestayRendered && feature.url == 'ManageHomestay.jsp'}">
                            <c:set var="manageHomestayRendered" value="true" />
                            <li><a href="ManageHomestay.jsp" class="nav-link">🏠 Quản lý Homestay</a></li>
                        </c:if>
                        
                        <c:if test="${empty manageRoomsRendered && feature.url == '/manage-homestay-rooms'}">
                            <c:set var="manageRoomsRendered" value="true" />
                            <li><a href="${pageContext.request.contextPath}/manage-homestay-rooms" class="nav-link">🛏️ Quản lý Phòng</a></li>
                        </c:if>
                            
                        <c:if test="${empty homestayBookingsRendered && feature.url == '/homestay-bookings'}">
                            <c:set var="homestayBookingsRendered" value="true" />
                            <li><a href="${pageContext.request.contextPath}/homestay-bookings" class="nav-link">📅 Lịch sử Đặt phòng</a></li>
                        </c:if>
                        
                        <c:if test="${empty listDishRendered && feature.url == '/list-dish'}">
                            <c:set var="listDishRendered" value="true" />
                            <li><a href="${pageContext.request.contextPath}/list-dish" class="nav-link">🍽️ Quản lý Món ăn</a></li>
                        </c:if>
                        
                        <c:if test="${empty restaurantBookingsRendered && feature.url == 'RestaurantBookings.jsp'}">
                            <c:set var="restaurantBookingsRendered" value="true" />
                            <li><a href="RestaurantBookings.jsp" class="nav-link">📅 Đặt bàn</a></li>
                        </c:if>
                        
                        <c:if test="${empty restaurantTablesRendered && feature.url == '/restaurant-manage-tables'}">
                            <c:set var="restaurantTablesRendered" value="true" />
                            <li><a href="${pageContext.request.contextPath}/restaurant-manage-tables" class="nav-link">🍽️ Quản lý Bàn</a></li>
                        </c:if>
                        
                        <c:if test="${empty tableAvailabilityRendered && feature.url == 'RestaurantTableAvailability.jsp'}">
                            <c:set var="tableAvailabilityRendered" value="true" />
                            <li><a href="RestaurantTableAvailability.jsp" class="nav-link">🪑 Tình trạng bàn</a></li>
                        </c:if>
                        
                        <c:if test="${empty restaurantSettingsRendered && feature.url == '/restaurant-profile'}">
                            <c:set var="restaurantSettingsRendered" value="true" />
                            <li><a href="${pageContext.request.contextPath}/restaurant-profile" class="nav-link">🏠 Thông tin Restaurant</a></li>
                        </c:if>
                        
                        <c:if test="${empty feedbackRendered && feature.url == 'Feedback.jsp'}">
                            <c:set var="feedbackRendered" value="true" />
                            <li><a href="Feedback.jsp" class="nav-link">💬 Phản hồi & Đánh giá</a></li>
                        </c:if>
                        
                        <c:if test="${empty reportsRendered && feature.url == 'Reports.jsp'}">
                            <c:set var="reportsRendered" value="true" />
                            <li><a href="Reports.jsp" class="nav-link">📊 Báo cáo Doanh thu</a></li>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            <li>
                <form action="${pageContext.request.contextPath}/Logout" method="POST" style="margin: 0;">
                    <button type="submit" class="nav-link" style="background: none; border: none; width: 100%; text-align: left;">
                       ➡️ Đăng xuất
                    </button>
                </form>
            </li>
        </ul>
    </nav>
</aside>