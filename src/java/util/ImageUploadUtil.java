package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Locale;
import java.util.UUID;

public class ImageUploadUtil {

    public static String upload(HttpServletRequest request, Part filePart, String subDir) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        // Lấy tên file gốc để tách đuôi
        String submitted = getSubmittedFileName(filePart);
        String ext = getSafeExtension(submitted); // trả về "" nếu không có
        String fileName = UUID.randomUUID().toString().replace("-", "") + ext;

        // Đường dẫn tuyệt đối tới /uploads trong webapp (Tomcat sẽ tự serve)
        String baseDir = request.getServletContext().getRealPath("/uploads");
        if (baseDir == null) {
            baseDir = "uploads";  // Fallback
        }

        // Làm sạch subDir (chỉ chữ, số, gạch ngang, gạch dưới). Tránh tên có dấu/khoảng trắng.
        String safeSubDir = sanitizeSubdir(subDir);
        Path dir = Paths.get(baseDir, safeSubDir);  // /uploads/dishes
        Files.createDirectories(dir);

        Files.createDirectories(dir);

        Path dest = dir.resolve(fileName);
        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, dest, StandardCopyOption.REPLACE_EXISTING);
        }

        String urlPrefix = request.getContextPath() + "/uploads";
        return safeSubDir.isEmpty()
                ? (urlPrefix + "/" + fileName)
                : (urlPrefix + "/" + safeSubDir + "/" + fileName);
    }

    public static String upload(HttpServletRequest request, Part filePart) throws IOException {
        return upload(request, filePart, null);
    }

    public static void deleteByUrl(HttpServletRequest request, String imageUrl) {
        if (imageUrl == null || imageUrl.isBlank()) {
            return;
        }

        String ctx = request.getContextPath();
        String relative = imageUrl.startsWith(ctx) ? imageUrl.substring(ctx.length()) : imageUrl;
        String baseDir = request.getServletContext().getRealPath("/"); // gốc webapp
        if (baseDir == null) {
            return;
        }
        // Ghép đường dẫn thực tế trên ổ đĩa
        Path filePath = Paths.get(baseDir, relative.replaceFirst("^/", ""));
        try {
            Files.deleteIfExists(filePath);
        } catch (IOException ignored) {
        }
    }

    private static String getSubmittedFileName(Part part) {
        try {
            String name = part.getSubmittedFileName();
            return name != null ? Paths.get(name).getFileName().toString() : null;
        } catch (NoSuchMethodError | Exception e) {
            // Fallback cho container cũ
            String cd = part.getHeader("content-disposition");
            if (cd == null) {
                return null;
            }
            for (String s : cd.split(";")) {
                s = s.trim();
                if (s.startsWith("filename=")) {
                    String fn = s.substring("filename=".length()).trim().replace("\"", "");
                    return Paths.get(fn).getFileName().toString();
                }
            }
            return null;
        }
    }

    private static String getSafeExtension(String filename) {
        if (filename == null) {
            return "";
        }
        int dot = filename.lastIndexOf('.');
        if (dot < 0 || dot == filename.length() - 1) {
            return "";
        }
        String raw = filename.substring(dot + 1).toLowerCase(Locale.ROOT);
        switch (raw) {
            case "jpg":
            case "jpeg":
            case "png":
            case "gif":
            case "webp":
                return "." + raw;
            default:
                return "";
        }
    }

    private static String sanitizeSubdir(String subDir) {
        if (subDir == null) {
            return "";
        }
        String s = subDir.replaceAll("[^a-zA-Z0-9_\\-/]", "");
        s = s.replaceAll("^/+", "").replaceAll("/+$", "");
        return s;
    }
}
