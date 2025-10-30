/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.HomePage;

import dao.AmenityDAO;
import dao.AreaDAO;
import dao.HomestayDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Amenities;
import model.Areas;
import model.Businesses;

/**
 *
 * @author Admin
 */
@WebServlet(name="HomestayListController", urlPatterns={"/homestay-list"})
public class HomestayListController extends HttpServlet {
   
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HomestayDAO homestayDAO = new HomestayDAO();
        AreaDAO areaDAO = new AreaDAO();
        AmenityDAO amenityDAO = new AmenityDAO();
        try {
            List<Areas> areaList = areaDAO.getAllAreas();
            request.setAttribute("areaList", areaList);
            List<Amenities> amenityList = amenityDAO.getAllAmenities();
            request.setAttribute("amenityList", amenityList);
            List<Businesses> homestays = homestayDAO.getAllHomestay();
            request.setAttribute("homestays", homestays);
            request.getRequestDispatcher("/HomePage/Homestay.jsp").forward(request, response);
        } catch (Exception e) {
             e.printStackTrace();
            throw new ServletException("Lỗi khi lấy danh sách homestay: " + e.getMessage(), e);
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

  
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
