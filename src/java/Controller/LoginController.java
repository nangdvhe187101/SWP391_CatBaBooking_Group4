package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;
import dao.UserDAO;
import model.Users;

@WebServlet("/Login")
public class LoginController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/Authentication/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ email và mật khẩu.");
            request.getRequestDispatcher("/Authentication/Login.jsp").forward(request, response);
            return;
        }
        Users user = userDAO.authenticateUser(email, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);
            String roleName = (user.getRole() != null && user.getRole().getRoleName() != null)
                    ? user.getRole().getRoleName().trim() : null;
            System.out.println("Login successful for: " + user.getEmail() + ", Role: " + roleName);
            if (roleName != null && roleName.equalsIgnoreCase("admin")) {
                response.sendRedirect(request.getContextPath() + "/AdminPage/Dashboard.jsp");
            } else if (roleName != null && roleName.equalsIgnoreCase("owner")) {
                response.sendRedirect(request.getContextPath() + "/OwnerPage/Dashboard.jsp");
            } else if (roleName != null && roleName.equalsIgnoreCase("customer")) {
                response.sendRedirect(request.getContextPath() + "/HomePage/Home.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/HomePage/Home.jsp");
            }
        } else {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("/Authentication/Login.jsp").forward(request, response);
        }
    }
}
