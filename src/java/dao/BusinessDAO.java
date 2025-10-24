/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Businesses;
import model.Users;
import util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.time.LocalDateTime;
/**
 *
 * @author ADMIN
 */
public class BusinessDAO {

    public boolean registerBusiness(Businesses biz) {
        String sql = "INSERT INTO businesses (owner_id, name, type, address, description, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); 
                PreparedStatement ps = conn.prepareStatement(sql)) {

            if (biz == null || biz.getOwner() == null || biz.getOwner().getUserId() <= 0) {
                return false;
            }

            ps.setInt(1, biz.getOwner().getUserId());
            ps.setString(2, biz.getName());
            ps.setString(3, biz.getType());
            ps.setString(4, biz.getAddress());
            ps.setString(5, biz.getDescription());
            ps.setString(6, "pending"); // Set status to pending
            ps.setObject(7, LocalDateTime.now());
            ps.setObject(8, LocalDateTime.now());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateBusinessStatus(int ownerId, String newStatus) {
        String sql = "UPDATE businesses SET status = ?, updated_at = ? WHERE owner_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setObject(2, LocalDateTime.now());
            ps.setInt(3, ownerId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Businesses getBusinessByOwnerId(int ownerId) {
        String sql = "SELECT * FROM businesses WHERE owner_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Users owner = new Users(); 
                owner.setUserId(ownerId);
                Businesses biz = new Businesses(); 
                biz.setBusinessId(rs.getInt("business_id"));
                biz.setOwner(owner);
                biz.setName(rs.getString("name"));
                biz.setType(rs.getString("type"));
                biz.setAddress(rs.getString("address"));
                biz.setDescription(rs.getString("description"));
                biz.setImage(rs.getString("image"));
                biz.setPricePerNight(rs.getBigDecimal("price_per_night"));
                biz.setCapacity(rs.getInt("capacity"));
                biz.setNumBedrooms(rs.getInt("num_bedrooms"));
                biz.setStatus(rs.getString("status"));
                biz.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                biz.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));
                return biz;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateBusinessProfile(int businessId, String name, String address, String description, 
                                       String image, java.math.BigDecimal pricePerNight, 
                                       Integer capacity, Integer numBedrooms) {
        String sql = "UPDATE businesses SET name = ?, address = ?, description = ?, image = ?, " +
                    "price_per_night = ?, capacity = ?, num_bedrooms = ?, updated_at = ? " +
                    "WHERE business_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, description);
            ps.setString(4, image);
            ps.setBigDecimal(5, pricePerNight);
            ps.setInt(6, capacity);
            ps.setInt(7, numBedrooms);
            ps.setObject(8, LocalDateTime.now());
            ps.setInt(9, businessId);
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Businesses getBusinessById(int businessId) {
        String sql = "SELECT * FROM businesses WHERE business_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Users owner = new Users(); 
                owner.setUserId(rs.getInt("owner_id"));
                Businesses biz = new Businesses(); 
                biz.setBusinessId(rs.getInt("business_id"));
                biz.setOwner(owner);
                biz.setName(rs.getString("name"));
                biz.setType(rs.getString("type"));
                biz.setAddress(rs.getString("address"));
                biz.setDescription(rs.getString("description"));
                biz.setImage(rs.getString("image"));
                biz.setPricePerNight(rs.getBigDecimal("price_per_night"));
                biz.setCapacity(rs.getInt("capacity"));
                biz.setNumBedrooms(rs.getInt("num_bedrooms"));
                biz.setStatus(rs.getString("status"));
                biz.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                biz.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));
                return biz;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}