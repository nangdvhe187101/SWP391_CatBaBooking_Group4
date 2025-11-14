package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.Bookings;
import model.BookingDishes;
import model.Businesses;
import model.Rooms;
import model.Users;
import model.dto.BookedRoomDTO;
import util.DBUtil;

/**
 * @author ADMIN
 */
public class BookingDAO {

    /**
     * Tạo booking mới với dishes
     */
    public int createBooking(Bookings booking, List<BookingDishes> dishesList) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            int bookingId = insertBooking(conn, booking);
            if (bookingId == -1) {
                conn.rollback();
                return -1;
            }
            booking.setBookingId(bookingId);

            if (dishesList != null && !dishesList.isEmpty()) {
                for (BookingDishes dish : dishesList) {
                    dish.setBooking(booking);
                    if (!insertBookingDish(conn, dish)) {
                        conn.rollback();
                        return -1;
                    }
                }
            }
            
            if (!createInitialPayment(conn, bookingId, booking.getTotalPrice(), "sepay", booking.getBookingCode())) {
                conn.rollback();
                return -1;
            }
            
            conn.commit();
            System.out.println("[BookingDAO] ✅ Created booking: " + booking.getBookingCode());
            return bookingId;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private int insertBooking(Connection conn, Bookings booking) throws SQLException {
        if (booking.getStatus() == null) {
            booking.setStatus("pending");
        }
        
        String bookingCode;
        if (booking.getBookingCode() == null || booking.getBookingCode().isEmpty()) {
            String shortUuid = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            long timestampMod = System.currentTimeMillis() % 10000;
            bookingCode = "BK" + shortUuid + String.format("%04d", timestampMod);
        } else {
            bookingCode = booking.getBookingCode();
        }
        booking.setBookingCode(bookingCode);
        
        String sql = "INSERT INTO bookings (booking_code, user_id, business_id, booker_name, booker_email, booker_phone, "
                + "num_guests, total_price, paid_amount, payment_status, notes, reservation_date, reservation_time, "
                + "reservation_start_time, reservation_end_time, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, bookingCode);
            if (booking.getUser() != null && booking.getUser().getUserId() > 0) {
                ps.setInt(2, booking.getUser().getUserId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setInt(3, booking.getBusiness().getBusinessId());
            ps.setString(4, booking.getBookerName());
            ps.setString(5, booking.getBookerEmail());
            ps.setString(6, booking.getBookerPhone());
            ps.setInt(7, booking.getNumGuests());
            ps.setBigDecimal(8, booking.getTotalPrice());
            ps.setBigDecimal(9, booking.getPaidAmount() != null ? booking.getPaidAmount() : BigDecimal.ZERO);
            ps.setString(10, booking.getPaymentStatus() != null ? booking.getPaymentStatus() : "unpaid");
            ps.setString(11, booking.getNotes());

            LocalDate resDate = booking.getReservationDateForDB();
            LocalTime resTime = booking.getReservationTimeForDB();
            ps.setDate(12, resDate != null ? java.sql.Date.valueOf(resDate) : null);
            ps.setTime(13, resTime != null ? java.sql.Time.valueOf(resTime) : null);
            
            // Set reservation_start_time and reservation_end_time for homestay bookings
            ps.setObject(14, booking.getReservationStartTime() != null ? booking.getReservationStartTime() : null, Types.TIMESTAMP);
            ps.setObject(15, booking.getReservationEndTime() != null ? booking.getReservationEndTime() : null, Types.TIMESTAMP);
            
            ps.setString(16, booking.getStatus());

            int result = ps.executeUpdate();
            if (result > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
            return -1;
        }
    }

    private boolean insertBookingDish(Connection conn, BookingDishes dish) throws SQLException {
        String sql = "INSERT INTO booking_dishes (booking_id, dish_id, quantity, price_at_booking, notes) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dish.getBooking().getBookingId());
            ps.setInt(2, dish.getDish().getDishId());
            ps.setInt(3, dish.getQuantity());
            ps.setBigDecimal(4, dish.getPriceAtBooking());
            ps.setString(5, dish.getNotes());
            return ps.executeUpdate() > 0;
        }
    }

    private boolean createInitialPayment(Connection conn, int bookingId, BigDecimal amount, 
                                        String paymentMethod, String bookingCode) throws SQLException {
        String sql = "INSERT INTO payments (booking_id, amount, payment_method, status, gateway_response, created_at) "
                   + "VALUES (?, ?, ?, 'pending', ?, NOW())";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bookingId);
            ps.setBigDecimal(2, amount);
            ps.setString(3, paymentMethod != null ? paymentMethod : "sepay");
            ps.setString(4, bookingCode);

            int result = ps.executeUpdate();
            if (result > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        System.out.println("[BookingDAO] ✅ Created payment for booking: " + bookingCode);
                        return true;
                    }
                }
            }
            return false;
        }
    }

    /**
     * Sync booking payment status từ payments table
     */
    public void syncBookingPayment(int bookingId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            
            BigDecimal paidSum = BigDecimal.ZERO;
            String sumSql = "SELECT COALESCE(SUM(amount), 0) FROM payments "
                    + "WHERE booking_id = ? AND status = 'completed'";
            try (PreparedStatement ps = conn.prepareStatement(sumSql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        paidSum = rs.getBigDecimal(1);
                    }
                }
            }
            
            BigDecimal totalPrice = BigDecimal.ZERO;
            String priceSql = "SELECT total_price FROM bookings WHERE booking_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(priceSql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalPrice = rs.getBigDecimal("total_price");
                    }
                }
            }
            
            String newPaymentStatus;
            String newBookingStatus;
            if (paidSum.compareTo(totalPrice) >= 0) {
                newPaymentStatus = "fully_paid";
                newBookingStatus = "confirmed";
            } else if (paidSum.compareTo(BigDecimal.ZERO) > 0) {
                newPaymentStatus = "partially_paid";
                newBookingStatus = "pending";
            } else {
                newPaymentStatus = "unpaid";
                newBookingStatus = "pending";
            }
            
            String updateSql = "UPDATE bookings SET paid_amount = ?, payment_status = ?, status = ? WHERE booking_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setBigDecimal(1, paidSum);
                ps.setString(2, newPaymentStatus);
                ps.setString(3, newBookingStatus);
                ps.setInt(4, bookingId);
                ps.executeUpdate();
            }
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }

    /**
     * Lấy booking theo code
     */
    public Bookings getBookingByCode(String bookingCode) throws SQLException {
        if (bookingCode == null || bookingCode.trim().isEmpty()) {
            return null;
        }
        
        String sql = "SELECT b.*, bus.business_id as bus_id, bus.name as bus_name "
                + "FROM bookings b "
                + "LEFT JOIN businesses bus ON b.business_id = bus.business_id "
                + "WHERE b.booking_code = ? LIMIT 1";
                
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingCode.trim());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Bookings b = new Bookings();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setBookingCode(rs.getString("booking_code"));

                    Users user = new Users();
                    user.setUserId(rs.getInt("user_id"));
                    b.setUser(user);

                    int busId = rs.getInt("bus_id");
                    if (!rs.wasNull() && busId > 0) {
                        Businesses business = new Businesses();
                        business.setBusinessId(busId);
                        business.setName(rs.getString("bus_name"));
                        b.setBusiness(business);
                    }

                    b.setBookerName(rs.getString("booker_name"));
                    b.setBookerEmail(rs.getString("booker_email"));
                    b.setBookerPhone(rs.getString("booker_phone"));
                    b.setNumGuests(rs.getInt("num_guests"));
                    b.setTotalPrice(rs.getBigDecimal("total_price"));
                    b.setPaidAmount(rs.getBigDecimal("paid_amount"));
                    b.setPaymentStatus(rs.getString("payment_status"));
                    b.setNotes(rs.getString("notes"));
                    b.setReservationDateForDB(rs.getDate("reservation_date") != null ? rs.getDate("reservation_date").toLocalDate() : null);
                    b.setReservationTimeForDB(rs.getTime("reservation_time") != null ? rs.getTime("reservation_time").toLocalTime() : null);
                    b.setStatus(rs.getString("status"));

                    return b;
                }
            }
        }
        return null;
    }

    /**
     * Lấy danh sách booking của user
     */
    public List<Bookings> getBookingsByUser(int userId) throws SQLException {
        List<Bookings> bookings = new ArrayList<>();
        String sql = "SELECT b.*, bus.name AS business_name, bus.type AS business_type, bus.address AS business_address "
                + "FROM bookings b "
                + "LEFT JOIN businesses bus ON b.business_id = bus.business_id "
                + "WHERE b.user_id = ? "
                + "ORDER BY b.created_at DESC";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bookings booking = new Bookings();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setBookingCode(rs.getString("booking_code"));

                    Users user = new Users();
                    user.setUserId(rs.getInt("user_id"));
                    booking.setUser(user);

                    int businessId = rs.getInt("business_id");
                    if (!rs.wasNull() && businessId > 0) {
                        Businesses business = new Businesses();
                        business.setBusinessId(businessId);
                        business.setName(rs.getString("business_name"));
                        business.setType(rs.getString("business_type"));
                        business.setAddress(rs.getString("business_address"));
                        booking.setBusiness(business);
                    }

                    booking.setBookerName(rs.getString("booker_name"));
                    booking.setBookerEmail(rs.getString("booker_email"));
                    booking.setBookerPhone(rs.getString("booker_phone"));
                    booking.setNumGuests(rs.getInt("num_guests"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setPaidAmount(rs.getBigDecimal("paid_amount"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setNotes(rs.getString("notes"));
                    booking.setStatus(rs.getString("status"));

                    booking.setReservationStartTime(rs.getObject("reservation_start_time", LocalDateTime.class));
                    booking.setReservationEndTime(rs.getObject("reservation_end_time", LocalDateTime.class));

                    java.sql.Date resDate = rs.getDate("reservation_date");
                    if (resDate != null) {
                        booking.setReservationDateForDB(resDate.toLocalDate());
                    }

                    java.sql.Time resTime = rs.getTime("reservation_time");
                    if (resTime != null) {
                        booking.setReservationTimeForDB(resTime.toLocalTime());
                    }

                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }

    /**
     * Update booking status
     */
    public boolean updateBookingStatus(int bookingId, String newStatus) throws SQLException {
        String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        }
    }

    // ========== EXPIRY MANAGEMENT (KHÔNG dùng expiry_time column) ==========

    /**
     * Lấy danh sách booking quá 5 phút chưa thanh toán
     * Tính toán expiry on-the-fly từ created_at
     */
    public List<Bookings> getExpiredBookings(int limit) throws SQLException {
        List<Bookings> expired = new ArrayList<>();
        
        String sql = "SELECT b.booking_id, b.booking_code, b.business_id, b.status, b.payment_status, " +
                     "       b.created_at, " +
                     "       DATE_ADD(b.created_at, INTERVAL 5 MINUTE) as expiry_time " +
                     "FROM bookings b " +
                     "WHERE b.status = 'pending' " +
                     "  AND b.payment_status IN ('unpaid', 'partially_paid') " +
                     "  AND DATE_ADD(b.created_at, INTERVAL 5 MINUTE) < NOW() " +
                     "ORDER BY b.created_at ASC " +
                     "LIMIT ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bookings b = new Bookings();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setBookingCode(rs.getString("booking_code"));
                    
                    Businesses business = new Businesses();
                    business.setBusinessId(rs.getInt("business_id"));
                    b.setBusiness(business);
                    
                    b.setStatus(rs.getString("status"));
                    b.setPaymentStatus(rs.getString("payment_status"));
                    
                    expired.add(b);
                }
            }
        }
        
        return expired;
    }

    /**
     * Hủy booking (transaction-safe)
     */
    public boolean cancelExpiredBooking(int bookingId, String reason) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Kiểm tra booking còn pending không
            String checkSql = "SELECT status, payment_status FROM bookings WHERE booking_id = ? FOR UPDATE";
            String currentStatus = null;
            String currentPaymentStatus = null;
            
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        currentStatus = rs.getString("status");
                        currentPaymentStatus = rs.getString("payment_status");
                    }
                }
            }
            
            // Nếu đã confirmed hoặc paid -> skip
            if ("confirmed".equals(currentStatus) || 
                "fully_paid".equals(currentPaymentStatus)) {
                conn.rollback();
                System.out.println("[BookingDAO] ⚠️ Booking " + bookingId + " already confirmed, skip cancel");
                return true;
            }
            
            // Nếu đã bị hủy -> skip
            if ("cancelled_by_owner".equals(currentStatus) || 
                "cancelled_by_user".equals(currentStatus)) {
                conn.rollback();
                System.out.println("[BookingDAO] ⚠️ Booking " + bookingId + " already cancelled");
                return true;
            }
            
            // 2. Update booking
            String updateBookingSql = 
                "UPDATE bookings " +
                "SET status = 'cancelled_by_owner', " +
                "    payment_status = 'refunded', " +
                "    notes = CONCAT(COALESCE(notes, ''), ?) " +
                "WHERE booking_id = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(updateBookingSql)) {
                ps.setString(1, "\n[AUTO] " + (reason != null ? reason : "Hủy do quá 5 phút không thanh toán"));
                ps.setInt(2, bookingId);
                ps.executeUpdate();
            }
            
            // 3. Update payments
            String updatePaymentSql = 
                "UPDATE payments " +
                "SET status = 'failed', " +
                "    gateway_response = CONCAT(COALESCE(gateway_response, ''), ?) " +
                "WHERE booking_id = ? AND status = 'pending'";
            
            try (PreparedStatement ps = conn.prepareStatement(updatePaymentSql)) {
                ps.setString(1, "\n[AUTO] Expired - " + (reason != null ? reason : "không thanh toán trong 5 phút"));
                ps.setInt(2, bookingId);
                ps.executeUpdate();
            }
            
            // 4. Giải phóng bàn
            freeTableAvailability(conn, bookingId);
            
            conn.commit();
            System.out.println("[BookingDAO] ✅ Cancelled expired booking: " + bookingId);
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Giải phóng table availability
     */
    private void freeTableAvailability(Connection conn, int bookingId) throws SQLException {
        String sql = "DELETE ta FROM table_availability ta " +
                     "JOIN booked_tables bt ON ta.table_id = bt.table_id " +
                     "WHERE bt.booking_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("[BookingDAO] 🪑 Freed " + rows + " table(s) for booking " + bookingId);
            }
        }
    }

    /**
     * Kiểm tra booking có quá hạn không (tính từ created_at)
     */
    public boolean isBookingExpired(int bookingId) throws SQLException {
        String sql = "SELECT DATE_ADD(created_at, INTERVAL 5 MINUTE) < NOW() as is_expired " +
                     "FROM bookings WHERE booking_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBoolean("is_expired");
                }
            }
        }
        return false;
    }

    /**
     * Lấy thời gian hết hạn timestamp (milliseconds) từ created_at
     */
    public Long getBookingExpiryTimestamp(String bookingCode) throws SQLException {
        String sql = "SELECT UNIX_TIMESTAMP(DATE_ADD(created_at, INTERVAL 5 MINUTE)) * 1000 as expiry_ms " +
                     "FROM bookings WHERE booking_code = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong("expiry_ms");
                }
            }
        }
        return null;
    }
    
    public List<Bookings> getHomestayBookingsByBusinessId(int businessId, String statusFilter, int page, int pageSize) {
        List<Bookings> bookingList = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        // Dùng SELECT b.* sẽ lấy tất cả các cột, bao gồm cả 'created_at'
        // nhưng model của bạn không có trường này, nên chúng ta sẽ bỏ qua nó.
        StringBuilder sql = new StringBuilder(
            "SELECT b.* FROM bookings b " +
            "JOIN businesses biz ON b.business_id = biz.business_id " +
            "WHERE b.business_id = ? AND biz.type = 'homestay' ");

        if (statusFilter != null && !statusFilter.equalsIgnoreCase("all")) {
            sql.append(" AND b.status = ? ");
        }
        // Sắp xếp theo created_at (vẫn tồn tại trong DB)
        sql.append(" ORDER BY b.created_at DESC LIMIT ? OFFSET ?"); 

        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            stmt.setInt(paramIndex++, businessId);
            
            if (statusFilter != null && !statusFilter.equalsIgnoreCase("all")) {
                stmt.setString(paramIndex++, statusFilter);
            }
            stmt.setInt(paramIndex++, pageSize);
            stmt.setInt(paramIndex++, offset);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Bookings booking = new Bookings();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setBookingCode(rs.getString("booking_code"));
                    
                    // SỬA LỖI 1: Model 'Bookings' dùng setBusiness(Businesses)
                    Businesses tempBiz = new Businesses();
                    tempBiz.setBusinessId(rs.getInt("business_id"));
                    booking.setBusiness(tempBiz); // <-- ĐÃ SỬA
                    
                    booking.setBookerName(rs.getString("booker_name"));
                    booking.setBookerEmail(rs.getString("booker_email"));
                    booking.setBookerPhone(rs.getString("booker_phone"));
                    booking.setNumGuests(rs.getInt("num_guests"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setPaidAmount(rs.getBigDecimal("paid_amount"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setNotes(rs.getString("notes"));
                    
                    // Các trường này dùng cho Homestay
                    booking.setReservationStartTime(rs.getObject("reservation_start_time", LocalDateTime.class));
                    booking.setReservationEndTime(rs.getObject("reservation_end_time", LocalDateTime.class));
                    
                    booking.setStatus(rs.getString("status"));
                    
                    // SỬA LỖI 2: Map các trường legacy (dùng cho restaurant)
                    // vì model của bạn (lượt 28) CÓ CÁC TRƯỜNG NÀY
                    booking.setReservation_date(rs.getObject("reservation_date", LocalDateTime.class));
                    booking.setReservation_time(rs.getObject("reservation_time", LocalDateTime.class));

                    // SỬA LỖI 3: XÓA DÒNG GÂY LỖI
                    // booking.setCreatedAt(...) <-- Đã xóa vì model (lượt 28) không có
                    
                    bookingList.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookingList;
    }

    /**
     * Đếm tổng số đơn đặt phòng (homestay) cho phân trang.
     * (Hàm này không có lỗi, giữ nguyên)
     */
    public int countHomestayBookingsByBusinessId(int businessId, String statusFilter) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM bookings b " +
            "JOIN businesses biz ON b.business_id = biz.business_id " +
            "WHERE b.business_id = ? AND biz.type = 'homestay' ");

        if (statusFilter != null && !statusFilter.equalsIgnoreCase("all")) {
            sql.append(" AND b.status = ? ");
        }

        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            stmt.setInt(paramIndex++, businessId);
            
            if (statusFilter != null && !statusFilter.equalsIgnoreCase("all")) {
                stmt.setString(paramIndex++, statusFilter);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy danh sách các phòng đã đặt cho một đơn hàng (booking).
     */
    public List<BookedRoomDTO> getBookedRoomsByBookingId(int bookingId) {
        List<BookedRoomDTO> bookedRooms = new ArrayList<>();
        String sql = "SELECT br.*, r.name as room_name FROM booked_rooms br " +
                     "JOIN rooms r ON br.room_id = r.room_id " +
                     "WHERE br.booking_id = ?";
        
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookingId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BookedRoomDTO dto = new BookedRoomDTO();
                    dto.setBookedRoomId(rs.getInt("booked_room_id"));
                    
                    // SỬA LỖI 4: Model 'BookedRooms' dùng setBooking(Bookings)
                    Bookings tempBooking = new Bookings();
                    tempBooking.setBookingId(rs.getInt("booking_id"));
                    dto.setBooking(tempBooking); // <-- ĐÃ SỬA
                    
                    // SỬA LỖI 5: Model 'BookedRooms' dùng setRoom(Rooms)
                    Rooms tempRoom = new Rooms();
                    tempRoom.setRoomId(rs.getInt("room_id"));
                    dto.setRoom(tempRoom); // <-- ĐÃ SỬA

                    dto.setPriceAtBooking(rs.getBigDecimal("price_at_booking"));
                    dto.setRoomName(rs.getString("room_name")); 
                    
                    bookedRooms.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookedRooms;
    }
    
    public Bookings getBookingById(int bookingId) {
        Bookings booking = null;
        String sql = "SELECT b.*, bus.name AS business_name, bus.type AS business_type, bus.address AS business_address "
                + "FROM bookings b "
                + "LEFT JOIN businesses bus ON b.business_id = bus.business_id "
                + "WHERE b.booking_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = new Bookings();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setBookingCode(rs.getString("booking_code"));

                    // Set User
                    Users tempUser = new Users();
                    tempUser.setUserId(rs.getInt("user_id"));
                    booking.setUser(tempUser);

                    // Set Business với đầy đủ thông tin
                    int businessId = rs.getInt("business_id");
                    if (!rs.wasNull() && businessId > 0) {
                    Businesses tempBiz = new Businesses();
                        tempBiz.setBusinessId(businessId);
                        tempBiz.setName(rs.getString("business_name"));
                        tempBiz.setType(rs.getString("business_type"));
                        tempBiz.setAddress(rs.getString("business_address"));
                    booking.setBusiness(tempBiz);
                    }

                    booking.setBookerName(rs.getString("booker_name"));
                    booking.setBookerEmail(rs.getString("booker_email"));
                    booking.setBookerPhone(rs.getString("booker_phone"));
                    booking.setNumGuests(rs.getInt("num_guests"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setPaidAmount(rs.getBigDecimal("paid_amount"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setNotes(rs.getString("notes"));

                    // Map các trường thời gian
                    booking.setReservationStartTime(rs.getObject("reservation_start_time", LocalDateTime.class));
                    booking.setReservationEndTime(rs.getObject("reservation_end_time", LocalDateTime.class));
                    
                    // Map reservation_date và reservation_time đúng cách (DATE và TIME, không phải DATETIME)
                    java.sql.Date resDate = rs.getDate("reservation_date");
                    if (resDate != null) {
                        booking.setReservationDateForDB(resDate.toLocalDate());
                    }
                    
                    java.sql.Time resTime = rs.getTime("reservation_time");
                    if (resTime != null) {
                        booking.setReservationTimeForDB(resTime.toLocalTime());
                    }
                    
                    booking.setStatus(rs.getString("status"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return booking;
    }
    
    /**
     * Lấy danh sách đặt phòng với đầy đủ bộ lọc: Ngày, Từ khóa, Trạng thái, Phân trang.
     */
    public List<Bookings> searchHomestayBookings(int businessId, String status, String keyword, 
                                                 String fromDate, String toDate, int page, int pageSize) {
        List<Bookings> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sql = new StringBuilder(
            "SELECT b.* FROM bookings b " +
            "JOIN businesses biz ON b.business_id = biz.business_id " +
            "WHERE b.business_id = ? AND biz.type = 'homestay' ");

        List<Object> params = new ArrayList<>();
        params.add(businessId);

        // 1. Lọc theo trạng thái
        if (status != null && !status.equals("all")) {
            sql.append(" AND b.status = ? ");
            params.add(status);
        }

        // 2. Tìm kiếm theo Tên hoặc SĐT
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (b.booker_name LIKE ? OR b.booker_phone LIKE ?) ");
            String likeKey = "%" + keyword.trim() + "%";
            params.add(likeKey);
            params.add(likeKey);
        }

        // 3. Lọc theo khoảng thời gian (Ngày nhận phòng hoặc Trả phòng nằm trong khoảng)
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND b.reservation_start_time >= ? ");
            params.add(fromDate + " 00:00:00");
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND b.reservation_end_time <= ? ");
            params.add(toDate + " 23:59:59");
        }

        // Sắp xếp và Phân trang
        sql.append(" ORDER BY b.reservation_start_time DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);

        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bookings b = new Bookings();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setBookingCode(rs.getString("booking_code"));
                    b.setBookerName(rs.getString("booker_name"));
                    b.setBookerPhone(rs.getString("booker_phone"));
                    b.setBookerEmail(rs.getString("booker_email"));
                    b.setNumGuests(rs.getInt("num_guests"));
                    b.setTotalPrice(rs.getBigDecimal("total_price"));
                    b.setPaidAmount(rs.getBigDecimal("paid_amount"));
                    b.setPaymentStatus(rs.getString("payment_status"));
                    b.setStatus(rs.getString("status"));
                    b.setNotes(rs.getString("notes"));
                    b.setReservationStartTime(rs.getObject("reservation_start_time", LocalDateTime.class));
                    b.setReservationEndTime(rs.getObject("reservation_end_time", LocalDateTime.class));
                    
                    // Set business dummy để tránh null pointer
                    Businesses biz = new Businesses();
                    biz.setBusinessId(businessId);
                    b.setBusiness(biz);

                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng số bản ghi để phân trang (với cùng bộ lọc).
     */
    public int countSearchHomestayBookings(int businessId, String status, String keyword, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM bookings b " +
            "JOIN businesses biz ON b.business_id = biz.business_id " +
            "WHERE b.business_id = ? AND biz.type = 'homestay' ");

        List<Object> params = new ArrayList<>();
        params.add(businessId);

        if (status != null && !status.equals("all")) {
            sql.append(" AND b.status = ? ");
            params.add(status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (b.booker_name LIKE ? OR b.booker_phone LIKE ?) ");
            String likeKey = "%" + keyword.trim() + "%";
            params.add(likeKey);
            params.add(likeKey);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND b.reservation_start_time >= ? ");
            params.add(fromDate + " 00:00:00");
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND b.reservation_end_time <= ? ");
            params.add(toDate + " 23:59:59");
        }

        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Lưu thông tin phòng đã đặt vào bảng booked_rooms
     */
    public boolean insertBookedRoom(int bookingId, int roomId, BigDecimal price) {
        String sql = "INSERT INTO booked_rooms (booking_id, room_id, price_at_booking) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, roomId);
            ps.setBigDecimal(3, price);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Chặn lịch trong bảng room_availability
     */
    public void blockRoomAvailability(int roomId, LocalDate checkIn, LocalDate checkOut, BigDecimal price) {
        // Status 'booked' nghĩa là đã có người đặt
        String sql = "INSERT INTO room_availability (room_id, date, price, status) VALUES (?, ?, ?, 'booked') " +
                     "ON DUPLICATE KEY UPDATE status = 'booked'"; 
        
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            // Lặp qua từng ngày từ checkIn đến checkOut (KHÔNG bao gồm ngày checkout)
            // Ví dụ: Book 01-03 (2 đêm), sẽ chặn ngày 01 và 02. Ngày 03 khách check-out trưa nên tối 03 vẫn trống.
            for (LocalDate date = checkIn; date.isBefore(checkOut); date = date.plusDays(1)) {
                ps.setInt(1, roomId);
                ps.setDate(2, java.sql.Date.valueOf(date));
                ps.setBigDecimal(3, price);
                ps.addBatch(); 
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public BigDecimal getMonthlyRevenue() {
        String sql = "SELECT COALESCE(SUM(total_price), 0) FROM bookings "
                + "WHERE MONTH(created_at) = MONTH(CURRENT_DATE) "
                + "AND YEAR(created_at) = YEAR(CURRENT_DATE) "
                + "AND status = 'confirmed'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public List<Bookings> getRecentBookings(int limit) throws SQLException {
        List<Bookings> bookings = new ArrayList<>();
        String sql = "SELECT b.*, bus.name AS business_name, bus.type AS business_type, bus.address AS business_address, "
                + "u.full_name AS user_name, u.email AS user_email "
                + "FROM bookings b "
                + "LEFT JOIN businesses bus ON b.business_id = bus.business_id "
                + "LEFT JOIN users u ON b.user_id = u.user_id "
                + "ORDER BY b.created_at DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bookings booking = new Bookings();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setBookingCode(rs.getString("booking_code"));

                    Users user = new Users();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("user_name"));
                    user.setEmail(rs.getString("user_email"));
                    booking.setUser(user);

                    int businessId = rs.getInt("business_id");
                    if (!rs.wasNull() && businessId > 0) {
                        Businesses business = new Businesses();
                        business.setBusinessId(businessId);
                        business.setName(rs.getString("business_name"));
                        business.setType(rs.getString("business_type"));
                        business.setAddress(rs.getString("business_address"));
                        booking.setBusiness(business);
                    }

                    booking.setBookerName(rs.getString("booker_name"));
                    booking.setBookerEmail(rs.getString("booker_email"));
                    booking.setBookerPhone(rs.getString("booker_phone"));
                    booking.setNumGuests(rs.getInt("num_guests"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setPaidAmount(rs.getBigDecimal("paid_amount"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setNotes(rs.getString("notes"));
                    booking.setStatus(rs.getString("status"));

                    booking.setReservationStartTime(rs.getObject("reservation_start_time", LocalDateTime.class));
                    booking.setReservationEndTime(rs.getObject("reservation_end_time", LocalDateTime.class));
                    booking.setReservation_date(rs.getObject("reservation_date", LocalDateTime.class));
                    booking.setReservation_time(rs.getObject("reservation_time", LocalDateTime.class));

                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }
    
    /**
     * Lấy tất cả booking cho admin với filter và pagination
     */
    public List<Bookings> getAllBookingsForAdmin(String statusFilter, String businessTypeFilter, 
                                                  String keyword, int page, int pageSize) throws SQLException {
        List<Bookings> bookings = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sql = new StringBuilder(
            "SELECT b.*, bus.name AS business_name, bus.type AS business_type, bus.address AS business_address, "
            + "u.full_name AS user_name, u.email AS user_email "
            + "FROM bookings b "
            + "LEFT JOIN businesses bus ON b.business_id = bus.business_id "
            + "LEFT JOIN users u ON b.user_id = u.user_id "
            + "WHERE 1=1 "
        );
        
        List<Object> params = new ArrayList<>();
        
        if (statusFilter != null && !statusFilter.isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
            sql.append(" AND b.status = ? ");
            params.add(statusFilter);
        }
        
        if (businessTypeFilter != null && !businessTypeFilter.isEmpty() && !"all".equalsIgnoreCase(businessTypeFilter)) {
            sql.append(" AND bus.type = ? ");
            params.add(businessTypeFilter);
        }
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (b.booking_code LIKE ? OR b.booker_name LIKE ? OR b.booker_email LIKE ? OR b.booker_phone LIKE ? OR bus.name LIKE ?) ");
            String likeKey = "%" + keyword.trim() + "%";
            params.add(likeKey);
            params.add(likeKey);
            params.add(likeKey);
            params.add(likeKey);
            params.add(likeKey);
        }
        
        sql.append(" ORDER BY b.created_at DESC LIMIT ? OFFSET ? ");
        params.add(pageSize);
        params.add(offset);
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bookings booking = new Bookings();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setBookingCode(rs.getString("booking_code"));
                    
                    Users user = new Users();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("user_name"));
                    user.setEmail(rs.getString("user_email"));
                    booking.setUser(user);
                    
                    int businessId = rs.getInt("business_id");
                    if (!rs.wasNull() && businessId > 0) {
                        Businesses business = new Businesses();
                        business.setBusinessId(businessId);
                        business.setName(rs.getString("business_name"));
                        business.setType(rs.getString("business_type"));
                        business.setAddress(rs.getString("business_address"));
                        booking.setBusiness(business);
                    }
                    
                    booking.setBookerName(rs.getString("booker_name"));
                    booking.setBookerEmail(rs.getString("booker_email"));
                    booking.setBookerPhone(rs.getString("booker_phone"));
                    booking.setNumGuests(rs.getInt("num_guests"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setPaidAmount(rs.getBigDecimal("paid_amount"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setNotes(rs.getString("notes"));
                    booking.setStatus(rs.getString("status"));
                    
                    booking.setReservationStartTime(rs.getObject("reservation_start_time", LocalDateTime.class));
                    booking.setReservationEndTime(rs.getObject("reservation_end_time", LocalDateTime.class));
                    booking.setReservation_date(rs.getObject("reservation_date", LocalDateTime.class));
                    booking.setReservation_time(rs.getObject("reservation_time", LocalDateTime.class));
                    
                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }
    
    /**
     * Đếm tổng số booking cho admin với filter
     */
    public int countAllBookingsForAdmin(String statusFilter, String businessTypeFilter, String keyword) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM bookings b "
            + "LEFT JOIN businesses bus ON b.business_id = bus.business_id "
            + "WHERE 1=1 "
        );
        
        List<Object> params = new ArrayList<>();
        
        if (statusFilter != null && !statusFilter.isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
            sql.append(" AND b.status = ? ");
            params.add(statusFilter);
        }
        
        if (businessTypeFilter != null && !businessTypeFilter.isEmpty() && !"all".equalsIgnoreCase(businessTypeFilter)) {
            sql.append(" AND bus.type = ? ");
            params.add(businessTypeFilter);
        }
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (b.booking_code LIKE ? OR b.booker_name LIKE ? OR b.booker_email LIKE ? OR b.booker_phone LIKE ? OR bus.name LIKE ?) ");
            String likeKey = "%" + keyword.trim() + "%";
            params.add(likeKey);
            params.add(likeKey);
            params.add(likeKey);
            params.add(likeKey);
            params.add(likeKey);
        }
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Tạo booking homestay với room transaction
     */
    public int createHomestayBookingTransaction(Bookings booking, int roomId, BigDecimal pricePerNight) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert booking
            int bookingId = insertBooking(conn, booking);
            if (bookingId == -1) {
                conn.rollback();
                return -1;
            }
            booking.setBookingId(bookingId);

            // 2. Insert booked room
            if (!insertBookedRoom(conn, bookingId, roomId, pricePerNight)) {
                conn.rollback();
                return -1;
            }

            // 3. Block room availability
            LocalDate checkIn = booking.getReservationDate();
            LocalDate checkOut = booking.getReservationEndTime() != null ? 
                booking.getReservationEndTime().toLocalDate() : checkIn.plusDays(1);
            blockRoomAvailability(conn, roomId, checkIn, checkOut, pricePerNight);

            // 4. Create initial payment
            if (!createInitialPayment(conn, bookingId, booking.getTotalPrice(), "sepay", booking.getBookingCode())) {
                conn.rollback();
                return -1;
            }
            
            conn.commit();
            System.out.println("[BookingDAO] ✅ Created homestay booking: " + booking.getBookingCode());
            return bookingId;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Lấy thời gian tạo booking từ database
     */
    public LocalDateTime getBookingCreatedTime(int bookingId) {
        String sql = "SELECT created_at FROM bookings WHERE booking_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getObject("created_at", LocalDateTime.class);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy danh sách bookings cho owner (restaurant)
     */
    public List<model.dto.BookingsDTO> getBookingsForOwner(int businessId) {
        List<model.dto.BookingsDTO> bookings = new ArrayList<>();
        String sql = "SELECT b.booking_code, b.booker_name, b.booker_email, b.booker_phone, " +
                     "b.num_guests, b.total_price, b.payment_status, " +
                     "b.reservation_date, b.reservation_time, " +
                     "GROUP_CONCAT(DISTINCT t.name SEPARATOR ', ') as table_name " +
                     "FROM bookings b " +
                     "LEFT JOIN booked_tables bt ON b.booking_id = bt.booking_id " +
                     "LEFT JOIN tables t ON bt.table_id = t.table_id " +
                     "WHERE b.business_id = ? " +
                     "GROUP BY b.booking_id " +
                     "ORDER BY b.created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.dto.BookingsDTO dto = new model.dto.BookingsDTO();
                    dto.setBookingCode(rs.getString("booking_code"));
                    dto.setBookerName(rs.getString("booker_name"));
                    dto.setBookerEmail(rs.getString("booker_email"));
                    dto.setBookerPhone(rs.getString("booker_phone"));
                    dto.setNumGuests(rs.getInt("num_guests"));
                    dto.setTotalPrice(rs.getBigDecimal("total_price"));
                    dto.setPaymentStatus(rs.getString("payment_status"));
                    
                    java.sql.Date resDate = rs.getDate("reservation_date");
                    if (resDate != null) {
                        dto.setReservationDate(resDate.toLocalDate());
                    }
                    
                    java.sql.Time resTime = rs.getTime("reservation_time");
                    if (resTime != null) {
                        dto.setReservationTime(resTime.toLocalTime());
                    }
                    
                    dto.setTableName(rs.getString("table_name"));
                    bookings.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    /**
     * Lấy danh sách bookings với bộ lọc cho owner (restaurant)
     */
    public List<model.dto.BookingsDTO> getFilteredBookingsForOwner(int businessId, 
            LocalDate reservationDate, LocalTime reservationTime, Integer numGuests, 
            String status, String searchCode) {
        List<model.dto.BookingsDTO> bookings = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
            "SELECT b.booking_code, b.booker_name, b.booker_email, b.booker_phone, " +
            "b.num_guests, b.total_price, b.payment_status, " +
            "b.reservation_date, b.reservation_time, " +
            "GROUP_CONCAT(DISTINCT t.name SEPARATOR ', ') as table_name " +
            "FROM bookings b " +
            "LEFT JOIN booked_tables bt ON b.booking_id = bt.booking_id " +
            "LEFT JOIN tables t ON bt.table_id = t.table_id " +
            "WHERE b.business_id = ? "
        );
        
        List<Object> params = new ArrayList<>();
        params.add(businessId);
        
        if (reservationDate != null) {
            sql.append(" AND DATE(b.reservation_date) = ? ");
            params.add(reservationDate);
        }
        
        if (reservationTime != null) {
            sql.append(" AND TIME(b.reservation_time) = ? ");
            params.add(reservationTime);
        }
        
        if (numGuests != null) {
            sql.append(" AND b.num_guests = ? ");
            params.add(numGuests);
        }
        
        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("all")) {
            sql.append(" AND b.status = ? ");
            params.add(status);
        }
        
        if (searchCode != null && !searchCode.trim().isEmpty()) {
            sql.append(" AND b.booking_code LIKE ? ");
            params.add("%" + searchCode.trim() + "%");
        }
        
        sql.append(" GROUP BY b.booking_id ORDER BY b.created_at DESC");
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.dto.BookingsDTO dto = new model.dto.BookingsDTO();
                    dto.setBookingCode(rs.getString("booking_code"));
                    dto.setBookerName(rs.getString("booker_name"));
                    dto.setBookerEmail(rs.getString("booker_email"));
                    dto.setBookerPhone(rs.getString("booker_phone"));
                    dto.setNumGuests(rs.getInt("num_guests"));
                    dto.setTotalPrice(rs.getBigDecimal("total_price"));
                    dto.setPaymentStatus(rs.getString("payment_status"));
                    
                    java.sql.Date resDate = rs.getDate("reservation_date");
                    if (resDate != null) {
                        dto.setReservationDate(resDate.toLocalDate());
                    }
                    
                    java.sql.Time resTime = rs.getTime("reservation_time");
                    if (resTime != null) {
                        dto.setReservationTime(resTime.toLocalTime());
                    }
                    
                    dto.setTableName(rs.getString("table_name"));
                    bookings.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    /**
     * Overload insertBookedRoom để dùng với Connection
     */
    private boolean insertBookedRoom(Connection conn, int bookingId, int roomId, BigDecimal price) throws SQLException {
        String sql = "INSERT INTO booked_rooms (booking_id, room_id, price_at_booking) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, roomId);
            ps.setBigDecimal(3, price);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Overload blockRoomAvailability để dùng với Connection
     */
    private void blockRoomAvailability(Connection conn, int roomId, LocalDate checkIn, LocalDate checkOut, BigDecimal price) throws SQLException {
        String sql = "INSERT INTO room_availability (room_id, date, price, status) VALUES (?, ?, ?, 'booked') " +
                     "ON DUPLICATE KEY UPDATE status = 'booked'"; 
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (LocalDate date = checkIn; date.isBefore(checkOut); date = date.plusDays(1)) {
                ps.setInt(1, roomId);
                ps.setDate(2, java.sql.Date.valueOf(date));
                ps.setBigDecimal(3, price);
                ps.addBatch(); 
            }
            ps.executeBatch();
        }
    }
    
}