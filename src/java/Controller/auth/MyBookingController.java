/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller.auth;

/**
 *
 * @author admin
 */
import dao.BookingDAO;
import model.Bookings; // Sử dụng model của bạn
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

// Đặt URL pattern cho servlet
@jakarta.servlet.annotation.WebServlet(name = "MyBookingController", urlPatterns = {"/my-bookings"})
public class MyBookingController extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        // Kiểm tra đăng nhập
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        // Lấy danh sách booking từ DAO
        List<Bookings> bookingList = bookingDAO.getBookingsByUserId(currentUser.getUserId());

        // Đặt danh sách vào request
        request.setAttribute("bookingList", bookingList);

        request.getRequestDispatcher("/ProfilePage/MyBooking.jsp").forward(request, response);
    }
}
