package controller.admin;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Bookings;
import model.Users;

@WebServlet(name = "BookingHistoryController", urlPatterns = {"/admin/booking-history"})
public class BookingHistoryController extends HttpServlet {

    private BookingDAO bookingDAO;
    private static final int PAGE_SIZE = 15;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null || currentUser.getRole() == null || currentUser.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        try {
            // Lấy các tham số filter
            String statusFilter = request.getParameter("status");
            if (statusFilter == null || statusFilter.isEmpty()) {
                statusFilter = "all";
            }

            String businessTypeFilter = request.getParameter("type");
            if (businessTypeFilter == null || businessTypeFilter.isEmpty()) {
                businessTypeFilter = "all";
            }

            String keyword = request.getParameter("keyword");
            if (keyword == null) {
                keyword = "";
            }

            // Lấy page number
            int page = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                }
            } catch (NumberFormatException e) {
                page = 1;
            }

            // Lấy danh sách booking
            List<Bookings> bookings = bookingDAO.getAllBookingsForAdmin(
                    statusFilter, businessTypeFilter, keyword, page, PAGE_SIZE);
            
            // Đếm tổng số booking
            int totalBookings = bookingDAO.countAllBookingsForAdmin(
                    statusFilter, businessTypeFilter, keyword);
            
            int totalPages = (int) Math.ceil((double) totalBookings / PAGE_SIZE);

            // Set attributes
            request.setAttribute("bookings", bookings);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", Math.max(totalPages, 1));
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("businessTypeFilter", businessTypeFilter);
            request.setAttribute("keyword", keyword);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải dữ liệu booking. Vui lòng thử lại sau.");
        }

        request.getRequestDispatcher("/AdminPage/BookingHistory.jsp").forward(request, response);
    }
}

