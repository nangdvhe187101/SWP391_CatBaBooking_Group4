/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class BusinessRestaurantTypes {

    private Businesses business;
    private RestaurantTypes restaurantType;

    public BusinessRestaurantTypes() {
    }

    public BusinessRestaurantTypes(Businesses business, RestaurantTypes restaurantType) {
        this.business = business;
        this.restaurantType = restaurantType;
    }

    // Getters and Setters
    public Businesses getBusiness() {
        return business;
    }

    public void setBusiness(Businesses business) {
        this.business = business;
    }

    public RestaurantTypes getRestaurantType() {
        return restaurantType;
    }

    public void setRestaurantType(RestaurantTypes restaurantType) {
        this.restaurantType = restaurantType;
    }

    @Override
    public String toString() {
        return "BusinessRestaurantTypes{" + "business=" + business + ", restaurantType=" + restaurantType + '}';
    }
}
