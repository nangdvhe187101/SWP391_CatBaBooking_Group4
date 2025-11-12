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
import model.Reviews;
import model.Rooms;
import model.RoomsImage;
import model.Users;
import model.dto.ReviewsDTO;
import model.dto.RoomsDTO;
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

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

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

    public Businesses getHomestayById(int businessId) {
    Businesses homestay = null;
    String sql = """
        SELECT b.business_id, b.name, b.address, b.description, b.image, b.avg_rating, b.review_count,
               b.capacity, b.num_bedrooms, b.price_per_night, b.status, b.created_at, b.updated_at,
               b.opening_hour, b.closing_hour,
               a.area_id, a.name AS area_name, u.user_id, u.full_name AS owner_name
        FROM businesses b
        JOIN areas a ON b.area_id = a.area_id
        JOIN users u ON b.owner_id = u.user_id
        WHERE b.type = 'homestay' AND b.status = 'active' AND b.business_id = ?
        """;

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, businessId);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                homestay = new Businesses();
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
                List<Amenities> amenities = getAmenitiesForHomestay(businessId);
                homestay.setAmenities(amenities);

                System.out.println("TÌM THẤY homestay: " + homestay.getName());
            } else {
                System.out.println("KHÔNG TÌM THẤY homestay ID: " + businessId);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return homestay;
}
   

    public List<ReviewsDTO> getReviewsByBusinessId(int businessId) {
        List<ReviewsDTO> reviews = new ArrayList<>();
        String sql = "SELECT r.review_id, r.user_id, r.rating, r.comment, r.created_at, u.full_name "
                + "FROM reviews r "
                + "JOIN users u ON r.user_id = u.user_id "
                + "WHERE r.business_id = ? "
                + "ORDER BY r.created_at DESC";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, businessId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ReviewsDTO review = new ReviewsDTO();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setRating(rs.getByte("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));

                    Users user = new Users();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    review.setUser(user);

                    reviews.add(review);
                }
            }
        } catch (Exception e) {
        }
        return reviews;
    }

    public List<String> getImagesByBusinessId(int businessId) {
        List<String> images = new ArrayList<>();
        String sql = "SELECT ri.image_url "
                + "FROM room_images ri "
                + "JOIN rooms r ON ri.room_id = r.room_id "
                + "WHERE r.business_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, businessId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    images.add(rs.getString("image_url"));
                }
            }
        } catch (Exception e) {
        }
        return images;
    }
    
public List<RoomsDTO> getAvailableRooms(int businessId, LocalDate checkIn, LocalDate checkOut, int guests, int numRooms) {
    List<RoomsDTO> rooms = new ArrayList<>();
    
    // Query lấy tất cả phòng còn trống trong khoảng thời gian
    String sql = """
        SELECT r.room_id, r.business_id, r.name, r.capacity, r.price_per_night, r.is_active
        FROM rooms r
        WHERE r.business_id = ? 
        AND r.is_active = 1
        AND NOT EXISTS (
            SELECT 1 FROM room_availability ra
            WHERE ra.room_id = r.room_id
            AND ra.date >= ? AND ra.date < ?
            AND ra.status IN ('booked', 'blocked')
        )
        ORDER BY r.price_per_night ASC
    """;

    try (Connection conn = DBUtil.getConnection(); 
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, businessId);
        stmt.setDate(2, Date.valueOf(checkIn));
        stmt.setDate(3, Date.valueOf(checkOut));
        
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                RoomsDTO room = new RoomsDTO();
                room.setRoomId(rs.getInt("room_id"));
                room.setBusinessId(rs.getInt("business_id"));
                room.setName(rs.getString("name"));
                room.setCapacity(rs.getInt("capacity"));
                room.setPrice(rs.getBigDecimal("price_per_night"));
                room.setIsActive(rs.getBoolean("is_active"));
                rooms.add(room);
            }
            
            System.out.println("Found " + rooms.size() + " available rooms for businessId: " + businessId);
            
            // Kiểm tra xem tổng sức chứa của các phòng có đủ cho số người không
            if (guests > 0 && numRooms > 0) {
                // Sắp xếp phòng theo sức chứa giảm dần để ưu tiên phòng lớn trước
                // Sử dụng bubble sort đơn giản
                for (int i = 0; i < rooms.size() - 1; i++) {
                    for (int j = 0; j < rooms.size() - i - 1; j++) {
                        if (rooms.get(j).getCapacity() < rooms.get(j + 1).getCapacity()) {
                            // Swap
                            RoomsDTO temp = rooms.get(j);
                            rooms.set(j, rooms.get(j + 1));
                            rooms.set(j + 1, temp);
                        }
                    }
                }
                
                // Kiểm tra xem có thể sắp xếp được không
                List<RoomsDTO> selectedRooms = new ArrayList<>();
                int totalCapacity = 0;
                
                // Lấy numRooms phòng đầu tiên (đã sắp xếp theo sức chứa giảm dần)
                for (int i = 0; i < rooms.size() && i < numRooms; i++) {
                    selectedRooms.add(rooms.get(i));
                    totalCapacity += rooms.get(i).getCapacity();
                }
                
                // Nếu tổng sức chứa không đủ, trả về danh sách rỗng
                if (totalCapacity < guests) {
                    System.out.println("Total capacity (" + totalCapacity + ") is not enough for " + guests + " guests");
                    return new ArrayList<>();
                }
                
                // Nếu số phòng còn trống ít hơn số phòng yêu cầu
                if (rooms.size() < numRooms) {
                    System.out.println("Not enough rooms available. Requested: " + numRooms + ", Available: " + rooms.size());
                    return new ArrayList<>();
                }
            }
            
        }
    } catch (SQLException e) {
        e.printStackTrace();
        System.out.println("SQL Error in getAvailableRooms: " + e.getMessage());
    }
    
    return rooms;
}

