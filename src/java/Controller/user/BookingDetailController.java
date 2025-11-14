package controller.user;

import dao.BookingDAO;
import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Bookings;
import model.Reviews;
import model.Users;

@WebServlet(name = "BookingDetailController", urlPatterns = {"/user/booking-detail"})
public class BookingDetailController extends HttpServlet {

    private BookingDAO bookingDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        if (session != null) {
            Object feedbackSuccess = session.getAttribute("feedbackSuccess");
            if (feedbackSuccess != null) {
                request.setAttribute("feedbackSuccess", feedbackSuccess);
                session.removeAttribute("feedbackSuccess");
            }
            Object feedbackError = session.getAttribute("feedbackError");
            if (feedbackError != null) {
                request.setAttribute("feedbackError", feedbackError);
                session.removeAttribute("feedbackError");
            }
        }

        String bookingIdParam = request.getParameter("id");
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/bookings");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Bookings booking = bookingDAO.getBookingById(bookingId);

            if (booking == null) {
                request.setAttribute("error", "Không tìm thấy booking này.");
                request.getRequestDispatcher("/HomePage/MyBookings.jsp").forward(request, response);
                return;
            }

            // Kiểm tra booking thuộc về user hiện tại
            if (booking.getUser() == null || booking.getUser().getUserId() != currentUser.getUserId()) {
                request.setAttribute("error", "Bạn không có quyền xem booking này.");
                request.getRequestDispatcher("/HomePage/MyBookings.jsp").forward(request, response);
                return;
            }

            // Kiểm tra xem đã có review chưa
            Reviews existingReview = null;
            try {
                existingReview = reviewDAO.getReviewByBookingId(bookingId);
            } catch (Exception e) {
                // Nếu có lỗi khi lấy review, vẫn tiếp tục hiển thị booking
                e.printStackTrace();
            }
            
            request.setAttribute("booking", booking);
            request.setAttribute("existingReview", existingReview);
            
            request.getRequestDispatcher("/HomePage/BookingDetail.jsp").forward(request, response);
            return;

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "ID booking không hợp lệ.");
            request.getRequestDispatcher("/HomePage/MyBookings.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải thông tin booking. Vui lòng thử lại sau. Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/HomePage/MyBookings.jsp").forward(request, response);
            return;
        }

    }
}

