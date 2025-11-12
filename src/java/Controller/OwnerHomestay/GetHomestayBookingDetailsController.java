package controller.OwnerHomestay;

import com.google.gson.Gson;
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
import java.util.List;
import model.Bookings;
import model.Businesses;
import model.Users;
import model.dto.BookedRoomDTO;

@WebServlet(name = "GetHomestayBookingDetailsController", urlPatterns = {"/get-homestay-booking-details"})
public class GetHomestayBookingDetailsController extends HttpServlet {

    private BookingDAO bookingDAO;
    private BusinessDAO businessDAO;
    private Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        businessDAO = new BusinessDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        // 1. Kiểm tra đăng nhập
        if (currentUser == null || currentUser.getRole().getRoleId() != 2) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            out.print("{\"error\":\"Bạn cần đăng nhập.\"}");
            out.flush();
            return;
        }

        // 2. Lấy business của owner
        Businesses biz = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        if (biz == null) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            out.print("{\"error\":\"Không tìm thấy cơ sở kinh doanh.\"}");
            out.flush();
            return;
        }

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            
            // 3. Xác thực chủ sở hữu: Đơn hàng này có thuộc business này không?
            // === BẮT ĐẦU SỬA LỖI ===
            Bookings booking = bookingDAO.getBookingById(bookingId); 
            
            // Lỗi ở dòng 'if' cũ. Sửa thành booking.getBusiness().getBusinessId()
            if (booking == null || booking.getBusiness() == null || booking.getBusiness().getBusinessId() != biz.getBusinessId()) {
            // === KẾT THÚC SỬA LỖI ===
                response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
                out.print("{\"error\":\"Bạn không có quyền xem chi tiết đơn này.\"}");
                out.flush();
                return;
            }

            // 4. Lấy dữ liệu và trả về JSON
            List<BookedRoomDTO> bookedRooms = bookingDAO.getBookedRoomsByBookingId(bookingId);
            String jsonResult = this.gson.toJson(bookedRooms);
            out.print(jsonResult);
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
            out.print("{\"error\":\"bookingId không hợp lệ.\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
            out.print("{\"error\":\"Lỗi máy chủ: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }
}