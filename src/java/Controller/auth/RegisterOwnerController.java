/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.BusinessDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import model.Businesses;
import model.Roles;
import model.Users;
import util.EmailUtil;
import util.PassWordUtil;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "RegisterOwnerController", urlPatterns = {"/register-owner"})
public class RegisterOwnerController extends HttpServlet {

    private UserDAO userDAO;
    private BusinessDAO businessDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        businessDAO = new BusinessDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/Authentication/RegisterOwner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String fullName = request.getParameter("full-name");
        String citizenId = request.getParameter("citizen-id");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");
        String personalAddress = request.getParameter("personal-address");  // Thêm nếu form có
        String businessName = request.getParameter("business-name");
        String businessType = request.getParameter("business-type");
        String businessAddress = request.getParameter("business-address");
        String description = request.getParameter("description");

        // Kiểm tra null hoặc rỗng
        if (fullName == null || citizenId == null || email == null || phone == null || password == null || confirmPassword == null
                || personalAddress == null || businessName == null || businessType == null || businessAddress == null || description == null
                || fullName.trim().isEmpty() || citizenId.trim().isEmpty() || email.trim().isEmpty() || phone.trim().isEmpty()
                || password.trim().isEmpty() || confirmPassword.trim().isEmpty() || personalAddress.trim().isEmpty()
                || businessName.trim().isEmpty() || businessType.trim().isEmpty() || businessAddress.trim().isEmpty() || description.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("/Authentication/RegisterOwner.jsp").forward(request, response);
            return;
        }

        // Check passwords match 
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/Authentication/RegisterOwner.jsp").forward(request, response);
            return;
        }

        // Validate password strength
        if (!PassWordUtil.isValidPassword(password)) {
            request.setAttribute("error", "Mật khẩu không đủ mạnh! Yêu cầu: 8-64 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt.");
            request.getRequestDispatcher("/Authentication/RegisterOwner.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng Roles với role_id = 2 (Owner)
        Roles role = new Roles(2, "Owner", "Business Owner Role", LocalDateTime.now());
        Users user = new Users(
                role,
                fullName,
                email,
                password, 
                phone,
                citizenId,
                personalAddress,
                null 
        );
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        // Đăng ký user và lấy userId
        int userId = userDAO.registerUser(user);
        if (userId == -1) {
            request.setAttribute("error", "Đăng ký thất bại. Email có thể đã được sử dụng hoặc có lỗi hệ thống.");
            request.getRequestDispatcher("/Authentication/RegisterOwner.jsp").forward(request, response);
            return;
        }

        // Cập nhật userId trong đối tượng user
        user.setUserId(userId);

        // Tạo đối tượng Businesses
        Businesses biz = new Businesses();
        biz.setOwner(user);
        biz.setName(businessName);
        biz.setType(businessType);
        biz.setAddress(businessAddress);
        biz.setDescription(description);
        biz.setCreatedAt(LocalDateTime.now());
        biz.setUpdatedAt(LocalDateTime.now());

        // Đăng ký business
        boolean businessSuccess = businessDAO.registerBusiness(biz);
        if (!businessSuccess) {
            request.setAttribute("error", "Đăng ký cơ sở thất bại");
            request.getRequestDispatcher("/Authentication/RegisterOwner.jsp").forward(request, response);
            return;
        }

        // Gửi email xác nhận cho user
        EmailUtil.sendPendingConfirmation(email, fullName);
        // Gửi thông báo cho admin
        EmailUtil.sendAdminNotification("catbabooking.fms@gmail.com", fullName, email, businessName, businessType);
        request.setAttribute("success", "Đăng ký thành công! Đơn của bạn đã được gửi đến admin và đang chờ duyệt. Vui lòng kiểm tra email.");
        request.getRequestDispatcher("/Authentication/RegisterOwner.jsp").forward(request, response);
    }
}
