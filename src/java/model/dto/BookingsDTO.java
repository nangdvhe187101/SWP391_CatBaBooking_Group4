package model.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class BookingsDTO {
    private String bookingCode;
    private String bookerName;
    private String bookerEmail;
    private String bookerPhone;
    private int numGuests;
    private BigDecimal totalPrice;
    private String paymentStatus;
    private LocalDate reservationDate;
    private LocalTime reservationTime;
    private String tableName;
    private List<BookedDishDTO> bookedDishes; // Thêm danh sách món đặt trước

    public BookingsDTO() {
        this.bookedDishes = new ArrayList<>();
    }

    public BookingsDTO(String bookingCode, String bookerName, String bookerEmail, String bookerPhone, 
                      int numGuests, BigDecimal totalPrice, String paymentStatus, 
                      LocalDate reservationDate, LocalTime reservationTime, String tableName) {
        this.bookingCode = bookingCode;
        this.bookerName = bookerName;
        this.bookerEmail = bookerEmail;
        this.bookerPhone = bookerPhone;
        this.numGuests = numGuests;
        this.totalPrice = totalPrice;
        this.paymentStatus = paymentStatus;
        this.reservationDate = reservationDate;
        this.reservationTime = reservationTime;
        this.tableName = tableName;
        this.bookedDishes = new ArrayList<>();
    }

    // Getters và Setters hiện tại...
    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public String getBookerName() {
        return bookerName;
    }

    public void setBookerName(String bookerName) {
        this.bookerName = bookerName;
    }

    public String getBookerEmail() {
        return bookerEmail;
    }

    public void setBookerEmail(String bookerEmail) {
        this.bookerEmail = bookerEmail;
    }

    public String getBookerPhone() {
        return bookerPhone;
    }

    public void setBookerPhone(String bookerPhone) {
        this.bookerPhone = bookerPhone;
    }

    public int getNumGuests() {
        return numGuests;
    }

    public void setNumGuests(int numGuests) {
        this.numGuests = numGuests;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public LocalDate getReservationDate() {
        return reservationDate;
    }

    public void setReservationDate(LocalDate reservationDate) {
        this.reservationDate = reservationDate;
    }

    public LocalTime getReservationTime() {
        return reservationTime;
    }

    public void setReservationTime(LocalTime reservationTime) {
        this.reservationTime = reservationTime;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    // Getter và Setter mới cho bookedDishes
    public List<BookedDishDTO> getBookedDishes() {
        return bookedDishes;
    }

    public void setBookedDishes(List<BookedDishDTO> bookedDishes) {
        this.bookedDishes = bookedDishes;
    }

    public void addBookedDish(BookedDishDTO dish) {
        this.bookedDishes.add(dish);
    }
}