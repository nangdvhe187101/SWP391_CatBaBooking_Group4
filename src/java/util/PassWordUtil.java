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
}
