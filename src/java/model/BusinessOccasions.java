/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class BusinessOccasions {

    private Businesses business;
    private Occasions occasion;

    public BusinessOccasions() {
    }

    public BusinessOccasions(Businesses business, Occasions occasion) {
        this.business = business;
        this.occasion = occasion;
    }

    // Getters and Setters
    public Businesses getBusiness() {
        return business;
    }

    public void setBusiness(Businesses business) {
        this.business = business;
    }

    public Occasions getOccasion() {
        return occasion;
    }

    public void setOccasion(Occasions occasion) {
        this.occasion = occasion;
    }

    @Override
    public String toString() {
        return "BusinessOccasions{" + "business=" + business + ", occasion=" + occasion + '}';
    }
}
