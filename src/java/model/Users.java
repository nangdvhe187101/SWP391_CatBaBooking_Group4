/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author ADMIN
 */
public class Users {
    private int userId;
    private Roles role;
    private String fullName;
    private String email;
    private String passwordHash;
    private String phone;
    private String citizenId;
    private String personalAddress;
    private String city;
    private String gender;
    private Integer birthDay;
    private Integer birthMonth;
    private Integer birthYear;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Businesses business;

    public Businesses getBusiness() {
        return business;
    }

    public void setBusiness(Businesses business) {
        this.business = business;
    }

    public Users() {
    }

    public Users(int userId, Roles role, String fullName, String email, String passwordHash, String phone, String citizenId,
            String personalAddress, String status, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.userId = userId;
        this.role = role;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.citizenId = citizenId;
        this.personalAddress = personalAddress;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    public Users(Roles role, String fullName, String email, String passwordHash,
                String phone, String citizenId, String personalAddress, String status) {
        this.role = role;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.citizenId = citizenId;
        this.personalAddress = personalAddress;
        this.status = status;
    }

    public Users(int userId, Roles role, String fullName, String email, String passwordHash, String phone,
            String citizenId, String personalAddress, String status, LocalDateTime createdAt, LocalDateTime updatedAt,
            String city, String gender, Integer birthDay, Integer birthMonth, Integer birthYear) {
        this(userId, role, fullName, email, passwordHash, phone, citizenId, personalAddress, status, createdAt, updatedAt);
        this.city = city;
        this.gender = gender;
        this.birthDay = birthDay;
        this.birthMonth = birthMonth;
        this.birthYear = birthYear;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Roles getRole() {
        return role;
    }

    public void setRole(Roles role) {
        this.role = role;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(String citizenId) {
        this.citizenId = citizenId;
    }

    public String getPersonalAddress() {
        return personalAddress;
    }

    public void setPersonalAddress(String personalAddress) {
        this.personalAddress = personalAddress;
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

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Integer getBirthDay() {
        return birthDay;
    }

    public void setBirthDay(Integer birthDay) {
        this.birthDay = birthDay;
    }

    public Integer getBirthMonth() {
        return birthMonth;
    }

    public void setBirthMonth(Integer birthMonth) {
        this.birthMonth = birthMonth;
    }

    public Integer getBirthYear() {
        return birthYear;
    }

    public void setBirthYear(Integer birthYear) {
        this.birthYear = birthYear;
    }

    @Override
    public String toString() {
        return "users{" + "userId=" + userId + ", role=" + role + ", fullName=" + fullName + ", email=" + email
                + ", passwordHash=" + passwordHash + ", phone=" + phone + ", citizenId=" + citizenId
                + ", personalAddress=" + personalAddress + ", city=" + city + ", gender=" + gender
                + ", birthDay=" + birthDay + ", birthMonth=" + birthMonth + ", birthYear=" + birthYear
                + ", status=" + status + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }
    
}
