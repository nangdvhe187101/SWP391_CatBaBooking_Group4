/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 *
 * @author ADMIN
 */
public class RoomAvailability {

    private long availabilityId;
    private Rooms room;
    private LocalDate date;
    private BigDecimal price;
    private String status; // ENUM('available','booked','blocked')

    public RoomAvailability() {
    }

    public RoomAvailability(long availabilityId, Rooms room, LocalDate date, BigDecimal price, String status) {
        this.availabilityId = availabilityId;
        this.room = room;
        this.date = date;
        this.price = price;
        this.status = status;
    }

    // Getters and Setters
    public long getAvailabilityId() {
        return availabilityId;
    }

    public void setAvailabilityId(long availabilityId) {
        this.availabilityId = availabilityId;
    }

    public Rooms getRoom() {
        return room;
    }

    public void setRoom(Rooms room) {
        this.room = room;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "RoomAvailability{" + "availabilityId=" + availabilityId + ", room=" + room + ", date=" + date + ", price=" + price + ", status='" + status + '\'' + '}';
    }
}
