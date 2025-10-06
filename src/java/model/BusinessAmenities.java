/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class BusinessAmenities {

    private Businesses business;
    private Amenities amenity;

    public BusinessAmenities() {
    }

    public BusinessAmenities(Businesses business, Amenities amenity) {
        this.business = business;
        this.amenity = amenity;
    }

    // Getters and Setters
    public Businesses getBusiness() {
        return business;
    }

    public void setBusiness(Businesses business) {
        this.business = business;
    }

    public Amenities getAmenity() {
        return amenity;
    }

    public void setAmenity(Amenities amenity) {
        this.amenity = amenity;
    }

    @Override
    public String toString() {
        return "BusinessAmenities{" + "business=" + business + ", amenity=" + amenity + '}';
    }
}
