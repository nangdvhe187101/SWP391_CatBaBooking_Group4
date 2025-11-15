<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <h2>🚢 Cát Bà Booking</h2>
        <h3>Owner Dashboard</h3>
    </div>
    <nav class="sidebar-nav">
        <ul>
            <%-- ✅ CHỈ HIỂN THỊ MENU DỰA TRÊN PERMISSIONS --%>
            <c:if test="${not empty sessionScope.permittedFeatures}">
                <%-- Tổng quan --%>
                <c:set var="hasDashboard" value="false" />
                <c:forEach var="feature" items="${sessionScope.permittedFeatures}">
                    <c:if test="${feature.url == '/owner-dashboard'}">
                        <c:set var="hasDashboard" value="true" />
                    </c:if>
                </c:forEach>
                <c:if test="${hasDashboard}">
                    <li><a href="${pageContext.request.contextPath}/owner-dashboard" class="nav-link">🏠 Tổng quan</a></li>
                    </c:if>

                <c:set var="hasProfile" value="false" />
                <c:forEach var="feature" items="${sessionScope.permittedFeatures}">
                    <c:if test="${feature.url == '/owner/profile'}">
                        <c:set var="hasProfile" value="true" />
                    </c:if>
                </c:forEach>
                <c:if test="${hasProfile}">
                    <li><a href="${pageContext.request.contextPath}/owner/profile" class="nav-link">🏠 Thông tin cá nhân</a></li>
                    </c:if>

                <%-- Homestay Settings --%>
                <c:set var="hasHomestaySettings" value="false" />
                <c:forEach var="feature" items="${sessionScope.permittedFeatures}">
                    <c:if test="${feature.url == '/homestay-settings'}">
                        <c:set var="hasHomestaySettings" value="true" />
                    </c:if>
                </c:forEach>
                <c:if test="${hasHomestaySettings}">
                    <li><a href="${pageContext.request.contextPath}/homestay-settings" class="nav-link">🏠 Thông tin Homestay</a></li>
                    </c:if>

                <c:set var="hasRestaurantSettings" value="false" />
                <c:forEach var="feature" items="${sessionScope.permittedFeatures}">
                    <c:if test="${feature.url == '/restaurant-profile'}">
                        <c:set var="hasRestaurantSettings" value="true" />
                    </c:if>
                </c:forEach>
                <c:if test="${hasRestaurantSettings}">
                    <li><a href="${pageContext.request.contextPath}/restaurant-profile" class="nav-link">🏠 Thông tin Restaurant</a></li>
                    </c:if>
                    <%-- Manage Homestay Rooms --%>
                    <c:set var="hasManageRooms" value="false" />
                    <c:forEach var="feature" items="${sessionScope.permittedFeatures}">
                        <c:if test="${feature.url == '/manage-homestay-rooms'}">
                            <c:set var="hasManageRooms" value="true" />
                        </c:if>
                    </c:forEach>
                    <c:if test="${hasManageRooms}">
                    <li><a href="${pageContext.request.contextPath}/manage-homestay-rooms" class="nav-link">🛏️ Quản lý Phòng</a></li>
                    </c:if>

                <%-- Homestay Bookings --%>
                <c:set var="hasHomestayBookings" value="false" />
                <c:forEach var="feature" items="${sessionScope.permittedFeatures}">
                    <c:if test="${feature.url == '/homestay-bookings'}">
                        <c:set var="hasHomestayBookings" value="true" />
                    </c:if>
                </c:forEach>
                <c:if test="${hasHomestayBookings}">
                    <li><a href="${pageContext.request.contextPath}/homestay-bookings" class="nav-link">📅 Lịch sử Đặt phòng</a></li>
                    </c:if>

                <%-- List Dishes --%>
                <c:set var="hasListDish" value="false" />
                <c:forEach var="feature" items="${sessionScope.permittedFeatures}">
                    <c:if test="${feature.url == '/list-dish'}">
                        <c:set var="hasListDish" value="true" />
                    </c:if>
                </c:forEach>
                <c:if test="${hasListDish}">
                    <li><a href="${pageContext.request.contextPath}/list-dish" class="nav-link">🍽️ Quản lý Món ăn</a></li>
                    </c:if>

                <%-- Owner Bookings (Restaurant) --%>
                <c:set var="hasOwnerBookings" value="false" />
                <c:forEach var="feature" items="${sessionScope.permittedFeatures}">
                    <c:if test="${feature.url == '/owner-bookings'}">
                        <c:set var="hasOwnerBookings" value="true" />
                    </c:if>
                </c:forEach>
                <c:if test="${hasOwnerBookings}">
                    <li><a href="${pageContext.request.contextPath}/owner-bookings" class="nav-link">📅 Lịch sử Đặt bàn</a></li>
                    </c:if>

                <c:set var="hasRestaurantTables" value="false" />
                <c:forEach var="feature" items="${sessionScope.permittedFeatures}">
                    <c:if test="${feature.url == '/restaurant-manage-tables'}">
                        <c:set var="hasRestaurantTables" value="true" />
                    </c:if>
                </c:forEach>
                <c:if test="${hasRestaurantTables}">
                    <li><a href="${pageContext.request.contextPath}/restaurant-manage-tables" class="nav-link">🍽️ Quản lý Bàn</a></li>
                    </c:if>


            </c:if>

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