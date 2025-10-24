/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.owner;

import dao.BusinessDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import model.Businesses;
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "UpdateHomestayController", urlPatterns = {"/update-homestay"})
public class UpdateHomestayController extends HttpServlet {

    private BusinessDAO businessDAO;

    @Override
    public void init() throws ServletException {
        businessDAO = new BusinessDAO();
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
        
        // Lấy thông tin homestay của owner
        Businesses homestay = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        if (homestay == null) {
            request.setAttribute("error", "Không tìm thấy thông tin homestay của bạn.");
            request.getRequestDispatcher("/OwnerPage/ManageHomestay.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("homestay", homestay);
        request.getRequestDispatcher("/OwnerPage/UpdateHomestay.jsp").forward(request, response);
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
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String description = request.getParameter("description");
            String image = request.getParameter("image");
            String pricePerNightStr = request.getParameter("pricePerNight");
            String capacityStr = request.getParameter("capacity");
            String numBedroomsStr = request.getParameter("numBedrooms");
            String isActiveStr = request.getParameter("isActive");
            
            // Validation
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Tên homestay không được để trống");
                request.getRequestDispatcher("/OwnerPage/UpdateHomestay.jsp").forward(request, response);
                return;
            }
            
            if (address == null || address.trim().isEmpty()) {
                request.setAttribute("error", "Địa chỉ không được để trống");
                request.getRequestDispatcher("/OwnerPage/UpdateHomestay.jsp").forward(request, response);
                return;
            }
            
            if (pricePerNightStr == null || pricePerNightStr.trim().isEmpty()) {
                request.setAttribute("error", "Giá mỗi đêm không được để trống");
                request.getRequestDispatcher("/OwnerPage/UpdateHomestay.jsp").forward(request, response);
                return;
            }
            
            // Parse numeric values
            BigDecimal pricePerNight;
            Integer capacity = null;
            Integer numBedrooms = null;
            
            try {
                pricePerNight = new BigDecimal(pricePerNightStr);
                if (pricePerNight.compareTo(BigDecimal.ZERO) <= 0) {
                    request.setAttribute("error", "Giá mỗi đêm phải lớn hơn 0");
                    request.getRequestDispatcher("/OwnerPage/UpdateHomestay.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Giá mỗi đêm không hợp lệ");
                request.getRequestDispatcher("/OwnerPage/UpdateHomestay.jsp").forward(request, response);
                return;
            }
            
            if (capacityStr != null && !capacityStr.trim().isEmpty()) {
                try {
                    capacity = Integer.parseInt(capacityStr);
                    if (capacity <= 0) {
                        request.setAttribute("error", "Sức chứa phải lớn hơn 0");
                        request.getRequestDispatcher("/OwnerPage/UpdateHomestay.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Sức chứa không hợp lệ");
                    request.getRequestDispatcher("/OwnerPage/UpdateHomestay.jsp").forward(request, response);
                    return;
                }
            }
            
            if (numBedroomsStr != null && !numBedroomsStr.trim().isEmpty()) {
                try {
                    numBedrooms = Integer.parseInt(numBedroomsStr);
                    if (numBedrooms < 0) {
                        request.setAttribute("error", "Số phòng ngủ không được âm");
                        request.getRequestDispatcher("/OwnerPage/UpdateHomestay.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Số phòng ngủ không hợp lệ");
                    request.getRequestDispatcher("/OwnerPage/UpdateHomestay.jsp").forward(request, response);
                    return;
                }
            }
            
            // Lấy thông tin homestay hiện tại
            Businesses currentHomestay = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
            if (currentHomestay == null) {
                request.setAttribute("error", "Không tìm thấy thông tin homestay của bạn.");
                request.getRequestDispatcher("/OwnerPage/ManageHomestay.jsp").forward(request, response);
                return;
            }
            
            // Cập nhật thông tin homestay
            boolean success = businessDAO.updateBusinessProfile(
                currentHomestay.getBusinessId(),
                name.trim(),
                address.trim(),
                description != null ? description.trim() : null,
                image != null ? image.trim() : null,
                pricePerNight,
                capacity,
                numBedrooms
            );
            
            if (success) {
                // Cập nhật session với thông tin mới
                Businesses updatedHomestay = businessDAO.getBusinessById(currentHomestay.getBusinessId());
                if (updatedHomestay != null) {
                    currentUser.setBusiness(updatedHomestay);
                    session.setAttribute("currentUser", currentUser);
                }
                
                request.setAttribute("success", "Cập nhật thông tin homestay thành công!");
                request.setAttribute("homestay", updatedHomestay);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật thông tin homestay. Vui lòng thử lại.");
                request.setAttribute("homestay", currentHomestay);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu. Vui lòng thử lại.");
            Businesses homestay = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
            request.setAttribute("homestay", homestay);
        }
        
        request.getRequestDispatcher("/OwnerPage/UpdateHomestay.jsp").forward(request, response);
    }
}
