package controller.owner;

import dao.BusinessDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;
import util.PassWordUtil;

@WebServlet(name = "ChangePasswordOwnerController", urlPatterns = {"/owner/change-password"})
public class ChangePasswordOwnerController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null || currentUser.getRole() == null
                || (currentUser.getRole().getRoleId() != 2 && currentUser.getRole().getRoleId() != 4)) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String passwordError = validateInputs(currentPassword, newPassword, confirmPassword, currentUser);

        if (passwordError != null) {
            request.setAttribute("passwordError", passwordError);
        } else {
            boolean updated = userDAO.updatePasswordByEmail(currentUser.getEmail(), newPassword);
            if (updated) {
                request.setAttribute("passwordSuccess", "Đổi mật khẩu thành công.");
            } else {
                request.setAttribute("passwordError", "Không thể đổi mật khẩu. Vui lòng thử lại sau.");
            }
        }

        Users refreshedUser = userDAO.getUserById(currentUser.getUserId());
        if (refreshedUser != null) {
            session.setAttribute("currentUser", refreshedUser);
            request.setAttribute("user", refreshedUser);
        } else {
            request.setAttribute("user", currentUser);
        }

        request.setAttribute("activeTab", "security");
        BusinessDAO businessDAO = new BusinessDAO();
        request.setAttribute("business", businessDAO.getBusinessByOwnerId(currentUser.getUserId()));
        request.getRequestDispatcher("/OwnerPage/EditProfileOwner.jsp").forward(request, response);
    }

    private String validateInputs(String currentPassword, String newPassword, String confirmPassword, Users currentUser) {
        if (currentPassword == null || currentPassword.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            return "Vui lòng điền đầy đủ thông tin.";
        }

        if (newPassword.length() < 8) {
            return "Mật khẩu mới phải có ít nhất 8 ký tự.";
        }

        if (!newPassword.equals(confirmPassword)) {
            return "Xác nhận mật khẩu không khớp.";
        }

        if (!PassWordUtil.isValidPassword(newPassword)) {
            return "Mật khẩu mới cần chứa chữ hoa, chữ thường, số và ký tự đặc biệt.";
        }

        Users authenticated = userDAO.authenticateUser(currentUser.getEmail(), currentPassword);
        if (authenticated == null) {
            return "Mật khẩu hiện tại không chính xác.";
        }

        if (PassWordUtil.verifyPassword(authenticated.getPasswordHash(), newPassword)) {
            return "Mật khẩu mới không được trùng với mật khẩu hiện tại.";
        }

        return null;
    }
}

