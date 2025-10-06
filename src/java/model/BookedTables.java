/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class BookedTables {

    private int bookedTableId;
    private Bookings booking;
    private RestaurantTables table;

    public BookedTables() {
    }

    public BookedTables(int bookedTableId, Bookings booking, RestaurantTables table) {
        this.bookedTableId = bookedTableId;
        this.booking = booking;
        this.table = table;
    }

    // Getters and Setters
    public int getBookedTableId() {
        return bookedTableId;
    }

    public void setBookedTableId(int bookedTableId) {
        this.bookedTableId = bookedTableId;
    }

    public Bookings getBooking() {
        return booking;
    }

    public void setBooking(Bookings booking) {
        this.booking = booking;
    }

    public RestaurantTables getTable() {
        return table;
    }

    public void setTable(RestaurantTables table) {
        this.table = table;
    }

    @Override
    public String toString() {
        return "BookedTables{" + "bookedTableId=" + bookedTableId + ", booking=" + booking + ", table=" + table + '}';
    }
}
