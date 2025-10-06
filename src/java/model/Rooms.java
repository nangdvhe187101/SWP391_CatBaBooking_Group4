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
public class Rooms {

    private int roomId;
    private Businesses business;
    private String name;
    private int capacity;
    private BigDecimal pricePerNight;
    private boolean isActive;

    public Rooms() {
    }

    public Rooms(int roomId, Businesses business, String name, int capacity, BigDecimal pricePerNight, boolean isActive) {
        this.roomId = roomId;
        this.business = business;
        this.name = name;
        this.capacity = capacity;
        this.pricePerNight = pricePerNight;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public Businesses getBusiness() {
        return business;
    }

    public void setBusiness(Businesses business) {
        this.business = business;
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

    public BigDecimal getPricePerNight() {
        return pricePerNight;
    }

    public void setPricePerNight(BigDecimal pricePerNight) {
        this.pricePerNight = pricePerNight;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "Rooms{" + "roomId=" + roomId + ", business=" + business + ", name='" + name + '\'' + ", capacity=" + capacity + ", pricePerNight=" + pricePerNight + ", isActive=" + isActive + '}';
    }
}
