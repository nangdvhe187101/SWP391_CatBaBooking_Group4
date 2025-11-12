/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
public class HomestayDAO {
    
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
}
