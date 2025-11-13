/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.FeaturesDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Features;
import model.Roles;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "PermissionsManagerController", urlPatterns = {"/permissions-manager"})
public class PermissionsManagerController extends HttpServlet {

    private FeaturesDAO featuresDAO;

    @Override
    public void init() throws ServletException {
        featuresDAO = new FeaturesDAO();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            int itemsPerPage = 10; 
            int offset = (currentPage - 1) * itemsPerPage;
            
            int totalFeatures = featuresDAO.getTotalFeatures();
            int totalPages = (int) Math.ceil((double) totalFeatures / itemsPerPage);
            
            List<Features> features = featuresDAO.getFeaturesPaginated(offset, itemsPerPage);
            
            List<Roles> roles = featuresDAO.getAllRoles();
            
            // Đặt dữ liệu vào request
            request.setAttribute("features", features);
            request.setAttribute("roles", roles);
            request.setAttribute("featuresDAO", featuresDAO);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalFeatures", totalFeatures);
            
            request.getRequestDispatcher("/AdminPage/PermissionsManager.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}