/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class Occasions {

    private int occasionId;
    private String name;

    public Occasions() {
    }

    public Occasions(int occasionId, String name) {
        this.occasionId = occasionId;
        this.name = name;
    }

    // Getters and Setters
    public int getOccasionId() {
        return occasionId;
    }

    public void setOccasionId(int occasionId) {
        this.occasionId = occasionId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Occasions{" + "occasionId=" + occasionId + ", name='" + name + '\'' + '}';
    }
}
