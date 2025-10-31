/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.OwnerRestaurant;

import dao.BusinessDAO;
import dao.DishDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Businesses;
import model.DishCategories;
import model.Dishes;
import model.Users;
import util.ImageUploadUtil;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.stream.Collectors;
import service.DishValidator;

/**
 *
 * @author ADMIN
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
                maxFileSize = 1024 * 1024 * 10,      
                maxRequestSize = 1024 * 1024 * 50)
@WebServlet(name = "AddDishController", urlPatterns = {"/add-dish"})
public class AddDishController extends HttpServlet {

    private DishDao dishDao = new DishDao();
    private BusinessDAO businessDAO = new BusinessDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/OwnerPage/RestaurantManageDishes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Businesses biz = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        if (biz == null) {
            request.setAttribute("error", "Bạn chưa có cơ sở kinh doanh. Hãy tạo mới trước khi quản lý món ăn.");
            request.getRequestDispatcher("/OwnerPage/RestaurantManageDishes.jsp").forward(request, response);
            return;
        }
        currentUser.setBusiness(biz);
        session.setAttribute("currentUser", currentUser);
        int businessId = biz.getBusinessId();

        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceParam = request.getParameter("price");
            String categoryIdParam = request.getParameter("category_id");
            String isActiveParam = request.getParameter("is_active");

            DishValidator.Result validationResult = DishValidator.validateAddDish(
                    name, description, businessId, dishDao
            );
            if (!validationResult.valid) {
                String allErrors = validationResult.errors.stream().collect(Collectors.joining(" "));
                session.setAttribute("error", allErrors);
                response.sendRedirect(request.getContextPath() + "/list-dish");
                return; 
            }
            
            BigDecimal price = new BigDecimal(priceParam);
            int categoryId = Integer.parseInt(categoryIdParam);
            boolean isActive = Boolean.parseBoolean(isActiveParam);

            // Tạo đối tượng Dish
            Dishes dish = new Dishes();
            
            Businesses business = new Businesses();
            business.setBusinessId(businessId);
            dish.setBusiness(business);

            DishCategories category = new DishCategories();
            category.setCategoryId(categoryId);
            dish.setCategory(category);

            // Sử dụng giá trị đã được .trim() 
            dish.setName(name.trim());
            dish.setDescription(description.trim());
            dish.setPrice(price);
            dish.setIsAvailable(isActive);

            // Xử lý upload ảnh
            Part filePart = request.getPart("dish_image_file");
            String imageUrl = ImageUploadUtil.upload(request, filePart, "dishes"); 
            dish.setImageUrl(imageUrl);

            // Thêm vào cơ sở dữ liệu
            boolean success = dishDao.addDish(dish);
            if (success) {
                session.setAttribute("success", "Thêm món ăn thành công!");
            } else {
                session.setAttribute("error", "Thêm món ăn thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi thêm món ăn: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/list-dish");
    }
}
