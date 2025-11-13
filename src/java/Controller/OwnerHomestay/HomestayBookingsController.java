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
    private static final int PAGE_SIZE = 10;

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

        if (currentUser == null || currentUser.getRole().getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Businesses biz = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        if (biz == null || !"homestay".equals(biz.getType())) {
            request.setAttribute("error", "Không tìm thấy homestay.");
            request.getRequestDispatcher("/OwnerPage/Dashboard.jsp").forward(request, response);
            return;
        }

        // 1. Lấy tham số từ Request
        String status = request.getParameter("status");
        if (status == null) status = "all";

        String search = request.getParameter("search"); // Tên hoặc SĐT
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        int page = 1;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null) page = Integer.parseInt(pageStr);
        } catch (NumberFormatException e) { }

        // 2. Gọi DAO tìm kiếm
        List<Bookings> bookingList = bookingDAO.searchHomestayBookings(
                biz.getBusinessId(), status, search, fromDate, toDate, page, PAGE_SIZE);
        
        int totalRecords = bookingDAO.countSearchHomestayBookings(
                biz.getBusinessId(), status, search, fromDate, toDate);
        
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        // 3. Set Attributes để hiển thị lại trên Form
        request.setAttribute("bookingList", bookingList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        
        // Giữ lại giá trị bộ lọc
        request.setAttribute("currentStatus", status);
        request.setAttribute("search", search);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);

        request.getRequestDispatcher("/OwnerPage/HomestayBookings.jsp").forward(request, response);
    }
}