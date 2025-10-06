/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 *
 * @author ADMIN
 */
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
    private String paymentStatus; // ENUM('unpaid','partially_paid','fully_paid','refunded')
    private String notes;
    private LocalDateTime reservationStartTime;
    private LocalDateTime reservationEndTime;
    private String status; // ENUM('pending','confirmed','cancelled_by_user','cancelled_by_owner','completed','no_show')

    public Bookings() {
    }

    public Bookings(int bookingId, String bookingCode, Users user, Businesses business, String bookerName, String bookerEmail, String bookerPhone, int numGuests, BigDecimal totalPrice, BigDecimal paidAmount, String paymentStatus, String notes, LocalDateTime reservationStartTime, LocalDateTime reservationEndTime, String status) {
        this.bookingId = bookingId;
        this.bookingCode = bookingCode;
        this.user = user;
        this.business = business;
        this.bookerName = bookerName;
        this.bookerEmail = bookerEmail;
        this.bookerPhone = bookerPhone;
        this.numGuests = numGuests;
        this.totalPrice = totalPrice;
        this.paidAmount = paidAmount;
        this.paymentStatus = paymentStatus;
        this.notes = notes;
        this.reservationStartTime = reservationStartTime;
        this.reservationEndTime = reservationEndTime;
        this.status = status;
    }

    // Getters and Setters
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Bookings{" + "bookingId=" + bookingId + ", bookingCode=" + bookingCode + ", user=" + user + ", business=" + business + ", bookerName=" + bookerName + ", bookerEmail=" + bookerEmail + ", bookerPhone=" + bookerPhone + ", numGuests=" + numGuests + ", totalPrice=" + totalPrice + ", paidAmount=" + paidAmount + ", paymentStatus=" + paymentStatus + ", notes=" + notes + ", reservationStartTime=" + reservationStartTime + ", reservationEndTime=" + reservationEndTime + ", status=" + status + '}';
    }
}
