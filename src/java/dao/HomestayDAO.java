/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.sql.Date;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
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
                + "b.capacity, b.num_bedrooms, b.price_per_night, b.status, b.created_at, b.updated_at,b.opening_hour, b.closing_hour, "
                + "a.area_id, a.name AS area_name, u.user_id, u.full_name AS owner_name "
                + "FROM businesses b "
                + "JOIN areas a ON b.area_id = a.area_id "
                + "JOIN users u ON b.owner_id = u.user_id "
                + "WHERE b.type = 'homestay' AND b.status = 'active' ";

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
                homestay.setOpeningHour(rs.getObject("opening_hour", LocalTime.class));
                homestay.setClosingHour(rs.getObject("closing_hour", LocalTime.class));

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

    public List<Businesses> searchHomestays(int areaId, LocalDate checkIn, LocalDate checkOut, int guests, int numRooms, Double minRating, BigDecimal minPrice, BigDecimal maxPrice, List<Integer> amenityIds) {
        List<Businesses> homestays = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT b.business_id, b.name, b.address, b.description, b.image, b.avg_rating, b.review_count, "
                + "b.capacity, b.num_bedrooms, b.price_per_night, b.status, b.created_at, b.updated_at,b.opening_hour, b.closing_hour, "
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

        if (minRating != null && minRating > 0) {
            sql.append(" AND b.avg_rating = ?");
            params.add(minRating);
        }

        if (minPrice != null) {
            sql.append(" AND b.price_per_night >= ?");
            params.add(minPrice);
        }

        if (maxPrice != null && maxPrice.compareTo(BigDecimal.ZERO) > 0) {
            sql.append(" AND b.price_per_night <= ?");
            params.add(maxPrice);
        }

        if (amenityIds != null && !amenityIds.isEmpty()) {
            sql.append(" AND b.business_id IN ( ");
            sql.append("    SELECT ba.business_id FROM business_amenities ba ");
            sql.append("    WHERE ba.amenity_id IN (");

            for (int i = 0; i < amenityIds.size(); i++) {
                sql.append("?");
                if (i < amenityIds.size() - 1) {
                    sql.append(",");
                }
            }

            sql.append(") ");
            sql.append("    GROUP BY ba.business_id ");
            sql.append("    HAVING COUNT(DISTINCT ba.amenity_id) = ? ");
            sql.append(") ");

            for (Integer amenityId : amenityIds) {
                params.add(amenityId);
            }

            params.add(amenityIds.size());
        }

        sql.append(" AND (SELECT COUNT(*) FROM rooms r WHERE r.business_id = b.business_id AND r.is_active = 1");
        if (guests > 0) {
            sql.append(" AND r.capacity >= ?");
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
        if (numRooms > 0) {
            sql.append(") >= ? ");
            params.add(numRooms);
        } else {
            sql.append(") >= 1 ");
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
                    homestay.setOpeningHour(rs.getObject("opening_hour", LocalTime.class));
                    homestay.setClosingHour(rs.getObject("closing_hour", LocalTime.class));
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

    public List<Businesses> getTopHomestays() {
        List<Businesses> homestays = new ArrayList<>();
        String sql = """
        SELECT b.business_id, b.name, b.address, b.description, b.image, b.avg_rating, b.review_count,
               b.capacity, b.num_bedrooms, b.price_per_night, b.status, b.created_at, b.updated_at,
               b.opening_hour, b.closing_hour,
               a.area_id, a.name AS area_name, u.user_id, u.full_name AS owner_name
        FROM businesses b
        JOIN areas a ON b.area_id = a.area_id
        JOIN users u ON b.owner_id = u.user_id
        WHERE b.type = 'homestay' 
          AND b.status = 'active'
          AND EXISTS (SELECT 1 FROM rooms r WHERE r.business_id = b.business_id AND r.is_active = 1)
        ORDER BY b.avg_rating DESC, b.review_count DESC
        LIMIT 5
        """;

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
                homestay.setOpeningHour(rs.getObject("opening_hour", LocalTime.class));
                homestay.setClosingHour(rs.getObject("closing_hour", LocalTime.class));

                Areas area = new Areas();
                area.setAreaId(rs.getInt("area_id"));
                area.setName(rs.getString("area_name"));
                homestay.setArea(area);

                Users owner = new Users();
                owner.setUserId(rs.getInt("user_id"));
                owner.setFullName(rs.getString("owner_name"));
                homestay.setOwner(owner);

                // Lấy tiện nghi
                List<Amenities> amenities = getAmenitiesForHomestay(homestay.getBusinessId());
                homestay.setAmenities(amenities);

                homestays.add(homestay);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return homestays;
    }
    
    public List<Businesses> getTopRestaurants() {
    List<Businesses> restaurants = new ArrayList<>();
    String sql = """
        SELECT b.business_id, b.name, b.address, b.description, b.image, b.avg_rating, b.review_count,
               b.price_per_night, b.status, b.opening_hour, b.closing_hour,
               a.area_id, a.name AS area_name, u.user_id, u.full_name AS owner_name
        FROM businesses b
        JOIN areas a ON b.area_id = a.area_id
        JOIN users u ON b.owner_id = u.user_id
        WHERE b.type = 'restaurant' 
          AND b.status = 'active'
        ORDER BY b.avg_rating DESC, b.review_count DESC
        LIMIT 3
        """;

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            Businesses restaurant = new Businesses();
            restaurant.setBusinessId(rs.getInt("business_id"));
            restaurant.setName(rs.getString("name"));
            restaurant.setAddress(rs.getString("address"));
            restaurant.setDescription(rs.getString("description"));
            restaurant.setImage(rs.getString("image"));
            restaurant.setAvgRating(rs.getBigDecimal("avg_rating"));
            restaurant.setReviewCount(rs.getInt("review_count"));
            restaurant.setPricePerNight(rs.getBigDecimal("price_per_night")); // dùng làm giá trung bình
            restaurant.setStatus(rs.getString("status"));
            restaurant.setOpeningHour(rs.getObject("opening_hour", LocalTime.class));
            restaurant.setClosingHour(rs.getObject("closing_hour", LocalTime.class));

            Areas area = new Areas();
            area.setAreaId(rs.getInt("area_id"));
            area.setName(rs.getString("area_name"));
            restaurant.setArea(area);

            Users owner = new Users();
            owner.setUserId(rs.getInt("user_id"));
            owner.setFullName(rs.getString("owner_name"));
            restaurant.setOwner(owner);

            // Lấy tiện nghi (nếu cần)
            List<Amenities> amenities = getAmenitiesForHomestay(restaurant.getBusinessId());
            restaurant.setAmenities(amenities);

            restaurants.add(restaurant);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return restaurants;
}
}
