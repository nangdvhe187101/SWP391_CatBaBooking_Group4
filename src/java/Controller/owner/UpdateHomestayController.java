package Controller.owner;

import dao.AreaDAO;
import dao.BusinessDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Areas;
import model.Businesses;
import model.Users;

public class UpdateHomestayController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy "flash message" (thông báo) từ Session (nếu có)
        HttpSession session = request.getSession();
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");

        // 2. Xóa message khỏi session để nó không hiện lại
        session.removeAttribute("successMessage");
        session.removeAttribute("errorMessage");

        // 3. Đặt message vào request để JSP có thể đọc
        request.setAttribute("success", successMessage);
        request.setAttribute("error", errorMessage);

        // 4. Lấy dữ liệu Homestay để hiển thị (giữ nguyên code cũ của bạn)
        String id = request.getParameter("id");
        BusinessDAO businessDAO = new BusinessDAO();
        AreaDAO areaDAO = new AreaDAO();

        try {
            int businessId = Integer.parseInt(id);
            Businesses b = businessDAO.getBusinessById(businessId); // Dùng getBusinessById(int)
            List<Areas> listA = areaDAO.getAllAreas();

            request.setAttribute("b", b); // Gửi ra JSP với tên là "b"
            request.setAttribute("listA", listA);
            request.getRequestDispatcher("OwnerPage/UpdateHomestay.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("manage-homestay");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Luôn cần session để gửi message
        HttpSession session = request.getSession();
        
        try {
            // 1. Lấy dữ liệu từ form
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String description = request.getParameter("description");
            BigDecimal pricePerNight = new BigDecimal(request.getParameter("pricePerNight"));
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            int numBedrooms = Integer.parseInt(request.getParameter("numBedrooms"));
            int areaId = Integer.parseInt(request.getParameter("area_id"));
            
            // Lấy ownerId từ session để bảo mật
            Users owner = (Users) session.getAttribute("user");
            int ownerId = owner.getUserId();

            // 2. Gọi DAO để update
            BusinessDAO businessDAO = new BusinessDAO();
            boolean check = businessDAO.updateHomestay(id, name, address, description, pricePerNight, capacity, numBedrooms, areaId, ownerId);

            if (check) {
                // 3. Gửi message thành công qua SESSION
                session.setAttribute("successMessage", "Cập nhật homestay thành công!");
            } else {
                // 4. Gửi message thất bại qua SESSION
                session.setAttribute("errorMessage", "Cập nhật thất bại. Vui lòng thử lại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        
        // 5. Redirect về trang "manage-homestay"
        response.sendRedirect("manage-homestay");
    }
}