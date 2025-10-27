package dao;

import model.Users;
import model.Roles;
import model.Businesses;
import util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
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
        }
        return null;
    }

    public int registerUser(Users user) {
        String sql = "INSERT INTO users (role_id, full_name, email, password_hash, phone, citizen_id, personal_address, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (!PassWordUtil.isValidPassword(user.getPasswordHash())) {
                return -1; // Invalid password
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

    public Users getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Roles role = new Roles(rs.getInt("role_id"), null, null, null);
                Users user = new Users();
                user.setUserId(rs.getInt("user_id"));
                user.setRole(role);
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePasswordByEmail(String email, String newPassword) {
        String hashedPassword = PassWordUtil.hashPassword(newPassword);
        String sql = "UPDATE users SET password_hash = ?, updated_at = ? WHERE email = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setObject(2, LocalDateTime.now());
            ps.setString(3, email);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean checkEmailExists(String email) {
        return getUserByEmail(email) != null;
    }

    public boolean deleteUserById(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateUserStatus(int userId, String newStatus) {
        String sql = "UPDATE users SET status = ?, updated_at = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setObject(2, LocalDateTime.now());
            ps.setInt(3, userId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Users getUserById(int userId) {
        String sql = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id = r.role_id WHERE u.user_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Roles role = new Roles(rs.getInt("role_id"), rs.getString("role_name"), null, null);
                Users user = new Users();
                user.setUserId(rs.getInt("user_id"));
                user.setRole(role);
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Users> getPendingOwners() {
        List<Users> pendingOwners = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name, b.name as business_name, b.type as business_type, b.address as business_address, b.description as business_description, b.business_id, b.status as business_status "
                + "FROM users u JOIN roles r ON u.role_id = r.role_id "
                + "LEFT JOIN businesses b ON u.user_id = b.owner_id "
                + "WHERE u.role_id = 2 AND u.status = 'pending'";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users user = new Users();
                user.setUserId(rs.getInt("user_id"));
                user.setRole(new Roles(rs.getInt("role_id"), rs.getString("role_name"), null, null));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setCitizenId(rs.getString("citizen_id"));
                user.setPersonalAddress(rs.getString("personal_address"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                user.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));

                // Set business info nếu có
                Businesses biz = null;
                if (rs.getString("business_name") != null) {
                    biz = new Businesses();
                    biz.setBusinessId(rs.getInt("business_id"));
                    biz.setName(rs.getString("business_name"));
                    biz.setType(rs.getString("business_type"));
                    biz.setAddress(rs.getString("business_address"));
                    biz.setDescription(rs.getString("business_description"));
                    biz.setStatus(rs.getString("business_status"));
                    biz.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                    biz.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));
                    user.setBusiness(biz);
                }
                pendingOwners.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pendingOwners;
    }

    /**
     * Lấy danh sách tất cả users, hỗ trợ lọc
     *
     * @param roleId
     * @param status
     * @param keyword
     * @return
     */
    public List<Users> getAllUsers(Integer roleId, String status, String keyword, int pageIndex, int pageSize) {
        List<Users> users = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name, b.name as business_name, b.type as business_type, "
                + "b.address as business_address, b.description as business_description, "
                + "b.business_id, b.status as business_status "
                + "FROM users u JOIN roles r ON u.role_id = r.role_id "
                + "LEFT JOIN businesses b ON u.user_id = b.owner_id "
                + "WHERE u.role_id <> 3 AND u.status <> 'pending'";

        List<Object> params = new ArrayList<>();
        if (roleId != null) {
            sql += " AND u.role_id = ?";
            params.add(roleId);
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND u.status = ?";
            params.add(status);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (u.email LIKE ? OR u.full_name LIKE ?)";
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        sql += " ORDER BY u.created_at DESC LIMIT ?, ?";
        params.add((pageIndex - 1) * pageSize); 
        params.add(pageSize);

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users user = new Users();
                user.setUserId(rs.getInt("user_id"));
                user.setRole(new Roles(rs.getInt("role_id"), rs.getString("role_name"), null, null));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setCitizenId(rs.getString("citizen_id"));
                user.setPersonalAddress(rs.getString("personal_address"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                user.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));

                if (rs.getString("business_name") != null) {
                    Businesses biz = new Businesses();
                    biz.setBusinessId(rs.getInt("business_id"));
                    biz.setName(rs.getString("business_name"));
                    biz.setType(rs.getString("business_type"));
                    biz.setAddress(rs.getString("business_address"));
                    biz.setDescription(rs.getString("business_description"));
                    biz.setStatus(rs.getString("business_status"));
                    user.setBusiness(biz);
                }
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Cập nhật status user (hỗ trợ 'active', 'rejected', 'pending', hoặc
     * "toggle" để tự động switch)
     */
    public boolean toggleUserStatus(int userId, String newStatus) {
        String finalStatus = newStatus;
        if ("toggle".equals(newStatus)) {
            String currentStatus = getCurrentStatus(userId);
            finalStatus = "active".equals(currentStatus) ? "rejected" : "active";
        } else if (!("active".equals(newStatus) || "rejected".equals(newStatus) || "pending".equals(newStatus))) {
            return false;
        }
        String sql = "UPDATE users SET status = ?, updated_at = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, finalStatus);
            ps.setObject(2, LocalDateTime.now());
            ps.setInt(3, userId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Helper: Lấy status hiện tại
     */
    private String getCurrentStatus(int userId) {
        String sql = "SELECT status FROM users WHERE user_id = ? LIMIT 1";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("status");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "active";
    }

    public int countAllUsers(Integer roleId, String status, String keyword) {
        String sql = "SELECT COUNT(*) FROM users u WHERE u.role_id <> 3 AND u.status <> 'pending'";

        List<Object> params = new ArrayList<>();
        if (roleId != null) {
            sql += " AND u.role_id = ?";
            params.add(roleId);
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND u.status = ?";
            params.add(status);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (u.email LIKE ? OR u.full_name LIKE ?)";
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Cập nhật thông tin profile của user
     */
       /**
     * Validate thông tin user profile trước khi cập nhật
     */
    public String validateUserProfile(String fullName, String email, String currentEmail) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Tên đầy đủ không được để trống";
        }
        if (email == null || email.trim().isEmpty()) {
            return "Email không được để trống";
        }
        if (!email.equals(currentEmail) && checkEmailExists(email)) {
            return "Email này đã được sử dụng bởi tài khoản khác";
        }
        return null;
    }

    /**
     * Gom toàn bộ validation + update vào DAO, chỉ trả về lỗi nếu có
     * Trả về null nếu thành công, hoặc chuỗi lỗi nếu thất bại
     */
    public String processUserProfileUpdate(int userId, String fullName, String email, String phone,
                                           String gender, Integer birthDay, Integer birthMonth,
                                           Integer birthYear, String city, String currentEmail) {
        // Bước 1: validation dữ liệu
        String validationMessage = validateUserProfile(fullName, email, currentEmail);
        if (validationMessage != null) {
            return validationMessage;
        }

        // Bước 2: gọi hàm updateUserProfile (đã có sẵn)
        boolean success = updateUserProfile(userId, fullName, email, phone, gender, birthDay, birthMonth, birthYear, city);

        if (!success) {
            return "Không thể cập nhật thông tin người dùng.";
        }

        return null; // thành công
    }

    /**
     * Cập nhật thông tin profile của user
     */
    public boolean updateUserProfile(int userId, String fullName, String email, String phone,
                                   String gender, Integer birthDay, Integer birthMonth, Integer birthYear, String city) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, gender = ?, birth_day = ?, birth_month = ?, birth_year = ?, city = ?, updated_at = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, gender);
            ps.setObject(5, birthDay);
            ps.setObject(6, birthMonth);
            ps.setObject(7, birthYear);
            ps.setString(8, city);
            ps.setObject(9, LocalDateTime.now());
            ps.setInt(10, userId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}