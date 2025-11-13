<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin - Quản lí Feedback</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/AdminPage/admin-style.css">
    <style>
        .feedback-wrapper { padding: 24px; }
        .feedback-table { width: 100%; border-collapse: collapse; background: #fff; border: 1px solid #e5e7eb; }
        .feedback-table th, .feedback-table td { padding: 12px 16px; border-bottom: 1px solid #e5e7eb; text-align: left; font-size: 14px; color: #1f2937; }
        .feedback-table th { background: #f8fafc; text-transform: uppercase; font-size: 12px; color: #475569; }
        .feedback-table tbody tr:nth-child(even) { background: #f8fafc; }
        .actions form { display: inline-block; margin-right: 6px; }
        .btn { border: none; padding: 7px 12px; border-radius: 4px; font-size: 13px; cursor: pointer; }
        .btn-delete { background: #dc2626; color: #fff; }
        .message { margin: 16px 0; padding: 10px 14px; border-radius: 6px; font-size: 14px; }
        .message-success { background: #ecfdf5; border: 1px solid #a7f3d0; color: #047857; }
        .message-error { background: #fef2f2; border: 1px solid #fecaca; color: #b91c1c; }
        .empty-row { text-align: center; padding: 32px 0; color: #6b7280; }
    </style>
</head>
<body>
<jsp:include page="Sidebar.jsp" />
<div class="main-content">
    <div class="feedback-wrapper">
        <h1>Quản lí Feedback</h1>

        <c:if test="${not empty feedbackMessage}">
            <div class="message message-success">${feedbackMessage}</div>
        </c:if>
        <c:if test="${not empty feedbackError}">
            <div class="message message-error">${feedbackError}</div>
        </c:if>

        <!-- Form tìm kiếm và lọc -->
        <div style="background: #fff; padding: 20px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #e5e7eb;">
            <form method="get" action="${pageContext.request.contextPath}/admin/feedbacks" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; align-items: end;">
                <div>
                    <label style="display: block; margin-bottom: 6px; font-size: 13px; color: #475569; font-weight: 500;">Tìm kiếm</label>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Tên cơ sở, người dùng, nội dung..." 
                           style="width: 100%; padding: 8px 12px; border: 1px solid #e5e7eb; border-radius: 4px; font-size: 14px;">
                </div>
                <div>
                    <label style="display: block; margin-bottom: 6px; font-size: 13px; color: #475569; font-weight: 500;">Đánh giá</label>
                    <select name="rating" style="width: 100%; padding: 8px 12px; border: 1px solid #e5e7eb; border-radius: 4px; font-size: 14px;">
                        <option value="">Tất cả</option>
                        <option value="5" ${ratingFilter eq '5' ? 'selected' : ''}>5 sao</option>
                        <option value="4" ${ratingFilter eq '4' ? 'selected' : ''}>4 sao</option>
                        <option value="3" ${ratingFilter eq '3' ? 'selected' : ''}>3 sao</option>
                        <option value="2" ${ratingFilter eq '2' ? 'selected' : ''}>2 sao</option>
                        <option value="1" ${ratingFilter eq '1' ? 'selected' : ''}>1 sao</option>
                    </select>
                </div>
                <div>
                    <label style="display: block; margin-bottom: 6px; font-size: 13px; color: #475569; font-weight: 500;">Sắp xếp</label>
                    <select name="sort" style="width: 100%; padding: 8px 12px; border: 1px solid #e5e7eb; border-radius: 4px; font-size: 14px;">
                        <option value="">Mới nhất</option>
                        <option value="rating_desc" ${sort eq 'rating_desc' ? 'selected' : ''}>Đánh giá cao → thấp</option>
                        <option value="rating_asc" ${sort eq 'rating_asc' ? 'selected' : ''}>Đánh giá thấp → cao</option>
                    </select>
                </div>
                <div>
                    <button type="submit" style="width: 100%; padding: 8px 16px; background: #3b82f6; color: #fff; border: none; border-radius: 4px; font-size: 14px; font-weight: 500; cursor: pointer;">Lọc</button>
                </div>
            </form>
        </div>

        <table class="feedback-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Người dùng</th>
                <th>Cơ sở</th>
                <th>Loại hình</th>
                <th>Nội dung</th>
                <th>Đánh giá</th>
                <th>Ngày gửi</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="review" items="${reviews}" varStatus="loop">
                <tr>
                    <td>${(currentPage - 1) * 10 + loop.index + 1}</td>
                    <td>${review.user.fullName}</td>
                    <td>
                        <c:choose>
                            <c:when test="${review.business ne null}">${review.business.name}</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${review.business ne null}">
                                <c:choose>
                                    <c:when test="${review.business.type eq 'homestay'}">Homestay</c:when>
                                    <c:when test="${review.business.type eq 'restaurant'}">Nhà hàng</c:when>
                                    <c:otherwise>${review.business.type}</c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">${review.comment}</td>
                    <td>${review.rating} sao</td>
                    <td>${review.formattedCreatedDate}</td>
                    <td class="actions">
                        <form action="${pageContext.request.contextPath}/admin/feedbacks" method="post"
                              onsubmit="return confirm('Bạn có chắc muốn xóa phản hồi này?');">
                            <input type="hidden" name="reviewId" value="${review.reviewId}">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="keyword" value="${keyword}">
                            <input type="hidden" name="rating" value="${ratingFilter}">
                            <input type="hidden" name="sort" value="${sort}">
                            <input type="hidden" name="page" value="${currentPage}">
                            <button type="submit" class="btn btn-delete">Xóa</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty reviews}">
                <tr>
                    <td colspan="8" class="empty-row">Chưa có phản hồi.</td>
                </tr>
            </c:if>
            </tbody>
        </table>

        <!-- Phân trang -->
        <c:if test="${totalPages > 1}">
            <div style="display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 24px;">
                <c:if test="${currentPage > 1}">
                    <c:url var="prevUrl" value="/admin/feedbacks">
                        <c:param name="page" value="${currentPage - 1}"/>
                        <c:param name="keyword" value="${keyword}"/>
                        <c:param name="rating" value="${ratingFilter}"/>
                        <c:param name="sort" value="${sort}"/>
                    </c:url>
                    <a href="${prevUrl}" style="padding: 8px 12px; border: 1px solid #e5e7eb; border-radius: 4px; text-decoration: none; color: #334155; font-size: 14px;">« Trước</a>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:choose>
                        <c:when test="${i eq currentPage}">
                            <span style="padding: 8px 12px; background: #3b82f6; color: #fff; border-radius: 4px; font-size: 14px;">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <c:url var="pageUrl" value="/admin/feedbacks">
                                <c:param name="page" value="${i}"/>
                                <c:param name="keyword" value="${keyword}"/>
                                <c:param name="rating" value="${ratingFilter}"/>
                                <c:param name="sort" value="${sort}"/>
                            </c:url>
                            <a href="${pageUrl}" style="padding: 8px 12px; border: 1px solid #e5e7eb; border-radius: 4px; text-decoration: none; color: #334155; font-size: 14px;">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages}">
                    <c:url var="nextUrl" value="/admin/feedbacks">
                        <c:param name="page" value="${currentPage + 1}"/>
                        <c:param name="keyword" value="${keyword}"/>
                        <c:param name="rating" value="${ratingFilter}"/>
                        <c:param name="sort" value="${sort}"/>
                    </c:url>
                    <a href="${nextUrl}" style="padding: 8px 12px; border: 1px solid #e5e7eb; border-radius: 4px; text-decoration: none; color: #334155; font-size: 14px;">Sau »</a>
                </c:if>
            </div>
        </c:if>

        <div style="padding: 16px; background: #f8fafc; border-top: 1px solid #e5e7eb; color: #64748b; font-size: 14px; margin-top: 20px; border-radius: 0 0 8px 8px;">
            Tổng số: <strong>${totalFeedback}</strong> phản hồi
        </div>
    </div>
</div>
</body>
</html>


