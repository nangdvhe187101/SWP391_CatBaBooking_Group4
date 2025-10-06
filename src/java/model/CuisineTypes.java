/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class CuisineTypes {

    private int cuisineId;
    private String name;

    public CuisineTypes() {
    }

    public CuisineTypes(int cuisineId, String name) {
        this.cuisineId = cuisineId;
        this.name = name;
    }

    // Getters and Setters
    public int getCuisineId() {
        return cuisineId;
    }

    public void setCuisineId(int cuisineId) {
        this.cuisineId = cuisineId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "CuisineTypes{" + "cuisineId=" + cuisineId + ", name='" + name + '\'' + '}';
    }
}
