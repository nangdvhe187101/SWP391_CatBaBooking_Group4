package dao;

import model.Bookings;
import model.Businesses;
import model.Reviews;
import model.Users;
import util.DBUtil;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReviewDAO {

    public List<Reviews> findReviews(String keyword, Integer ratingFilter, String sort, int pageIndex, int pageSize) {
        List<Reviews> reviews = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {
            boolean hasStatus = columnExists(conn, "reviews", "status");

            StringBuilder sql = new StringBuilder(
                    "SELECT r.*, "
                            + "b.business_id, b.name AS business_name, b.type AS business_type, "
                            + "u.user_id, u.full_name AS user_name, u.email AS user_email "
                            + "FROM reviews r "
                            + "JOIN bookings bk ON r.booking_id = bk.booking_id "
                            + "JOIN businesses b ON r.business_id = b.business_id "
                            + "JOIN users u ON r.user_id = u.user_id "
                            + "WHERE 1=1 ");

            List<Object> params = new ArrayList<>();

            if (hasStatus) {
                sql.append("AND (r.status = 'pending' OR r.status IS NULL) ");
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append("AND (LOWER(b.name) LIKE ? OR LOWER(u.full_name) LIKE ? OR LOWER(r.comment) LIKE ?) ");
                String likeValue = "%" + keyword.trim().toLowerCase() + "%";
                params.add(likeValue);
                params.add(likeValue);
                params.add(likeValue);
            }

            if (ratingFilter != null && ratingFilter > 0) {
                sql.append("AND r.rating = ? ");
                params.add(ratingFilter);
            }

            String orderClause = switch (sort == null ? "" : sort) {
                case "rating_desc" -> "ORDER BY r.rating DESC, r.created_at DESC ";
                case "rating_asc" -> "ORDER BY r.rating ASC, r.created_at DESC ";
                default -> "ORDER BY r.created_at DESC ";
            };
            sql.append(orderClause);
            sql.append("LIMIT ? OFFSET ?");

            params.add(pageSize);
            params.add((pageIndex - 1) * pageSize);

            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }

                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Reviews review = mapReview(rs);
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public int countReviews(String keyword, Integer ratingFilter) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM reviews r "
                        + "JOIN businesses b ON r.business_id = b.business_id "
                        + "JOIN users u ON r.user_id = u.user_id "
                        + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(b.name) LIKE ? OR LOWER(u.full_name) LIKE ? OR LOWER(r.comment) LIKE ?) ");
            String likeValue = "%" + keyword.trim().toLowerCase() + "%";
            params.add(likeValue);
            params.add(likeValue);
            params.add(likeValue);
        }

        if (ratingFilter != null && ratingFilter > 0) {
            sql.append("AND r.rating = ? ");
            params.add(ratingFilter);
        }

        try (Connection conn = DBUtil.getConnection()) {
            if (columnExists(conn, "reviews", "status")) {
                sql.append("AND (r.status = 'pending' OR r.status IS NULL) ");
            }

            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getAverageRating() {
        String sql = "SELECT AVG(rating) FROM reviews";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Map<Integer, Integer> getRatingDistribution() {
        Map<Integer, Integer> distribution = new LinkedHashMap<>();
        for (int i = 5; i >= 1; i--) {
            distribution.put(i, 0);
        }

        String sql = "SELECT rating, COUNT(*) AS total FROM reviews GROUP BY rating";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                distribution.put(rs.getInt("rating"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return distribution;
    }

    public boolean deleteReviewById(int reviewId) {
        String sql = "DELETE FROM reviews WHERE review_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateReviewStatus(int reviewId, String status) {
        String sql = "UPDATE reviews SET status = ? WHERE review_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createReview(Reviews review) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            boolean hasStatus = columnExists(conn, "reviews", "status");
            String sql;
            if (hasStatus) {
                sql = "INSERT INTO reviews (booking_id, business_id, user_id, rating, comment, status, created_at) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            } else {
                sql = "INSERT INTO reviews (booking_id, business_id, user_id, rating, comment, created_at) "
                        + "VALUES (?, ?, ?, ?, ?, ?)";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                int idx = 1;
                ps.setInt(idx++, review.getBooking().getBookingId());
                ps.setInt(idx++, review.getBusiness().getBusinessId());
                ps.setInt(idx++, review.getUser().getUserId());
                ps.setInt(idx++, review.getRating());
                ps.setString(idx++, review.getComment());
                if (hasStatus) {
                    ps.setString(idx++, review.getStatus() != null ? review.getStatus() : "pending");
                }
                ps.setObject(idx, review.getCreatedAt() != null ? review.getCreatedAt() : LocalDateTime.now());
                return ps.executeUpdate() > 0;
            }
        }
    }

    public Reviews getReviewByBookingId(int bookingId) {
        String sql = "SELECT r.*, "
                + "b.business_id, b.name AS business_name, b.type AS business_type, "
                + "u.user_id, u.full_name AS user_name, u.email AS user_email "
                + "FROM reviews r "
                + "JOIN businesses b ON r.business_id = b.business_id "
                + "JOIN users u ON r.user_id = u.user_id "
                + "WHERE r.booking_id = ? "
                + "LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapReview(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Reviews getReviewByUserAndBusiness(int userId, int businessId) {
        String sql = "SELECT r.*, "
                + "b.business_id, b.name AS business_name, b.type AS business_type, "
                + "u.user_id, u.full_name AS user_name, u.email AS user_email "
                + "FROM reviews r "
                + "JOIN businesses b ON r.business_id = b.business_id "
                + "JOIN users u ON r.user_id = u.user_id "
                + "WHERE r.user_id = ? AND r.business_id = ? "
                + "ORDER BY r.created_at DESC LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, businessId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapReview(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Reviews mapReview(ResultSet rs) throws SQLException {
        Reviews review = new Reviews();
        review.setReviewId(rs.getInt("review_id"));
        review.setRating((byte) rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        if (hasColumn(rs, "status")) {
            review.setStatus(rs.getString("status"));
        }

        Bookings booking = new Bookings();
        booking.setBookingId(rs.getInt("booking_id"));
        review.setBooking(booking);

        Businesses business = new Businesses();
        business.setBusinessId(rs.getInt("business_id"));
        business.setName(rs.getString("business_name"));
        business.setType(rs.getString("business_type"));
        review.setBusiness(business);

        Users user = new Users();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("user_name"));
        user.setEmail(rs.getString("user_email"));
        review.setUser(user);

        return review;
    }

    private boolean hasColumn(ResultSet rs, String columnLabel) {
        try {
            ResultSetMetaData meta = rs.getMetaData();
            int columnCount = meta.getColumnCount();
            for (int i = 1; i <= columnCount; i++) {
                if (columnLabel.equalsIgnoreCase(meta.getColumnLabel(i))) {
                    return true;
                }
            }
        } catch (SQLException ignored) {
        }
        return false;
    }

    private boolean columnExists(Connection conn, String tableName, String columnName) {
        try {
            DatabaseMetaData meta = conn.getMetaData();
            try (ResultSet rs = meta.getColumns(conn.getCatalog(), null, tableName, columnName)) {
                if (rs.next()) {
                    return true;
                }
            }
            try (ResultSet rs = meta.getColumns(conn.getCatalog(), null, tableName.toUpperCase(), columnName.toUpperCase())) {
                return rs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }
}


