package controller.HomePage;

import dao.BookingDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import model.Bookings;
import java.sql.SQLException;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "SePayWebhookController", urlPatterns = {"/sepay-webhook"})
public class SePayWebhookController extends HttpServlet {

    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        paymentDAO = new PaymentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setStatus(405);
        response.setContentType("application/json");
        response.getWriter().write("{\"error\":\"Method not allowed\"}");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Optional authentication
        String token = System.getProperty("SEPAY_API_TOKEN");
        if (token == null || token.isEmpty()) {
            token = System.getenv("SEPAY_API_TOKEN");
        }
        String auth = request.getHeader("Authorization");
        if (token != null && !token.isEmpty()) {
            if (auth == null || !auth.equals("Apikey " + token)) {
                System.err.println("[WEBHOOK] ERROR: Unauthorized request");
                response.setStatus(401);
                response.setContentType("application/json");
                response.getWriter().write("{\"error\":\"unauthorized\"}");
                return;
            }
        } 

        // Read request body
        String body;
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(request.getInputStream(), StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            body = sb.toString();
        }
        // Parse SePay Bank API format fields
        String gateway = extractField(body, "\"gateway\"\\s*:\\s*\"(.*?)\"");
        String content = extractField(body, "\"content\"\\s*:\\s*\"(.*?)\"");
        String description = extractField(body, "\"description\"\\s*:\\s*\"(.*?)\"");
        String transferType = extractField(body, "\"transferType\"\\s*:\\s*\"(.*?)\"");
        String transferAmountStr = extractField(body, "\"transferAmount\"\\s*:\\s*(\\d+)");
        String transactionId = extractField(body, "\"id\"\\s*:\\s*(\\d+)");
        String referenceCode = extractField(body, "\"referenceCode\"\\s*:\\s*\"(.*?)\"");
        // Validate transfer type must be "in"
        if (!"in".equalsIgnoreCase(transferType)) {
            response.setStatus(200);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"ok\",\"message\":\"ignored_transfer_type\"}");
            return;
        }
        // Extract booking code from content or description
        String bookingCode = null;
        if (content != null && !content.trim().isEmpty()) {
            bookingCode = extractBookingCode(content);
        }
        
        if (bookingCode == null && description != null && !description.trim().isEmpty()) {
            bookingCode = extractBookingCode(description);
        }
        
        if (bookingCode == null) {
            response.setStatus(200);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"ok\",\"message\":\"booking_code_not_found\"}");
            return;
        }
        // Normalize booking code
        bookingCode = bookingCode.trim().toUpperCase();
        // Process payment update
        try {
            Integer paymentId = paymentDAO.getPaymentIdByBookingCode(bookingCode);
            if (paymentId == null) {
                response.setStatus(200);
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"ok\",\"message\":\"payment_not_found\"}");
                return;
            }
            String finalStatus = "completed";
            LocalDateTime paidAt = LocalDateTime.now();
            // Build transaction code from available fields
            String txnCode = (referenceCode != null ? referenceCode : "") + "_" + 
                            (transactionId != null ? transactionId : "");
            int rowsUpdated = paymentDAO.updatePaymentStatus(
                paymentId, 
                finalStatus, 
                txnCode, 
                body, 
                paidAt
            );
            if (rowsUpdated > 0) {
                Bookings booking = bookingDAO.getBookingByCode(bookingCode);
                if (booking != null) {
                    bookingDAO.syncBookingPayment(booking.getBookingId());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Always return 200 to prevent SePay retry
        response.setStatus(200);
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"ok\",\"message\":\"processed\"}");
    }

    
    private String extractBookingCode(String text) {
        if (text == null || text.trim().isEmpty()) {
            return null;
        }
        Pattern p1 = Pattern.compile("(?i)\\b((BK|HS)[0-9A-F]{8}\\d{4,5})\\b");
        Matcher m1 = p1.matcher(text);
        if (m1.find()) {
            String code = m1.group(1);
            return code;
        }
        
        Pattern p2 = Pattern.compile("(?i)\\b((BK|HS)[0-9A-F]{10,16})\\b");
        Matcher m2 = p2.matcher(text);
        if (m2.find()) {
            String code = m2.group(1);
            return code;
        }
        return null;
    }
    /**
     * Extract field from JSON using regex
     */
    private String extractField(String json, String pattern) {
        if (json == null || json.trim().isEmpty()) {
            return null;
        }
        
        try {
            Matcher m = Pattern.compile(pattern, Pattern.DOTALL).matcher(json);
            if (m.find()) {
                String value = m.group(1);
                // Unescape JSON
                return value.replace("\\\"", "\"")
                           .replace("\\/", "/")
                           .replace("\\n", "\n")
                           .replace("\\t", "\t");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}