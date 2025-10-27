/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Timestamp;
import java.sql.Date;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Amenities;
import model.Businesses;
import model.Areas;
import model.Users;
import util.DBUtil;

/**
 *
 * @author Admin
 */
public class HomestayDAO {

    public List<Businesses> getAllHomestay() {
        List<Businesses> homestays = new ArrayList<>();
         String sql = "SELECT b.business_id, b.name, b.address, b.description, b.image, b.avg_rating, b.review_count, "
                + "b.capacity, b.num_bedrooms, b.price_per_night, b.status, b.created_at, b.updated_at, "
                + "a.area_id, a.name AS area_name, u.user_id, u.full_name AS owner_name "
                + "FROM businesses b "
                + "JOIN areas a ON b.area_id = a.area_id "
                + "JOIN users u ON b.owner_id = u.user_id " 
                + "WHERE EXISTS ( " 
                + "    SELECT 1 "
                + "    FROM rooms r "
                + "    WHERE r.business_id = b.business_id "
                + ") AND b.status = 'active' "; 


        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Businesses homestay = new Businesses();
                homestay.setBusinessId(rs.getInt("business_id"));
                homestay.setName(rs.getString("name"));
                homestay.setAddress(rs.getString("address"));
                homestay.setDescription(rs.getString("description"));
                homestay.setImage(rs.getString("image"));
                homestay.setAvgRating(rs.getBigDecimal("avg_rating"));
                homestay.setReviewCount(rs.getInt("review_count"));
                homestay.setCapacity(rs.getInt("capacity"));
                homestay.setNumBedrooms(rs.getInt("num_bedrooms"));
                homestay.setPricePerNight(rs.getBigDecimal("price_per_night"));
                homestay.setStatus(rs.getString("status"));
                homestay.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                homestay.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));

                Areas area = new Areas();
                area.setAreaId(rs.getInt("area_id"));
                area.setName(rs.getString("area_name"));
                homestay.setArea(area);

                Users owner = new Users();
                owner.setUserId(rs.getInt("user_id"));
                owner.setFullName(rs.getString("owner_name"));
                homestay.setOwner(owner);

                // Lấy và cài đặt danh sách tiện nghi
                List<Amenities> amenities = getAmenitiesForHomestay(homestay.getBusinessId());
                homestay.setAmenities(amenities);

                homestays.add(homestay);
            }
        } catch (SQLException e) {
            // Xử lý ngoại lệ
            e.printStackTrace();
        }
        return homestays;
    }

    private List<Amenities> getAmenitiesForHomestay(int businessId) throws SQLException {
        List<Amenities> amenities = new ArrayList<>();
        String sql = "SELECT a.amenity_id, a.name "
                + "FROM amenities a "
                + "JOIN business_amenities ba ON a.amenity_id = ba.amenity_id "
                + "WHERE ba.business_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, businessId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Amenities amenity = new Amenities();
                amenity.setAmenityId(rs.getInt("amenity_id"));
                amenity.setName(rs.getString("name"));
                amenities.add(amenity);
            }
        }
        return amenities;
    }

    public List<Businesses> searchHomestays(int areaId, LocalDate checkIn, LocalDate checkOut, int guests) {
        List<Businesses> homestays = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT b.business_id, b.name, b.address, b.description, b.image, b.avg_rating, b.review_count, "
                + "b.capacity, b.num_bedrooms, b.price_per_night, b.status, b.created_at, b.updated_at, "
                + "a.area_id, a.name AS area_name, u.user_id, u.full_name AS owner_name "
                + "FROM businesses b "
                + "JOIN areas a ON b.area_id = a.area_id "
                + "JOIN users u ON b.owner_id = u.user_id "
                + "WHERE b.type = 'homestay' AND b.status = 'active' "
        );

        if (areaId > 0) {
            sql.append(" AND b.area_id = ?");
            params.add(areaId);
        }

        if (guests > 0) {
            sql.append(" AND EXISTS (SELECT 1 FROM rooms r WHERE r.business_id = b.business_id AND r.is_active = 1 AND r.capacity >= ?)");
            params.add(guests);
        }

        if (checkIn != null && checkOut != null) {
            sql.append(" AND NOT EXISTS ( "
                    + "    SELECT 1 FROM rooms r "
                    + "    WHERE r.business_id = b.business_id AND r.is_active = 1 "
                    + "    AND EXISTS ( "
                    + "        SELECT 1 FROM room_availability ra "
                    + "        WHERE ra.room_id = r.room_id "
                    + "        AND ra.date >= ? AND ra.date < ? "
                    + "        AND ra.status IN ('booked', 'blocked') "
                    + "    ) "
                    + ") ");
            params.add(Date.valueOf(checkIn));
            params.add(Date.valueOf(checkOut));
        }

        sql.append(" AND EXISTS (SELECT 1 FROM rooms r WHERE r.business_id = b.business_id AND r.is_active = 1) ");
        sql.append(" ORDER BY b.name ASC");

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            // Set tham so
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Businesses homestay = new Businesses();
                    homestay.setBusinessId(rs.getInt("business_id"));
                    homestay.setName(rs.getString("name"));
                    homestay.setAddress(rs.getString("address"));
                    homestay.setDescription(rs.getString("description"));
                    homestay.setImage(rs.getString("image"));
                    homestay.setAvgRating(rs.getBigDecimal("avg_rating"));
                    homestay.setReviewCount(rs.getInt("review_count"));
                    homestay.setCapacity(rs.getInt("capacity"));
                    homestay.setNumBedrooms(rs.getInt("num_bedrooms"));
                    homestay.setPricePerNight(rs.getBigDecimal("price_per_night"));
                    homestay.setStatus(rs.getString("status"));
                    homestay.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                    homestay.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));

                    Areas area = new Areas();
                    area.setAreaId(rs.getInt("area_id"));
                    area.setName(rs.getString("area_name"));
                    homestay.setArea(area);

                    Users owner = new Users();
                    owner.setUserId(rs.getInt("user_id"));
                    owner.setFullName(rs.getString("owner_name"));
                    homestay.setOwner(owner);

                    // Lấy và cài đặt danh sách tiện nghi
                    List<Amenities> amenities = getAmenitiesForHomestay(homestay.getBusinessId());
                    homestay.setAmenities(amenities);

                    homestays.add(homestay);
                }
            } catch (Exception e) {
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return homestays;
    }
}
