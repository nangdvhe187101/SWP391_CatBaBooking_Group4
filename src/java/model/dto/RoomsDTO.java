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
public class RoomsDTO {
    private int roomId;
    private int businessId;
    private String name;
    private int capacity;
    private BigDecimal price;
    private boolean isActive;

    public RoomsDTO() {
    }

    public RoomsDTO(int roomId, int businessId, String name, int capacity, BigDecimal price, boolean isActive) {
        this.roomId = roomId;
        this.businessId = businessId;
        this.name = name;
        this.capacity = capacity;
        this.price = price;
        this.isActive = isActive;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getBusinessId() {
        return businessId;
    }

    public void setBusinessId(int businessId) {
        this.businessId = businessId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    
}
