package com.travelo.dao;

import com.travelo.model.Booking;
import com.travelo.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BookingDao {

    public boolean createBooking(int userId, String type, int referenceId, double totalPrice) {
        String sql = "INSERT INTO bookings (user_id, booking_type, reference_id, total_price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, userId);
            ps.setString(2, type);
            ps.setInt(3, referenceId);
            ps.setDouble(4, totalPrice);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Booking> getUserBookings(int userId) {
        List<Booking> list = new ArrayList<>();
        // Query that attempts to get the name from packages or hotels based on type
        String sql = "SELECT b.*, " +
                     "CASE WHEN b.booking_type = 'PACKAGE' THEN p.destination " +
                     "     WHEN b.booking_type = 'HOTEL' THEN h.name " +
                     "END as item_name " +
                     "FROM bookings b " +
                     "LEFT JOIN packages p ON b.booking_type = 'PACKAGE' AND b.reference_id = p.id " +
                     "LEFT JOIN hotels h ON b.booking_type = 'HOTEL' AND b.reference_id = h.id " +
                     "WHERE b.user_id = ? ORDER BY b.booking_date DESC";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setBookingType(rs.getString("booking_type"));
                    b.setReferenceId(rs.getInt("reference_id"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setBookingDate(rs.getTimestamp("booking_date"));
                    b.setStatus(rs.getString("status"));
                    b.setItemName(rs.getString("item_name"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean cancelBooking(int bookingId, int userId) {
        String sql = "UPDATE bookings SET status = 'CANCELLED' WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
