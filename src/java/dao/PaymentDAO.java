package dao;

import model.Payments;
import util.DBUtil;
import java.sql.*;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class PaymentDAO {

    /**
     * Tạo payment mới
     */
    public int createPayment(Payments payment) throws SQLException {
        String sql = "INSERT INTO payments (booking_id, amount, payment_method, status, gateway_response, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getBookingId());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getStatus());
            ps.setString(5, payment.getGatewayResponse());
            ps.setObject(6, LocalDateTime.now());

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

    /**
     * Update payment status
     */
    public int updatePaymentStatus(int paymentId, String status, String transactionCode,
            String gatewayResponse, LocalDateTime paidAt) throws SQLException {
        String sql = "UPDATE payments SET status = ?, transaction_code = ?, gateway_response = ?, "
                + "paid_at = ? WHERE payment_id = ?";
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setString(2, transactionCode);
                ps.setString(3, gatewayResponse);
                if (paidAt != null) {
                    ps.setObject(4, paidAt);
                } else {
                    ps.setNull(4, Types.TIMESTAMP);
                }
                ps.setInt(5, paymentId);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    syncBookingFromPayment(conn, paymentId, status);
                    conn.commit();
                    System.out.println("[PaymentDAO] ✅ Updated payment " + paymentId + " to " + status);
                } else {
                    conn.rollback();
                }
                return rows;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
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
     * Sync booking status khi payment thay đổi
     */
    private void syncBookingFromPayment(Connection conn, int paymentId, String paymentStatus) throws SQLException {
        String getBookingSql = "SELECT booking_id FROM payments WHERE payment_id = ?";
        int bookingId = -1;
        try (PreparedStatement psGet = conn.prepareStatement(getBookingSql)) {
            psGet.setInt(1, paymentId);
            try (ResultSet rs = psGet.executeQuery()) {
                if (rs.next()) {
                    bookingId = rs.getInt("booking_id");
                }
            }
        }

        if (bookingId == -1) {
            return;
        }

        String newBookingStatus;
        String newPaymentStatus;
        switch (paymentStatus) {
            case "pending":
                newBookingStatus = "pending";
                newPaymentStatus = "unpaid";
                break;
            case "completed":
                newBookingStatus = "confirmed";
                newPaymentStatus = "fully_paid";
                break;
            case "failed":
                newBookingStatus = "pending";
                newPaymentStatus = "unpaid";
                break;
            case "refunded":
                newBookingStatus = "cancelled_by_owner";
                newPaymentStatus = "refunded";
                break;
            default:
                newBookingStatus = "pending";
                newPaymentStatus = "unpaid";
        }

        String updateBookingSql = "UPDATE bookings SET payment_status = ?, status = ? WHERE booking_id = ?";
        try (PreparedStatement psUpdate = conn.prepareStatement(updateBookingSql)) {
            psUpdate.setString(1, newPaymentStatus);
            psUpdate.setString(2, newBookingStatus);
            psUpdate.setInt(3, bookingId);
            psUpdate.executeUpdate();
        }
    }

    /**
     * Lấy tất cả payments của booking
     */
    public List<Payments> getPaymentsByBookingId(int bookingId) throws SQLException {
        List<Payments> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE booking_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payments p = new Payments();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setBookingId(rs.getInt("booking_id"));
                    p.setAmount(rs.getBigDecimal("amount"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setStatus(rs.getString("status"));
                    p.setTransactionCode(rs.getString("transaction_code"));
                    p.setGatewayResponse(rs.getString("gateway_response"));
                    p.setPaidAt(rs.getObject("paid_at", LocalDateTime.class));
                    p.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                    payments.add(p);
                }
            }
        }
        return payments;
    }

    /**
     * Lấy payment_id theo booking_code (dùng cho webhook)
     */
    public Integer getPaymentIdByBookingCode(String bookingCode) throws SQLException {
        if (bookingCode == null || bookingCode.trim().isEmpty()) {
            return null;
        }

        String normalizedCode = bookingCode.trim().toUpperCase();
        String sql = "SELECT p.payment_id "
                + "FROM payments p "
                + "JOIN bookings b ON p.booking_id = b.booking_id "
                + "WHERE UPPER(b.booking_code) = ? "
                + "  AND p.payment_method = 'sepay' "
                + "  AND p.status = 'pending' "
                + "ORDER BY p.created_at DESC "
                + "LIMIT 1";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, normalizedCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("payment_id");
                }
            }
        }
        return null;
    }
}
