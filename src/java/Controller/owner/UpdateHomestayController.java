package controller.owner;

import dao.BusinessDAO; 
import dao.RoomDAO;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Businesses;
import model.Rooms;
import model.Users;

@WebServlet(name = "UpdateHomestayController", urlPatterns = {"/update-homestay"})
public class UpdateHomestayController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("manage-homestay");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[UpdateHomestayController] Đã vào doPost() để cập nhật PHÒNG.");
        HttpSession session = request.getSession();
        request.setCharacterEncoding("UTF-8");

        Users owner = (Users) session.getAttribute("currentUser");
        if (owner == null || owner.getRole().getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String roomIdParam = request.getParameter("roomId_modal");

        try {
            int roomId = Integer.parseInt(roomIdParam);
            String name = request.getParameter("roomName_modal");
            int capacity = Integer.parseInt(request.getParameter("roomCapacity_modal"));
            BigDecimal pricePerNight = new BigDecimal(request.getParameter("roomPrice_modal"));
            boolean isActive = request.getParameter("roomIsActive_modal") != null;
            int businessId = Integer.parseInt(request.getParameter("businessId_modal"));

            StringBuilder errorMsg = new StringBuilder();
            if (name == null || name.trim().isEmpty()) errorMsg.append("Tên phòng không được để trống. ");
            if (capacity <= 0) errorMsg.append("Sức chứa phải lớn hơn 0. ");
            if (pricePerNight == null || pricePerNight.compareTo(BigDecimal.ZERO) < 0) errorMsg.append("Giá phòng phải là số không âm. ");

            if (errorMsg.length() > 0) {
                session.setAttribute("errorMessage", "Validation failed: " + errorMsg.toString());
                response.sendRedirect("manage-homestay"); // Redirect về trang quản lý với thông báo lỗi
                return;
            }

            BusinessDAO businessDAO = new BusinessDAO();
            Businesses parentBusiness = businessDAO.getBusinessById(businessId);
            if (parentBusiness == null || parentBusiness.getOwner().getUserId() != owner.getUserId()) {
                session.setAttribute("errorMessage", "Bạn không có quyền sửa phòng này.");
                response.sendRedirect("manage-homestay");
                return;
            }

            RoomDAO roomDAO = new RoomDAO();
            Rooms updatedRoom = new Rooms();
            updatedRoom.setRoomId(roomId);
            updatedRoom.setName(name);
            updatedRoom.setCapacity(capacity);
            updatedRoom.setPricePerNight(pricePerNight);
            updatedRoom.setIsActive(isActive);
            Businesses businessRef = new Businesses();
            businessRef.setBusinessId(businessId);
            updatedRoom.setBusiness(businessRef);
            boolean check = roomDAO.updateRoom(updatedRoom);
            
            if (check) {
                session.setAttribute("successMessage", "Cập nhật phòng '" + name + "' thành công!");
            } else {
                session.setAttribute("errorMessage", "Cập nhật phòng thất bại (có thể do lỗi DB).");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Dữ liệu nhập vào không hợp lệ (ID, Số, Giá).");
        }
        catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống khi cập nhật phòng: " + e.getMessage());
        }

        response.sendRedirect("manage-homestay");
    }
}