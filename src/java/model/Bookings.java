package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class Bookings {

    private int bookingId;
    private String bookingCode;
    private Users user;
    private Businesses business;
    private String bookerName;
    private String bookerEmail;
    private String bookerPhone;
    private int numGuests;
    private BigDecimal totalPrice;
    private BigDecimal paidAmount;
    private String paymentStatus;
    private String notes;
    private LocalDateTime reservationStartTime;
    private LocalDateTime reservationEndTime;
    private String status;
    private LocalDateTime reservation_date;  // Giữ nguyên cho tương thích cũ
    private LocalDateTime reservation_time;  // Giữ nguyên cho tương thích cũ
    
    // NEW: Fields riêng để giữ date/time RIÊNG BIỆT (dùng cho mapping trực tiếp)
    private LocalDate reservationDate;
    private LocalTime reservationTime;

    public Bookings() {
    }

    public Bookings(int bookingId, String bookingCode, Users user, Businesses business, String bookerName,
            String bookerEmail, String bookerPhone, int numGuests, BigDecimal totalPrice,
            BigDecimal paidAmount, String paymentStatus, String notes,
            LocalDateTime reservationStartTime, LocalDateTime reservationEndTime,
            LocalDateTime reservation_date, LocalDateTime reservation_time, String status) {
        this.bookingId = bookingId;
        this.bookingCode = bookingCode;
        this.user = user;
        this.business = business;
        this.bookerName = bookerName;
        this.bookerEmail = bookerEmail;
        this.bookerPhone = bookerPhone;
        this.numGuests = numGuests;
        this.totalPrice = totalPrice;
        this.paidAmount = paidAmount != null ? paidAmount : BigDecimal.ZERO;
        this.paymentStatus = paymentStatus;
        this.notes = notes;
        this.reservationStartTime = reservationStartTime;
        this.reservationEndTime = reservationEndTime;
        this.reservation_date = reservation_date;
        this.reservation_time = reservation_time;
        this.status = status;
        // Auto-sync từ fields cũ sang fields mới
        if (reservation_date != null) this.reservationDate = reservation_date.toLocalDate();
        if (reservation_time != null) this.reservationTime = reservation_time.toLocalTime();
        updateDateTimeFields();  // Sync ngược lại nếu cần
    }

    public Bookings(Users user, Businesses business, String bookerName, String bookerEmail, String bookerPhone,
            int numGuests, BigDecimal totalPrice, LocalDateTime reservation_date, LocalDateTime reservation_time,
            String notes) {
        this.user = user;
        this.business = business;
        this.bookerName = bookerName;
        this.bookerEmail = bookerEmail;
        this.bookerPhone = bookerPhone;
        this.numGuests = numGuests;
        this.totalPrice = totalPrice;
        this.reservation_date = reservation_date;
        this.reservation_time = reservation_time;
        this.notes = notes;
        // Auto-sync
        if (reservation_date != null) this.reservationDate = reservation_date.toLocalDate();
        if (reservation_time != null) this.reservationTime = reservation_time.toLocalTime();
        updateDateTimeFields();
    }

    // Các getters/setters cũ giữ nguyên (bookingId, user, etc.)...
    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public Businesses getBusiness() {
        return business;
    }

    public void setBusiness(Businesses business) {
        this.business = business;
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

    public BigDecimal getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(BigDecimal paidAmount) {
        this.paidAmount = paidAmount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDateTime getReservationStartTime() {
        return reservationStartTime;
    }

    public void setReservationStartTime(LocalDateTime reservationStartTime) {
        this.reservationStartTime = reservationStartTime;
    }

    public LocalDateTime getReservationEndTime() {
        return reservationEndTime;
    }

    public void setReservationEndTime(LocalDateTime reservationEndTime) {
        this.reservationEndTime = reservationEndTime;
    }

    // Getters/Setters cũ cho reservation_date và reservation_time (LocalDateTime) – Giữ nguyên
    public LocalDateTime getReservation_date() {
        return reservation_date;
    }

    public void setReservation_date(LocalDateTime reservation_date) {
        this.reservation_date = reservation_date;
        updateSeparateFields();  // Auto-sync sang fields riêng
    }

    public LocalDateTime getReservation_time() {
        return reservation_time;
    }

    public void setReservation_time(LocalDateTime reservation_time) {
        this.reservation_time = reservation_time;
        updateSeparateFields();  // Auto-sync
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // NEW: Getters/Setters RIÊNG cho date/time (LocalDate/LocalTime) – Dùng cho mapping request/ResultSet
    public LocalDate getReservationDate() {
        return reservationDate;
    }

    public void setReservationDate(LocalDate reservationDate) {
        this.reservationDate = reservationDate;
        updateDateTimeFields();  // Auto-sync sang LocalDateTime fields
    }

    public LocalTime getReservationTime() {
        return reservationTime;
    }

    public void setReservationTime(LocalTime reservationTime) {
        this.reservationTime = reservationTime;
        updateDateTimeFields();  // Auto-sync
    }

    // NEW: Setters ForDB – Nhận LocalDate/LocalTime từ DB và combine vào LocalDateTime (fix lỗi retrieve)
    public void setReservationDateForDB(LocalDate date) {
        this.reservationDate = date;
        // Combine: Set reservation_date = date.atStartOfDay() (date full midnight)
        this.reservation_date = date != null ? date.atStartOfDay() : null;
        updateDateTimeFields();  // Sync nếu cần
    }

    public void setReservationTimeForDB(LocalTime time) {
        this.reservationTime = time;
        // Combine: Set reservation_time = current_date.atTime(time) (time full on today)
        // Sử dụng current date (Nov 06, 2025) hoặc từ reservationDate nếu có
        LocalDate baseDate = (this.reservationDate != null) ? this.reservationDate : LocalDate.now();  // Hoặc hardcode LocalDate.of(2025, 11, 6)
        this.reservation_time = (time != null) ? baseDate.atTime(time) : null;
        updateDateTimeFields();
    }

    // OLD: Getters ForDB – Giữ nguyên cho insert (extract từ LocalDateTime)
    public LocalDate getReservationDateForDB() {
        return reservation_date != null ? reservation_date.toLocalDate() : null;
    }

    public LocalTime getReservationTimeForDB() {
        return reservation_time != null ? reservation_time.toLocalTime() : null;
    }

    // NEW: Helper private – Sync từ fields riêng sang LocalDateTime (khi set riêng)
    private void updateDateTimeFields() {
        if (reservationDate != null && reservationTime != null) {
            LocalDateTime full = reservationDate.atTime(reservationTime);
            this.reservation_date = full;  // Hoặc chỉ date part nếu muốn tách
            this.reservation_time = full;  // Tương tự
        } else if (reservationDate != null) {
            this.reservation_date = reservationDate.atStartOfDay();
        } else if (reservationTime != null) {
            LocalDate baseDate = LocalDate.now();  // Default today (2025-11-06)
            this.reservation_time = baseDate.atTime(reservationTime);
        }
    }

    // NEW: Helper private – Sync từ LocalDateTime sang fields riêng (khi set cũ)
    private void updateSeparateFields() {
        if (reservation_date != null) this.reservationDate = reservation_date.toLocalDate();
        if (reservation_time != null) this.reservationTime = reservation_time.toLocalTime();
    }

    @Override
    public String toString() {
        return "Bookings{"
                + "bookingId=" + bookingId
                + ", bookingCode='" + bookingCode + '\''
                + ", user=" + user
                + ", business=" + business
                + ", bookerName='" + bookerName + '\''
                + ", bookerEmail='" + bookerEmail + '\''
                + ", bookerPhone='" + bookerPhone + '\''
                + ", numGuests=" + numGuests
                + ", totalPrice=" + totalPrice
                + ", paidAmount=" + paidAmount
                + ", paymentStatus='" + paymentStatus + '\''
                + ", notes='" + notes + '\''
                + ", reservationStartTime=" + reservationStartTime
                + ", reservationEndTime=" + reservationEndTime
                + ", reservation_date=" + reservation_date
                + ", reservation_time=" + reservation_time
                + ", reservationDate=" + reservationDate  // NEW: Log fields riêng
                + ", reservationTime=" + reservationTime   // NEW
                + ", status='" + status + '\''
                + '}';
    }
}