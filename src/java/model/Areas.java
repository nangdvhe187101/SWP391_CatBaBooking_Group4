/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class Areas {

    private int areaId;
    private String name;

    public Areas() {
    }

    public Areas(int areaId, String name) {
        this.areaId = areaId;
        this.name = name;
    }

    // Getters and Setters
    public int getAreaId() {
        return areaId;
    }

    public void setAreaId(int areaId) {
        this.areaId = areaId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Areas{" + "areaId=" + areaId + ", name=" + name + '}';
    }
}
