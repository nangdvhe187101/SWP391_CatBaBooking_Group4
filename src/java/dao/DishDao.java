/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import ch.qos.logback.classic.db.DBAppender;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import model.Businesses;
import model.DishCategories;
import model.Dishes;
import util.DBUtil;

/**
 *
 * @author ADMIN
 */
public class DishDao {
    
    //lay tat ca mon an cua 1 nha hang
     public List<Dishes> getAllDishesByBusinessId(int businessId){
         List<Dishes> dishes = new ArrayList<>();
         String sql ="SELECT d.dish_id, d.business_id, d.category_id, d.name, d.description, d.price, d.image_url, d.is_available, " +
                     "dc.name as category_name " +
                     "FROM dishes d " +
                     "JOIN dish_categories dc ON d.category_id = dc.category_id " +
                     "WHERE d.business_id = ?";
         try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)){
             ps.setInt(1, businessId);
             try(ResultSet rs = ps.executeQuery()){
                 while (rs.next()) {                     
                    Dishes dish = new Dishes();
                    dish.setDishId(rs.getInt("dish_id"));
                    Businesses business = new Businesses();
                    dish.setBusiness(business);
                    DishCategories category = new DishCategories();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setName(rs.getString("category_name"));
                    dish.setCategory(category);
                    dish.setName(rs.getString("name"));
                    dish.setDescription(rs.getString("description"));
                    dish.setPrice(rs.getBigDecimal("price"));
                    dish.setImageUrl(rs.getString("image_url"));
                    dish.setIsAvailable(rs.getBoolean("is_available"));
                    dishes.add(dish);
                 }
             }
         } catch (Exception e) {
             e.printStackTrace();
         }
         return dishes;
     }
     
     //lay mon an theo id
     public Dishes getDishById(int dishId) {
        String sql = "SELECT d.*, dc.name as category_name " +
                     "FROM dishes d " +
                     "JOIN dish_categories dc ON d.category_id = dc.category_id " +
                     "WHERE d.dish_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, dishId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Dishes dish = new Dishes();
                    dish.setDishId(rs.getInt("dish_id"));
                    Businesses business = new Businesses();
                    business.setBusinessId(rs.getInt("business_id"));
                    dish.setBusiness(business);
                    DishCategories category = new DishCategories();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setName(rs.getString("category_name"));
                    dish.setCategory(category);
                    dish.setName(rs.getString("name"));
                    dish.setDescription(rs.getString("description"));
                    dish.setPrice(rs.getBigDecimal("price"));
                    dish.setImageUrl(rs.getString("image_url"));
                    dish.setIsAvailable(rs.getBoolean("is_available"));
                    return dish;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
     
     //them mon an
     public boolean addDish(Dishes dish) {
        String sql = "INSERT INTO dishes (business_id, category_id, name, description, price, image_url, is_available) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dish.getBusiness().getBusinessId());
            ps.setInt(2, dish.getCategory().getCategoryId());
            ps.setString(3, dish.getName());
            ps.setString(4, dish.getDescription());
            ps.setBigDecimal(5, dish.getPrice());
            ps.setString(6, dish.getImageUrl());
            ps.setBoolean(7, dish.isIsAvailable());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    // update mon an 
    public boolean updateDish(Dishes dish) {
        String sql = "UPDATE dishes SET category_id = ?, name = ?, description = ?, price = ?, image_url = ?, is_available = ? " +
                     "WHERE dish_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dish.getCategory().getCategoryId());
            ps.setString(2, dish.getName());
            ps.setString(3, dish.getDescription());
            ps.setBigDecimal(4, dish.getPrice());
            ps.setString(5, dish.getImageUrl());
            ps.setBoolean(6, dish.isIsAvailable());
            ps.setInt(7, dish.getDishId());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    //ktra món ăn đó đã có trong nhà hàng chưa
    public boolean isDishNameExists(String dishName, int businessId) {
        String sql = "SELECT COUNT(*) FROM dishes WHERE name = ? AND business_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, dishName);
            ps.setInt(2, businessId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; 
    }
    
   //Kiểm tra tên món ăn tồn tại, nhưng loại trừ chính nó 
   public boolean isDishNameExistsForUpdate(String dishName, int businessId, int dishIdToExclude) {
        String sql = "SELECT COUNT(*) FROM dishes WHERE name = ? AND business_id = ? AND dish_id != ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, dishName);
            ps.setInt(2, businessId);
            ps.setInt(3, dishIdToExclude); 
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; 
    }
}
