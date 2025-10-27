package controller.owner;

import dao.BusinessDAO;
import dao.RoomDAO; // Import RoomDAO mới
import java.io.IOException;
import java.util.List; // Import List
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Businesses;
import model.Rooms; // Import model Rooms
import model.Users;

@WebServlet(name = "ManageHomestayController", urlPatterns = {"/manage-homestay"})
public class ManageHomestayController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("[ManageHomestayController] Đã vào doGet().");
        HttpSession session = request.getSession();

        // 1. Kiểm tra đăng nhập
        Users owner = (Users) session.getAttribute("currentUser"); // Dùng key "currentUser" như code của bạn
        if (owner == null || owner.getRole().getRoleId() != 2) { // Kiểm tra Role ID = 2 (Owner)
            System.out.println("[ManageHomestayController] Chưa đăng nhập hoặc không phải Owner.");
            response.sendRedirect(request.getContextPath() + "/Login"); // Chuyển về trang Login của bạn
            return;
        }
        int ownerId = owner.getUserId();
        System.out.println("[ManageHomestayController] Owner ID = " + ownerId);

        // 2. Lấy Flash Messages (Giữ nguyên)
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (successMessage != null) {
            request.setAttribute("success", successMessage);
            session.removeAttribute("successMessage");
        }
        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            session.removeAttribute("errorMessage");
        }

        try {
            // 3. Gọi DAO để lấy thông tin Homestay duy nhất
            BusinessDAO businessDAO = new BusinessDAO();
            // Gọi phương thức DAO mới để lấy 1 business
            Businesses homestayDetail = businessDAO.getBusinessByOwnerIdAndType(ownerId, "HOMESTAY");

            List<Rooms> roomList = null; // Khởi tạo danh sách phòng là null

            // 4. Nếu tìm thấy homestay -> lấy danh sách phòng
            if (homestayDetail != null) {
                System.out.println("[ManageHomestayController] Tìm thấy homestay: " + homestayDetail.getName());
                RoomDAO roomDAO = new RoomDAO(); // Tạo instance RoomDAO
                int businessId = homestayDetail.getBusinessId();
                roomList = roomDAO.getRoomsByBusinessId(businessId); // Lấy danh sách phòng
            } else {
                 System.out.println("[ManageHomestayController] Không tìm thấy homestay nào cho owner này.");
                 // Có thể đặt thông báo nếu owner chưa có homestay
                 request.setAttribute("error", "Bạn chưa đăng ký homestay nào.");
            }

            // 5. Đặt dữ liệu vào Request
            request.setAttribute("homestayDetail", homestayDetail); // Gửi chi tiết homestay
            request.setAttribute("roomList", roomList); // Gửi danh sách phòng (có thể null hoặc rỗng)
            
            // 6. Forward đến JSP
            System.out.println("[ManageHomestayController] Forwarding đến ManageHomestay.jsp...");
            request.getRequestDispatcher("OwnerPage/ManageHomestay.jsp").forward(request, response);
            
        } catch (Exception e) {
             System.out.println("[ManageHomestayController] Lỗi nghiêm trọng: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống khi tải dữ liệu homestay.");
            request.getRequestDispatcher("OwnerPage/ManageHomestay.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiện tại trang này không xử lý POST, nhưng để đó phòng khi cần (ví dụ: tìm kiếm phòng)
        doGet(request, response);
    }
}