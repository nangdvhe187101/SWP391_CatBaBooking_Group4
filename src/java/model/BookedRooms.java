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
public class BookedRooms {

    private int bookedRoomId;
    private Bookings booking;
    private Rooms room;
    private BigDecimal priceAtBooking;

    public BookedRooms() {
    }

    public BookedRooms(int bookedRoomId, Bookings booking, Rooms room, BigDecimal priceAtBooking) {
        this.bookedRoomId = bookedRoomId;
        this.booking = booking;
        this.room = room;
        this.priceAtBooking = priceAtBooking;
    }

    // Getters and Setters
    public int getBookedRoomId() {
        return bookedRoomId;
    }

    public void setBookedRoomId(int bookedRoomId) {
        this.bookedRoomId = bookedRoomId;
    }

    public Bookings getBooking() {
        return booking;
    }

    public void setBooking(Bookings booking) {
        this.booking = booking;
    }

    public Rooms getRoom() {
        return room;
    }

    public void setRoom(Rooms room) {
        this.room = room;
    }

    public BigDecimal getPriceAtBooking() {
        return priceAtBooking;
    }

    public void setPriceAtBooking(BigDecimal priceAtBooking) {
        this.priceAtBooking = priceAtBooking;
    }

    @Override
    public String toString() {
        return "BookedRooms{" + "bookedRoomId=" + bookedRoomId + ", booking=" + booking + ", room=" + room + ", priceAtBooking=" + priceAtBooking + '}';
    }
}
