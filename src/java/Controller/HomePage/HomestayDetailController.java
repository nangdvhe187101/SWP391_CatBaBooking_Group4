/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.HomePage;

import dao.HomestayDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import model.Businesses;
import model.dto.ReviewsDTO;
import model.dto.RoomsDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name="HomestayDetailController", urlPatterns={"/homestay-detail"})
public class HomestayDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HomestayDAO homestayDAO = new HomestayDAO();
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect("homestays-list");
                return;
            }

            int businessId = Integer.parseInt(idParam);

            Businesses homestay = homestayDAO.getHomestayById(businessId);
            if (homestay == null) {
                request.setAttribute("error", "Không tìm thấy homestay này.");
                request.getRequestDispatcher("/HomePage/NotFound.jsp").forward(request, response);
                return;
            }

            List<ReviewsDTO> reviews = homestayDAO.getReviewsByBusinessId(businessId);
            List<String> images = homestayDAO.getImagesByBusinessId(businessId);

            String checkInStr = request.getParameter("checkIn");
            String checkOutStr = request.getParameter("checkOut");
            String guestsStr = request.getParameter("guests");
            String numRoomsStr = request.getParameter("numRooms");

            // Xử lý date với try-catch để tránh lỗi parse
            LocalDate checkIn = null;
            LocalDate checkOut = null;
            
            try {
                if (checkInStr != null && !checkInStr.isEmpty()) {
                    checkIn = LocalDate.parse(checkInStr);
                } else {
                    checkIn = LocalDate.now();
                }
                
                if (checkOutStr != null && !checkOutStr.isEmpty()) {
                    checkOut = LocalDate.parse(checkOutStr);
                } else {
                    checkOut = checkIn.plusDays(1);
                }
            } catch (Exception e) {
                checkIn = LocalDate.now();
                checkOut = checkIn.plusDays(1);
            }

            int guests = 2;
            int numRooms = 1;
            
            try {
                guests = (guestsStr != null && !guestsStr.isEmpty()) ? Integer.parseInt(guestsStr) : 2;
                numRooms = (numRoomsStr != null && !numRoomsStr.isEmpty()) ? Integer.parseInt(numRoomsStr) : 1;
            } catch (NumberFormatException e) {
                // Giữ giá trị mặc định
            }

            // Gọi phương thức với cả guests và numRooms
            List<RoomsDTO> availableRooms = homestayDAO.getAvailableRooms(businessId, checkIn, checkOut, guests, numRooms);

            // Kiểm tra và tính toán thông báo
            String roomMessage = null;
            if (availableRooms.isEmpty() && numRooms > 0 && guests > 0) {
                roomMessage = "Không đủ phòng trống để phục vụ " + guests + " người trong " + numRooms + " phòng. Vui lòng thử giảm số phòng hoặc chọn ngày khác.";
            } else if (numRooms > availableRooms.size() && !availableRooms.isEmpty()) {
                // Tính tổng sức chứa
                int totalCapacity = availableRooms.stream()
                    .limit(numRooms)
                    .mapToInt(RoomsDTO::getCapacity)
                    .sum();
                
                if (totalCapacity >= guests) {
                    roomMessage = "Chỉ còn " + availableRooms.size() + " phòng trống (đủ cho " + totalCapacity + " người). Bạn có thể đặt " + availableRooms.size() + " phòng.";
                } else {
                    roomMessage = "Chỉ còn " + availableRooms.size() + " phòng trống nhưng không đủ sức chứa cho " + guests + " người.";
                }
            }

            request.setAttribute("homestay", homestay);
            request.setAttribute("reviews", reviews);
            request.setAttribute("homestayImages", images);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("roomMessage", roomMessage);
            request.setAttribute("checkIn", checkInStr);
            request.setAttribute("checkOut", checkOutStr);
            request.setAttribute("guests", guestsStr);
            request.setAttribute("numRooms", numRoomsStr);

            request.getRequestDispatcher("/HomePage/HomestayDetail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi hệ thống khi tải homestay: " + e.getMessage());
            request.getRequestDispatcher("/HomePage/HomestayDetail.jsp").forward(request, response);
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}