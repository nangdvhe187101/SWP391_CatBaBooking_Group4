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
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.Businesses;
import model.DishCategories;
import model.Dishes;
import model.Users;

/**
 *
 * @author ADMIN
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
                maxFileSize = 1024 * 1024 * 10,      
                maxRequestSize = 1024 * 1024 * 50)
@WebServlet(name = "ListDishController", urlPatterns = {"/list-dish"})
public class ListDishController extends HttpServlet {

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
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 4) {
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
        List<Dishes> dishes = dishDao.getAllDishesByBusinessId(businessId);
        List<DishCategories> categories = categoryDao.getCategoriesByBusinessId(businessId);

        request.setAttribute("dishes", dishes);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/OwnerPage/RestaurantManageDishes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
