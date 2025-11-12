/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.OwnerRestaurant;

import dao.BusinessDAO;
import dao.RestaurantTableDAO;
import jakarta.servlet.ServletConfig;
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
import service.RestaurantTableValidator;


/**
 *
 * @author ADMIN
 */
@WebServlet(name = "RestaurantManageTablesController", urlPatterns = {"/restaurant-manage-tables"})
public class RestaurantManageTablesController extends HttpServlet {

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
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole().getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Businesses biz = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        if (biz == null) {
            request.setAttribute("error", "Không tìm thấy nhà hàng.");
            request.getRequestDispatcher("/OwnerPage/RestaurantManageTables.jsp").forward(request, response);
            return;
        }
        String action = request.getParameter("action");
        List<RestaurantTables> tables = tableDAO.getAllByBusinessId(biz.getBusinessId());
        RestaurantTables editTable = null;
        
        if("edit".equals(action)){
            String tableIdStr = request.getParameter("tableId");
            if(tableIdStr != null && !tableIdStr.trim().isEmpty()){
                int tableId = Integer.parseInt(tableIdStr);
                editTable = tableDAO.getByIdTable(tableId);
                if(editTable == null){
                    request.setAttribute("error", "Bàn không tồn tại.");
                }
            }
        }
        
        List<String> errors = (List<String>) session.getAttribute("errors");
        String error = (String) session.getAttribute("error");
        String message = (String) session.getAttribute("message");

        // Xóa khỏi session để không hiển thị lại
        session.removeAttribute("errors");
        session.removeAttribute("error");
        session.removeAttribute("message");

        // Đặt vào request để JSP có thể đọc
        if (errors != null) {
            request.setAttribute("errors", errors);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }
        if (message != null) {
            request.setAttribute("message", message);
        }
        
        request.setAttribute("tables", tables);
        request.setAttribute("business", biz);
        request.setAttribute("editTable", editTable);
        request.getRequestDispatcher("/OwnerPage/RestaurantManageTables.jsp").forward(request, response);
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
