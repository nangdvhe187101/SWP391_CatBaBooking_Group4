package controller.HomePage;

import dao.DishCategoryDAO;
import dao.DishDao;
import dao.RestaurantDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.DishCategories;
import model.Dishes;
import model.dto.BusinessesDTO;
import model.dto.CartItemDTO;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "RestaurantDetailController", urlPatterns = {"/restaurant-detail"})
public class RestaurantDetailController extends HttpServlet {

    private RestaurantDAO restaurantDAO;
    private DishDao dishDao;
    private DishCategoryDAO dishCategoryDAO;  

    @Override
    public void init() throws ServletException {
        restaurantDAO = new RestaurantDAO();
        dishDao = new DishDao();
        dishCategoryDAO = new DishCategoryDAO();  
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {       
        try {
            HttpSession session = request.getSession();
            
            // Lấy và validate ID parameter
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/restaurants");
                return;
            }
            int businessId;
            try {
                businessId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/restaurants");
                return;
            }

            // Lấy thông tin nhà hàng
            BusinessesDTO restaurant = restaurantDAO.getRestaurantById(businessId);
            if (restaurant == null) {
                response.sendRedirect(request.getContextPath() + "/restaurants");
                return;
            }
            // Lấy categories
            List<DishCategories> categories = dishCategoryDAO.getCategoriesByBusinessId(businessId);
            if (categories == null) {
                categories = new ArrayList<>();
            } 

            // Lấy dishes
            List<Dishes> dishes = dishDao.getAllDishesByBusinessId(businessId);
            if (dishes == null) {
                dishes = new ArrayList<>();
            } 
            // Lấy giỏ hàng từ session
            List<CartItemDTO> orderItems = (List<CartItemDTO>) session.getAttribute("orderItems");
            Integer sessionRestaurantId = (Integer) session.getAttribute("restaurantId");
            // Nếu đổi nhà hàng khác, xóa giỏ hàng cũ
            if (sessionRestaurantId != null && sessionRestaurantId != businessId) {
                session.removeAttribute("orderItems");
                orderItems = null;
            }
            if (orderItems == null) {
                orderItems = new ArrayList<>();
            }
            // Lưu restaurantId vào session
            session.setAttribute("restaurantId", businessId);

            // Lấy 5 reviews gần nhất
            List<model.dto.ReviewsDTO> reviews = restaurantDAO.getReviewsByBusinessId(businessId);
            if (reviews == null) {
                reviews = new ArrayList<>();
            }

            // Set attributes
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("categories", categories);
            request.setAttribute("dishes", dishes);
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("reviews", reviews);
            // Forward đến JSP
            request.getRequestDispatcher("/HomePage/RestaurantDetail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            
            // Redirect đến error page
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Error loading restaurant details: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}