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
import service.RestaurantTableValidator;


/**
 *
 * @author ADMIN
 */
@WebServlet(name = "RestaurantTableAddController", urlPatterns = {"/restaurant-table-add"})
public class RestaurantTableAddController extends HttpServlet {

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
        
        String message = null;
        List<String> errors = new ArrayList<>();
        
        String name = request.getParameter("name");
        String capacityStr = request.getParameter("capacity");
        String isActiveStr = request.getParameter("isActive");
        
        var vr = RestaurantTableValidator.validate(name, capacityStr, isActiveStr, biz.getBusinessId(), null);
        if (!vr.valid) {
            errors.addAll(vr.errors);
            session.setAttribute("errors", errors); 
        } else {
            RestaurantTables table = new RestaurantTables();
            table.setBusiness(biz);
            table.setName(name.trim());
            table.setCapacity(Integer.parseInt(capacityStr.trim()));
            table.setActive("true".equals(isActiveStr));
            int rows = tableDAO.insertTables(table);
            if (rows > 0) {
                message = "Thêm bàn thành công!";
            } else {
                session.setAttribute("error", "Lỗi khi thêm bàn.");
            }
            if (message != null) {
                session.setAttribute("message", message);
            }
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
