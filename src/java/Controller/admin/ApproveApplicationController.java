/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.BusinessDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Businesses;
import model.Users;
import util.EmailUtil;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ApproveApplicationController", urlPatterns = {"/approve-application"})
public class ApproveApplicationController extends HttpServlet {

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
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            List<Users> pendingOwners = userDAO.getPendingOwners();  
            request.setAttribute("pendingOwners", pendingOwners);
            request.getRequestDispatcher("/AdminPage/ApproveApplication.jsp").forward(request, response);
        } else if (action.equals("detail")) {
            int userId;
            try {
                userId = Integer.parseInt(request.getParameter("userId"));
            } catch (NumberFormatException e) {
                return;
            }
            Users user = userDAO.getUserById(userId);
            Businesses biz = businessDAO.getBusinessByOwnerId(userId);
            request.setAttribute("user", user);
            request.setAttribute("business", biz);
            request.getRequestDispatcher("/AdminPage/ApproveApplication.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        String action = request.getParameter("action");
        int userId = Integer.parseInt(request.getParameter("userId"));
        Users user = userDAO.getUserById(userId);
        Businesses biz = businessDAO.getBusinessByOwnerId(userId);

        if (action.equals("approve")) {
            boolean userUpdated = userDAO.updateUserStatus(userId, "active");
            boolean bizUpdated = businessDAO.updateBusinessStatus(userId, "active");
            if (userUpdated && bizUpdated) {
                EmailUtil.sendApprovalConfirmation(user.getEmail(), user.getFullName(), biz.getName());
                request.setAttribute("success", "Đã duyệt đơn thành công!");
            } else {
                request.setAttribute("error", "Lỗi khi duyệt đơn.");
            }
        } else if (action.equals("reject")) {
            String reason = request.getParameter("reason");
            if (reason == null || reason.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng cung cấp lý do từ chối.");
                // Forward lại detail view
                request.setAttribute("user", user);
                request.setAttribute("business", biz);
                request.getRequestDispatcher("/AdminPage/ApproveApplication.jsp").forward(request, response);
                return;
            }
            boolean userUpdated = userDAO.updateUserStatus(userId, "rejected");
            boolean bizUpdated = businessDAO.updateBusinessStatus(userId, "rejected");
            if (userUpdated && bizUpdated) {
                EmailUtil.sendRejectionNotification(user.getEmail(), user.getFullName(), biz.getName(), reason);
                request.setAttribute("success", "Đã từ chối đơn thành công!");
            } else {
                request.setAttribute("error", "Lỗi khi từ chối đơn.");
            }
        }

        // Redirect to list after action
        response.sendRedirect(request.getContextPath() + "/approve-application");
    }

    @Override
    public String getServletInfo() {
        return "Admin Controller for managing owner registrations";
    }
}