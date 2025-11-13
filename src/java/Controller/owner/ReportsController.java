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
import model.Businesses;
import model.Users;

@WebServlet(name = "ReportsController", urlPatterns = {"/owner/reports"})
public class ReportsController extends HttpServlet {

    private UserDAO userDAO;
    private BusinessDAO businessDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        businessDAO = new BusinessDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (!isOwner(currentUser)) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        // Load user and business data
        Users refreshedUser = userDAO.getUserById(currentUser.getUserId());
        Businesses business = businessDAO.getBusinessByOwnerId(currentUser.getUserId());

        request.setAttribute("user", refreshedUser);
        request.setAttribute("business", business);

        request.getRequestDispatcher("/OwnerPage/Reports.jsp").forward(request, response);
    }

    private boolean isOwner(Users user) {
        if (user == null || user.getRole() == null) {
            return false;
        }
        int roleId = user.getRole().getRoleId();
        return roleId == 2 || roleId == 4;
    }
}

