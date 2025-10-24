/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;


import model.Areas;
import util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class AreaDAO {
    public List<Areas> getAllAreas() {
        List<Areas> areaList = new ArrayList<>();
        String sql = "SELECT * FROM areas ORDER BY name ASC"; 
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Areas area = new Areas();
                area.setAreaId(rs.getInt("area_id"));
                area.setName(rs.getString("name"));
                areaList.add(area);
            }
        } catch (SQLException e) {
            e.printStackTrace(); 
        }
        return areaList;
    }
}
