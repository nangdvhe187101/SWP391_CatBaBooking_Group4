/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.OwnerRestaurant;

import dao.AreaDAO; // THÊM MỚI
import dao.BusinessDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalTime;
import java.util.List; // THÊM MỚI
import model.Areas; // THÊM MỚI
import model.Businesses;
import model.Users;
import service.RestaurantBusinessSettingsValidator;


/**
 *
 * @author ADMIN
 */
@WebServlet(name = "RestaurantSettingsServlet", urlPatterns = {"/restaurant-settings"})
public class RestaurantSettingsController extends HttpServlet {

    private BusinessDAO businessDAO;
    private AreaDAO areaDAO; 

    @Override
    public void init()throws ServletException{
        businessDAO = new BusinessDAO();
        areaDAO = new AreaDAO();
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
        request.setAttribute("business", biz);
        List<Areas> allAreas = areaDAO.getAllAreas();
        request.setAttribute("allAreas", allAreas);
        request.getRequestDispatcher("/OwnerPage/RestaurantSettings.jsp").forward(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String description = request.getParameter("description");
        String image = request.getParameter("image");
        String areaIdRaw = request.getParameter("areaId"); 
        String openingHourRaw = request.getParameter("openingHour");
        String closingHourRaw = request.getParameter("closingHour");
        var vr = RestaurantBusinessSettingsValidator.validate(name, address, description, image, areaIdRaw);
        if(!vr.valid){
            request.setAttribute("errors", vr.errors); 
            request.setAttribute("business", businessDAO.getBusinessByOwnerId(currentUser.getUserId()));
            List<Areas> allAreas = areaDAO.getAllAreas();
            request.setAttribute("allAreas", allAreas);
            request.getRequestDispatcher("/OwnerPage/RestaurantSettings.jsp").forward(request, response);
            return;
        }
        Integer areaId = (areaIdRaw == null || areaIdRaw.isBlank()) ? null : Integer.parseInt(areaIdRaw.trim());
        
        try{
            int row = businessDAO.updateBusinessSettingsByOwnerId(currentUser.getUserId(), name, address, description, image, areaId, LocalTime.MIDNIGHT, LocalTime.MIDNIGHT);
            request.setAttribute("message", row > 0 ? "Cập nhật thành công" : "Không có thay đổi nào được áp dụng" );
        }catch(SQLException e){
            request.setAttribute("errors", List.of("có lỗi khi cập nhật: " + e.getMessage())); 
        }
        
        request.setAttribute("business", businessDAO.getBusinessByOwnerId(currentUser.getUserId()));
        List<Areas> allAreas = areaDAO.getAllAreas();
        request.setAttribute("allAreas", allAreas);
        request.getRequestDispatcher("/OwnerPage/RestaurantSettings.jsp").forward(request, response);
    }

    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}