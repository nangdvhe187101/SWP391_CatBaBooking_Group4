/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.RestaurantTableDAO;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */

public class RestaurantTableValidator {

    public static class ValidationResult {  
        public boolean valid;
        public List<String> errors;

        public ValidationResult(boolean valid, List<String> errors) {
            this.valid = valid;
            this.errors = (errors != null) ? errors : new ArrayList<>();  
        }
    }

    public static ValidationResult validate(String name, String capacityStr, String isActiveStr, int businessId, Integer excludeTableId) {
        List<String> errors = new ArrayList<>();
        if (name == null || name.trim().isEmpty()) {
            errors.add("Tên bàn không được để trống.");
        } else if (name.trim().length() < 2 || name.trim().length() > 50) {
            errors.add("Tên bàn phải từ 2-50 ký tự.");
        } else {
            RestaurantTableDAO dao = new RestaurantTableDAO();
            if (dao.isNameExists(name, businessId, excludeTableId)) {
                errors.add("Tên bàn đã tồn tại");
            }
        }
        // Check capacity
        if (capacityStr == null || capacityStr.trim().isEmpty()) {
            errors.add("Sức chứa không được để trống.");
        } else {
            try {
                int capacity = Integer.parseInt(capacityStr.trim());
                if (capacity < 1 || capacity > 20) {  
                    errors.add("Sức chứa mỗi bàn từ 1-20 người.");
                }
            } catch (NumberFormatException e) {
                errors.add("Sức chứa phải là số hợp lệ.");
            }
        }
        return new ValidationResult(errors.isEmpty(), errors);
    }
}