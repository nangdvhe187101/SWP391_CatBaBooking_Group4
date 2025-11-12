package controller.OwnerHomestay;

import dao.BusinessDAO;
import dao.HomestayDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Businesses;
import model.Rooms;
import model.Users;

@WebServlet(name = "ManageHomestayRoomsController", urlPatterns = {"/manage-homestay-rooms"})
public class ManageHomestayRoomsController extends HttpServlet {

    private BusinessDAO businessDAO;
    private HomestayDAO homestayDAO;
    private static final int PAGE_SIZE = 10; // 10 phòng mỗi trang

    @Override
    public void init() throws ServletException {
        businessDAO = new BusinessDAO();
        homestayDAO = new HomestayDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        // 1. Kiểm tra đăng nhập và vai trò
        if (currentUser == null || currentUser.getRole().getRoleId() != 2) { // 2 = owner
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        // 2. Lấy business của owner
        Businesses biz = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        if (biz == null || !"homestay".equals(biz.getType())) {
            request.setAttribute("error", "Không tìm thấy homestay hoặc cơ sở kinh doanh không phải là homestay.");
            request.getRequestDispatcher("/OwnerPage/Dashboard.jsp").forward(request, response);
            return;
        }

        // 3. Xử lý thông báo (nếu có)
        String error = (String) session.getAttribute("error");
        String message = (String) session.getAttribute("message");
        session.removeAttribute("error");
        session.removeAttribute("message");
        request.setAttribute("error", error);
        request.setAttribute("message", message);

        // 4. Xử lý phân trang
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // Bỏ qua, dùng page = 1
        }

        // 5. Lấy dữ liệu
        List<Rooms> rooms = homestayDAO.getPaginatedRoomsByBusinessId(biz.getBusinessId(), page, PAGE_SIZE);
        int totalRooms = homestayDAO.countRoomsByBusinessId(biz.getBusinessId());
        int totalPages = (int) Math.ceil((double) totalRooms / PAGE_SIZE);

        // 6. Set attributes và forward
        request.setAttribute("rooms", rooms);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("business", biz);
        request.getRequestDispatcher("/OwnerPage/ManageHomestayRooms.jsp").forward(request, response);
    }
}