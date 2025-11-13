package controller.user;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import model.Bookings;
import model.Users;

@WebServlet(name = "MyBookingsController", urlPatterns = {"/user/bookings"})
public class MyBookingsController extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.isBlank()) {
            statusFilter = "all";
        } else {
            statusFilter = statusFilter.toLowerCase(Locale.ROOT);
        }

        // Khởi tạo các giá trị mặc định
        List<Bookings> filtered = new ArrayList<>();
        int totalCount = 0;
        int confirmedCount = 0;
        int pendingCount = 0;
        int cancelledCount = 0;

        try {
            List<Bookings> bookings = bookingDAO.getBookingsByUser(currentUser.getUserId());
            totalCount = bookings.size();

            for (Bookings booking : bookings) {
                String badgeClass = booking.getStatusBadgeClass();
                switch (badgeClass) {
                    case "confirmed":
                        confirmedCount++;
                        break;
                    case "cancelled":
                        cancelledCount++;
                        break;
                    default:
                        pendingCount++;
                        break;
                }

                if ("all".equals(statusFilter) || badgeClass.equals(statusFilter)) {
                    filtered.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải thông tin booking. Vui lòng thử lại sau.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.");
        }

        // Luôn set các attribute để JSP không bị lỗi
        request.setAttribute("bookings", filtered);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("confirmedCount", confirmedCount);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("cancelledCount", cancelledCount);
        request.setAttribute("activeStatus", statusFilter);

        request.getRequestDispatcher("/HomePage/MyBookings.jsp").forward(request, response);
    }
}

