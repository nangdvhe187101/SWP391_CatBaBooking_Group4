/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import model.Users;

/**
 *
 * @author ADMIN
 */
public class EditProfileController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        
        // Lấy thông tin user đầy đủ từ database
        Users userProfile = userDAO.getUserProfileById(currentUser.getUserId());
        if (userProfile != null) {
            request.setAttribute("user", userProfile);
        } else {
            request.setAttribute("user", currentUser);
        }
        
        request.getRequestDispatcher("/EditProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        
        try {
            // Lấy dữ liệu từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String city = request.getParameter("city");
            
            // Xử lý ngày sinh
            Integer birthDay = null;
            Integer birthMonth = null;
            Integer birthYear = null;
            
            String birthDayStr = request.getParameter("birthDay");
            String birthMonthStr = request.getParameter("birthMonth");
            String birthYearStr = request.getParameter("birthYear");
            
            if (birthDayStr != null && !birthDayStr.isEmpty()) {
                birthDay = Integer.parseInt(birthDayStr);
            }
            if (birthMonthStr != null && !birthMonthStr.isEmpty()) {
                birthMonth = Integer.parseInt(birthMonthStr);
            }
            if (birthYearStr != null && !birthYearStr.isEmpty()) {
                birthYear = Integer.parseInt(birthYearStr);
            }
            
            // Validation
            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Tên đầy đủ không được để trống");
                request.getRequestDispatcher("/EditProfile.jsp").forward(request, response);
                return;
            }
            
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email không được để trống");
                request.getRequestDispatcher("/EditProfile.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra email có thay đổi không và có bị trùng không
            if (!email.equals(currentUser.getEmail())) {
                if (userDAO.checkEmailExists(email)) {
                    request.setAttribute("error", "Email này đã được sử dụng bởi tài khoản khác");
                    request.getRequestDispatcher("/EditProfile.jsp").forward(request, response);
                    return;
                }
            }
            
            // Cập nhật thông tin profile
            boolean success = userDAO.updateUserProfile(
                currentUser.getUserId(),
                fullName.trim(),
                email.trim(),
                phone != null ? phone.trim() : null,
                gender,
                birthDay,
                birthMonth,
                birthYear,
                city != null ? city.trim() : null
            );
            
            if (success) {
                // Cập nhật session với thông tin mới
                Users updatedUser = userDAO.getUserProfileById(currentUser.getUserId());
                if (updatedUser != null) {
                    session.setAttribute("currentUser", updatedUser);
                }
                
                request.setAttribute("success", "Cập nhật thông tin thành công!");
                request.setAttribute("user", updatedUser);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật thông tin. Vui lòng thử lại.");
                request.setAttribute("user", currentUser);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu ngày sinh không hợp lệ");
            request.setAttribute("user", currentUser);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu. Vui lòng thử lại.");
            request.setAttribute("user", currentUser);
        }
        
        request.getRequestDispatcher("/EditProfile.jsp").forward(request, response);
    }
}