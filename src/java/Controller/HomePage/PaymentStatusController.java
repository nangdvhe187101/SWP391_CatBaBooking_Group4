package controller.HomePage;

import dao.BookingDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Bookings;
import model.Payments;
import java.sql.SQLException;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "PaymentStatusController", urlPatterns = {"/payment-status"})
public class PaymentStatusController extends HttpServlet {

    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        paymentDAO = new PaymentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingCode = request.getParameter("booking");
        if (bookingCode == null || bookingCode.trim().isEmpty()) {
            response.sendError(400, "Thiếu mã đặt bàn");
            return;
        }

        String acceptHeader = request.getHeader("Accept");
        boolean isJsonRequest = acceptHeader != null && acceptHeader.contains("application/json");

        try {
            Bookings booking = bookingDAO.getBookingByCode(bookingCode.trim());
            if (booking == null) {
                if (isJsonRequest) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"status\":\"not_found\",\"message\":\"Không tìm thấy đặt bàn\"}");
                } else {
                    response.sendError(404, "Không tìm thấy đặt bàn");
                }
                return;
            }

            // 1. Kiểm tra expiry
            boolean isExpired = bookingDAO.isBookingExpired(booking.getBookingId());

            // 2. Lấy payments
            List<Payments> payments = paymentDAO.getPaymentsByBookingId(booking.getBookingId());

            if (isJsonRequest) {
                String status = determineBookingStatus(booking, payments, isExpired);
                String message = getStatusMessage(status);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(String.format(
                        "{\"status\":\"%s\",\"bookingId\":%d,\"message\":\"%s\",\"isExpired\":%b}",
                        status, booking.getBookingId(), message, isExpired
                ));
                return;
            }

            // Non-JSON: forward to JSP
            request.setAttribute("booking", booking);
            request.setAttribute("payments", payments);
            request.setAttribute("isExpired", isExpired);
            request.getRequestDispatcher("/HomePage/PaymentStatus.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            if (isJsonRequest) {
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi hệ thống\"}");
            } else {
                response.sendError(500, "Lỗi tra cứu trạng thái");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (isJsonRequest) {
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi hệ thống\"}");
            } else {
                response.sendError(500, "Lỗi hệ thống");
            }
        }
    }

    /**
     * Xác định status dựa trên booking, payments và expiry
     */
    private String determineBookingStatus(Bookings booking, List<Payments> payments, boolean isExpired) {
        // 1. Kiểm tra confirmed/paid
        if ("confirmed".equals(booking.getStatus()) || "fully_paid".equals(booking.getPaymentStatus())) {
            return "paid";
        }

        // 2. Kiểm tra payment completed
        for (Payments p : payments) {
            if ("completed".equals(p.getStatus())) {
                return "paid";
            }
        }

        // 3. Kiểm tra cancelled
        if ("cancelled_by_owner".equals(booking.getStatus())
                || "cancelled_by_user".equals(booking.getStatus())) {
            return "cancelled";
        }

        // 4. Kiểm tra failed
        for (Payments p : payments) {
            if ("failed".equals(p.getStatus())) {
                return "failed";
            }
        }

        // 5. Kiểm tra expired
        if (isExpired) {
            return "expired";
        }

        // 6. Default: pending
        return "pending";
    }

    /**
     * Message tương ứng status
     */
    private String getStatusMessage(String status) {
        switch (status) {
            case "paid":
                return "Thanh toán thành công";
            case "pending":
                return "Đang chờ thanh toán";
            case "cancelled":
                return "Đã hủy";
            case "failed":
                return "Thanh toán thất bại";
            case "expired":
                return "Đã hết hạn (quá 5 phút)";
            default:
                return "Đang xử lý";
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
