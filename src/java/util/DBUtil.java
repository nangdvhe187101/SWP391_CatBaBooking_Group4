/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 *
 * @author ADMIN
 */
public class DBUtil {

    private static final Properties properties = new Properties();

    static {
        try {
            ClassLoader classLoader = DBUtil.class.getClassLoader();
            InputStream input = classLoader.getResourceAsStream("properties/DB.properties");
            if (input == null) {
                throw new RuntimeException("Xin lỗi, không tìm thấy file db.properties");
            }
            properties.load(input);
            Class.forName(properties.getProperty("db.driver"));
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi đọc file properties!");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Không tìm thấy JDBC Driver của MySQL!");
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                properties.getProperty("db.url"),
                properties.getProperty("db.username"),
                properties.getProperty("db.password")
        );
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        try (Connection conn = getConnection()) { 
            if (conn != null && !conn.isClosed()) {
                System.out.println("Kết nối MySQL thành công! ✅");
            } else {
                System.out.println("Không thể kết nối. ❌");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối: " + e.getMessage());
        }
    }
}
