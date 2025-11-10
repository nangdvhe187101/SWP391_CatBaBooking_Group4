package controller.HomePage;

import dao.DishDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Dishes;
import model.dto.CartItemDTO;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "AddToCartController", urlPatterns = {"/add-to-cart"})
public class AddToCartController extends HttpServlet {

    private DishDao dishDao;

    @Override
    public void init() throws ServletException {
        dishDao = new DishDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/restaurants");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Lấy parameters từ form
        String dishIdStr = request.getParameter("dishId");
        String quantityStr = request.getParameter("quantity");
        String notes = request.getParameter("notes");
        String restaurantIdStr = request.getParameter("restaurantId");

        try {
            int dishId = Integer.parseInt(dishIdStr);
            int quantity = Integer.parseInt(quantityStr);
            int restaurantId = Integer.parseInt(restaurantIdStr);

            // Validate quantity
            if (quantity < 1) {
                quantity = 1;
            } else if (quantity > 99) {
                quantity = 99;
            }

            // Load dish từ DB
            Dishes dish = dishDao.getDishById(dishId);
            if (dish == null) {
                System.err.println("[AddToCart] Dish not found: " + dishId);
                response.sendRedirect(request.getContextPath() + "/restaurant-detail?id=" + restaurantId + "&error=dish_not_found");
                return;
            }

            // Kiểm tra món có available không
            if (!dish.isIsAvailable()) {
                System.err.println("[AddToCart] Dish not available: " + dishId);
                response.sendRedirect(request.getContextPath() + "/restaurant-detail?id=" + restaurantId + "&error=dish_not_available");
                return;
            }

            // Lấy cart từ session (hoặc tạo mới)
            List<CartItemDTO> orderItems = (List<CartItemDTO>) session.getAttribute("orderItems");
            if (orderItems == null) {
                orderItems = new ArrayList<>();
            }

            // Kiểm tra món đã có trong cart chưa
            boolean found = false;
            for (CartItemDTO item : orderItems) {
                if (item.getDishId() == dishId) {
                    // Cập nhật quantity
                    int newQty = item.getQuantity() + quantity;
                    if (newQty > 99) {
                        newQty = 99;
                    }
                    item.setQuantity(newQty);
                    
                    // Cập nhật notes nếu có
                    if (notes != null && !notes.trim().isEmpty()) {
                        item.setNotes(notes.trim());
                    }
                    found = true;
                    break;
                }
            }

            // Nếu chưa có, thêm mới
            if (!found) {
                CartItemDTO newItem = new CartItemDTO();
                newItem.setDishId(dishId);
                newItem.setQuantity(quantity);
                newItem.setPriceAtBooking(dish.getPrice());
                newItem.setDishName(dish.getName());
                newItem.setDishImage(dish.getImageUrl());
                newItem.setNotes(notes != null ? notes.trim() : "");
                orderItems.add(newItem);
            }

            // Lưu lại vào session
            session.setAttribute("orderItems", orderItems);
            session.setAttribute("restaurantId", restaurantId);
            // Redirect về trang detail với thông báo thành công
            response.sendRedirect(request.getContextPath() + "/restaurant-detail?id=" + restaurantId);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/restaurants?error=invalid_input");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/restaurants?error=add_cart_failed");
        }
    }
}