/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import model.Areas;
import model.RestaurantTypes;
import model.Users;
import model.dto.BusinessesDTO;
import util.DBUtil;

/**
 *
 * @author Admin
 */
public class RestaurantDAO {

    //lấy ds nhà hàng
    public List<BusinessesDTO> getAllRestaurants() {
        List<BusinessesDTO> restaurants = new ArrayList<>();
        String sql = "SELECT b.business_id, b.owner_id, b.name, b.address, b.description, "
                + "b.image, b.avg_rating, b.review_count,b.price_per_night, b.status, b.opening_hour, b.closing_hour,"
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
                restaurant.setPricePerNight(rs.getBigDecimal("price_per_night"));
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

    // Lấy tất cả loại nhà hàng
    public List<RestaurantTypes> getAllRestaurantTypes() {
        List<RestaurantTypes> types = new ArrayList<>();
        String sql = "SELECT * FROM restaurant_types ORDER BY name ASC";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                RestaurantTypes type = new RestaurantTypes();
                type.setTypeId(rs.getInt("type_id"));
                type.setName(rs.getString("name"));
                types.add(type);

            }
        } catch (Exception e) {
        }
        return types;
    }


public List<BusinessesDTO> searchRestaurants(int typeId, int areaId, LocalDate reservationDate,
        LocalTime reservationTime, Integer numGuests, Double minRating) throws SQLException {
    List<BusinessesDTO> list = new ArrayList<>();
    List<Object> params = new ArrayList<>();

    // Câu SQL cơ bản
    StringBuilder sql = new StringBuilder(
            "SELECT b.business_id, b.owner_id, b.name, b.address, b.description, "
            + "b.image, b.avg_rating, b.review_count,b.price_per_night, b.status, b.opening_hour, b.closing_hour, "
            + "a.area_id, a.name AS area_name, u.user_id, u.full_name AS owner_name "
            + "FROM businesses b "
            + "LEFT JOIN areas a ON b.area_id = a.area_id "
            + "JOIN users u ON b.owner_id = u.user_id "
            + "WHERE b.type = 'restaurant' AND b.status = 'active'");

    // 1. Lọc theo Loại hình
    if (typeId > 0) {
        sql.append(" AND EXISTS (SELECT 1 FROM business_restaurant_types brt "
                + "WHERE brt.business_id = b.business_id AND brt.type_id = ?)");
        params.add(typeId);
    }

    // 2. Lọc theo Khu vực
    if (areaId > 0) {
        sql.append(" AND b.area_id = ?");
        params.add(areaId);
    }

    // 3. Lọc theo Đánh giá
    if (minRating != null && minRating > 0) {
        sql.append(" AND b.avg_rating = ?"); 
        params.add(minRating);
    }

    // 4. Lọc theo Ngày, Giờ, Số người 
    boolean hasDate = (reservationDate != null);
    boolean hasTime = (reservationTime != null);
    boolean hasCapacityFilter = (numGuests != null && numGuests > 0);

    //Kiểm tra giờ mở cửa (chỉ chạy nếu người dùng nhập 'Giờ')
    if (hasTime) {
        sql.append(" AND (");
        // TH 1: Giờ bình thường 
        sql.append("   (b.opening_hour <= b.closing_hour AND ? >= b.opening_hour AND ? < b.closing_hour)");
        // TH 2: Giờ qua đêm 
        sql.append("   OR (b.opening_hour > b.closing_hour AND (? >= b.opening_hour OR ? < b.closing_hour))");
        sql.append(" )");

        params.add(java.sql.Time.valueOf(reservationTime));
        params.add(java.sql.Time.valueOf(reservationTime));
        params.add(java.sql.Time.valueOf(reservationTime));
        params.add(java.sql.Time.valueOf(reservationTime));
    }

    //Kiểm tra bàn trống
    if (hasDate && hasTime) {
        // TRƯỜNG HỢP A: Người dùng nhập CẢ NGÀY VÀ GIỜ
        sql.append(" AND EXISTS (");
        sql.append("  SELECT 1 FROM restaurant_tables rt ");
        sql.append("  WHERE rt.business_id = b.business_id");

        // Kiểm tra sức chứa
        int capacity = (hasCapacityFilter) ? numGuests : 1; 
        sql.append(" AND rt.capacity >= ?");
        params.add(capacity);

        sql.append(" AND NOT EXISTS (");
        sql.append("  SELECT 1 FROM table_availability ta ");
        sql.append("  WHERE ta.table_id = rt.table_id ");
        sql.append("  AND ta.reservation_date = ? ");
        sql.append("  AND ta.reservation_time = ? ");
        sql.append("  AND (ta.status = 'booked' OR ta.status = 'blocked')");
        sql.append(" )");

        sql.append(")");

        params.add(java.sql.Date.valueOf(reservationDate));
        params.add(java.sql.Time.valueOf(reservationTime));

    } else if (hasCapacityFilter) {
        //  Người dùng CHỈ nhập SỐ NGƯỜI
        // (hoặc Số người + Giờ / Số người + Ngày)
        // Chỉ cần tìm nhà hàng có bàn đủ sức chứa.
        sql.append(" AND EXISTS (");
        sql.append("  SELECT 1 FROM restaurant_tables rt ");
        sql.append("  WHERE rt.business_id = b.business_id");
        sql.append("  AND rt.capacity >= ?");
        sql.append(")"); // Đóng EXISTS
        params.add(numGuests);
    }
    

    // Thực thi Query
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BusinessesDTO restaurant = new BusinessesDTO();
                restaurant.setBusinessId(rs.getInt("business_id"));
                restaurant.setName(rs.getString("name"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setDescription(rs.getString("description"));
                restaurant.setImage(rs.getString("image"));
                restaurant.setAvgRating(rs.getBigDecimal("avg_rating"));
                restaurant.setReviewCount(rs.getInt("review_count"));
                restaurant.setPricePerNight(rs.getBigDecimal("price_per_night"));
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

                // Get cuisines for restaurant
                restaurant.setCuisines(getCuisinesForRestaurant(restaurant.getBusinessId()));

                list.add(restaurant);
            }
        }
    }
    return list;
}
}
