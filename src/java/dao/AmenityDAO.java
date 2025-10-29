/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import model.Amenities;
import java.sql.*;
import util.DBUtil;

/**
 *
 * @author Admin
 */
public class AmenityDAO {
    public List<Amenities> getAllAmenities(){
        List<Amenities> amenitiesList = new ArrayList<>();
        String sql = "SELECT * FROM amenities ORDER BY name";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery() ){
            while (rs.next()) {                
                Amenities amenity = new Amenities();
                amenity.setAmenityId(rs.getInt("amenity_id"));
                amenity.setName(rs.getString("name"));
                amenitiesList.add(amenity);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return amenitiesList;
    }
}
