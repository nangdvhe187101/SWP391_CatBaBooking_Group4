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
import model.Users;

@WebServlet(name = "DeleteHomestayRoomController", urlPatterns = {"/delete-homestay-room"})
public class DeleteHomestayRoomController extends HttpServlet {

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

            // Xác thực phòng thuộc về chủ sở hữu trước khi xóa
            if (homestayDAO.getRoomById(roomId, biz.getBusinessId()) == null) {
                session.setAttribute("error", "Không tìm thấy phòng hoặc bạn không có quyền xóa phòng này.");
                response.sendRedirect(redirectURL);
                return;
            }

            if (homestayDAO.deleteRoom(roomId, biz.getBusinessId())) {
                session.setAttribute("message", "Đã xóa phòng vĩnh viễn.");
            } else {
                session.setAttribute("error", "Xóa phòng thất bại. Có thể phòng đang có trong đơn đặt phòng (hãy kiểm tra lại).");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID phòng không hợp lệ.");
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi khi xóa phòng: " + e.getMessage());
        }

        response.sendRedirect(redirectURL);
    }
}