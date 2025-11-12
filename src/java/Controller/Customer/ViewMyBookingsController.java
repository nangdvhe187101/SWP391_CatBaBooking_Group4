    /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Customer;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.Users;
import model.dto.BookingHistoryDTO;

/**
 *
 * @author jackd
 */
@WebServlet(name = "ViewMyBookingsController", urlPatterns = {"/my-bookings"})
public class ViewMyBookingsController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ViewMyBookingsController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewMyBookingsController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Lấy session, không tạo mới

        // 1. Kiểm tra đăng nhập (Bảo mật)
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("Login"); // Về trang đăng nhập
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");
        
        // 2. Kiểm tra vai trò (Chỉ Customer mới có lịch sử booking)
        if (currentUser.getRole().getRoleId() != 1) { // Giả sử Role 1 là Customer
             if(currentUser.getRole().getRoleId() == 2) { // Owner
                 response.sendRedirect("owner-dashboard"); // (URL dashboard của Owner)
             } else if (currentUser.getRole().getRoleId() == 3) { // Admin
                 response.sendRedirect("admin-dashboard"); // (URL dashboard của Admin)
             } else {
                 response.sendRedirect("Logout"); // Vai trò lạ -> Đăng xuất
             }
            return;
        }

        int userId = currentUser.getUserId();

        try {
            // 3. Gọi DAO
            BookingDAO bookingDAO = new BookingDAO();
            List<BookingHistoryDTO> bookingList = bookingDAO.getBookingHistoryByUserId(userId);

            // 4. Đặt dữ liệu vào request
            request.setAttribute("bookingList", bookingList);

            // 5. Forward đến trang JSP
            request.getRequestDispatcher("CustomerPage/MyBookings.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi
            request.setAttribute("error", "Lỗi khi tải lịch sử đặt chỗ.");
            request.getRequestDispatcher("CustomerPage/MyBookings.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
