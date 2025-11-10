/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.RestaurantTables;
import model.Businesses;
import util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import service.RestaurantTableValidator;
import java.time.LocalDate;
import java.time.LocalTime;
import java.sql.*;

/**
 *
 * @author ADMIN
 */
public class RestaurantTableDAO {

    
    private static final int SLOT_HOURS = 2;

    public RestaurantTables findSuitableTableForPreview(int businessId, int numGuests, LocalDate date, LocalTime time) {
        String sql = """
            SELECT rt.table_id, rt.name, rt.capacity 
            FROM restaurant_tables rt
            WHERE rt.business_id = ? AND rt.is_active = true
              AND rt.capacity >= ?
              AND NOT EXISTS (
                SELECT 1 FROM table_availability booked 
                WHERE booked.table_id = rt.table_id 
                  AND booked.reservation_date = ?
                  AND booked.status IN ('booked', 'blocked')
                  AND (
                    (booked.reservation_time < ? AND booked.reservation_time + INTERVAL ? HOUR > ?) OR
                    (booked.reservation_time >= ? AND booked.reservation_time < ?)
                  )
              )
            ORDER BY rt.capacity ASC  -- Ưu tiên bàn nhỏ nhất
            LIMIT 1
            """;
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            LocalTime endTime = time.plusHours(SLOT_HOURS);
            ps.setInt(1, businessId);
            ps.setInt(2, numGuests);
            ps.setObject(3, date);
            ps.setObject(4, time);
            ps.setInt(5, SLOT_HOURS);
            ps.setObject(6, time);
            ps.setObject(7, time);
            ps.setObject(8, endTime);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RestaurantTables table = new RestaurantTables();
                    table.setTableId(rs.getInt("table_id"));
                    table.setName(rs.getString("name"));
                    table.setCapacity(rs.getInt("capacity"));
                    return table;  
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; 
    }

    public int assignTableToBooking(int bookingId, int businessId, int numGuests, LocalDate date, LocalTime time) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); 
            RestaurantTables table = findSuitableTableForPreview(businessId, numGuests, date, time);
            if (table == null) {  
                throw new SQLException("No suitable table available");
            }
            int tableId = table.getTableId();
            String insertBookedSql = "INSERT INTO booked_tables (booking_id, table_id) VALUES (?, ?)";
            try (PreparedStatement psBooked = conn.prepareStatement(insertBookedSql, Statement.RETURN_GENERATED_KEYS)) {
                psBooked.setInt(1, bookingId);
                psBooked.setInt(2, tableId);
                int result = psBooked.executeUpdate();
                if (result == 0) {
                    throw new SQLException("Failed to create booked_table");
                }
                try (ResultSet rs = psBooked.getGeneratedKeys()) {
                    if (rs.next()) {
                        int bookedTableId = rs.getInt(1);
                        LocalTime endTime = time.plusHours(SLOT_HOURS);
                        String updateAvailSql = """
                            UPDATE table_availability 
                            SET status = 'booked' 
                            WHERE table_id = ? AND reservation_date = ? AND reservation_time = ?
                            """;
                        try (PreparedStatement ps = conn.prepareStatement(updateAvailSql)) {
                            ps.setInt(1, tableId);
                            ps.setObject(2, date);
                            ps.setObject(3, time);
                            int availResult = ps.executeUpdate();
                            if (availResult == 0) {
                                String insertAvailSql = "INSERT INTO table_availability (table_id, reservation_date, reservation_time, status) VALUES (?, ?, ?, 'booked')";
                                try (PreparedStatement psInsertAvail = conn.prepareStatement(insertAvailSql)) {
                                    psInsertAvail.setInt(1, tableId);
                                    psInsertAvail.setObject(2, date);
                                    psInsertAvail.setObject(3, time);
                                    psInsertAvail.executeUpdate();
                                }
                            }
                            conn.commit();
                            return bookedTableId;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
        return numGuests;  
    }
    public List<RestaurantTables> getAllByBusinessId(int businessId) {
        List<RestaurantTables> tables = new ArrayList<>();
        String sql = "SELECT * FROM restaurant_tables WHERE business_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RestaurantTables table = new RestaurantTables();
                table.setTableId(rs.getInt("table_id"));
                Businesses business = new Businesses();
                business.setBusinessId(businessId);
                table.setBusiness(business);
                table.setName(rs.getString("name"));
                table.setCapacity(rs.getInt("capacity"));
                table.setActive(rs.getBoolean("is_active"));
                tables.add(table);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tables;
    }

    public int insertTables(RestaurantTables table) {
        String sql = "INSERT INTO restaurant_tables (business_id, name, capacity, is_active) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, table.getBusiness().getBusinessId());
            ps.setString(2, table.getName());
            ps.setInt(3, table.getCapacity());
            ps.setBoolean(4, table.isActive());
            int rows = ps.executeUpdate();
            return rows;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int updateTables(RestaurantTables table) {
        String sql = "UPDATE restaurant_tables SET name = ?, capacity = ?, is_active = ? WHERE table_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, table.getName());
            ps.setInt(2, table.getCapacity());
            ps.setBoolean(3, table.isActive());
            ps.setInt(4, table.getTableId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int deleteTables(int tableId) {
        String sql = "DELETE FROM restaurant_tables WHERE table_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tableId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public RestaurantTables getByIdTable(int tableId) {
        String sql = "SELECT * FROM restaurant_tables WHERE table_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tableId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                RestaurantTables table = new RestaurantTables();
                table.setTableId(rs.getInt("table_id"));
                Businesses busines = new Businesses();
                busines.setBusinessId(rs.getInt("business_id"));
                table.setName(rs.getString("name"));
                table.setCapacity(rs.getInt("capacity"));
                table.setActive(rs.getBoolean("is_active"));
                return table;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isNameExists(String name, int businessId, Integer excludeTableId) {
        String sql = "SELECT COUNT(*) FROM restaura"
                + "nt_tables WHERE name = ? AND business_id = ?";
        if (excludeTableId != null) {
            sql += " AND table_id != ?";
        }
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            ps.setInt(2, businessId);
            if (excludeTableId != null) {
                ps.setInt(3, excludeTableId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}