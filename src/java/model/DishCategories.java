/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class DishCategories {

    private int categoryId;
    private Businesses business;
    private String name;
    private Integer displayOrder;

    public DishCategories() {
    }

    public DishCategories(int categoryId, Businesses business, String name, Integer displayOrder) {
        this.categoryId = categoryId;
        this.business = business;
        this.name = name;
        this.displayOrder = displayOrder;
    }

    public DishCategories(int categoryId, String name) {
        this.categoryId = categoryId;
        this.name = name;
        this.displayOrder = 0;
    }

    public DishCategories(Businesses business, String name, Integer displayOrder) {
        this.business = business;
        this.name = name;
        this.displayOrder = displayOrder;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public Businesses getBusiness() {
        return business;
    }

    public void setBusiness(Businesses business) {
        this.business = business;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }

    @Override
    public String toString() {
        return "DishCategories{"
                + "categoryId=" + categoryId
                + ", business=" + business
                + ", name='" + name + '\''
                + ", displayOrder=" + displayOrder
                + '}';
    }
}
