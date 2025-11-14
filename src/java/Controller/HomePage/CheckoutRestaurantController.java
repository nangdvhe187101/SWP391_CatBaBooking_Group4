package controller.HomePage;

import com.google.gson.Gson;
import dao.BookingDAO;
import dao.DishDao;
import dao.RestaurantDAO;
import dao.RestaurantTableDAO;
import dao.UserDAO;
import model.Bookings;
import model.Businesses;
import model.BookingDishes;
import model.Users;
import model.dto.BusinessesDTO;
import model.dto.CartItemDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import model.DishCategories;
import model.Dishes;
import model.RestaurantTables;
import service.CheckRestaurantValidate;
import service.CheckRestaurantValidate.ValidationResult;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "CheckoutRestaurantController", urlPatterns = {"/checkout-restaurant"})
public class CheckoutRestaurantController extends HttpServlet {

    private BookingDAO bookingDAO;
    private UserDAO userDAO;
    private RestaurantDAO restaurantDAO;
    private DishDao dishDao;
    private RestaurantTableDAO tableDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        userDAO = new UserDAO();
        restaurantDAO = new RestaurantDAO();
        dishDao = new DishDao();
        tableDAO = new RestaurantTableDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        // Lấy restaurantId từ session hoặc parameter
        String resIdParam = request.getParameter("restaurantId");
        Integer sessionRestaurantId = (Integer) session.getAttribute("restaurantId");

        int restaurantId;
        if (resIdParam != null && !resIdParam.trim().isEmpty()) {
            try {
                restaurantId = Integer.parseInt(resIdParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/restaurant");
                return;
            }
        } else if (sessionRestaurantId != null) {
            restaurantId = sessionRestaurantId;
        } else {
            response.sendRedirect(request.getContextPath() + "/restaurant");
            return;
        }

        // Load restaurant
        BusinessesDTO restaurant = restaurantDAO.getRestaurantById(restaurantId);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/restaurant");
            return;
        }

        // Load categories và dishes cho restaurant
        List<DishCategories> categories = restaurantDAO.getCategoriesByBusinessId(restaurantId);
        List<Dishes> dishes = dishDao.getAllDishesByBusinessId(restaurantId);

        // Load cart từ session
        List<CartItemDTO> orderItems = (List<CartItemDTO>) session.getAttribute("orderItems");
        if (orderItems == null || orderItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/restaurant-detail?id=" + restaurantId + "&error=empty_cart");
            return;
        }

        // Tính tổng tiền
        BigDecimal totalPrice = calculateTotal(orderItems, dishes);

        // Check available table (preview)
        String dateParam = request.getParameter("date");
        String timeParam = request.getParameter("time");
        String guestsParam = request.getParameter("guests");
        List<RestaurantTables> availableTables = new ArrayList<>();
        if (dateParam != null && timeParam != null && guestsParam != null) {
            try {
                LocalDate date = LocalDate.parse(dateParam);
                LocalTime time = LocalTime.parse(timeParam);
                int numGuests = Integer.parseInt(guestsParam);
                RestaurantTables optTable = tableDAO.findSuitableTableForPreview(restaurantId, numGuests, date, time);
                if (optTable != null) {
                    availableTables.add(optTable);
                }
            } catch (Exception e) {
                // Ignore
            }
        }

        // Set current date for date input min attribute
        LocalDate currentDate = LocalDate.now();
        request.setAttribute("currentDate", currentDate.toString());

        // Set attributes
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("restaurantId", restaurantId);
        request.setAttribute("categories", categories);
        request.setAttribute("dishes", dishes);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("availableTables", availableTables);
        request.setAttribute("currentUser", currentUser);

