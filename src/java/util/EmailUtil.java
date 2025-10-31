/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.InputStream;
import java.util.Properties;

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
