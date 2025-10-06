/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class BusinessCuisines {

    private Businesses business;
    private CuisineTypes cuisine;

    public BusinessCuisines() {
    }

    public BusinessCuisines(Businesses business, CuisineTypes cuisine) {
        this.business = business;
        this.cuisine = cuisine;
    }

    // Getters and Setters
    public Businesses getBusiness() {
        return business;
    }

    public void setBusiness(Businesses business) {
        this.business = business;
    }

    public CuisineTypes getCuisine() {
        return cuisine;
    }

    public void setCuisine(CuisineTypes cuisine) {
        this.cuisine = cuisine;
    }

    @Override
    public String toString() {
        return "BusinessCuisines{" + "business=" + business + ", cuisine=" + cuisine + '}';
    }
}
