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
import java.util.List;
import model.Users;
import model.dto.BookingsDTO;

/**
 *
 * @author Admin
 */
@WebServlet(name = "OwnerBookingsController", urlPatterns = {"/owner-bookings"})
public class OwnerBookingsController extends HttpServlet {

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
        
        List<BookingsDTO> bookings = bookingDAO.getBookingsForOwner(businessId);
            
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
