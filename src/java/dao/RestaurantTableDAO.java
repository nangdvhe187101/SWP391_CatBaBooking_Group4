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

/**
 *
 * @author ADMIN
 */
public class RestaurantTableDAO {

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
