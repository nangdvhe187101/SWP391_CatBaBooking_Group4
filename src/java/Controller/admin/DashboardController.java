package controller.admin;

import dao.BookingDAO;
import dao.UserDAO;
import dao.BusinessDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import model.Bookings;
import model.Users;

@WebServlet(name = "DashboardController", urlPatterns = {"/admin/dashboard"})
public class DashboardController extends HttpServlet {

    private BookingDAO bookingDAO;
    private UserDAO userDAO;
    private BusinessDAO businessDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        userDAO = new UserDAO();
        businessDAO = new BusinessDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        
        // Kiểm tra quyền admin (role_id = 3)
        if (currentUser == null || currentUser.getRole() == null || currentUser.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        try {
            // 1. Lấy tổng số người dùng (không phải admin)
            int totalUsers = userDAO.countAllUsers(null, null, null);
            request.setAttribute("totalUsers", totalUsers);

            // 2. Lấy số lượng homestay/restaurant đang hoạt động
            int activeBusinesses = businessDAO.countActiveBusinesses();
            request.setAttribute("activeBusinesses", activeBusinesses);

            // 3. Lấy doanh thu tháng (tính từ các booking confirmed)
            BigDecimal monthlyRevenue = getMonthlyRevenue();
            request.setAttribute("monthlyRevenue", monthlyRevenue != null ? monthlyRevenue : BigDecimal.ZERO);

            // 4. Lấy các booking gần đây (limit 10)
            List<Bookings> recentBookings = bookingDAO.getRecentBookings(10);
            request.setAttribute("recentBookings", recentBookings);

            // 5. Thêm các thông tin khác (optional)
            int pendingApplications = getPendingApplicationsCount();
            request.setAttribute("pendingApplications", pendingApplications);

            int totalBookings = getTotalBookingsCount();
            request.setAttribute("totalBookings", totalBookings);

            int pendingPayments = getPendingPaymentsCount();
            request.setAttribute("pendingPayments", pendingPayments);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu dashboard. Vui lòng thử lại sau.");
        }

        request.getRequestDispatcher("/AdminPage/Dashboard.jsp").forward(request, response);
    }

    /**
     * Lấy doanh thu trong tháng (từ các booking đã confirmed)
     */
    private BigDecimal getMonthlyRevenue() {
        try {
            String sql = "SELECT SUM(b.total_price) as total FROM bookings b " +
                         "WHERE b.status = 'confirmed' " +
                         "AND MONTH(b.created_at) = MONTH(NOW()) " +
                         "AND YEAR(b.created_at) = YEAR(NOW())";
            
            java.sql.Connection conn = util.DBUtil.getConnection();
            java.sql.PreparedStatement ps = conn.prepareStatement(sql);
            java.sql.ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");
                ps.close();
                conn.close();
                return total;
            }
            ps.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    /**
     * Lấy số lượng yêu cầu đang chờ duyệt
     */
    private int getPendingApplicationsCount() {
        try {
            List<Users> pendingOwners = userDAO.getPendingOwners();
            return pendingOwners != null ? pendingOwners.size() : 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy tổng số booking
     */
    private int getTotalBookingsCount() {
        try {
            return bookingDAO.countAllBookingsForAdmin("all", "all", null);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy số lượng thanh toán đang chờ xử lý
     */
    private int getPendingPaymentsCount() {
        try {
            String sql = "SELECT COUNT(*) FROM bookings WHERE payment_status = 'pending'";
            
            java.sql.Connection conn = util.DBUtil.getConnection();
            java.sql.PreparedStatement ps = conn.prepareStatement(sql);
            java.sql.ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                ps.close();
                conn.close();
                return count;
            }
            ps.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
