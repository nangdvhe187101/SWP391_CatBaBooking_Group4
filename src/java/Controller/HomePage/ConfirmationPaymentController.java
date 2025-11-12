package controller.HomePage;

import dao.BookingDAO;
import dao.PaymentDAO;
import dao.RestaurantDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import model.Bookings;
import model.dto.BusinessesDTO;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

/**
 * 
 * @author ADMIN
 */
@WebServlet(name = "ConfirmationPaymentController", urlPatterns = {"/confirmation-payment"})
public class ConfirmationPaymentController extends HttpServlet {

    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        restaurantDAO = new RestaurantDAO();
        paymentDAO = new PaymentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String bookingCode = request.getParameter("bookingCode");
        if (bookingCode == null || bookingCode.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/restaurants");
            return;
        }

        try {
            Bookings booking = bookingDAO.getBookingByCode(bookingCode.trim());
            if (booking == null) {
                response.sendError(404, "Không tìm thấy đặt bàn");
                return;
            }

            // 1. Kiểm tra nếu đã thanh toán -> redirect success
            if ("fully_paid".equals(booking.getPaymentStatus()) || 
                "confirmed".equals(booking.getStatus())) {
                request.setAttribute("booking", booking);
                request.setAttribute("statusMessage", "Booking đã được thanh toán thành công!");
                request.getRequestDispatcher("/HomePage/BookingSuccess.jsp").forward(request, response);
                return;
            }

            // 2. Kiểm tra nếu đã bị hủy -> show message
            if ("cancelled_by_owner".equals(booking.getStatus()) || 
                "cancelled_by_user".equals(booking.getStatus())) {
                request.setAttribute("errorMessage", "Booking này đã bị hủy.");
                request.getRequestDispatcher("/HomePage/BookingCancelled.jsp").forward(request, response);
                return;
            }

            // 3. Kiểm tra nếu đã hết hạn (quá 5 phút) -> auto cancel
            if (bookingDAO.isBookingExpired(booking.getBookingId())) {
                bookingDAO.cancelExpiredBooking(
                    booking.getBookingId(), 
                    "User accessed page after expiry"
                );
                
                request.setAttribute("errorMessage", 
                    "Booking đã hết hạn (quá 5 phút). Vui lòng đặt lại.");
                request.getRequestDispatcher("/HomePage/BookingExpired.jsp").forward(request, response);
                return;
            }

            // 4. Load restaurant info
            BusinessesDTO restaurant = null;
            if (booking.getBusiness() != null && booking.getBusiness().getBusinessId() > 0) {
                restaurant = restaurantDAO.getRestaurantById(booking.getBusiness().getBusinessId());
            }
            
            if (restaurant == null) {
                response.sendError(404, "Không tìm thấy thông tin nhà hàng");
                return;
            }

            // 5. Prepare date/time for JSP
            Date resDateForJsp = null;
            if (booking.getReservationDateForDB() != null) {
                resDateForJsp = java.sql.Date.valueOf(booking.getReservationDateForDB());
            }

            Date resTimeForJsp = null;
            if (booking.getReservationTimeForDB() != null) {
                LocalDateTime fullTime = booking.getReservationTimeForDB().atDate(LocalDate.now());
                resTimeForJsp = java.sql.Timestamp.valueOf(fullTime);
            }

            // 6. Generate QR payment URL
            String desRaw = "TKPDVN " + bookingCode;
            String desEnc = URLEncoder.encode(desRaw, StandardCharsets.UTF_8.toString());
            long vnd = booking.getTotalPrice().longValue();

            final String BANK_ACCOUNT = "00000807297";
            final String BANK_CODE = "TPBank";

            String qrImage = "https://qr.sepay.vn/img?acc=" + BANK_ACCOUNT + 
                            "&bank=" + BANK_CODE + 
                            "&amount=" + vnd + 
                            "&des=" + desEnc;
            String checkoutUrl = "https://qr.sepay.vn/?acc=" + BANK_ACCOUNT + 
                                "&bank=" + BANK_CODE + 
                                "&amount=" + vnd + 
                                "&des=" + desEnc;

            // 7. Tính expiry timestamp (từ created_at + 5 phút)
            Long expiryTimestamp = bookingDAO.getBookingExpiryTimestamp(bookingCode);
            if (expiryTimestamp == null) {
                // Fallback nếu không query được
                expiryTimestamp = System.currentTimeMillis() + (5L * 60 * 1000);
            }

            // 8. Set attributes
            request.setAttribute("booking", booking);
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("bookingCode", bookingCode);
            request.setAttribute("amount", vnd);
            request.setAttribute("qrImage", qrImage);
            request.setAttribute("checkoutUrl", checkoutUrl);
            request.setAttribute("expiryTime", expiryTimestamp);
            request.setAttribute("resDateForJsp", resDateForJsp);
            request.setAttribute("resTimeForJsp", resTimeForJsp);

            request.getRequestDispatcher("/HomePage/ConfirmationPayment.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi tải thông tin thanh toán: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}