/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.HomePage;

import dao.BusinessDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.dto.BusinessesDTO;

/**
 *
 * @author Admin
 */
@WebServlet(name="RestaurantListController", urlPatterns={"/restaurant"})
public class RestaurantListController extends HttpServlet {
   
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        BusinessDAO dao = new BusinessDAO();
        try {
        List<BusinessesDTO> restaurants = dao.getAllRestaurants();
        System.out.println("Số lượng nhà hàng lấy được: " + restaurants.size()); // Ghi log kích thước
        request.setAttribute("restaurants", restaurants);
        request.getRequestDispatcher("/HomePage/Restaurant.jsp").forward(request, response);
    } catch (Exception e) {
        e.printStackTrace();
        throw new ServletException("Lỗi khi lấy danh sách nhà hàng: " + e.getMessage(), e);
    }
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