/**
     * Lấy danh sách phòng theo businessId có phân trang.
     *
     * @param businessId ID của homestay
     * @param page Số trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số phòng trên mỗi trang
     * @return Danh sách phòng
     */
    public List<Rooms> getPaginatedRoomsByBusinessId(int businessId, int page, int pageSize) {
        List<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE business_id = ? ORDER BY name ASC LIMIT ? OFFSET ?";
        int offset = (page - 1) * pageSize;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, businessId);
            stmt.setInt(2, pageSize);
            stmt.setInt(3, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Rooms room = new Rooms();
                    room.setRoomId(rs.getInt("room_id"));
                    // Chúng ta không cần set business đầy đủ ở đây để tránh gọi đệ quy
                    // Tạm thời set businessId vào một trường (nếu có) hoặc để null
                    room.setName(rs.getString("name"));
                    room.setCapacity(rs.getInt("capacity"));
                    room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                    room.setIsActive(rs.getBoolean("is_active"));
                    rooms.add(room);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    /**
     * Đếm tổng số phòng của một homestay.
     *
     * @param businessId ID của homestay
     * @return Tổng số phòng
     */
    public int countRoomsByBusinessId(int businessId) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE business_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, businessId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy thông tin một phòng bằng ID và businessId (để xác thực chủ sở hữu).
     *
     * @param roomId ID của phòng
     * @param businessId ID của homestay
     * @return Đối tượng Rooms nếu tìm thấy, ngược lại là null
     */
    public Rooms getRoomById(int roomId, int businessId) {
        String sql = "SELECT * FROM rooms WHERE room_id = ? AND business_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            stmt.setInt(2, businessId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Rooms room = new Rooms();
                    room.setRoomId(rs.getInt("room_id"));
                    room.setName(rs.getString("name"));
                    room.setCapacity(rs.getInt("capacity"));
                    room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                    room.setIsActive(rs.getBoolean("is_active"));
                    // Không set business để tránh vòng lặp
                    return room;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Cập nhật thông tin phòng.
     *
     * @param room Đối tượng Rooms chứa thông tin mới
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateRoom(Rooms room) {
        String sql = "UPDATE rooms SET name = ?, capacity = ?, price_per_night = ?, is_active = ? WHERE room_id = ? AND business_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, room.getName());
            stmt.setInt(2, room.getCapacity());
            stmt.setBigDecimal(3, room.getPricePerNight());
            stmt.setBoolean(4, room.isIsActive());
            stmt.setInt(5, room.getRoomId());
            stmt.setInt(6, room.getBusiness().getBusinessId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa phòng vĩnh viễn.
     *
     * @param roomId ID phòng cần xóa
     * @param businessId ID của homestay (để xác thực)
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteRoom(int roomId, int businessId) {
        String sql = "DELETE FROM rooms WHERE room_id = ? AND business_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            stmt.setInt(2, businessId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật trạng thái active/inactive cho phòng.
     *
     * @param roomId ID phòng
     * @param isActive Trạng thái mới
     * @param businessId ID của homestay (để xác thực)
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateRoomStatus(int roomId, boolean isActive, int businessId) {
        String sql = "UPDATE rooms SET is_active = ? WHERE room_id = ? AND business_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, isActive);
            stmt.setInt(2, roomId);
            stmt.setInt(3, businessId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}