/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 *
 * @author ADMIN
 */
public class TableAvailability {

    private long availabilityId;
    private RestaurantTables table;
    private LocalDate reservationDate;
    private LocalTime reservationTime;
    private String status; // ENUM('available','booked','blocked')

    public TableAvailability() {
    }

    public TableAvailability(long availabilityId, RestaurantTables table, LocalDate reservationDate, LocalTime reservationTime, String status) {
        this.availabilityId = availabilityId;
        this.table = table;
        this.reservationDate = reservationDate;
        this.reservationTime = reservationTime;
        this.status = status;
    }

    // Getters and Setters
    public long getAvailabilityId() {
        return availabilityId;
    }

    public void setAvailabilityId(long availabilityId) {
        this.availabilityId = availabilityId;
    }

    public RestaurantTables getTable() {
        return table;
    }

    public void setTable(RestaurantTables table) {
        this.table = table;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "TableAvailability{" + "availabilityId=" + availabilityId + ", table=" + table + ", reservationDate=" + reservationDate + ", reservationTime=" + reservationTime + ", status='" + status + '\'' + '}';
    }
}
