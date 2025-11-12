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
import java.math.BigDecimal;
import model.Businesses;
import model.Rooms;
import model.Users;

@WebServlet(name = "UpdateHomestayRoomController", urlPatterns = {"/update-homestay-room"})
public class UpdateHomestayRoomController extends HttpServlet {

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
            String name = request.getParameter("name");
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            BigDecimal pricePerNight = new BigDecimal(request.getParameter("pricePerNight"));
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));

            // Xác thực đơn giản
            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("error", "Tên phòng không được để trống.");
                response.sendRedirect(redirectURL);
                return;
            }
            if (capacity <= 0 || pricePerNight.compareTo(BigDecimal.ZERO) <= 0) {
                session.setAttribute("error", "Sức chứa và giá phòng phải lớn hơn 0.");
                response.sendRedirect(redirectURL);
                return;
            }

            // Kiểm tra phòng có thuộc sở hữu của owner không
            Rooms existingRoom = homestayDAO.getRoomById(roomId, biz.getBusinessId());
            if (existingRoom == null) {
                session.setAttribute("error", "Không tìm thấy phòng hoặc bạn không có quyền sửa phòng này.");
                response.sendRedirect(redirectURL);
                return;
            }

            // Tạo đối tượng và cập nhật
            Rooms roomToUpdate = new Rooms();
            roomToUpdate.setRoomId(roomId);
            roomToUpdate.setName(name);
            roomToUpdate.setCapacity(capacity);
            roomToUpdate.setPricePerNight(pricePerNight);
            roomToUpdate.setIsActive(isActive);
            roomToUpdate.setBusiness(biz); // Cần set business để DAO có thể lấy businessId

            if (homestayDAO.updateRoom(roomToUpdate)) {
                session.setAttribute("message", "Cập nhật phòng thành công.");
            } else {
                session.setAttribute("error", "Cập nhật phòng thất bại.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại sức chứa và giá phòng.");
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
        }

        response.sendRedirect(redirectURL);
    }
}