/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import de.mkammerer.argon2.Argon2;
import de.mkammerer.argon2.Argon2Factory;
import java.util.Scanner;

/**
 *
 * @author ADMIN
 */
public class PassWordUtil {
    private static final Argon2 ARGON2_INSTANCE = Argon2Factory.create(Argon2Factory.Argon2Types.ARGON2id);

    private static final int ITERATIONS = 2;
    private static final int MEMORY_COST = 19456; // 19MB
    private static final int PARALLELISM = 1;

    public static String hashPassword(String password) {
        char[] passwordChars = password.toCharArray();
        try {
            return ARGON2_INSTANCE.hash(ITERATIONS, MEMORY_COST, PARALLELISM, passwordChars);
        } finally {
            ARGON2_INSTANCE.wipeArray(passwordChars);
        }
    }
    public static boolean verifyPassword(String hash, String password) {
        char[] passwordChars = password.toCharArray();
        try {
            return ARGON2_INSTANCE.verify(hash, passwordChars);
        } finally {
            ARGON2_INSTANCE.wipeArray(passwordChars);
        }
    }

    public static boolean isValidPassword(String password) {
        String passwordPattern = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\\-=\\[\\]{}|']).{8,64}$";
        return password != null && password.matches(passwordPattern);
    }

    public static void main(String[] args) {
        try (Scanner scanner = new Scanner(System.in)) {
            String passwordToHash;
            String hash;

            while (true) {
                System.out.print("⌨️ Vui lòng nhập mật khẩu để tạo hash: ");
                passwordToHash = scanner.nextLine();

                if (isValidPassword(passwordToHash)) {
                    System.out.println("✅ Mật khẩu hợp lệ. Đang tiến hành hash...");
                    break; // Thoát khỏi vòng lặp nếu mật khẩu hợp lệ
                } else {
                    System.out.println("❌ Mật khẩu không đủ mạnh! Yêu cầu: 8-64 ký tự, có chữ hoa, chữ thường, số, và ký tự đặc biệt.");
                    System.out.println("   Vui lòng thử lại.\n");
                }
            }

            hash = hashPassword(passwordToHash);
            System.out.println("\n✅ Hash đã được tạo thành công!");
            System.out.println("   🔐 Mật khẩu gốc   : " + passwordToHash);
            System.out.println("   🔑 Hash để lưu trữ : " + hash);
            System.out.println("----------------------------------------");

            System.out.println("Bây giờ, hãy xác thực mật khẩu bạn vừa tạo.");
            while (true) {
                System.out.print("⌨️ Vui lòng nhập lại mật khẩu để xác thực: ");
                String passwordToVerify = scanner.nextLine();
                if (verifyPassword(hash, passwordToVerify)) {
                    System.out.println("✅ Tuyệt vời! Xác thực thành công! Mật khẩu khớp.");
                    break; // Thoát khỏi vòng lặp khi xác thực đúng
                } else {
                    System.out.println("❌ Sai rồi! Mật khẩu không khớp. Vui lòng thử lại.");
                }
            }
            System.out.println("Chương trình kết thúc.");
        }
    }
}
