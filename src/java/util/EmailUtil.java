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
import java.util.Properties;

/**
 *
 * @author ADMIN
 */
public class EmailUtil {

    private static final String FROM_EMAIL = "catbabooking.fms@gmail.com";
    private static final String SUPPORT_EMAIL = "catbabooking.fms@gmail.com";
    private static final String PASSWORD = "bzsnvnkpjodfwdvx";

    // Common method to configure SMTP properties and session
    private static Session getSmtpSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });
    }

    // Send registration confirmation email to regular users
    public static void sendRegistrationConfirmation(String toEmail, String recipientName) {
        Session session = getSmtpSession();
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Cat Ba Booking"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Welcome to Cat Ba Booking!");
            message.setContent(createRegistrationContent(recipientName), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Registration confirmation email sent to: " + toEmail);
        } catch (Exception e) {
            System.err.println("❌ Failed to send registration confirmation email: " + e.getMessage());
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
        """.formatted(escapeHtml(recipientName), SUPPORT_EMAIL);
    }

    public static void sendOTP(String toEmail, String otp) {
        Session session = getSmtpSession();
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Cát Bà Booking"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Password Reset OTP Code - Cát Bà Booking");
            message.setContent(createOTPContent(otp), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ OTP email sent to: " + toEmail);
        } catch (Exception e) {
            System.err.println("❌ Failed to send OTP email: " + e.getMessage());
        }
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

    public static void sendPendingConfirmation(String toEmail, String recipientName) {
        Session session = getSmtpSession();
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Cat Ba Booking"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Your Registration is Under Review - Cat Ba Booking");
            message.setContent(createPendingContent(recipientName), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Pending confirmation email sent to: " + toEmail);
        } catch (Exception e) {
            System.err.println("❌ Failed to send pending confirmation email: " + e.getMessage());
        }
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
        """.formatted(escapeHtml(recipientName), SUPPORT_EMAIL);
    }

    // Send notification to admin about new owner registration
    public static void sendAdminNotification(String adminEmail, String fullName, String userEmail, String businessName, String businessType) {
        Session session = getSmtpSession();
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Cat Ba Booking"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(adminEmail));
            message.setSubject("New Owner Registration Pending Approval - Cat Ba Booking");
            message.setContent(createAdminNotificationContent(fullName, userEmail, businessName, businessType), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Admin notification email sent to: " + adminEmail);
        } catch (Exception e) {
            System.err.println("❌ Failed to send admin notification email: " + e.getMessage());
        }
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
        """.formatted(escapeHtml(fullName), escapeHtml(userEmail), escapeHtml(businessName), escapeHtml(businessType), SUPPORT_EMAIL);
    }

    // Send approval confirmation email to approved owners
    public static void sendApprovalConfirmation(String toEmail, String recipientName, String businessName) {
        Session session = getSmtpSession();
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Cat Ba Booking"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Your Registration Has Been Approved - Cat Ba Booking");
            message.setContent(createApprovalContent(recipientName, businessName), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Approval confirmation email sent to: " + toEmail);
        } catch (Exception e) {
            System.err.println("❌ Failed to send approval confirmation email: " + e.getMessage());
        }
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
        """.formatted(escapeHtml(recipientName), escapeHtml(businessName), SUPPORT_EMAIL);
    }

    // Send rejection notification email to rejected owners
    public static void sendRejectionNotification(String toEmail, String recipientName, String businessName, String reason) {
        Session session = getSmtpSession();
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Cat Ba Booking"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Your Registration Has Been Rejected - Cat Ba Booking");
            message.setContent(createRejectionContent(recipientName, businessName, reason), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Rejection notification email sent to: " + toEmail);
        } catch (Exception e) {
            System.err.println("❌ Failed to send rejection notification email: " + e.getMessage());
        }
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
        """.formatted(escapeHtml(recipientName), escapeHtml(businessName), escapeHtml(reason), SUPPORT_EMAIL, SUPPORT_EMAIL);
    }
    // Send approval email to owner

    public static void sendApprovalEmail(String toEmail, String recipientName) {
        Session session = getSmtpSession();
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Cat Ba Booking"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Đăng Ký Owner Đã Được Duyệt!");
            message.setContent(createApprovalContent(recipientName), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Approval email sent to: " + toEmail);
        } catch (Exception e) {
            System.err.println("❌ Failed to send approval email: " + e.getMessage());
        }
    }

    private static String createApprovalContent(String recipientName) {
        return """
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng Ký Được Duyệt</title>
    </head>
    <body>
        <h2>Xin chào %s,</h2>
        <p>Đơn đăng ký owner của bạn đã được duyệt! Bạn có thể đăng nhập và quản lý cơ sở ngay.</p>
        <p>Trân trọng,<br>Cat Ba Booking</p>
    </body>
    </html>
    """.formatted(escapeHtml(recipientName));
    }

// Send rejection email to owner
    public static void sendRejectionEmail(String toEmail, String recipientName, String reason) {
        Session session = getSmtpSession();
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Cat Ba Booking"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Đăng Ký Owner Bị Từ Chối");
            message.setContent(createRejectionContent(recipientName, reason), "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Rejection email sent to: " + toEmail);
        } catch (Exception e) {
            System.err.println("❌ Failed to send rejection email: " + e.getMessage());
        }
    }

    private static String createRejectionContent(String recipientName, String reason) {
        return """
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng Ký Bị Từ Chối</title>
    </head>
    <body>
        <h2>Xin chào %s,</h2>
        <p>Đơn đăng ký owner của bạn bị từ chối vì: %s</p>
        <p>Bạn có thể đăng ký lại sau khi chỉnh sửa.</p>
        <p>Trân trọng,<br>Cat Ba Booking</p>
    </body>
    </html>
    """.formatted(escapeHtml(recipientName), escapeHtml(reason));
    }

    // Escape HTML characters to prevent XSS in email content
    private static String escapeHtml(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    // Test method for sending emails
    public static void main(String[] args) {
        System.out.println("=== Email Test ===");
//        sendRegistrationConfirmation("test@example.com", "Test User");
        System.out.println("=== Test Complete ===");
    }
}
