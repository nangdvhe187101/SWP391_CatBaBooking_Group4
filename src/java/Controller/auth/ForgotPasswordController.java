/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;
import model.Users;
import util.EmailUtil;
import util.PassWordUtil;


/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/Authentication/ForgotPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("send-otp".equals(action)) {
            String email = request.getParameter("email");
            Users user = userDAO.getUserByEmail(email); 
            if (user == null) {
                request.setAttribute("error", "Email không tồn tại trong hệ thống.");
                request.getRequestDispatcher("/Authentication/ForgotPassword.jsp").forward(request, response);
                return;
            }
            // Tạo OTP ngẫu nhiên 6 chữ số
            String otp = generateOTP();
            session.setAttribute("otp", otp);
            session.setAttribute("otpEmail", email);
            session.setAttribute("otpTime", System.currentTimeMillis()); 

            // Gửi email OTP
            EmailUtil.sendOTP(email, otp);
            request.setAttribute("success", "Mã OTP đã gửi đến email của bạn.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/Authentication/VerifyOTP.jsp").forward(request, response);

        } else if ("verify-otp".equals(action)) {
            String inputOtp = request.getParameter("otp");
            String storedOtp = (String) session.getAttribute("otp");
            Long otpTime = (Long) session.getAttribute("otpTime");
            String email = request.getParameter("email");

            if (storedOtp == null || otpTime == null || (System.currentTimeMillis() - otpTime) > 300000) { // 5 phút
                request.setAttribute("error", "Mã OTP hết hạn hoặc không tồn tại.");
                request.getRequestDispatcher("/Authentication/ForgotPassword.jsp").forward(request, response);
                return;
            }
            if (!storedOtp.equals(inputOtp)) {
                request.setAttribute("error", "Mã OTP không đúng.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/Authentication/VerifyOTP.jsp").forward(request, response);
                return;
            }
            // OTP đúng, xóa OTP khỏi session
            session.removeAttribute("otp");
            session.removeAttribute("otpTime");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/Authentication/ResetPassword.jsp").forward(request, response);

        } else if ("reset-password".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm-password");

            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu không khớp.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/Authentication/ResetPassword.jsp").forward(request, response);
                return;
            }
            if (!PassWordUtil.isValidPassword(password)) {
                request.setAttribute("error", "Mật khẩu không đủ mạnh! Yêu cầu: 8-64 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/Authentication/ResetPassword.jsp").forward(request, response);
                return;
            }
            // Cập nhật mật khẩu
            boolean updated = userDAO.updatePasswordByEmail(email, password);
            if (updated) {
                request.setAttribute("success", "Đổi mật khẩu thành công! Vui lòng đăng nhập.");
                request.getRequestDispatcher("/Authentication/Login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Lỗi khi đổi mật khẩu.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/Authentication/ResetPassword.jsp").forward(request, response);
            }
        }
    }

    private String generateOTP() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(999999));
    }
}
