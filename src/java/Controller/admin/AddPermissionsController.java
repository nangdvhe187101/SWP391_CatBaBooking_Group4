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
import model.RoleFeature;
import service.FeatureValidator;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "AddPermissionsController", urlPatterns = {"/savePermission"})
public class AddPermissionsController extends HttpServlet {

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
        String mode = request.getParameter("mode");
        String name = request.getParameter("name");
        String url = request.getParameter("url");
        String editIdStr = request.getParameter("id");

        // Validate input
        List<String> errors = FeatureValidator.validateFeature(name, url, null); // businessType null vì JSP không có field

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("name", name);
            request.setAttribute("url", url);
            // Reload data cho JSP
            List<Features> features = featuresDAO.getAllFeatures();
            List<model.RoleFeature> roleFeatures = featuresDAO.getAllRoleFeatures();
            request.setAttribute("features", features);
            request.setAttribute("roleFeatures", roleFeatures);
            request.getRequestDispatcher("/AdminPage/PermissionsManager.jsp").forward(request, response);
            return;
        }

        // Sanitize input
        name = FeatureValidator.sanitizeInput(name);
        url = FeatureValidator.sanitizeInput(url);

        boolean success = false;
        if ("add".equals(mode)) {
            // Kiểm tra URL tồn tại
            if (featuresDAO.isUrlExists(url, null)) {
                request.setAttribute("error", "Đường dẫn URL đã tồn tại.");
                // Reload và forward
                List<Features> features = featuresDAO.getAllFeatures();
                List<RoleFeature> roleFeatures = featuresDAO.getAllRoleFeatures();
                request.setAttribute("features", features);
                request.setAttribute("roleFeatures", roleFeatures);
                request.getRequestDispatcher("/AdminPage/PermissionsManager.jsp").forward(request, response);
                return;
            }
            Features newFeature = new Features(0, name, url); 
            success = featuresDAO.addFeature(newFeature);
            if (success) {
                // Sau khi add, cần thêm default permissions? Giả sử không, admin sẽ set sau
                request.setAttribute("success", "Thêm chức năng mới thành công!");
            }
        } else if ("edit".equals(mode)) {
            if (!FeatureValidator.isValidFeatureId(editIdStr)) {
                request.setAttribute("error", "ID không hợp lệ.");
                // Reload và forward
                List<Features> features = featuresDAO.getAllFeatures();
                List<RoleFeature> roleFeatures = featuresDAO.getAllRoleFeatures();
                request.setAttribute("features", features);
                request.setAttribute("roleFeatures", roleFeatures);
                request.getRequestDispatcher("/AdminPage/PermissionsManager.jsp").forward(request, response);
                return;
            }
            int featureId = Integer.parseInt(editIdStr);
            // Kiểm tra URL tồn tại (exclude current)
            if (featuresDAO.isUrlExists(url, featureId)) {
                request.setAttribute("error", "Đường dẫn URL đã tồn tại.");
                // Reload và forward
                List<Features> features = featuresDAO.getAllFeatures();
                List<RoleFeature> roleFeatures = featuresDAO.getAllRoleFeatures();
                request.setAttribute("features", features);
                request.setAttribute("roleFeatures", roleFeatures);
                request.getRequestDispatcher("/AdminPage/PermissionsManager.jsp").forward(request, response);
                return;
            }
            Features feature = featuresDAO.getFeatureById(featureId);
            if (feature == null) {
                request.setAttribute("error", "Không tìm thấy chức năng.");
                // Reload và forward
                List<Features> features = featuresDAO.getAllFeatures();
                List<RoleFeature> roleFeatures = featuresDAO.getAllRoleFeatures();
                request.setAttribute("features", features);
                request.setAttribute("roleFeatures", roleFeatures);
                request.getRequestDispatcher("/AdminPage/PermissionsManager.jsp").forward(request, response);
                return;
            }
            feature.setFeatureName(name);
            feature.setUrl(url);
            success = featuresDAO.updateFeature(feature);
            if (success) {
                request.setAttribute("success", "Cập nhật chức năng thành công!");
            }
        }

        if (!success) {
            request.setAttribute("error", "Có lỗi xảy ra khi lưu.");
        }

        // Reload data sau action
        List<Features> features = featuresDAO.getAllFeatures();
        List<RoleFeature> roleFeatures = featuresDAO.getAllRoleFeatures();
        request.setAttribute("features", features);
        request.setAttribute("roleFeatures", roleFeatures);
        request.getRequestDispatcher("/AdminPage/PermissionsManager.jsp").forward(request, response);
    }
}