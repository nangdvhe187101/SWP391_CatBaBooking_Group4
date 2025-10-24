/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;

/**
 *
 * @author ADMIN
 */
public class BookingDishes {

    private int bookingDishId;
    private Bookings booking;
    private Dishes dish;
    private int quantity;
    private BigDecimal priceAtBooking;
    private String notes;

    public BookingDishes() {
    }

    public BookingDishes(int bookingDishId, Bookings booking, Dishes dish, int quantity,
            BigDecimal priceAtBooking, String notes) {
        this.bookingDishId = bookingDishId;
        this.booking = booking;
        this.dish = dish;
        this.quantity = quantity;
        this.priceAtBooking = priceAtBooking;
        this.notes = notes;
    }

    public BookingDishes(Bookings booking, Dishes dish, int quantity,
            BigDecimal priceAtBooking, String notes) {
        this.booking = booking;
        this.dish = dish;
        this.quantity = quantity;
        this.priceAtBooking = priceAtBooking;
        this.notes = notes;
    }

    public int getBookingDishId() {
        return bookingDishId;
    }

    public void setBookingDishId(int bookingDishId) {
        this.bookingDishId = bookingDishId;
    }

    public Bookings getBooking() {
        return booking;
    }

    public void setBooking(Bookings booking) {
        this.booking = booking;
    }

    public Dishes getDish() {
        return dish;
    }

    public void setDish(Dishes dish) {
        this.dish = dish;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPriceAtBooking() {
        return priceAtBooking;
    }

    public void setPriceAtBooking(BigDecimal priceAtBooking) {
        this.priceAtBooking = priceAtBooking;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    @Override
    public String toString() {
        return "BookingDishes{"
                + "bookingDishId=" + bookingDishId
                + ", booking=" + booking
                + ", dish=" + dish
                + ", quantity=" + quantity
                + ", priceAtBooking=" + priceAtBooking
                + ", notes='" + notes + '\''
                + '}';
    }
}
