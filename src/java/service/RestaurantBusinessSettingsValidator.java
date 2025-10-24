/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class RestaurantBusinessSettingsValidator {

    public static class Result {

        public final boolean valid;
        public final List<String> errors;

        public Result(boolean valid, List<String> errors) {
            this.valid = valid;
            this.errors = errors;
        }
    }

    public static Result validate(String name, String address, String description, String image, String areaIdRaw) {
        List<String> errs = new ArrayList<>();

        if (name == null || name.trim().isEmpty()) {
            errs.add("Tên nhà hàng không được để trống.");
        } else if (name.length() > 255) {
            errs.add("Tên nhà hàng vượt quá 255 ký tự.");
        }

        if (address == null || address.trim().isEmpty()) {
            errs.add("Địa chỉ không được để trống.");
        } else if (address.length() > 255) {
            errs.add("Địa chỉ vượt quá 255 ký tự.");
        }

        if (description != null && description.length() > 2000) {
            errs.add("Mô tả quá dài (tối đa 2000 ký tự).");
        }

        if (image != null && !image.trim().isEmpty()) {
            String s = image.trim();
            boolean looksUrl = s.startsWith("http://") || s.startsWith("https://");
            if (!looksUrl) {
                errs.add("Ảnh đại diện phải là URL (http/https) hoặc để trống.");
            }
            if (s.length() > 500) {
                errs.add("URL ảnh vượt quá 500 ký tự.");
            }
        }

        if (areaIdRaw != null && !areaIdRaw.trim().isEmpty()) {
            try {
                int v = Integer.parseInt(areaIdRaw.trim());
                if (v <= 0) {
                    errs.add("Khu vực (area_id) phải là số nguyên dương.");
                }
            } catch (NumberFormatException e) {
                errs.add("Khu vực (area_id) không hợp lệ.");
            }
        }

        return new Result(errs.isEmpty(), errs);
    }
}
