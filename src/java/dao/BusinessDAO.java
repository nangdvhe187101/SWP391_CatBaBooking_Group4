/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Businesses;
import model.Users;
import model.Areas;
import util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import model.dto.BusinessesDTO;

/**
 *
 * @author ADMIN
 */
public class BusinessDAO {

    public boolean registerBusiness(Businesses biz) {
        String sql = "INSERT INTO businesses (owner_id, name, type, address, description, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
                biz.setStatus(rs.getString("status"));
                biz.setClosingHour(rs.getObject("closing_hour", LocalTime.class));
                biz.setOpeningHour(rs.getObject("opening_hour", LocalTime.class));
                biz.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                biz.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));
                biz.setImage(rs.getString("image"));
                return biz;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //Hàm Dao chức năng RestaurantSettings
    public int updateBusinessSettingsByOwnerId(int ownerId, String name, String address, String description, String image, Integer areaId, LocalTime closingHour, LocalTime openingHour)
            throws SQLException {
        String sql = "UPDATE businesses "
                + "SET name=?, address=?, description=?, image=?, area_id=?, "
                + "opening_hour=?, closing_hour=?, updated_at=? "
                + "WHERE owner_id=?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, description);
            ps.setString(4, image);
            if (areaId == null) {
                ps.setNull(5, java.sql.Types.INTEGER);
            } else {
                ps.setInt(5, areaId);
            }
            if (openingHour == null) {
                ps.setNull(6, java.sql.Types.TIME);
            } else {
                ps.setObject(6, openingHour);
            }
            if (closingHour == null) {
                ps.setNull(7, java.sql.Types.TIME);
            } else {
                ps.setObject(7, closingHour);
            }
            
            ps.setObject(8, LocalDateTime.now()); 
            ps.setInt(9, ownerId);               
            
            return ps.executeUpdate();
        }
    }

//lấy ds nhà hàng
    public List<BusinessesDTO> getAllRestaurants() {
        List<BusinessesDTO> restaurants = new ArrayList<>();
        String sql = "SELECT b.business_id, b.owner_id, b.name, b.address, b.description, "
                + "b.image, b.avg_rating, b.review_count, b.status, "
                + "a.area_id, a.name AS area_name, u.user_id, u.full_name AS owner_name "
                + "FROM businesses b "
                + "LEFT JOIN areas a ON b.area_id = a.area_id "
                + "JOIN users u ON b.owner_id = u.user_id "
                + "WHERE b.type = 'restaurant' AND b.status = 'active'";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BusinessesDTO restaurant = new BusinessesDTO();
                restaurant.setBusinessId(rs.getInt("business_id"));
                restaurant.setName(rs.getString("name"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setDescription(rs.getString("description"));
                restaurant.setImage(rs.getString("image"));
                restaurant.setAvgRating(rs.getBigDecimal("avg_rating"));
                restaurant.setReviewCount(rs.getInt("review_count"));
                restaurant.setStatus(rs.getString("status"));

                Areas area = new Areas();
                area.setAreaId(rs.getInt("area_id"));
                area.setName(rs.getString("area_name"));
                restaurant.setArea(area);

                Users owner = new Users();
                owner.setUserId(rs.getInt("user_id"));
                owner.setFullName(rs.getString("owner_name"));
                restaurant.setOwner(owner);

                // Lấy danh sách loại ẩm thực
                restaurant.setCuisines(getCuisinesForRestaurant(restaurant.getBusinessId()));

                restaurants.add(restaurant);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return restaurants;
    }

    // Lấy danh sách loại ẩm thực cho một nhà hàng
    private List<String> getCuisinesForRestaurant(int businessId) throws SQLException {
        List<String> cuisines = new ArrayList<>();
        String sql = "SELECT ct.name "
                + "FROM business_cuisines bc "
                + "JOIN cuisine_types ct ON bc.cuisine_id = ct.cuisine_id "
                + "WHERE bc.business_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, businessId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    cuisines.add(rs.getString("name"));
                }
            }
        }
        return cuisines;
    }

}
