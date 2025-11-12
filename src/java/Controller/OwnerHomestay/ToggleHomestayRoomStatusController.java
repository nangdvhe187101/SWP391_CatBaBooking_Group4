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
import model.Businesses;
import model.Rooms;
import model.Users;

@WebServlet(name = "ToggleHomestayRoomStatusController", urlPatterns = {"/toggle-homestay-room-status"})
public class ToggleHomestayRoomStatusController extends HttpServlet {

    private BusinessDAO businessDAO;
    private HomestayDAO homestayDAO;

    @Override
    public void init() throws ServletException {
        businessDAO = new BusinessDAO();
        homestayDAO = new HomestayDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        String redirectURL = request.getContextPath() + "/manage-homestay-rooms";

        if (currentUser == null || currentUser.getRole().getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Businesses biz = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        if (biz == null || !"homestay".equals(biz.getType())) {
            session.setAttribute("error", "Không tìm thấy homestay.");
            response.sendRedirect(redirectURL);
            return;
        }

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            
            // Lấy trạng thái hiện tại
            Rooms room = homestayDAO.getRoomById(roomId, biz.getBusinessId());
            if (room == null) {
                session.setAttribute("error", "Không tìm thấy phòng hoặc bạn không có quyền thay đổi phòng này.");
                response.sendRedirect(redirectURL);
                return;
            }

            // Đảo ngược trạng thái
            boolean newStatus = !room.isIsActive();
            if (homestayDAO.updateRoomStatus(roomId, newStatus, biz.getBusinessId())) {
                session.setAttribute("message", "Đã cập nhật trạng thái phòng.");
            } else {
                session.setAttribute("error", "Cập nhật trạng thái thất bại.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID phòng không hợp lệ.");
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
        }

        response.sendRedirect(redirectURL);
    }
}