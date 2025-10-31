/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.DishDao;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Validator cho Dish (Món ăn).
 * Sử dụng Result object để trả về kết quả validate.
 * @author ADMIN (updated for update logic)
 */
public class DishValidator {
    
    /**
     * Kết quả validate: valid = true nếu OK, errors chứa list lỗi nếu fail.
     */
    public static class Result {
        public boolean valid;
        public List<String> errors;
        
        public Result(boolean valid) {
            this.valid = valid;
            this.errors = new ArrayList<>();
        }
        
        public Result(boolean valid, List<String> errors) {
            this.valid = valid;
            this.errors = errors != null ? errors : new ArrayList<>();
        }
        
        public void addError(String error) {
            if (error != null && !error.trim().isEmpty()) {
                errors.add(error.trim());
            }
        }
    }
    
    /**
     * Validate cho Add Dish: Tên không rỗng, không duplicate, description trim.
     * @param name Tên món
     * @param description Mô tả (optional)
     * @param businessId ID business
     * @param dishDao Để check duplicate
     * @return Result với valid và errors
     */
    public static Result validateAddDish(String name, String description, int businessId, DishDao dishDao) {
        Result result = new Result(true);
        
        // Check name
        if (name == null || name.trim().isEmpty()) {
            result.addError("Tên món ăn không được để trống.");
            result.valid = false;
            return result;
        }
        String trimmedName = name.trim();
        if (trimmedName.length() < 2 || trimmedName.length() > 100) {
            result.addError("Tên món ăn phải từ 2-100 ký tự.");
            result.valid = false;
            return result;
        }
        
        // Check duplicate name (KHÔNG loại trừ - cho add)
        if (dishDao.isDishNameExists(trimmedName, businessId)) {
            result.addError("Tên món ăn '" + trimmedName + "' đã tồn tại trong nhà hàng.");
            result.valid = false;
            return result;
        }
        
        // Check description (optional, nhưng trim)
        if (description != null && !description.trim().isEmpty()) {
            if (description.trim().length() > 500) {
                result.addError("Mô tả không được quá 500 ký tự.");
                result.valid = false;
                return result;
            }
        }
        
        // Debug log
        System.out.println("DEBUG Validate AddDish - Name OK: " + trimmedName + " for business " + businessId);
        
        return result;
    }
    
    /**
     * Validate cho Update Dish: Tương tự Add, NHƯNG duplicate check loại trừ chính món đang update.
     * @param dishId ID món đang update
     * @param name Tên món mới
     * @param description Mô tả mới
     * @param businessId ID business
     * @param dishDao Để check duplicate
     * @return Result với valid và errors
     */
    public static Result validateUpdateDish(int dishId, String name, String description, int businessId, DishDao dishDao) {
        Result result = new Result(true);
        
        // Check name (copy từ add)
        if (name == null || name.trim().isEmpty()) {
            result.addError("Tên món ăn không được để trống.");
            result.valid = false;
            return result;
        }
        String trimmedName = name.trim();
        if (trimmedName.length() < 2 || trimmedName.length() > 100) {
            result.addError("Tên món ăn phải từ 2-100 ký tự.");
            result.valid = false;
            return result;
        }
        
        // Check duplicate name (LOẠI TRỪ chính dishId - chỉ trùng với món khác mới lỗi)
        if (dishDao.isDishNameExistsForUpdate(trimmedName, businessId, dishId)) {
            result.addError("Tên món ăn '" + trimmedName + "' đã tồn tại (không thể dùng tên trùng với món khác).");
            result.valid = false;
            return result;
        }
        
        // Check description (copy từ add)
        if (description != null && !description.trim().isEmpty()) {
            if (description.trim().length() > 500) {
                result.addError("Mô tả không được quá 500 ký tự.");
                result.valid = false;
                return result;
            }
        }
        
        // Debug log
        System.out.println("DEBUG Validate UpdateDish - Name OK: " + trimmedName + " for dish " + dishId + " (excluded itself)");
        
        return result;
    }
    
    /**
     * Validate price riêng (có thể gọi từ controller).
     * @param priceStr String price từ form
     * @return Result (chỉ cho price)
     */
    public static Result validatePrice(String priceStr) {
        Result result = new Result(true);
        if (priceStr == null || priceStr.trim().isEmpty()) {
            result.addError("Giá tiền không được để trống.");
            result.valid = false;
            return result;
        }
        try {
            String cleanPrice = priceStr.trim().replace(",", "");  // Xử lý dấu phẩy VN
            BigDecimal price = new BigDecimal(cleanPrice);
            if (price.compareTo(BigDecimal.ZERO) <= 0) {
                result.addError("Giá tiền phải lớn hơn 0.");
                result.valid = false;
            }
            if (price.compareTo(new BigDecimal("10000000")) > 0) {  // Giới hạn max, tùy chỉnh
                result.addError("Giá tiền không được quá 10.000.000 đ.");
                result.valid = false;
            }
        } catch (NumberFormatException e) {
            result.addError("Giá tiền phải là số hợp lệ (ví dụ: 100000).");
            result.valid = false;
        }
        return result;
    }
}