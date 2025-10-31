/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller_OwnerHomestay;

import dao.RoomDAO;
import model.Rooms;
import model.Businesses;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.math.BigDecimal;

/**
 *
 * @author admin
 */
@WebServlet(name="AddHomestay", urlPatterns={"/OwnerPage/AddHomestay"})

public class AddHomestay extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet AddHomestay</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddHomestay at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Đảm bảo đọc được Unicode (tiếng Việt)
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form JSP
            int businessId = Integer.parseInt(request.getParameter("businessId"));
            String name = request.getParameter("name");
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            BigDecimal pricePerNight = new BigDecimal(request.getParameter("pricePerNight"));
            String image = request.getParameter("image");
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));

            // Tạo đối tượng Business (chỉ cần set ID)
            Businesses business = new Businesses();
            business.setBusinessId(businessId);

            // Tạo đối tượng Room
            Rooms room = new Rooms();
            room.setBusiness(business);
            room.setName(name);
            room.setCapacity(capacity);
            room.setPricePerNight(pricePerNight);
            room.setImage(image);
            room.setIsActive(isActive);

            // Gọi DAO để lưu vào DB
            RoomDAO dao = new RoomDAO();
            boolean success = dao.insertRoom(room);

            if (success) {
                request.setAttribute("message", "Thêm phòng thành công!");
            } else {
                request.setAttribute("message", "Thêm phòng thất bại!");
            }

            // Quay lại trang AddHomestay.jsp
            request.getRequestDispatcher("AddHomestay.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("AddHomestay.jsp").forward(request, response);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
