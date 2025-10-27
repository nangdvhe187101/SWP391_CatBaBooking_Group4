/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author jackd
 */
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Businesses;
import model.Rooms; // Đảm bảo import model Rooms
import util.DBUtil;

public class RoomDAO {
public List<Rooms> getRoomsByBusinessId(int businessId) {
        List<Rooms> roomList = new ArrayList<>();
        // Lấy các cột cần thiết từ bảng rooms
        String sql = "SELECT room_id, business_id, name, capacity, price_per_night, image, is_active "
                   + "FROM rooms WHERE business_id = ?";

        System.out.println("[RoomDAO] Đang lấy phòng cho business_id = " + businessId);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomId(rs.getInt("room_id"));

                // SỬA LỖI 1: Tạo đối tượng Businesses tạm thời chỉ với ID
                // Vì phương thức này không cần load toàn bộ thông tin business
                Businesses businessRef = new Businesses();
                businessRef.setBusinessId(rs.getInt("business_id"));
                room.setBusiness(businessRef); // Dùng setter setBusiness

                room.setName(rs.getString("name"));
                room.setCapacity(rs.getInt("capacity"));
                room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                room.setImage(rs.getString("image"));

                // SỬA LỖI 2: Dùng đúng setter setIsActive
                room.setIsActive(rs.getBoolean("is_active"));

                roomList.add(room);
            }
        } catch (SQLException e) {
            System.out.println("[RoomDAO] LỖI getRoomsByBusinessId: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("[RoomDAO] Đã tìm thấy " + roomList.size() + " phòng.");
        return roomList;
    }

    // --- Các phương thức CRUD khác (addRoom, updateRoom, deleteRoom) sẽ ở đây ---
     /**
     * Lấy thông tin chi tiết một phòng bằng ID.
     * Cần thiết cho UpdateRoomController.
     * @param roomId ID của phòng
     * @return Đối tượng Room hoặc null nếu không tìm thấy.
     */
    public Rooms getRoomById(int roomId) {
        Rooms room = null;
        String sql = "SELECT room_id, business_id, name, capacity, price_per_night, image, is_active "
                   + "FROM rooms WHERE room_id = ?";
         System.out.println("[RoomDAO] Đang lấy phòng có room_id = " + roomId);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                room = new Rooms();
                room.setRoomId(rs.getInt("room_id"));

                Businesses businessRef = new Businesses();
                businessRef.setBusinessId(rs.getInt("business_id"));
                room.setBusiness(businessRef);

                room.setName(rs.getString("name"));
                room.setCapacity(rs.getInt("capacity"));
                room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                room.setImage(rs.getString("image"));
                room.setIsActive(rs.getBoolean("is_active"));
                 System.out.println("[RoomDAO] Đã tìm thấy phòng: " + room.getName());
            } else {
                 System.out.println("[RoomDAO] Không tìm thấy phòng nào với ID " + roomId);
            }
        } catch (SQLException e) {
            System.out.println("[RoomDAO] LỖI getRoomById: " + e.getMessage());
            e.printStackTrace();
        }
        return room;
    }

     /**
     * Cập nhật thông tin phòng trong database.
     * Cần thiết cho UpdateRoomController.
     * @param room Đối tượng Room chứa thông tin mới
     * @return true nếu cập nhật thành công, false nếu thất bại.
     */
     public boolean updateRoom(Rooms room) {
         String sql = "UPDATE rooms SET name = ?, capacity = ?, price_per_night = ?, image = ?, is_active = ? "
                    + "WHERE room_id = ?";
          System.out.println("[RoomDAO] Đang cập nhật phòng ID: " + room.getRoomId());

         try (Connection conn = DBUtil.getConnection();
              PreparedStatement ps = conn.prepareStatement(sql)) {

             ps.setString(1, room.getName());
             ps.setInt(2, room.getCapacity());
             ps.setBigDecimal(3, room.getPricePerNight());
             ps.setString(4, room.getImage()); // Cần xử lý upload ảnh riêng nếu có
             ps.setBoolean(5, room.isIsActive());
             ps.setInt(6, room.getRoomId());

             int rowsAffected = ps.executeUpdate();
             if(rowsAffected > 0) System.out.println("[RoomDAO] Cập nhật phòng thành công.");
             else System.out.println("[RoomDAO] Cập nhật phòng thất bại (không tìm thấy ID?).");
             return rowsAffected > 0;

         } catch (SQLException e) {
             System.out.println("[RoomDAO] LỖI updateRoom: " + e.getMessage());
             e.printStackTrace();
             return false;
         }
     }

      /**
     * Xóa phòng khỏi database.
     * Cần thiết cho DeleteRoomController.
     * @param roomId ID của phòng cần xóa
     * @return true nếu xóa thành công, false nếu thất bại.
     */
     public boolean deleteRoom(int roomId) {
         String sql = "DELETE FROM rooms WHERE room_id = ?";
          System.out.println("[RoomDAO] Đang xóa phòng ID: " + roomId);

         try (Connection conn = DBUtil.getConnection();
              PreparedStatement ps = conn.prepareStatement(sql)) {

             ps.setInt(1, roomId);
             int rowsAffected = ps.executeUpdate();
              if(rowsAffected > 0) System.out.println("[RoomDAO] Xóa phòng thành công.");
             else System.out.println("[RoomDAO] Xóa phòng thất bại (không tìm thấy ID?).");
             return rowsAffected > 0;

         } catch (SQLException e) {
             System.out.println("[RoomDAO] LỖI deleteRoom: " + e.getMessage());
             e.printStackTrace();
             return false;
         }
     }
}
