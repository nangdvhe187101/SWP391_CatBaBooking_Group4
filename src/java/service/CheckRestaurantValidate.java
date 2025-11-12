/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.math.BigDecimal;
import dao.RestaurantDAO;  // NEW: Import để load restaurant
import model.BookingDishes;
import model.dto.BusinessesDTO;  // NEW: Import cho BusinessesDTO

/**
 *
 * @author ADMIN
 */
public class CheckRestaurantValidate {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
    private static final Gson gson = new Gson();
    private static final RestaurantDAO restaurantDAO = new RestaurantDAO();  // NEW: Instance để query restaurant
    private static final int MAX_GUESTS = 20;  // Giới hạn số khách

    /**
     * Validate info khách hàng.
     */
    public static ValidationResult validateCustomerInfo(String name, String phone, String email) {
        List<String> errors = new ArrayList<>();
        if (name == null || name.trim().length() < 2 || name.trim().length() > 100) {
            errors.add("Tên phải từ 2-100 ký tự.");
        }
        if (phone == null || !phone.matches("\\d{10,11}")) {
            errors.add("Số điện thoại phải là 10-11 chữ số.");
        }
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$")) {
            errors.add("Email không hợp lệ.");
        }
        // Thống nhất: hasErrors = true nếu có lỗi (invalid)
        return new ValidationResult(!errors.isEmpty(), errors);
    }

    /**
     * Validate đặt bàn (ngày, giờ, số khách) - cho String input từ form.
     */
    public static ValidationResult validateReservation(String dateStr, String timeStr, int numGuests) {
        List<String> errors = new ArrayList<>();
        try {
            LocalDate date = LocalDate.parse(dateStr, DATE_FORMATTER);
            if (date.isBefore(LocalDate.now())) {
                errors.add("Ngày đặt bàn phải từ hôm nay trở đi.");
            }
        } catch (DateTimeParseException e) {
            errors.add("Định dạng ngày không hợp lệ (yyyy-MM-dd).");
        }
        try {
            LocalTime.parse(timeStr, TIME_FORMATTER);
        } catch (DateTimeParseException e) {
            errors.add("Định dạng giờ không hợp lệ (HH:mm).");
        }
        if (numGuests < 1 || numGuests > MAX_GUESTS) {  // FIX: <1 thay vì <=0
            errors.add("Số khách phải từ 1-" + MAX_GUESTS + " người.");
        }
        // Thống nhất: hasErrors = true nếu có lỗi
        return new ValidationResult(!errors.isEmpty(), errors);
    }

    /**
     * Validate đặt bàn (ngày, giờ, số khách) - cho LocalDate/LocalTime (nội
     * bộ). NEW: Thêm overload không có restaurantId (gọi method đầy đủ với -1).
     */
    public static ValidationResult validateReservation(LocalDate date, LocalTime time, int numGuests) {
        return validateReservation(date, time, numGuests, -1);  // Delegate sang method đầy đủ
    }

    /**
     * NEW: Validate đầy đủ với restaurantId - để fix lỗi compile. Kiểm tra
     * thêm: restaurant tồn tại, giờ trong opening/closing hours.
     */
    public static ValidationResult validateReservation(LocalDate date, LocalTime time, int numGuests, int restaurantId) {
        List<String> errors = new ArrayList<>();

        // Basic checks (ngày tương lai, số khách)
        if (date.isBefore(LocalDate.now())) {
            errors.add("Ngày đặt phải trong tương lai.");
        }
        if (numGuests < 1 || numGuests > MAX_GUESTS) {
            errors.add("Số khách từ 1 đến " + MAX_GUESTS + " người.");
        }

        // Nếu có restaurantId, check thêm hours và existence
        if (restaurantId > 0) {
            try {
                BusinessesDTO restaurant = restaurantDAO.getRestaurantById(restaurantId);
                if (restaurant == null) {
                    errors.add("Không tìm thấy nhà hàng.");
                    return new ValidationResult(!errors.isEmpty(), errors);
                }

                LocalTime opening = restaurant.getOpeningHour();
                LocalTime closing = restaurant.getClosingHour();
                if (opening != null && closing != null) {
                    if (time.isBefore(opening) || time.isAfter(closing)) {
                        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("HH:mm");
                        errors.add(String.format("Giờ đặt bàn (%s) phải trong khoảng %s - %s.",
                                time.format(fmt), opening.format(fmt), closing.format(fmt)));
                    }
                }
                // Có thể thêm check ngày nghỉ (ví dụ: nếu có field days_off trong BusinessesDTO)
            } catch (Exception e) {
                errors.add("Lỗi kiểm tra thông tin nhà hàng: " + e.getMessage());
            }
        }

        // Thống nhất: hasErrors = true nếu có lỗi
        return new ValidationResult(!errors.isEmpty(), errors);
    }

    public static ValidationResult validatePaymentAmount(BigDecimal amount) { 
        List<String> errors = new ArrayList<>();
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            errors.add("Số tiền thanh toán phải lớn hơn 0.");
        }
        if (amount.compareTo(new BigDecimal("5000000")) > 0) {
            errors.add("Số tiền thanh toán không vượt quá 5 triệu VND.");
        }
        if (amount.scale() > 2) {
            errors.add("Số tiền phải là số nguyên.");
        }
        return new ValidationResult(!errors.isEmpty(), errors);
    }

    // Inner class result - FIX: Thêm isValid() để khớp controller (!hasErrors)
    public static class ValidationResult {

        private boolean hasErrors;  // true nếu invalid
        private List<String> errors;

        public ValidationResult(boolean hasErrors, List<String> errors) {
            this.hasErrors = hasErrors;
            this.errors = errors != null ? errors : new ArrayList<>();
        }

        public boolean hasErrors() {
            return hasErrors;
        }

        // NEW: Thêm isValid() để controller dùng (!hasErrors)
        public boolean isValid() {
            return !hasErrors;
        }

        // FIX: Thêm getMessage() nếu controller dùng (join errors)
        public String getMessage() {
            return errors.isEmpty() ? null : String.join(" ", errors);
        }

        public List<String> getErrors() {
            return errors;
        }
    }
}
