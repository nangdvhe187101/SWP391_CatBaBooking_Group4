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
import model.Rooms;
import util.DBUtil;

public class RoomDAO {
    public List<Rooms> getRoomsByBusinessId(int businessId) {
        List<Rooms> roomList = new ArrayList<>();
        String sql = "SELECT room_id, business_id, name, capacity, price_per_night, image, is_active "
                   + "FROM rooms WHERE business_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, businessId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomId(rs.getInt("room_id"));
                Businesses businessRef = new Businesses();
                businessRef.setBusinessId(rs.getInt("business_id"));
                room.setBusiness(businessRef);
                room.setName(rs.getString("name"));
                room.setCapacity(rs.getInt("capacity"));
                room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                room.setImage(rs.getString("image"));
                room.setIsActive(rs.getBoolean("is_active"));
                roomList.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roomList;
    }

    public Rooms getRoomById(int roomId) {
        Rooms room = null;
        String sql = "SELECT room_id, business_id, name, capacity, price_per_night, image, is_active "
                   + "FROM rooms WHERE room_id = ?";
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
            } else {
                System.out.println("[RoomDAO] Không tìm thấy phòng nào với ID " + roomId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return room;
    }

    public boolean updateRoom(Rooms room) {
        String sql = "UPDATE rooms SET name = ?, capacity = ?, price_per_night = ?, image = ?, is_active = ?, business_id = ? "
            + "WHERE room_id = ?";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getName());
            ps.setInt(2, room.getCapacity());
            ps.setBigDecimal(3, room.getPricePerNight());
            ps.setString(4, room.getImage()); // Cần xử lý upload ảnh riêng nếu muốn đổi ảnh
            ps.setBoolean(5, room.isIsActive());
            ps.setInt(6, room.getBusiness().getBusinessId()); // Lấy businessId từ đối tượng Room
            ps.setInt(7, room.getRoomId());

            int rowsAffected = ps.executeUpdate();
            if(rowsAffected > 0) System.out.println("[RoomDAO] Cập nhật phòng thành công.");
            else System.out.println("[RoomDAO] Cập nhật phòng thất bại (không tìm thấy ID?).");
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
