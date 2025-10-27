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

        Users owner = (Users) session.getAttribute("currentUser");
        if (owner == null || owner.getRole().getRoleId() != 2) {
            System.out.println("[ManageHomestayController] Chưa đăng nhập hoặc không phải Owner.");
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        int ownerId = owner.getUserId();
        System.out.println("[ManageHomestayController] Owner ID = " + ownerId);

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
            BusinessDAO businessDAO = new BusinessDAO();
            Businesses homestayDetail = businessDAO.getBusinessByOwnerIdAndType(ownerId, "HOMESTAY");
            List<Rooms> roomList = null;

            if (homestayDetail != null) {
                RoomDAO roomDAO = new RoomDAO();
                int businessId = homestayDetail.getBusinessId();
                roomList = roomDAO.getRoomsByBusinessId(businessId);
            } else {
                request.setAttribute("error", "Bạn chưa đăng ký homestay nào.");
            }

            request.setAttribute("homestayDetail", homestayDetail);
            request.setAttribute("roomList", roomList);

            request.getRequestDispatcher("OwnerPage/ManageHomestay.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống khi tải dữ liệu homestay.");
            request.getRequestDispatcher("OwnerPage/ManageHomestay.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}