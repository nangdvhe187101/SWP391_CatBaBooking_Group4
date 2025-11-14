package controller.user;

import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import model.Bookings;
import model.Businesses;
import model.Reviews;
import model.Users;
import dao.BookingDAO;

@WebServlet(name = "SubmitFeedbackController", urlPatterns = {"/user/submit-feedback"})
public class SubmitFeedbackController extends HttpServlet {

    private ReviewDAO reviewDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");
        String ratingParam = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (bookingIdParam == null || ratingParam == null || comment == null) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
            response.sendRedirect(request.getContextPath() + "/user/bookings");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            int rating = Integer.parseInt(ratingParam);

            if (rating < 1 || rating > 5) {
                session.setAttribute("feedbackError", "Đánh giá phải từ 1 đến 5 sao.");
                response.sendRedirect(request.getContextPath() + "/user/booking-detail?id=" + bookingId);
                return;
            }

            if (comment.trim().isEmpty()) {
                session.setAttribute("feedbackError", "Vui lòng nhập nội dung đánh giá.");
                response.sendRedirect(request.getContextPath() + "/user/booking-detail?id=" + bookingId);
                return;
            }

            // Kiểm tra booking thuộc về user
            Bookings booking = bookingDAO.getBookingById(bookingId);
            if (booking == null || booking.getUser() == null || booking.getUser().getUserId() != currentUser.getUserId()) {
                session.setAttribute("feedbackError", "Bạn không có quyền đánh giá booking này.");
                response.sendRedirect(request.getContextPath() + "/user/bookings");
                return;
            }

            // Kiểm tra booking đã được xác nhận (confirmed) chưa
            if (!"confirmed".equalsIgnoreCase(booking.getStatus())) {
                session.setAttribute("feedbackError", "Chỉ có thể đánh giá khi booking đã được xác nhận thành công.");
                response.sendRedirect(request.getContextPath() + "/user/booking-detail?id=" + bookingId);
                return;
            }

            Businesses business = booking.getBusiness();
            if (business == null || business.getBusinessId() <= 0) {
                session.setAttribute("feedbackError", "Không tìm thấy thông tin cơ sở cho booking này.");
                response.sendRedirect(request.getContextPath() + "/user/booking-detail?id=" + bookingId);
                return;
            }

            // Kiểm tra xem đã có review cho booking này chưa (mỗi booking chỉ feedback được 1 lần)
            Reviews existingReview = reviewDAO.getReviewByBookingId(bookingId);
            if (existingReview != null) {
                session.setAttribute("feedbackError", "Bạn đã đánh giá booking này rồi. Mỗi booking chỉ có thể đánh giá một lần.");
                response.sendRedirect(request.getContextPath() + "/user/booking-detail?id=" + bookingId);
                return;
            }

            // Tạo review mới với status pending
            Reviews review = new Reviews();
            review.setBooking(booking);
            review.setBusiness(business);
            review.setUser(currentUser);
            review.setRating((byte) rating);
            review.setComment(comment.trim());
            review.setCreatedAt(LocalDateTime.now());
            review.setStatus("pending"); // Chờ admin duyệt

            try {
                boolean success = reviewDAO.createReview(review);
                if (success) {
                    session.setAttribute("feedbackSuccess", "Cảm ơn bạn đã đánh giá! Đánh giá của bạn đang chờ được duyệt.");
                    session.removeAttribute("feedbackError");
                } else {
                    session.setAttribute("feedbackError", "Không thể gửi đánh giá. Vui lòng thử lại sau.");
                }
            } catch (SQLException ex) {
                String message = ex.getMessage() != null && ex.getMessage().toLowerCase().contains("duplicate")
                        ? "Bạn đã gửi đánh giá cho cơ sở này."
                        : "Không thể gửi đánh giá: " + ex.getMessage();
                session.setAttribute("feedbackError", message);
            }

        } catch (NumberFormatException e) {
            session.setAttribute("feedbackError", "Dữ liệu đánh giá không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("feedbackError", "Có lỗi xảy ra. Vui lòng thử lại sau.");
        }

        response.sendRedirect(request.getContextPath() + "/user/booking-detail?id=" + bookingIdParam);
    }
}

