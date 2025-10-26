/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import model.Businesses;
import model.Users;
import util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Areas;
import java.sql.Timestamp;

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
                biz.setImage(rs.getString("image"));
                return biz;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //Hàm Dao chức năng RestaurantSettings
    public int updateBusinessSettingsByOwnerId(int ownerId, String name, String address, String description, String image, Integer areaId)
            throws SQLException {
        String sql = "UPDATE businesses "
                + "SET name=?, address=?, description=?, image=?, area_id=?, updated_at=? "
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
            ps.setObject(6, LocalDateTime.now());
            ps.setInt(7, ownerId);
            return ps.executeUpdate();
        }
    }

    //Lấy danh sách các cơ sở kinh doanh (Homestay) theo ID của chủ sở hữu.
    public List<Businesses> getBusinessesByOwnerIdAndType(int ownerId, String type) {
        List<Businesses> list = new ArrayList<>();

        // Câu SQL JOIN với bảng 'areas' để lấy tên khu vực
        String sql = "SELECT b.*, a.name AS area_name "
                   + "FROM businesses b "
                   + "LEFT JOIN areas a ON b.area_id = a.area_id "
                   + "WHERE b.owner_id = ? AND b.type = ?";
        // DÒNG DEBUG 1: Kiểm tra xem phương thức có được gọi với đúng tham số không
        System.out.println("[BusinessDAO] Đang tìm homestay cho owner_id = " + ownerId + " VÀ type = " + type);

        // 1. Dùng try-with-resources (giống code mẫu của bạn)
        // conn và ps sẽ được tự động đóng, không cần 'finally'
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ownerId);
            ps.setString(2, type);

            // ResultSet sẽ tự động đóng khi PreparedStatement (ps) đóng
            ResultSet rs = ps.executeQuery();

            // 2. Lặp qua tất cả kết quả
            while (rs.next()) {

                // 3. Dùng style Setter (giống code mẫu của bạn)
                Businesses biz = new Businesses();

                // 4. Tạo và set đối tượng Users lồng nhau (giống code mẫu)
                Users owner = new Users();
                owner.setUserId(rs.getInt("owner_id"));
                biz.setOwner(owner);

                // 5. Tạo và set đối tượng Areas lồng nhau (phần mở rộng)
                Areas area = new Areas(rs.getInt("area_id"), rs.getString("area_name"));
                biz.setArea(area); // Gán đối tượng khu vực

                // 6. Set các trường còn lại
                biz.setBusinessId(rs.getInt("business_id"));
                biz.setName(rs.getString("name"));
                biz.setType(rs.getString("type"));
                biz.setAddress(rs.getString("address"));
                biz.setDescription(rs.getString("description"));
                biz.setPricePerNight(rs.getBigDecimal("price_per_night"));
                biz.setCapacity(rs.getInt("capacity"));
                biz.setNumBedrooms(rs.getInt("num_bedrooms"));
                biz.setStatus(rs.getString("status"));

                // 7. Lấy Timestamp (phổ biến) hoặc LocalDateTime (như code mẫu)
                biz.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                biz.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));

                list.add(biz);
            }
        } catch (Exception e) { // Bắt Exception chung
            System.out.println("[BusinessDAO] LỖI SQL: " + e.getMessage());
            e.printStackTrace();
        }
        // DÒNG DEBUG 2: Kiểm tra xem DAO tìm thấy bao nhiêu homestay
        System.out.println("[BusinessDAO] Đã tìm thấy " + list.size() + " homestay.");

        // 8. Không cần khối 'finally'
        return list;
    }

    public boolean updateHomestay(int id, String name, String address,
        String description, BigDecimal pricePerNight,
        int capacity, int numBedrooms, int areaId, int ownerId) {

        // Câu SQL UPDATE, cập nhật tất cả các trường
        // Thêm điều kiện AND owner_id = ? để bảo mật
        String sql = "UPDATE businesses SET "
                + "name = ?, "
                + "address = ?, "
                + "description = ?, "
                + "price_per_night = ?, "
                + "capacity = ?, "
                + "num_bedrooms = ?, "
                + "area_id = ?, "
                + "updated_at = CURRENT_TIMESTAMP "
                + "WHERE business_id = ? AND owner_id = ?";

        // Dùng try-with-resources (giống phong cách code getBusinessById của bạn)
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // 1. Set các tham số cho câu lệnh SQL
            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, description);
            ps.setBigDecimal(4, pricePerNight);
            ps.setInt(5, capacity);
            ps.setInt(6, numBedrooms);
            ps.setInt(7, areaId);

            // 2. Set các tham số cho WHERE
            ps.setInt(8, id);
            ps.setInt(9, ownerId); // Tham số bảo mật

            // 3. Thực thi update và lấy số hàng bị ảnh hưởng
            int rowsAffected = ps.executeUpdate();

            // 4. Trả về true nếu có 1 hàng bị ảnh hưởng (tức là thành công)
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("[BusinessDAO] LỖI updateHomestay: " + e.getMessage());
            e.printStackTrace();
            return false; // Trả về false nếu có lỗi
        }
    }
    
}
