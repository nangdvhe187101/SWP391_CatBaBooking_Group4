/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Bookings;
import model.Users;
import model.Businesses;
import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

   
    public List<Bookings> getBookingsByUserId(int userId) {
        List<Bookings> bookingList = new ArrayList<>();
        
     
        String sql = "SELECT b.*, biz.name as business_name, biz.address as business_address "
                   + "FROM Bookings b "
                   + "JOIN Businesses biz ON b.business_id = biz.business_id "
                   + "WHERE b.user_id = ? "
                   + "ORDER BY b.reservation_start_time DESC"; // Sắp xếp theo ngày đặt

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Bookings booking = new Bookings();
                
          
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setBookingCode(rs.getString("booking_code"));
                booking.setBookerName(rs.getString("booker_name"));
                booking.setNumGuests(rs.getInt("num_guests"));
                booking.setTotalPrice(rs.getBigDecimal("total_price"));
                booking.setPaymentStatus(rs.getString("payment_status"));
                booking.setStatus(rs.getString("status"));
                booking.setReservationStartTime(rs.getObject("reservation_start_time", LocalDateTime.class));
                booking.setReservationEndTime(rs.getObject("reservation_end_time", LocalDateTime.class));

           
                Users user = new Users();
                user.setUserId(rs.getInt("user_id"));
                booking.setUser(user);

            
                Businesses business = new Businesses();
                business.setBusinessId(rs.getInt("business_id"));
                business.setName(rs.getString("business_name"));
                business.setAddress(rs.getString("business_address"));
                booking.setBusiness(business);
                
                bookingList.add(booking);
            }
            
        } catch (SQLException e) {
            e.printStackTrace(); // Luôn kiểm tra lỗi console
        }
        
        return bookingList;
    }
}
    
