/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.dto.BookingHistoryDTO;
import util.DBUtil;
/**
 *
 * @author jackd
 */
public class BookingDAO {
    /**
     * Lấy lịch sử đặt chỗ (cả homestay và nhà hàng) của một user
     * @param userId ID của người dùng
     * @return Danh sách các DTO Lịch sử Booking
     */
    public List<BookingHistoryDTO> getBookingHistoryByUserId(int userId) {
        List<BookingHistoryDTO> list = new ArrayList<>();
        
        // Câu SQL JOIN 4 bảng
        String sql = "SELECT "
                   + "b.booking_id, b.total_price, b.status, b.created_at, "
                   + "biz.name AS business_name, biz.image AS business_image, biz.type AS business_type, "
                   + "br.check_in_date, br.check_out_date, "
                   + "bt.reservation_date, bt.reservation_time "
                   + "FROM bookings b "
                   + "JOIN businesses biz ON b.business_id = biz.business_id "
                   + "LEFT JOIN booked_rooms br ON b.booking_id = br.booking_id "
                   + "LEFT JOIN booked_tables bt ON b.booking_id = bt.booking_id "
                   + "WHERE b.user_id = ? "
                   + "ORDER BY b.created_at DESC"; // Sắp xếp mới nhất lên đầu

        // Dùng try-with-resources (giống BusinessDAO)
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BookingHistoryDTO dto = new BookingHistoryDTO();

                // 1. Lấy từ Bookings & Businesses (luôn có)
                dto.setBookingId(rs.getInt("booking_id"));
                dto.setTotalPrice(rs.getBigDecimal("total_price"));
                dto.setStatus(rs.getString("status"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setBusinessName(rs.getString("business_name"));
                dto.setBusinessImage(rs.getString("business_image"));
                dto.setBusinessType(rs.getString("business_type"));

                // 2. Lấy từ BookedRooms (có thể null)
                // Dùng getObject để tránh lỗi nếu giá trị là NULL
                if (rs.getObject("check_in_date") != null) {
                    dto.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
                }
                if (rs.getObject("check_out_date") != null) {
                    dto.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
                }

                // 3. Lấy từ BookedTables (có thể null)
                if (rs.getObject("reservation_date") != null) {
                    dto.setReservationDate(rs.getDate("reservation_date").toLocalDate());
                }
                if (rs.getObject("reservation_time") != null) {
                    dto.setReservationTime(rs.getTime("reservation_time").toLocalTime());
                }

                list.add(dto);
            }
        } catch (SQLException e) {
            System.out.println("[BookingDAO] Lỗi khi lấy lịch sử booking: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("[BookingDAO] Tìm thấy " + list.size() + " booking cho user " + userId);
        return list;
    }
}
