package controller.owner;

import dao.BusinessDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Businesses;
import model.Users;

@WebServlet(name = "EditProfileOwnerController", urlPatterns = {"/owner/profile"})
public class EditProfileOwnerController extends HttpServlet {

    private UserDAO userDAO;
    private BusinessDAO businessDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        businessDAO = new BusinessDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (!isOwner(currentUser)) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Users refreshedUser = userDAO.getUserById(currentUser.getUserId());
        Businesses business = businessDAO.getBusinessByOwnerId(currentUser.getUserId());

        request.setAttribute("user", refreshedUser);
        request.setAttribute("business", business);
        String tab = request.getParameter("tab");
        if (tab == null || tab.isBlank()) {
            tab = "account";
        }
        request.setAttribute("activeTab", tab);
        request.getRequestDispatcher("/OwnerPage/EditProfileOwner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = session != null ? (Users) session.getAttribute("currentUser") : null;
        if (!isOwner(currentUser)) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String citizenId = request.getParameter("citizenId");
        String personalAddress = request.getParameter("personalAddress");
        String city = request.getParameter("city");

        Integer birthDay = parseIntOrNull(request.getParameter("birthDay"));
        Integer birthMonth = parseIntOrNull(request.getParameter("birthMonth"));
        Integer birthYear = parseIntOrNull(request.getParameter("birthYear"));
        String gender = request.getParameter("gender");

        String businessName = request.getParameter("businessName");
        String businessType = request.getParameter("businessType");
        String businessAddress = request.getParameter("businessAddress");
        String businessDescription = request.getParameter("businessDescription");
        String businessImage = request.getParameter("businessImage");

        try {
            String validationResult = userDAO.processUserProfileUpdate(
                    currentUser.getUserId(),
                    fullName,
                    email,
                    phone,
                    citizenId,
                    gender,
                    birthDay,
                    birthMonth,
                    birthYear,
                    city,
                    personalAddress,
                    currentUser.getEmail()
            );

            if (validationResult != null) {
                request.setAttribute("profileError", validationResult);
            } else {
                boolean businessUpdated = businessDAO.updateOwnerBusinessProfile(
                        currentUser.getUserId(),
                        businessName,
                        businessType,
                        businessAddress,
                        businessDescription,
                        businessImage
                );

                Users updatedUser = userDAO.getUserById(currentUser.getUserId());
                session.setAttribute("currentUser", updatedUser);

                if (!businessUpdated) {
                    request.setAttribute("profileWarning", "Thông tin cá nhân đã lưu nhưng chưa cập nhật được thông tin cơ sở.");
                } else {
                    request.setAttribute("profileSuccess", "Cập nhật thông tin thành công.");
                }
            }
        } catch (Exception e) {
            request.setAttribute("profileError", "Không thể cập nhật thông tin. Vui lòng thử lại sau.");
        }

        Users refreshedUser = userDAO.getUserById(currentUser.getUserId());
        Businesses business = businessDAO.getBusinessByOwnerId(currentUser.getUserId());
        request.setAttribute("user", refreshedUser);
        request.setAttribute("business", business);
        request.setAttribute("activeTab", "account");
        request.getRequestDispatcher("/OwnerPage/EditProfileOwner.jsp").forward(request, response);
    }

    private boolean isOwner(Users user) {
        if (user == null || user.getRole() == null) {
            return false;
        }
        int roleId = user.getRole().getRoleId();
        return roleId == 2 || roleId == 4;
    }

    private Integer parseIntOrNull(String value) {
        try {
            return (value != null && !value.isBlank()) ? Integer.parseInt(value) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}

