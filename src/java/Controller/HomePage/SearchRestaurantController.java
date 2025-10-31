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
import java.time.format.DateTimeParseException;
import java.util.List;
import model.Areas;
import model.RestaurantTypes;
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
            List<RestaurantTypes> restaurantTypes = restaurantDAO.getAllRestaurantTypes();
            List<Areas> areaList = areaDAO.getAllAreas();
            request.setAttribute("restaurantTypes", restaurantTypes);
            request.setAttribute("areaList", areaList);

            // 2. Lấy tham số tìm kiếm
            String typeIdStr = request.getParameter("restaurantType");
            String areaIdStr = request.getParameter("areaId");
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            String guestsStr = request.getParameter("numGuests");
            String minRatingStr = request.getParameter("minRating");

          
            List<BusinessesDTO> restaurants;
            if (typeIdStr != null || areaIdStr != null || dateStr != null || timeStr != null || guestsStr != null || minRatingStr != null) {
                int typeId = 0;
                int areaId = 0;
                Integer numGuests = null;
                Double minRating = null;
                LocalDate date = null;
                LocalTime time = null;
                
                try {
                    if (typeIdStr != null && !typeIdStr.isEmpty()) {
                        typeId = Integer.parseInt(typeIdStr);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Lỗi parse typeStr:" + typeIdStr);
                }
                
                try {
                    if (areaIdStr != null && !areaIdStr.isEmpty()) {
                        areaId = Integer.parseInt(areaIdStr);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Lỗi parse areaId:" + areaIdStr);
                }
                
                try {
                    if (guestsStr != null && !guestsStr.isEmpty()) {
                        numGuests = Integer.parseInt(guestsStr);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Lỗi parse numGuests:" + guestsStr);
                }
                
                try {
                    if (dateStr != null && !dateStr.isEmpty()) {
                        date = LocalDate.parse(dateStr);
                    }
                } catch (DateTimeParseException e) {
                    System.err.println("Lỗi parse ngày: " + dateStr);
                }
                
                try {
                    if (timeStr != null && !timeStr.isEmpty()) {
                        time = LocalTime.parse(timeStr);
                    }
                } catch (DateTimeParseException e) {
                    System.err.println("Lỗi parse giờ: " + timeStr);
                }
                
                try {
                    if (minRatingStr != null && !minRatingStr.trim().isEmpty()) {
                        minRating = Double.valueOf(minRatingStr);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Lỗi parsr rating" + minRatingStr);
                }
                
                restaurants = restaurantDAO.searchRestaurants(typeId, areaId, date, time, numGuests, minRating);
                
            } else {
                restaurants = restaurantDAO.getAllRestaurants();
            }

            request.setAttribute("restaurants", restaurants);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tìm kiếm nhà hàng.");
        }

        request.getRequestDispatcher("/HomePage/Restaurant.jsp").forward(request, response);
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
