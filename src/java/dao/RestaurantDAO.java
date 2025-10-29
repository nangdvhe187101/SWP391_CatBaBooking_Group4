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
                + "b.image, b.avg_rating, b.review_count, b.status, b.opening_hour, b.closing_hour,"
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
    public List<String> getAllRestaurantTypes() {
        List<String> types = new ArrayList<>();
        String sql = "SELECT name FROM restaurant_types ORDER BY name";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                types.add(rs.getString("name"));

            }
        } catch (Exception e) {
        }
        return types;
    }

    public List<BusinessesDTO> searchRestaurants(String restaurantType, int areaId, LocalDate reservationDate, LocalTime reservationTime, Integer numGuests, Double minRating) throws SQLException {
        List<BusinessesDTO> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT b.business_id, b.owner_id, b.name, b.address, b.description, "
                + "b.image, b.avg_rating, b.review_count, b.status, b.opening_hour, b.closing_hour,"
                + "a.area_id, a.name AS area_name, u.user_id, u.full_name AS owner_name "
                + "FROM businesses b "
                + "LEFT JOIN areas a ON b.area_id = a.area_id "
                + "JOIN users u ON b.owner_id = u.user_id "
                + "WHERE b.type = 'restaurant' AND b.status = 'active'");

        if (restaurantType != null && restaurantType.isEmpty()) {
            sql.append(" AND EXISTS (SELECT 1 FROM business_restaurant_types brt "
                    + "JOIN restaurant_types rt ON brt.type_id = rt.type_id "
                    + "WHERE brt.business_id = b.business_id AND rt.name = ?)");
            params.add(restaurantType);
        }

        // 2. Khu vực
        if (areaId > 0) {
            sql.append(" AND b.area_id = ?");
            params.add(areaId);
        }
        // 3. Đánh giá tối thiểu
        if (minRating != null) {
            sql.append(" AND b.avg_rating >= ?");
            params.add(minRating);
        }
        // 4. Kiểm tra bàn trống + giờ mở cửa + sức chứa
        boolean hasAvailabilityFilter = (reservationDate != null || reservationTime != null || numGuests != null);
        if (hasAvailabilityFilter) {
            sql.append(" AND EXISTS (");
            sql.append("  SELECT 1 FROM restaurant_tables rt ");
            sql.append("  JOIN table_availability ta ON rt.table_id = ta.table_id ");
            sql.append("  WHERE rt.business_id = b.business_id AND ta.status = 'available'");

            if (numGuests != null && numGuests > 0) {
                sql.append(" AND rt.capacity >= ?");
                params.add(numGuests);
            }
            if (reservationDate != null) {
                sql.append(" AND ta.reservation_date = ?");
                params.add(java.sql.Date.valueOf(reservationDate));
            }
            if (reservationTime != null) {
                sql.append(" AND ta.reservation_time = ?");
                params.add(java.sql.Time.valueOf(reservationTime));
            }
            if (reservationTime != null) {
                sql.append(" AND ? BETWEEN b.opening_hour AND b.closing_hour");
                params.add(java.sql.Time.valueOf(reservationTime));
            }
            sql.append(")");
        }

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BusinessesDTO dto = new BusinessesDTO();
                    dto.setBusinessId(rs.getInt("business_id"));
                    dto.setName(rs.getString("name"));
                    dto.setAddress(rs.getString("address"));
                    dto.setDescription(rs.getString("description"));
                    dto.setImage(rs.getString("image"));
                    dto.setAvgRating(rs.getBigDecimal("avg_rating"));
                    dto.setReviewCount(rs.getInt("review_count"));
                    dto.setOpeningHour(rs.getObject("opening_hour", LocalTime.class));
                    dto.setClosingHour(rs.getObject("closing_hour", LocalTime.class));

                    Areas area = new Areas();
                    area.setAreaId(rs.getInt("area_id"));
                    area.setName(rs.getString("area_name"));
                    dto.setArea(area);

                    Users owner = new Users();
                    owner.setUserId(rs.getInt("user_id"));
                    owner.setFullName(rs.getString("owner_name"));
                    dto.setOwner(owner);

                    // Lấy danh sách cuisines
                    dto.setCuisines(getCuisinesForRestaurant(dto.getBusinessId()));

                    list.add(dto);
                }
            }
        }
        return list;
    }
}
