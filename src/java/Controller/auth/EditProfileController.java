package controller.auth;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

public class EditProfileController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Users refreshedUser = userDAO.getUserById(currentUser.getUserId());
        request.setAttribute("user", refreshedUser);
        request.getRequestDispatcher("/ProfilePage/EditProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String city = request.getParameter("city");
        String personalAddress = request.getParameter("personalAddress");

        Integer birthDay = parseIntOrNull(request.getParameter("birthDay"));
        Integer birthMonth = parseIntOrNull(request.getParameter("birthMonth"));
        Integer birthYear = parseIntOrNull(request.getParameter("birthYear"));

        try {
            // Gọi xử lý trong DAO (bao gồm cả validate và update)
            String result = userDAO.processUserProfileUpdate(
                    currentUser.getUserId(),
                    fullName,
                    email,
                    phone,
                    gender,
                    birthDay,
                    birthMonth,
                    birthYear,
                    city,
                    currentUser.getEmail()
            );

            if (result == null) {
                // Cập nhật thành công
                Users updated = userDAO.getUserById(currentUser.getUserId());
                session.setAttribute("currentUser", updated);
                request.setAttribute("user", updated);
                request.setAttribute("success", "Cập nhật thông tin thành công!");
            } else {
                // Có lỗi validate
                request.setAttribute("error", result);
                request.setAttribute("user", currentUser);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật thông tin!");
            request.setAttribute("user", currentUser);
        }

        request.getRequestDispatcher("/ProfilePage/EditProfile.jsp").forward(request, response);
    }

    private Integer parseIntOrNull(String value) {
        try {
            return (value != null && !value.isEmpty()) ? Integer.parseInt(value) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
