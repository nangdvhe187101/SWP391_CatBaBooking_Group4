/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import model.Areas;
import model.Users;

/**
 *
 * @author Admin
 */
public class BusinessesDTO {

    private int businessId;
    private Users owner;
    private String name;
    private String type; //('homestay','restaurant')
    private String address;
    private String description;
    private String image;
    private Areas area;
    private BigDecimal avgRating;
    private int reviewCount;
    private Integer capacity;
    private String status; //('active','pending','rejected')
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalTime openingHour;
    private LocalTime closingHour;
    private List<String> cuisines;

    public BusinessesDTO() {
    }

    public BusinessesDTO(int businessId, Users owner, String name, String type, String address, String description, String image, Areas area, BigDecimal avgRating, int reviewCount, Integer capacity, String status, LocalDateTime createdAt, LocalDateTime updatedAt, LocalTime openingHour, LocalTime closingHour, List<String> cuisines) {
        this.businessId = businessId;
        this.owner = owner;
        this.name = name;
        this.type = type;
        this.address = address;
        this.description = description;
        this.image = image;
        this.area = area;
        this.avgRating = avgRating;
        this.reviewCount = reviewCount;
        this.capacity = capacity;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.openingHour = openingHour;
        this.closingHour = closingHour;
        this.cuisines = cuisines;
    }

    public int getBusinessId() {
        return businessId;
    }

    public void setBusinessId(int businessId) {
        this.businessId = businessId;
    }

    public Users getOwner() {
        return owner;
    }

    public void setOwner(Users owner) {
        this.owner = owner;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Areas getArea() {
        return area;
    }

    public void setArea(Areas area) {
        this.area = area;
    }

    public BigDecimal getAvgRating() {
        return avgRating;
    }

    public void setAvgRating(BigDecimal avgRating) {
        this.avgRating = avgRating;
    }

    public int getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
    }

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalTime getOpeningHour() {
        return openingHour;
    }

    public void setOpeningHour(LocalTime openingHour) {
        this.openingHour = openingHour;
    }

    public LocalTime getClosingHour() {
        return closingHour;
    }

    public void setClosingHour(LocalTime closingHour) {
        this.closingHour = closingHour;
    }

    public List<String> getCuisines() {
        return cuisines;
    }

    public void setCuisines(List<String> cuisines) {
        this.cuisines = cuisines;
    }

    
}
