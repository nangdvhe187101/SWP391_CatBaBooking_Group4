/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class BusinessesImage {
    private int imageId;
    private int businessId;
    private String imageUrl;

    public BusinessesImage() {
    }

    public BusinessesImage(int imageId, int businessId, String imageUrl) {
        this.imageId = imageId;
        this.businessId = businessId;
        this.imageUrl = imageUrl;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getBusinessId() {
        return businessId;
    }

    public void setBusinessId(int businessId) {
        this.businessId = businessId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "BusinessesImage{" + "imageId=" + imageId + ", businessId=" + businessId + ", imageUrl=" + imageUrl + '}';
    }
    
    
}
