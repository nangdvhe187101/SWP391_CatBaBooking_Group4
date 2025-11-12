/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.OwnerRestaurant;

import dao.BusinessDAO;
import dao.DishCategoryDAO;
import dao.DishDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.stream.Collectors;
import model.Businesses;
import model.DishCategories;
import model.Dishes;
import model.Users;
import service.DishValidator;
import util.ImageUploadUtil;


/**
 *
 * @author ADMIN
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
                 maxFileSize = 1024 * 1024 * 10,      
                 maxRequestSize = 1024 * 1024 * 50)
@WebServlet(name = "UpdateDishController", urlPatterns = {"/update-dish"})
public class UpdateDishController extends HttpServlet {

    private DishDao dishDao = new DishDao();
    private DishCategoryDAO categoryDao = new DishCategoryDAO();
    private BusinessDAO businessDAO = new BusinessDAO();

    @Override
    public void init() throws ServletException {
        dishDao = new DishDao();
        categoryDao = new DishCategoryDAO();
        businessDAO = new BusinessDAO();
    }
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/OwnerPage/RestaurantManageDishes.jsp").forward(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            Users currentUser = (Users) session.getAttribute("currentUser");
            if (currentUser == null || currentUser.getBusiness() == null || currentUser.getRole().getRoleId() != 4) {
                session.setAttribute("error", "Phiên làm việc hết hạn hoặc bạn không có quyền.");
                response.sendRedirect(request.getContextPath() + "/Login");
                return;
            }
            
            int businessId = currentUser.getBusiness().getBusinessId();

            // Lấy params với check null/empty
            String dishIdStr = request.getParameter("dish_id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String categoryIdStr = request.getParameter("category_id");
            String isActiveStr = request.getParameter("is_active");  
            String existingImageUrl = request.getParameter("existing_image_url");

            // Debug log
            System.out.println("DEBUG UpdateDish - Params: dish_id='" + dishIdStr + "', price='" + priceStr + "', category_id='" + categoryIdStr + "', name='" + name + "'");

            if (dishIdStr == null || dishIdStr.trim().isEmpty()) {
                session.setAttribute("error", "ID món ăn không hợp lệ (thiếu hoặc rỗng).");
                response.sendRedirect(request.getContextPath() + "/list-dish");
                return;
            }
            if (priceStr == null || priceStr.trim().isEmpty()) {
                session.setAttribute("error", "Giá tiền không được để trống.");
                response.sendRedirect(request.getContextPath() + "/list-dish");
                return;
            }
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                session.setAttribute("error", "Danh mục không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/list-dish");
                return;
            }

            // Parse dishId an toàn
            int dishId;
            try {
                dishId = Integer.parseInt(dishIdStr.trim());
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID món ăn không đúng định dạng số: '" + dishIdStr + "'.");
                response.sendRedirect(request.getContextPath() + "/list-dish");
                return;
            }

            // Parse categoryId an toàn
            int categoryId;
            try {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID danh mục không đúng định dạng số: '" + categoryIdStr + "'.");
                response.sendRedirect(request.getContextPath() + "/list-dish");
                return;
            }

            boolean isActive = Boolean.parseBoolean(isActiveStr != null ? isActiveStr.trim() : "false");

            // Validate name & description (sử dụng validateUpdateDish để check duplicate loại trừ chính nó)
            DishValidator.Result nameResult = DishValidator.validateUpdateDish(dishId, name, description, businessId, dishDao);
            if (!nameResult.valid) {
                String allErrors = nameResult.errors.stream().collect(Collectors.joining(", "));
                session.setAttribute("error", "Cập nhật thất bại: " + allErrors);
                response.sendRedirect(request.getContextPath() + "/list-dish");
                return;
            }

            // Validate price
            DishValidator.Result priceResult = DishValidator.validatePrice(priceStr);
            if (!priceResult.valid) {
                String allErrors = priceResult.errors.stream().collect(Collectors.joining(", "));
                session.setAttribute("error", allErrors);
                response.sendRedirect(request.getContextPath() + "/list-dish");
                return;
            }

            // Parse price sau validate
            BigDecimal price = new BigDecimal(priceStr.trim().replace(",", ""));

            // Xử lý Upload ảnh (nếu có ảnh mới)
            Part filePart = request.getPart("dish_image_file");
            String imageUrl = existingImageUrl;

            if (filePart != null && filePart.getSize() > 0) {
                try {
                    // Xóa file ảnh cũ (nếu không phải external URL)
                    if (existingImageUrl != null && !existingImageUrl.startsWith("http")) {
                        ImageUploadUtil.deleteByUrl(request, existingImageUrl); 
                    }
                    
                    // Upload file mới
                    imageUrl = ImageUploadUtil.upload(request, filePart, "dishes");
                    if (imageUrl == null) {
                        session.setAttribute("error", "Upload ảnh thất bại.");
                        response.sendRedirect(request.getContextPath() + "/list-dish");
                        return;
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    session.setAttribute("error", "Lỗi khi tải ảnh mới lên: " + e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/list-dish");
                    return;
                }
            }
            
            // Tạo đối tượng Dish để cập nhật
            Dishes dishToUpdate = new Dishes();
            dishToUpdate.setDishId(dishId);
            dishToUpdate.setName(name.trim());
            dishToUpdate.setDescription(description != null ? description.trim() : "");
            dishToUpdate.setPrice(price);
            dishToUpdate.setIsAvailable(isActive);
            dishToUpdate.setImageUrl(imageUrl); 

            // Set Category
            DishCategories category = new DishCategories();
            category.setCategoryId(categoryId);
            dishToUpdate.setCategory(category);
            
            // Set Business 
            Businesses business = new Businesses();
            business.setBusinessId(businessId);
            dishToUpdate.setBusiness(business);
            
            // Gọi DAO để update
            boolean success = dishDao.updateDish(dishToUpdate);

            if (success) {
                session.setAttribute("success", "Cập nhật món ăn thành công!");
            } else {
                session.setAttribute("error", "Cập nhật món ăn thất bại do lỗi cơ sở dữ liệu.");
                // Cleanup ảnh mới nếu update fail
                if (imageUrl != null && !imageUrl.equals(existingImageUrl)) {
                    ImageUploadUtil.deleteByUrl(request, imageUrl);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Đã xảy ra lỗi nghiêm trọng: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/list-dish");
    }
   
}
