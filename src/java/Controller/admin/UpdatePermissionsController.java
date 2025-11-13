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
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Features;
import model.RoleFeature;
import model.Roles;
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "UpdatePermissionsController", urlPatterns = {"/update-permissions"})
public class UpdatePermissionsController extends HttpServlet {

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


        int currentPage = 1;

        try {
            String pageParam = request.getParameter("page");
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

            List<Features> features = featuresDAO.getFeaturesPaginated(offset, itemsPerPage);
            List<Roles> roles = featuresDAO.getAllRoles();

            boolean hasChanges = false;
            for (Features feature : features) {
                for (Roles role : roles) {
                    String paramName = "permission_" + feature.getFeatureId() + "_" + role.getRoleId();
                    boolean isChecked = request.getParameter(paramName) != null;
                    boolean hasPermission = featuresDAO.hasPermission(role.getRoleId(), feature.getFeatureId());

                    if (isChecked != hasPermission) {
                        hasChanges = true;
                        if (isChecked) {
                            featuresDAO.addPermission(role.getRoleId(), feature.getFeatureId());
                        } else {
                            featuresDAO.removePermission(role.getRoleId(), feature.getFeatureId());
                        }
                    }
                }
            }

            if (hasChanges) {
                session.setAttribute("successMessage", "Cập nhật phân quyền thành công");
            } else {
                session.setAttribute("infoMessage", "Không có thay đổi nào được thực hiện");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/permissions-manager?page=" + currentPage);
    }
}
