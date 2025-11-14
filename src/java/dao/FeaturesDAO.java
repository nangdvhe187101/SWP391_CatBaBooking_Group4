/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author ADMIN
 */
import model.Features;
import model.RoleFeature;
import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeaturesDAO {

    /**
     * Lấy tất cả features
     */
    public List<Features> getAllFeatures() {
        List<Features> features = new ArrayList<>();
        String sql = "SELECT * FROM features ORDER BY feature_id";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Features feature = new Features();
                feature.setFeatureId(rs.getInt("feature_id"));
                feature.setFeatureName(rs.getString("feature_name"));
                feature.setUrl(rs.getString("url"));
                features.add(feature);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return features;
    }

    /**
     * Lấy feature theo ID
     */
    public Features getFeatureById(int featureId) {
        String sql = "SELECT * FROM features WHERE feature_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, featureId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Features feature = new Features();
                feature.setFeatureId(rs.getInt("feature_id"));
                feature.setFeatureName(rs.getString("feature_name"));
                feature.setUrl(rs.getString("url"));
                return feature;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Thêm feature mới
     */
    public boolean addFeature(Features feature) {
        String sql = "INSERT INTO features (feature_name, url) VALUES (?, ?)";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, feature.getFeatureName());
            ps.setString(2, feature.getUrl());
            int result = ps.executeUpdate();
            if (result > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    feature.setFeatureId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật feature
     */
    public boolean updateFeature(Features feature) {
        String sql = "UPDATE features SET feature_name = ?, url = ? WHERE feature_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, feature.getFeatureName());
            ps.setString(2, feature.getUrl());
            ps.setInt(3, feature.getFeatureId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa feature
     */
    public boolean deleteFeature(int featureId) {
        String sql = "DELETE FROM features WHERE feature_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, featureId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra URL đã tồn tại chưa
     */
    public boolean isUrlExists(String url, Integer excludeFeatureId) {
        String sql = "SELECT COUNT(*) FROM features WHERE url = ?";
        if (excludeFeatureId != null) {
            sql += " AND feature_id != ?";
        }

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, url);
            if (excludeFeatureId != null) {
                ps.setInt(2, excludeFeatureId);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy tất cả roles
     */
    public List<model.Roles> getAllRoles() {
        List<model.Roles> roles = new ArrayList<>();
        String sql = "SELECT * FROM roles WHERE role_id IN (1, 2, 4) ORDER BY role_id";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                model.Roles role = new model.Roles();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
                role.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                roles.add(role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }

    /**
     * Lấy tất cả phân quyền (roles_features)
     */
    public List<RoleFeature> getAllRoleFeatures() {
        List<RoleFeature> roleFeatures = new ArrayList<>();
        String sql = "SELECT rf.role_id, rf.feature_id, r.role_name, f.feature_name, f.url "
                + "FROM roles_features rf "
                + "JOIN roles r ON rf.role_id = r.role_id "
                + "JOIN features f ON rf.feature_id = f.feature_id "
                + "ORDER BY f.feature_id, r.role_id";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RoleFeature rf = new RoleFeature();
                rf.setRoleId(rs.getInt("role_id"));
                rf.setFeatureId(rs.getInt("feature_id"));
                rf.setRoleName(rs.getString("role_name"));
                rf.setFeatureName(rs.getString("feature_name"));
                rf.setUrl(rs.getString("url"));
                roleFeatures.add(rf);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roleFeatures;
    }

    /**
     * Kiểm tra role có quyền truy cập feature không
     */
    public boolean hasPermission(int roleId, int featureId) {
        String sql = "SELECT COUNT(*) FROM roles_features WHERE role_id = ? AND feature_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ps.setInt(2, featureId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thêm quyền cho role
     */
    public boolean addPermission(int roleId, int featureId) {
        String sql = "INSERT INTO roles_features (role_id, feature_id) VALUES (?, ?)";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ps.setInt(2, featureId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa quyền của role
     */
    public boolean removePermission(int roleId, int featureId) {
        String sql = "DELETE FROM roles_features WHERE role_id = ? AND feature_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ps.setInt(2, featureId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Đếm tổng số features
     */
    public int getTotalFeatures() {
        String sql = "SELECT COUNT(*) FROM features";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy features có phân trang
     */
    public List<Features> getFeaturesPaginated(int offset, int limit) {
        List<Features> features = new ArrayList<>();
        String sql = "SELECT * FROM features ORDER BY feature_id LIMIT ? OFFSET ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Features feature = new Features();
                    feature.setFeatureId(rs.getInt("feature_id"));
                    feature.setFeatureName(rs.getString("feature_name"));
                    feature.setUrl(rs.getString("url"));
                    features.add(feature);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return features;
    }

    /**
     * Lấy feature_id từ URL (exact hoặc prefix match, return null nếu không tìm
     * thấy).
     */
    public Integer getFeatureIdByUrl(String url) {
        String sql = "SELECT feature_id FROM features WHERE url = ? OR url LIKE ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, url);  // Exact match
            ps.setString(2, url + "%");  // Prefix cho params (e.g. /homestay-detail?id=1)

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("feature_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lưu tất cả phân quyền (xóa hết rồi thêm lại)
     */
    public boolean saveAllPermissions(List<RoleFeature> permissions) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // Xóa tất cả phân quyền hiện tại
            String deleteSql = "DELETE FROM roles_features";
            try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.executeUpdate();
            }

            // Thêm lại các phân quyền mới
            String insertSql = "INSERT INTO roles_features (role_id, feature_id) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                for (RoleFeature rf : permissions) {
                    ps.setInt(1, rf.getRoleId());
                    ps.setInt(2, rf.getFeatureId());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
    
    /**
     * Lấy danh sách RoleFeature (features được phép) cho một role cụ thể
     */
    public List<RoleFeature> getPermittedFeaturesForRole(int roleId) {
        List<RoleFeature> permittedFeatures = new ArrayList<>();
        String sql = "SELECT rf.role_id, rf.feature_id, r.role_name, f.feature_name, f.url "
                   + "FROM roles_features rf "
                   + "JOIN roles r ON rf.role_id = r.role_id "
                   + "JOIN features f ON rf.feature_id = f.feature_id "
                   + "WHERE rf.role_id = ? "
                   + "ORDER BY f.feature_id";

        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoleFeature rf = new RoleFeature();
                    rf.setRoleId(rs.getInt("role_id"));
                    rf.setFeatureId(rs.getInt("feature_id"));
                    rf.setRoleName(rs.getString("role_name"));
                    rf.setFeatureName(rs.getString("feature_name"));
                    rf.setUrl(rs.getString("url"));
                    permittedFeatures.add(rf);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permittedFeatures;
    }
}
