/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.HomePage;

import dao.AreaDAO;
import dao.HomestayDAO;
import dao.RestaurantDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Areas;
import model.Businesses;
import model.RestaurantTypes;

/**
 *
 * @author Admin
 */
@WebServlet(name="HomeController", urlPatterns={"/Home"})
public class HomeController extends HttpServlet {
    
    
    
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
        HomestayDAO homestayDAO = new HomestayDAO();
        RestaurantDAO dao = new RestaurantDAO();
        AreaDAO areaDAO = new AreaDAO();
        List<Businesses> topHomestays = homestayDAO.getTopHomestays();
        request.setAttribute("topHomestays", topHomestays);
        List<Businesses> topRestaurants = homestayDAO.getTopRestaurants();
        request.setAttribute("topRestaurants", topRestaurants);
        List<Areas> areaList = areaDAO.getAllAreas();
        request.setAttribute("areaList", areaList);
        
        List<RestaurantTypes> restaurantTypes = dao.getAllRestaurantTypes();
        request.setAttribute("restaurantTypes", restaurantTypes);
        
        request.getRequestDispatcher("/HomePage/Home.jsp").forward(request, response);
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
