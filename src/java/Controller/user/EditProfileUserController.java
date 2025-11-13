package controller.user;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

@WebServlet(name = "EditProfileUserController", urlPatterns = {"/user/profile"})
public class EditProfileUserController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Users refreshedUser = userDAO.getUserById(currentUser.getUserId());
        request.setAttribute("user", refreshedUser != null ? refreshedUser : currentUser);

        String tab = request.getParameter("tab");
        if (tab == null || tab.isBlank()) {
            tab = "account";
        }
        request.setAttribute("activeTab", tab);

        request.getRequestDispatcher("/HomePage/EditProfileUser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String personalAddress = request.getParameter("personalAddress");
        String city = request.getParameter("city");
        String gender = request.getParameter("gender");
        Integer birthDay = parseInteger(request.getParameter("birthDay"));
        Integer birthMonth = parseInteger(request.getParameter("birthMonth"));
        Integer birthYear = parseInteger(request.getParameter("birthYear"));

        String validationResult = userDAO.processUserProfileUpdate(
                currentUser.getUserId(),
                fullName,
                email,
                phone,
                null, // citizenId is null for regular users, only owners need it
                gender,
                birthDay,
                birthMonth,
                birthYear,
                city,
                personalAddress,
                currentUser.getEmail()
        );

        if (validationResult != null) {
            request.setAttribute("profileError", validationResult);
        } else {
            Users updatedUser = userDAO.getUserById(currentUser.getUserId());
            if (updatedUser != null) {
                session.setAttribute("currentUser", updatedUser);
                request.setAttribute("user", updatedUser);
            } else {
                request.setAttribute("user", currentUser);
            }
            request.setAttribute("profileSuccess", "Cập nhật thông tin thành công.");
        }

        if (request.getAttribute("user") == null) {
            request.setAttribute("user", currentUser);
        }

        request.setAttribute("activeTab", "account");
        request.getRequestDispatcher("/HomePage/EditProfileUser.jsp").forward(request, response);
    }

    private Integer parseInteger(String input) {
        try {
            return (input != null && !input.trim().isEmpty()) ? Integer.parseInt(input.trim()) : null;
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}

