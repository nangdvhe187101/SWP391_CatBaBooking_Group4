/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import model.DishCategories;
import java.sql.*;
import model.Businesses;
import model.Dishes;
import util.DBUtil;

/**
 *
 * @author ADMIN
 */
public class DishCategoryDAO {
 
    public List<DishCategories> getCategoriesByBusinessId(int businessId) {
        List<DishCategories> categories = new ArrayList<>();
        String sql = "SELECT category_id, name FROM dish_categories WHERE business_id = ?";  
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) { 
            pstmt.setInt(1, businessId);
            try (ResultSet rs = pstmt.executeQuery()) {  
                while (rs.next()) {
                    DishCategories cat = new DishCategories(rs.getInt("category_id"), rs.getString("name"));
                    categories.add(cat);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    public boolean createDishCategory(DishCategories category) {
        if (category == null || category.getBusiness() == null || category.getBusiness().getBusinessId() <= 0 || 
            category.getName() == null || category.getName().trim().isEmpty()) {
            return false; 
        }

        String sql = "INSERT INTO dish_categories (business_id, name, display_order) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {  
            ps.setInt(1, category.getBusiness().getBusinessId());
            ps.setString(2, category.getName().trim());
            ps.setInt(3, (category.getDisplayOrder() != null) ? category.getDisplayOrder() : 0);  

            int result = ps.executeUpdate();
            if (result > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        category.setCategoryId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
