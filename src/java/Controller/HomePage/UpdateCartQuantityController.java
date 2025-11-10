package controller.HomePage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.dto.CartItemDTO;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "UpdateCartQuantityController", urlPatterns = {"/update-cart-quantity"})
public class UpdateCartQuantityController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String dishIdStr = request.getParameter("dishId");
        String deltaStr = request.getParameter("delta");
        String restaurantIdStr = request.getParameter("restaurantId");
        
        try {
            int dishId = Integer.parseInt(dishIdStr);
            int delta = Integer.parseInt(deltaStr);
            int restaurantId = Integer.parseInt(restaurantIdStr);
            
            // Lấy cart từ session
            List<CartItemDTO> orderItems = (List<CartItemDTO>) session.getAttribute("orderItems");
            
            if (orderItems != null) {
                // Tìm item và cập nhật quantity
                CartItemDTO itemToUpdate = null;
                for (CartItemDTO item : orderItems) {
                    if (item.getDishId() == dishId) {
                        itemToUpdate = item;
                        break;
                    }
                }
                
                if (itemToUpdate != null) {
                    int newQty = itemToUpdate.getQuantity() + delta;
                    
                    if (newQty <= 0) {
                        // Xóa nếu quantity <= 0
                        orderItems.remove(itemToUpdate);
                    } else if (newQty > 99) {
                        // Giới hạn tối đa 99
                        itemToUpdate.setQuantity(99);
                    } else {
                        itemToUpdate.setQuantity(newQty);
                    }
                    
                    // Cập nhật lại session
                    session.setAttribute("orderItems", orderItems);
                }
            }
            // Redirect về trang detail
            response.sendRedirect(request.getContextPath() + "/restaurant-detail?id=" + restaurantId);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/restaurants?error=invalid_input");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/restaurants?error=update_failed");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}