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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import model.Users;


/**
 *
 * @author ADMIN
 */
@WebServlet(name = "DeletePermissionsController", urlPatterns = {"/delete-permissions"})
public class DeletePermissionsController extends HttpServlet {

    private FeaturesDAO featuresDAO;

    @Override
    public void init() throws ServletException {
        featuresDAO = new FeaturesDAO();
    }
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/permissions-manager");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/permissions-manager");
            return;
        }
        
        try {
            int featureId = Integer.parseInt(idStr);
            
            boolean success = featuresDAO.deleteFeature(featureId);
            
            if (success) {
                session.setAttribute("successMessage", "Đã xóa URL thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể xóa URL này!");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/permissions-manager");
    }

}
