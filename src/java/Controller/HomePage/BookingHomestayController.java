package Controller.HomePage;

import dao.BookingDAO;
import dao.HomestayDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import model.Bookings;
import model.Businesses;
import model.Rooms;
import model.Users;

@WebServlet(name = "BookingHomestayController", urlPatterns = {"/booking-homestay"})
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

        // 1. Lấy tham số từ URL (từ trang HomestayDetail)
        String roomIdStr = request.getParameter("roomId");
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");
        String guestsStr = request.getParameter("guests");

        // Validate sơ bộ
        if (roomIdStr == null || checkInStr == null || checkOutStr == null) {
            response.sendRedirect("home"); 
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdStr);
            int guests = (guestsStr != null && !guestsStr.isEmpty()) ? Integer.parseInt(guestsStr) : 1;
            LocalDate checkIn = LocalDate.parse(checkInStr);
            LocalDate checkOut = LocalDate.parse(checkOutStr);

            // 2. Lấy thông tin chi tiết phòng
            Rooms room = homestayDAO.getRoomDetailById(roomId);
            
            if (room == null) {
                response.sendRedirect("home");
                return;
            }

            // 3. Tính toán sơ bộ
            long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
            if (nights < 1) nights = 1;
            BigDecimal totalPrice = room.getPricePerNight().multiply(BigDecimal.valueOf(nights));

            // 4. Truyền dữ liệu sang JSP
            request.setAttribute("room", room);
            request.setAttribute("checkIn", checkIn);
            request.setAttribute("checkOut", checkOut);
            request.setAttribute("guests", guests);
            request.setAttribute("nights", nights);
            request.setAttribute("totalPrice", totalPrice);
            
            // QUAN TRỌNG: Gửi giới hạn ngày để validate ở client (không cho chọn ngoài khoảng này)
            request.setAttribute("minDate", checkIn);
            request.setAttribute("maxDate", checkOut);

            // Auto-fill thông tin user
            if (currentUser != null) {
                request.setAttribute("userFullName", currentUser.getFullName());
                request.setAttribute("userEmail", currentUser.getEmail());
                request.setAttribute("userPhone", currentUser.getPhone());
            }

            request.getRequestDispatcher("/HomePage/BookingHomestay.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        try {
            // 1. Nhận dữ liệu form
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String notes = request.getParameter("notes");
            int guests = Integer.parseInt(request.getParameter("guests"));
            
            LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
            LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));
            
            // Các mốc giới hạn (để validate backend)
            LocalDate minDate = LocalDate.parse(request.getParameter("minDate"));
            LocalDate maxDate = LocalDate.parse(request.getParameter("maxDate"));

            // 2. Validate Logic Backend
            // Ngày chọn phải nằm trong khoảng [minDate, maxDate] (Logic bạn yêu cầu)
            if (checkIn.isBefore(minDate) || checkOut.isAfter(maxDate)) {
                request.setAttribute("error", "Thời gian chọn không hợp lệ so với tìm kiếm ban đầu.");
                doGet(request, response); 
                return;
            }
            if (!checkOut.isAfter(checkIn)) {
                request.setAttribute("error", "Ngày trả phòng phải sau ngày nhận phòng.");
                doGet(request, response);
                return;
            }

            // 3. Tính toán lại tiền (Server side)
            Rooms room = homestayDAO.getRoomDetailById(roomId);
            long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
            BigDecimal totalPrice = room.getPricePerNight().multiply(BigDecimal.valueOf(nights));

            // 4. Tạo Booking Object
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
            booking.setPaymentStatus("unpaid");
            booking.setStatus("pending");
            booking.setNotes(notes);
            
            // Set ngày giờ
            booking.setReservationDate(checkIn); 
            booking.setReservationStartTime(checkIn.atTime(14, 0)); // Checkin 14h
            booking.setReservationEndTime(checkOut.atTime(12, 0));  // Checkout 12h
            
            // 5. Lưu vào DB
            // Gọi DAO tạo booking (BookingDAO.createBooking trả về bookingId)
            int bookingId = bookingDAO.createBooking(booking, null); 
            
            if (bookingId > 0) {
                // Lưu chi tiết phòng
                bookingDAO.insertBookedRoom(bookingId, roomId, room.getPricePerNight());
                
                // Chặn lịch
                bookingDAO.blockRoomAvailability(roomId, checkIn, checkOut, room.getPricePerNight());

                // 6. Redirect sang trang thanh toán có sẵn
                response.sendRedirect("confirmation-payment?bookingId=" + bookingId);
            } else {
                request.setAttribute("error", "Lỗi khi tạo đơn đặt phòng. Vui lòng thử lại.");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            doGet(request, response);
        }
    }
}