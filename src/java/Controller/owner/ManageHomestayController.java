package Controller.owner;

import dao.BusinessDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Businesses;
import model.Users;

public class ManageHomestayController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // DÒNG DEBUG 1: Lỗi phổ biến nhất
            System.out.println("[ManageHomestayController] LỖI: Không tìm thấy 'user' trong session. Chuyển về Login.");
            response.sendRedirect(request.getContextPath() + "/Authentication/Login.jsp");
            return;
        }
        
        // 2. Lấy Owner ID từ session
        Users owner = (Users) session.getAttribute("user");
        int ownerId = owner.getUserId();
        // DÒNG DEBUG 2: Kiểm tra xem đã lấy đúng ID của owner chưa
        System.out.println("[ManageHomestayController] Đã đăng nhập với owner_id = " + ownerId);
        
        try {
            // 3. Gọi DAO (phương thức đã tinh chỉnh ở Bước 1)
            BusinessDAO businessDAO = new BusinessDAO();
            List<Businesses> listHomestays = businessDAO.getBusinessesByOwnerIdAndType(ownerId, "HOMESTAY");
            
            // DÒNG DEBUG 3: Kiểm tra xem Controller nhận được bao nhiêu homestay
            System.out.println("[ManageHomestayController] Đã nhận được " + listHomestays.size() + " homestay từ DAO.");
            // 4. Gửi danh sách 'listHomestays' ra View với tên là "listH"
            request.setAttribute("listH", listHomestays);
            
            // 5. Forward đến trang JSP
            request.getRequestDispatcher("OwnerPage/ManageHomestay.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("[ManageHomestayController] LỖI: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}