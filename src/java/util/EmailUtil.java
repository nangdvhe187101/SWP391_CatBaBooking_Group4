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
