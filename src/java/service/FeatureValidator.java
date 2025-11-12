/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 *
 * @author ADMIN
 */
public class FeatureValidator {
    private static final Pattern URL_PATTERN = Pattern.compile("^/[a-zA-Z0-9/_-]*$");
    private static final int MAX_FEATURE_NAME_LENGTH = 100;
    private static final int MAX_URL_LENGTH = 255;

    /**
     * Validate feature name
     */
    public static List<String> validateFeatureName(String featureName) {
        List<String> errors = new ArrayList<>();
        
        if (featureName == null || featureName.trim().isEmpty()) {
            errors.add("Tên chức năng không được để trống");
            return errors;
        }
        
        featureName = featureName.trim();
        
        if (featureName.length() > MAX_FEATURE_NAME_LENGTH) {
            errors.add("Tên chức năng không được vượt quá " + MAX_FEATURE_NAME_LENGTH + " ký tự");
        }
        
        if (featureName.length() < 3) {
            errors.add("Tên chức năng phải có ít nhất 3 ký tự");
        }
        
        return errors;
    }

    /**
     * Validate URL
     */
    public static List<String> validateUrl(String url) {
        List<String> errors = new ArrayList<>();
        
        if (url == null || url.trim().isEmpty()) {
            errors.add("Đường dẫn URL không được để trống");
            return errors;
        }
        
        url = url.trim();
        
        if (!url.startsWith("/")) {
            errors.add("Đường dẫn URL phải bắt đầu bằng dấu /");
        }
        
        if (url.length() > MAX_URL_LENGTH) {
            errors.add("Đường dẫn URL không được vượt quá " + MAX_URL_LENGTH + " ký tự");
        }
        
        if (!URL_PATTERN.matcher(url).matches()) {
            errors.add("Đường dẫn URL chỉ được chứa chữ cái, số, dấu gạch ngang, gạch dưới và dấu /");
        }
        
        // Kiểm tra các ký tự đặc biệt không hợp lệ
        if (url.contains("//") || url.contains(" ")) {
            errors.add("Đường dẫn URL không được chứa // hoặc khoảng trắng");
        }
        
        return errors;
    }

    /**
     * Validate required business type
     */
    public static List<String> validateBusinessType(String businessType) {
        List<String> errors = new ArrayList<>();
        
        if (businessType == null || businessType.trim().isEmpty()) {
            errors.add("Loại doanh nghiệp không được để trống");
            return errors;
        }
        
        businessType = businessType.trim().toLowerCase();
        
        if (!businessType.equals("homestay") && 
            !businessType.equals("restaurant") && 
            !businessType.equals("both")) {
            errors.add("Loại doanh nghiệp không hợp lệ. Chỉ chấp nhận: homestay, restaurant, both");
        }
        
        return errors;
    }

    /**
     * Validate toàn bộ feature
     */
    public static List<String> validateFeature(String featureName, String url, String businessType) {
        List<String> errors = new ArrayList<>();
        
        errors.addAll(validateFeatureName(featureName));
        errors.addAll(validateUrl(url));
        errors.addAll(validateBusinessType(businessType));
        
        return errors;
    }

    /**
     * Validate permission IDs
     */
    public static List<String> validatePermissions(String[] permissionIds) {
        List<String> errors = new ArrayList<>();
        
        if (permissionIds == null || permissionIds.length == 0) {
            // Có thể không có permission nào được chọn, không coi là lỗi
            return errors;
        }
        
        for (String id : permissionIds) {
            try {
                int permId = Integer.parseInt(id);
                if (permId <= 0) {
                    errors.add("ID phân quyền không hợp lệ: " + id);
                }
            } catch (NumberFormatException e) {
                errors.add("ID phân quyền không hợp lệ: " + id);
            }
        }
        
        return errors;
    }

    /**
     * Sanitize input
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        return input.trim()
                   .replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#x27;");
    }

    /**
     * Validate feature ID
     */
    public static boolean isValidFeatureId(String featureId) {
        if (featureId == null || featureId.trim().isEmpty()) {
            return false;
        }
        
        try {
            int id = Integer.parseInt(featureId.trim());
            return id > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Validate role ID
     */
    public static boolean isValidRoleId(String roleId) {
        if (roleId == null || roleId.trim().isEmpty()) {
            return false;
        }
        
        try {
            int id = Integer.parseInt(roleId.trim());
            return id > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
