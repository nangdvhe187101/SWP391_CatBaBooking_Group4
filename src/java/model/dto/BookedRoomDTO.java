/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dto;

import model.BookedRooms;

/**
 *
 * @author jackd
 */
public class BookedRoomDTO extends BookedRooms {
    
    private String roomName;

    public BookedRoomDTO() {
        super();
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }
}
