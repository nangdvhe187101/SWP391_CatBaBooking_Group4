/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import model.Roles;
import model.Users;
import util.EmailUtil;
import util.PassWordUtil;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "RegisterCustomerController", urlPatterns = {"/register-customer"})
public class RegisterCustomerController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    // Handle GET requests to display the registration form
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward to Register-user.jsp
        request.getRequestDispatcher("/Authentication/RegisterCustomer.jsp").forward(request, response);
    }

    // Handle POST requests to process form submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String fullName = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        // Validate input
        if (fullName == null || email == null || password == null || confirmPassword == null ||
            fullName.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("/Authentication/RegisterCustomer.jsp").forward(request, response);
            return;
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/Authentication/RegisterCustomer.jsp").forward(request, response);
            return;
        }

        // Validate password strength
        if (!PassWordUtil.isValidPassword(password)) {
            request.setAttribute("error", "Mật khẩu không đủ mạnh! Yêu cầu: 8-64 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt.");
            request.getRequestDispatcher("/Authentication/RegisterCustomer.jsp").forward(request, response);
            return;
        }

        // Create user object
        Roles role = new Roles(1, "User", "Customer Role", LocalDateTime.now()); // Assuming role_id 1 is for customers
        Users user = new Users(
            role,
            fullName,
            email,
            password, 
            null, 
            null,
            null, 
            "Active"
        );
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        int userId = userDAO.registerUser(user);
        if (userId != -1) {
            EmailUtil.sendRegistrationConfirmation(email, fullName);
            request.setAttribute("success", "Đăng ký thành công! Vui lòng kiểm tra email.");
            request.getRequestDispatcher("/Authentication/RegisterCustomer.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Email có thể đã được sử dụng hoặc có lỗi hệ thống.");
            request.getRequestDispatcher("/Authentication/RegisterCustomer.jsp").forward(request, response);
        }
    }
}
