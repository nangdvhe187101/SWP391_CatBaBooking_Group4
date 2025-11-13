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
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.LocalTime;

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
        String sql = "SELECT b.*, a.area_id AS area_id_fk, a.name AS area_name "
                + "FROM businesses b "
                + "LEFT JOIN areas a ON b.area_id = a.area_id "
                + "WHERE b.owner_id = ?";
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
                Integer areaIdFk = rs.getInt("area_id_fk");
                if (!rs.wasNull() && areaIdFk != 0) {
                    Areas area = new Areas();
                    area.setAreaId(areaIdFk);
                    area.setName(rs.getString("area_name"));
                    biz.setArea(area);
                }

                return biz;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //Hàm Dao chức năng RestaurantSettings
    public int updateBusinessSettingsByOwnerId(int ownerId, String name, String address, String description, String image, Integer areaId, LocalTime openingHour, LocalTime closingHour)
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

    public boolean updateOwnerBusinessProfile(int ownerId, String name, String type, String address, String description, String image) {
        if (ownerId <= 0) {
            return false;
        }
        if (name == null || name.trim().isEmpty()) {
            return false;
        }
        if (type == null || type.trim().isEmpty()) {
            return false;
        }
        if (address == null || address.trim().isEmpty()) {
            return false;
        }

        String sql = "UPDATE businesses SET name = ?, type = ?, address = ?, description = ?, image = ?, updated_at = ? WHERE owner_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            ps.setString(2, type.trim());
            ps.setString(3, address.trim());
            if (description == null || description.trim().isEmpty()) {
                ps.setNull(4, java.sql.Types.VARCHAR);
            } else {
                ps.setString(4, description.trim());
            }
            if (image == null || image.trim().isEmpty()) {
                ps.setNull(5, java.sql.Types.VARCHAR);
            } else {
                ps.setString(5, image.trim());
            }
            ps.setObject(6, LocalDateTime.now());
            ps.setInt(7, ownerId);

            int updated = ps.executeUpdate();
            if (updated > 0) {
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // Nếu không có business nào trước đó, tạo mới bản ghi
        Businesses newBiz = new Businesses();
        Users owner = new Users();
        owner.setUserId(ownerId);
        newBiz.setOwner(owner);
        newBiz.setName(name);
        newBiz.setType(type);
        newBiz.setAddress(address);
        newBiz.setDescription(description);
        newBiz.setImage(image);
        newBiz.setCreatedAt(LocalDateTime.now());
        newBiz.setUpdatedAt(LocalDateTime.now());
        return registerBusiness(newBiz);
    }

    public int countActiveBusinesses() {
        String sql = "SELECT COUNT(*) FROM businesses WHERE status = 'active'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countPendingBusinesses() {
        String sql = "SELECT COUNT(*) FROM businesses WHERE status = 'pending'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
