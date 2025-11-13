package controller.OwnerHomestay; // Chú ý package name chữ thường

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.BookingDAO;
import dao.BusinessDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Bookings;
import model.Businesses;
import model.Users;
import model.dto.BookedRoomDTO;

@WebServlet(name = "GetHomestayBookingDetailsController", urlPatterns = {"/get-homestay-booking-details"})
public class GetHomestayBookingDetailsController extends HttpServlet {

    private BookingDAO bookingDAO;
    private BusinessDAO businessDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        businessDAO = new BusinessDAO();
        
        gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, new util.LocalDateTimeAdapter())
            .registerTypeAdapter(LocalDate.class, new util.LocalDateAdapter())
            .registerTypeAdapter(LocalTime.class, new util.LocalTimeAdapter())
            .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getRole().getRoleId() != 2) {
            response.setStatus(401);
            out.print("{\"error\":\"Unauthorized\"}");
            return;
        }

        Businesses biz = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        if (biz == null) {
            response.setStatus(403);
            out.print("{\"error\":\"No Business\"}");
            return;
        }

        try {
            String bookingIdStr = request.getParameter("bookingId");
            if(bookingIdStr == null) return;
            
            int bookingId = Integer.parseInt(bookingIdStr);
            
            Bookings booking = bookingDAO.getBookingById(bookingId); 
            
            if (booking == null || booking.getBusiness() == null || booking.getBusiness().getBusinessId() != biz.getBusinessId()) {
                response.setStatus(403);
                out.print("{\"error\":\"Access Denied\"}");
                return;
            }

            List<BookedRoomDTO> rooms = bookingDAO.getBookedRoomsByBookingId(bookingId);
            
            // [FIX] Lấy ngày tạo từ DB
            LocalDateTime createdAt = bookingDAO.getBookingCreatedTime(bookingId);

            Map<String, Object> responseData = new HashMap<>();
            responseData.put("booking", booking);
            responseData.put("rooms", rooms);
            responseData.put("createdAt", createdAt); // Gửi thêm trường này

            out.print(gson.toJson(responseData));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            out.print("{\"error\":\"Server Error\"}");
        }
    }
}