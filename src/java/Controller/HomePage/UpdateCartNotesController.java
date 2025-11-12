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
@WebServlet(name = "UpdateCartNotesController", urlPatterns = {"/update-cart-notes"})
public class UpdateCartNotesController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String dishIdStr = request.getParameter("dishId");
        String notes = request.getParameter("notes");
        String restaurantIdStr = request.getParameter("restaurantId");
        
        try {
            int dishId = Integer.parseInt(dishIdStr);
            int restaurantId = Integer.parseInt(restaurantIdStr);
            
            // Lấy cart từ session
            List<CartItemDTO> orderItems = (List<CartItemDTO>) session.getAttribute("orderItems");
            
            if (orderItems != null) {
                // Tìm item và cập nhật notes
                for (CartItemDTO item : orderItems) {
                    if (item.getDishId() == dishId) {
                        String trimmedNotes = (notes != null) ? notes.trim() : "";
                        item.setNotes(trimmedNotes);
                        break;
                    }
                }
                // Cập nhật lại session
                session.setAttribute("orderItems", orderItems);
            }
            // Redirect về trang detail (không hiển thị toast vì notes update thường xuyên)
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