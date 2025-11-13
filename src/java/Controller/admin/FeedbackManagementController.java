package controller.admin;

import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import model.Reviews;
import model.Users;

@WebServlet(name = "FeedbackManagementController", urlPatterns = {"/admin/feedbacks"})
public class FeedbackManagementController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null || currentUser.getRole() == null || currentUser.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String keyword = request.getParameter("keyword");
        String ratingParam = request.getParameter("rating");
        String sort = request.getParameter("sort");
        String pageParam = request.getParameter("page");

        Integer ratingFilter = null;
        if (ratingParam != null && !ratingParam.isEmpty()) {
            try {
                ratingFilter = Integer.parseInt(ratingParam);
                if (ratingFilter < 1 || ratingFilter > 5) {
                    ratingFilter = null;
                }
            } catch (NumberFormatException ignored) {
                ratingFilter = null;
            }
        }

        int pageIndex = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                pageIndex = Math.max(1, Integer.parseInt(pageParam));
            } catch (NumberFormatException ignored) {
                pageIndex = 1;
            }
        }

        List<Reviews> reviews = reviewDAO.findReviews(keyword, ratingFilter, sort, pageIndex, PAGE_SIZE);
        int total = reviewDAO.countReviews(keyword, ratingFilter);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        request.setAttribute("reviews", reviews);
        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("ratingFilter", ratingFilter == null ? "" : String.valueOf(ratingFilter));
        request.setAttribute("sort", sort == null ? "" : sort);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", Math.max(totalPages, 1));
        request.setAttribute("totalFeedback", total);

        Object feedbackMessage = session != null ? session.getAttribute("feedbackMessage") : null;
        Object feedbackError = session != null ? session.getAttribute("feedbackError") : null;
        if (feedbackMessage != null) {
            request.setAttribute("feedbackMessage", feedbackMessage);
            session.removeAttribute("feedbackMessage");
        }
        if (feedbackError != null) {
            request.setAttribute("feedbackError", feedbackError);
            session.removeAttribute("feedbackError");
        }

        request.getRequestDispatcher("/AdminPage/FeedbackManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null || currentUser.getRole() == null || currentUser.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String reviewIdParam = request.getParameter("reviewId");
        String action = request.getParameter("action");
        boolean success = false;

        if (reviewIdParam != null) {
            try {
                int reviewId = Integer.parseInt(reviewIdParam);
                if ("approve".equalsIgnoreCase(action)) {
                    success = reviewDAO.updateReviewStatus(reviewId, "approved");
                    session.setAttribute(success ? "feedbackMessage" : "feedbackError",
                            success ? "Phản hồi đã được duyệt." : "Không thể duyệt phản hồi.");
                } else if ("delete".equalsIgnoreCase(action)) {
                    success = reviewDAO.deleteReviewById(reviewId);
                    session.setAttribute(success ? "feedbackMessage" : "feedbackError",
                            success ? "Đã xóa phản hồi khỏi hệ thống." : "Không thể xóa phản hồi.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("feedbackError", "Mã phản hồi không hợp lệ.");
            }
        }

        String keyword = request.getParameter("keyword");
        String rating = request.getParameter("rating");
        String sort = request.getParameter("sort");
        String page = request.getParameter("page");

        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin/feedbacks");
        String delimiter = "?";

        if (keyword != null && !keyword.isBlank()) {
            redirectUrl.append(delimiter).append("keyword=")
                    .append(URLEncoder.encode(keyword, StandardCharsets.UTF_8));
            delimiter = "&";
        }
        if (rating != null && !rating.isBlank()) {
            redirectUrl.append(delimiter).append("rating=")
                    .append(URLEncoder.encode(rating, StandardCharsets.UTF_8));
            delimiter = "&";
        }
        if (sort != null && !sort.isBlank()) {
            redirectUrl.append(delimiter).append("sort=")
                    .append(URLEncoder.encode(sort, StandardCharsets.UTF_8));
            delimiter = "&";
        }
        if (page != null && !page.isBlank()) {
            redirectUrl.append(delimiter).append("page=")
                    .append(URLEncoder.encode(page, StandardCharsets.UTF_8));
        }

        response.sendRedirect(redirectUrl.toString());
    }
}

