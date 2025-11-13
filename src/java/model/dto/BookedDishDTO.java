/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

import java.math.BigDecimal;

/**
 *
 * @author Admin
 */
public class BookedDishDTO {
    private String dishName;
    private int quantity;
    private BigDecimal priceAtBooking;
    private String notes;

    public BookedDishDTO() {
    }

    public BookedDishDTO(String dishName, int quantity, BigDecimal priceAtBooking, String notes) {
        this.dishName = dishName;
        this.quantity = quantity;
        this.priceAtBooking = priceAtBooking;
        this.notes = notes;
    }

    public String getDishName() {
        return dishName;
    }

    public void setDishName(String dishName) {
        this.dishName = dishName;
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
    
    
}
