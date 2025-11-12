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
import model.Users;
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
                + "num_guests, total_price, paid_amount, payment_status, notes, reservation_date, reservation_time, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
            ps.setString(14, booking.getStatus());

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
        String sql = "SELECT * FROM bookings WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bookings b = new Bookings();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setBookingCode(rs.getString("booking_code"));
                    bookings.add(b);
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
}
