package dao;

import model.Users;
import model.Roles;
import util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import util.PassWordUtil;

public class UserDAO {
    
    public Users authenticateUser(String email, String password) {
        String sql = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id = r.role_id WHERE u.email = ? LIMIT 1";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                if (PassWordUtil.verifyPassword(storedHash, password)) {
                    Users user = new Users();
                    user.setUserId(rs.getInt("user_id"));
                    user.setRole(new Roles(rs.getInt("role_id"), rs.getString("role_name"), null, null));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setPhone(rs.getString("phone"));
                    user.setCitizenId(rs.getString("citizen_id"));
                    user.setPersonalAddress(rs.getString("personal_address"));
                    user.setStatus(rs.getString("status"));
                    user.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                    user.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public int registerUser(Users user) {
        String sql = "INSERT INTO users (role_id, full_name, email, password_hash, phone, citizen_id, personal_address, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (!PassWordUtil.isValidPassword(user.getPasswordHash())) {
                return -1;
            }

            String hashedPassword = PassWordUtil.hashPassword(user.getPasswordHash());

            ps.setInt(1, user.getRole().getRoleId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, hashedPassword);
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getCitizenId());
            ps.setString(7, user.getPersonalAddress());
            ps.setString(8, user.getRole().getRoleId() == 1 ? "active" : "pending");
            ps.setObject(9, user.getCreatedAt());
            ps.setObject(10, user.getUpdatedAt());

            int result = ps.executeUpdate();
            if (result > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
            return -1;

        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }
}