        request.getRequestDispatcher("/HomePage/CheckoutRestaurant.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        // Lấy restaurantId từ session hoặc parameter
        Integer sessionRestaurantId = (Integer) session.getAttribute("restaurantId");
        String restaurantIdStr = request.getParameter("restaurantId");

        int restaurantId;
        if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
            try {
                restaurantId = Integer.parseInt(restaurantIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Mã nhà hàng không hợp lệ");
                doGet(request, response);
                return;
            }
        } else if (sessionRestaurantId != null) {
            restaurantId = sessionRestaurantId;
        } else {
            request.setAttribute("errorMessage", "Thiếu thông tin nhà hàng");
            response.sendRedirect(request.getContextPath() + "/restaurant");
            return;
        }

        String reservationDateStr = request.getParameter("reservationDate");
        String reservationTimeStr = request.getParameter("reservationTime");
        String numGuestsStr = request.getParameter("numGuests");

        if (reservationDateStr == null || reservationTimeStr == null || numGuestsStr == null) {
            request.setAttribute("errorMessage", "Thiếu thông tin bắt buộc (ngày/giờ/số khách)");
            doGet(request, response);
            return;
        }

        int numGuests;
        try {
            numGuests = Integer.parseInt(numGuestsStr);
            if (numGuests < 1) {
                numGuests = 1;
            }
        } catch (NumberFormatException e) {
            numGuests = 1;
        }

        LocalDateTime reservationDateTime;
        try {
            LocalDate date = LocalDate.parse(reservationDateStr);
            LocalTime time = LocalTime.parse(reservationTimeStr);
            reservationDateTime = LocalDateTime.of(date, time);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Ngày giờ không hợp lệ");
            doGet(request, response);
            return;
        }

        // Lấy cart từ session
        List<CartItemDTO> cartItems = (List<CartItemDTO>) session.getAttribute("orderItems");
        if (cartItems == null || cartItems.isEmpty()) {
            request.setAttribute("errorMessage", "Giỏ hàng trống. Vui lòng thêm món ăn.");
            doGet(request, response);
            return;
        }

        BusinessesDTO restaurantDTO = restaurantDAO.getRestaurantById(restaurantId);
        if (restaurantDTO == null) {
            request.setAttribute("errorMessage", "Không tìm thấy nhà hàng");
            response.sendRedirect(request.getContextPath() + "/restaurant");
            return;
        }
        Businesses restaurant = restaurantDAO.dtoToBusiness(restaurantDTO);

        String bookerName = request.getParameter("bookerName");
        String bookerPhone = request.getParameter("bookerPhone");
        String bookerEmail = request.getParameter("bookerEmail");

        // Giữ lại thông tin form để hiển thị lại khi lỗi
        request.setAttribute("bookerName", bookerName);
        request.setAttribute("bookerPhone", bookerPhone);
        request.setAttribute("bookerEmail", bookerEmail);
        request.setAttribute("reservationDate", reservationDateStr);
        request.setAttribute("reservationTime", reservationTimeStr);
        request.setAttribute("numGuests", numGuests);

        ValidationResult customerValid = CheckRestaurantValidate.validateCustomerInfo(bookerName, bookerPhone, bookerEmail);
        if (!customerValid.isValid()) {
            request.setAttribute("errorMessage", "Thông tin khách hàng không hợp lệ: " + customerValid.getMessage());
            doGet(request, response);
            return;
        }

        ValidationResult resValid = CheckRestaurantValidate.validateReservation(
                reservationDateTime.toLocalDate(),
                reservationDateTime.toLocalTime(),
                numGuests,
                restaurantId);
        if (!resValid.isValid()) {
            request.setAttribute("errorMessage", "Thông tin đặt bàn không hợp lệ: " + resValid.getMessage());
            doGet(request, response);
            return;
        }

        RestaurantTables assignedTable = tableDAO.findSuitableTableForPreview(
                restaurantId,
                numGuests,
                reservationDateTime.toLocalDate(),
                reservationDateTime.toLocalTime());
        if (assignedTable == null) {
            request.setAttribute("errorMessage", "Không có bàn phù hợp cho " + numGuests + " khách vào thời gian này. Vui lòng chọn thời gian khác.");
            doGet(request, response);
            return;
        }

        List<Dishes> dishes = dishDao.getAllDishesByBusinessId(restaurantId);
        BigDecimal totalPrice = BigDecimal.ZERO;
        List<BookingDishes> bookingDishes = new ArrayList<>();

        for (CartItemDTO item : cartItems) {
            Dishes dish = null;
            for (Dishes d : dishes) {
                if (d.getDishId() == item.getDishId()) {
                    dish = d;
                    break;
                }
            }

            if (dish != null && dish.isIsAvailable()) {
                BigDecimal subtotal = dish.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
                totalPrice = totalPrice.add(subtotal);

                BookingDishes bd = new BookingDishes();
                bd.setDish(dish);
                bd.setQuantity(item.getQuantity());
                bd.setPriceAtBooking(dish.getPrice());
                bd.setNotes(item.getNotes());
                bookingDishes.add(bd);
            }
        }

        if (totalPrice.compareTo(BigDecimal.ZERO) <= 0) {
            request.setAttribute("errorMessage", "Số tiền không hợp lệ");
            doGet(request, response);
            return;
        }

        ValidationResult paymentValid = CheckRestaurantValidate.validatePaymentAmount(totalPrice);
        if (!paymentValid.isValid()) {
            request.setAttribute("errorMessage", "Số tiền không hợp lệ: " + paymentValid.getMessage());
            doGet(request, response);
            return;
        }

        Bookings booking = new Bookings(currentUser, restaurant, bookerName, bookerEmail, bookerPhone,
                numGuests, totalPrice, reservationDateTime, reservationDateTime, "");
        int bookingId;
        try {
            bookingId = bookingDAO.createBooking(booking, bookingDishes);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tạo đặt bàn: " + e.getMessage());
            doGet(request, response);
            return;
        }

        if (bookingId <= 0) {
            request.setAttribute("errorMessage", "Không thể tạo đặt bàn. Vui lòng thử lại.");
            doGet(request, response);
            return;
        }

        // Assign table to booking
        try {
            int bookedTableId = tableDAO.assignTableToBooking(bookingId, restaurantId, numGuests,
                    reservationDateTime.toLocalDate(),
                    reservationDateTime.toLocalTime());
            if (bookedTableId <= 0) {
                request.setAttribute("errorMessage", "Không thể gán bàn. Vui lòng liên hệ nhà hàng.");
                // Không return ở đây vì đã tạo booking thành công
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi gán bàn: " + e.getMessage());
            // Có thể tiếp tục vì booking đã tạo
        }

        // Xóa giỏ hàng và restaurantId từ session
        session.removeAttribute("orderItems");
        session.removeAttribute("restaurantId");
        String confirmUrl = request.getContextPath() + "/confirmation-payment?bookingCode=" + booking.getBookingCode();
        response.sendRedirect(confirmUrl);
    }

    private BigDecimal calculateTotal(List<CartItemDTO> items, List<Dishes> dishes) {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItemDTO item : items) {
            Dishes matchingDish = null;
            for (Dishes dish : dishes) {
                if (dish.getDishId() == item.getDishId()) {
                    matchingDish = dish;
                    break;
                }
            }
            if (matchingDish != null) {
                BigDecimal subtotal = matchingDish.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
                total = total.add(subtotal);
            }
        }
        return total.setScale(0, RoundingMode.DOWN);
    }
}
