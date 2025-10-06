/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
/**
 *
 * @author ADMIN
 */
public class Payments {

    private int paymentId;
    private Bookings booking;
    private BigDecimal amount;
    private String paymentMethod;
    private String status; //('pending','completed','failed','refunded')
    private String transactionCode;
    private String gatewayResponse;
    private LocalDateTime paidAt;
    private LocalDateTime createdAt;

    public Payments() {
    }

    public Payments(int paymentId, Bookings booking, BigDecimal amount, String paymentMethod, String status, String transactionCode, String gatewayResponse, LocalDateTime paidAt, LocalDateTime createdAt) {
        this.paymentId = paymentId;
        this.booking = booking;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.transactionCode = transactionCode;
        this.gatewayResponse = gatewayResponse;
        this.paidAt = paidAt;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public Bookings getBooking() {
        return booking;
    }

    public void setBooking(Bookings booking) {
        this.booking = booking;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTransactionCode() {
        return transactionCode;
    }

    public void setTransactionCode(String transactionCode) {
        this.transactionCode = transactionCode;
    }

    public String getGatewayResponse() {
        return gatewayResponse;
    }

    public void setGatewayResponse(String gatewayResponse) {
        this.gatewayResponse = gatewayResponse;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Payments{" + "paymentId=" + paymentId + ", booking=" + booking + ", amount=" + amount + ", paymentMethod=" + paymentMethod + ", status=" + status + ", transactionCode=" + transactionCode + ", gatewayResponse=" + gatewayResponse + ", paidAt=" + paidAt + ", createdAt=" + createdAt + '}';
    }
}
