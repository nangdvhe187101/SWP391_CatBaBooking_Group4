package controller.HomePage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import model.dto.CartItemDTO;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "RemoveFromCartController", urlPatterns = {"/remove-from-cart"})
public class RemoveFromCartController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String dishIdStr = request.getParameter("dishId");
        String restaurantIdStr = request.getParameter("restaurantId");
        
        try {
            int dishId = Integer.parseInt(dishIdStr);
            int restaurantId = Integer.parseInt(restaurantIdStr);
            List<CartItemDTO> orderItems = (List<CartItemDTO>) session.getAttribute("orderItems");
            if (orderItems != null) {
                Iterator<CartItemDTO> iterator = orderItems.iterator();
                while (iterator.hasNext()) {
                    CartItemDTO item = iterator.next();
                    if (item.getDishId() == dishId) {
                        iterator.remove();
                        break;
                    }
                }
                session.setAttribute("orderItems", orderItems);
            }
            // Redirect về trang hiện tại
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("checkout-restaurant")) {
                response.sendRedirect(request.getContextPath() + "/checkout-restaurant");
            } else {
                response.sendRedirect(request.getContextPath() + "/restaurant-detail?id=" + restaurantId + "&cartUpdated=true");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/restaurants?error=invalid_input");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/restaurants?error=remove_failed");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}