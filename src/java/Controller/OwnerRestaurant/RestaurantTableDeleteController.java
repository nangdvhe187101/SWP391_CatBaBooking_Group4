/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.OwnerRestaurant;

import dao.BusinessDAO;
import dao.RestaurantTableDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import model.Businesses;
import model.RestaurantTables;
import model.Users;


/**
 *
 * @author ADMIN
 */
@WebServlet(name = "RestaurantTableDeleteController", urlPatterns = {"/restaurant-table-delete"})
public class RestaurantTableDeleteController extends HttpServlet {

    private BusinessDAO businessDAO;
    private RestaurantTableDAO tableDAO;

    @Override
    public void init() throws ServletException {
        businessDAO = new BusinessDAO();
        tableDAO = new RestaurantTableDAO();
    }
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return ;
        }

        Businesses biz = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        if (biz == null) {
            request.setAttribute("error", "Không tìm thấy nhà hàng.");
            request.getRequestDispatcher("/OwnerPage/RestaurantManageTables.jsp").forward(request, response);
            return ;
        }
        
        String message = null;
        List<String> errors = new ArrayList<>();
        
        String tableIdStr = request.getParameter("tableId");
        if (tableIdStr != null && !tableIdStr.trim().isEmpty()) {
            int tableId = Integer.parseInt(tableIdStr);
            int rows = tableDAO.deleteTables(tableId);
            message = rows > 0 ? "Xóa bàn thành công!" : "Không thể xóa bàn.";
        } else {
            errors.add("ID bàn không hợp lệ.");
        }
        if (!errors.isEmpty()) {
            session.setAttribute("errors", errors);
        }
        if (message != null) {
            session.setAttribute("message", message);
        }
        response.sendRedirect(request.getContextPath() + "/restaurant-manage-tables");
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
