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
import java.util.List;
import model.Features;
import model.RoleFeature;
import model.Users;
import service.FeatureValidator;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "AddPermissionsController", urlPatterns = {"/save-permission"})
public class AddPermissionsController extends HttpServlet {

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
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }        
        String mode = request.getParameter("mode");
        String name = request.getParameter("name");
        String url = request.getParameter("url");
        
        // Validate input
        List<String> nameErrors = FeatureValidator.validateFeatureName(name);
        List<String> urlErrors = FeatureValidator.validateUrl(url);
        
        if (!nameErrors.isEmpty() || !urlErrors.isEmpty()) {
            // Có lỗi validation
            StringBuilder errorMsg = new StringBuilder();
            for (String error : nameErrors) {
                errorMsg.append(error).append("; ");
            }
            for (String error : urlErrors) {
                errorMsg.append(error).append("; ");
            }
            session.setAttribute("errorMessage", errorMsg.toString());
            response.sendRedirect(request.getContextPath() + "/permissions-manager");
            return;
        }
        
        try {
            if ("add".equals(mode)) {
                // Thêm mới feature
                
                // Kiểm tra URL đã tồn tại chưa
                if (featuresDAO.isUrlExists(url, null)) {
                    session.setAttribute("errorMessage", "URL đã tồn tại trong hệ thống!");
                    response.sendRedirect(request.getContextPath() + "/permissions-manager");
                    return;
                }
                
                Features feature = new Features();
                feature.setFeatureName(name.trim());
                feature.setUrl(url.trim());
                
                boolean success = featuresDAO.addFeature(feature);
                
                if (success) {
                    session.setAttribute("successMessage", "Đã thêm URL mới thành công!");
                } else {
                    session.setAttribute("errorMessage", "Không thể thêm URL mới!");
                }
                
            } else if ("edit".equals(mode)) {
                // Cập nhật feature
                String idStr = request.getParameter("id");
                
                if (idStr == null || idStr.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "ID không hợp lệ!");
                    response.sendRedirect(request.getContextPath() + "/permissions-manager");
                    return;
                }
                
                try {
                    int featureId = Integer.parseInt(idStr);
                    
                    // Kiểm tra URL đã tồn tại chưa (trừ feature hiện tại)
                    if (featuresDAO.isUrlExists(url, featureId)) {
                        session.setAttribute("errorMessage", "URL đã tồn tại trong hệ thống!");
                        response.sendRedirect(request.getContextPath() + "/permissions-manager");
                        return;
                    }
                    
                    Features feature = new Features();
                    feature.setFeatureId(featureId);
                    feature.setFeatureName(name.trim());
                    feature.setUrl(url.trim());
                    
                    boolean success = featuresDAO.updateFeature(feature);
                    
                    if (success) {
                        session.setAttribute("successMessage", "Đã cập nhật URL thành công!");
                    } else {
                        session.setAttribute("errorMessage", "Không thể cập nhật URL!");
                    }
                    
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "ID không hợp lệ!");
                }
                
            } else {
                session.setAttribute("errorMessage", "Chế độ không hợp lệ!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/permissions-manager");
    }
}