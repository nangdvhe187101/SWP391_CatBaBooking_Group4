/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.HomePage;

import dao.AreaDAO;
import dao.HomestayDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import model.Areas;
import model.Businesses;

/**
 *
 * @author Admin
 */
@WebServlet(name = "SearchHomestayController", urlPatterns = {"/homestays"})
public class SearchHomestayController extends HttpServlet {

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

        HomestayDAO homestayDAO = new HomestayDAO();
        AreaDAO areaDAO = new AreaDAO();

        try {
            // 1. Luôn lấy danh sách khu vực 
            List<Areas> areaList = areaDAO.getAllAreas();
            request.setAttribute("areaList", areaList);
            // 2. Lấy các tham số tìm kiếm
            String areaIdStr = request.getParameter("areaId");
            String checkInStr = request.getParameter("checkIn");
            String checkOutStr = request.getParameter("checkOut");
            String guestsStr = request.getParameter("guests");

            List<Businesses> homestay;

            if (areaIdStr != null || checkInStr != null || guestsStr != null) {
                int areaId = 0;
                int guests = 0;
                LocalDate checkIn = null;
                LocalDate checkOut = null;

                try {
                    if (areaIdStr != null && !areaIdStr.isEmpty()) {
                        areaId = Integer.parseInt(areaIdStr);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Lỗi parse areaId: " + areaIdStr);
                }

                try {
                    if (guestsStr != null && !guestsStr.isEmpty()) {
                        guests = Integer.parseInt(guestsStr);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Lỗi parse guests: " + guestsStr);
                }

                try {
                    if (checkInStr != null && !checkInStr.isEmpty()) {
                        checkIn = LocalDate.parse(checkInStr);
                    }
                    if (checkOutStr != null && !checkOutStr.isEmpty()) {
                        checkOut = LocalDate.parse(checkOutStr);
                    }
                } catch (DateTimeParseException e) {
                    System.err.println("Lỗi parse ngày: " + e.getMessage());
                }

                homestay = homestayDAO.searchHomestays(areaId, checkIn, checkOut, guests);
            } else {
                homestay = homestayDAO.getAllHomestay();
            }
            request.setAttribute("homestays", homestay);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tìm kiếm homestay. Vui lòng thử lại.");
        }
        request.getRequestDispatcher("/HomePage/Homestay.jsp").forward(request, response);
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
        processRequest(request, response);
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
    }

}
