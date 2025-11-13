/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package filter;

import dao.FeaturesDAO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebFilter("/*")
public class AuthPermissionFilter implements Filter {

    private FeaturesDAO featuresDAO;
    private List<String> publicUrls;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        featuresDAO = new FeaturesDAO();
        // Full list public URLs từ SQL + auth (guest OK)
        publicUrls = Arrays.asList(
                "/Home", "/home",
                "/homestay-list", "/homestays-list",
                "/homestay-detail",
                "/restaurant", "/restaurants",
                "/restaurant-detail",
                "/add-to-cart",
                "/update-cart-quantity",
                "/update-cart-notes",
                "/remove-from-cart",
                "/check-available-table",
                "/checkout-restaurant",
                "/confirmation-payment",
                "/payment-status",
                "/sepay-webhook",
                "/cancel-expired-booking",
                "/Login", "/Logout",
                "/register-customer", "/register-owner",
                "/forgot-password",
                "/"
        );
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String requestUri = request.getRequestURI().replaceFirst(request.getContextPath(), "");

        // Bước 1: Public URL (guest OK) 
        boolean isPublic = false;
        for (String uri : publicUrls) {
            if (requestUri.startsWith(uri)) {
                isPublic = true;
                break; 
            }
        }

        if (isPublic) {
            chain.doFilter(req, res);
            return;
        }

        // Bước 2: Private → Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Login?from=" + requestUri);
            return;
        }

        // Bước 3: 
        Users currentUser = (Users) session.getAttribute("currentUser");
        int roleId = currentUser.getRole().getRoleId();

        Integer featureId = featuresDAO.getFeatureIdByUrl(requestUri);
        if (featureId != null && !featuresDAO.hasPermission(roleId, featureId)) {
            response.sendRedirect(request.getContextPath() + "/home?error=unauthorized");
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
    }

}
