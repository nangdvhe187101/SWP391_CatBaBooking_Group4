/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class RestaurantTypes {

    private int typeId;
    private String name;

    public RestaurantTypes() {
    }

    public RestaurantTypes(int typeId, String name) {
        this.typeId = typeId;
        this.name = name;
    }

    // Getters and Setters
    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "RestaurantTypes{" + "typeId=" + typeId + ", name='" + name + '\'' + '}';
    }
}
