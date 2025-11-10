package controller.HomePage;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Bookings;
import java.sql.SQLException;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "CancelExpiredBookingController", urlPatterns = {"/cancel-expired-booking"})
public class CancelExpiredBookingController extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String bookingCode = request.getParameter("bookingCode");

        if (bookingCode == null || bookingCode.trim().isEmpty()) {
            response.setStatus(400);
            response.getWriter().write("{\"error\":\"Missing booking code\"}");
            return;
        }

        try {
            // 1. Lấy thông tin booking
            Bookings booking = bookingDAO.getBookingByCode(bookingCode.trim());

            if (booking == null) {
                response.setStatus(404);
                response.getWriter().write("{\"error\":\"Booking not found\"}");
                return;
            }

            // 2. Kiểm tra đã thanh toán chưa
            if ("fully_paid".equals(booking.getPaymentStatus())
                    || "confirmed".equals(booking.getStatus())) {
                response.setStatus(200);
                response.getWriter().write("{\"status\":\"already_paid\",\"message\":\"Booking already confirmed\"}");
                return;
            }

            // 3. Kiểm tra đã bị hủy chưa
            if ("cancelled_by_owner".equals(booking.getStatus())
                    || "cancelled_by_user".equals(booking.getStatus())) {
                response.setStatus(200);
                response.getWriter().write("{\"status\":\"already_cancelled\",\"message\":\"Booking already cancelled\"}");
                return;
            }

            // 4. Kiểm tra có thực sự quá hạn không
            boolean isExpired = bookingDAO.isBookingExpired(booking.getBookingId());
            if (!isExpired) {
                response.setStatus(200);
                response.getWriter().write("{\"status\":\"not_expired\",\"message\":\"Booking not expired yet\"}");
                return;
            }

            // 5. Thực hiện hủy booking
            boolean success = bookingDAO.cancelExpiredBooking(
                    booking.getBookingId(),
                    "Frontend notification - Quá 5 phút không thanh toán"
            );

            if (success) {
                System.out.println(String.format(
                        "[CancelExpiredBooking] ✅ Cancelled booking %s (ID: %d) via API",
                        bookingCode, booking.getBookingId()
                ));

                response.setStatus(200);
                response.getWriter().write("{\"status\":\"cancelled\",\"message\":\"Booking cancelled successfully\"}");
            } else {
                response.setStatus(500);
                response.getWriter().write("{\"error\":\"Failed to cancel booking\"}");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\":\"Database error: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\":\"System error: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setStatus(405);
        response.setContentType("application/json");
        response.getWriter().write("{\"error\":\"Method not allowed. Use POST.\"}");
    }
}
