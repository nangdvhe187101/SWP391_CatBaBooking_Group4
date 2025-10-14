/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class RoomsImage {
    private int imageId;
    private int roomId;
    private String imageUrl;

    public RoomsImage() {
    }

    public RoomsImage(int imageId, int roomId, String imageUrl) {
        this.imageId = imageId;
        this.roomId = roomId;
        this.imageUrl = imageUrl;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "RoomsImage{" + "imageId=" + imageId + ", roomId=" + roomId + ", imageUrl=" + imageUrl + '}';
    }
    
    
}
