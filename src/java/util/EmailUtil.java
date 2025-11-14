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
import java.util.Properties;
import java.io.UnsupportedEncodingException;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Locale;
import java.util.Properties;
import java.util.ResourceBundle;
import model.Bookings;
import java.time.format.DateTimeFormatter;
import java.util.Properties;
import model.Bookings;
import model.dto.BusinessesDTO;

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

    public static void sendBookingConfirmation(Bookings booking, BusinessesDTO restaurant) {
        if (booking == null || restaurant == null
                || booking.getBookerEmail() == null || booking.getBookerEmail().trim().isEmpty()) {
            return;
        }
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getFromEmail(), getSenderName()));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(booking.getBookerEmail()));
            message.setSubject("Booking Confirmation - " + restaurant.getName() + " | Cat Ba Booking");
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
            String dateStr = booking.getReservationDateForDB() != null
                    ? dateFormatter.format(booking.getReservationDateForDB()) : "N/A";
            String timeStr = booking.getReservationTimeForDB() != null
                    ? timeFormatter.format(booking.getReservationTimeForDB()) : "N/A";
            String totalStr = String.format("%,.0f ₫", booking.getTotalPrice().doubleValue());
            message.setContent(createBookingConfirmationContent(
                    booking.getBookerName(),
                    booking.getBookingCode(),
                    restaurant.getName(),
                    restaurant.getAddress(),
                    dateStr,
                    timeStr,
                    booking.getNumGuests(),
                    totalStr
            ), "text/html; charset=UTF-8");
            Transport.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * ✅ FIXED: Booking confirmation email template (NO PHONE NEEDED)
     */
    private static String createBookingConfirmationContent(
            String recipientName,
            String bookingCode,
            String restaurantName,
            String restaurantAddress,
            String dateStr,
            String timeStr,
            int numGuests,
            String totalStr) {
        return """
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            background-color: #ffffff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .header {
            background: linear-gradient(135deg, #059669, #10b981);
            color: white;
            padding: 30px 20px;
            text-align: center;
        }
        .header h2 {
            margin: 0;
            font-size: 24px;
        }
        .header .icon {
            font-size: 48px;
            margin-bottom: 10px;
        }
        .content {
            padding: 30px;
        }
        .booking-details {
            background: #f0fdf4;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #059669;
        }
        .booking-details h3 {
            margin: 0 0 15px 0;
            color: #059669;
            font-size: 18px;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e5e7eb;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: 600;
            color: #6b7280;
        }
        .detail-value {
            color: #111827;
            text-align: right;
        }
        .booking-code {
            background: #059669;
            color: white;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            letter-spacing: 2px;
            margin: 20px 0;
        }
        .important-note {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 15px;
            border-radius: 4px;
            margin: 20px 0;
        }
        .important-note strong {
            color: #d97706;
        }
        .button {
            display: inline-block;
            padding: 12px 30px;
            background-color: #059669;
            color: white !important;
            text-decoration: none;
            border-radius: 6px;
            margin: 20px 0;
            font-weight: 600;
            transition: background-color 0.3s;
        }
        .button:hover {
            background-color: #047857;
        }
        .footer {
            text-align: center;
            font-size: 12px;
            color: #6b7280;
            padding: 20px;
            background-color: #f9fafb;
            border-top: 1px solid #e5e7eb;
        }
        .footer a {
            color: #059669;
            text-decoration: none;
        }
        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Booking Confirmed Successfully!</h2>
        </div>
       
        <div class="content">
            <p>Hello <strong>%s</strong>,</p>
            <p>Thank you for your payment! We are pleased to inform you that your booking at <strong>%s</strong> has been successfully confirmed.</p>
           
            <div class="booking-code">
                %s
            </div>
           
            <div class="booking-details">
                <h3>Booking Details</h3>
                <div class="detail-row">
                    <span class="detail-label">Restaurant:</span>
                    <span class="detail-value">%s</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Address:</span>
                    <span class="detail-value">%s</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Booking Date:</span>
                    <span class="detail-value">%s</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Booking Time:</span>
                    <span class="detail-value">%s</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Number of Guests:</span>
                    <span class="detail-value">%d people</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Total Amount:</span>
                    <span class="detail-value"><strong>%s</strong></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Status:</span>
                    <span class="detail-value" style="color: #059669; font-weight: bold;">Paid & Confirmed</span>
                </div>
            </div>
           
            <div class="important-note">
                <strong>Important Note:</strong><br>
                • Please arrive on time as booked<br>
                • Bring your booking code when arriving at the restaurant<br>
                • If you need to make changes, please contact us at least 24 hours in advance
            </div>
           
            <p>If you have any questions, feel free to contact our support team.</p>
           
            <center>
                <a href="mailto:%s" class="button">Contact Support</a>
            </center>
        </div>
       
        <div class="footer">
            <p><strong>Best regards,</strong><br>Cat Ba Booking Team</p>
            <p>Cát Bà Island, Vietnam<br>
            <a href="mailto:%s">%s</a> | <a href="https://catbabooking.com">catbabooking.com</a></p>
            <p style="margin-top: 15px; font-size: 11px; color: #9ca3af;">
                This email was sent automatically, please do not reply directly.
            </p>
        </div>
    </div>
</body>
</html>
""".formatted(
                escapeHtml(recipientName),
                escapeHtml(restaurantName),
                escapeHtml(bookingCode),
                escapeHtml(restaurantName),
                escapeHtml(restaurantAddress != null ? restaurantAddress : "Updating"),
                escapeHtml(dateStr),
                escapeHtml(timeStr),
                numGuests,
                escapeHtml(totalStr),
                getSupportEmail(),
                getSupportEmail(),
                getSupportEmail()
        );
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
