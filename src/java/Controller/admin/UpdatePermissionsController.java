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
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Features;
import model.RoleFeature;
import model.Roles;

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
        // Không hỗ trợ GET
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Parse form data: permissions[i][role] = true/false
        Map<Integer, Map<Integer, Boolean>> permissionsMap = new HashMap<>();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            if (paramName.startsWith("permissions[")) {
                // Parse permissions[featureIndex][roleName]
                String[] parts = paramName.replace("permissions[", "").replace("]", "").split("\\]\\[");
                if (parts.length == 2) {
                    try {
                        int featureIndex = Integer.parseInt(parts[0]);
                        String roleName = parts[1];
                        boolean isChecked = "true".equals(request.getParameter(paramName));

                        // Map roleName to roleId (giả sử hardcode dựa trên JSP: customer=1, guest=2, ownerHomestay=3, ownerRestaurant=4)
                        // Nên dùng dao để map động, nhưng để đơn giản
                        int roleId;
                        switch (roleName) {
                            case "customer": roleId = 1; break;
                            case "guest": roleId = 2; break;
                            case "ownerHomestay": roleId = 3; break;
                            case "ownerRestaurant": roleId = 4; break;
                            default: continue;
                        }

                        permissionsMap.computeIfAbsent(featureIndex, k -> new HashMap<>()).put(roleId, isChecked);
                    } catch (NumberFormatException e) {
                        // Ignore invalid
                    }
                }
            }
        }

        // Chuyển thành List<RoleFeature> chỉ với checked=true
        List<RoleFeature> permissions = new ArrayList<>();
        List<Features> features = featuresDAO.getAllFeatures();
        for (int i = 0; i < features.size(); i++) {
            int featureId = features.get(i).getFeatureId();
            Map<Integer, Boolean> rolePerms = permissionsMap.get(i);
            if (rolePerms != null) {
                for (Map.Entry<Integer, Boolean> entry : rolePerms.entrySet()) {
                    if (entry.getValue()) { 
                        RoleFeature rf = new RoleFeature(entry.getKey(), featureId);
                        permissions.add(rf);
                    }
                }
            }
        }

        // Lưu tất cả permissions
        boolean success = featuresDAO.saveAllPermissions(permissions);
        if (success) {
            request.setAttribute("success", "Cập nhật phân quyền thành công!");
        } else {
            request.setAttribute("error", "Có lỗi khi cập nhật phân quyền.");
        }

        // Reload data
        List<model.RoleFeature> roleFeatures = featuresDAO.getAllRoleFeatures();
        request.setAttribute("features", features);
        request.setAttribute("roleFeatures", roleFeatures);
        request.getRequestDispatcher("/AdminPage/PermissionsManager.jsp").forward(request, response);
    }
}