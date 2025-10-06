/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class RestaurantTables {

    private int tableId;
    private Businesses business;
    private String name;
    private int capacity;
    private boolean isActive;

    public RestaurantTables() {
    }

    public RestaurantTables(int tableId, Businesses business, String name, int capacity, boolean isActive) {
        this.tableId = tableId;
        this.business = business;
        this.name = name;
        this.capacity = capacity;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getTableId() {
        return tableId;
    }

    public void setTableId(int tableId) {
        this.tableId = tableId;
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

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "RestaurantTables{" + "tableId=" + tableId + ", business=" + business + ", name='" + name + '\'' + ", capacity=" + capacity + ", isActive=" + isActive + '}';
    }
}
