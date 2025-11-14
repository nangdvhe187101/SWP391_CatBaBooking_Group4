/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.OwnerRestaurant;

import dao.BookingDAO;
import dao.BusinessDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import model.Users;
import model.dto.BookingsDTO;

/**
 *
 * @author Admin
 */
@WebServlet(name = "RestaurantBookingsSearchController", urlPatterns = {"/owner-booking"})
public class RestaurantBookingsSearchController extends HttpServlet {

    private BookingDAO bookingDAO;
    private BusinessDAO businessDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        businessDAO = new BusinessDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        try {
            int businessId = businessDAO.getBusinessIdForUser(currentUser.getUserId());

            List<BookingsDTO> bookings = bookingDAO.getFilteredBookingsForOwner(businessId, null, null, null, null, null);

            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/OwnerPage/RestaurantBookings.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        try {
            int businessId = businessDAO.getBusinessIdForUser(currentUser.getUserId());

            // Lấy tham số từ form lọc
            String dateStr = request.getParameter("reservationDate");
            String timeStr = request.getParameter("reservationTime");
            String numGuestsStr = request.getParameter("numGuests");
            String status = request.getParameter("status");
            // Lấy tham số từ ô tìm kiếm
            String searchCode = request.getParameter("searchCode");

            // Chuyển đổi tham số
            LocalDate reservationDate = dateStr != null && !dateStr.isEmpty() ? LocalDate.parse(dateStr) : null;
            LocalTime reservationTime = timeStr != null && !timeStr.isEmpty() ? LocalTime.parse(timeStr) : null;
            Integer numGuests = numGuestsStr != null && !numGuestsStr.isEmpty() ? Integer.parseInt(numGuestsStr) : null;

            // Lấy danh sách booking theo bộ lọc và tìm kiếm
            List<BookingsDTO> bookings = bookingDAO.getFilteredBookingsForOwner(
                    businessId, reservationDate, reservationTime, numGuests, status, searchCode
            );

            // Lưu các giá trị lọc và tìm kiếm để hiển thị lại trên form
            request.setAttribute("bookings", bookings);
            request.setAttribute("filterDate", dateStr);
            request.setAttribute("filterTime", timeStr);
            request.setAttribute("filterNumGuests", numGuestsStr);
            request.setAttribute("filterStatus", status);
            request.setAttribute("searchCode", searchCode);
            
            // Thêm thông báo nếu không tìm thấy kết quả
            if (bookings.isEmpty() && (searchCode != null && !searchCode.trim().isEmpty())) {
                request.setAttribute("message", "Không tìm thấy booking với mã: " + searchCode);
            } else if (bookings.isEmpty()) {
                request.setAttribute("message", "Không tìm thấy booking phù hợp với bộ lọc.");
            }

            request.getRequestDispatcher("/OwnerPage/RestaurantBookings.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
