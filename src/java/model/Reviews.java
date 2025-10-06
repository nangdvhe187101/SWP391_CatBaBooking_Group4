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
public class Reviews {

    private int reviewId;
    private Bookings booking;
    private Businesses business;
    private Users user;
    private byte rating;
    private String comment;
    private LocalDateTime createdAt;

    public Reviews() {
    }

    public Reviews(int reviewId, Bookings booking, Businesses business, Users user, byte rating, String comment, LocalDateTime createdAt) {
        this.reviewId = reviewId;
        this.booking = booking;
        this.business = business;
        this.user = user;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public Bookings getBooking() {
        return booking;
    }

    public void setBooking(Bookings booking) {
        this.booking = booking;
    }

    public Businesses getBusiness() {
        return business;
    }

    public void setBusiness(Businesses business) {
        this.business = business;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public byte getRating() {
        return rating;
    }

    public void setRating(byte rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Reviews{" + "reviewId=" + reviewId + ", booking=" + booking + ", business=" + business + ", user=" + user + ", rating=" + rating + ", comment='" + comment + '\'' + ", createdAt=" + createdAt + '}';
    }
}
