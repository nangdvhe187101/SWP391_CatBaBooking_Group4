package controller.HomePage;

import dao.BookingDAO;
import dao.HomestayDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import jakarta.servlet.http.HttpServlet;
import java.time.temporal.ChronoUnit;
import model.Bookings;
import model.Businesses;
import model.Rooms;
import model.Users;

// [QUAN TRỌNG] Đổi URL pattern thành /checkout-homestay
@WebServlet(name = "BookingHomestayController", urlPatterns = {"/checkout-homestay"})
public class BookingHomestayController extends HttpServlet {

    private HomestayDAO homestayDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        homestayDAO = new HomestayDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        String roomIdStr = request.getParameter("roomId");
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");
        String guestsStr = request.getParameter("guests");

        // Validate tham số
        if (roomIdStr == null || checkInStr == null || checkOutStr == null) {
            response.sendRedirect(request.getContextPath() + "/home"); 
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdStr);
            int guests = (guestsStr != null && !guestsStr.isEmpty()) ? Integer.parseInt(guestsStr) : 1;
            LocalDate checkIn = LocalDate.parse(checkInStr);
            LocalDate checkOut = LocalDate.parse(checkOutStr);

            // Lấy thông tin phòng (đã fix trong HomestayDAO)
            Rooms room = homestayDAO.getRoomDetailById(roomId);
            
            if (room == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
            if (nights < 1) nights = 1;
            BigDecimal totalPrice = room.getPricePerNight().multiply(BigDecimal.valueOf(nights));

            request.setAttribute("room", room);
            request.setAttribute("checkIn", checkIn);
            request.setAttribute("checkOut", checkOut);
            request.setAttribute("guests", guests);
            request.setAttribute("nights", nights);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("minDate", checkIn);
            request.setAttribute("maxDate", checkOut);

            if (currentUser != null) {
                request.setAttribute("userFullName", currentUser.getFullName());
                request.setAttribute("userEmail", currentUser.getEmail());
                request.setAttribute("userPhone", currentUser.getPhone());
            }

            // [QUAN TRỌNG] Trỏ về đúng file JSP: CheckoutHomestay.jsp
            request.getRequestDispatcher("/HomePage/CheckoutHomestay.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        try {
            // Nhận dữ liệu từ form
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String notes = request.getParameter("notes");
            int guests = Integer.parseInt(request.getParameter("guests"));
            
            LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
            LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));
            
            // Validate ngày tháng (Backend check)
            if (!checkOut.isAfter(checkIn)) {
                request.setAttribute("error", "Ngày trả phòng không hợp lệ.");
                doGet(request, response); 
                return;
            }

            Rooms room = homestayDAO.getRoomDetailById(roomId);
            long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
            BigDecimal totalPrice = room.getPricePerNight().multiply(BigDecimal.valueOf(nights));

            // Tạo Booking Object
            Bookings booking = new Bookings();
            booking.setUser(currentUser); 
            
            Businesses biz = new Businesses();
            biz.setBusinessId(room.getBusiness().getBusinessId());
            booking.setBusiness(biz);
            
            booking.setBookerName(fullName);
            booking.setBookerEmail(email);
            booking.setBookerPhone(phone);
            booking.setNumGuests(guests);
            booking.setTotalPrice(totalPrice);
            booking.setNotes(notes);
            
            booking.setReservationDate(checkIn); 
            booking.setReservationStartTime(checkIn.atTime(14, 0));
            booking.setReservationEndTime(checkOut.atTime(12, 0));
            
            // Gọi hàm Transaction trong BookingDAO (đã thêm ở bước trước)
            int bookingId = bookingDAO.createHomestayBookingTransaction(booking, roomId, room.getPricePerNight());
            
            if (bookingId > 0) {
                // Redirect sang trang thanh toán
                response.sendRedirect("confirmation-payment?bookingCode=" + booking.getBookingCode());
            } else {
                request.setAttribute("error", "Lỗi khi tạo đơn đặt phòng. Vui lòng thử lại.");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            doGet(request, response);
        }
    }
}