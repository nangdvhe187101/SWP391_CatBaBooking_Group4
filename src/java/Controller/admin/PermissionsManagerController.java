/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.admin;

import dao.FeaturesDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Features;

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
        // Lấy tất cả features
        List<Features> features = featuresDAO.getAllFeatures();
        
        // Lấy tất cả role-features (permissions)
        List<model.RoleFeature> roleFeatures = featuresDAO.getAllRoleFeatures();
        
        // Lấy tất cả roles (để map nếu cần)
        List<model.Roles> roles = featuresDAO.getAllRoles();

        // Set attributes cho JSP
        request.setAttribute("features", features);
        request.setAttribute("roleFeatures", roleFeatures);
        request.setAttribute("roles", roles);

        // Forward đến JSP
        request.getRequestDispatcher("/AdminPage/PermissionsManager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}