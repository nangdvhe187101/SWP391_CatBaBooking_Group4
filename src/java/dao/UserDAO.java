package dao;

import model.Users;
import model.Roles;
import util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
}