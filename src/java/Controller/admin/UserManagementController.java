/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.UserDAO;
import dao.BusinessDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import model.Users;
import model.Businesses;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "UserManagementController", urlPatterns = {"/user-management/*"})
public class UserManagementController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final BusinessDAO businessDAO = new BusinessDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String path = request.getPathInfo();
        if (path == null || "/".equals(path)) {
            String roleParam = request.getParameter("role");
            String statusParam = request.getParameter("status");
            String keyword = request.getParameter("keyword");
            String pageIndexRaw = request.getParameter("page");
            int pageSize = 2;
            int pageIndex = 1;
            if (pageIndexRaw != null && !pageIndexRaw.trim().isEmpty()) {
                try {
                    pageIndex = Integer.parseInt(pageIndexRaw);
                } catch (NumberFormatException e) {
                    pageIndex = 1;
                }
            }
            Integer roleId = null;
            if (roleParam != null && !roleParam.trim().isEmpty()) {
                try {
                    roleId = Integer.valueOf(roleParam);
                } catch (NumberFormatException e) {
                }
            }
            int totalUsers = userDAO.countAllUsers(roleId, statusParam, keyword);
            int totalPage = (totalUsers + pageSize - 1) / pageSize;
            List<Users> users = userDAO.getAllUsers(roleId, statusParam, keyword, pageIndex, pageSize);
            request.setAttribute("users", users);
            request.setAttribute("pageIndex", pageIndex);
            request.setAttribute("totalPage", totalPage);
            request.setAttribute("keywordFilter", keyword);
            request.setAttribute("roleFilter", roleParam);
            request.setAttribute("statusFilter", statusParam);
            request.getRequestDispatcher("/AdminPage/UserManagement.jsp").forward(request, response);
            return;
        }
        try {
            int userId = Integer.parseInt(path.substring(1));
            Users user = userDAO.getUserById(userId);
            if (user != null && user.getRole().getRoleId() == 2) {
                Businesses business = businessDAO.getBusinessByOwnerId(userId); 
                if (business != null) {
                    user.setBusiness(business);
                }
            }
            request.setAttribute("roleFilter", request.getParameter("role"));
            request.setAttribute("statusFilter", request.getParameter("status"));
            request.setAttribute("keywordFilter", request.getParameter("keyword"));
            request.setAttribute("pageIndex", request.getParameter("page"));
            request.setAttribute("user", user);
            request.getRequestDispatcher("/AdminPage/UserManagement.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        String action = request.getParameter("action");
        String roleParam = request.getParameter("role");
        String statusParam = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String pageParam = request.getParameter("page");  // Thêm để giữ pageIndex
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            Users targetUser = userDAO.getUserById(userId);
            boolean success = false;
            if ("toggleStatus".equals(action)) {
                success = userDAO.toggleUserStatus(userId, "toggle");
                if (success && targetUser != null && targetUser.getRole().getRoleId() == 2) {
                }
            } else if ("updateStatus".equals(action)) {
                String newStatus = request.getParameter("newStatus");
                success = userDAO.toggleUserStatus(userId, newStatus);
            }

            if (success) {
                statusParam = null;
            }

            String successParam = success ? "toggled" : "error";
            StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/user-management?success=" + successParam);
            if (roleParam != null && !roleParam.isEmpty()) {
                redirectUrl.append("&role=").append(roleParam);
            }
            if (statusParam != null && !statusParam.isEmpty()) {
                redirectUrl.append("&status=").append(statusParam);
            }
            if (keyword != null && !keyword.isEmpty()) {
                try {
                    redirectUrl.append("&keyword=").append(URLEncoder.encode(keyword, "UTF-8"));
                } catch (Exception e) {
                    redirectUrl.append("&keyword=").append(keyword);
                }
            }
            if (pageParam != null && !pageParam.isEmpty()) {
                redirectUrl.append("&page=").append(pageParam);
            }
            response.sendRedirect(redirectUrl.toString());
        } catch (NumberFormatException e) {
            StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/user-management?success=error");
            if (roleParam != null && !roleParam.isEmpty()) {
                redirectUrl.append("&role=").append(roleParam);
            }
            if (statusParam != null && !statusParam.isEmpty()) {
                redirectUrl.append("&status=").append(statusParam);
            }
            if (keyword != null && !keyword.isEmpty()) {
                try {
                    redirectUrl.append("&keyword=").append(URLEncoder.encode(keyword, "UTF-8"));
                } catch (Exception ex) {
                    redirectUrl.append("&keyword=").append(keyword);
                }
            }
            if (pageParam != null && !pageParam.isEmpty()) {
                redirectUrl.append("&page=").append(pageParam);
            }
            response.sendRedirect(redirectUrl.toString());
        } catch (Exception e) {
            e.printStackTrace();
            StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/user-management?success=error");
            if (roleParam != null && !roleParam.isEmpty()) {
                redirectUrl.append("&role=").append(roleParam);
            }
            if (statusParam != null && !statusParam.isEmpty()) {
                redirectUrl.append("&status=").append(statusParam);
            }
            if (keyword != null && !keyword.isEmpty()) {
                try {
                    redirectUrl.append("&keyword=").append(URLEncoder.encode(keyword, "UTF-8"));
                } catch (Exception ex) {
                    redirectUrl.append("&keyword=").append(keyword);
                }
            }
            if (pageParam != null && !pageParam.isEmpty()) {
                redirectUrl.append("&page=").append(pageParam);
            }
            response.sendRedirect(redirectUrl.toString());
        }
    }
}