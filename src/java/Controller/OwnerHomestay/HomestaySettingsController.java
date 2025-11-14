/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.OwnerHomestay;

import dao.AreaDAO;
import dao.BusinessDAO;
import dao.HomestayDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.List;
import model.Areas;
import model.Businesses;
import model.Users;

/**
 *
 * @author jackd
 */
@WebServlet(name = "HomestaySettingsController", urlPatterns = {"/homestay-settings"})
public class HomestaySettingsController extends HttpServlet {

    private BusinessDAO businessDAO;
    private HomestayDAO homestayDAO;
    private AreaDAO areaDAO;

    @Override
    public void init() throws ServletException {
        businessDAO = new BusinessDAO();
        homestayDAO = new HomestayDAO();
        areaDAO = new AreaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getRole().getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        // 1. Lấy thông tin cơ bản để có BusinessID
        Businesses basicInfo = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        if (basicInfo == null || !"homestay".equals(basicInfo.getType())) {
            request.setAttribute("error", "Không tìm thấy thông tin Homestay.");
            request.getRequestDispatcher("/OwnerPage/Dashboard.jsp").forward(request, response);
            return;
        }

        // 2. [FIX QUAN TRỌNG] Dùng HomestayDAO để lấy ĐẦY ĐỦ thông tin (bao gồm Giá)
        // BusinessDAO thường thiếu các trường chi tiết của Homestay
        Businesses homestay = homestayDAO.getHomestayById(basicInfo.getBusinessId());

        // Fallback: Nếu homestayDAO null (hiếm), dùng tạm basicInfo
        if (homestay == null) {
            homestay = basicInfo;
        }

        // 3. Xử lý giá hiển thị (cho trường hợp load lần đầu)
        // Chuyển thành chuỗi số nguyên (bỏ .00) để form hiển thị đẹp
        String displayPrice = "";
        if (homestay.getPricePerNight() != null) {
            displayPrice = String.valueOf(homestay.getPricePerNight().longValue());
        }
        request.setAttribute("displayPrice", displayPrice);

        // 4. Load danh sách khu vực
        List<Areas> areas = areaDAO.getAllAreas();

        request.setAttribute("business", homestay);
        request.setAttribute("allAreas", areas);

        request.getRequestDispatcher("/OwnerPage/ManageHomestaySettings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        try {
            // Lấy lại object cũ để giữ ID
            Businesses basicInfo = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
            if (basicInfo == null || !"homestay".equals(basicInfo.getType())) {
                request.setAttribute("error", "Không tìm thấy thông tin Homestay.");
                doGet(request, response); // Redirect to doGet for reload
                return;
            }

            // Cũng nên lấy full info để update đè lên
            Businesses homestay = homestayDAO.getHomestayById(basicInfo.getBusinessId());

            // [NEW] Fallback: If homestayDAO returns null, use basicInfo (as in doGet)
            if (homestay == null) {
                System.err.println("Warning: homestayDAO.getHomestayById returned null for businessId=" + basicInfo.getBusinessId() + ". Falling back to basicInfo.");
                homestay = basicInfo;
            }

            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String description = request.getParameter("description");
            String image = request.getParameter("image");

            // [NEW] Validation for required fields
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Tên Homestay là bắt buộc.");
                doGet(request, response);
                return;
            }
            if (address == null || address.trim().isEmpty()) {
                request.setAttribute("error", "Địa chỉ là bắt buộc.");
                doGet(request, response);
                return;
            }

            String areaIdStr = request.getParameter("areaId");
            int areaId;
            if (areaIdStr == null || areaIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn khu vực.");
                doGet(request, response);
                return;
            } else {
                try {
                    areaId = Integer.parseInt(areaIdStr.trim());
                    if (areaId <= 0) {
                        request.setAttribute("error", "Khu vực không hợp lệ.");
                        doGet(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Khu vực không hợp lệ.");
                    doGet(request, response);
                    return;
                }
            }

            // [FIX] Xử lý giá nhập vào: Chỉ lấy số (Loại bỏ dấu chấm, phẩy)
            String priceStr = request.getParameter("pricePerNight");
            BigDecimal pricePerNight = BigDecimal.ZERO;
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                String cleanPrice = priceStr.trim().replaceAll("[^0-9]", ""); // 500.000 -> 500000
                if (!cleanPrice.isEmpty()) {
                    pricePerNight = new BigDecimal(cleanPrice);
                    if (pricePerNight.compareTo(BigDecimal.ZERO) <= 0) {
                        request.setAttribute("error", "Giá phải lớn hơn 0.");
                        doGet(request, response);
                        return;
                    }
                }
            } else {
                request.setAttribute("error", "Giá phòng là bắt buộc.");
                doGet(request, response);
                return;
            }

            String checkInStr = request.getParameter("openingHour");
            String checkOutStr = request.getParameter("closingHour");

            LocalTime checkInTime = null;
            if (checkInStr != null && !checkInStr.trim().isEmpty()) {
                try {
                    checkInTime = LocalTime.parse(checkInStr.trim());
                } catch (Exception e) {
                    request.setAttribute("error", "Giờ check-in không hợp lệ.");
                    doGet(request, response);
                    return;
                }
            }

            LocalTime checkOutTime = null;
            if (checkOutStr != null && !checkOutStr.trim().isEmpty()) {
                try {
                    checkOutTime = LocalTime.parse(checkOutStr.trim());
                } catch (Exception e) {
                    request.setAttribute("error", "Giờ check-out không hợp lệ.");
                    doGet(request, response);
                    return;
                }
            }

            // Optional: Validate checkOut > checkIn
            if (checkInTime != null && checkOutTime != null && checkOutTime.isBefore(checkInTime)) {
                request.setAttribute("error", "Giờ check-out phải sau giờ check-in.");
                doGet(request, response);
                return;
            }

            // Cập nhật object (now safe: homestay is guaranteed non-null)
            homestay.setName(name.trim());
            homestay.setAddress(address.trim());
            homestay.setDescription(description != null ? description.trim() : "");
            homestay.setImage(image != null ? image.trim() : "");

            Areas area = new Areas();
            area.setAreaId(areaId);
            homestay.setArea(area);

            homestay.setPricePerNight(pricePerNight);
            homestay.setOpeningHour(checkInTime);
            homestay.setClosingHour(checkOutTime);

            // Gọi DAO update
            if (homestayDAO.updateHomestay(homestay)) {
                request.setAttribute("message", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("error", "Cập nhật thất bại. Vui lòng thử lại.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        // Load lại trang (sẽ gọi doGet để lấy dữ liệu mới nhất từ DB)
        doGet(request, response);
    }
}
