/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.HomePage;

import dao.AreaDAO;
import dao.RestaurantDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import model.Areas;
import model.dto.BusinessesDTO;

/**
 *
 * @author Admin
 */
@WebServlet(name = "SearchRestaurantController", urlPatterns = {"/restaurants"})
public class SearchRestaurantController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        AreaDAO areaDAO = new AreaDAO();

        try {
            List<String> restaurantTypes = restaurantDAO.getAllRestaurantTypes();
            List<Areas> areaList = areaDAO.getAllAreas();
            request.setAttribute("restaurantTypes", restaurantTypes);
            request.setAttribute("areaList", areaList);

            // 2. Lấy tham số tìm kiếm
            String type = request.getParameter("restaurantType");
            String areaIdStr = request.getParameter("areaId");
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            String guestsStr = request.getParameter("numGuests");

            // Xử lý đánh giá (checkbox)
            Double minRating = null;
            if (request.getParameter("rating5") != null) {
                minRating = 5.0;
            } else if (request.getParameter("rating4") != null) {
                minRating = 4.0;
            } else if (request.getParameter("rating3") != null) {
                minRating = 3.0;
            } else if (request.getParameter("rating2") != null) {
                minRating = 2.0;
            } else if (request.getParameter("rating1") != null) {
                minRating = 1.0;
            }

            Integer areaId = parseIntOrNull(areaIdStr);
            LocalDate date = parseDateOrNull(dateStr);
            LocalTime time = parseTimeOrNull(timeStr);
            Integer numGuests = parseIntOrNull(guestsStr);

            List<BusinessesDTO> restaurants;
            // 3. Nếu có bất kỳ filter nào → tìm kiếm
            if (type != null || areaId != null || date != null || time != null || numGuests != null || minRating != null) {
                restaurants = restaurantDAO.searchRestaurants(type, areaId, date, time, numGuests, minRating);
            } else {
                restaurants = restaurantDAO.getAllRestaurants(); // Method cũ của bạn
            }

            request.setAttribute("restaurants", restaurants);
            request.setAttribute("resultCount", restaurants.size());

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tìm kiếm nhà hàng.");
        }

        request.getRequestDispatcher("/HomePage/Restaurant.jsp").forward(request, response);
    }

    // Helper methods
    private Integer parseIntOrNull(String str) {
        try {
            return str != null && !str.trim().isEmpty() ? Integer.parseInt(str) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private LocalDate parseDateOrNull(String str) {
        try {
            return str != null && !str.trim().isEmpty() ? LocalDate.parse(str) : null;
        } catch (Exception e) {
            return null;
        }
    }

    private LocalTime parseTimeOrNull(String str) {
        try {
            return str != null && !str.trim().isEmpty() ? LocalTime.parse(str) : null;
        } catch (Exception e) {
            return null;
        }
    }



    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
