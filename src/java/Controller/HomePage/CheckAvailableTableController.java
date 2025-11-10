package controller.HomePage;

import com.google.gson.Gson;
import dao.RestaurantTableDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import model.RestaurantTables;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "CheckAvailableTableController", urlPatterns = {"/check-available-table"})
public class CheckAvailableTableController extends HttpServlet {
    private RestaurantTableDAO tableDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        tableDAO = new RestaurantTableDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Parse params
            String resIdParam = request.getParameter("restaurantId");
            String guestsParam = request.getParameter("numGuests");
            String dateParam = request.getParameter("date");
            String timeParam = request.getParameter("time");

            if (resIdParam == null || guestsParam == null || dateParam == null || timeParam == null) {
                response.setStatus(400);
                response.getWriter().write(gson.toJson(new Response(false, "Missing parameters")));
                return;
            }

            int restaurantId = Integer.parseInt(resIdParam);
            int numGuests = Integer.parseInt(guestsParam);
            LocalDate date = LocalDate.parse(dateParam);
            LocalTime time = LocalTime.parse(timeParam + ":00"); 

            // Check future date
            if (date.isBefore(LocalDate.now())) {
                response.setStatus(400);
                response.getWriter().write(gson.toJson(new Response(false, "Date must be in the future")));
                return;
            }

            RestaurantTables table = tableDAO.findSuitableTableForPreview(restaurantId, numGuests, date, time);
            if (table != null) {
                response.getWriter().write(gson.toJson(new Response(true, null, table.getName(), table.getCapacity())));
            } else {
                response.getWriter().write(gson.toJson(new Response(false, "No suitable table available for " + numGuests + " guests")));
            }
        } catch (NumberFormatException e) {
            response.setStatus(400);
            response.getWriter().write(gson.toJson(new Response(false, "Invalid parameters")));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write(gson.toJson(new Response(false, "Server error")));
        }
    }

    // Inner class cho JSON response
    private static class Response {
        boolean available;
        String message;
        String tableName;
        int capacity;

        Response(boolean available, String message) {
            this.available = available;
            this.message = message;
        }

        Response(boolean available, String message, String tableName, int capacity) {
            this(available, message);
            this.tableName = tableName;
            this.capacity = capacity;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);  
    }
}