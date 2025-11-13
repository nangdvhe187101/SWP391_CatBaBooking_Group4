/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Locale;
import java.util.Properties;
import java.util.ResourceBundle;
import model.Bookings;

/**
 * @author ADMIN 
 */
public class EmailUtil {

    private static final Properties properties = new Properties();
    private static final Session session;

    static {
        String resourcePath = "properties/Email.properties";
        try (InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream(resourcePath)) {
            if (input == null) {
                throw new RuntimeException("Không tìm thấy file cấu hình email.");
            }
            properties.load(input);
            session = Session.getInstance(properties, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(
                            properties.getProperty("mail.app.username"),
                            properties.getProperty("mail.app.password")
                    );
                }
            });
            System.out.println("✅ Đã tải cấu hình email và khởi tạo Session thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi nghiêm trọng khi khởi tạo cấu hình email.", e);
        }
    }

    private static String getFromEmail() {
        return properties.getProperty("mail.app.username");
    }

    private static String getSupportEmail() {
        return properties.getProperty("mail.support.address");
    }

    private static String getSenderName() {
        return properties.getProperty("mail.app.sender_name", "Cat Ba Booking");
    }

    // --- CÁC PHƯƠNG THỨC GỬI EMAIL ---
    public static void sendRegistrationConfirmation(String toEmail, String recipientName) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail(), getSenderName()));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Welcome to Cat Ba Booking!");
            message.setContent(createRegistrationContent(recipientName), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Registration confirmation email sent to: " + toEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void sendOTP(String toEmail, String otp) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail(), "Cát Bà Booking"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Password Reset OTP Code - Cát Bà Booking");
            message.setContent(createOTPContent(otp), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ OTP email sent to: " + toEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void sendPendingConfirmation(String toEmail, String recipientName) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail(), getSenderName()));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Your Registration is Under Review - Cat Ba Booking");
            message.setContent(createPendingContent(recipientName), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Pending confirmation email sent to: " + toEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void sendAdminNotification(String adminEmail, String fullName, String userEmail, String businessName, String businessType) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail(), getSenderName()));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(adminEmail));
            message.setSubject("New Owner Registration Pending Approval - Cat Ba Booking");
            message.setContent(createAdminNotificationContent(fullName, userEmail, businessName, businessType), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Admin notification email sent to: " + adminEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void sendApprovalConfirmation(String toEmail, String recipientName, String businessName) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail(), getSenderName()));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Your Registration Has Been Approved - Cat Ba Booking");
            message.setContent(createApprovalContent(recipientName, businessName), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Approval confirmation email sent to: " + toEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void sendRejectionNotification(String toEmail, String recipientName, String businessName, String reason) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail(), getSenderName()));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Your Registration Has Been Rejected - Cat Ba Booking");
            message.setContent(createRejectionContent(recipientName, businessName, reason), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Rejection notification email sent to: " + toEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String createRegistrationContent(String recipientName) {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <style>
                body { font-family: Arial, sans-serif; color: #333; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { background-color: #1890ff; color: white; padding: 10px; text-align: center; border-radius: 8px 8px 0 0; }
                .content { padding: 20px; background-color: #f9fafb; border: 1px solid #e5e7eb; }
                .button { display: inline-block; padding: 10px 20px; background-color: #1890ff; color: white; text-decoration: none; border-radius: 5px; }
                .footer { text-align: center; font-size: 12px; color: #6b7280; margin-top: 20px; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h2>Welcome to Cat Ba Booking!</h2>
                </div>
                <div class="content">
                    <p>Hello %s,</p>
                    <p>Thank you for joining Cat Ba Booking, your gateway to discovering the best homestays and restaurants on the beautiful Cat Ba Island!</p>
                    <p>Explore serene beaches, vibrant local culture, and delightful dining experiences. Start planning your perfect trip today!</p>
                </div>
                <div class="footer">
                    <p>Best regards,<br>The Cat Ba Booking Team</p>
                    <p>Cat Ba Island, Vietnam | <a href="mailto:%s">Contact Support</a> | <a href="https://catbabooking.fms@gmail.com">catbabooking.com</a></p>
                </div>
            </div>
        </body>
        </html>
        """.formatted(escapeHtml(recipientName), getSupportEmail());
    }

    private static String createOTPContent(String otp) {
        return """
        <html>
            <body>
                <h2>Password Reset OTP Code</h2>
                <p>Your OTP code is: <strong>%s</strong></p>
                <p>This code is valid for 5 minutes. Please do not share it with anyone.</p>
                <p>Best regards,<br>Cát Bà Booking</p>
            </body>
        </html>
        """.formatted(otp);
    }

    private static String createPendingContent(String recipientName) {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <style>
                body { font-family: Arial, sans-serif; color: #333; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { background-color: #1890ff; color: white; padding: 10px; text-align: center; border-radius: 8px 8px 0 0; }
                .content { padding: 20px; background-color: #f9fafb; border: 1px solid #e5e7eb; }
                .footer { text-align: center; font-size: 12px; color: #6b7280; margin-top: 20px; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h2>Your Registration is Under Review</h2>
                </div>
                <div class="content">
                    <p>Hello %s,</p>
                    <p>Your application to register as a homestay or restaurant owner with Cat Ba Booking has been successfully submitted.</p>
                    <p>Our team is reviewing your application, and you will receive a response within the next few hours. Thank you for your patience!</p>
                </div>
                <div class="footer">
                    <p>Best regards,<br>The Cat Ba Booking Team</p>
                    <p>Cat Ba Island, Vietnam | <a href="mailto:%s">Contact Support</a> | <a href="https://catbabooking.fms@gmail.com">catbabooking.com</a></p>
                </div>
            </div>
        </body>
        </html>
        """.formatted(escapeHtml(recipientName), getSupportEmail());
    }

    private static String createAdminNotificationContent(String fullName, String userEmail, String businessName, String businessType) {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <style>
                body { font-family: Arial, sans-serif; color: #333; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { background-color: #1890ff; color: white; padding: 10px; text-align: center; border-radius: 8px 8px 0 0; }
                .content { padding: 20px; background-color: #f9fafb; border: 1px solid #e5e7eb; }
                .button { display: inline-block; padding: 10px 20px; background-color: #1890ff; color: white; text-decoration: none; border-radius: 5px; }
                .footer { text-align: center; font-size: 12px; color: #6b7280; margin-top: 20px; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h2>New Owner Registration Request</h2>
                </div>
                <div class="content">
                    <p><strong>Pending Approval</strong></p>
                    <p>A new owner has registered and is awaiting your approval:</p>
                    <ul>
                        <li><strong>Full Name:</strong> %s</li>
                        <li><strong>Email:</strong> %s</li>
                        <li><strong>Business Name:</strong> %s</li>
                        <li><strong>Business Type:</strong> %s</li>
                    </ul>
                    <p>Please review and approve or deny this application in the admin dashboard.</p>
                </div>
                <div class="footer">
                    <p>Best regards,<br>The Cat Ba Booking Team</p>
                    <p>Cat Ba Island, Vietnam | <a href="mailto:%s">Contact Support</a> | <a href="https://catbabooking.fms@gmail.com">catbabooking.com</a></p>
                </div>
            </div>
        </body>
        </html>
        """.formatted(escapeHtml(fullName), escapeHtml(userEmail), escapeHtml(businessName), escapeHtml(businessType), getSupportEmail());
    }

    private static String createApprovalContent(String recipientName, String businessName) {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <style>
                body { font-family: Arial, sans-serif; color: #333; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { background-color: #1890ff; color: white; padding: 10px; text-align: center; border-radius: 8px 8px 0 0; }
                .content { padding: 20px; background-color: #f9fafb; border: 1px solid #e5e7eb; }
                .button { display: inline-block; padding: 10px 20px; background-color: #1890ff; color: white; text-decoration: none; border-radius: 5px; }
                .footer { text-align: center; font-size: 12px; color: #6b7280; margin-top: 20px; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h2>Registration Approved!</h2>
                </div>
                <div class="content">
                    <p>Hello %s,</p>
                    <p>Congratulations! Your application to register %s as a homestay or restaurant owner has been approved.</p>
                    <p>You can now log in to your account and start managing your business on Cat Ba Booking.</p>
                </div>
                <div class="footer">
                    <p>Best regards,<br>The Cat Ba Booking Team</p>
                    <p>Cat Ba Island, Vietnam | <a href="mailto:%s">Contact Support</a> | <a href="https://catbabooking.fms@gmail.com">catbabooking.com</a></p>
                </div>
            </div>
        </body>
        </html>
        """.formatted(escapeHtml(recipientName), escapeHtml(businessName), getSupportEmail());
    }

    private static String createRejectionContent(String recipientName, String businessName, String reason) {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <style>
                body { font-family: Arial, sans-serif; color: #333; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { background-color: #ff4d4f; color: white; padding: 10px; text-align: center; border-radius: 8px 8px 0 0; }
                .content { padding: 20px; background-color: #f9fafb; border: 1px solid #e5e7eb; }
                .button { display: inline-block; padding: 10px 20px; background-color: #1890ff; color: white; text-decoration: none; border-radius: 5px; }
                .footer { text-align: center; font-size: 12px; color: #6b7280; margin-top: 20px; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h2>Registration Rejected</h2>
                </div>
                <div class="content">
                    <p>Hello %s,</p>
                    <p>We regret to inform you that your application to register %s as a homestay or restaurant owner has been rejected.</p>
                    <p><strong>Reason:</strong> %s</p>
                    <p>If you believe this is an error or wish to reapply to the system, please resubmit your application to us.</p>
                    <a href="mailto:%s" class="button">Contact Support</a>
                </div>
                <div class="footer">
                    <p>Best regards,<br>The Cat Ba Booking Team</p>
                    <p>Cat Ba Island, Vietnam | <a href="mailto:%s">Contact Support</a> | <a href="https://catbabooking.fms@gmail.com">catbabooking.fms@gmail.com</a></p>
                </div>
            </div>
        </body>
        </html>
        """.formatted(escapeHtml(recipientName), escapeHtml(businessName), escapeHtml(reason), getSupportEmail(), getSupportEmail());
    }
    
    public static void sendBookingConfirmation(String toEmail, Bookings booking) {
        // 1. Lấy cấu hình từ file properties
        ResourceBundle rb = ResourceBundle.getBundle("properties.Email");
        final String fromEmail = rb.getString("email.user");
        final String password = rb.getString("email.password");

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // 2. Tạo Session
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            // 3. Tạo nội dung Email (HTML)
            MimeMessage msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
            msg.addHeader("format", "flowed");
            msg.addHeader("Content-Transfer-Encoding", "8bit");

            msg.setFrom(new InternetAddress(fromEmail, "Cat Ba Booking System"));
            msg.setReplyTo(InternetAddress.parse(fromEmail, false));
            msg.setSubject("Xác nhận đặt phòng thành công - Mã đơn: " + booking.getBookingCode(), "UTF-8");
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));

            // Format dữ liệu
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            String totalPrice = nf.format(booking.getTotalPrice());
            String checkIn = booking.getReservationStartTime() != null ? booking.getReservationStartTime().format(dtf) : "N/A";
            String checkOut = booking.getReservationEndTime() != null ? booking.getReservationEndTime().format(dtf) : "N/A";
            
            // Tên Homestay/Nhà hàng
            String businessName = (booking.getBusiness() != null) ? booking.getBusiness().getName() : "Dịch vụ";

            // Template HTML
            String body = 
                "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;'>" +
                "  <h2 style='color: #198754; text-align: center;'>Đặt phòng thành công!</h2>" +
                "  <p>Xin chào <strong>" + booking.getBookerName() + "</strong>,</p>" +
                "  <p>Cảm ơn bạn đã sử dụng dịch vụ của <strong>Cat Ba Booking</strong>. Đơn đặt phòng của bạn đã được thanh toán và xác nhận.</p>" +
                "  <hr style='border: 0; border-top: 1px dashed #ccc;'/>" +
                "  <h3 style='color: #333;'>Thông tin chi tiết:</h3>" +
                "  <table style='width: 100%; border-collapse: collapse;'>" +
                "    <tr><td style='padding: 8px; color: #666;'>Mã đơn hàng:</td><td style='padding: 8px; font-weight: bold;'>" + booking.getBookingCode() + "</td></tr>" +
                "    <tr><td style='padding: 8px; color: #666;'>Địa điểm:</td><td style='padding: 8px; font-weight: bold;'>" + businessName + "</td></tr>" +
                "    <tr><td style='padding: 8px; color: #666;'>Nhận phòng:</td><td style='padding: 8px;'>" + checkIn + "</td></tr>" +
                "    <tr><td style='padding: 8px; color: #666;'>Trả phòng:</td><td style='padding: 8px;'>" + checkOut + "</td></tr>" +
                "    <tr><td style='padding: 8px; color: #666;'>Số khách:</td><td style='padding: 8px;'>" + booking.getNumGuests() + " người</td></tr>" +
                "    <tr><td style='padding: 8px; color: #666;'>Tổng thanh toán:</td><td style='padding: 8px; font-weight: bold; color: #d32f2f;'>" + totalPrice + "</td></tr>" +
                "  </table>" +
                "  <hr style='border: 0; border-top: 1px dashed #ccc;'/>" +
                "  <p>Vui lòng xuất trình email này hoặc mã đơn hàng khi đến nhận phòng.</p>" +
                "  <p style='text-align: center; font-size: 12px; color: #999;'>Đây là email tự động, vui lòng không trả lời.</p>" +
                "</div>";

            msg.setContent(body, "text/html; charset=UTF-8");
            msg.setSentDate(new Date());

            // 4. Gửi mail (Chạy trong thread riêng để không chặn luồng chính)
            new Thread(() -> {
                try {
                    Transport.send(msg);
                    System.out.println("Email sent successfully to " + toEmail);
                } catch (MessagingException e) {
                    e.printStackTrace();
                }
            }).start();

        } catch (MessagingException | UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }

    private static String escapeHtml(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }

    public static void main(String[] args) {
        System.out.println("=== Email Test ===");
        sendRegistrationConfirmation("nangdvhe187101@fpt.edu.vn", "Năng");
        System.out.println("=== Test Complete ===");
    }
}
