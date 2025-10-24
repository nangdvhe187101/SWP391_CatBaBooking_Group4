/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;

/**
 *
 * @author ADMIN
 */
public class Dishes {

    private int dishId;
    private Businesses business;
    private DishCategories category;
    private String name;
    private String description;
    private BigDecimal price;
    private String imageUrl;
    private boolean isAvailable;

    public Dishes() {
    }

    public Dishes(int dishId, Businesses business, DishCategories category, String name,
            String description, BigDecimal price, String imageUrl, boolean isAvailable) {
        this.dishId = dishId;
        this.business = business;
        this.category = category;
        this.name = name;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.isAvailable = isAvailable;
    }

    public Dishes(Businesses business, DishCategories category, String name,
            String description, BigDecimal price, String imageUrl, boolean isAvailable) {
        this.business = business;
        this.category = category;
        this.name = name;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.isAvailable = isAvailable;
    }

    public int getDishId() {
        return dishId;
    }

    public void setDishId(int dishId) {
        this.dishId = dishId;
    }

    public Businesses getBusiness() {
        return business;
    }

    public void setBusiness(Businesses business) {
        this.business = business;
    }

    public DishCategories getCategory() {
        return category;
    }

    public void setCategory(DishCategories category) {
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isIsAvailable() {
        return isAvailable;
    }

    public void setIsAvailable(boolean isAvailable) {
        this.isAvailable = isAvailable;
    }

    @Override
    public String toString() {
        return "Dishes{"
                + "dishId=" + dishId
                + ", business=" + business
                + ", category=" + category
                + ", name='" + name + '\''
                + ", description='" + description + '\''
                + ", price=" + price
                + ", imageUrl='" + imageUrl + '\''
                + ", isAvailable=" + isAvailable
                + '}';
    }
}
