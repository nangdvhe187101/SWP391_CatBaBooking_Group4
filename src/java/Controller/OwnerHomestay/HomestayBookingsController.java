package controller.OwnerHomestay;

import dao.BookingDAO;
import dao.BusinessDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Bookings;
import model.Businesses;
import model.Users;

@WebServlet(name = "HomestayBookingsController", urlPatterns = {"/homestay-bookings"})
public class HomestayBookingsController extends HttpServlet {

    private BusinessDAO businessDAO;
    private BookingDAO bookingDAO;
    private static final int PAGE_SIZE = 10; // 10 đơn mỗi trang

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

        if (currentUser == null || currentUser.getRole().getRoleId() != 2) { // 2 = owner
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Businesses biz = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        if (biz == null || !"homestay".equals(biz.getType())) {
            request.setAttribute("error", "Không tìm thấy homestay hoặc cơ sở kinh doanh không phải là homestay.");
            request.getRequestDispatcher("/OwnerPage/Dashboard.jsp").forward(request, response);
            return;
        }

        // Lấy tham số trang và trạng thái
        String status = request.getParameter("status");
        if (status == null || status.trim().isEmpty()) {
            status = "all"; // Mặc định
        }

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // Dùng trang mặc định là 1
        }

        // Lấy dữ liệu
        List<Bookings> bookingList = bookingDAO.getHomestayBookingsByBusinessId(biz.getBusinessId(), status, page, PAGE_SIZE);
        int totalBookings = bookingDAO.countHomestayBookingsByBusinessId(biz.getBusinessId(), status);
        int totalPages = (int) Math.ceil((double) totalBookings / PAGE_SIZE);

        // Đặt attributes cho JSP
        request.setAttribute("bookingList", bookingList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("currentStatus", status);

        request.getRequestDispatcher("/OwnerPage/HomestayBookings.jsp").forward(request, response);
    }
}