package controller.owner;

import dao.BookingDAO;
import dao.BusinessDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import model.Bookings;
import model.Businesses;
import model.Users;

@WebServlet(name = "OwnerDashboardController", urlPatterns = {"/owner-dashboard"})
public class OwnerDashboardController extends HttpServlet {

    private BusinessDAO businessDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        businessDAO = new BusinessDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        // 1. Check Login & Role Owner (Role ID = 2)
        if (currentUser == null && (currentUser.getRole().getRoleId() == 2 || currentUser.getRole().getRoleId() == 4)) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        // 2. Lấy thông tin Business của Owner
        Businesses biz = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        
        if (biz == null) {
            // Trường hợp account mới chưa tạo homestay/nhà hàng
            request.setAttribute("error", "Bạn chưa có cơ sở kinh doanh nào.");
            request.getRequestDispatcher("/OwnerPage/Dashboard.jsp").forward(request, response);
            return;
        }

        // 3. Lấy các thông số thống kê thực tế
        int businessId = biz.getBusinessId();
        
        // a. Tổng doanh thu (Chỉ tính đơn đã hoàn thành/xác nhận)
        BigDecimal totalRevenue = bookingDAO.getTotalRevenue(businessId);
        
        // b. Đếm số lượng đơn
        int totalBookings = bookingDAO.countBookingsByStatus(businessId, null); // null = đếm tất cả
        int pendingBookings = bookingDAO.countBookingsByStatus(businessId, "pending"); // Đếm đơn chờ
        
        // c. Đánh giá (Lấy từ Business object)
        BigDecimal avgRating = biz.getAvgRating();
        int reviewCount = biz.getReviewCount();

        // d. Đơn hàng gần đây (Lấy 5 đơn mới nhất)
        List<Bookings> recentList = bookingDAO.getRecentBookings(businessId, 5);

        // 4. Đẩy dữ liệu ra JSP
        request.setAttribute("business", biz);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("pendingBookings", pendingBookings);
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("reviewCount", reviewCount);
        request.setAttribute("recentList", recentList);

        request.getRequestDispatcher("/OwnerPage/Dashboard.jsp").forward(request, response);
    }
}