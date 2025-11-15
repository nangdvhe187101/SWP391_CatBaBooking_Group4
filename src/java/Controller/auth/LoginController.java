package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Users;
import dao.UserDAO;
import dao.FeaturesDAO;
import model.RoleFeature;  

@WebServlet("/Login")
public class LoginController extends HttpServlet {

    private UserDAO userDAO;
    private FeaturesDAO featuresDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        featuresDAO = new FeaturesDAO();
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
                int roleId = user.getRole().getRoleId();
                List<RoleFeature> permittedFeatures = featuresDAO.getPermittedFeaturesForRole(roleId);
                session.setAttribute("permittedFeatures", permittedFeatures);
                switch (roleName.toLowerCase()) {
                    case "admin":
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                        break;
                        
                    case "owner homestay":
                        response.sendRedirect(request.getContextPath() + "/owner-dashboard");
                        break;
                    case "owner restaurant":
                        response.sendRedirect(request.getContextPath() + "/owner-dashboard");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/Home");
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