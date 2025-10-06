/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class Amenities {

    private int amenityId;
    private String name;

    public Amenities() {
    }

    public Amenities(int amenityId, String name) {
        this.amenityId = amenityId;
        this.name = name;
    }

    // Getters and Setters
    public int getAmenityId() {
        return amenityId;
    }

    public void setAmenityId(int amenityId) {
        this.amenityId = amenityId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Amenities{" + "amenityId=" + amenityId + ", name='" + name + '\'' + '}';
    }
}
