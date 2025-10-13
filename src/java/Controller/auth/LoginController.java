package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;
import dao.UserDAO;

@WebServlet("/Login")
public class LoginController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        // Khởi tạo UserDAO một lần khi servlet được tạo
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
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
            String userStatus = user.getStatus(); 
            if ("active".equalsIgnoreCase(userStatus)) {
                HttpSession session = request.getSession(true);
                session.setAttribute("currentUser", user);
                String roleName = (user.getRole() != null && user.getRole().getRoleName() != null)
                        ? user.getRole().getRoleName().trim() : "";
                switch (roleName.toLowerCase()) {
                    case "admin":
                        response.sendRedirect(request.getContextPath() + "/AdminPage/Dashboard.jsp");
                        break;
                    case "owner":
                        response.sendRedirect(request.getContextPath() + "/OwnerPage/Dashboard.jsp");
                        break;
                    default: 
                        response.sendRedirect(request.getContextPath() + "/HomePage/Home.jsp");
                        break;
                }
            } else {
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa hoặc đang chờ duyệt. Vui lòng liên hệ quản trị viên.");
                request.getRequestDispatcher("/Authentication/Login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("/Authentication/Login.jsp").forward(request, response);
        }
    }
}